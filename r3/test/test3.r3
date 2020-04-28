|SCR 512 512
| block error

^r3/lib/gui.r3

#rom

:tt
	4 ( 1 - 1? ) drop ;

:test
	cls home
	2 3 * 1 + 'rom !
	key
	>esc< =? ( exit )
	<f1> =? ( 15 tt )
	drop
	;

:
	'test onshow
;

