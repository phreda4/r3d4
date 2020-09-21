^r3/lib/gui.r3
^r3/lib/fontj.r3

#v1 0 $3f000000
#vm 32
#vs 5

:test
	key
	>esc< =? ( exit )
	drop

	cls home
	$ffffff 'ink !
	"test" print cr
	'v1 q@
	dup "%d " print cr
	dup "%h " print cr
	dup "%b " print cr
	vm
	dup "* %d " print cr
	* 
	vs 
	dup ">> %d" print cr
	>>
	dup "%d " print
	dup "%h " print cr
	dup "%b " print cr
	drop
	cr
	'v1 q@
	dup "%d " print
	dup "%h " print cr
	dup "%b " print cr
	vm
	vs
	2dup swap "*>> %d %d" print cr
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

