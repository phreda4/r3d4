|SCR 512 512
| Example 1

^r3/lib/gui.r3
^r3/lib/print.r3

#cc

:test
	cls home
	"hola" emits cr
|	cc "%h" print cr
|	cc "%d" print cr

	key
	>esc< =? ( exit )
|	<up> =? ( 1 'cc +! )
|	<dn> =? ( -1 'cc +! )
	drop
	;

:
	'test onshow
;

