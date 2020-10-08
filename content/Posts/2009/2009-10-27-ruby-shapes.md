---
title: "Ruby Shapes"
date: "2009-10-27"
---

### ![rubyshapeslogo](images/rubyshapeslogo.png "rubyshapeslogo")

### What is RubyShapes?

RubyShapes is a Ruby library that defines Shape objects analogous to geometric cross-sections. These Shape objects "have" the same geometric properties that their real world counterparts do. The long term goal is to use RubyShape objects as building blocks for a larger structural and mechanical calculation software library.

### Geometric cross sections?

These are cross sections of 3D objects (square rods, circular rods, rectangular tubing, etc.) Each shapes' cross section has properties that are that are used in structural and mechanical calculations.

### Current version?

The current version of RubyShapes is v0.2.9.1. It has been tested on Ruby 1.8 & later.

### License

RubyShapes is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. RubyShapes is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. For license specifics, see

### Where is the source code?

The source can be found at the [github RubyShapes repository](http://github.com/mdjordan/RubyShapes/tree/master).

### Properties for each shape class

**x** = x dimension (in.) (equiv. to outer diameter for round shapes) **y** = y dimension (in.) (equiv. to outer diameter for round shapes) **a** = square area (in^2) **ix** = second moment of area for xx (in^4) **iy** = second moment of area for yy (in^4) **sx** = section modulus for xx (in^3) **sy** = section modulus for yy (in^3) **rx** = radius of gyration for xx (in) **ry** = radius of gyration for yy (in) **w** = weight of shape per linear foot (lbs/ft) - right now assumes all shapes are steel

### RubyShapes Structure:

**RubyShapes.rb** - the main file, contains the definitions & calculations for each shape class. There is a testing area at the bottom of the file. Most of the shared code for RubyShapes is divided into several modules, each module lives as a file in the /lib/ folder: **DiagUtils Module** - Diagnostic messages. **OutputUtils Module** - Defines the methods that return values from the shape values. **ShapeUtils Module** - Defines property calculations that are common to multiple.

### List of Classes

**Bar(x/y dimension)** - Square bar shapes **Plate(x dimension, y dimension)** - Rectangular bar shapes **Square\_tube(x/y dimension, gauge/thickness)** - Mild Steel As-Welded Mechanical Tubing **Rec\_tube(x dimension, y dimension, gauge/thickness)** - Mild Steel As-Welded Mechanical Tubing **Round\_tube(outside diameter, thickness)** **Rod(outside diameter)** - Round rod shapes

### Output Methods

These methods are used to retrieve the calculated properties from the shape objects. **.props** Returns a human-readable list of the shape object's properties (as floats, rounded to 4 places). Optional: include a ("variable") parameter to the method to return that specific parameter's value. **.bigprops** Returns a human-readable list of the shape object's properties (as BigDecimals). Optional: include a ("variable") parameter to the method to return that specific parameter's value. **.hash** Returns the hash of Object properties (as floats, rounded to 4 places). **.bighash** Returns the hash of Object properties (as BigDecimals). **.columns\_header** Prints a pretty, human-readable header for the columns method. Spacing is not currently ideal. **.columns** Returns the Object properties in a column format (as floats, rounded to 4 places).

### ShapeUtilites Methods

These methods are invoked by the shape classes during object initialization. They are not very useful to the end user. **Float::to\_d** **.corner\_radius** Calculates corner radius for calculations. This method is not implemented yet. **.gauge\_converter** Converts from steel gauge thicknesses to decimal thickness. **.calc\_weight** Calculates weight values - currently assumes all shapes are mild steel. **.build\_hash** Builds a hash of the shape object's properties. Result is stored in the shape object's **hash** variable.

### Diagnostics Methods

These methods mostly only run when DIAGNOSTICS = on. **.diag\_section("message")** Outputs a diagnostic section(header) line to the screen. --- message --- **.diag\_line(arg)** Outputs a diagnostic line to the screen **.diag\_class** Outputs which class is currently initializing. Prints the following: ==== Now initiating a Rec\_tube class ==== **.test\_output** Prints Output Module Methods all at once for the receiver object. Good for batch testing the Output Module methods **.var\_classes** Prints the classes for a predefined list of instance variables in the receiver object. DIAGNOSTIC flag independent. **.var\_values** Prints the values for a predefined list of instance variable in the receiver object. DIAGNOSTIC flag independent. **.diag\_all** Not implemented yet. It will be a comprehensive diagnostic inspection for any object. DIAGNOSTIC flag independent.
