| test de tileset
| PHREDA 2020
|MEM $ffff

^r3/lib/gui.r3
^r3/lib/btn.r3
^r3/lib/input.r3
^r3/lib/sprite.r3
^r3/util/loadimg.r3

^media/ico/tool16.ico

#testmap (
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
1 2 2 3 3 3 3 4 4 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 3 3 4 4 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 3 3 4 4 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 0 0 0 0 0 0 0 1
1 2 2 0 3 3 3 4 4 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 0 3 3 3 4 4 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 0 3 3 3 4 4 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 0 0 0 0 0 0 0 1
1 2 2 3 3 0 3 4 4 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 0 3 4 4 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 0 3 4 4 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 0 0 0 0 0 0 0 1
1 2 2 3 3 3 3 0 9 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 3 3 0 9 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 3 3 0 9 4 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 0 0 0 0 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 4 4 0 0 0 0 0 0 0 1
1 2 2 3 3 3 3 9 9 0 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 3 3 9 9 0 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 3 3 9 4 0 4 5 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 0 0 0 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 0 0 0 0 0 0 0 1
1 2 2 3 3 3 3 9 4 4 4 0 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 3 3 9 4 4 4 0 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 3 9 9 4 4 4 0 5 5 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 0 0 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 0 0 0 0 0 0 0 1
1 2 2 3 3 3 9 4 4 4 4 5 5 0 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 3 9 4 4 4 4 5 5 0 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 3 9 4 4 4 4 5 5 0 6 7 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 0 0 0 9 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 0 0 0 0 0 0 0 1
1 2 2 3 9 9 9 4 4 4 4 5 5 5 6 0 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 9 9 9 4 4 4 4 5 5 5 6 0 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 2 2 3 3 3 3 4 4 4 4 5 5 5 6 0 8 8 8 0 0 0 0 0 0 1 2 3 0 0 1
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 0 0 0 0 0 0 0 1
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )

#resxmap 32
#resymap 32
#adrmap

#tileink
#sprtile

#xcam 0.0
#ycam 0.0

#wtilemap 31
#htilemap 33

#wcam 10
#hcam 14

#xini #yini
#xlim #ylim
#xi #yi
#xii #yii


#tileini 0
#tilenow 0
#xipal
#yipal


:drawt | dib --
	0? ( drop ; )
	xi yi sprTile ssprite ;


:clickmap
	xypen
	yii - 32 / wtilemap * swap
	xii - 32 / +
	'testmap
	ycam 16 >> wtilemap * xcam 16 >> + +
	+
	tilenow swap c!
	;

:drawtilemap
	xcam 11 >> $1f and neg xini + dup 'xii ! 'xi !
	ycam 11 >> $1f and neg yini + dup 'yii ! 'yi !
	'testmap
	ycam 16 >> wtilemap * xcam 16 >> + +

	hcam ( 1? 1 -
		wcam ( 1? 1 -
			rot c@+ drawt
			rot rot
			32 'xi +!
			) drop
		swap wtilemap wcam - + swap
		xii 'xi !
		32 'yi +!
		) 2drop

	xii yii
	32 wcam * 32 hcam *
	guiBox
	'clickmap onMove
	;

:wintilemap | x1 y1 x2 y2 --
	'hcam !
	'wcam !
	dup 'yini ! hcam swap - 32 / 'hcam !
	dup 'xini ! wcam swap - 32 / 'wcam !
	wtilemap wcam - 16 << 'xlim !
	htilemap hcam - 16 << 'ylim !
	;

|-------------------

:tilecur
	xi yi over 31 + over 31 +
	$ffffff 'ink ! rectbox
	;

:clicktile
	xypen 
	yipal - 32 / 10 * swap
	xipal - 32 / +
	tileini + 'tilenow !
	;

:drawpaleta
	yipal 'yi !
	xipal 'xi !
	tileini
	10 ( 1? 1 -
		10 ( 1? 1 -
			rot dup	xi yi
			sprTile ssprite
			tilenow =? ( tilecur )
			1 + rot rot
			32 'xi +!
			) drop
		32 'yi +!
		xipal 'xi !
		) 2drop
	xipal yipal
	32 10 * 32 10 *
	guiBox
	'clicktile onClick

	;


#imodes 'i_draw 'i_eye 'i_star 'i_pencil 'i_tool 0
#nmode

:main
	cls home gui
	cols dup 1 >> swap 2 >> + 0 gotoxy
	sp 'nmode 'imodes ibtnmode
	$ff0000 'ink !
	'exit 'i_exit ibtnf
	$ff00 'ink !
	50 2 gotoxy
	"X:" print 'resxmap inputint
	"  Y:" print 'resymap inputint


	drawtilemap
	drawpaleta
	key
	>esc< =? ( exit )
|	<up> =? ( -1.0 ycam + 0.0 max 'ycam ! )
|	<dn> =? ( 1.0 ycam + ylim min 'ycam ! )
|	<le> =? ( -1.0 xcam + 0.0 max 'xcam ! )
|	<ri> =? ( 1.0 xcam + xlim min 'xcam ! )

	<le> =? ( tilenow 1 - 0 max 'tilenow ! )
	<ri> =? ( 1 'tilenow +! )
	<up> =? ( tilenow 10 - 0 max 'tilenow ! )
	<dn> =? ( 10 'tilenow +! )

	drop
	acursor
	;

|-------------------
:inimem
	$696969 'paper !
	mark
	cls home "cargando..." print redraw

	32 32
	"media/img/open_tileset.old.png"
	loadimg tileSheet 'sprtile !

	0 0 sw 1 >> sh wintilemap

	sw 1 >> 32 + 'xipal !
	64 'yipal !

	;

: inimem 'main onShow ;