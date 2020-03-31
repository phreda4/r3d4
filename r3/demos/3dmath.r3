| 3d math demo
| PHREDA 2020
|----------------------
|MEM 8192

^r3/lib/gui.r3
^r3/lib/3d.r3
^r3/lib/rand.r3
^r3/util/arr16.r3

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

|-----------------------
:r1 rand 1.0 mod ;
:r10 rand 10.0 mod ;
:r.1 rand 0.1 mod ;
:r.01 rand 0.01 mod ;

:v+ b@+ b> 28 - +! ;

:boink
	dup abs 20.0 >? ( 
		b> 20 + dup @ neg swap !	| vel
		b> 32 + dup @ neg swap !	| rot
		) drop ;

:draw1 | adr --
	>b
	mpush
	b@+ 'ink !
	b@+ boink b@+ boink b@+ boink
	mtransi
	b@+ mrotxi b@+ mrotyi b@+ mrotzi
	v+
	0.001 b> +!
	v+ v+
	v+ v+ v+
	drawcube
	mpop ;

:addobj
	'draw1 'objetos p!+ >a
	rand a!+
	0 0 0 a!+ a!+ a!+	| position
	0 0 0 a!+ a!+ a!+	| rotation
	r.1 r.1 r.1 a!+ a!+ a!+ | vpos
	r.01 r.01 r.01 a!+ a!+ a!+ | vrot
	;

|-----------------------
:screen
	cls home
	$ff00 'ink !
	'objetos p.cnt "%d" print
	omode
	freelook
	xcam ycam zcam mtrans
	'objetos p.draw
	drawcube
	key
	<up> =? ( 0.1 'zcam +! )
	<dn> =? ( -0.1 'zcam +! )
	<f1> =? ( addobj )
	>esc< =? ( exit )
	drop
	acursor ;

:main
	mark
	10000 'objetos p.ini
	'screen onshow ;

: main ;