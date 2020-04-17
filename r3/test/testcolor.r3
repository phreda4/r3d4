| Color Wheel selector
| PHREDA 2020

^r3/lib/gui.r3
^r3/lib/btn.r3
^r3/lib/rand.r3
^r3/lib/input.r3
^r3/lib/sprite.r3
^r3/lib/vdraw.r3

^r3/util/loadimg.r3

#cwx 60 #cwy 100

#colorwimg |188x189
#c1 $ffffff
#c1x #c1y #c1w

#color $ffffff

::colorWheel! | color --
	rgb2hsv
	;

:setcolor | color --
	cwx 140 + cwy c1w + xy>v @ 'color !
	;

:selectColorWheel
	$999999 'ink !
	cwx 1 - cwy 1 - over 200 + over 160 + fillbox
	cwx cwy colorwimg sprite
	cwx 140 + cwy xy>v >a
	0 ( 128 <?
		c1 0 pick2 1 << colmix
		a> swap 10 fill sw 2 << a+
		1 + ) drop
	cwx cwy 128 128 guiBox
	[ xypen 2dup xy>v @ 0? ( 3drop ; ) 'c1 ! 'c1y ! 'c1x ! setcolor ; ] onMove
	cwx 138 + cwy 1 - 12 130 guiBox
	[ xypen nip cwy - 128 clamp0max 'c1w ! setcolor ; ] onMove


	$ffffff 'ink !
	c1x 2 - c1y 2 - over 4 + over 4 + rectbox
	cwx 138 + cwy c1w + 1 - over 14 + over 2 + rectbox
 	cwx 70 + cwy 138 + atxy
	color "$%h" print
	color 'ink !
	cwx 10 + cwy 134 + over 50 + over 20 + fillbox
	;


#pal8 * 300

#xpal 0 #ypal 200
#npal

:palbar
	$454545 'ink !
	xpal ypal
	over 60 + over 380 +
	fillbox

	color 'ink !
	xpal 10 + ypal 5 +
	40 30 guiBox
	guiFill

	'pal8
	0 ( 20 <?
		0 ( 3 <?
			rot @+ 'ink ! rot rot
        	over 4 << 41 + ypal +
			over 4 << 7 + xpal + swap
			14 14 guiBox
			guiFill
			over 3 * over +
			[ dup 'npal ! ink 'color ! ; ] onClick
			npal =? ( $ffffff 'ink ! guiBorde )
			drop
			1 + ) drop
		1 + ) 2drop ;

:setpaleta
	'pal8 >a
	$000000 a!+
	$888888 a!+
	$ffffff a!+
	0 ( 19 <?
		dup 1.0 19 */ 1.0 0.5 hsv2rgb a!+
		dup 1.0 19 */ 1.0 1.0 hsv2rgb a!+
		dup 1.0 19 */ 0.5 1.0 hsv2rgb a!+
		1 + ) drop
	;

|--------------------
:drawcircle
	0 'ink !
	400 64 - dup over 128 + over 128 + fillbox
	64 ( 0 >?
		0 ( 1.0 <?
			dup pick2 1.0 64 */ 1.0 hsv2rgb 'ink !
			400 400 pick2 pick4 ar>xy
|			bop bline
			op line
			0.0001 + ) drop
		1 - ) drop
	;

|--------------------
:main
	cls
	gui
    palbar
	selectColorWheel
	key
	>esc< =? ( exit )
	drop
	acursor
	;

:inimem
	mark
	"media/img/colorwheel.png" loadimg 'colorwimg !
	;

: inimem
	| $666666 'paper !
	| cls drawcircle
setpaleta
	'main onshow ;