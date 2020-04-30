|SCR 512 512
| Example 1

^r3/lib/gui.r3
^r3/lib/print.r3

#cc 330
#str "coso"

:test1
	here .h emits cr ;

:test2
	here .b emits cr ;

#vac 'test1 'test2

:test
	cls home
	$ffffff 'ink !
	"hola " emits cr
	$ff 'ink !
	"que tal" emits cr
	$ff0000 'ink !
	cc .d emits cr
	here .h emits cr
	$ff00 'ink !
	cr
|	cc "%b" print cr
	cc "%d" 
	print 
	cr

|	'vac cc $1 and 2 << + @ ex | table jmp work!!

	key
	>esc< =? ( exit )
	<up> =? ( 1 'cc +! )
	<dn> =? ( -1 'cc +! )
	<f1> =? ( mark )
	<f2> =? ( empty )
	drop
	;

:
	'test onshow
;

