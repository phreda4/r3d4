| simple mandelbrot viewer
| PHREDA 2010
|---------------------------------
^r3/lib/sys.r3
^r3/lib/math.r3
^r3/lib/str.r3
^r3/lib/print.r3

#xmax #ymax #xmin #ymin

:calc | p q cx cy -- p q cx cy xn yn r
	over dup *. over dup *. - pick4 + | xn
	pick2 pick2 *. 1 << pick4 +		| xn yn
	over dup *. over dup *. +			| xn yn r
	;

:mandel | x y -- x y v
	over xmax xmin - sw */ xmin +	| x y p
	over ymax ymin - sh */ ymin +	| x y p q
	0 0 0 | cx cy it
	( 255 <? >r 	| x y p q cx cy
		calc		| x y p q cx cy xn yn r
		4.0 >? ( 4drop 3drop r> ; )
		drop rot drop rot drop
		r> 1 + )
	nip nip nip nip
	;

:color | c -- color
  dup dup 3 << $ff and
  rot 2 << $ff and
  rot 1 << $ff and
  8 << or 8 << or ;

:scrman
	vframe >a
	sh ( 1? 1 -
		sw ( 1? 1 - swap
			mandel color a!+
			swap ) drop
		) drop ;

:main
	cls home $ff00 'ink !
	" Calculando..." print
	redraw
	msec
	2.0 'xmax ! 2.0 'ymax !
	-3.0 'xmin ! -2.0 'ymin !
	scrman
	home $ff00 'ink !
	sp msec swap - .d print " ms " print
	waitesc ;

: main ;

