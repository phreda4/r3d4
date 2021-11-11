^r3/lib/gui.r3
^r3/util/loadimg.r3
^r3/lib/sprite.r3
^r3/util/arr8.r3
^r3/lib/fontj.r3
|MEM $ffff

#dir 0
#px 100.0 #py 100.0
#vx #vy

#disparos 0 0 

#spr
#spr_tanque

#mapa
30 30 30 30 30 30 30 30 30 30 30 30
30 30 30 30 30 30 30 30 30 32 30 30
30 30 31 30 30 30 30 30 30 30 30 30
30 30 30 30 30 30 30 30 30 30 30 30
30 30 30 30 30 30 30 32 30 30 30 30
30 30 30 30 46 30 30 30 30 30 30 30
30 30 30 30 30 30 30 30 30 30 30 30
30 30 30 30 30 30 30 30 30 30 30 30
2  2   2  2  2  2  2  2  2  2  2  2
10 10 10 10 10 10 10 10 10 10 10 10

:dibujatile | y x tile ---
	0? ( drop ; ) 1 -
	over 32 * pick3 32 * 
	spr a> >r ssprite r> >a ;

:dibujarmapa
	'mapa >a
	0 ( 10 <?
		0 ( 12 <?
		    a@+ dibujatile 
			1 + ) drop
		1 + ) drop ;

:setmap | x y --
	21 + 32 / 12 * swap 21 + 32 / +
	2 << 'mapa + 25 swap ! ;

:getmap | x y -- l
	21 + 32 / 12 * swap 21 + 32 / +
	2 << 'mapa + @ ;
	
| x y vx vy
	
:disp | adr --
	>a
	a@+ a@+ 
	a@+ a> 12 - +!
	a@+ a> 12 - +!
	spr_tanque sprite
	;

#dirx 0.0 -1.0 0.0 1.0
#diry -1.0 0.0 1.0 0.0

:shoot	| y x --
	'disp 'disparos p!+ >a a!+ a!+ 
	dir 2 << 'diry + @ a!+
	dir 2 << 'dirx + @ a!+
	;
	
:mover | vx vy --
	'vy ! 'vx ! ;
	
:stop  0 0 mover ;
	
:avanza	
	vx px + 16 >> vx 21 *. +
	vy py + 16 >> vy 21 *. +
	getmap  1? ( drop ; ) drop
	vx 'px +! vy 'py +!
	;
	
:jugando
	cls
	dibujarmapa
|	px 16 >> py 16 >> dir 0.25 * spr_tanque rsprite
|	'disparos p.draw
|	avanza
	key
	>esc< =? ( exit )
	<up> =? ( 0 'dir ! 0.0 -1.0 mover ) >up< =? ( stop )
	<le> =? ( 1 'dir ! -1.0 0.0 mover ) >le< =? ( stop )
	<dn> =? ( 2 'dir ! 0.0 1.0 mover ) >dn< =? ( stop )
	<ri> =? ( 3 'dir ! 1.0 0.0 mover ) >ri< =? ( stop )
	<f1> =? ( px 16 >> py 16 >> setmap )
	
	<esp> =? ( py 16 >> px 16 >> shoot )
	drop ;
	
:juego
	'jugando onshow ;

:inicio
	mark
	32 32 "r3/games/tanques/tiles.png" loadimg tilesheet 'spr !
	100 'disparos p.ini
	;

: inicio
fontj4
juego ;
