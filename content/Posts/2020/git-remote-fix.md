---
title: "A New Site Design Using Hugo"
date: 2020-10-18T00:40:53-04:00
draft: false
summary: All about this blog redesign...
---

I've recently redesigned this blog using a static site generator, Hugo.  Hugo is a command-line utility written in the Go programming language that will allow you to generate a static web-site (html and css files) from markdown text files and some pre-defined templates/themes

To channel someone I used to work with: _Okay... why bother?  Doesn't Wordpress do everything you need and more? Why muck around with something that sounds complicated?_

* It's something new to try out and learn about.  I don't always get time to devote to side projects, and heaven knows I don't update this blog much, but I enjoy playing with various web technologies.  The current static site generators are a reaction against the largely unneeded bloat of popular content management systems. (JAMStack is another term for this particular combination of technologies, a term coined by Netlify).  [You can read more about Static Site Generators in this article from 2015](https://www.smashingmagazine.com/2015/11/modern-static-website-generators-next-big-thing/).

* I don't really need a full blown wordpress install to manage this small personal blog.

* Furthermore, I don't visit the wordpress admin panel very much; apparently I've been behind on wordpress updates for years.  Whoopsie.  This poses potential security risks, as well as the possibility of something breaking if my hosting provider updates a dependency in the background.

* Even without the upgrade issue pointed out above, having a wordpress install presents more security concerns than simple, static web-pages.  With a static site, the security exposure footprint is much lower.  I guarantee you won't suffer SQL injection attacks with no SQL database.

* Likewise, a statically generated site is generally more efficient than a dynamic wordpress site; the thing should run faster and it's less processor/resource intensive.

* If needed, it can scale to a CDN or larger web-hosting provider with ease.  They're just static HTML and CSS files served up; they can be stored just about anywhere.

* Continuing this point, I'm not tied to a single hosting provider.  I don't have to wrangle my data out of a system or export from a database.  My site can be ported anywhere with a few keystrokes. Indeed, I plan on looking for a new hosting solution early this coming year to save on hosting costs.

* The presentation is [mostly] decoupled from the content.  Presentation is managed by a site theme, which contains a config file and the HTML/JS and CSS templates that will be used to generate the site.

* The content resides in markdown text files in a /content/ folder.  It can't get much simpler than that.  Migrating the site to a new theme or location is pretty simple; and the posts themselves are all in text files that can be migrated wherever you desire.  I also can use my favorite text editors to manage my content; this is fantastic when editing markdown, code, mathjax formulas, etc.

* Using a static site generator allows you to use git (or another SCM) to effectively manage your web-site. Since the content is mostly markdown files, you can throw the whole thing in a git repo and sync it between your devices, as well as utilize all the goodies that git provides (such as branching, merging, etc).

* The build and deployment of your website can be easily automated (aka continuous integration, or CI) such that a git push to your server can also serve to deploy the most recent build.  This can be accomplished a variety of ways.

### My Deploy Solution

My chosen deployment method does not use CI.  I've created a simple batch script named _deploy.bat_ and placed it in the root of my repo.  This file contains a simple set of commands that will build the static site pages and css, and then rsync the generated content to my server.  I trigger this by running ```deploy``` from the hugo-site/ directory.

#### deploy.bat file example

``` BATCH
echo off

SET /p user="Enter User Name:"
SET host=enter-your-server-here.com
SET publicDest=~/public_html/path-to-your-new-website/

REM run the hugo command to build your static site files...
hugo

SET publicSource=public/
if not exist %publicSource% goto :end

REM rsync to your server.  Having SSH keys makes this much simpler.  The options below will keep the files in sync on the server, and delete any not found locally.  It will also change permissions on the server files so they are accessible by everyone.
rsync -azvu --delete %publicSource% %user%@%host%:%publicDest% --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r

:end
echo on
```

### CPanel Automatic Deployments

You can also configure cpanel to automatically deploy your web-site when you _git push_ to a git repo on your server.  When you _git push_ to the cpanel git repo, cpanel will automatically fire a post-receive githook script.  You can embed whatever shell commands you want into this script.  A typical deploy config would be to locally rsync from your hugo-site/public/ folder to your ~/public_html/web-site/ directory.  This is a pretty simple way to deploy your site.

However, for this to work cpanel requires that you create a github repository through its interface.  This is simple enough, but there you may run into a snag when you try to push your local repo to the new cpanel repo through an ssh connection.  You may get an error: "fatal: bad config value for 'receive.denycurrentbranch' in ./config".

The fix for it was [simple](https://stackoverflow.com/questions/56990207/fatal-bad-config-value-for-receive-denycurrentbranch-in-config) after you realize what's going on.
There are sometimes more than one version of git installed in your web-hosting environment.  (E.g. a usually older system-wide git in /usr/bin/ and a newer version installed elsewhere for cpanel.)  The one that is being tapped to run the git interaction from the ssh user is the old one, which causes the error; you need to point to the right version of git (or get your hosting provider to upgrade git on the server).

#### Steps to enable CPanel automatic deploys:

* Create the remote repo via cpanel interface

* From the manage tab in CPanel git repo, select the branch that you'd like to use for deployments.  When you push this branch, the deployment script will run.  You can deploy multiple branches, but as far as I know, you have to change the checked out branch through CPanel's interface (you may be able to do it through the CLI by SSHing into the server as well.)  This is why I've chosen to use a different deployment strategy for my sites, mostly for A/B testing different branches.

* Add the repo location as an origin to your local repo

* From your local repo perform a test push to your origin. If it fails with the error above, you will have to fix it like so...

  * SSH into your server and run `which git-receive-pack`

  * Note the location returned...

  * Run the following command in the *local* repo:

```
git config remote.origin.receivepack /path/on/the/server/to/the/git-receive-pack
```

* Create a .cpanel.yml file in the root of your repo.  This is where you will enter the shell commands to deploy your site.  Cpanel will run these commands during the deployment.

#### Example .cpanel.yml file:

```
---
deployment:
  tasks:
    - rsync -a --delete public/ ~/public_html/path-to-your-new-static-site
```