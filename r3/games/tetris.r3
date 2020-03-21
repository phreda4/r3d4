| teris r3
| PHREDA 2020
|-------------------
^r3/lib/gui.r3
^r3/lib/rand.r3

#tablero * 800

#colores 0 $ffff $ff $ff8040 $ffff00 $ff00 $ff0000 $800080

#figuras
	1 5 9 13
	1 5 9 8
	1 5 9 10
	0 1 5 6
	1 2 4 5
	0 1 4 5
	1 4 5 6

#suma
	0 1 2 3
	10 11 12 13
	20 21 22 23
	30 31 32 33

#jugador 0 0 0 0
#jugadors 0

#rota>
	8 4 0 0
	9 5 1 13
	10 6 2 0
	0 7 0 0

#rota<
	2 6 10 0
	1 5 9 13
	0 4 8 0
	0 7 0 0

:ficha | x y --
	2dup op
	over 15 + over pline
	over 15 + over 15 + pline
	over over 15 + pline
	pline poli ;

:dibuja.ficha | y x -- y x
	a@+ 0? ( drop ; )
	2 << 'colores + @ 'ink !
	dup 16 * 100 +
	pick2 16 * 50 +
	ficha ;

:dibuja.tablero
	'tablero >a
	0 ( 20 <?
		0 ( 10 <?
			dibuja.ficha
		1 + ) drop
	1 + ) drop ;


:dibuja.jugador
	'jugador >a
	a@+ 'ink !
	0 ( 4 <?
		a@+
		dup 10 / 16 * 50 +
		swap 10 mod 16 * 100 +
		swap ficha
		1 + ) drop ;

:nueva_ficha
	'jugador >a
	( rand $7 and 0? drop )
	2 << 'colores + @ a!+
	( rand $7 and 0? drop )
	1 -
	16 * 'figuras + 
	'jugador swap 4 move
	;

:baja_ficha
	10 'jugadors +! ;

:rota_ficha
	;

:juego
	cls home
	$ff00 'ink !
	"tetris" print
	'jugador
	@+ "%d " print
	@+ "%d " print
	@+ "%d " print
	@ "%d " print

	dibuja.tablero
	dibuja.jugador

	key
	>esc< =? ( exit )
	<f1> =? ( nueva_ficha )
	<f2> =? ( baja_ficha )
	drop ;

:inicio
	'juego onshow
	;

: inicio ;