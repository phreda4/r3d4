| Mini Screen - Zoom screen to resolution
| PHREDA 2019
|
| Uso:
| 320 200 miniscreen | set screen resolution (virtual)
|
| show.. minidraw | draw upper left screen in all screen
|
^r3/lib/gr.r3

#inish	#steph	#hsh
#inisw	#stepw	#wsw
#sumDa	#sumDb
#sumAa	#sumAb
#va #vb

::miniscreen | w h --
	sh over / 2dup * sh swap -
	1 + 1 >> 'inish ! 'steph ! 'hsh !
	sw over / 2dup * sw swap -
	1 + 1 >> 'inisw ! 'stepw ! 'wsw !

	sw stepw - 2 << 'sumda !
	sw steph *
	dup stepw + 2 << neg 'sumdb !
		stepw wsw * - 2 << neg 'sumaa !
	sw wsw - 2 << neg 'sumab !

	sw inisw - stepw -
	sh inish - steph -
	xy>v 'va !
	wsw 1 - hsh 1 -
	xy>v 'vb !
	;

:shaderdot | col --
	steph ( 1?
		stepw ( 1?
			pick2 a!+
			1 - ) drop
		sumda a+
		1 - ) 2drop
	sumdb a+ ;

::minidraw
	va >a vb >b
	hsh ( 1?
		wsw ( 1?
			b@ shaderdot
			-4 b+
			1 - ) drop
		sumaa a+
		sumab b+
		1 - ) drop
	|.... clear
	paper
	vframe over inish sw * fill
	'ink !
	inisw 1 << sh 1 - sw inisw - 0
	fillrect
	;

::minixy | x y -- mx my
	inish - steph / swap
	inisw - stepw / swap
	;

