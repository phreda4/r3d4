| Libreria de tileset
| tileset from Silveira Neto
|   http://silveiraneto.net/2011/08/20/getting-openpixels/
| PHREDA 2020

|MEM $ffff

^r3/lib/gui.r3
^r3/util/loadimg.r3

|----------------- LIB BUILD
#tilesheet
#tilearray
#cnttiles

#tadvi
#tadsr
#tnext

#tilew #tileh
#tw #th

::tileinit | w h "imgfile" --
	loadimg 0? ( 3drop ; )
	dup 'tilesheet !
	spr.wh 'tileh ! 'tilew !
	'th ! 'tw !

	tilew tw - 2 << 'tadvi !
	sw tw - 2 << 'tadsr !
	th sw * tw - neg 2 << 'tnext !

	here dup >a 'tilearray !
	tilesheet 4 + >b
	0 ( tileh <?
		0 ( tilew <?
			b> a!+
			tw dup 2 << b+
			+ ) drop
		th dup 1 - tilew * 2 << b+
		+ ) drop
	a> dup tilearray - 2 >> 'cnttiles !
	'here !
	;

::drawtile | nro --
	2 << tilearray + @ >b
	th ( 1? 1 -
		tw ( 1? 1 - b@+ a!+ ) drop
		tadvi b+
		tadsr a+ ) drop
	tnext a+ ;

::drawtilev | nro --
	2 << tilearray + @ >b
	th ( 1? 1 -
		tw 2 << a+
		tw ( 1? 1 - b@+ a! -4 a+ ) drop
		tadvi b+
		tadsr tw 2 << + a+ ) drop
	tnext a+ ;

::drawtilei | nro --
	2 << tilearray + @
	th 1 - tilew * 2 << + >b
	th ( 1? 1 -
		tw ( 1? 1 - b@+ a!+ ) drop
		tilew tw + 2 << neg b+
		tadsr a+ ) drop
	tnext a+ ;

::drawtileiv | nro --
	2 << tilearray + @
	th 1 - tilew * 2 << + >b
	th ( 1? 1 -
		tw 2 << a+
		tw ( 1? 1 - b@+ a! -4 a+ ) drop
		tilew tw + 2 << neg b+
		tadsr tw 2 << + a+ ) drop
	tnext a+ ;

#testmap
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79
2 20 32 42 2 2 2 2 2 2 2 2 2 2 2 2
3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3
4 5 4 4 5 4 6 5 4 7 5 6 4 5 6 4
6 7 8 6 4 3 4 5 6 7 8 9 8 5 4 6
6 7 8 6 4 3 4 5 6 7 8 9 8 5 4 6

:drawmap
	'testmap
	0 ( 6 <?
		0 over 32 * xy>v >a
		0 ( 16 <? 1 +
			rot @+ drawtile
			rot rot ) drop
		1 + ) 2drop ;

|-----------------
#nroi
#nroa

:drawpal | --
	nroi
	0 ( 14 <?
		160 over 1 + 32 * xy>v >a
		0 ( 15 <? 1 +
			rot dup drawtile 1 +
			rot rot ) drop
		1 + ) 2drop ;


:drawtilepal | --
	nroi
	0 ( 14 <?
    	8 over 1 + 32 * xy>v >a
		swap dup drawtile 1 +
		swap ) 2drop ;

:main
	cls home gui
	nroi "%d" print

	drawpal
	|drawtilepal

	key
	<up> =? ( nroi 15 - clamp0 'nroi ! )
	<dn> =? ( nroi 15 + cnttiles 15 14 * - clampmax 'nroi ! )
	>esc< =? ( exit )
	drop
	acursor
	;

:inimem
	mark
	cls "cargando..." print redraw
	32 32
	"media/img/open_tileset.old.png"
	tileinit
	;

: inimem 'main onShow ;