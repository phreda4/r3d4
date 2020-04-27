|SCR 512 512
| block error

^r3/lib/gui.r3

#rom

:setpix | val mask -- val
	na? ( 4 a+ ; )
	ink a!+ ;

:tt | c --
	ccx ccy xy>v drop |>a
	drop ;
:a
	3 << dup 1 >> + 'rom +
|	sw 8 - 2 << swap
|	12
|( 1? 1 -
|		swap c@+
|		$80 ( 1? over setpix 1 >> ) 2drop
|		pick2 a+
|		swap )
|	sw 2 << dup 1 << + 2 << 32 - neg a+

|	3drop
	drop
;

:test
	cls home
	key
	>esc< =? ( exit )
	<f1> =? ( 15 tt )
	drop
	;

:
	'test onshow
;

