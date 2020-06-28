|MEM 32768
| irregular iso algorithm
| PHREDA 2020
|-------------------

^r3/lib/gui.r3
^r3/lib/3d.r3
^r3/lib/gr.r3

|------------------------------
#xcam 0 #ycam 0 #zcam 0.5

#octvert * 3072 	| 32 niveles de 3 valores*8 vert
#octvert> 'octvert

#rotsum * 2048		| 32 niveles de 2 valores*8 vert
#rotsum> 'rotsum

#mask

#x0 #y0 #z0
#x1 #y1 #z1
#x2 #y2 #z2
#x4 #y4 #z4
#x7 #y7 #z7	| centro del cubo

#xmask * 1024
#ymask * 1024

#octree

|--------------------------------------
#$base
#$magic
#$octree
#$pixels
#$paleta

:load3do | "" -- moctree
	here dup rot load 'here ! ;

:3do! | octree --
	dup '$base !
	dup 28 + '$octree !
	@+ '$magic !
	@ $octree + '$pixels !
	;

:octcolor | oct -- color
    $octree - $pixels + @ ;

#tpopcnt (
 0 1 1 2 1 2 2 3 1 2 2 3 2 3 3 4
 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5
 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5
 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6
 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5
 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6
 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6
 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 )

:popcnt | nro -- cnt
	'tpopcnt + c@ ;


|---------------
:id3d3i
	transform swap rot ;

:fillstart | --
	'octvert >b
	 0.1  0.1  0.1 id3d3i b!+ b!+ b!+ | 111
	 0.1  0.1 -0.1 id3d3i b!+ b!+ b!+ | 110
	 0.1 -0.1  0.1 id3d3i b!+ b!+ b!+ | 101
	 0.1 -0.1 -0.1 id3d3i b!+ b!+ b!+ | 100
	-0.1  0.1  0.1 id3d3i b!+ b!+ b!+ | 011
	-0.1  0.1 -0.1 id3d3i b!+ b!+ b!+ | 010
	-0.1 -0.1  0.1 id3d3i b!+ b!+ b!+ | 001
	-0.1 -0.1 -0.1 id3d3i b!+ b!+ b!+ | 000
	b> 'octvert> !
	 $ff  $ff  $ff transform 'x0 ! 'y0 ! 'z0 !
	 $ff  $ff -$ff transform 'x1 ! 'y1 ! 'z1 !
	 $ff -$ff  $ff transform 'x2 ! 'y2 ! 'z2 !
	-$ff  $ff  $ff transform 'x4 ! 'y4 ! 'z4 !
	-$ff -$ff -$ff transform
	x0 + 1 >> 'x7 ! y0 + 1 >> 'y7 ! z0 + 1 >> 'z7 !
	;

:noct | n -- x y
	dup 1 << + 2 << 'octvert +
	@+ swap @+ swap @ p3d ;

:noct3 | n1 n2 -- x y z
	dup 1 << + 2 << 'octvert + >a
	dup 1 << + 2 << 'octvert + >b
	;



:fillveciso | --
	octvert> 96 - >b
	'rotsum >a
	b@+ b@+ b@+ p3d a!+ a!+
	b@+ b@+ b@+ p3d a!+ a!+
	b@+ b@+ b@+ p3d a!+ a!+
	b@+ b@+ b@+ p3d a!+ a!+
	b@+ b@+ b@+ p3d a!+ a!+
	b@+ b@+ b@+ p3d a!+ a!+
	b@+ b@+ b@+ p3d a!+ a!+
	b@+ b@+ b@ p3d a!+ a!+
	a> 'rotsum> ! ;

:getn | n --
	3 << 'rotsum + @+ swap @ swap ;

:drawire
	$ff 'ink !
	0 getn op 1 getn line 3 getn line 2 getn line 0 getn line
	4 getn op 5 getn line 7 getn line 6 getn line 4 getn line
	0 getn op 4 getn line
	1 getn op 5 getn line
	2 getn op 6 getn line
	3 getn op 7 getn line
	;

|----- modo 1
:forma1
	x0 x1 - x7 * y0 y1 - y7 * + z0 z1 - z7 * + 63 >> 1 and
	x0 x2 - x7 * y0 y2 - y7 * + z0 z2 - z7 * + 63 >> 2 and or
	x0 x4 - x7 * y0 y4 - y7 * + z0 z4 - z7 * + 63 >> 4 and or
	7 xor 'mask !
	;

:3dop p3d op ;
:3dline p3d line ;

:box | x y r --
	>r
	over r@ - over r@ - 2dup op
	2dup r@ 1 << + line
	over r@ 1 << + over r@ 1 << + line
	over r> 1 << + over line
	line 2drop ;

:drawcube
	$ff00 'ink !
	z0 y0 x0 "x0 %f %f %f " print cr
	z7 y7 x7 "x7 %f %f %f " print cr
	mask "%d " print cr

	$ffff00 'ink ! 0 getn 3 box
	$ffffff 'ink ! mask getn 5 box
	;


|--------------------------------------
|--------------------------------------
#xx0 #yy0 #zz0
#xx1 #yy1 #zz1
#xx2 #yy2 #zz2
#xx4 #yy4 #zz4

#minx #miny #minz
#lenx #leny #lenz
#xy #zz
#len

#vecpos * 64	| child vectors
#stacko * 256	| stack octree+nchildrens
#stacko> 'stacko

:sminmax3 | a b c -- sn sx
	pick2 dup 63 >> not and
	pick2 dup 63 >> not and +
	over dup 63 >> not and + >r
	dup 63 >> and
	swap dup 63 >> and +
	swap dup 63 >> and +
	r> ;

:packxyza!+ | x y z -- xyz0
	rot xx0 + 1 >>
	rot yy0 + 1 >> 16 << or a!+
	zz0 + a!+ ;

:fillx | child x --
	xx0 + 1 >> 'xmask +
	lenx 1 + 1 >> ( 1? 1 - | child xmin len
		pick2 pick2 c+!
		swap 1 + swap ) 3drop ;

:filly | child x --
	yy0 + 1 >> 'ymask +
	leny 1 + 1 >> ( 1? 1 - | child xmin len
		pick2 pick2 c+!
		swap 1 + swap ) 3drop ;

:isodraw
	0 getn 'xx0 ! 'yy0 ! 'zz0 !
	1 getn xx0 - 'xx1 ! yy0 - 'yy1 ! zz0 - 'zz1 !
	2 getn xx0 - 'xx2 ! yy0 - 'yy2 ! zz0 - 'zz2 !
	4 getn xx0 - 'xx4 ! yy0 - 'yy4 ! zz0 - 'zz4 !
	xx1 xx2 xx4 sminmax3 over - 1 + 'lenx ! xx0 + 'minx !
    yy1 yy2 yy4 sminmax3 over - 1 + 'leny ! yy0 + 'miny !
    zz1 zz2 zz4 sminmax3 over - 1 + 'lenz ! zz0 + 'minz !

    minx neg 'xx0 +!
    miny neg 'yy0 +!
	minz neg 'zz0 +!

	lenx leny min 1 >> 'len !

	'vecpos >a
	0 0 0 packxyza!+
	xx1 yy1 zz1 packxyza!+
	xx2 yy2 zz2 packxyza!+
	xx1 xx2 + yy1 yy2 + zz1 zz2 + packxyza!+
	xx4 yy4 zz4 packxyza!+
	xx4 xx1 + yy4 yy1 + zz4 zz1 + packxyza!+
	xx4 xx2 + yy4 yy2 + zz4 zz2 + packxyza!+
	xx4 xx1 + xx2 + yy4 yy1 + yy2 + zz4 zz1 + zz2 + packxyza!+

	'xmask 0 256 fill
	$1 0 fillx
	$2 xx1 fillx
	$4 xx2 fillx
	$8 xx1 xx2 + fillx
	$10 xx4 fillx
	$20 xx4 xx1 + fillx
	$40 xx4 xx2 + fillx
	$80 xx4 xx2 + xx1 + fillx

	'ymask 0 256 fill
	$1 0 filly
	$2 yy1 filly
	$4 yy2 filly
	$8 yy1 yy2 + filly
	$10 yy4 filly
	$20 yy4 yy1 + filly
	$40 yy4 yy2 + filly
	$80 yy4 yy2 + yy1 + filly

|$octree drawiso
	;

|------ vista
#xm #ym
#rx #ry
:dnlook
	xypen 'ym ! 'xm ! ;

:movelook
	xypen
	ym over 'ym ! - neg 7 << 'rx +!
	xm over 'xm ! - 7 << neg 'ry +!  ;


:freelook
	xypen
	sh 1 >> - 7 << swap
	sw 1 >> - neg 7 << swap
	neg mrotx mroty ;

:drawchild | n --
	$ff0000 'ink !
	0 ( 8 <?
    	2dup noct3
		a@+ b@+ + 1 >>
		a@+ b@+ + 1 >>
		a@+ b@+ + 1 >>
        p3d
        4 box
		1 + ) 2drop ;

#xminb #yminb #xmaxb #ymaxb
#xmin #ymin #xmax #ymax

:getxy
   	2dup noct3
	a@+ b@+ + 1 >>
	a@+ b@+ + 1 >>
	a@+ b@+ + 1 >>
    p3d ;

:recchild | n --
	0 getxy
	dup 'ymin ! 'ymax !
	dup 'xmin ! 'xmax !
	1 +
	( 8 <?
		getxy
		ymin <? ( dup 'ymin ! )
		ymax >? ( dup 'ymax ! )
		drop
		xmin <? ( dup 'xmin ! )
		xmax >? ( dup 'xmax ! )
		drop
		1 + ) drop ;

:mainbox
	0 noct
	dup 'yminb ! 'ymaxb !
	dup 'xminb ! 'xmaxb !
	1 ( 8 <?
		dup noct
		yminb <? ( dup 'yminb ! )
		ymaxb >? ( dup 'ymaxb ! )
		drop
		xminb <? ( dup 'xminb ! )
		xmaxb >? ( dup 'xmaxb ! )
		drop
		1 + ) drop ;



:fillxx
	xmin xminb - 'xmask +
	xmax xmin - 1 + ( 1? 1 -
    	1 pick3 << pick2 c+!
    	swap 1 + swap ) 2drop ;

:fillyy
	ymin yminb - 'ymask +
	ymax ymin - 1 + ( 1? 1 -
             1 pick3 << pick2 c+!
    	     swap 1 + swap ) 2drop ;

#listch * 256

:fillall
	mainbox
	'xmask 0 256 fill
	'ymask 0 256 fill
	0 ( 8 <?
		recchild
		fillxx
		fillyy
		xmin xminb -
		ymin yminb - 16 << or
		xmax xmin - 1 + 16 <<
		xmaxb xminb - 1 >> 1 + /
		swap
		pick2 3 << 'listch + !+ !
		1 + ) drop ;

#colores $ffffff $ff0000 $00ff00 $ffff00 $0000ff $ff00ff $00ffff $888888

|--------------------------------------
:pp
   over and? ( b@+ ; ) 0 4 b+ ;

:drawxm
	'colores >b
	c@+ $1
	( $100 <?
		pp
		dup a!+ sw 1 - 2 << a+
		a!+ sw 1 - 2 << a+
		1 << ) 2drop ;

:drawym
	'colores >b
	c@+ $1
	( $100 <?
		pp
		dup a!+ a!+
		1 << ) 2drop ;

:drawrules
	'xmask
	xminb ( xmaxb <? swap
    	over 10 + yminb 30 - xy>v >a
		drawxm
		swap 1 + ) 2drop
	'ymask
	yminb ( ymaxb <?  swap
		xminb 30 - pick2 xy>v >a
		drawym
		swap 1 + ) 2drop ;

#ani

:main
	cls home gui

	Omode
	rx mrotx ry mroty
	xcam ycam zcam mtrans

    'dnlook 'movelook onDnMove

	fillstart
	fillveciso
	forma1
	drawcube
	drawire

	|isodraw

	fillall
	drawrules

    'listch 8 ( 1?  swap
       	@+ dup 16 >> "%d " print
        $ffff and "%d " print
        @+ "%f " print
        cr
      	swap 1 - ) 2drop

	key
	<f1> =? ( ani 1 xor 'ani ! )
	<up> =? ( -0.01 'zcam +! )
	<dn> =? ( 0.01 'zcam +! )
	<le> =? ( -0.01 'xcam +! )
	<ri> =? ( 0.01 'xcam +! )
	<pgup> =? ( -0.01 'ycam +! )
	<pgdn> =? ( 0.01 'ycam +! )
	>esc< =? ( exit )
	drop
	acursor ;

:
	mark
|	"media/3do/tie fighter.3do"
|	"media/3do/mario.3do"
	"media/3do/ldhorse.3do"
|	"media/3do/ovni31.3do"
	load3do 'octree !
	octree 3do!
	'main onshow ;
