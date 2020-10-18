---
title: "Git remote fix for 'receive.denycurrentbranch' in ./config"
date: 2020-10-18T00:40:53-04:00
draft: false
---

This is a just a quick reminder to myself about a cpanel git issue that I've found a fix for.

When accessing a git remote from a webphosting provider thru ssh, you may get the error...
"fatal: bad config value for 'receive.denycurrentbranch' in ./config"

The fix for it was [simple](https://stackoverflow.com/questions/56990207/fatal-bad-config-value-for-receive-denycurrentbranch-in-config) after you realize what's going on.
It turns out that there are sometimes more than one version of git installed in web-hosting providers.  (One in /usr/bin/ and one is cpanel path somewhere.)  The one that is being tapped to run the git interaction from the ssh user is the old one, which causes the error.  You need to point to the right version of git.

* Create the remote repo
* Add the repo location as an origin to your local repo
* Run the following command in the local repo:

```git config remote.origin.receivepack /usr/local/cpanel/3rdparty/lib/path-bin/git-receive-pack```

(You're location for the git version you need may be different.)
(To find out the location you need to use, while ssh'ed in the server, run `which git-receive-pack`.)
