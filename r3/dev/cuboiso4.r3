|MEM 8192
| cubo isometrico
| PHREDA 2020
|-------------------
^r3/lib/gui.r3
^r3/lib/3d.r3
^r3/lib/gr.r3

|------------------------------
#xcam 0 #ycam 0 #zcam 0

#octree

#octvert * 3072 	| 32 niveles de 3 valores*8 vert
#octvert> 'octvert

#rotsum * 2048		| 32 niveles de 2 valores*8 vert
#rotsum> 'rotsum

#ymin #nymin
#xmin #nxmin
#zmin #nzmin

#ymax #nymax
#xmax #nxmax
#zmax

#mask

#x0 #y0 #z0
#x1 #y1 #z1
#x2 #y2 #z2
#x4 #y4 #z4

#x7 #y7 #z7	| centro del cubo
#n1 #n2 #n3

#xmask * 512
#ymask * 512

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
:id3d
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


:getp | n --
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
#sumy #sumx
#len

#vecpos * 128	| child vectors
#stacko * 128	| stack octree+nchildrens
#stacko> 'stacko

:stack2@ | -- a b
	stacko> 8 - dup 'stacko> !
	@+ swap @ ;

:stack2! | a b --
	stacko> !+ !+ 'stacko> ! ;

:stack4! | a b c d --
	stacko> !+ !+ !+ !+ 'stacko> ! ;


:addchild | bm 0 mask -- bm ch mask
	1 over <<
	pick3 nand? ( drop ; ) drop
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

:getyxmakl | len -- len bm
	'ymask sumy + dup c@ swap pick2	1 >> + 1 - c@ or
	'xmask sumx + dup c@ swap pick3 1 >> + 1 - c@ or
	and $ff and ;

:getyxmakl2 | len -- len bm
	'ymask sumy + c@
	'xmask sumx + c@
	and $ff and ;

:getyxmask0 | y x -- y x mask
	over 'ymask + c@
	over 'xmask + c@
	and $ff and	;

|--------------------------------------
| with octree
|--------------------------------------
:stack4@2 | -- a b
	stacko> 16 - dup 'stacko> !
	@+ 'sumy ! @+ 'sumx !
	@+ swap @ ;

:prevchild | len -- ordenn len
	1 >> 0? ( dup ; )
	stack4@2
	4 >>> 0? ( 2drop prevchild ; )
	swap >b swap ;

:nextchild | norden len -- norden len
	1 << swap		| len norden
	dup b> sumx sumy stack4!
	$7 and 1 over << 1 - >r
	4 << 'vecpos +
	@+ neg sumx + clamp0 1 << 'sumx !
	@ neg sumy + clamp0 1 << 'sumy !
    b@+ dup r> and popcnt swap 8 >> + 2 << b+
	getyxmakl	| len bm
	b@ and 0? ( drop prevchild ; )
	fillchild  |  len norden
	swap ;

:rayoctree | octree s y x -- octree s y x
	getyxmask0 0? ( drop 4 a+ ; )
	pick4 >b b@ and 0? ( drop 4 a+ ; )
	over 'sumx !
	pick2 'sumy !
	'stacko 'stacko> !
	fillchild	| norden
	1 ( len <?		| norden len
		nextchild	| norden len
		0? ( 2drop 4 a+ ; )
		b> $pixels >=? ( octcolor a!+ 2drop ; ) drop
		) 2drop
	b> octcolor a!+ ;

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
	dup dup 63 >> dup
	not rot and rot rot and		| + -
	rot
	dup dup 63 >> dup
	not rot and rot rot and
	rot + >r + r>
	rot
	dup dup 63 >> dup
	not rot and rot rot and
	rot + >r + r> swap ;

:sminmax3 | a b c -- sn sx
	pick2 dup 63 >> not and
	pick2 dup 63 >> not and +
	over dup 63 >> not and + >r
	dup 63 >> and
	swap dup 63 >> and +
	swap dup 63 >> and +
	r> ;

:packxyza!+ | x y z -- xyz0
	rot xx0 + minx - 1 >> a!+
	swap yy0 + miny - 1 >> a!+
	zz0 + minz - a!+
	0 a!+ ;

:fillx | child x --
	xx0 + minx - 1 >> 'xmask +
	lenx 1 >> ( 1? 1 - | child xmin len
		pick2 pick2 c+!
		swap 1 + swap ) 3drop ;

:filly | child x --
	yy0 + miny - 1 >> 'ymask +
	leny 1 >> ( 1? 1 - | child xmin len
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
	lenx leny min 2 >> 'len !
	'vecpos >a
	0 0 0 packxyza!+
	xx1 yy1 zz1 packxyza!+
	xx2 yy2 zz2 packxyza!+
	xx1 xx2 + yy1 yy2 + zz1 zz2 + packxyza!+
	xx4 yy4 zz4 packxyza!+
	xx4 xx1 + yy4 yy1 + zz4 zz1 + packxyza!+
	xx4 xx2 + yy4 yy2 + zz4 zz2 + packxyza!+
	xx4 xx1 + xx2 + yy4 yy1 + yy2 + zz4 zz1 + zz2 + packxyza!+

	'xmask 0 128 fill
	$1 0 fillx
	$2 xx1 fillx
	$4 xx2 fillx
	$8 xx1 xx2 + fillx
	$10 xx4 fillx
	$20 xx4 xx1 + fillx
	$40 xx4 xx2 + fillx
	$80 xx4 xx2 + xx1 + fillx

	'ymask 0 128 fill
	$1 0 filly
	$2 yy1 filly
	$4 yy2 filly
	$8 yy1 yy2 + filly
	$10 yy4 filly
	$20 yy4 yy1 + filly
	$40 yy4 yy2 + filly
	$80 yy4 yy2 + yy1 + filly

	octree 3do!
	$octree drawiso
	;

|----------------------------------------
:dumpvar
	$ff00 'ink !
	minz miny minx "%d %d %d " print cr
	lenz leny lenx "%d %d %d " print cr

|	'vecpos
|	8 ( 1? 1 - swap
|		@+ "xy:%h " print @+ "z:%h " print cr
|		swap ) 2drop

|	$ffff 'ink ! 0 getp 1 box
|	$ffffff 'ink ! mask getp 3 box
|	minx miny op minx lenx + miny leny + line
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
|-----------------------------------------
:main
	cls home gui
	pick2 pick2 "%d %d" print cr
	octree "%h" print cr
	Omode
	rx mrotx ry mroty
	xcam ycam zcam mtrans

	fillstart
	fillveciso
	calco

	dumpvar
|	drawire

	isodraw

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
|	"media/3do/mario.3do"
	"media/3do/ldhorse.3do"
	load3do 'octree !
	'main onshow ;
