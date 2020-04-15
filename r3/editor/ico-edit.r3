| Editor de iconos
| PHREDA 2010
|--------------------------------------------------
^r3/lib/gui.r3
^r3/lib/btn.r3
^r3/lib/input.r3
^r3/lib/parse.r3
^r3/lib/vdraw.r3

^r3/lib/sprite.r3
^r3/util/loadimg.r3
|^r3/lib/dlgfile.r3
^r3/lib/trace.r3

^media/ico/tool16.ico


#nombre * 256

#actual
#cntvar
#indexn * 3200 | 100 nombres de 32
#index * $ffff

#cntlist
#inilist

:viewlist | actual -- actual
	inilist <? ( dup 'inilist ! ; )
	inilist cntlist + >=? ( dup cntlist - 1 + 'inilist ! )
	;

:existname? | "" -- "" 1/0
	'indexn
	cntvar ( 1?
		pick2 pick2 =s 1? ( nip nip ; )
		drop swap 32 + swap 1 - ) nip ;

:freename | -- ""
	0
	( dup "new%d" mformat existname? 1? 2drop 1 + )
	drop nip
	;
|------------------------------
#icohw $f0f
#icomem * 256

:pl
	ink
	dup a!+ dup a!+ dup a!+ dup a!+ dup a!+ dup a!+ dup a!+ a!+
	sw 8 - 2 << a+ ;
:px8
	pl pl pl pl pl pl pl pl
	sw 3 << neg 8 + 2 << a+ ;
:px+
	32 a+ ;
:pxline
	3 << sw 3 << swap - 2 << a+ ;

:p.
	1 an? ( px8 ; ) px+ ;

::drawzico
	>b b@+ dup $ff and swap 8 >> $ff and
	( 1? b@+
		pick2 ( 1? 1 - swap
			p. 1 >> swap ) 2drop
		over pxline
		1 - ) 2drop ;

|-------------------------------
:invico
	'icomem >a
	32 ( 1? 1 - a@ not a!+ ) drop ;

:upico
	icohw 8 >> $ff and 1 -
	'icomem >a
	a@+ swap
	( 1? 1 -
		a@ a> 4 - ! 4 a+ ) drop
	a> 4 - ! ;

:dnico
	icohw 8 >> $ff and
 	dup 2 << 'icomem + >a
	1 + ( 1? 1 -
		a@ a> 4 + ! -4 a+
		) drop
	icohw 8 >> $ff and 2 << 'icomem + @ a> 4 + !
	;
:leico
	icohw $ff and 1 -
	'icomem >a
	32 ( 1? 1 - a@
		dup 1 >> swap 1 and pick3 << or
		a!+ ) 2drop ;

:riico
	icohw $ff and 1 -
	'icomem >a
	32 ( 1? 1 - a@
		dup 1 << swap pick3 >> 1 and or
		a!+ ) 2drop ;

:mirbit | nro nbit -- nroi
	0 swap
	( 1?
		pick2 1 and
		rot 1 << or swap
		rot 1 >> rot rot
		1 - ) drop nip ;

:mvico
	'icomem >a
	icohw dup $ff and swap 8 >> $ff and
	( 1? a@
		pick2 mirbit
		a!+ 1 - )
	2drop ;

:mhico
	'icomem >a
	0 icohw 8 >> $ff and 1 -
	( over >?
 	    dup 2 << a> + @
 	    pick2 2 << a> + @
 	    pick2 2 << a> + !
 	    pick2 2 << a> + !
		1 - swap 1 + swap ) 2drop ;

#aux * 256

:paso | val --
	'aux 32 ( 1? 1 -
		rot rot dup @ 1 << | i 'a a+
		pick2 1 and or swap !+
		swap 1 >> swap
		rot ) 3drop ;

:vhico
	'aux 32 ( 1? 1 - 0 rot !+ swap ) 2drop
	'icomem >a
	icohw 8 >> $ff and
	( 1? a@+ paso 1 - ) drop
	'icomem >a
	'aux 32 ( 1? 1 - swap @+ a!+ swap ) 2drop
	;

:chgm | a1 a2 cnt --
	( 1? 1 - >r
		over c@ over c@ swap
		rot c!+ rot rot swap c!+
		r> ) 3drop ;

:chg | a1 a2 icnt --
	rot >a
	( 1? 1 - swap
		a@ over @ a!+ swap !+
		swap ) 2drop ;

:chgico | i1 i2 --
	over 5 << 'indexn +
	over 5 << 'indexn + 8 chg
	8 << 'index + swap
	8 << 'index + swap 32 chg
	;

:dnlist
	actual cntvar 1 - >=? ( drop ; )
	dup 1 + chgico
	1 'actual +! ;

:uplist
	actual 0? ( drop ; )
	dup 1 - chgico
	-1 'actual +! ;

|--- parse
:getnro | txt -- txt' 0 / nro
	( dup c@ 33 <? 0? ( ; ) drop 1 + ) drop
	dup ?numero 0? ( ; )
	drop rot drop ;

:cpynom | adr en -- adr''
	swap ( c@+ $ff and 32 >?
		rot c!+ swap )
	drop 0 rot c! ;

:getsize@ 8 >> $ff and ;

:cadadibujo | adr $23 -- adr'
	drop c@+ $23 <>? ( drop ; ) drop | ##
	cntvar 5 << 'indexn + cpynom
	cntvar 8 << 'index + >a
	getnro dup a!+ getsize@
	( 1? swap getnro a!+ swap 1 - ) drop
	1 'cntvar +! ;

:parsefile | "" --
	here dup rot load 0 swap !+ 'here !
	0 'cntvar !
	( c@+ 1?
		$23 =? ( cadadibujo dup )
		drop ) 2drop
	;

:copyico | adr --
	'icohw >a
	@+ dup a!+
	getsize@
	( 1? swap @+ a!+ swap 1 - )
	2drop ;

:icocopy | adr --
	>a
	'icohw @+ dup a!+
	getsize@
	( 1? swap @+ a!+ swap 1 - )
	2drop ;

:actual! | nro --
	viewlist
	actual 8 << 'index + icocopy
	dup 'actual !
	8 << 'index + copyico
	refreshfoco ;

|--- write
:,codigo | adr --
	@+ dup " $%h" ,format
	8 >> $ff and
	( 1? 1 - swap
	   @+ " $%h" ,format swap ) 2drop
	,nl ;

:writefile | "" --
	mark
	"| ICO file" ,s ,nl
	0 ( cntvar <?
		'indexn over 5 << + "##%s" ,format
		dup 8 << 'index + ,codigo
		1 + ) drop
	savemem
	empty ;


|--------------------------------------------------
:newdib
	freename |cntvar "new%d" mformat
	cntvar 5 << 'indexn + strcpy
	cntvar 8 << 'index + >a
	$f0f a!+
	16 ( 1? 1 - 0 a!+ ) drop
	1 'cntvar +!
	cntvar 1 - actual!
	;

:copydib
	freename |cntvar "new%d" mformat
	cntvar 5 << 'indexn + strcpy
	cntvar 8 << 'index + >a
	actual 8 << 'index + @+ a!+
	32 ( 1? 1 - swap @+ a!+ swap ) 2drop
	1 'cntvar +!
	cntvar 1 - actual!
	;

:deldib
	cntvar 0? ( drop ; ) drop
	actual 8 << 'index +
	actual 1 + 8 << 'index +
	cntvar actual - 8 << 1 + move
	actual 5 << 'indexn +
	actual 1 + 5 << 'indexn +
	cntvar actual - 5 << cmove
	-1 'cntvar +!
	actual 1 - clamp0 'actual !
	actual 8 << 'index + copyico
	;

#imagen
#imagenx
#imageny

:cargaimg
	mark

|	"media/img" dlgfileload 0? ( drop empty ; )

	loadimg 0? ( drop empty ; )
	'imagen !
	0 'imagenx !
	0 'imageny !
	empty
	;

#capx 16
#capy 16
#ox
#oy

#marca 0
:marca1
	marca not 'marca ! ;

:getpixel
	over oy + over ox +
	swap xy>v >a
	a@ 7 >>
	1 and over << ;

:makeico
	cntvar
	freename |	dup "new%d" mformat
	over 5 << 'indexn + strcpy
	8 << 'index + >b
	capy 8 << capx or b!+
	0 ( capy <?
		0 >r
		0 ( capx <?
			getpixel r> + >r
			1 + ) drop
		r>
		b!+
		1 + ) drop
	1 'cntvar +!
	cntvar 1 - actual!
	exit ;

:drawimg
	imagen 0? ( drop ; )
	imagenx imageny 16 + rot sprite

	key
	<ret> =? ( makeico )
	drop

	blink 1? ( $ffffff or ) 'ink !
	ox oy over capx + over capy +
	fillbox
	;

|----------------------------
#namedraw 0

:editname
	namedraw 0? ( drop ; ) 31 input
	[ 0 'namedraw ! ; ] lostfoco
	;

:rendib
	actual 5 << 'indexn + 'namedraw ! ;

#varx 'ox #vary 'oy
#sumxy 1

:importm
	cls home
    drawimg

	fonti
	$7f00 'ink !
	backline
	$ff00 'ink !
	over " :R%d" print
	$ffffff 'ink !
	"iMPORT iCO " print
	capy capx "%dx%d " print

	[ xypen 'oy ! 'ox ! ; ] onClick

	$ff 'ink !
	[ 16 dup 'capx ! 'capy ! ; ] " 16 " link
	[ 24 dup 'capx ! 'capy ! ; ] " 24 " link
	[ 32 dup 'capx ! 'capy ! ; ] " 32 " link
	$7f7f 'ink !
	'cargaimg " Load " link
	'marca1 " set " link
	$ff0000 'ink !
	'exit "x" link

	key
	>shift< =? ( 'ox 'varx ! 'oy 'vary ! 1 'sumxy ! )
	<shift> =? ( 'imagenx 'varx ! 'imageny 'vary ! 16 'sumxy ! )
	<up> =? ( sumxy neg vary +! )
	<dn> =? ( sumxy vary +! )
	<le> =? ( sumxy neg varx +! )
	<ri> =? ( sumxy varx +! )
	<f1> =? ( cargaimg )
	<f2> =? ( marca1 )
	>esc< =? ( exit )
	drop

	acursor ;

:import
	3
	'importm onshow
	drop ;

|---------------------------------------------------
:invp | x y --
	2 << 'icomem + >a 1 swap << a@ xor a! ;

#xa #ya

:dn
	xypen 'ya ! 'xa ! ;
:mv
	xa ya xypen op line ;
:up
	xypen
	48 - 3 >> swap 10 - 3 >> swap vop
	xa 10 - 3 >> ya 48 - 3 >> vline ;

:editico
	$7f00 'ink !
	1 26 gotoxy
	'upico 'i_aup ibtn sp |ibtn " U " btnt sp
	'dnico 'i_adn ibtn sp |" D " btnt sp
	'leico 'i_ale ibtn sp |" L " btnt sp
	'riico 'i_ari ibtn sp |" R " btnt
	'invico 'i_wb ibtn sp |" N " btnt sp
	'mhico 'i_mhor ibtn sp |"MH " btnt sp
	'mvico 'i_mver ibtn sp |"Mv " btnt sp
	'vhico 'iturn ibtn sp |"MVH" btnt sp

   	$7f7f 'ink ! cr cr sp
	'newdib 'i_new ibtn |"f1-New" link
	'copydib 'i_copy sp ibtn |"f2-Copy" link
	'rendib 'i_name sp ibtn |"f3-Rename" link
	'import 'i_img sp ibtn |"f4-IMG" link
	'uplist 'i_sup sp ibtn |" U " btnt sp
	'dnlist 'i_sdn sp ibtn |" D " btnt sp
	'deldib 'i_del sp ibtn |"Del" link

	$7f7f 'ink ! cr cr cr sp
	[ icohw dup $ff and 1 - 0 max swap $ff00 and or 'icohw ! ; ] "-" btnt sp
	icohw $ff and "w:%d" print
	[ icohw dup $ff and 1 + 32 min swap $ff00 and or 'icohw ! ; ] "+" sp btnt
	sp sp
	[ icohw dup $ff00 and $100 - 0 max swap $ff and or 'icohw ! ; ] "-" btnt sp
	icohw 8 >> $ff and "h:%d" print
	[ icohw dup $ff00 and $100 + $2000 min swap $ff and or 'icohw ! ; ] "+" sp btnt
	cr cr
	$ffffff 'ink !
	sp 'icohw drawico
	sp 'icohw drawnico

	10 48
	icohw dup $ff and 3 << swap 8 >> $ff and 3 <<
	guiBox
	$777777 'ink !
	guiFill

	$ffffff 'ink !
	'dn 'mv 'up guiMap
	10 48 xy>v >a
	'icohw drawzico

	key
	<f1> =? ( newdib )
	<f2> =? ( copydib )
	<f3> =? ( rendib )
	<f4> =? ( import )
	<del> =? ( deldib )
	drop
	;

|----------------------------
:cadadib | n n -- n n
	dup inilist + cntvar >=? ( drop ; )

	$777777 'ink !
	actual =? ( $9900 'ink ! )
	[ dup actual! ; ]
	200 32 btnfpx
	$ffffff 'ink !
	dup 8 << 'index + sp drawico
	5 << 'indexn + " %s" print
	cr cr cr ;

:tabladib
	0 ( cntlist <?
		36 3 pick2 3 * + gotoxy
		cadadib 1 + ) drop ;

:viewall
	0 ( cntvar <?
		dup $f and 0? ( 62 pick2 4 >> 2 << 3 + gotoxy ) drop
		dup 8 << 'index + drawico
		1 + ) drop ;

:kdn
	actual cntvar 1 - >=? ( drop ; )
	1 + actual! ;

:kup
	actual 0? ( drop ; )
	1 - actual! ;

:mains
	cls home gui
	$7f00 'ink !
	2 backlines
	$ff0000 'ink !
	0 2 atxy
	sp 'exit 'i_exit ibtn |"esc-Exit" link
	sp
	$ff00 'ink !
	over " :R%d" print
	$ffffff 'ink !
	"eDIT iCO  " print
	$777777 'ink !
	[ $1010 'icohw ! ; ] "16" sp btnt
	[ $1818 'icohw ! ; ] "24" sp btnt
	[ $2020 'icohw ! ; ] "32" sp btnt

	'nombre "%s " mformat printr

	sp editname
	cr cr

	editico
	tabladib
	viewall

	key
	>esc< =? ( exit )
	<dn> =? ( kdn )
	<up> =? ( kup )
	drop

	acursor ;

:main
	'nombre "mem/ico-edit.mem" load drop
	'nombre parsefile
	actual 8 << 'index + copyico
	fonti home
	rows 3 / 1 - 'cntlist !
	0 'inilist !
	'invp vset!
	3
	'mains onshow ;

|--------------------------------------------------
:	0 'paper !
	mark
	main
|	'nombre writefile
	;

