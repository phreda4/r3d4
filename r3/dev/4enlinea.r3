| PHREDA 2020
| 4 in ROW

^r3/lib/gui.r3
^r3/lib/sprite.r3
^r3/util/miniscr.r3

^r3/lib/trace.r3

#ficha $2010010 | 16x16 paleta 8bits opaque, 4 colores
$FFFF00 $00 0 0
(
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0
0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0
0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0
0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0
0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0
0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0
0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0
0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0
0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0
0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0
0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0
0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
)

#tablero
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
3 3 3 3 3 3 3

#fichacol $0 $ff $ff0000
:dibujaficha | y x t f
	pick2 16 * 56 +
	pick4 16 * 192 4 / +
	rot
	4 * 'fichacol + @ 'ficha 8 + !
	'ficha sprite
	;

:dibujatablero
	'tablero
	0 ( 6 <?
		0 ( 7 <?
			rot @+ dibujaficha rot rot
		1 + ) drop cr
	1 + ) 2drop ;

#columna 0
#turno 1

:cambiaturno
	turno
	3 xor | bit trick
	'turno ! ;

:xy-tab | x y -- ad
	7 * + 2 << 'tablero + ;

|------- horizontal
:primeroizq | x y -- x y
	( swap 1 - -? ( 1 + swap ; ) swap
		2dup xy-tab @ turno =? drop ) drop
	swap 1 + swap ;

:iguales  | x y -- x
	( 2dup xy-tab @ turno =? drop swap 1 +
		6 >? ( nip 1 - ; )
		swap )
	2drop 1 - ;

:ganah? | x y -- score
	primeroizq over swap iguales swap - ;

|------- diagonal
:primerod1 | x y -- xi yi
	(   1 - -? ( 1 + ; ) swap
		1 - -? ( 1 + swap 1 + ; ) swap
		2dup xy-tab @ turno =? drop ) drop
	swap 1 + swap 1 + ;

:igualesd1  | x y -- x
	( 2dup xy-tab @ turno =? drop
		1 + swap 1 +
		6 >? ( nip 1 - ; )
		swap )
	2drop 1 - ;

:ganad1? | x y -- score
	primerod1 over swap igualesd1 swap - ;

:primerod2 | x y -- xi yi
	(   1 + swap
		1 - -? ( 1 + swap 1 - ; )
		swap
		2dup xy-tab @ turno =? drop ) drop
	swap 1 + swap 1 - ;

:igualesd2  | x y -- x
	( 2dup xy-tab @ turno =? drop
		1 - swap 1 +
		6 >? ( nip 1 - ; )
		swap )
	2drop 1 - ;

:ganad2? | x y -- score
	primerod2 over swap igualesd2 swap - ;

|------- vertical
:ganav? | x y -- score
	swap over
	( 1 + 2dup xy-tab @ turno =? drop ) drop
	nip 1 - swap - ;

:gana? | x y -- x y g
	2dup ganah? 2 >? ( nip nip ; ) drop
	2dup ganav? 2 >? ( nip nip ; ) drop
	2dup ganad1? 2 >? ( nip nip ; ) drop
	ganad2? ;


:caerficha | c -- x y
	0 ( 2dup xy-tab @ 0? drop 1 + ) drop 1 - ;

#maxscore 0
#colscore 0

:calscore | x y -- score
	-? ( 2drop -10 ; )
	2dup xy-tab turno swap !
	2dup ganah? >a
	2dup ganav? a> max >a
	2dup ganad1? a> max >a
	2dup ganad2? a> max >a
	xy-tab 0 swap !
	a> ;

:scorecol
	$ffffff 'ink !
	0 ( 7 <?
		dup 16 * 60 + 0 atxy
		dup caerficha calscore "%d" print
		dup 16 * 60 + 12 atxy
		dup caerficha cambiaturno calscore cambiaturno "%d" print
		1 + ) drop ;


:gano?
	turno 1 =? ( drop "azul" ; )
	drop "rojo" ;

:fintablero
	cls
	$ffffff 'ink !
	" Gano " print
	gano? print
	dibujatablero
	minidraw
	key
	>esc< =? ( exit )
	drop ;

:poneficha
	columna caerficha
	-? ( 2drop ; )

	2dup xy-tab turno swap ! | pone ficha
	gana? 2 >? ( drop 'fintablero onshow exit ; ) drop

    cambiaturno
	;


:colorturno
	turno
	1 =? ( drop $ff 'ficha 8 + ! ; ) drop
	$ff0000 'ficha 8 + ! ;

:fichausuario
	$0 'ficha 4 + !
	colorturno
	columna 16 * 56 +
	192 4 / 16 -
	'ficha sprite
	$ffff00 'ficha 4 + !
	;

:main
	cls
	fichausuario
	dibujatablero
	scorecol
	minidraw

	key
	>esc< =? ( exit )
	<ri> =? ( columna 1 + 6 min 'columna ! )
	<le> =? ( columna 1 - 0 max 'columna !  )
	<dn> =? ( poneficha )
	drop
	acursor ;

:
	mark
	224 192 miniscreen
	'main onshow ;
