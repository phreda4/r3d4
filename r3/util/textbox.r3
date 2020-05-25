| textbox
| PHREDA 2020
|--------------------
##padx ##pady ##padl
##tx1 ##ty1 ##tx2 ##ty2

::gridxy | int -- x1 y1
	dup 8 >> $ff and 2 <<
	swap $ff and 2 << ;

::gridwh | int -- w h
	dup 24 >> $ff and 2 <<
	swap 16 >> $ff and 2 << ;

::gridxy2 | int -- x2 y2
	dup 8 >> $ff and over 24 >> $ff and + 2 <<
	over $ff and rot 16 >> $ff and + 2 << ;

::int2box | int --
	dup 8 >> $ff and 2 << dup 'tx1 !
	over 24 >> $ff and 2 << + 'tx2 !
	dup $ff and 2 << dup 'ty1 !
	swap 16 >> $ff and 2 << + 'ty2 ! ;

::int2pad | int --
	dup 16 >> 'padl !
	dup $ff and 'padx !
	8 >> $ff and 'pady ! ;

::box! | x1 y1 x2 y2 --
	'ty2 ! 'tx2 ! 'ty1 ! 'tx1 ! ;

::boxpad! | x y l --
	'padl ! 'pady ! 'padx ! ;

::boxfill | --
	tx1 ty1 tx2 ty2 fillbox	;

::boxborder | g --
	tx1 ty1 tx1 pick3 + ty2 fillbox
	tx2 ty1 tx2 pick3 - ty2 fillbox
	tx1 ty1 tx2 ty1 pick4 + fillbox
	tx1 ty2 tx2 ty2 pick4 - fillbox
	drop ;

|-------------------------------
:cntlin | adr -- c
	1 swap ( c@+ 1?
		10 =? ( rot 1 + rot rot ) | <enter>
		$5F =? ( rot 1 + rot rot ) | $5f _
		drop ) 2drop ;

:sizeline | adr -- cc
	0 swap
	( c@+ 1?
		10 =? ( 2drop ; )
		$5F =? ( 2drop ; )
		emitsize rot + swap )
	2drop ;

#emitv 'emit
#padyy

:lineemit | adr -- adr'
	( c@+ 1?
		10 =? ( drop ; )
		$5F =? ( drop ; )
		emitv ex ) drop ;

:boxprintl | adr --
	dup cntlin
	ty1 padyy + 'ccy !
	( 1? 1 -
		tx1 padx + 'ccx !
		swap lineemit swap cr padl 'ccy +!
		) 2drop ;

:boxprintc | adr --
	dup cntlin
	ty1 padyy + 'ccy !
	( 1? 1 -
		over sizeline
		tx1 tx2 + 1 >> swap 1 >> - padx + 'ccx !
		swap lineemit swap cr padl 'ccy +!
		) 2drop ;

:boxprintr | adr --
	dup cntlin
	ty1 padyy + 'ccy !
	( 1? 1 -
		over sizeline
		tx2 swap - padx - 'ccx !
		swap lineemit swap cr padl 'ccy +!
		) 2drop ;

| $00 up $10 center $20 dn
| $ 0 iz $ 1 center $ 2 ri

::textbox | str n --
	dup $3 and
	pady 'padyy !
	1 =? ( ty2 ty1 - 1 >> pick3 cntlin cch padl + * 1 >> - padl 1 >> + 'padyy +! )
	2 =? ( ty2 ty1 - pick3 cntlin cch padl + * - pady - padl + 'padyy ! )
	drop
	4 >> $3 and
	0? ( drop boxprintl ; )
	1 =? ( drop boxprintc ; )
	drop
	boxprintr ;

::textboxvec | vec --
	'emitv ! ;

::textboxemit
	'emit 'emitv ! ;
