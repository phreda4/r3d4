| bubbles
| PHREDA 2012,2020
|mem $ffff

^r3/lib/3d.r3
^r3/lib/gui.r3
^r3/lib/btn.r3
^r3/util/arr16.r3

#bubles 0 0

|----- draw cube -----
:3dop project3d op ;
:3dline project3d line ;

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

|---------
:r.01 rand 0.001 mod ;
:r.1 rand 1.0 mod ;
:r.8 rand 8.0 mod ;

:bub | adr -- adr/adr 0 delete
 	>b
	mpush
	b@+
	18.0 >? ( 18.0 b> 4 - ! b> 4 + dup @ neg swap ! )
	-18.0 <? ( -18.0 b> 4 - ! b> 4 + dup @ neg swap ! )
	b@+
	-18.0 <? ( -18.0 b> 4 - ! b> 4 + dup @ neg swap ! )
	0 mtransi
	b@+ b> 12 - +!
	b@ 0.01 - b> ! | gravedad
	b@+ b> 12 - +!
	b@+ 'ink !
	drawcube
	mpop
	;

:+buble
	'bub 'bubles p!+ >a
	r.8 8.0 + r.8 a!+ a!+
	r.1 r.1 a!+ a!+
	rand a!+ ;

:collision | p1 p2 -- p1 p2
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

:white $ffffff 'ink ! ;
:green $7f00 'ink ! ;
:red $7f0000 'ink ! ;

:main
	cls gui home white
	over "r%d " print cr
	"<SPC> to add bubbles..." print cr cr
	sp
	red 'exit " Exit " btnt sp
	green '+buble " + " btnt sp

	key
	<esp> =? ( +buble )
	>esc< =? ( exit )
	drop

	omode
	0 0 -40.0 mtrans
	'bubles p.draw
	'collision 'bubles p.map2
	acursor
	;

:resetgame
	'bubles p.clear
	;

:inicio
	mark
	1000 'bubles p.ini
	resetgame
	;

: inicio 3 'main onShow ;
