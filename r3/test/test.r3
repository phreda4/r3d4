|SCR 512 512
| Example 1

^r3/lib/sys.r3

:colmix | c1 c2 m -- c
	>r
	dup $ff00ff and
	pick2 $ff00ff and
	over - r@ * 8 >> + $ff00ff and
    rot rot $ff00 and
	swap $ff00 and
	over - r> * 8 >> + $ff00 and
	or ;

:patternxor
	vframe >a
	sh ( 1? 1 -
		sw ( 1? 1 -
			2dup xor msec 2 >> + 
			$ff0000 $ff rot colmix
			a!+
		) drop
	) drop
	key 27 =? ( exit ) drop
	;

:
	'patternxor onshow
;

