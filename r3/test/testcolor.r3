| Color Wheel selector
| PHREDA 2020

^r3/lib/gui.r3
^r3/lib/btn.r3
^r3/lib/rand.r3
^r3/lib/input.r3
^r3/lib/sprite.r3
^r3/lib/vdraw.r3

^r3/util/loadimg.r3

#colorwimg |188x189
#c1 $ffffff
#color $ffffff
#cwx 10 #cwy 100
#c1x #c1y
#c1w

:colorWheel! | color --
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
	[ xypen 2dup xy>v @ 0? ( 3drop ; ) 'c1 ! 'c1y ! 'c1x ! ; ] onMove
	cwx 138 + cwy 1 - 12 130 guiBox
	[ xypen nip cwy - 128 clamp0max 'c1w ! ; ] onMove
	cwx 140 + cwy c1w + xy>v @ 'color !

	$ffffff 'ink !
	c1x 2 - c1y 2 - over 4 + over 4 + rectbox
	cwx 138 + cwy c1w + 1 - over 14 + over 2 + rectbox
 	cwx 70 + cwy 138 + atxy
	color "$%h" print
	color 'ink !
	cwx 10 + cwy 134 + over 50 + over 20 + fillbox
	;

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

:main
	cls
	gui
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
	'main onshow ;