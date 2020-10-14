---
title: "CADalyzer 0.7 Update (AutoCAD Command Counter)"
date: "2009-06-26"
tags: ["AutoCAD", "Code"]
---

This is an update to the Cadalyzer script that I posted a few months ago. It will count the number of commands you have used in AutoCAD; it does this by examining your AutoCAD log files. (You can enable log files in AutoCAD’s options dialogue box.)

[Cadalyzer 0.7 on GitHub](https://github.com/mdjordan/CADalyzer) New features are listed below

- Counting mechanism has be rebuilt, the script now computes 25 times faster than the previous version!
- shows the total number of commands used (Apparently I’ve invoked approx. 38,000 commands since this previous October. Ouch.)
- several command line options have been implemented:

- - unused - shows all the commands you didn’t use; this is helpful when you want to learn more commands
- - compile - compiles all of the logs in the directory and saves them to a single file
- - results - saves the results to a file
- - percent - formats the each command as a percentage of the total commands used

You will need Ruby installed (tested on 1.8.6 and up.) [You can find the Ruby download here.](http://www.ruby-lang.org/en/downloads/) If you don’t use Ruby but would like to learn to program, I highly recommend it. Ruby is an excellent language for beginners and advanced alike.

The only other thing you will need is to tell the script where to find your log file directory. Open the Cadalyzer.rb file and look for the line ```path = '/Path/to/log/files/”``` Replace the```/Path/to/log/files/``` with your path and run the script.

Happy analyzing!
