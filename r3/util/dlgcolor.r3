| Color Select Dialog
| PHREDA 2020
|---------------


^r3/lib/gui.r3
^r3/lib/btn.r3
^r3/lib/input.r3
^r3/lib/sprite.r3

^r3/util/loadimg.r3

#xpal 0 #ypal 200
#cwx 60 #cwy 200

##color $ffffff

#colorwimg |188x189
#c1 $ffffff
#c1x #c1y #c1w

#pal8 * 300
#npal
#select 0

::color! | color --
	dup 'color !
	select 0? ( 2drop ; ) drop
	rgb2hsv | h s v
	128 16 *>> 128 swap - 'c1w !
	61 16 *>> | 61 cae en color siempre, deberia ser 64!
	cwx 68 + cwy 68 + 2swap
	xy+polar
	2dup xy>v @ 0? ( 3drop ; )
	'c1 ! 'c1y ! 'c1x !
	;

:setcolor | color --
	cwx 140 + cwy c1w + xy>v @
	dup 'color !
	'pal8 npal 2 << + !
	;

:selectColorWheel
	$999999 'ink !
	cwx cwy over 200 + over 160 + fillbox
	cwx 2 + cwy 2 + colorwimg sprite
	cwx 140 + cwy xy>v >a
	0 ( 128 <?
		c1 0 pick2 1 << colmix
		a> swap 10 fill sw 2 << a+
		1 + ) drop
	cwx 2 + cwy 2 + 128 128 guiBox
	[ xypen 2dup xy>v @ 0? ( 3drop ; ) 'c1 ! 'c1y ! 'c1x ! setcolor ; ] onMove
	cwx 138 + cwy 12 130 guiBox
	[ xypen nip cwy - 128 clamp0max 'c1w ! setcolor ; ] onMove

	$0 'ink !
	c1x 3 - c1y 3 - over 6 + over 6 + rectbox
	cwx 137 + cwy c1w + 2 - over 16 + over 4 + rectbox

	$ffffff 'ink !
	c1x 2 - c1y 2 - over 4 + over 4 + rectbox
	cwx 138 + cwy c1w + 1 - over 14 + over 2 + rectbox
 	cwx 70 + cwy 138 + atxy
	color $ffffffff and "$%h" print
	color 'ink !
	cwx 10 + cwy 134 + over 50 + over 20 + fillbox
	;

::dlgColor
	select 1? ( selectColorWheel ) drop

	$454545 'ink !
	xpal ypal
	over 60 + over 380 +
	fillbox

	color 'ink !
	xpal 10 + ypal 5 +
	40 30 guiBox
	guiFill
	[ select 1 xor 'select ! selectColorWheel color color! ; ] onClick

	'pal8
	0 ( 20 <?
		0 ( 3 <?
			rot @+ 'ink ! rot rot
        	over 4 << 41 + ypal +
			over 4 << 7 + xpal + swap
			14 14 guiBox
			guiFill
			over 3 * over +
			[ dup 'npal ! ink color! ; ] onClick
			npal =? ( $ffffff 'ink ! guiBorde )
			drop
			1 + ) drop
		1 + ) 2drop ;

::dlgColorIni
	"media/img/colorwheel.png" loadimg 'colorwimg !
	'pal8 >a
	$000000 a!+
	$888888 a!+
	$ffffff a!+
	0 ( 19 <?
		dup 1.0 19 */ 1.0 0.5 hsv2rgb a!+
		dup 1.0 19 */ 1.0 1.0 hsv2rgb a!+
		dup 1.0 19 */ 0.5 1.0 hsv2rgb a!+
		1 + ) drop
	$0 'color !
	;

::xydlgColor! | x y --
	over 60 + 'cwx !
	dup 'cwy !
	'ypal ! 'xpal ! ;