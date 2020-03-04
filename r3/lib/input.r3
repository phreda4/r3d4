^r3/lib/print.r3
^r3/lib/gui.r3

^r3/lib/trace.r3


|--- Edita linea
#cmax
#padi>	| inicio
#pad>	| cursor
#padf>	| fin

:lins  | c --
	padf> padi> - cmax >=? ( 2drop ; ) drop
	pad> dup 1 - padf> over - 1 + cmove> 1 'padf> +!
:lover | c --
	pad> c!+ dup 'pad> !
	padf> >? (
		dup padi> - cmax >=? ( swap 1 - swap -1 'pad> +! ) drop
		dup 'padf> ! ) drop
:0lin | --
	0 padf> c! ;
:kdel
	pad> padf> >=? ( drop ; ) drop
	1 'pad> +!
:kback
	pad> padi> <=? ( drop ; )
	dup 1 - swap padf> over - 1 + cmove -1 'padf> +! -1 'pad> +! ;
:kder
	pad> padf> <? ( 1 + ) 'pad> ! ;
:kizq
	pad> padi> >? ( 1 - ) 'pad> ! ;
:kup
	pad> ( padi> >?
		1 - dup c@ $ff and 32 <? ( drop 'pad> ! ; )
		drop ) 'pad> ! ;
:kdn
	pad> ( c@+ 1?
		$ff and 32 <? ( drop 'pad> ! ; )
		drop ) drop 1 - 'pad> ! ;

#modo 'lins

:drc
	ccx ccy xy>v >a
	cch ( 1? 1 -
		ccw ( 1? 1 -
			a@ not a!+
			) drop
		sw ccw - 2 << a+
		) drop ;

:drci
	ccx ccy cch dup 2 >> - + xy>v >a
	cch 2 >> ( 1? 1 -
		ccw ( 1? 1 -
			a@ not a!+
			) drop
		sw ccw - 2 << a+
		) drop ;

:cursor
	modo 'lins =? ( drop drci ; ) drop drc ;

:cursori
	blink 1? ( drop ; ) drop
	padi> ( pad> =? ( drop cursor ; ) c@+ 1?
		noemit ) 2drop ;

:cursorm
	blink 1? ( drop ; ) drop
	padi> ( pad> =? ( drop cursor ; ) c@+ 1?
		|allowcrx
		noemit ) 2drop ;

::pcursor | adr -- adr
	pad> <>? ( ; )
	blink 1? ( drop ; ) drop
	ccx 1 - ccy 2dup op cch + pline
	dup c@ emitsize 1 +
	ccx + ccy 2dup cch + op pline
	;

|----- ALFANUMERICO
:iniinput | 'var max IDF -- 'var max IDF
	over 'cmax !
	pick3 dup 'padi> !
	( c@+ 1? drop ) drop 1 -
	dup 'pad> ! 'padf> !
	'lins 'modo !
	;

:chmode
	modo 'lins =? ( drop 'lover 'modo ! ; )
	drop 'lins 'modo ! ;

:proinputa | --
	ccx cursori 'ccx !
	char 1? ( modo ex ; ) drop

	key
	<ins> =? ( chmode )

	<le> =? ( kizq )
	<ri> =? ( kder )
	<back> =? ( kback )
	<del> =? ( kdel )
	<home> =? ( padi> 'pad> ! )
	<end> =? ( padf> 'pad> ! )
	<tab> =? ( ktab )
|	'nextfoco <dn>
|	'prevfoco <up>

	drop
	;


|************************************
::input | 'var max --
	'proinputa 'iniinput w/foco
|	'clickfoco onClick
	drop
	emits ;


|************************************
|:proinputc | --
|	ccx cursori 'ccx !
|	[ key toasc modo ex ; ] <visible>
|	[ modo 'lins =? ( 'lover )( 'lins ) 'modo ! drop  ; ] <ins>
|	'kback <back>	'kdel <del>
|	'kder <ri>		'kizq <le>
|	[ padi> 'pad> ! ; ] <home>
|	[ padf> 'pad> ! ; ] <end>
|	'ktab <tab>
|	;

|::inputcell | 'var max --
|	dup gc.push makesizew
|	'proinputc 'iniinput w/foco
|	'clickfoco guiBtn
|	drop ccx w + >r
|	printx
|	gc.pop r> 'ccx !
|	;

|::inputcr | 'var max --
|	'proinputc 'iniinput w/foco
|	allowcr prin
|	;

|:proinputexe | --
|	ccx cursori 'ccx !
||	[ key toasc modo ex pick2 ex ; ] <visible>
||	[ modo 'lins =? ( 'lover )( 'lins ) 'modo ! drop  ; ] <ins>
|	[ kback pick2 ex ; ] <back>
|	[ kdel pick2 ex ; ] <del>
|	'kder <ri>		'kizq <le>
|	[ padi> 'pad> ! ; ] <home>
|	[ padf> 'pad> ! ; ] <end>
|	'ktab dup <tab> <enter>
|	'nextfoco <dn> 'prevfoco <up>
|	;

|************************************
|::inputexec | 'vector 'var max  --
|	gc.push dup makesizew
|	'proinputexe 'iniinput w/foco
|	'clickfoco guiBtn
|	drop ccx w + >r
|	printx
|	gc.pop r> 'ccx !
|	drop
|	;

