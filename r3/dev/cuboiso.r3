| cubo isometrico
| PHREDA 2017
|-------------------
^r3/lib/gui.r3
^r3/lib/3d.r3
^r3/lib/gr.r3

|------------------------------
#xcam 0 #ycam 0 #zcam 0

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

#xmask * 1024
#ymask * 1024
#xmask1 * 512
#ymask1 * 512
#xmask2 * 256
#ymask2 * 256
#xmask3 * 128
#ymask3 * 128
#xmask4 * 64
#ymask4 * 64
#xmask5 * 32
#ymask5 * 32
#xmask6 * 16
#ymask6 * 16
#xmask7 * 8
#ymask7 * 8

#xmasl xmask xmask1 xmask2 xmask3 xmask4 xmask5 xmask6 xmask7 0
#ymasl ymask ymask1 ymask2 ymask3 ymask4 ymask5 ymask6 ymask7 0

:2/ 1 >> ;
:2* 1 << ;

|---------------
:fillstart | --
	'octvert >b
	1.0 1.0 1.0 transform b!+ b!+ b!+ | 111
	1.0 1.0 -1.0 transform b!+ b!+ b!+ | 110
	1.0 -1.0 1.0 transform b!+ b!+ b!+ | 101
	1.0 -1.0 -1.0 transform b!+ b!+ b!+ | 100
	-1.0 1.0 1.0 transform b!+ b!+ b!+ | 011
	-1.0 1.0 -1.0 transform b!+ b!+ b!+ | 010
	-1.0 -1.0 1.0 transform b!+ b!+ b!+ | 001
	-1.0 -1.0 -1.0 transform b!+ b!+ b!+ | 000
	b> 'octvert> !
	$ff $ff $ff transform 'x0 ! 'y0 ! 'z0 !
	$ff $ff -$ff transform 'x1 ! 'y1 ! 'z1 !
	$ff -$ff $ff transform 'x2 ! 'y2 ! 'z2 !
	-$ff $ff $ff transform 'x4 ! 'y4 ! 'z4 !
	-$ff -$ff -$ff transform
	x0 + 2/ 'x7 ! y0 + 2/ 'y7 ! z0 + 2/ 'z7 !
	;


| PERSPECTIVA
:id3d | x y z -- u v
	p3d ;

| ISOMETRICO
:id3d
	pick2 over - 0.03 / ox + >r
	rot + 2/ + 0.03 / oy + r> swap ;

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
	$7 xor 'mask ! ;

|-----------------------------------------
:getn | id -- z y x
	dup 2* + 2 << 'octvert +
	@+ swap @+ swap @ dup >r
	pick2 over - 0.03 / ox + >r
	rot + 2/ + 0.03 / oy + r>
	r> rot rot ;

#xx0 #yy0 #zz0
#xx1 #yy1 #zz1
#xx2 #yy2 #zz2
#xx4 #yy4 #zz4

#minx #miny #minz
#lenx #leny #lenz
#maxlev
#norden

#vecpos * 512

|-- bitmask to childmask
|  10110111 -- f0ff0fff
:b2b | b -- h
	dup 12 << $f0000 and swap $f and or
	dup 6 << $3000300 and swap $30003 and or | 3030303
	dup 3 << $10101010 and swap $1010101 and or
	dup 2 << or dup 1 << or ;


:raycast
	a@ $f0f0f colavg a!+ ;

:draw1
	minx miny xy>v >a
	sw lenx - 2 <<
	0 ( leny <?
		0 ( lenx <?
			raycast
			1 + ) drop
		over a+
		1 + ) 2drop ;
|-----------------------------------
:getyxmask | xy lev norden -- xy lev norden yxmask
	over 2 <<
	dup 'ymasl + @ pick4 12 >> $3ff and + c@
	swap 'xmasl + @ pick4 $3ff and + c@ and ;

|:getyxmask
|	adrx c@+ swap 'adrx ! precalcy and ;

:raytest | y x --
	over 12 << over or	| yx
	0 0 getyxmask
	0? ( 4drop 4 a+ ; )
	$7f0000 nip
	a!+
	3drop ;

:drawf | x y z --
	minx miny xy>v >a
	sw lenx - 2 <<
	0 ( leny <?
		0 ( lenx <?
|			rayfull
			raytest
			1 + ) drop
		over a+
		1 + ) 2drop ;

|-----------------------------------
|	0 0
|	xx1 -? ( rot + swap )( + )
|	xx2 -? ( rot + swap )( + )
|	xx3 -? ( rot + swap )( + )
|-- V1
:sminmax3 | a b c -- sn sx
	dup dup 63 >> dup
	not rot and rot rot and		| + -
	rot dup dup 63 >> dup
	not rot and rot rot and
	rot + >r + r>
	rot dup dup 63 >> dup
	not rot and rot rot and
	rot + >r + r> swap ;

|-- V2
:sminmax3 | a b c -- sn sx
	pick2 dup 63 >> not and
	pick2 dup 63 >> not and +
	over dup 63 >> not and + >r
	dup 63 >> and
	swap dup 63 >> and +
	swap dup 63 >> and +
	r> ;

:packxyz | x y z -- zyx
	zz0 + minz - 20 <<
	swap yy0 + miny - 10 << or
	swap xx0 + minx - or ;

:lbox | x1 y1 x2 y2
	2dup op pick3 over line 2over line
	over pick3 line line 2drop ;

:drawpanel | n --
	2 << 'vecpos + @
	dup $3ff and 2/ minx +
	swap 10 >> $3ff and 2/ miny +
	over lenx 2/ + over leny 2/ +
	lbox ;

#colores $ffffff $ff0000 $00ff00 $ffff00 $0000ff $ff00ff $00ffff $888888

|--------------------------------------
:pix
	and? ( b@+ ; )
	0 4 b+ ;

:drawxm
	'colores >b
	c@+ $1
	( $100 <?
		over pix
		dup a!+ sw 1 - 2 << a+
		a!+ sw 1 - 2 << a+
		2* ) 2drop ;

:drawym
	'colores >b
	c@+ $1
	( $100 <?
		over pix
		dup a!+ a!+
		2* ) 2drop ;

:drawrules
    0 ( 8 <?
    	dup 2 << 'colores + @ 'ink !
    	dup drawpanel
    	1 + ) drop
	'xmask
	0 ( lenx 2* <?  swap
    	over minx + miny 20 - xy>v >a
		drawxm
		swap 1 + ) 2drop
	'ymask
	0 ( leny 2* <?  swap
		minx 20 - pick2 miny + xy>v >a
		drawym
		swap 1 + ) 2drop
	;


|--------------------------------------
:fillx | child x --
	xx0 + minx - 2/ 'xmask +
	lenx 1 + 2/ ( 1? 1 - | child xmin len
		pick2 pick2 c+!
		swap 1 + swap ) 3drop ;

:filly | child x --
	yy0 + miny - 2/ 'ymask +
	leny 1 + 2/ ( 1? 1 - | child xmin len
		pick2 pick2 c+!
		swap 1 + swap ) 3drop ;

:calclev | len -- a:in b:out
	( 1? 1 -
		a@+ dup $ff00ff and swap 8 >> or $ff00ff and dup 8 >> or
		a@+ dup $ff00ff and swap 8 >> or $ff00ff and dup 8 >> or
		16 << or b!+
		) drop ;

:calclevel
	lenx 3 >> 'xmasl
	( @+ over @ 1?  | adr ms1 ms2
		>b >a over calclev
		swap 2/ swap ) 4drop
	leny 3 >> 'ymasl
	( @+ over @ 1?  | adr ms1 ms2
		>b >a over calclev
		swap 2/ swap ) 4drop
	;

:maskini
	'xmask 0 256 fill
	'ymask 0 256 fill
	;

:algo1
	0 getn 'xx0 ! 'yy0 ! 'zz0 !
	1 getn xx0 - 'xx1 ! yy0 - 'yy1 ! zz0 - 'zz1 !
	2 getn xx0 - 'xx2 ! yy0 - 'yy2 ! zz0 - 'zz2 !
	4 getn xx0 - 'xx4 ! yy0 - 'yy4 ! zz0 - 'zz4 !

    xx1 xx2 xx4 sminmax3 over - 1 + 'lenx ! xx0 + 'minx !
    yy1 yy2 yy4 sminmax3 over - 1 + 'leny ! yy0 + 'miny !
    zz1 zz2 zz4 sminmax3 over - 1 + 'lenz ! zz0 + 'minz !
	30 lenx leny min clz - 'maxlev ! | -2

	'vecpos >a
	0 0 0 packxyz a!+
	xx1 yy1 zz1 packxyz a!+
	xx2 yy2 zz2 packxyz a!+
	xx1 xx2 + yy1 yy2 + zz1 zz2 + packxyz a!+
	xx4 yy4 zz4 packxyz a!+
	xx4 xx1 + yy4 yy1 + zz4 zz1 + packxyz a!+
	xx4 xx2 + yy4 yy2 + zz4 zz2 + packxyz a!+
	xx4 xx1 + xx2 + yy4 yy1 + yy2 + zz4 zz1 + zz2 + packxyz a!+

	maskini
	$1 0 fillx
	$2 xx1 fillx
	$4 xx2 fillx
	$8 xx1 xx2 + fillx
	$10 xx4 fillx
	$20 xx4 xx1 + fillx
	$40 xx4 xx2 + fillx
	$80 xx4 xx2 + xx1 + fillx

	$1 0 filly
	$2 yy1 filly
	$4 yy2 filly
	$8 yy1 yy2 + filly
	$10 yy4 filly
	$20 yy4 yy1 + filly
	$40 yy4 yy2 + filly
	$80 yy4 yy2 + yy1 + filly

   	mask dup
	over 1 xor 4 << or
	over 2 xor 8 << or
	over 4 xor 12 << or
	over 3 xor 16 << or
	over 5 xor 20 << or
	over 6 xor 24 << or
	swap 7 xor 28 << or
	$88888888 or
	'norden !

	calclevel
    drawf
	drawrules
	;

;

|----------------------------------------
:dumpvar
	$ff00 'ink !
	minz miny minx "%d %d %d " print cr
	lenz leny lenx "%d %d %d " print cr

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

|-----------------------------------------
:main
	cls home gui
	over "%d" print cr

	Omode
	rx mrotx ry mroty
	xcam ycam zcam mtrans

	fillstart
	fillveciso
	calco

	dumpvar
	algo1
	drawire

    'dnlook 'movelook onDnMove
	key
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
	33
	mark
	'main onshow ;