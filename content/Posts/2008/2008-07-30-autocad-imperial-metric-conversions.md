---
title: "AutoCAD Imperial & Metric Conversions"
date: "2008-07-30"
---

Yesterday a friend asked me how to convert an AutoCAD drawing from metric to imperial. He needed to dimension in inches and draw imperial sized objects inside a metric drawing. Turns out the Autocad help is not so helpful on this specific subject.

**Units & Units:** So here's the deal, AutoCAD “thinks” in a _drawing units_. These _drawing units_ don’t have a real world size. The only relation to real world size they have is the name that we assign to them in the units dialogue box. But a name doesn’t mean a thing to AutoCAD. 1 metric _drawing unit_ = 1 imperial _drawing unit_ = 1 mile _drawing unit_.

Example: when you copy & paste a 12"x12" rectangle into any drawing, AutoCAD really pastes a 12 unit x 12 unit rectangle. If you paste that same 12”x12” rectangle into a millimeter based drawing, the rectangle will only be 12 mm x 12 mm.  Likewise, a 12mm x 12mm rectangle pasted into an inch based drawing will become 12”x12”.

**Conversion Factors:** These common conversion factors will help you out as you keep reading: 1 inch is 25.4 mm 1 mm is 0.0393700787 inches

There are two easy ways to solving cross unit woes in AutoCAD.

**Soft-Convert:** If you only need to _dimension_ a drawing with different units (e.g. a metric drawing with imperial dimensions,) you can create a dimension style with a SCALE (Dimension Styles > Primary Units tab.) The SCALE is the conversion factor. So if my SCALE is 25.4, when I dimension a 1” line the dimension shown will be 25.4 (1 x 25.4 = 25.4)

Advanced tip: If you want to forgo the dialogue boxes, you can edit the current dimension style's scale directly by changing the value of the DIMLFAC variable.  Note that DIMLFAC creates a dimension style override (named "Style Overrides") that only alters the scale of the current dimension style.

**Hard-Convert:** If you need to actually draw in imperial units when the drawing is in metric units, you will need to scale the objects in the drawing from mm to inch (or vice versa).  No settings or variables here; simply select everything in the drawing and use the scale command (& the correct conversion factors) to resize everything to your desired measurement unit. Now draw away.

**A Note on Insertion Scale:** Something important to note. Many people get waylaid by the "Insertion Scale" field in the "Units" dialogue box. This _does_automatically scale inserted content to the selected unit, but only when you are inserting objects such as blocks, drawings, or images. If you need to paste cross-unit objects between drawings, writing them to a block and inserting may be your best bet. If you want, you can use the INSUNITS variable to change this setting.

Optional tip. You can also set the "Insertion Scale" to Unitless and specify the default source and target units in the "Options/User Preferences" dialogue box. Inserted objects will automatically scale between the source and target units you set, regardless of what unit the drawing file was created with.

The most useful information ends here. For those who program LISP routines, a rant follows...

It boggles my mind that AutoCAD does not have an optional real-time scaling factor built-in for drawing differing units in the same drawing. This would consist of 1) a global drawing unit, as supplied by the user or the template. This would tell Autocad what measurement unit the drawing is in. 2) A scaling factor would be calculated and applied to objects as they are drawn. AutoCAD would compare the entered unit to the global unit and apply the appropriate conversion factor to object drawn or edited. Perhaps the same can be achieved using a LISP routine. If there are any takers, please drop me a line.

[![kick it on CadKicks.com](http://cadkicks.com:80/Services/Images/KickItImageGenerator.ashx?url=http%3a%2f%2fscenic-shop.com%2fss%2ffiles%2fautocad_mixed_units.html&bgcolor=FF9900&cfgcolor=FFFFFF&cbgcolor=000000)](http://cadkicks.com:80/kick/?url=http%3a%2f%2fscenic-shop.com%2fss%2ffiles%2fautocad_mixed_units.html)
