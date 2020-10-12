| lunar lander
| PHREDA 2020

^r3/lib/gui.r3
^r3/lib/sprite.r3


#ship $2010010 | 16x16 paleta 8bits opaque, 4 colores
$0 $ff00ff00 $ff0000ff 0  | color0 color1 color2 color3
(
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0
0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0
0 0 0 1 1 1 2 2 2 2 1 1 1 0 0 0
0 0 1 1 2 2 2 2 2 2 2 2 1 1 0 0
0 0 1 1 2 2 2 2 2 2 2 2 1 1 0 0
0 0 1 1 2 2 2 2 2 2 2 2 1 1 0 0
0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0
0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0
0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0
0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0
0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0
0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0
0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0
0 1 1 0 0 0 0 0 0 0 0 0 0 1 1 0
)

#grd * 1024
#fuel
#px #py
#pdx #pdy
#pthrust
#g

#adx #ady

:makePlayer
	;

:makeGround
	'grd >a
	rand sh 2 >> mod sh 1 >> +
	sh 1 >>
	256 ( 1? 1 - swap
		rand sh 4 >> mod +
		dup a!+
		swap ) 2drop ;

:reset
	sw 1 >> 16 << 'px ! 10.0 'py !
	0 'pdx ! 0 'pdy !
	1000 'fuel !
	0.075 'pthrust !
	0.025 'g !
	makePlayer
	makeGround
	;

:stars
	;

:keyboard
	key
	<up> =? ( pthrust neg 'ady ! )
	<le> =? ( pthrust neg 'adx ! )
	<ri> =? ( pthrust 'adx ! )
	>up< =? ( 0 'ady ! )
	>le< =? ( 0 'adx ! )
	>ri< =? ( 0 'adx ! )
	<f1> =? ( makeGround )
	>esc< =? ( exit )
	drop ;

:player
	fuel 0? (
		0 'adx ! 0 'ady !
		) drop

	adx ady or 1? (
		-1 'fuel +!
		) drop

	ady g + 'pdy +!
	adx 'pdx +!
	pdx 'px +!
	pdy 'py +!
	px
	0 <? ( 0 'px ! 0 'pdx ! )
	sw 16 << >? ( sw 16 << 'px ! 0 'pdx ! )
	drop
	py
	-3 <? ( -3 'py ! 0 'pdy ! )
	drop

	px 16 >> py 16 >> 'ship sprite
	;


:ground
	$ff00 'ink !
	'grd >a
	0 a@+ op
	0 ( 255 <? 1 +
		dup sw 255 */ a@+ line
		) drop ;

:main
	cls home
	$ffffff 'ink !
	fuel "%d" print
	stars
	ground
	player

	keyboard
	;


: reset 'main onshow ;


