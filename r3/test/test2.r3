|SCR 512 512
| Example 1

^r3/lib/gui.r3
^r3/lib/print.r3
^r3/sys/r3parse.r3

#cc 10

:oper | v1 v2 str --
	rot .d emits " " emits
	swap .d emits " " emits
	emits ;

:oper3 | v1 v2 v3 str --
	2swap
	swap .d emits " " emits
	.d emits " " emits
	swap .d emits " " emits
	emits ;

:res1 | r1 --
	" ==> " emits
	.d emits " " emits ;

:res2 | r1 r2 --
	" ==> " emits
	swap .d emits " " emits
	.d emits " " emits ;


:testop
	cc 3 2dup "/" oper / res1 cc 3 / " opt %d" print cr
	cc 3 2dup "mod" oper mod res1 cc 3 MOD " opt %d" print cr
	cc 3 2dup "/mod" oper /mod res2 cc 3 /MOD " opt %d %d" print cr
	cc 10 3 pick2 pick2 pick2 "*>>" oper3 *>> res1 cc 10 3 *>> "opt %d" print cr
	cc 15 3 pick2 pick2 pick2 "*/" oper3 */ res1 cc 15 3 */ "opt %d" print cr
	cc 2 2dup "and" oper and res1 cr

	4 16 << cc 0? ( 1 + ) / "%d" print cr
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

