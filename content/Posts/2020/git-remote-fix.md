---
title: "A New Site Design Using Hugo"
date: 2020-10-18T00:40:53-04:00
draft: false
#summary: All about this blog redesign...
---

I've recently redesigned this blog using a static site generator, Hugo.  Hugo is a command-line utility written in the Go programming language that will generate a static web-site (html and css files) from a collection of text files and some pre-defined themes.  [You can read more about Static Site Generators in this article from 2015](https://www.smashingmagazine.com/2015/11/modern-static-website-generators-next-big-thing/).

So, why bother?  These are a few reasons I've made the jump:

* It's something new to learn and experiment with.

* This blog isn't updated very often.  In all honesty I don't need the bloat of wordpress to manage such a small personal blog.

* Static sites present a smaller exposure footprint for security issues.

* Statically generated sites are generally more efficient than a dynamic wordpress site. They load faster and uses less server resources.

* Static sites can easily scale to a CDN if needed.  They're just static HTML and CSS files which can be stored just about anywhere.

* I no longer will have to wrangle my data out of a database system if I want to change providers.  My site can be ported anywhere with a few keystrokes.

* The presentation is decoupled from the content.  Presentation is managed by a site theme, which contains a config file and the HTML/JS and CSS templates that will be used to generate the site.

* The content resides in markdown text files in a `hugo-site/content/` folder.  This means I can use my favorite text editors to manage my content.

* I can use git to manage my web-site. The site's "source-code" resides in a git repo and can be synced between devices.  This lets me edit from any device that has git installed.  And I can download and generate the site from any device with Hugo installed.  This lets me utilize all the goodies that git provides such as file history, [feature] branching, bisect, merging, submodules, etc.

* The build and deployment of the website can be easily automated (aka continuous integration, or CI) such that a git push to your server can also serve to deploy the most recent build.

### My Deploy Solution

My chosen deployment method does not use continuous integration.  Instead, I've created a simple batch script named _deploy.bat_ and placed it in the root of my repo.  This file contains a simple set of commands that will build the static site pages and css with Hugo, and then rsync that generated content to my server.  All of this by running the `./deploy` command from the `hugo-site/` directory.

#### deploy.bat file example

``` BATCH
echo off

SET /p user="Enter User Name:"
SET host=http:\\www.enter-your-server-here.com
SET publicDest=~/public_html/path-to-your-new-website/

REM run the hugo command to build your static site's files...
hugo

SET publicSource=public/
if not exist %publicSource% goto :end

REM rsync to your server.  Having SSH keys makes this much simpler.  The options below will keep the files in sync on the server, and delete any not found locally.  It will also change permissions on the server files so they are accessible by everyone.
rsync -azvu --delete %publicSource% %user%@%host%:%publicDest% --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r

:end
echo on
```

### CPanel Automatic Deployments

There is another method to deploy your website by using CI with CPanel; you `git push` to a remote repo on your web-server and CPanel will fire a post-receive githook script.  This script can be configured to run whatever commands you want.  A typical deploy config would be to locally rsync from your `hugo-site/public/` folder to your `~/public_html/web-site/` directory.  This is a pretty simple way to deploy your site.

This was the first method I'd played around with when I was getting all of this set-up.  I eventually decided to forgo this method, mostly because I wanted to quickly deploy different versions of my site to different locations for A/B testing, but also because I didn't want to track the `hugo-site/public/` folder into my github repo.

If you do choose this deploy method, there are a few things to note, which is why I'm including this section. For this to work CPanel requires that you create a github repository through CPanel's web-interface.  This is simple enough, but there you may run into a snag when you try to push your local repo to remote via ssh.  You may get an error: `fatal: bad config value for 'receive.denycurrentbranch' in ./config"`.

The fix for it was [simple](https://stackoverflow.com/questions/56990207/fatal-bad-config-value-for-receive-denycurrentbranch-in-config) after you realize what's going on:
there may be more than one version of git installed in your web-hosting environment.  (E.g. usually an older system-wide git in `/usr/bin/` and a newer version installed elsewhere for cpanel.)  The one that is being tapped to run the git interaction from the ssh user is the old one, which causes the error; you need to point to the newer version of git (or get your hosting provider to upgrade git on the server).

#### Steps to enable CPanel automatic deploys:

1. Create the remote repo via cpanel interface

2. From the manage tab in CPanel git repo, select the branch that you'd like to use for deployments.  When you push this branch, the deployment script will run.  You can deploy multiple branches, but as far as I know, you have to change the checked out branch through CPanel's interface (you may be able to do it through the CLI by SSHing into the server as well, I haven't tested this myself).

3. Add the repo location as an origin to your local repo

4. From your local repo perform a test push to your origin. If this push fails with the error : _fatal: bad config value for 'receive.denycurrentbranch' in ./config_, you will have to fix it like so...

  * SSH into your server and run `which git-receive-pack`

  * Note the location returned...

  * Run the following command in the *local* repo:

``` BATCH
git config remote.origin.receivepack /path/on/the/server/to/the/git-receive-pack
```

5. Create a .cpanel.yml file in the root of your repo.  This is where you will enter the shell commands to deploy your site.  Cpanel will run these commands during the deployment.

#### Example .cpanel.yml file:

``` YAML
---
deployment:
  tasks:
    - rsync -a --delete public/ ~/public_html/path-to-your-new-static-site
```