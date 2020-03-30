| PHREDA 2020
| test vectorial icons
|-------------------------
^r3/lib/sys.r3
^r3/lib/math.r3
^r3/lib/str.r3
^r3/lib/print.r3
^r3/lib/sprite.r3

^r3/lib/fontr.r3

^media/ric/modernpics.ric

:teclado
	key
	>esc< =? ( exit )
	drop ;

:main
	cls home
	$ffffff 'ink !

	100 100 rpos
	100 dup rsize
	'i.period remit

	xypen rpos
	'i.S msec 2 << remitr

	omode
	0 0 -30.0 mtrans
	$ff00 'ink !
	'i.a remit3d
|	acursor
	teclado
	;


:
	'main onshow
	;