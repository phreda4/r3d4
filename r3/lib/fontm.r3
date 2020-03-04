| font monospace
| PHREDA 2014
|  uso:
|	^r3/lib/fontm.r3
|   ^r3/fntm/...fuente.rtf
|
|	::fontm | 'fontm --
|-------------------------------
^r3/lib/gr.r3
^r3/lib/print.r3

:charsizem | byte -- size
	drop ccw ;

#palcol $000000 $005500 $00aa00 $00ff00

:charline | sx n bit --
	ccw ( 1? 1 -
		swap dup $3 and 2 << 'palcol + @ a!+
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

::fontmcolor | c1 c2 --
	'palcol >a
	over a!+
	2dup $66 colmix a!+
	2dup $cc colmix a!+
	nip a!+ ;

::fontminv
	'palcol @+ swap 8 + @ swap
	fontmcolor ;
