| test and debug r3stack
| PHREDA 2020
|--------------------------
^r3/lib/gui.r3
^r3/sys/r3stack.r3

#norm1

:test1
	2 stk.2normal
	0 push.reg
	0 push.reg
	5 push.reg
|	16 push.nro

	,printstk ,cr ,cr
|--------------------------------
	stk.ARC

	,printstk ,cr
|--------------------------------
|	stk.normal ,cr
|	,printstk ,cr
|--------------------------------
	0 ,c
	;


:panta
	cls home
	over "%d" print cr cr

|	mark ,printstk ,eol empty here text cr cr
|	mark dumpcells, ,eol empty here text cr

	norm1 text

	key
|	<f1> =? ( 3 stk.2normal )
|	<f2> =? ( shuffle )
|	<f3> =? ( tonorm )
	>esc< =? ( exit )
	drop ;

:main
	$ff00 'ink !
	here 0 over !
	'norm1 !
	33
	test1
	'panta onShow
	;


: mark main ;

