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

:sminmax3 | a b c -- sn sx
	dup dup 63 >> dup
	not rot and rot rot and		| + -
	rot
	dup dup 63 >> dup
	not rot and rot rot and
	rot + >r + r>
	rot
	dup dup 63 >> dup
	not rot and rot rot and
	rot + >r + r> swap ;

:patternxor
	1 2 3 sminmax3 2drop
	vframe >a
	sh ( 1? 1 -
		sw ( 1? 1 -
			2dup xor msec + 8 <<
			$ff0000 $ff rot colmix
			a!+
		) drop
	) drop
	key 27 =? ( exit ) drop
	;

:
	'patternxor onshow
;

