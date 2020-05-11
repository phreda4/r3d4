|SCR 512 512
| Example 1

^r3/lib/gui.r3
^r3/lib/print.r3
^r3/lib/rand.r3
^r3/lib/3d.r3

#cc

#tt

:drawc
	0.01 'tt +!
	0 300 op
	0 0 ( 5.0 <? swap
		dup pick2 tt + cos 200 1.0 */ 300 + line
		3 + swap 0.02 + ) 2drop ;

#xcam #ycam #zcam 40.0
#objetos 0 0	| finarray iniarray

:2/ 1 >> ;

:freelook
	xypen
	sh 2/ - 7 << swap
	sw 2/ - neg 7 << swap
	neg mrotx mroty ;

|----- draw cube -----
:3dop project3d op ;
:3dline project3d line ;

:drawboxz | z --
	-0.5 -0.5 pick2 3dop
	0.5 -0.5 pick2 3dline
	0.5 0.5 pick2 3dline
	-0.5 0.5 pick2 3dline
	-0.5 -0.5 rot 3dline ;

:drawlinez | x1 x2 --
	2dup -0.5 3dop 0.5 3dline ;

:drawcube |
	-0.5 drawboxz
	0.5 drawboxz
	-0.5 -0.5 drawlinez
	0.5 -0.5 drawlinez
	0.5 0.5 drawlinez
	-0.5 0.5 drawlinez ;

:test
	cls home
	$ffffff 'ink !
	over " r%d" print cr
	cr
	$ff00 'ink !
	here "%h" print cr cr
	msec 2 << sin "%f" print cr
	drawc

	omode
| freelook
	0.2 mrotx
	2.3 2.3 40.0  mtrans
	drawcube
	1.0 1.0 1.0 transform "%f %f %f" print cr
	oztransform "%f" print cr

	$1186
	%1111110 an? ( "no" print cr )
	drop

	key
	>esc< =? ( exit )
	<up> =? ( 10 'cc +! )
	<dn> =? ( -1 'cc +! )
	drop
	;

:ini
	mark
	;

:
	ini
	3 'test onshow
;

