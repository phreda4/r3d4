|SCR 512 512

^r3/lib/gui.r3


#x #y
:test
	cls home
	$ff00 'ink !
	"test 3" print cr
	y x "%d %d" print cr

	$ffffff 'ink !
	50 50 op
	x y line

	$ff 'ink !
	xypen op
	40 40 pline
	90 120 pline
	20 30 pline
	xypen pline
	poli

	key
	>esc< =? ( exit )
	<up> =? ( -10 'y +! )
	<dn> =? ( 10 'y +! )
	<le> =? ( -10 'x +! )
	<ri> =? ( 10 'x +! )
	drop
	;

:
	'test onshow
;

