| r3 CPU1
| PHREDA 2020
|---------------------
| multi machine simulator
^r3/lib/gui.r3
^./r3cpu1.r3

#cpu1

#testcpu "
#v 0
:main ( 1 'v +! v $8000 ! ) ;
: main ;"

:newcpu | -- adr
	here 
	$fff 'here +!
	dup
	;

:main
	cls home
	"Test cpu" print cr cr

	'cpu1 vmdatamem
	16 ( 1? 1 - swap
		@+ "%h " print
		swap ) 2drop
	cr

	'cpu1 vmstep
	key
	>esc< =? ( exit )
	drop
	;

:ram
	mark
	newcpu 'cpu1 !
	'testcpy 'cpu1 vmcompile
	;


: ram main ;

