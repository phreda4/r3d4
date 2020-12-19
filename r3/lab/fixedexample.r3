^r3/lib/gui.r3
^r3/lib/fontj.r3

#v1 0 $2f000000
#vm 32
#vs 5

:test
	key
	>esc< =? ( exit )
	drop

	cls home
	$ffffff 'ink !
	"* and >> separated, 64bit in intermediate result, lost bits" print cr
	$ff00 'ink !
	'v1 q@
	dup "%d " print
	dup "%h " print cr
	dup "%b " print cr
	vm
	dup "%d * " print
	*
	vs
	dup "%d >>" print cr
	>>
	dup "%d " print
	dup "%h " print cr
	dup "%b " print cr
	drop
	cr
	$ffffff 'ink !
	"*>> word, 128bit in intermediate result, not bit lost" print cr
	$ff00 'ink !
	'v1 q@
	dup "%d " print
	dup "%h " print cr
	dup "%b " print cr
	vm
	vs
	2dup swap "%d %d *>> " print cr
	*>>
	dup "%d " print
	dup "%h " print cr
	dup "%b " print cr
	drop

	;

:
|	fontj2
	'test onshow
;

