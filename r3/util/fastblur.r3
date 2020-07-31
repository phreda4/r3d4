| blur
| PHREDA 2020
|--------------------
^r3/lib/gui.r3
^r3/lib/fontj.r3

^r3/lib/trace.r3

#wb #hb

#sumR
#sumG
#sumB

#rad
#invrad

#cnt


:+rgb | pix --
	dup $ff and 'sumB +!
	dup 8 >> $ff and 'sumG +!
	16 >> $ff and 'sumR +!
	;

:-+rgb | pix1 pix2 --
	over $ff and over $ff and - 'sumB +!
	over 8 >> $ff and over 8 >> $ff and - 'sumG +!
	16 >> $ff and swap 16 >> $ff and swap - 'sumR +!
	;

:rgb!
	sumR invrad * $ff0000 and
	sumG invrad 8 *>> $ff00 and or
	sumB invrad 16 *>> $ff and or
	b!+
	;


:blurHPass | -- ; A=src B=dst
|	hb 100 -
	300 ( 1? 1 -
		a@
		dup $ff and rad * 'sumB !
		dup 8 >> $ff and rad * 'sumG !
		dup 16 >> $ff and rad * 'sumR !
		a> rad ( 1? 1 - swap
			@+ +rgb swap ) 2drop
		|..... left border
		rad 1 + ( 1? 1 -
			a@+ pick2 -+rgb
			rgb! ) 2drop
		|..... center
		a> rad 2 << -
		wb rad 1 << - 1 - ( 1? 1 - swap
			@+ a@+ swap -+rgb
			rgb! swap ) 2drop
		|..... right border
		a> 4 - @
		rad 2 << neg a+
		rad ( 1? 1 -
			over a@+ -+rgb
			rgb! ) 2drop
		rad 2 << a+
		) drop ;

:vrgb!
	sumR invrad * $ff0000 and
	sumG invrad 8 *>> $ff00 and or
	sumB invrad 16 *>> $ff and or
	b!
	wb 2 << b+
	;

:blurVPass | -- ; A=src B=dst
|	hb 100 -
	a> b>
	300 ( 1? 1 -
		over >b
		pick2 >a a@
		dup $ff and rad * 'sumB !
		dup 8 >> $ff and rad * 'sumG !
		dup 16 >> $ff and rad * 'sumR !
		a> rad ( 1? 1 - swap
			dup @ +rgb
			wb 2 << +
			swap ) 2drop
		|..... left border
		rad 1 + ( 1? 1 -
			a@ pick2 -+rgb
			vrgb!
			wb 2 << +
			) 2drop
		|..... center
		a> rad 2 << -
		wb rad 1 << - 1 - ( 1? 1 - swap
			@+ a@ swap -+rgb
			vrgb!
			wb 2 << a+
			swap ) 2drop
		|..... right border
		a> wb 2 << - @
		rad 2 << neg sw * a+
		rad ( 1? 1 -
			over a@ -+rgb
			vrgb!
			wb 2 << a+
			) 2drop
		rot 4 + rot 4 + rot ) 3drop ;


::blur | w h radio --
	1.0 over / 'invrad !
	'rad ! 'hb ! 'wb !
	vframe >a here >b
	blurHPass
	here >a vframe >b
	blurHPass
	;

:main
	cls home
	msec 8 >> "test: %d" print cr
	sw sh 3 blur
	cnt sw "%d %d" print
	key
	>esc< =? ( exit )
	drop
	;

:   fontj4
	'main onshow ;