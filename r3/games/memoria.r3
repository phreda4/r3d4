| MEMOCARD
| PHREDA 2013,2020
|--------------
^r3/lib/gui.r3
^r3/lib/rand.r3
^r3/lib/btn.r3
^r3/lib/3d.r3

^r3/lib/fontr.r3
^r3/lib/fontr3d.r3

^media/ric/efon.ric
^media/rft/gooddog.rft

#cartascnt 20
#cartas * 1024
#cartase * 1024

:]nro 2 << 'cartas + ;
:]est 2 << 'cartase + ;

#tiempo

#carta1
#carta2
#estado
#puntos
#intentos

#filas
#columnas
#zcam
#pxcarta

#riccnt 40 	| cantidad de dibujos
#cartasric
i.quotedbl i.percent i.ampersand i.quotesingle i.parenleft i.parenright i.asterisk i.plus
i.comma i.less i.equal i.greater i.question i.at i.A i.B i.C i.D i.E i.F i.G i.H i.I
i.L i.M i.N i.O i.P i.Q i.R i.S i.T i.U i.V i.W i.X i.Y i.Z i.bracketleft i.backslash

:3dop project3d op ;
:3dpline project3d pline ;

:3dbox | size --
	dup dup 0 project3d 2dup op
	rot
	dup neg over 0 3dpline
	dup neg dup 0  3dpline
	dup neg 0 3dpline
	pline poli ;

:cartaback
	$ff 'ink ! 1.05 3dbox
	;

:cartafront | nro --
	$0 'ink ! 1.05 3dbox
	$ffffff 'ink ! 0.98 3dbox

	]nro @
	dup 8 >> 'ink !
	$ff and 2 << 'cartasric + @
	remit3d
	;

:elijecarta | n --
	carta1 -? ( drop 'carta1 ! ; ) drop
	carta1 =? ( drop ; )
	carta2 -? ( drop 'carta2 ! ; ) drop
	drop ;

:clickCarta
	bpen 0? ( drop ; ) drop
	xypen inscreen
	rot - abs pxcarta >? ( 3drop ; )
	drop - abs pxcarta >? ( drop ; ) drop
	dup elijecarta ;

:drawcartam | nro --
	dup ]nro @ $ff and $ff =? ( 2drop ; ) drop
	mpush
	clickCarta
	dup ]est @ dup mrotyi
	0.25 - oxyztransform nip atan2 + | correccion por vista
	$ffff and 0.5 <? ( 2drop cartaback mpop ; )
	drop cartafront mpop ;



:printmazog
	columnas 2.2 * 1 >> 1.1 + neg
	filas 2.2 * 1 >> 1.1 - neg
	0 mtransi
	0
	filas ( 1? 1 -
		columnas ( 1? 1 -
			2.2 0 0 mtransi
			rot dup drawcartam 1 + rot rot
			) drop
		columnas 2.2 * neg 2.2 0 mtransi
		) 2drop
	;

|------- cartas
:resetelije
	-1 dup 'carta1 ! 'carta2 ! 0 'estado ! ;

:llenacartas
	'cartas >b
	cartascnt 1 >>
	( 1? 1 -
		dup rand 1.0 1.0 hsv2rgb 8 << or
		dup b!+ b!+
		) drop ;

:swapcarta
	]nro dup @ rot ]nro rot over @ swap ! ! ;

:mexclacartas
	msec 'seed !
	200 ( 1? 1 -
		rand abs cartascnt mod
		rand abs cartascnt mod
		swapcarta
		) drop
	;

:mezclagiro
	'cartase >a
	cartascnt ( 1? 1 -
		rand a!+ ) drop ;

:cartasgiro
	'cartase >a
	cartascnt ( 1? 1 -
		0.01 a> +! 4 a+ ) drop ;

:esconder
	'cartase >a
	cartascnt ( 1? 1 -
		0.5 a!+ ) drop ;

:giracarta | nro -- nro
	]est dup @
	0 >? ( 0.02 - swap ! ; )
	0 nip 1 'estado +! swap ! ;

:descubriendo
	0 'estado !
	carta1 0 >=? ( dup giracarta ) drop
	carta2 0 >=? ( dup giracarta ) drop
	;

:vuelvecarta | nro -- nro
	]est dup @
	0.5 <? ( 0.02 + swap ! ; )
	0.5 nip 1 'estado +! swap ! ;

:encubriendo
	500 'estado !
	carta1 vuelvecarta
	carta2 vuelvecarta
	estado 502 <? ( drop ; )
	resetelije ;

:coincidencia
	$ff carta1 ]nro !
	$ff carta2 ]nro !
	2 'puntos +!
	puntos cartascnt =? ( exit ) drop
	resetelije ;

:check
	1 'estado +!
	carta1 ]nro @
	carta2 ]nro @
	=? ( coincidencia ) drop
	1 'intentos +!
	;

:accionmazo
	estado
	3 <? ( descubriendo )
	1 >? ( 1 'estado +! )
	20 =? ( check )
	20 >? ( encubriendo )
	drop
	;

:calcdim
	cartascnt sqrt dup 'filas !
	dup * cartascnt swap -
	filas / filas + 'columnas !
	filas columnas max 1.8 * 2.0 + 'zcam !
	omode
	0 0 zcam mtrans
	1.0 0 0 projectdim drop 'pxcarta !
	;

:juego
	cls home gui
|		dup "%d" print cr
|		pxcarta "%d" print cr
|		carta1 carta2 "%d %d" print cr
|		filas columnas "%d %d " print

	omode
	0 0 zcam mtrans
	printmazog
	accionmazo

	$ff0000 'ink !
	gooddog 64 fontr!
	intentos puntos 1 >> " %d/%d" print

	'exit >esc<
	acursor
	;

:accion
	llenacartas
	mexclacartas
	esconder
	0 'puntos !
	0 'intentos !
	resetelije
	'juego onshow
	;

:pantallaf
	cls home gui
	'exit onClick
	omode
	0 0 zcam mtrans
	printmazog
	cartasgiro
	gooddog 64 fontr!
	cr
	$ff0000 'ink !
	"Fin de juego" printc
	cr cr
	$ff00 'ink !
	intentos puntos 1 >>  "Aciertos: %d/%d" printc cr
	tiempo 1000 / "%d segundos" printc
	key
	>esc< =? ( exit )
	drop
	;

:final
	llenacartas
	mexclacartas
	mezclagiro
	msec tiempo - 'tiempo !
	'pantallaf onshow
	;

:jugar | cartas --
	'cartascnt !
	msec 'tiempo !
	calcdim
	accion
	final
	;

:main
	cls home gui
	gooddog 64 fontr!
	$ff 'ink !
	"Memoria" printc cr
	gooddog 40 fontr!
	cr cr
	$ff00 'ink !
	gooddog 48 fontr!
	sp sp [ 16 jugar ; ] "16" btnt
	sp [ 30 jugar ; ] "30" btnt
	sp [ 48 jugar ; ] "48" btnt
	cr cr
	$ff0000 'ink !
	sp sp 'exit " Exit " btnt
	cr cr
	$0 'ink !
	"r3 - PHREDA 2020" printc
	key
	>esc< =? ( exit )
	drop
	acursor
	;

: $ffffff 'paper !
	'main onshow ;