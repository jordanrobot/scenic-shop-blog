---
title: "New Hugo Web Site."
date: 2020-10-18T00:40:53-04:00
draft: false
---

I've recently redesigned this website & blog using a static site generator, Hugo.  Hugo is a command-line utility written in the Go programming lanagauge that will allow you to generate a static web-site (html and css files) from markdown text files and some pre-defined templates/themes.

To channel someone I used to work with: _Okay... why bother?  Doesn't Wordpress do everything you need an more? Why muck around with something that sounds complicated?_

* It's something new to try out and learn about.  I don't always get time to devote to side projects, and heaven knows I don't update this blog much, but I enjoy keeping abrest of some current web technologies.  Static Site Generators are the "new" hotness for creating simple web-pages (JAMStack is another term for this particular combination of technologies).
* As mentioned above, I have not been updating this site very much.  It's been years since I last wrote a post.  I don't really need a full blown wordpress install to manage this blog.
* Furthermore, since I'm not updating that often, I don't visit the wordpress admin panel very much.  I've been behind on wordpress updates for years.  This poses potential security risks, as well as the possibility of something breaking if my hosting provider updates a depency.
* Even without the upgrade issue pointed out above, having a wordpress install presents more security concerns thatn simple, static html pages.  With a static web site, the footprint of security of exposure is much lower.  You can't have sql injection attacks if you're not using a SQL database on the backend.
* Likewise, a statically generated site is generally more efficient than a dynamic wordpress site; the thing should run faster and it's less processor/resource intensive.
* If needed, it can scale to a CDN or larger web-hosting provider with ease.  They're just static HTML and CSS files served up; they can be stored just about anywhere.
* Continuing this point, I'm not tied to a single hosting provider, or have to wrangle my data out of my current provided to import into a new.  I can move my site just about anywhere in just a few keystrokes using a simple git push.
* The presentation is [mostly] decoupled from the content.  Presentation is managed by a site theme, which contains a config file and the HTML/JS and CSS templates that will be used to generate the site.  The content resides in markdown text files in a /content/ folder.  It can't get much simpler than that.  Migrating the site to a new theme or location is pretty simple; and the posts themselves are located in a easy to copy format.
* Using a static site generator allows you to use git to effectively manage your web-site. Since the content is mostly markdown files, you can throw the whole thing in a git repo and sync it between your devices, as well as utilize all the goodies that git provides (such as branching, merging, etc).
* The build and deployment of your website can be easily automated (CU, or continuous integration) such that a git push to your server can also serve to deploy the most recent build.  This can be accomplished a variety of ways, but I've chosen to use a simple rsync shell command triggered on the server by a post-receive githook.

As mentioned above, when I _git push_ master to origin, cpanel automatically fires a post-receive githook script that allows you to run a command.  I'm currently rsyncing form my hugo-site/public/ folder to my ~/public_html/web-site/ directory on the server.  This is a great way to automatically deploy your site when you're ready.

However, for this to work cpanel requires that you create a github respository through its interface.  This is simple enough, but there you may run into a snag when you try to push your local repo to the new cpanel repo through an ssh connection.  You may get an error: "fatal: bad config value for 'receive.denycurrentbranch' in ./config".

The fix for it was [simple](https://stackoverflow.com/questions/56990207/fatal-bad-config-value-for-receive-denycurrentbranch-in-config) after you realize what's going on.
It turns out that there are sometimes more than one version of git installed in web-hosting providers.  (One in /usr/bin/ and one is cpanel path somewhere.)  The one that is being tapped to run the git interaction from the ssh user is the old one, which causes the error.  You need to point to the right version of git.

* Create the remote repo
* Add the repo location as an origin to your local repo
* Run the following command in the local repo:

```git config remote.origin.receivepack /usr/local/cpanel/3rdparty/lib/path-bin/git-receive-pack```

(You're location for the git version you need may be different.)
(To find out the location you need to use, while ssh'ed in the server, run `which git-receive-pack`.)
