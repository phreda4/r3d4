| pool
| PHREDA 2012 :r4
|--------------------------
^r3/lib/gui.r3
^r3/lib/3d.r3
^r3/lib/vsprite.r3

^r3/lib/trace.r3
^r3/util/arr16.r3

#sball $16ECE64 $4DDBFE26 $489AE730 $16D2DD6 $498D1CA0 $B507FE26 $BBB51310 $16ECE66 $B956E730
#cball $FF0C 0

#FRICTION	0.982

#power 2.0
#x1 #y1
#x2 #y2

|c m dy dx y x
#balllist 0 0

#xcam 0 #ycam 0 #zcam 50.0

|--------------------------------
:3dop project3d op ;
:3dline project3d line ;

:freelook
	xypen
	sh 1 >> - 7 << swap
	sw 1 >> - 7 << swap
	neg mrotx mroty ;

:drawmesa
	$ffffff 'ink !
	15.0 20.0 0 3dop
	-15.0 20.0 0 3dline
	-15.0 -20.0 0 3dline
	15.0 -20.0 0 3dline
	15.0 20.0 0 3dline
	;

:drawboxz | z --
	-0.7 -0.7 pick2 3dop
	0.7 -0.7 pick2 3dline
	0.7 0.7 pick2 3dline
	-0.7 0.7 pick2 3dline
	-0.7 -0.7 rot 3dline ;

:drawlinez | x1 x2 --
	2dup -0.7 3dop 0.7 3dline ;

:drawcube |
	-0.7 drawboxz
	0.7 drawboxz
	-0.7 -0.7 drawlinez
	0.7 -0.7 drawlinez
	0.7 0.7 drawlinez
	-0.7 0.7 drawlinez ;

|------------------------------
:hitwall | adr --
	dup @ neg swap ! ;

:pball
	mpush
	>b
	b@+	| X
	15.0 >? ( 15.0 b> 4 - ! b> 4 + hitwall )
	-15.0 <? ( -15.0 b> 4 - ! b> 4 + hitwall )
	b@+	| Y
	20.0 >? ( 20.0 b> 4 - ! b> 4 + hitwall )
	-20.0 <? ( -20.0 b> 4 - ! b> 4 + hitwall )
	0 mtransi
	b@+ b> 12 - +!	| VX
	b> 4 - dup @ FRICTION *. swap !
	b@+ b> 12 - +!	| VY
	b> 4 - dup @ FRICTION *. swap !
	b@+ drop		| MASS
	b> @

|	8 << $c or 'cball !  | COLOR
|	'sball 3dvsprite

	'ink ! drawcube

	mpop ;

:+pball | color x y --
	'pball 'balllist p!+ >b
	b!+ b!+
	0 0 b!+ b!+
	1.0 b!+
	b! ;

|------
:everyb | p1 p2 -- p1 p2
	over 4 + @ over 4 + @ - dup *. | (x1-x2)^2
	pick2 8 + @ pick2 8 + @ - dup *. +
	4.0 >=? ( drop ; ) sqrt. 2.0 swap -
	1 >> >a
	over 4 + @ over 4 + @ -
	pick2 8 + @ pick2 8 + @ -
	atan2 sincos swap				| p1 p2 si co
	dup a> *. pick4 4 + +!
	dup a> *. neg pick3 4 + +!
	over a> *. pick4 8 + +!
	over a> *. neg pick3 8 + +!

	dup a> *. pick4 12 + +!
	dup a> *. neg pick3 12 + +!
	over a> *. pick4 16 + +!
	over a> *. neg pick3 16 + +!

	2drop
	;
|------
:hitmove
	$ff0000 'ink !
	x1 y1 op xypen 2dup line 'y2 ! 'x2 !
	x1 x2 - dup * y1 y2 - dup * + 1 << 'power !
	;

:hit
	'balllist 4 + @ | 1er
	12 + >a | vx vy
	x1 x2 - y1 y2 -
	atan2 sincos swap
	power *. a!+
	power *. a!+
	;

:resethit
	0 'x1 ! 0 'y1 ! 0 'x2 ! 0 'y2 ! ;

:resetgame
	'balllist p.clear
	 $f0f0f0 -9.0 0.0 +pball
	5 ( 1?
		1 ( over <?
				rand
				pick2 5 - 2.0 * 10.0 +
				pick3 1.0 * pick3 2.0 * -
				+pball
			1 + ) drop
		1 - ) drop
	;

|-----
:main
	cls gui $ffffff 'ink !
|	dup "%d" print cr
|	power " POWER:%f" print
	[ xypen 'y1 ! 'x1 ! ; ] 'hitmove 'hit  guiMap

	omode
|	freelook
	xcam ycam zcam mtrans

	drawmesa
	'balllist p.draw
	'everyb 'balllist p.map2

	key
	<esp> =? ( hit )
	>esc< =? ( exit )
	drop
	acursor ;

:start
	mark
	50 'balllist p.ini
	resetgame
	resethit
	;

:
start
'main onshow
;

