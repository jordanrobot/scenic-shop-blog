---
title: "Acad - Saving Keystrokes!"
date: "2008-10-02"
tags: ["AutoCAD"]
---

(Or: How I Stopped Worring and Learned to Love the Command Alias)

If you are an avid AutoCAD user, you know that setting up your command aliases is key. For those interested, I’ve put my customized portion of the acad.pgp file [here](http://scenic-shop.com/files/cad/pgp/acad-pgp.txt).

For those of you who are not familiar with AutoCAD’s command aliases, you’re in for a treat. Every time you enter “rec” instead of “rectangle,” or “l” instead of “line” you are using a command alias. Te best part is that you can customize your aliases to your heart’s content.

Customizing your aliases provides a number of advantages. Brief bullet list:

- Edit the shortcuts so that they make sense to you, not some guy at Autodesk.
- Edit the shortcuts so that groups of commands are related.
- Cut down on the overall number of keystrokes your numb little fingers enter during the day.
- Select your most frequently used commands and try to reduce them to as few keystrokes as possible, even if other less frequently used commands have to be reassigned to have longer aliases.

How can you edit your command aliases? There are two ways to go about it. The first is to use the Aliasedit command, which will let you change your aliases in a cute dialogue box. As convenient as the Aliasedit command is, I am not a fan for reasons that will later become clear.

AutoCAD’s command aliases are stored in a file called Acad.pgp (buried in your user folders.) The second (and my preferred) method is to edit the acad.pgp file directly. I recommend running Windows’ file search to find the file. Once you open it, you will see the aliases on the left, and commands they invoke to the right.

If you edit or add any aliases, I recommend you go to the bottom of the file, and add your changes there; don’t edit the top portion of the acad.pgp file unless you know what you are doing. This is why you don’t need to edit the top of the file; if AutoCAD sees the same alias twice, it will only use the one closest to the bottom of the file.

And here is why I recommend putting all of your changes in one place; when you upgrade AutoCAD, you can copy your changes and paste them into the bottom of the upgraded acad.pgp file. This way nothing breaks, and you don’t end up trashing any aliases for new commands. (This is why I don’t like using the Aliasedit command, it does not group your changes together which makes upgrading and organizing any changes a hassle.)

Almost done, just a few more things, you might want to print out your aliases and use them as a reference until you become more familiar with them. It is also a great way to discover powerful commands you didn’t know about.
