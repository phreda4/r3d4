^r3/lib/gui.r3

:fib1 | n1 -- n2
	2 <? ( drop 1 ; )
	dup 1 - fib1
	swap 2 - fib1 + ;

:fib1-bench
	0 ( 1000 <?
		0 ( 20 <?
			dup fib1 drop
			1 + ) drop
		1 + ) drop ;

:fib2 | n1 -- n2
	0 1
	0 ( pick3 <?
		rot rot over +
		rot 1 + ) drop nip nip ;

:fib2-bench
	0 ( 1000 <?
		0 ( 20 <?
			dup fib2 drop
			1 + ) drop
		1 + ) drop ;

:main
	cls home
	$ff00 'ink !
	" ejecutando fib1..." print cr
	redraw
	msec
	fib1-bench
	$ffffff 'ink !
	msec swap - " resultado %d ms " print cr
	cr
	$ff00 'ink !
	" ejecutando fib2..." print cr
	redraw
	msec
	fib2-bench
	$ffffff 'ink !
	msec swap - " resultado %d ms " print cr


	$ffff 'ink !
	" Presione >ESC< para continuar..." print
	waitesc ;

: main ;
