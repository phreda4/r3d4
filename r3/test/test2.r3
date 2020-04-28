|SCR 512 512
| Example 1

^r3/lib/gui.r3
^r3/lib/print.r3

#cc 330


:test
	cls home
	$ffffff 'ink !
	"hola " emits cr
	$ff00 'ink !
	"que tal" emits cr
	$ff0000 'ink !

|	mark
|	cc ,d
	"hola" ,s
|	empty
|	here emits

|	cc ,d

|	cc "%b" print cr
|	cc "%d" print cr

	key
	>esc< =? ( exit )
	<up> =? ( 1 'cc +! )
	<dn> =? ( -1 'cc +! )
	drop
	;

:	mark
	'test onshow
;

