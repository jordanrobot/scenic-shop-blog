---
title: "AutoLISP Layer Snippets"
date: "2020-10-07"
tags: ["AutoCAD", "Code"]
---

These are some of my frequently used AutoLISP snippets for layer management.  I've got a heap of these in a lisp file that I autoload into autocad at startup.  You can find the entire file here: [layer-shortcuts.lsp](https://github.com/jordanrobot/AutocadUtilities/blob/master/layer-shortcuts.lsp).

If you look through that file, you'll see that I have a common set of layers (for 2D and general work) that I include in every drawing file. The AutoLisp commands help to speed up my drafting with these common layers.

This is the syntax for each command:

Change to layer...

    (defun c:1()(setvar "clayer" "Shop - Construction"))

Move to layer...
```
(defun c:m2( / eset) (setq eset (ssget))
    (command ".chprop" "\_p" "" "\_la" "Shop - Dimensions" "")
    )
```
Look like layer \[transform\]...
```
(defun c:t1( / eset) (setq eset (ssget))
    (command ".chprop" "\_p" "" "\_c" "40" "lt" "continuous" "lw" "0.2" "")
    ) 

(defun c:t1( / eset) (setq eset (ssget))
    (command ".chprop" "\_p" "" "\_c" "40" "lt" "continuous" "lw" "0.2" "")
    )
```
Reset object to default layer appearance...
```
(defun c:by( / eset) (setq eset (ssget))
    (command ".chprop" "p" "" "c" "bylayer" "lt" "bylayer" "")
    )
```
copy to current layer...
```
(defun c:ctc() (copy\_to\_)
    (command ".chprop" "L" "" "\_p" "\_la" (getvar "clayer") "")
    )
```