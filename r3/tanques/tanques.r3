^r3/lib/gui.r3
^r3/util/loadimg.r3
^r3/lib/sprite.r3
^r3/util/arr8.r3
|MEM $ffff

#dir 0
#px 80.0 #py 80.0
#vx #vy

#edir 0
#epx 340.0  #epy 250.0
#evx #evy

#disparos 0 0
#fx 0 0
#spr_tanque
#spr_disparo
#spr_explo
#piedra
#pasto

#mapa
2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
2 0 0 0 0 0 1 0 2 2 0 0 0 0 0 2
2 0 0 0 0 0 1 0 0 2 0 0 0 0 0 2
2 0 0 2 2 2 1 0 0 2 0 0 0 0 0 2
2 0 0 2 0 0 1 0 0 2 1 1 0 0 0 2
2 1 1 2 0 0 1 0 0 2 0 1 2 2 2 2
2 0 0 2 2 2 2 0 0 0 0 1 0 0 0 2
2 0 0 2 0 0 2 0 0 2 0 1 0 0 0 2
2 0 0 2 0 0 0 0 0 2 0 1 0 0 0 2
2 0 2 2 0 0 0 0 0 2 0 1 2 2 2 2
2 0 0 0 0 1 1 1 1 2 0 1 0 0 0 2
2 0 1 0 0 0 0 0 0 2 0 1 1 1 0 2
2 0 1 0 0 2 0 2 0 2 0 0 0 0 0 2
2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2

#tiles 0 'pasto 'piedra 

:dibujatile | y x ---
	0? ( drop ; )  
	over 42 * pick3 42 *
	rot 4 * 'tiles + @ @
	a> >r sprite r> >a 
	;

:dibujarmapa
	'mapa >a
	0 ( 14 <?
		0 ( 16 <?
			a@+ dibujatile 
			1 + ) drop
		1 + ) drop ;
		
:setmap | p x y --
	21 + 42 / 16 * swap 21 + 42 / +
	2 << 'mapa + ! ;
	
:getmap | x y -- l
	21 + 42 / 16 * swap 21 + 42 / +
	2 << 'mapa + @ ;

|-------------------------------
| explosion
:explosion
	>a
	a@ 0.2 + 2.6 >? ( drop 0 ; )	| son 3 dibujos, 0 1 y 2
	dup a!+	| graba el avance en tiempo
	16 >>	| parte entera 1.2 -> 1
	a@+ a@+ | lugar en x y
	spr_explo ssprite ; | dibuja la explosion
	
:explota | x y --
	'explosion 'fx p!+ >a 
	0 a!+ swap a!+ a! ; | pone el 0 para tiempo y la posicion
	
|-------------------------------	
:choquepasto
	1 >? ( 3drop 0 ; ) drop	| no rompe la pared
	2dup explota			| pone explosion
	0 rot rot setmap		| borra en mapa
	0 ;						| quita bala
	
:choquej | x y -- 1/0
	a> 12 + @ 0? ( 3drop 0 ; ) drop			| bala propia no choca
	21 + py 16 >> 21 + - abs 21 >? ( 2drop 0 ; ) drop
	21 + px 16 >> 21 + - abs 21 >? ( drop 0 ; )
	drop 1
	px 16 >> py 16 >> explota
	;
	
:choquejug	
	3drop 0 | quita bala
	|**** perdio!!!	
	;
	
:choquee | x y -- 1/0
	a> 12 + @ 1? ( 3drop 0 ; ) drop			| bala propia no choca
	21 + epy 16 >> 21 + - abs 21 >? ( 2drop 0 ; ) drop
	21 + epx 16 >> 21 + - abs 21 >? ( drop 0 ; )
	drop 1
	epx 16 >> epy 16 >> explota
	;
	
:choqueene	
	| nuevo enemigo
	0 'edir !
	340.0 'epx ! 250.0 'epy !
	0 'evx ! 0 'evy	!
	3drop 0 | quita bala
	;
	
| x y xv yv
:disp | adr --
	>a
	a@+ 16 >> 6 +				| x bala 			
	a@+ 16 >> 4 +				| y bala
	2dup getmap 1? ( choquepasto ; ) drop | choca con pared?
	2dup choquej 1? ( choquejug ; ) drop
	2dup choquee 1? ( choqueene ; ) drop
	a@+ a> 12 - +!
	a@+ a> 12 - +!
	a@+ spr_disparo rsprite ;

#dirx  0.0 -1.0  0.0  1.0
#diry -1.0  0.0  1.0  0.0

:shoot | y x --
	'disp 'disparos p!+ >a a!+ a!+
	dir 2 << 'dirx + @ 2 * a!+
	dir 2 << 'diry + @ 2 * a!+
	dir 0.25 * a!+ 
	0 a!+ | bala de jugador
	;

:movep | dir --
	dup 2 << 'dirx + @ 'vx !
	dup 2 << 'diry + @ 'vy !
	'dir ! ;

:stop  
	0 'vx !
	0 'vy ! ;
 
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
	<esp> =? ( py px shoot )
	drop 
	;
	
|------------------------------------
:eshoot | y x --
	'disp 'disparos p!+ >a a!+ a!+
	edir 2 << 'dirx + @ 2 * a!+
	edir 2 << 'diry + @ 2 * a!+
	edir 0.25 * a!+
	1 a!+	| bala de enemigo
	;
	
:eavanza
	evx epx + 16 >> evx 21 *. +
	evy epy + 16 >> evy 21 *. +
	getmap  1? ( drop ; ) drop
	evx 'epx +! evy 'epy +!
	;

:movee | dir --
	dup 2 << 'dirx + @ 'evx !
	dup 2 << 'diry + @ 'evy !
	'edir ! 
	;

#tant
#tiempo 0

:elegirmov
	py 
	epy 10.0 - <? ( drop 0 movee ; ) 
	epy 10.0 + >? ( drop 2 movee ; )
	drop
	px 
	epx 10.0 - <? ( drop 1 movee ; ) 
	epx 10.0 + >? ( drop 3 movee ; )
	drop
	;
	
:juegaia
	eavanza
	msec tant - 'tiempo +!
	msec 'tant ! 
	tiempo 
	2000 <? ( drop ; ) drop | cada 2 segundos toma decision
	0 'tiempo !
	rand %1100 and? ( epy epx eshoot ) drop 	| dispara
	rand %10000 and? ( drop elegirmov ; ) drop	| va hacia el jugador
	rand $3 and movee							| elije al azar
	;

|------------------------------------
:jugando
	cls home
	
	dibujarmapa
	'disparos p.draw
	px 16 >> py 16 >> dir 0.25 * spr_tanque rsprite 
	epx 16 >> epy 16 >> edir 0.25 * spr_tanque rsprite 
	'fx p.draw	
	
	juegahumano
	juegaia
	;
	
:inicio
	mark
	"r3/tanques/tanque.png" loadimg  'spr_tanque !
	"r3/tanques/bala.png" loadimg  'spr_disparo !
	"r3/tanques/pasto.png" loadimg 'pasto !
	"r3/tanques/piedra.png" loadimg 'piedra !
	40 37 "r3/tanques/explo.png" loadimg tilesheet 'spr_explo !
	100 'disparos p.ini
	10 'fx p.ini
	;
	
: 
	inicio
	'jugando onshow 
	;