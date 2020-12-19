| midpoint drawing line
| simplest recursive
| PHREDA 2020

^r3/lib/gui.r3

:xy>v sw * + 2 << vframe + ; 		| x y -- adr

:pset | xy --
	dup 16 >> swap $ffff and xy>v ink swap ! ;

:(mline) | x1y1 x2y2 --
	2dup + 1 >> $7fff7fff and
	over =? ( pset 2drop ; )
	pick2 =? ( pset 2drop ; )
	dup rot (mline) (mline) ;

:packxy | x y -- xy
	$ffff and swap 16 << or ;

:mline
	packxy rot rot packxy (mline) ;

:main | "" --
	cls
	sw 1 >> sh 1 >> msec 5 << -200 xy+polar
	sw 1 >> sh 1 >> msec 5 << 200 xy+polar
	mline

	key
	>esc< =? ( exit )
	drop ;

: 'main onShow ;

