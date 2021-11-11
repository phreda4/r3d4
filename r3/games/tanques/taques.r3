^r3/lib/gui.r3
^r3/util/loadimg.r3
^r3/lib/sprite.r3
^r3/util/arr8.r3
^r3/lib/fontj.r3
|MEM $ffff

#dir 0
#px 100.0 #py 100.0
#vx #vy

#edir 0
#epx 400.0 #epy 330.0
#evx #evy

#disparos 0 0 

#spr
#spr_tanque
#spr_disparo

#mapa
1 1 1 1 1 1 1 1 1 1 1 1
1 0 0 0 0 0 0 0 0 0 0 1
1 1 0 0 0 0 0 0 0 1 0 1
1 1 0 0 1 1 0 0 0 0 0 1
1 0 0 0 0 0 0 0 0 1 0 1
1 0 0 0 0 0 1 0 0 1 0 1
1 1 1 0 0 0 1 1 1 1 0 1
1 0 0 0 0 0 1 0 0 0 0 1
1 0 0 0 0 0 0 0 0 0 0 1
1 1 1 1 1 1 1 1 1 1 1 1

:dibujatile | y x tile ---
	0? ( drop ; ) 1 -
	over 42 * pick3 42 * 
	spr a> >r ssprite r> >a ;

:dibujarmapa
	'mapa >a
	0 ( 10 <?
		0 ( 12 <?
		    a@+ dibujatile 
			1 + ) drop
		1 + ) drop ;

:getmap | x y -- l
	21 + 42 / 12 * swap 21 + 42 / +
	2 << 'mapa + @ ;

	
| x y vx vy
:disp | adr --
	>a
	a@+ 16 >> a@+ 16 >> 
	over 8 - over 8 - | correccion para que sea el centro
	getmap 1? ( 3drop 0 ; ) drop | si hay pared quit bala
	a@+ a> 12 - +!
	a@+ a> 12 - +!
	spr_disparo sprite
	;

| direccion
#dirx 0.0 -1.0 0.0 1.0 
#diry -1.0 0.0 1.0 0.0

:shoot	| y x --
	'disp 'disparos p!+ >a a!+ a!+ 
	dir 2 << 'dirx + @ 2 * a!+
	dir 2 << 'diry + @ 2 * a!+
	;

:movep
	dup 2 << 'dirx + @ 'vx !
	dup 2 << 'diry + @ 'vy !
	'dir !
	;
	
:stop  
	0 0 'vy ! 'vx ! ;
	
:avanza	
	vx px + 16 >> vx 21 *. +
	vy py + 16 >> vy 21 *. +
	getmap  1? ( drop ; ) drop
	vx 'px +! vy 'py +! ;
	
:juegahumano
	avanza	
	key
	>esc< =? ( exit )
	<up> =? ( 0 movep ) >up< =? ( stop )
	<le> =? ( 1 movep ) >le< =? ( stop )
	<dn> =? ( 2 movep ) >dn< =? ( stop )
	<ri> =? ( 3 movep ) >ri< =? ( stop )
	<esp> =? ( py 6.0 + px 8.0 + shoot )
	drop ;

|--------------- COMPUTADORA
:avanzae
	evx epx + 16 >> evx 21 *. +
	evy epy + 16 >> evy 21 *. +
	getmap  1? ( drop ; ) drop
	evx 'epx +! evy 'epy +! ;

:moveia	| dir --
	dup 2 << 'dirx + @ 'evx !
	dup 2 << 'diry + @ 'evy !
	'edir ! ;

#tiempo 0
#mseca

:juegaia
	avanzae
	
	msec dup mseca - 'tiempo +! 'mseca !
	tiempo 2000 <? ( drop ; ) drop | cada 2 seg cambia de direccion
	0 'tiempo !
	rand 8 >> $3 and moveia
	;

|--------------- JUEGO	
:jugando
	cls
	dibujarmapa
	'disparos p.draw	
	px 16 >> py 16 >> dir 0.25 * spr_tanque rsprite
	epx 16 >> epy 16 >> edir 0.25 * spr_tanque rsprite	
	juegahumano
	juegaia
	;
	
:inicio
	mark
	42 42 "r3/games/tanques/tanques.png" loadimg tilesheet 'spr !
	"r3/games/tanques/tanque.png" loadimg 'spr_tanque !
	"r3/games/tanques/bala.png" loadimg 'spr_disparo !
	100 'disparos p.ini
	;

: inicio
	fontj4
	'jugando onshow ;
