| Example 5 DRAW in Canvas

^r3/lib/sys.r3
^r3/lib/str.r3
^r3/lib/print.r3
^r3/util/penner.r3

^r3/lib/fontr.r3
^r3/rft/robotoregular.rft

#xv 0

:coso1
	robotoregular 160 fontr!
	msec
	dup 5 << $1ffff and
	$10000 and? ( $1ffff xor )
	Bac_In sw 1 >> *. sw 3 >> +
	'ccx !
	4 << $1ffff and
	$10000 and? ( $1ffff xor )
	Bac_InOut sh 1 >> *. sh 3 >> +
	'ccy !
	$ff0000 'ink !
	"R3d4" print
	;

:coso
	cls home
	xv 5 >> dup videoshow
	1? ( "video.mp4" 500 400 video ) drop
	xv 5 >> .d print cr
	xv 1 + $7ff and 'xv !

	coso1
	;

:teclado
	key
	>esc< =? ( exit )
	<f1> =? ( "video.mp4" 500 400 video )
	<f2> =? ( "salud.mp4" 500 400 video )
	<f3> =? ( 0 0 video )
	<f4> =? ( xv 3 >> 64 + videosize )
	drop ;

:show
	teclado
	coso ;

:
|	"salud.mp4" 600 video
	"video.mp4" 600 400 video
	0 'paper !
	'show onshow
	|0 dup dup video
	;