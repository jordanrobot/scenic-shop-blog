---
title: "Layer State Switcher"
date: "2010-07-17"
tags: ["AutoCAD", "Code"]
summary: AutoLISP code to toggle between layerstates.
---

This AutoCAD lisp command transparently saves the current layerstate.  Subsequent invocations switch between the saved state and the current state.  You can go back and forth until your eyes pop out.

[Download and enjoy!](https://scenic-shop.com/files/cad/lisp/LayerStateSwitcher.lsp)

```
command: LSS
- on first run, it will save a layerstate and exit the command
- option: Previous - (default option), saves the current layerstate and switches you to the original saved layerstate.
- option: Update   - saves the current layerstate for future retrieval.
- option: Clear    - delete the auto-generated layerstates that this script creates. 
- option: eXit     - duh.
```
