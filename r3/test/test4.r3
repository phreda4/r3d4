|SCR 512 512
| Example 1

^r3/lib/gui.r3
^r3/lib/print.r3
^r3/lib/3d.r3

#cc 10

:test
	cls home
	$ffffff 'ink !
	over " r%d" print cr
	cr
	$ff00 'ink !
	here "%h" print cr


	key
	>esc< =? ( exit )
	<up> =? ( 1 'cc +! )
	<dn> =? ( -1 'cc +! )
	drop
	;

:ini
	mark
	;

:
	ini
	3 'test onshow
;

