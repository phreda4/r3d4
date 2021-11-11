| print palindrome numbers
^r3/lib/gui.r3

:testp | nro - 0 is palindrome
	0 over ( 10 /mod rot 10 * + swap 1? ) drop - ;

:printcapi
	dup testp 1? ( drop ; ) drop
	dup "%d " print
	;

:main | "" --
	cls home
	0 ( 50000 <? printcapi 1 + ) drop
	key
	>esc< =? ( exit )
	drop ;

: 'main onShow ;

