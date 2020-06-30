| floodfill test
| PHREDA 2020
|MEM 32768

^r3/lib/gr.r3
^r3/lib/xfb.r3
^r3/lib/rand.r3
^r3/lib/gui.r3
^r3/util/clock.r3

:randop
	rand sw mod abs
	rand sh mod abs
	;

:drawlines
	5 ( 1? 1 -
		rand 'ink !
		randop op
		20 ( 1? 1 -
			randop line
			) drop
		) drop ;

:fillcol
	rand xypen floodfill
	>xfb
	;

:show
	gui
	xfb>
	'fillcol onClick
	key
	>esc< =? ( exit )
	drop
	90 100 100 clocksize
	clockexp
	acursor ;


:main
	inixfb
	cls drawlines >xfb
	'show onshow
	;

: main ;