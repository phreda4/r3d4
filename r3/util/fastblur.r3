| fast blur implemantation
| PHREDA 2020
| blur | w h r --
|--------------------
|MEM $ffff
^r3/lib/gui.r3
^r3/lib/fontj.r3
^r3/lib/trace.r3


#wb
#hb

#sumR
#sumG
#sumB

#rad
#invrad

:rgb1 | pix -- pix
	dup $ff and rad * 'sumB !
	dup 8 >> $ff and rad * 'sumG !
	dup 16 >> $ff and rad * 'sumR !
	;

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
	b!+ ;

:blurHPass | -- ; A=src B=dst
	hb ( 1? 1 -
		a@ rgb1
		rad 1 + ( 1? 1 -
			a@+ +rgb ) drop
		|..... left border
		rad ( 1? 1 -
			rgb!
			a@+ pick2 -+rgb
			) 2drop
		|..... center
		a> rad 3 << 4 + -
		wb rad 1 << - ( 1? 1 -
			rgb!
			swap
			@+ a@+ swap -+rgb
			swap ) 2drop
		|..... right border
		a> 4 - @
		rad 3 << 4 + neg a+
		rad ( 1? 1 -
			rgb!
			over a@+ -+rgb
			) 2drop
		rad 2 << a+
		) drop ;


:wk
	key <f1> =? ( exit ) drop ;

::waitkey
	'wk onshow ;

:vrgb!
	sumR invrad * $ff0000 and
	sumG invrad 8 *>> $ff00 and or
	sumB invrad 16 *>> $ff and or
	b!
	wb 2 << b+
	;

:blurVPass | -- ; A=src B=dst
	a> b>
	wb ( 1? 1 -
		over >b pick2 >a
		a@ rgb1
		rad 1 + ( 1? 1 -
			a@ +rgb
			wb 2 << a+ ) drop
		|..... left border
		rad ( 1? 1 -
			vrgb!
			a@ pick2 -+rgb
			wb 2 << a+ 	) 2drop
		|..... center
		pick2
		hb rad 1 << - ( 1? 1 -
			vrgb!
			swap
			a@ over @ -+rgb
			wb 2 << dup a+ +
			swap ) 2drop
		|..... right border
		a> wb 2 << - @
		rad 3 << 4 + wb * neg a+
		rad ( 1? 1 -
			vrgb!
			over a@ -+rgb
			wb 2 << a+
			) 2drop
		rot 4 + rot 4 + rot
		) 3drop ;

::blur | w h radio --
	1 <? ( 3drop ; )
	1.0 over 1 << 1 + / 'invrad !
	'rad ! 'hb ! 'wb !
	vframe >a here >b
	blurHPass
	here >a vframe >b
	blurVPass
	;


|------------------- DEMO -----------------------
:main
	cls home
	$ffffff 'ink !
	msec 8 >> "test: %d" print cr
	$ff 'ink !
	"color" print cr
	$ff00ff 'ink !

	300 60 op
	360 120 line
	sw sh
	msec 8 >> $7 and
	blur | w h radio --

	key
	>esc< =? ( exit )
	drop
	;

:   fontj4
	'main onshow ;