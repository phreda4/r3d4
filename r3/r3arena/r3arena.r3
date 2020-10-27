| r3 CPU1
| PHREDA 2020
|---------------------
| multi machine simulator
^r3/lib/gui.r3
^./r3cpu1.r3

#cpu1


#cpu1 * 1060

:dump512 | adr x y --
	xy>v >a
	>b
	$3f ( 1? 1 -
		$3f ( 1? 1 -
			b@+ a!+
			) drop
		sw $3f -  2 << a+
		) drop ;

:.hex
	ink $ff0000 xor 'ink !
	$f <=? ( "0" emits )
	"%h" print ;

:dump16 | adr --
	16 ( 1? 1 -
		16 ( 1? 1 -
			rot c@+ .hex
			rot rot ) drop
		cr ) 2drop ;

:newcpu | -- adr
	here
	1060 'here +!
	dup
	;

:main
	cls home
	$ffffff 'ink !
	"r3arena" print cr cr
	$ff00 'ink ! "cpu" print cr
	$ff 'ink !
	cpu1 @ $1ff and "ip:%h" print cr
	$ff00 'ink ! "data" print cr
	$ff 'ink !
	cpu1 vmdatamem dump16
	cr
	$ff00 'ink ! "code" print cr
	$ff 'ink !
	cpu1 vmcodemem dump16

|	'cpu1 vmstep

	key
	>esc< =? ( exit )
	<f1> =? ( cpu1 vmstep )
	drop
	;

| 0 - IP
| 1 - DS/DR           	+4
| 2 - A					+8
| 3 - B             	+12
| 0..15 | DATA STACK 	+16
| 0..15 | RETURN STACK	+80
| 0..512 | CODE-DATA	+144
| 0..512 | DATA
:testbuild | adr
	mark
	dup 144 + 'here !
	4 ,c 10 ,c 0 ,c
	4 ,c 5 ,c 0 ,c

	empty
	;

#testcpu
"#v 0
:main ( 1 'v +! v $8000 ! ) ;
: main ;"

:ram
	mark
	newcpu 'cpu1 !
|	'testcpu 'cpu1 vmcompile
	cpu1 testbuild
	;


: ram
	'main onshow ;

