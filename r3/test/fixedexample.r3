^r3/lib/gui.r3
^r3/lib/fontj.r3

#v1 0 $3f000000
#vm 32
#vs 5

:test
	cls home
	$ffffff 'ink !

	'v1 q@
	dup "%d " print
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

	key
	>esc< =? ( exit )
	drop
	;

:
|	fontj2
	'test onshow
;

