| font monospace
| PHREDA 2014
|  uso:
|	^r3/lib/fontm.r3
|   ^r3/fntm/...fuente.rtf
|
|	fontm | 'fontm --
|-------------------------------
^r3/lib/gr.r3
^r3/lib/print.r3

:charsizem | byte -- size
	drop ccw ;

:a00 4 a+ ;
:a01 a@ ink col33% a!+ ;
:a10 a@ ink col50% a!+ ;
:a11 ink a!+ ;

#acc a00 a01 a10 a11

:charline | sx n bit --
	ccw ( 1? 1 -
		swap dup $3 and 2 << 'acc + @ ex
		2 >> swap ) 2drop ;

:charm | c --
    charlin * charrom +
	ccx ccy xy>v >a
	sw ccw - 2 <<
	swap
	cch ( 1? 1 -
		swap @+ charline swap
		pick2 a+
		) 3drop ;

::fontm | 'fontm --
	>a a@+ dup 2 << 'charlin !
	a@+ swap 'cch ! 'ccw !
	a> 'charrom !
	'charm 'charsizem font!
	calcrowcol ;

