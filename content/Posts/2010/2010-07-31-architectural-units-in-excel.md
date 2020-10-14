---
title: "Architectural Units in Excel"
date: "2010-07-31"
tags: ["Excel", "Code"]
---

Here we give out excel formulas to do math with architectural measurements (e.g. 14'-3").

I recently had to calculate the total area of our soft goods inventory.  With over 80 drapes, that's a lot of number crunching.  Luckily our inventory is in an excel file, which includes the height and width of each drape.  Okay, make a formula to calculate the square area from those values... Problem: the measurements are given in feet and inches (e.g. 12'-1").  Excel treats this as a string, hence it cannot use it to do math.  Solution: the following formula will strip out the excess characters and convert the measurement to inches -- success!

### Formula #1

Convert a 13'-10" style format into inches.  (Replace instances of C3 with the cell containing the measurement to convert.)

    =(LEFT(C3,(SEARCH("'",C3,1)-1))*12)+(SUBSTITUTE(SUBSTITUTE((RIGHT(C3,((SEARCH("-",C3,1)) -1))),"-",""),"""","")))

### Formula #2

Calculate area from two cells (C3 & D3) from a ```\[feet\]'-\[inches\]"``` style format.  Returns area as square feet.

    =(((LEFT(C3,(SEARCH("'",C3,1)-1))*12)+(SUBSTITUTE(SUBSTITUTE((RIGHT(C3,((SEARCH("-",C3,1)) -1))),"-",""),"""","")))*((LEFT(D3,(SEARCH("'",D3,1)-1))*12)+(SUBSTITUTE(SUBSTITUTE((RIGHT(D3,((SEARCH("-",D3,1)) -1))),"-",""),"""",""))))/144

The only requirement is that the format must be as follows: 5'-3" These formulas rely on this format to find the numbers. Perhaps when I find more time, I'll update them to work with a few different styles.
