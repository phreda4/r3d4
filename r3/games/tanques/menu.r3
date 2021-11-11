^r3/lib/gui.r3
^r3/lib/fontj.r3


|-------------------------
:juego
	cls home
	cr
	" jugando" print
	
	key
	>esc< =? ( exit )
	drop
	;

:jugando
	'juego onshow ;
	
|-------------------------

:configurar ;	
:dificutad ;

|-------------------------

#opcion 0

:enter
	opcion
	0 =? ( jugando )
	1 =? ( configurar )	
	2 =? ( dificutad )
	3 =? ( exit )	
	drop ;
	
:menu
	cls home
	cr
	$ff00 'ink !
	" Menu" print cr

	$F726FF 'ink !
	5 4 gotoxy "Jugar" print
	5 5 gotoxy "Configurar" print
	5 6 gotoxy "Dificultad" print	
	5 7 gotoxy "Salir" print	

	$ffffff 'ink !
	3 4 opcion + gotoxy ">" print
	16 4 opcion + gotoxy "<" print
	
	key
	<up> =? ( -1 'opcion +! )	
	<dn> =? ( 1 'opcion +! )
	
	opcion 0 max 3 min 'opcion ! 
	
|	>esc< =? ( exit )
|	<f1> =? ( jugando )
	<ret> =? ( enter )
	drop
	;
	
:inicio
	'menu onshow ; 

: fontj4 inicio ;