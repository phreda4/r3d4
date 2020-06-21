| test and debug r3stack
| PHREDA 2020
|--------------------------
^r3/lib/gui.r3
^r3/sys/r3stack.r3

#norm1

|;>> qword[rbp-4*8] qword[rbp-3*8] qword[rbp-2*8] qword[rbp-1*8] qword[rbp] rax
|;   qword[rbp-3*8] rcx qword[rbp] qword[rbp-1*8] qword[rbp-2*8] rbx
|;<< qword[rbp-3*8] qword[rbp-2*8] qword[rbp-1*8] rbx qword[rbp+1*8] rax

:test
	6 stk.2normal
	,printstk ,cr
|--------------------------------

	.4drop
	.2drop
	-3 PUSH.STK
	3 push.reg
	0 push.stk
	-1 PUSH.STK
	-2 PUSH.STK
	1 push.reg

	stk.push

	stk.conv ,cr
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

