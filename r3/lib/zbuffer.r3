| zbuffer
| PHREDA 2020
|-------------------------
##zb
##zbw ##zbh
#zcnt

|--- maskbuffer | zbw*zbh
::zb.adr | x y -- a
	zbw * + 3 << zb + ;

::zb@ | x y -- zc
	zb.adr q@ ;

::zbo! | zc x y --
	zb.adr q! ;

::zb.clear
	zb >a zcnt ( 1? 1 -  $7fffffff a!+ 0 a!+ ) drop ;
|	zb zcnt ( 1? 1 - $7fffffff00000000 rot q!+ swap ) 2drop ;
|	zb $7fffffff zcnt fill ;
|	zb $7fffffff00000000 zcnt qfill ;

::zb.ini | w h --
	2dup * dup 'zcnt !	| w h cnt
	here dup 'zb !			| w h cnt here
	swap 3 << +	'here !	| w h
	'zbh ! 'zbw !		|
	zb.clear
	;

::zdraw | x y --
	xy>v >a zb >b
	sw zbw - 2 <<
	zbh ( 1? 1 -
		zbw ( 1? 1 - 4 b+ b@+ a!+ ) drop
		over a+
		) 2drop ;

::zdrawz | x y --
	xy>v >a zb >b
	sw zbw - 2 <<
	zbh ( 1? 1 -
		zbw ( 1? 1 - b@+ 4 b+ a!+ ) drop
		over a+
		) 2drop ;

