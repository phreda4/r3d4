^r3/lib/gui.r3


#ccx 10 #ccy 10
#char65 ( $00 $3c $42 $42 $7e $42 $42 $00 )

::xy>v sw * + 2 << vframe + ; 		| x y -- adr

:scanl and? ( ink a!+ ; ) 4 a+ ;	| mask value -- mask

:emitchar | 'a --
	drop 'char65 		| force only 1 char!!
	ccx ccy xy>v >a
	sw 8 - 2 << swap
	8 ( 1? 1 -
		swap c@+
		$80 ( 1? over scanl 1 >> ) 2drop     | pc lc ad'
		pick2 a+
		swap ) 3drop
	8 'ccx +! ;			| advance cursor

:emitstr | "" --
	( c@+ 1? emitchar ) 2drop ;

: "forth" emitstr ;

