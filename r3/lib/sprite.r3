| sprite
| PHREDA 2015,2018,2020
|------------------------
| pal/type-w-h
| 8-12-12
|
| 00 - 32bit opaque
| 01 - 32bit alpha
| 10 - 8bit opaque
| 11 - 8bit alpha

^r3/lib/gr.r3
^r3/lib/math.r3

#wb #hb		| ancho alto
#paleta

|-- internas para clip
#addm
#wi #hi
#xi #yi
|-- internas para scale
#wr #hr
#sx #sy
#xa #ya

|---- w/alpha
:alp!+ | col --
	dup 24 >> $ff and
	0? ( 2drop 4 a+ ; )
	$ff =? ( drop a!+ ; )
	a@ rot
	over $ff00ff and over $ff00ff and
	over - pick4 * 8 >> + $ff00ff and >r
	swap $ff00 and swap $ff00 and
	over - rot * 8 >> + $ff00 and
	r> or a!+ ;

:pal!+ | pal --
	2 << paleta + @ a!+ ;

:pala!+ | pal --
	2 << paleta + @ alp!+ ;

|----- 1:1
:clipw
	sw >? ( sw pick2 - ; )
	wb ;

:negw
	-? ( dup 'wi +! neg 'addm ! 0 ; )
	0 'addm ! ;

:cliph
	sh >? ( sh pick2 - ; )
	hb ;

:clip | x y	-- x y
	swap wb over + clipw 'wi ! drop
	negw
	swap hb over + cliph 'hi ! drop
	-? ( dup 'hi +! neg wb * 'addm +! 0 )
	;

|---- opaque
:d0 | adr -- ;32 bit/pixel
	addm 2 << + >b
	wb wi - 2 <<
   	sw wi - 2 <<
	hi ( 1?
		wi ( 1?
			b@+ a!+
			1 - ) drop
		over a+
		pick2 b+
		1 - ) 3drop ;

:d1 | adr -- ; 32 alpha
	addm 2 << + >b
	wb wi - 2 <<
   	sw wi - 2 <<
	hi ( 1?
		wi ( 1?
			b@+ alp!+
			1 - ) drop
		over a+
		pick2 b+
		1 - ) 3drop ;

:d2 | adr -- ; 8 sol
	addm + >b
	wb wi -
   	sw wi - 2 <<
	hi ( 1?
		wi ( 1?
			b> c@+ pal!+ >b
			1 - ) drop
		over a+
		pick2 b+
		1 - ) 3drop ;

:d3 | adr -- ; 8 alpha
	addm + >b
	wb wi -
   	sw wi - 2 <<
	hi ( 1?
		wi ( 1?
			b> c@+ pala!+ >b
			1 - ) drop
		over a+
		pick2 b+
		1 - ) 3drop ;

#odraw d0 d1 d2 d3

::sprite | x y 'spr  --
	0? ( 3drop ; )
	@+
	dup $fff and 'wb !
	dup 12 >> $fff and 'hb !
	2swap clip | adr h x y
	wi hi or -? ( drop 4drop ; ) drop
	xy>v >a
	$2000000 and? ( over 'paleta ! swap over 24 >> $3 or $ff and 1 + 2 << + swap )
	22 >> $c and 'odraw + @ ex ;


|----- N:N
:sd0 | x y adr --
	yi 'ya !
	sw wi - 2 << | columna
	hi ( 1?
		xi 'xa !
	 	pick2 ya 16 >> wb * 2 << +
		wi ( 1?
			over xa 16 >> 2 << + @ a!+
			sx 'xa +!
			1 - ) 2drop
		over a+
		sy 'ya +!
		1 - ) 3drop ;

:sd1 | x y adr --
	yi 'ya !
	sw wi - 2 << | columna
	hi ( 1?
		xi 'xa !
	 	pick2 ya 16 >> wb * 2 << +
		wi ( 1?
			over xa 16 >> 2 << + @ alp!+
			sx 'xa +!
			1 - ) 2drop
		over a+
		sy 'ya +!
		1 - ) 3drop ;

:sd2 | x y adr --
	yi 'ya !
	sw wi - 2 << | columna
	hi ( 1?
		xi 'xa !
	 	pick2 ya 16 >> wb * +
		wi ( 1?
			over xa 16 >> + c@ pal!+
			sx 'xa +!
			1 - ) 2drop
		over a+
		sy 'ya +!
		1 - ) 3drop ;

:sd3 | x y adr --
	yi 'ya !
	sw wi - 2 << | columna
	hi ( 1?
		xi 'xa !
	 	pick2 ya 16 >> wb * +
		wi ( 1?
			over xa 16 >> + c@ pala!+
			sx 'xa +!
			1 - ) 2drop
		over a+
		sy 'ya +!
		1 - ) 3drop ;

#sdraw sd0 sd1 sd2 sd3

:clipscw
	sw >? ( sw pick2 - ; ) wr ;
:negsw
	-? ( dup 'wi +! neg 'xi ! 0 ; ) 0 'xi ! ;
:clipsch
	sh >? ( sh pick2 - ; ) hr ;
:negsh
    -? ( dup 'hi +! neg 'yi ! 0 ; ) 0 'yi ! ;

:clipsc | x y adr -- adr x y
	rot | y adr x
	wr over + clipscw 'wi ! drop
	negsw
	rot | adr x y
	hr over + clipsch 'hi ! drop
    negsh
	wb wr 16 <</ dup 'sx ! xi * 'xi !
	hb hr 16 <</ dup 'sy ! yi * 'yi !
	;

::spritesize | x y w h 'img --
	0? ( 4drop drop ; ) >b
	b@+ dup $fff and 'wb ! 12 >> $fff and 'hb !
	0? ( 4drop ; ) 'hr !
	0? ( 3drop ; ) 'wr !
	b> clipsc | adr x y
	wi hi or -? ( 4drop ; ) drop
	xy>v >a
	4 - @+
	$2000000 and? ( over 'paleta ! swap over 24 >> $3 or $ff and 1 + 2 << + swap )
	22 >> $c and 'sdraw + @ ex ;

::spritescale | x y scale 'img --
	0? ( 4drop ; ) >b
	b@ dup		| x y s h h
	$fff and pick2 *. rot rot 12 >> $fff and *.
	b> spritesize ;

|----- DRAW ROT 1:1
:rotlim
	rot -? ( min ; ) rot max swap ;

:neglim
	-? ( 0 swap ; ) 0 ;

:inirot | x y r -- x y
	sincos 'xa ! 'ya !	| calc w&h
	xa wb * ya hb * neg 2dup +
	neglim rotlim rotlim
	- 16 >> 'wi !
	ya wb * xa hb * 2dup +
	neglim rotlim rotlim
	- 16 >> 'hi !		| calc ori
	wb 15 << wi xa * hi ya * - 1 >> - 'sx !
	hb 15 << hi xa * wi ya * + 1 >> - 'sy !
	swap wi wb - 1 >> -	| adjust & clip
	wi over + sw >? ( sw over - 'wi +! ) drop
	-? ( dup 'wi +! neg dup xa * 'sx +! ya * 'sy +! 0 )
	swap hi hb - 1 >> -
	hi over + sh >? ( sh over - 'hi +! ) drop
	-? ( dup 'hi +! dup ya * 'sx +! neg xa * 'sy +! 0 )
	;

:dotrot | xa ya w -- n
	over -? ( ; ) 16 >> hb >=? ( drop -1 ; )
	wb *
	pick3 -? ( nip ; ) 16 >> wb >=? ( 2drop -1 ; )
	+ ;

:point0
	-? ( drop 4 a+ ; ) 2 << b> + @ a!+ ;

:r0
	>b inirot
	wi hi or -? ( 3drop ; ) drop
	xy>v >a
	sx sy
	hi ( 1?
		pick2 pick2
		wi ( 1?
			dotrot point0
			rot xa + rot ya +
			rot 1 - ) 3drop
		sw wi - 2 << a+
		rot ya - rot xa +
		rot 1 - )
	3drop ;

:point1
	-? ( drop 4 a+ ; ) 2 << b> + @ alp!+ ;

:r1 | x y r adr --
	>b inirot
	wi hi or -? ( 3drop ; ) drop
	xy>v >a
	sx sy
	hi ( 1?
		pick2 pick2
		wi ( 1?
			dotrot point1
			rot xa + rot ya +
			rot 1 - ) 3drop
		sw wi - 2 << a+
		rot ya - rot xa +
		rot 1 - )
	3drop ;

:point2
	-? ( drop 4 a+ ; ) b> + c@ pal!+ ;

:r2 | x y r adr --
	>b inirot
	wi hi or -? ( 3drop ; ) drop
	xy>v >a
	sx sy
	hi ( 1?
		pick2 pick2
		wi ( 1?
			dotrot point2
			rot xa + rot ya +
			rot 1 - ) 3drop
		sw wi - 2 << a+
		rot ya - rot xa +
		rot 1 - )
	3drop ;

:point3
	-? ( drop 4 a+ ; ) b> + c@ pala!+ ;

:r3 | x y r adr --
	>b inirot
	wi hi or -? ( 3drop ; ) drop
	xy>v >a
	sx sy
	hi ( 1?
		pick2 pick2
		wi ( 1?
			dotrot point3
			rot xa + rot ya +
			rot 1 - ) 3drop
		sw wi - 2 << a+
		rot ya - rot xa +
		rot 1 - )
	3drop ;

#rdraw r0 r1 r2 r3

::rsprite | x y r 'bmr --
	0? ( 4drop ; )
	@+
	dup $fff and 'wb !
	dup 12 >> $fff and 'hb !
	$2000000 and? ( over 'paleta ! swap over 24 >> $3 or $ff and 1 + 2 << + swap )
	22 >> $c and 'rdraw + @ ex ;

|-------
::spr.alpha | 'bmr --
	dup @ $1000000 or swap ! ;

::spr.wh | 'spr -- w h
	@ dup $fff and swap 12 >> $fff and ;

::spr.cntmem | 'spr -- cnt mem
	dup spr.wh * swap 4 + ;

|--------------------------
:gettile | n --
	2 << sx + @ >b
	hi ( 1? 1 -
		wi ( 1? 1 - b@+ a!+ ) drop
		yi b+ ) drop ;

::tileSheet | w h 'sprite -- ssprite
	dup 'xi !
	spr.wh 'hr ! 'wr !
	'hi ! 'wi !
	wr wi - 2 << 'yi !
	here dup >a 'sx !
	xi 4 + >b
	0 ( hr <?
		0 ( wr <?
			b> a!+ wi dup 2 << b+
			+ ) drop
		hi dup 1 - wr * 2 << b+
		+ ) drop
	a> dup 'sy ! sx - 2 >> 'addm !
	hi 12 << wi or xi @ $ff000000 and or a!+
	0 ( addm <? dup gettile 1 + ) drop

	xi sy addm wi hi * 2 << * 4 + move
	sx 'here !
	xi ;


:mem2spr | n adr ex -- adr' ex
	$2000000 and? ( rot wb hb * * rot + swap ; )
	rot wb hb * 2 << * rot + swap ;

::ssprite | n x y 'spr  --
	0? ( 4drop ; )
	@+
	dup $fff and 'wb !
	dup 12 >> $fff and 'hb !
	2swap clip | adr h x y
	wi hi or -? ( 2drop 4drop ; ) drop
	xy>v >a
	$2000000 and? ( over 'paleta ! swap over 24 >> $3 or $ff and 1 + 2 << + swap )
	mem2spr
	22 >> $c and 'odraw + @ ex ;

::sspritesize | n x y w h 'img --
	0? ( 2drop 4drop ; ) >b
	b@+ dup $fff and 'wb ! 12 >> $fff and 'hb !
	0? ( 4drop ; ) 'hr !
	0? ( 3drop ; ) 'wr !
	b> clipsc | adr x y
	wi hi or -? ( drop 4drop ; ) drop
	xy>v >a
	4 - @+
	$2000000 and? ( over 'paleta ! swap over 24 >> $3 or $ff and 1 + 2 << + swap )
	mem2spr
	22 >> $c and 'sdraw + @ ex ;

::sspritescale | n x y scale 'img --
	0? ( nip 4drop ; ) >b
	b@ dup		| x y s h h
	$fff and pick2 *. rot rot 12 >> $fff and *.
	b> sspritesize ;

