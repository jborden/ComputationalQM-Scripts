#!/usr/local/bin/gnuplot -persist
#
#    
#    	G N U P L O T
#    	Version 4.0 patchlevel 0
#    	last modified Thu Apr 15 14:44:22 CEST 2004
#    	System: Darwin 8.2.0
#    
#    	Copyright (C) 1986 - 1993, 1998, 2004
#    	Thomas Williams, Colin Kelley and many others
#    
#    	This is gnuplot version 4.0.  Please refer to the documentation
#    	for command syntax changes.  The old syntax will be accepted
#    	throughout the 4.0 series, but all save files use the new syntax.
#    
#    	Type `help` to access the on-line reference manual.
#    	The gnuplot FAQ is available from
#    		http://www.gnuplot.info/faq/
#    
#    	Send comments and requests for help to
#    		<gnuplot-info@lists.sourceforge.net>
#    	Send bugs, suggestions and mods to
#    		<gnuplot-bugs@lists.sourceforge.net>
#    
# set terminal x11 
# set output
unset clip points
set clip one
unset clip two
set bar 1.000000
set border 31 lt -1 lw 1.000
set xdata
set ydata
set zdata
set x2data
set y2data
set timefmt x "%d/%m/%y,%H:%M"
set timefmt y "%d/%m/%y,%H:%M"
set timefmt z "%d/%m/%y,%H:%M"
set timefmt x2 "%d/%m/%y,%H:%M"
set timefmt y2 "%d/%m/%y,%H:%M"
set timefmt cb "%d/%m/%y,%H:%M"
set boxwidth
set style fill empty border
set dummy x,y
set format x "% g"
set format y "% g"
set format x2 "% g"
set format y2 "% g"
set format z "% g"
set format cb "% g"
set angles radians
unset grid
set key title ""
set key right top Right noreverse enhanced box linetype -2 linewidth 1.000 samplen 4 spacing 1 width 0 height 0 autotitles
unset label
unset arrow
unset style line
unset style arrow
unset logscale
set offsets 0, 0, 0, 0
set pointsize 1
set encoding default
unset polar
unset parametric
unset decimalsign
set view 73, 342, 1, 1
set samples 100, 100
set isosamples 10, 10
set surface
set contour base
set clabel '%8.3g'
set mapping cartesian
set datafile separator whitespace
unset hidden3d
set cntrparam order 4
set cntrparam linear
set cntrparam levels discrete 3,4 ,5 ,6 ,7 ,8 ,9 ,10 ,10.5 ,11 ,12 ,13 ,14.5 ,15 ,15.5 ,16.5 ,17 ,17.5 
set cntrparam points 5
set size ratio 0 1,1
set origin 0,0
set style data points
set style function lines
set xzeroaxis lt -2 lw 1.000
set yzeroaxis lt -2 lw 1.000
set x2zeroaxis lt -2 lw 1.000
set y2zeroaxis lt -2 lw 1.000
set tics in
set ticslevel 0.5
set ticscale 1 0.5
set mxtics default
set mytics default
set mztics default
set mx2tics default
set my2tics default
set mcbtics default
set xtics border mirror norotate 1.80000,0.1,3.10000
set ytics border mirror norotate 1.80000,0.1,3.10000
set ztics border nomirror norotate autofreq 
set nox2tics
set noy2tics
set cbtics border mirror norotate autofreq 
set title "" 0.000000,0.000000  font ""
set timestamp "" bottom norotate 0.000000,0.000000  ""
set rrange [ * : * ] noreverse nowriteback  # (currently [0.00000:10.0000] )
set trange [ * : * ] noreverse nowriteback  # (currently [-5.00000:5.00000] )
set urange [ * : * ] noreverse nowriteback  # (currently [-5.00000:5.00000] )
set vrange [ * : * ] noreverse nowriteback  # (currently [-5.00000:5.00000] )
set xlabel "R6" 0.000000,0.000000  font ""
set x2label "" 0.000000,0.000000  font ""
set xrange [ 1.90000 : 3.10000 ] noreverse nowriteback
set x2range [ -1.16428 : -1.16428 ] noreverse nowriteback
set ylabel "R4" 0.000000,0.000000  font ""
set y2label "" 0.000000,0.000000  font ""
set yrange [ 1.80000 : 3.20000 ] noreverse nowriteback
set y2range [ 157.007 : 157.007 ] noreverse nowriteback
set zlabel "" 0.000000,0.000000  font ""
set zrange [ * : * ] noreverse nowriteback  # (currently [-10.0000:10.0000] )
set cblabel "" 0.000000,0.000000  font ""
set cbrange [ * : * ] noreverse nowriteback  # (currently [-10.0000:10.0000] )
set zero 1e-08
set lmargin -1
set bmargin -1
set rmargin -1
set tmargin -1
set locale "C"
set pm3d at s
set pm3d scansautomatic flush begin noftriangles nohidden3d implicit corners2color mean
set palette positive nops_allcF maxcolors 0 gamma 1.5 color model RGB 
set palette defined ( 0 0 0 1, 0.25 0.6784 0.8471 0.902, 0.5 1 0.6471 0,\
     0.75 1 0.2706 0, 1 1 0 0 )
set colorbox vertical origin 0.9,0.2 size 0.1,0.63 bdefault
unset colorbox
set loadpath 
set fontpath 
set fit noerrorvariables
MOUSE_X = 2.95063890203502
MOUSE_Y = -1.97551020408163
MOUSE_X2 = 1e+38
MOUSE_Y2 = 1e+38
MOUSE_BUTTON = 1
MOUSE_SHIFT = 0
MOUSE_ALT = 0
MOUSE_CTRL = 0
splot 'PES.txt' using 1:2:3 with lines
#    EOF
