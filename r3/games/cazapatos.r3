|MEM $ffff
| cazapatos

^r3/lib/gui.r3
^r3/util/loadimg.r3
^r3/lib/sprite.r3

#spr_flecha
#spr_ave

#xf #yf #af 
#df 0
#xa #ya
#vxa #vya

:avenueva
	rand sh 15 << mod abs 'ya !
	sw 16 << 'xa !
	-1.8 'vxa !
	rand 0.7 mod 'vya !
	;

:ave
	msec 5 >> $f and xa 16 >> ya 16 >> spr_ave ssprite 
	vxa 'xa +!
	vya 'ya +!
	xa -160.0 <? ( avenueva ) drop
	;
	
:flechanueva
	sw 1 >> 16 << 'xf !
	sh 16 << 100.0 - 'yf !
	0 'df !
	;
	
:flecha
	xf 16 >> yf 16 >> af spr_flecha rsprite ;

:apunta
	$ffffff 'ink !
	xypen
	over 8 - over over 16 + over op line
	8 - 2dup 16 + op line
	xypen
	swap sw 1 >> -
	swap sh 100 - -
	atan2 0.5 + 'af !
	bpen 1? ( 1 'df ! ) drop
	;

:cayendo
	cls home
	0 xa 16 >> ya 16 >> spr_ave ssprite 
	3.8 'ya +!
	xf 16 >> yf 16 >> af spr_flecha rsprite 
	3.8 'yf +!
	ya sh 16 << <? ( drop ; ) drop
	exit
	;

:blanco
	'cayendo onshow
	avenueva flechanueva ;
		
:disparo
	flecha
	df 0? ( drop apunta ; ) drop
	af -7.9 polar 'yf +! 'xf +!

	xa 16 >> 60 + xf 16 >> - dup * 
	ya 16 >> 75 + yf 16 >> - dup * +
	sqrt
	30 <? ( blanco ) drop
	
	yf -120.0 <? ( flechanueva ) drop
	;
	
:jugando
	cls home
	ave
	disparo
	key
	>esc< =? ( exit )
	drop ;

:inicio
	mark
	"r3/games/flecha.png" loadimg  'spr_flecha !
	120 157 "r3/games/ave.png" loadimg tilesheet 'spr_ave !
	;
	
: 
	inicio
	avenueva
	flechanueva
	'jugando onshow 
	;