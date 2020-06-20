| test and debug r3stack
| PHREDA 2020
|--------------------------
^r3/lib/gui.r3
^r3/sys/r3stack.r3

#norm1

:test
	2 stk.2normal
	2 push.reg
	3 push.reg
	1 push.reg
	,printstk ,cr ,cr
|--------------------------------
	%101 stk.freereg
|--------------------------------
	,printstk ,cr
	0 ,c
	;


:panta
	cls home
	over "%d" print cr cr

	norm1 text
	cr
	mark ,printstk ,eol empty here text
	cr

	key
	<f1> =? ( stk.normal )
	>esc< =? ( exit )
	drop ;

:main
	$ff00 'ink !
	here 0 over !
	'norm1 !
	33
	test
	'panta onShow
	;


: mark main ;

