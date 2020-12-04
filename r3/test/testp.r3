|scr 1280 720
^r3/lib/gui.r3

:testp | nro -- n
	0 over		| nro acc nro
	(
		10/mod	| nro acc n' nro%10
		rot
		10 * +	| nro n' acc*10+nr0%10
		swap	| nro new n'
	1? ) drop	| nro newn
	- ;

:testp | nro - 0 is capi
	0 over ( 10/mod	rot 10 * + swap 1? ) drop - ;

:swcr
	ccx 40 + sw >? ( cr ) drop ;

:printcapi
	dup testp 1? ( drop ; ) drop
	dup "%d " print
	swcr
	;

:main | "" --
	cls home
	0 ( 99999 <?
		printcapi 1 +
		) drop
	key
	>esc< =? ( exit )
	drop ;

: 'main onShow ;

