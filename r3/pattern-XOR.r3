|SCR 512 512
| Example 1

^r3/lib/sys.r3

:patternxor
 vframe >a
 sh ( 1? 1 -
  sw ( 1? 1 -
    2dup xor msec + 8 <<
	a!+
    ) drop
  ) drop
  key 27 =? ( exit ) drop
  ;

:
 'patternxor onshow
;
