| teris r3
| PHREDA 2020
|-------------------
^r3/lib/gui.r3
^r3/lib/rand.r3

#tablero * 800 | 10 * 20 * 4

#colores 0 $ffff $ff $ff8040 $ffff00 $ff00 $ff0000 $800080

#figuras
	1 5 9 13
	1 5 9 8
	1 5 9 10
	0 1 5 6
	1 2 4 5
	1 4 5 6
	0 1 4 5

#rota>
	8 4 0 0
	9 5 1 13
	10 6 2 0
	0 7 0 0

#suma
	$000 $001 $002 $003
	$100 $101 $102 $103
	$200 $201 $202 $203
	$300 $301 $302 $303

#jugador 0 0 0 0
#jugadors 0
#jugadorc 0
#puntos 0
#proxima 0
#velocidad 300

:tab2pant | n -- y x
    dup $ff and 4 << 50 +
	swap 8 >> 4 << 100 +
	;

:ficha | x y --
	2dup op
	over 15 + over pline
	over 15 + over 15 + pline
	over over 15 + pline
	pline poli ;

:dibuja_ficha | y x -- y x
	a@+ 0? ( drop ; ) 'ink !
	2dup or tab2pant ficha ;

:dibuja_tablero
	'tablero >a
	0 ( $1400 <?
		1 ( 11 <?
			dibuja_ficha
			1 + ) drop
		$100 + ) drop ;

:r>j
	dup @ 2 << 'rota> + @ swap ;

:rota>_ficha
	'jugador r>j !+ r>j !+ r>j !+ r>j ! ;

:j2t
	2 << 'suma + @ jugadors + ;

:j2f
	j2t
	tab2pant
	ficha ;

:dibuja_jugador
	jugadorc 'ink !
	'jugador @+ j2f @+ j2f @+ j2f @ j2f ;

:dpf
	2 << 'suma + @ 15 + tab2pant ficha ;

:dibuja_prox
	proxima dup 2 << 'colores + @ 'ink !
	1 - 4 << 'figuras +
	@+ dpf @+ dpf @+ dpf @ dpf ;

:rand1.7 | -- rand1..7
    ( rand dup 16 >> xor $7 and 0? drop ) ;

:nueva_ficha
	proxima
	'jugador
	over 1 - 4 << 'figuras +
	4 move | dst src cnt
	2 << 'colores + @ 'jugadorc !
	5 'jugadors !
	rand1.7 'proxima !
	;

:coord2f | coord -- realcoord
	dup $f and 1 - | x
	swap 8 >> 10 * +
	2 << 'tablero + ;

:check | pos -- 0/pos
	$1400 >? ( drop 0 ; )
	dup coord2f @ 1? ( 2drop 0 ; ) drop
	$ff and
	0? ( drop 0 ; )
	10 >? ( drop 0 ; )
	;

:colision | suma -- sumareal ; 0 encontro colision
	'jugador
	@+ j2t pick2 + check 0? ( nip nip ; ) drop
	@+ j2t pick2 + check 0? ( nip nip ; ) drop
	@+ j2t pick2 + check 0? ( nip nip ; ) drop
	@ j2t over + check 0? ( nip ; ) drop
	;

:rcolision | -- 0/1
	'jugador
	@+ 2 << 'rota> + @ j2t check 0? ( nip ; ) drop
	@+ 2 << 'rota> + @ j2t check 0? ( nip ; ) drop
	@+ 2 << 'rota> + @ j2t check 0? ( nip ; ) drop
	@ 2 << 'rota> + @ j2t check ;

:j2tt
	j2t coord2f jugadorc swap ! ;

#combo
#combop 0 40 100 300 1200

:bajalinea |
	'tablero dup 40 + swap a> pick2 - 2 >> move>
	-1 'velocidad +!
	4 'combo +! ;

:testlinea
	'combop 'combo !
	'tablero >a
	0 ( $1400 <?
		0 1 ( 11 <?
			a@+ 1? ( rot 1 + rot rot ) drop
			1 + ) drop
		10 =? ( bajalinea ) drop
		$100 + ) drop
	combo @ 'puntos +!
	;

:fija
	'jugador @+ j2tt @+ j2tt @+ j2tt @ j2tt
	testlinea
	nueva_ficha
	;

:logica
	$100 colision 0? ( drop fija ; )
	'jugadors +!
	;

:mueve
	colision 'jugadors +! ;

:rotar
	rcolision 0? ( drop ; ) drop
	rota>_ficha ;

#ntime
#dtime

:juego
	cls home
	$ff00 'ink !
	20 20 atxy "Tetris R3" print

	$444444 'ink !
	128 70 286 96 fillrect
	166 326 62 96 fillrect

	$ffffff 'ink !
	360 100 atxy puntos "%d" print

	dibuja_tablero
	dibuja_jugador
	dibuja_prox

	msec dup ntime - 'dtime +! 'ntime !
	dtime velocidad >? ( dup velocidad - 'dtime !
		logica
		) drop

	key
	>esc< =? ( exit )
	<dn> =? ( 250 'dtime +! )
	<ri> =? ( 1 mueve )
	<le> =? ( -1 mueve )
	<up> =? ( rotar )
	drop ;

:inicio
	0 'puntos !
	300 'velocidad !
	msec 'ntime ! 0 'dtime !
	rerand
	rand1.7 'proxima !
	'juego onshow
	;

: inicio ;