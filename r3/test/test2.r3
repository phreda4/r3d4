|SCR 512 512
| Example 1

^r3/lib/gui.r3
^r3/lib/print.r3
^r3/sys/r3parse.r3

#cc 18

:clzl
	0 swap
	$ffffffff00000000 na? ( 32 << swap 32 + swap )
	$ffff000000000000 na? ( 16 << swap 16 + swap )
	$ff00000000000000 na? ( 8 << swap 8 + swap )
	$f000000000000000 na? ( 4 << swap 4 + swap )
	$c000000000000000 na? ( 2 << swap 2 + swap )
	$8000000000000000 na? ( swap 1 + swap )
	drop ;

#vv 10

:testop
	cc "%d 2 / =" print cc 2 / "%d " print cr
	cc "%d 4 / =" print cc 4 / "%d " print cr
	cc "%d 16 / =" print cc 16 / "%d " print cr

	cc "%d 10 /mod =" print cc 10 /mod "%d %d" print cr
	cc abs "%d" print cr
	cc 25.0 10 */ "%f" print cr
	cr

	-446534001.233 25.0 mod "mod %f" print cr
	cr
	$4000000000000 clz "%d" print cr
	$4000000000000 clzl "%d" print cr
	;

#kk

:test
	cls home
	$ffffff 'ink !
	"hola " emits cr
	$ff 'ink !
	cc .d emits cr
	here .h emits cr
	$ff00 'ink !

	key 1? ( dup 'kk ! ) drop
	kk "%h" print cr
	sh sw "%dx%d" print cr
	cc "%h" print cr
	cc "%d" print cr cr
	cr
	$ff8888 'ink !
	testop

	key
	>esc< =? ( exit )
	<up> =? ( 1 'cc +! )
	<dn> =? ( -1 'cc +! )
	<f1> =? ( mark )
	<f2> =? ( empty )
	drop
	;

:
	mark
	'test onshow
;

