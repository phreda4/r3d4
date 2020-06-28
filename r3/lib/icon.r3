| draw icon
| PHREDA

^r3/lib/gr.r3

:set1pix
	1 and? ( ink@ a!+ ; ) 4 a+ ;

::drawico | c --
	ccx ccy xy>v >a
	@+ dup $ff and swap 8 >> $ff and
	( 1? rot @+
		pick3 ( 1? 1 - swap set1pix 1 >> swap ) 2drop
		rot rot 1 -
		sw pick2 - 2 << a+
		) drop
	'ccx +!
	drop ;

::drawnico | c --
	ccx ccy xy>v >a
	@+ dup $ff and swap 8 >> $ff and
	( 1? rot @+ not
		pick3 ( 1? 1- swap set1pix 1 >> swap ) 2drop
		rot rot 1 -
		sw pick2 - 2 << a+
		) drop
	'ccx +!
	drop ;
