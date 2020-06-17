| test and debug r3stack
| PHREDA 2020
|--------------------------
^r3/lib/gui.r3
^r3/sys/r3stack.r3


:shuffle
|	d.pop r.push d.rot r.pop d.push d.rot
|	0 pushVAR 1 pushVAR


	.2dup
	33 push.NRO
	.swap
|	1 push.REG
	;

#norm1
:tonorm
	here 'norm1 !
	,printstk ,cr

	stk.normal
	,cr
	,printstk
	0 ,c
	;

#norm2
:tonorm2
	here 'norm2 !
	,printstk
|	3 vpila2fix
	,printstk
	0 ,c
	;

#norm3
:tonorm3
	here 'norm2 !
	,printstk
|	3 vpila2Reg
	,printstk
	0 ,c
	;

:panta
	cls home
	over "%d" print cr cr
	mark ,printstk ,eol empty here text cr cr
|	mark dumpcells, ,eol empty here text cr

	norm1 text

	key
	<f1> =? ( 4 stk.2normal )
	<f2> =? ( shuffle )
	<f3> =? ( tonorm )

|		[ 3 d.tos cell+! ; ] <f3>
|		[ 3 d.tos cell<< ; ] <f4>
|		[ d.tos cell[] ; ] <f5>
|		'tonorm2 <f4>
|		'tonorm3 <f5>
	>esc< =? ( exit )
	drop ;

:main
	$ff00 'ink !
	here 0 over ! dup 'norm1 ! dup 'norm2 ! 'norm3 !
	33
	'panta onShow
	;


: mark main ;

