| lunar lander
| PHREDA 2020

^r3/lib/gui.r3
^r3/lib/sprite.r3


#ship $3010010 | 16x16 paleta 8bits alpa, 4 colores
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

#fire $3008008 | 8x8 paleta 8bits alpha, 4 colores
$0 $ffffffff $ffffff00 $ffff0000
(
3 3 2 1 2 1 2 3
3 3 2 1 3 2 3 3
0 3 3 2 3 2 3 0
0 0 3 3 3 3 0 0
0 0 3 3 3 3 0 0
0 0 3 0 3 3 0 0
0 0 0 0 3 0 0 0
0 0 0 0 0 0 0 0
)

#grd * 1024
#fuel
#px #py
#pdx #pdy
#pthrust
#g

#adx #ady

#astars * 1024

:makeGround
	'grd >a
	rand sh 2 >> mod sh 1 >> +
	sh 1 >>
	256 ( 1? 1 - swap
		rand sh 4 >> mod +
		60 max
		dup a!+
		swap ) 3drop ;

:makeStars
	'astars >a
	256 ( 1? 1 -
		rand sw mod abs
		rand
		over 256 sw */ 2 << 'grd + @
		mod abs
		16 << or a!+
		) drop ;

:reset
	sw 1 >> 16 << 'px ! 10.0 'py !
	0 'pdx ! 0 'pdy !
	1000 'fuel !
	0.075 'pthrust !
	0.025 'g !
	makeGround
	makeStars
	;

:stars
	$ffffff 'ink !
	'astars >b
	100 ( 1? 1 -
		b@+
		dup $ffff and swap 16 >>
		pset
		) drop ;

:keyboard
	key
	<up> =? ( pthrust neg 'ady ! )
	<le> =? ( pthrust neg 'adx ! )
	<ri> =? ( pthrust 'adx ! )
	>up< =? ( 0 'ady ! )
	>le< =? ( 0 'adx ! )
	>ri< =? ( 0 'adx ! )
	>esc< =? ( exit )
	drop ;

:player
	fuel 0? (
		0 'adx ! 0 'ady !
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

	px 16 >> py 16 >>
	'ship sprite

	adx ady or 0? ( drop ; ) drop

	-1 'fuel +!
	px 16 >> 4 + py 16 >> 10 +
	msec $7 and +
	'fire sprite
	;


:ground
	$ff00 'ink !
	'grd >a
	0 a@+ op
	0 ( 255 <? 1 +
		dup sw 255 */ a@+ line
		) drop ;

:hitground? | -- +/-
	px sw / 8 >>
	2 << 'grd + @
	py 16 >> -
	;

:main
	cls home
	$ffffff 'ink !
	fuel "%d" print cr
	stars
	ground
	player
	hitground? -? ( reset ) drop
	keyboard
	;


: rerand reset 'main onshow ;


