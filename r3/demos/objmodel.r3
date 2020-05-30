| Obj Model Loader
| - faltan indices negativos
| PHREDA 2017
|-----------------------------------
|MEM $ffff

^r3/lib/gui.r3
^r3/lib/btn.r3
^r3/lib/3d.r3

|^r3/3d/dev/tritex.r3

^r3/lib/trace.r3

^r3/util/loadobj.r3


| TEXTURE
|-------------
#v2d
#zbuffer

#txres
#tyres
#tritt
0 0 0 0
0 0 0 0
0 0 0 0

:dumptri
	'tritt
	@+ "%d " print @+ "%d " print @+ "%d " print @+ "%h " print cr
	@+ "%d " print @+ "%d " print @+ "%d " print @+ "%h " print cr
	@+ "%d " print @+ "%d " print @+ "%d " print @+ "%h " print cr
	drop ;

:setcolor
	4 << colorl + 12 + @
	dup @
	dup $ffff and 'txres !
	16 >>> 'tyres !
|	'tritexture !
	drop
	;

:svert
	b@+ 1 - 3 << v2d + @+ d>xy swap a!+ a!+ | x y
	@ a!+ | z
	b@+ 16 >>> 1 - 12 * texl +
	@+ txres
	1.0 */ $ffff and 16 <<  | 0..1 0
	swap @ tyres
	1.0 - 1.0 */ $ffff and
	or
	a!+
	;

:objsolid
	0 zbuffer sw sh * fill
	mark
	here 'v2d !
	verl >b
	nver ( 1? 1 -
		b@+ b@+ b@+ 4 b+
		project3dz xy>d , neg , ) drop

	facel >b
	nface ( 1? 1 -
		b> 6 2 << + @ setcolor
		'tritt >a
		svert svert svert
		4 b+
		b> >r
|		dumptri trace

|		'tritt tritex2 |**

|		dumptri
		r> >b
		) drop
	empty
	;

| WIRE
|-------------
:drawtri | x y x y x y --
	2dup op
	2swap line
	2swap line
	line ;

:drawtrif | x y x y x y --
	2dup op
	2swap pline
	2swap pline
	pline
	poli ;

::objwire
	mark
	here 'v2d !
	verl >b
	nver ( 1? 1 -
		b@+ b@+ b@+ 4 b+ project3d
		xy>d , ) drop
	facel >b
	nface ( 1? 1 -
		b@+ 4 b+ 1 - 2 << v2d + @ d>xy
		b@+ 4 b+ 1 - 2 << v2d + @ d>xy
		b@+ 4 b+ 1 - 2 << v2d + @ d>xy
		4 b+
		drawtri
		) drop
	empty
	;

| MAIN
|-----------------------------------
#xcam 0 #ycam 0 #zcam -55.0
#xr #yr

:freelook
	xypen
	sh 1 >> - 7 << swap
	sw 1 >> - neg 7 << swap
	neg
|	swap 0 mrotxyz
	mrotx mroty ;

#model

:red $ff0000 'ink ! ;
:white $ffffff 'ink ! ;
:green $ff00 'ink ! ;
:cyan $ffff 'ink ! ;

:main
	cls home gui
	cr sp
	red 'exit " X " btnt sp

	over ":r%d " white print
	"Load Obj" green print cr cr
	nver " %d vertices" print cr
   	nface " %d caras" print cr

|	facel dumpd
|		dumpcolor
	1.0 3dmode
	freelook
	xcam ycam zcam mtrans
	white
	objwire
|		objsolid

	key
	<up> =? ( 1.0 'zcam +! )
	<dn> =? ( -1.0 'zcam +! )
	<f1> =? ( objminmax objcentra )
	>esc< =? ( exit )
	drop

	acursor ;

:memory
	0 'paper !
	mark
	here 'zbuffer !
|	zbuffer vframe - 'trizbuffer !
	sw sh * 2 << 'here +!
	"media/obj/mario/mario.obj"
	loadobj 'model !
	objminmax
	objcentra
	;

: memory 3 'main onshow ;
