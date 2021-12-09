^r3/lib/gui.r3
^r3/util/loadimg.r3
^r3/lib/sprite.r3
^r3/lib/fontj.r3
^r3/util/arr8.r3
|MEM $ffff

#fx 0 0
#spr_jugador
#jxp 200.0 #jyp 400.0
#jxv #jyv

#aniquieto ( 3 -1 )
#aniaparece ( 0 1 2 3 -1 )
#anigolpe ( 30 31 32 33 34 -1 )
#anisalto ( 18 18 19 18 18 20 20 20 21 21 22 -1 ) 

#animacion 'aniquieto
#dibujo

:tocopiso
	0 'jyv ! 		| pone velocidad en 0
	400.0 'jyp ! 	| pone y en piso
	'aniquieto 'animacion ! | pone animacion en quieto
	;
	
:jugador
	0.05 'dibujo +! 

	jxv 'jxp +!
	jyv 'jyp +!
	
	0.1 'jyv +!
	jyp 400.0 >? ( tocopiso ) drop
	

	dibujo 16 >> animacion + c@ 			| recorre animacion
	-? ( 0 'dibujo ! drop animacion c@ )
	jxp 16 >> jyp 16 >> 						| lugar en x y
	spr_jugador ssprite ; 
	
	
:jugando
	cls home
	
	dibujo "%f" print
	jugador
	
	key
	>esc< =? ( exit ) 
	<f1> =? ( 'anigolpe 'animacion ! ) 
	<up> =? ( 'anisalto 'animacion ! -4.0 'jyv ! )
	drop
	;
	
:inicio
	mark
	45 60 "r3/games/pelea/vladix.png" loadimg tilesheet 'spr_jugador !
	1000 'fx p.ini
	;
	
: 
	inicio
	fontj2
	33
	'jugando onshow 
	;