| Matrix
| Adaptacion del programa homonimo en PS2Yabasic. Galileo (2016)

^r3/lib/gui.r3
^r3/lib/fontj.r3

#ms 200  | cantidad de hilos
#sxy	| hilos
#scr	| pantalla

:color | r g b --
	8 << or 8 << or 'ink ! ;

:ran | n -- n
	rnd swap mod abs ;

:caracter | x y --
	cols * + scr + c@ emit ;

:escribe | x y -- x y
	-? ( ; ) rows >=? ( ; )
	2dup gotoxy 2dup caracter ;

:dibuja | x y --
    0 255 0 color escribe 1 -
    0 200 0 color escribe 1 -
    0 150 0 color escribe 1 -
    0 70 0 color escribe 23 -
    0 0 0 color escribe
    2drop ;

:matrix
	sxy ms ( 1? >r
		5 ran 1 =? ( 1 pick2 1 + c+! ) drop
		c@+ swap c@+ rot swap
		rows 25 + >? ( 0 cols ran pick4 2 - c!+ c! )
		dibuja
    	r> 1 - ) 2drop
	key
	>esc< =? ( exit )
	drop
	;

:inicializa
	fonti | probar..fonti fonti2 fontj
	cls | ajusta cols y rows segun fuente de letra

	mark | marca inicio de memoria libre
	here dup 'scr !
	cols rows * 		| mem ocupada por pantalla
	+ dup 'sxy !
	ms 1 << + 'here !		| mem ocupada por x,y

	scr cols rows * ( 1? 96 ran 33 + rot c!+ swap 1 - ) 2drop
	sxy ms ( 1? swap rows 25 + ran cols ran rot c!+ c!+ swap 1 - ) 2drop
	;

: msec rndseed inicializa $000000 'paper ! cls
	'matrix onshow ;