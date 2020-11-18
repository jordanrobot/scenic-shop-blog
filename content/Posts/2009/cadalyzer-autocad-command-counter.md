---
title: "CADalyzer (AutoCAD Command Counter)"
date: "2009-03-01"
tags: ["AutoCAD", "Code"]
---

I’ve been working on a Ruby utility to analyze AutoCAD log files. The goal is to count how many times each command is invoked. The basic functionality is all in place, I’ve plans to add more in-depth analysis and perhaps even turn it into a web based tool. For now, you’ll have to download it and run it in the command line. If you want to run this, you’ll need the Ruby programming language runtime installed on your computer. Here is a link to the [Ruby download](http://www.ruby-lang.org/en/downloads/). My [CADalyzer utility can be downloaded here.](http://scenic-shop.com/files/code/Cadalyzer.05b.zip "CADalyzer")

Download the .zip file, and unpack it. To run the utility, you will need to tell it where your AutoCAD log files are stored. (You can find that location in AutoCAD, via the Preferences.) Open the Cadalyzer.rb file and enter the path to your log directory next to the word path, like so:

Excerpt from top of Cadalyzer.rb file:

    > path = "insert full path to log file directory here"


The utility will combine & analyze the data from every log file in the directory specified.

Happy analyzing.
