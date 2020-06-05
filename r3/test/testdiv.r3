|SCR 512 512

^r3/lib/gui.r3


#x 10 #y 12

#q 0 0
:test
	cls home
	$ff00 'ink !
	"test div" print cr cr
	y x "x:%d y:%d" print cr
	cr
	$ffffff 'ink !
	x y mod  "x y mod->%d " print cr
	cr
	$7fffffffffffffff y 1 + /
	dup "%d " print cr
	x * y 63 *>>
	"x y mod->%d " print cr

	key
	>esc< =? ( exit )
	<up> =? ( -1 'y +! )
	<dn> =? ( 1 'y +! )
	<le> =? ( -1 'x +! )
	<ri> =? ( 1 'x +! )
	drop
	;

:
	rand 'x !
	'test onshow
;

