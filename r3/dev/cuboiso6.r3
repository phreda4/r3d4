|MEM 32768
| cubo isometrico
| PHREDA 2020
|
|-------------------
^r3/lib/gui.r3
^r3/lib/3d.r3
^r3/lib/gr.r3

|------------------------------
#xcam 0 #ycam 0 #zcam 1.0

#octree

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
#n1 #n2 #n3

|---------------
:fillstart | --
	'octvert >b
	1.5 1.5 1.5 transform b!+ b!+ b!+ | 111
	1.5 1.5 -1.5 transform b!+ b!+ b!+ | 110
	1.5 -1.5 1.5 transform b!+ b!+ b!+ | 101
	1.5 -1.5 -1.5 transform b!+ b!+ b!+ | 100
	-1.5 1.5 1.5 transform b!+ b!+ b!+ | 011
	-1.5 1.5 -1.5 transform b!+ b!+ b!+ | 010
	-1.5 -1.5 1.5 transform b!+ b!+ b!+ | 001
	-1.5 -1.5 -1.5 transform b!+ b!+ b!+ | 000
	b> 'octvert> !
	$ff $ff $ff transform 'x0 ! 'y0 ! 'z0 !
	$ff $ff -$ff transform 'x1 ! 'y1 ! 'z1 !
	$ff -$ff $ff transform 'x2 ! 'y2 ! 'z2 !
	-$ff $ff $ff transform 'x4 ! 'y4 ! 'z4 !
	-$ff -$ff -$ff transform
	x0 + 1 >> 'x7 ! y0 + 1 >> 'y7 ! z0 + 1 >> 'z7 !
	;


| PERSPECTIVA
:id3d | x y z -- u v
	p3d ;

| ISOMETRICO
:id3d1  | x y z -- u v
	pick2 over - 0.03 / ox + >r
	rot + 1 >> + 0.03 / oy + r> swap ;

:fillveciso | --
	octvert> 96 - >b
	'rotsum
	b@+ b@+ b@+ id3d rot !+ !+
	b@+ b@+ b@+ id3d rot !+ !+
	b@+ b@+ b@+ id3d rot !+ !+
	b@+ b@+ b@+ id3d rot !+ !+
	b@+ b@+ b@+ id3d rot !+ !+
	b@+ b@+ b@+ id3d rot !+ !+
	b@+ b@+ b@+ id3d rot !+ !+
	b@+ b@+ b@ id3d rot !+ !+
	'rotsum> ! ;


:getp | n -- x y
	3 << 'rotsum + @+ swap @ swap ;

:drawire
	$ffffff 'ink !
	0 getp op 1 getp line 3 getp line 2 getp line 0 getp line
	4 getp op 5 getp line 7 getp line 6 getp line 4 getp line
	0 getp op 4 getp line 1 getp op 5 getp line
	2 getp op 6 getp line 3 getp op 7 getp line
	;

:calco
	x0 x1 - x7 * y0 y1 - y7 * + z0 z1 - z7 * + dup 'n1 ! 63 >> $1 and
	x0 x2 - x7 * y0 y2 - y7 * + z0 z2 - z7 * + dup 'n2 ! 63 >> $2 and or
	x0 x4 - x7 * y0 y4 - y7 * + z0 z4 - z7 * + dup 'n3 ! 63 >> $4 and or
	|$7 xor
	'mask ! ;

:getn | id -- z y x
	dup 1 << + 2 << 'octvert +
	@+ swap @+ swap @ dup >r
	pick2 over - 0.03 / ox + >r
	rot + 1 >> + 0.03 / oy + r>
	r> rot rot ;

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

|-----------------------------------------
#xx0 #yy0 #zz0
#xx1 #yy1 #zz1
#xx2 #yy2 #zz2
#xx4 #yy4 #zz4

#minx #miny #minz
#lenx #leny #lenz

#xx #yy #zz

#len

#norden
#vecpos * 256	| child vectors

#stacko * 256	| stack octree+nchildrens
#stacko> 'stacko

:stack2! | a b --
	stacko> !+ !+ 'stacko> ! ;

:stack2@ | -- a b
	stacko> 8 - dup 'stacko> !
	@+ swap @ ;

:addchild | bm 0 mask -- bm ch mask
	1 over <<
	pick3 na? ( drop ; ) drop
	swap 4 << over $8 or or swap ;

:fillchild | bitmask -- norden
	0
	mask addchild
	1 xor addchild	| 1 xor
	3 xor addchild	| 2 xor
	6 xor addchild	| 4 xor
	7 xor addchild	| 3 xor
	6 xor addchild	| 5 xor
	3 xor addchild	| 6 xor
	1 xor addchild	| 7 xor
	drop nip | $ffffffff and
	;

:getyxmask0 | y x -- y x maskal
    'vecpos >b
    0 $1 (
	    pick3 1 << b@+ - dup leny - not or
		pick3 1 << b@+ - dup lenx - not or
		8 b+ or not 63 >> | -1/0
		over and rot or swap 1 <<
		$100 <? ) drop ;

:inyxmask? | child -- child -1/0
	dup 4 << 'vecpos +
	yy over @ - dup leny - not or
	xx rot 4 + @ - dup lenx - not or
	or not 63 >> ;

|-------------------------------------------
:prevchild | len -- orden len
	1 >> 0? ( dup ; )
	stack2@ $ffffffff and
	dup $7 and 4 << 'vecpos +
	@+ yy 1 >> + 'yy !
	@+ xx 1 >> + 'xx !
	@ 'zz +!

	4 >>> 0? ( 2drop prevchild ; )
	swap >b swap ;

:nextchild | norden len -- norden len
	swap	| len norden
	0? ( drop prevchild ; )
	dup $7 and inyxmask?
	0? ( 2drop 4 >>> swap nextchild ; ) drop | len norden child
	1 over << 1 - >r
	swap b> stack2!	| len child

	4 << 'vecpos +
	@+ yy swap - 1 << 'yy !
	@+ xx swap - 1 << 'xx !
	@ neg 'zz +!

	1 <<			| len
	b@+ dup r> and popcnt swap 8 >> + 2 << b+
	b> $pixels >=? ( octcolor a! 0 ; ) drop
	b@ $ff and 0? ( drop prevchild ; )
	fillchild
	swap ;


:rayoctree | octree s y x -- octree s y x

	getyxmask0 0? ( drop 4 a+ ; )
	pick4 >b b@ and 0? ( drop 4 a+ ; )

|	pick3 >b b@ $ff and 0? ( drop 4 a+ ; )

	pick2 1 << 'yy ! over 1 << 'xx ! minz 'zz !

	'stacko 'stacko> !
	fillchild	| norden
	1 ( len <?	| norden len
		nextchild	| norden len
		0? ( 2drop 4 a+ ; )
		) 2drop
	b> octcolor a!+ ;

:rayoctree1 | octree s y x -- octree s y x
	getyxmask0 0? ( drop 4 a+ ; ) drop
	$ff00 a!+
	;

:drawiso | octree --
	minx miny xy>v >a
	sw lenx - 2 <<
	0 ( leny <?
		0 ( lenx <?
			rayoctree
			1 + ) drop
		over a+
		1 + ) 3drop ;

|--------------------------------------
|--------------------------------------
:sminmax3 | a b c -- sn sx
	pick2 dup 63 >> not and
	pick2 dup 63 >> not and +
	over dup 63 >> not and + >r
	dup 63 >> and
	swap dup 63 >> and +
	swap dup 63 >> and +
	r> ;

#maskz
#nmask

:inim
	0 'nmask ! 0 'maskz ! ;

:packxyza!+ | x y z -- xyz0
|	maskz <? ( nmask 'mask ! dup 'maskz ! )
|	1 'nmask +!

	swap yy0 + a!+
	swap xx0 + a!+
	zz0 + a!+
	0 a!+ ;

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

	inim
	'vecpos >a
	0 0 0 packxyza!+
	xx1 yy1 zz1 packxyza!+
	xx2 yy2 zz2 packxyza!+
	xx1 xx2 + yy1 yy2 + zz1 zz2 + packxyza!+
	xx4 yy4 zz4 packxyza!+
	xx4 xx1 + yy4 yy1 + zz4 zz1 + packxyza!+
	xx4 xx2 + yy4 yy2 + zz4 zz2 + packxyza!+
	xx4 xx1 + xx2 + yy4 yy1 + yy2 + zz4 zz1 + zz2 + packxyza!+

	$octree drawiso
	;

|----------------------------------------
:lbox | x1 y1 x2 y2
	2dup op pick3 over line 2over line
	over pick3 line line 2drop ;

:box | x y r --
	>r
	over r@ - over r@ - 2swap r@ + swap r> + swap
	lbox ;

:dumpvar
	$ff00 'ink !

	minz miny minx "%d %d %d " print cr
	lenz leny lenx "%d %d %d " print cr

	$ffff 'ink ! 0 getp 2 box
	$ffffff 'ink ! mask getp 3 box
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

#ani 0

#mseca

|-----------------------------------------
:main
	cls home gui
	pick2 pick2 "%d %d" print cr
	msec dup mseca - "%d msec" print cr 'mseca !

	Omode
	rx mrotx ry mroty
	xcam ycam zcam mtrans

	fillstart
	fillveciso
|	calco

	dumpvar

	isodraw

|	drawire

	ani 1? ( 0.005 'ry +! ) drop
    'dnlook 'movelook onDnMove
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
	34
	33
	mark
|	"media/3do/tie fighter.3do"
	"media/3do/mario.3do"
|	"media/3do/ldhorse.3do"
|	"media/3do/ovni31.3do"
	load3do 'octree !
	octree 3do!
	'main onshow ;
