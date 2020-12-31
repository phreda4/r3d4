|SCR 1280 720
|MEM $1ffff 64MB
||FULL

^r3/lib/gui.r3
^r3/lib/parse.r3

^r3/sys/r3base.r3

^r3/lib/fontr.r3

^media/rft/robotobold.rft

| xy wh str col
|-------------------
#zonas * 1024
#zonas> 'zonas

:xy>v 16 << swap $ffff and or ;

:v>xy dup 48 << 48 >> swap 16 >> ;

:c>2c | c1 -- c1 c2
	dup $f0f0f0 and dup 4 >> or
	swap $f0f0f and dup 4 << or ;

:2c>c | c1 c2 -- c1
	$f0f0f0 and swap
	4 >> $f0f0f and or ;

#nowa
#px #py
#nx #ny

:dnz
	a> 8 - dup 'nowa !
	@ v>xy 'ny ! 'nx !
	xypen 'py ! 'px !
	;
:movez
	xypen
	dup py - 'ny +! 'py !
	dup px - 'nx +! 'px !

	nx ny xy>v nowa !
	;

:czone | adr -- adr'
	>a
	a@+ v>xy a@+ v>xy guiBox
	'dnz 'movez onDnMoveA
	a@+ a@+ c>2c 'ink !
	guiFill
	'ink !
	swprint xr2 xr1 - swap - 1 >> xr1 +
	yr2 yr1 - cch - 1 >> yr1 +
	atxy
	emits
	a> ;

:zones
	'zonas ( zonas> <? czone ) drop ;

:z!+ | "" w h x y --
	zonas> >a
	xy>v a!+
	xy>v a!+
	a!+
	$00f00f a!+
	a> 'zonas> ! ;

:clearzone
	'zonas 'zonas> ! ;

|--------------
#vcode
#vcode>

:,tk | nro --
	vcode> !+ 'vcode> ! :

:rebuild
	clearzone

	;

|---------------------------
:teclado
	key
	>esc< =? ( exit )
	drop
	;

:main
	cls home gui
	robotobold 60 fontr!

	zones

	teclado
	acursor
	;

:mm
	mark
	here dup 'vcode ! 'vcode> !
	$ffff 'here +!
	robotobold 60 fontr!
	"dup" 160 cch 8 + 100 100 z!+
	"drop" 160 cch 8 + 100 180 z!+
	"swap" 160 cch 8 + 100 260 z!+
	;

: mm 'main onshow ;