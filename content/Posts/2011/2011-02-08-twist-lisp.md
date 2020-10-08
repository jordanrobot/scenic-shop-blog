---
title: "Twist Lisp"
date: "2011-02-08"
---

Did you know you can precisely rotate the current view of modelspace?  This is a killer way to simplify drafting and dimensioning objects on an angle, especially if you have a way to align the current view to an object.  (And we do, keep reading.)

The longhand command is Dview > Dviewblock > Twist.  Enter the angle you want to twist the current view to, and you're set.  Why type that out every time?  This lisp will do that and more - just type "TW" to invoke.

[Download it here.](https://scenic-shop.com/files/cad/lisp/twist.lsp)

Command : TW

- Enter the twist angle explicitly (e.g. 45 or -134.25) or...

- Align: set twist angle by picking two points (Point 1 is 0,0 and Point 2 is positive x-axis vector)
- Relative: set twist angle relative to current twist angle
- After twisting the view, the list will prompt yes(default)/no to realign the UCS to the current angle.

Right now the script only does the twist in modelspace, I'm planning on expanding it to work in paperspace & viewports as well.  When I get some free time that is.

Until next time - keep it lazy.
