| Vsprite Editor
| PHREDA Nov2006,May17,2020
|-----------------------
|MEM $8000
^r3/lib/gui.r3
^r3/lib/xfb.r3
^r3/lib/fontj.r3
^r3/lib/vsprite.r3

^r3/util/dlgcolor.r3
^media/ico/tool16.ico

#modo
#xv #yv #sv
#ves 0
#ves>

| inicio x1y1 x2y2 color
#tra 0
#tra>

| scrach pad
#lin
#lin>

#po #pa
#xf #yf
#xfa #yfa
#xsa #ysa
#xca #yca
#wpa #hpa

#cursor
#picktra -1

#xmin #ymin #xmax #ymax	| box in screen
#colp

|----------------------------------
:i.st
	$7fffffff dup 'xmin ! 'ymin !
	-$7fffffff dup 'xmax ! 'ymax ! ;

:a.st | adr --
    d>xy
    ymax >? ( dup 'ymax ! ) ymin <? ( dup 'ymin ! ) drop
    xmax >? ( dup 'xmax ! ) xmin <? ( dup 'xmin ! ) drop
	;

:t0 drop ;
:t1 8 >> 'colp ! ;
:t4 a.st ;
:t2 a.st @+ a.st ;
:t7 a.st @+ a.st @+ a.st ;
:tc 8 >> 'colp ! swap >a xmin ymin xy>d a!+ xmax ymax xy>d a!+ colp a!+ dup a!+ a> swap i.st ;

#lbox t0 t1 t0 t0 t4 t4 t2 t7 t4 t4 t2 t7 tc tc tc tc
:buildtra
	ves> 4 + dup 'tra !
	ves dup rot !+ swap i.st
	( ves> <?
     	@+ dup $f and 2 << 'lbox + @ ex
		) drop
	dup 'tra> !
	dup 'lin ! 0 over ! 'lin> !
	;

:rebuild1tra | tra --
	i.st
	4 << tra +
	@+ ( @+ dup $f and $c <?
		2 << 'lbox + @ ex
		) 3drop
	xmin ymin xy>d swap !+
	xmax ymax xy>d swap !
	;

:lastnode | adr -- adr'
	( @+ $f and $c <? drop ) drop ;

:getcolor | adr -- color
	lastnode 4 - @ 8 >> ;

|----------------------------------
:resetves
	ves 0 over ! 'ves> !
	buildtra
	-1 'picktra !
	0 'cursor !
	;

|---------------------------------
|**********************
:fbox | xc yc r --
	>r r@ - swap r@ - swap 2dup 2dup op
	r@ 1 << + 2dup pline
	swap r@ 1 << + swap 2dup pline
	r> 1 << - pline pline poli ;

:box | xc yc r --
	>r r@ - swap r@ - swap 2dup 2dup op
	r@ 1 << + 2dup line
	swap r@ 1 << + swap 2dup line
	r> 1 << - line line ;

:diam | x y r --
	>r 2dup r@ + op
	over r@ + over line 2dup r@ - line
	over r@ - over line r> + line ;

:fdiam | x y r --
	>r 2dup r@ + op
	over r@ + over pline 2dup r@ - pline
	over r@ - over pline r> + pline poli ;

:cruz | x y r --
	>r over r@ - over op over r@ + over line
	2dup r@ - op r> + line ;

:negro $000000 'ink ! ;
:azul $0000ff 'ink ! ;
:verde $00ff00 'ink ! ;
:rojo $ff0000 'ink ! ;
:violeta $ff00ff 'ink ! ;
:cyan $00ffff 'ink ! ;
:amarillo $ffff00 'ink ! ;
:blanco $ffffff 'ink ! ;
:gris $888888 'ink ! ;
:naranja $ff7f00 'ink ! ;
:celeste $8888ff 'ink ! ;

|------- Grilla
:hlinea | x --
	dup vsy vsh 1 >> - op vsy vsh 1 >> + line ;
:vlinea | y --
	dup vsx vsw 1 >> - swap op vsx vsw 1 >> + swap line ;

:rgrilla | escala --
	0? ( drop ; )
	vsw over / vsh pick2 / rot 1 >> 1 +
	( 1? 1 -
		pick2 over * dup vsx + hlinea neg vsx + hlinea
		over over * dup vsy + vlinea neg vsy + vlinea
		) 3drop ;

:vesfill
	vsx vsw 1 >> - vsy vsh 1 >> -
	over vsw + over vsh +
	fillbox
	;

:vesgui
	vsx vsw 1 >> - vsy vsh 1 >> - vsw vsh guiBox ;

|**********************

:p1 2dup 3 fbox ink >r gris 3 box r> 'ink ! ;
:p2 2dup 3 fdiam ink >r gris 3 diam r> 'ink ! ;

|---------- punto en poligono
#inside

:dline | p1 p2 --
	2dup gc>xy op gc>xy line ;

:entre | p1 p2 --
|	dline
	d>xy rot d>xy  | x1 y1 x2 y2
	pick2 <? ( 2swap )
	yf pick3 pick2 between -? ( 4drop drop ; ) drop
	pick2 - swap pick3 -	| x1 y1 y2-y1 x2-x1
	rot yf swap - *			| x1 (y2-1) (x2-x1)*(yf-y1)
	rot xf swap - rot *		| (x2-x1)*(yf-y1) (xf-x1)*(y2-1)
	>? ( 1 'inside +! ) drop ;

:t0 drop ;
:t1 drop 4 + ;
:t4 po -1 =? ( drop dup 'pa ! 'po ! ; )
	over dup 'pa ! 'po ! entre ;
:t5 pa over 'pa ! entre ;
:t6 swap @+ dup pa entre
	rot dup 'pa ! entre ;
:t7 swap @+ swap @+ | n3 n2 adr n1
	dup pa entre 	| n3 n2 adr n1
	rot dup rot entre |	n3 a n2
	rot dup 'pa ! entre ;

#ppo t0 t0 t1 t1 t4 t5 t6 t7 t4 t5 t6 t7 t0 t0 t0 t0 t0

:train? | adr -- 1/0
	0 'inside !
	-1 'po !
	( @+ dup $f and $c <?
|	( @+ 1? dup $f and
		2 << 'ppo + @ ex
		) 3drop
	inside 1 and ;

|---- punto fijo en gc
::fxymouse | -- .x .y
	xypen
	vsy - 17 << vsh / swap
	vsx - 17 << vsw / swap neg ;

::xfix vsx - 17 << vsw / ;
::yfix vsy - 17 << vsh / ;
::fixx vsw 17 *>> vsx + ;
::fixy vsh 17 *>> vsy + ;
|-------
:inmouse | x y -- 1/0
	xypen rot - dup * rot rot - dup * +
	32 <=? ( 1 nip ; ) 0 nip ;

:dotf | x1 y1 --
	yfix 3 >> 'yf ! xfix 3 >> 'xf ! ;

:indot | x y -- 1/0
	yf - dup * swap xf - dup * +
	32 <=? ( 1 nip ; ) 0 nip ;

:in? | xm ym xM yM -- 0/1
	rot yf rot rot between -? ( 3drop 0 ; ) drop
	xf swap rot between -? ( drop 0 ; ) drop
	1 ;

:intr
	( tra> <? 4 + >a
		a@+ a@+ d>xy rot d>xy
|		in? 1? ( drop r> 12 - tra - 4 >> ; ) drop
		in? 1? ( drop a> 12 - @ train? 1? ( drop a> 12 - tra - 4 >> ; ) ) drop
		a> 4 + ) drop
	-1 ;

:intra | x1 y1 -- tra
	dotf tra intr ;

:innext | tra -- tra'
	4 << tra + intr ;

:searchtra | x y -- tra
	intra -? ( ; )
	( dup 1 + innext 0 >? nip ) drop ;

:setpicktra
	xypen searchtra -? ( 'picktra ! ; )
	dup 'picktra !
    4 << tra +
    4 + |@+ getcolor 'color !
	@+ gc>xy 'ymin ! 'xmin !
	@ gc>xy 'ymax ! 'xmax !
	;

|---------------------
:vistall
	sw dup 1 >> 'xv !
	sh dup 1 >> 'yv !
	min 64 - 'sv ! ;

|----- curvas
:cursor0 ;

:cursor0c
	gris
	xca yca 2dup op xypen line
	verde 3 fbox ;

:cursor1
	xypen line ;

:cursor2
	xypen lin> 4 - @ gc>xy curve
	gris
	xca yca op
	lin> 4 - @ gc>xy 2dup line
	3 fdiam
	;

:cursor3
	xca yca
	xypen
	pick3 dup pick3 - +
	pick3 dup pick3 - +
	xca yca 2over curve
	gris
	2dup 3 fdiam 2over 3 fdiam
	op line line
	;

:cursor4
	xypen
	lin> 4 - @ gc>xy curve
	gris
	lin> 12 - >b
	b@+ gc>xy 2dup op
	b@+ gc>xy 2dup line 3 fdiam
	op b@ gc>xy 2dup line 3 fdiam
	;

:cursor4c
	xypen
	lin> 4 - @ gc>xy curve
	gris
	lin> 12 - >b
	b@+ gc>xy 2dup op
	b> 4 + @ gc>xy 2dup line 3 fdiam 3 fdiam
	;

:cursor5
	xca yca
	xypen
	pick3 dup pick3 - +
	pick3 dup pick3 - +
	xca yca 2over lin> 4 - @ gc>xy curve3
	gris
	2dup 3 fdiam 2over 3 fdiam
	op line line
	;

#ecursor 'cursor0
#emodo 0

:ins0
	xypen xy>gc 4 or
	lin> !+ 'lin> !
	'cursor1 'ecursor ! ;

:ins0c
	xypen xy>gc
	xca yca xy>gc 4 or
	lin> !+ !+ 'lin> !
	'cursor2 'ecursor ! ;

:ins1
	xypen xy>gc 5 or
	lin> !+ 'lin> !
	'cursor1 'ecursor ! ;

:ins2
	lin> 4 - dup @ $fffffff0 and
	xypen xy>gc 6 or
	rot !+ !+ 'lin> !
	'cursor1 'ecursor ! ;

:ins3
	xca yca
	xypen
	pick3 dup pick3 - +
	pick3 dup pick3 - +
	xy>gc rot rot xy>gc
	2swap xy>gc 6 or
	lin> >a a!+
	swap a!+ a!+ a> 'lin> !
	'cursor4 'ecursor !
	;

:ins4
    lin> 4 - >a
	a@ $fffffff0 and
	xypen xy>gc 6 or a!+
	a!+ a> 'lin> !
	'cursor1 'ecursor !
	;


:ins5
	lin> 4 - >a
	a@ $fffffff0 and
	xca yca
	xypen
	pick3 dup pick3 - +
	pick3 dup pick3 - +
	xy>gc rot rot xy>gc		| nc mou
	2swap xy>gc 7 or		| nc mou ca
	a!+ swap a!+ swap a!+
	a!+ a> 'lin> !
    'cursor4c 'ecursor !
	;

:closep
	| la ultima curva(curda?)
	ecursor
	'cursor4 =? ( ins4 )
	'cursor4c =? ( ins4 )
	drop
   	ves> >a
	lin ( lin> <? @+ a!+ ) drop
	color 8 << $c or a!+
	0 a! a> 'ves> !
	buildtra
	'cursor0 'ecursor !
	;

:remallp
	lin 'lin> !
	'cursor0 'ecursor ! ;

:remv | value
	neg lin> + 'lin> !
	lin> lin <=? ( drop lin 'lin> ! 'cursor0 'ecursor ! ; ) drop
	'cursor1 'ecursor !
	;

:remlastp
	ecursor
	'cursor0 =? ( drop ; )
	'cursor0c =? ( drop 0 remv ; )
	'cursor1 =? ( drop 4 remv ; )
	'cursor2 =? ( drop 8 remv ; )
	'cursor3 =? ( drop 8 remv ; )
	'cursor4 =? ( drop 12 remv ; )
	'cursor4c =? ( drop 12 remv ; )
	'cursor5 =? ( drop 8 remv ; )
	drop ;

:t0 drop ;
:t5 gc>xy op ;
:t2 gc>xy line ;
:t3 swap >b gc>xy b@+ gc>xy curve b> ;
:t4 swap >b gc>xy b@+ gc>xy b@+ gc>xy curve3 b> ;

#ltra t0 t0 t0 t0 t5 t2 t3 t4 t5 t2 t3 t4 t0 t0 t0 t0

:drawdraw
	lin lin> =? ( drop ecursor ex ; )
	gris
	( lin> <?
		@+ dup $f and 2 << 'ltra + @ ex
		) drop

	rojo
	ecursor ex

	lin @ gc>xy
	2dup
	inmouse 0? ( $ff00 'ink ! drop 3 fbox ; )
	rojo 'closep onClick
	drop 3 fbox
	;

:drawlines
	lin lin> =? ( drop ; )
	gris
	( lin> <?
		@+ dup $f and 2 << 'ltra + @ ex
		) drop ;

|----
:inip
	xypen 'yca ! 'xca !
	0 'emodo ! ;

:movp1
	xypen yca - abs swap xca - abs or
	4 <? ( drop ; ) drop
	1 'emodo !
	ecursor
	'cursor0 =? ( drop 'cursor0c 'ecursor ! ; )
	'cursor1 =? ( drop 'cursor3 'ecursor ! ; )
	'cursor2 =? ( drop 'cursor3 'ecursor ! ; )
	'cursor3 =? ( drop 'cursor4 'ecursor ! ; )
	'cursor4 =? ( drop 'cursor5 'ecursor ! ; )
	'cursor4c =? ( drop 'cursor5 'ecursor ! ; )
	drop
	;

:movp
	emodo 0? ( drop movp1 ; ) drop ;

:uppp
	ecursor
	'cursor0 =? ( drop ins0 ; )
	'cursor0c =? ( drop ins0c ; )
	'cursor1 =? ( drop ins1 ; )
	'cursor2 =? ( drop ins2 ; )
	'cursor3 =? ( drop ins3 ; )
	'cursor4 =? ( drop ins4 ; )
	'cursor4c =? ( drop ins4 ; )
	'cursor5 =? ( drop ins5 ; )
	drop
	;

|---- lineas
:inid
	xypen xy>gc 8 or lin !+ 0 over ! 'lin> ! ;
:movd
	xypen xy>gc 9 or lin> !+ 0 over ! 'lin> ! ;
:updd
   	ves> >a
   	color 8 << 1 or a!+
	lin ( lin> <? @+ a!+ ) drop
|	color 8 << $c or r!+
	0 a! a> 'ves> !
	buildtra
	;

:inicl	xypen dup 'ymin ! 'ymax ! dup 'xmin ! 'xmax ! ;
:movcl  xypen 'ymax ! 'xmax ! ;

|---- caja
:updc
	ves> >a
	xmin ymin xmax ymax
	2over xy>gc 4 or a!+
	pick3 over xy>gc 5 or a!+
	2dup xy>gc 5 or a!+
	drop swap xy>gc 5 or a!+
	drop
	color 8 << $c or a!+
	0 a! a> 'ves> !
	buildtra
	;

|---- elipse
:updel
	ves> >a
	xmin xmax 2dup + 1 >> rot rot - abs 1 >>    | xm rx
	ymin ymax 2dup + 1 >> rot rot - abs 1 >>	| xm rx ym ry
	pick3 pick2 pick2 - xy>gc 4 or a!+
	pick3 pick3 + pick2 xy>gc 6 or a!+
	pick3 pick3 + pick2 pick2 - xy>gc a!+
	pick3 pick2 pick2 + xy>gc 6 or a!+
	pick3 pick3 + pick2 pick2 + xy>gc a!+
	pick3 pick3 - pick2 xy>gc 6 or a!+
	pick3 pick3 - pick2 pick2 + xy>gc a!+
	pick3 pick2 pick2 - xy>gc 6 or a!+
	pick3 pick3 - pick2 pick2 - xy>gc a!+
	4drop
	color 8 << $c or a!+
	0 a! a> 'ves> !
	buildtra ;

|----
:drawhand
	vesGui
	'inid 'movd 'updd guiMap	| lineas
	drawlines
|	'remlastline <del>
	;

:drawpoint
	vesGui
	'inip 'movp 'uppp guiMap
	drawdraw
	key
|	'removep <del>
	<back> =? ( remlastp )
	<del> =? ( remallp )
	drop
	;

:drawbox
	vesgui
	'inicl 'movcl 'updc guiMap
	color 'ink ! 
	xmin ymin xmax ymax fillbox ;

:drawcir
	vesgui
	'inicl 'movcl 'updel guiMap
	color 'ink !
	xmin xmax 2dup + 1 >> rot rot - abs 1 >>
	ymin ymax 2dup + 1 >> rot rot - abs 1 >>
	rot swap fellipse ;

#mdraw 'drawpoint

:mododraw
	mdraw ex ;

|----------------------------------
:modovista
	[ xypen 'yf ! 'xf ! ; ]
	[ xypen dup yf - 'yv +! 'yf ! dup xf - 'xv +! 'xf ! ;	] onDnMove
	;

|----------------------------------
:rebox
	picktra -? ( drop ; ) rebuild1tra
:reboxl
	xv yv vspos sv dup vsize
	picktra 4 << tra + 4 +
	@+ gc>xy 'ymin ! 'xmin !
	@ gc>xy 'ymax ! 'xmax !
	;

|------
:+nodo | adr --
	dup 4 + swap ves> over - 2 >> move> ;

:-nodo | adr --
	dup 4 + ves> over - 2 >> move ;

:renodo
	buildtra rebox 0 'cursor ! ;

|------
:0ins ;
:1ins cursor +nodo renodo ;
:2ins ;
:3ins ;
#tins 0ins 1ins 2ins 3ins

:insnodo
	cursor 0? ( drop ; ) drop
	cursor @ $3 and 2 << 'tins + @ ex ;

|------
:0del   cursor | op
		dup 4 + @ $3 and
		1 =? ( drop -nodo cursor dup @ $fffffff0 and 4 or swap ! renodo ; )
		2drop
		;
:1del	cursor -nodo renodo ;	| line
:2del   cursor dup -nodo -nodo renodo ;	| curve
:3del   cursor dup dup -nodo -nodo -nodo renodo ;	| curve3

#tdel 0del 1del 2del 3del

:delnodo
	cursor 0? ( drop ; ) drop
	cursor @ $3 and 2 << 'tdel + @ ex ;

|------
:tocanodo | x y -- nro/0
	xypen 'yf ! 'xf !
	picktra 4 << tra + @
	( @+ dup $f and $c <? drop
		gc>xy indot 1? ( drop 4 - ; )
		drop ) 3drop 0 ;

:muevenodo | cursor --
	xypen xy>gc over @ $f and or swap ! ;

:modoeditne
	vesgui
	'setpicktra onClick ;

:cursor! | nodo --
	'cursor !
	;

|---
:t0 drop ;
:t1 drop 4 + ;
:t2 dup 'pa ! gc>xy p1 ;
:t3 dup 'pa ! gc>xy p1
	@+ gc>xy p2 ;
:t4 >r @+ >r @+
	gc>xy 2dup op pa gc>xy line p2
	r> gc>xy 2dup op r> dup 'pa ! gc>xy 2dup line p1 p2 ;

#ltrap t0 t0 t1 t1 t2 t2 t3 t4 t2 t2 t3 t4

:drawtra
	blanco
	( @+ dup $f and $c <?
		2 << 'ltrap + @ ex
		) 3drop
	cursor 0? ( drop ; )
	rojo @ gc>xy 3 fbox ;

|---
:modoeditn
	picktra -? ( drop modoeditne ; )
	vesgui
	[ tocanodo 0? ( -1 'picktra ! ) cursor! ; ]
	[ cursor 1? ( muevenodo ; ) drop ; ]
	'rebox
	guiMap
	4 << tra + @ drawtra ;

|---------------------------------
:movetr | adr --
	( dup @ dup $f and $c <?
		swap d>xy
		yfa + swap xfa + swap
		xy>d or swap !+
		) 3drop ;

:movelim | adr -- adr'
	dup @ d>xy yfa + swap xfa + swap xy>d swap !+
	dup @ d>xy yfa + swap xfa + swap xy>d swap !+
	;

:movepoly
	xypen
	yfix 3 >> dup yf - 'yfa ! 'yf !
	xfix 3 >> dup xf - 'xfa ! 'xf !

	picktra 4 << tra + 4 +	| limites
	@+ d>xy
	yfa + -$1fff <? ( 3drop ; ) drop
	xfa + -$1fff <? ( 2drop ; ) drop
	@+ d>xy
	yfa + $1fff >? ( 3drop ; ) drop
	xfa + $1fff >? ( 2drop ; ) drop

	12 -
	dup @ movetr			| mueve poly
	4 +						| mueve limites
	movelim
	8 -
	@+ gc>xy 'ymin ! 'xmin !
	@ gc>xy 'ymax ! 'xmax !
	;

:escalanodo
	swap d>xy	| x y
	yca - ysa *. yca + swap
	xca - xsa *. xca + swap
	xy>d ;

:escalapoly
	picktra 4 << tra + @ >b
	lin ( lin> <?
		@+ dup $f and
		$c <? ( escalanodo )
	 	or b!+ ) drop ;


:rotanodo
	swap d>xy	| x y
	yca - swap xca - swap
	over xsa *. over ysa *. + yca + >r
	swap ysa *. swap xsa *. - xca + r>
	xy>d ;

:rotapoly
	picktra 4 << tra + @ >b
	lin ( lin> <?
		@+ dup $f and
		$c <? ( rotanodo )
	 	or b!+ ) drop ;


:delpoly
	picktra 4 << tra + @
	dup lastnode ves>	| ini end last
	over -
	over pick3 - neg 'ves> +!
	2 >> 1 + move 				| des src cnt
	0 ves> !
	buildtra
	-1 'picktra ! ;

:cpypoly
	ves> picktra 4 << tra + @
	dup lastnode over -			| last ini cnt
	dup 'ves> +!
	2 >> move
	0 ves> !
	buildtra
	reboxl ;

|--- scratch pad
:.pad
	lin 'lin> ! ;

:cpy>pad | adr --
	lin> >a
	( @+ dup $f and $c <? drop
		a!+ ) drop
	a!+ drop
	a> 'lin> ! ;

:cpypad> | adr --
	>a lin
	( lin> <? @+ a!+ ) drop ;

|---
:uppoly
	picktra tra> tra - 4 >> 1 - >=? ( drop ; )
	.pad
	4 << tra +
	dup @ swap 16 + @	| p1 p2
	cpy>pad
	dup cpy>pad
	cpypad>
	buildtra
	1 'picktra +!
	reboxl
	;

:dnpoly
	picktra 0? ( drop ; )
	.pad
	4 << tra +
	dup @ cpy>pad
	16 - @ dup cpy>pad
	cpypad>
	buildtra
	-1 'picktra +!
	reboxl
	;

|----------------------------------
:inpoly | -- 1/0
	xypen
	ymin ymax between -? ( 2drop 0 ; ) drop
	xmin xmax between -? ( drop 0 ; ) drop
	1 ;
|	picktra 4 << tra + @ train? ;


:polyini
	lin 'lin> !
	picktra 4 << tra + @+
	cpy>pad
	@+ d>xy rot @ d>xy rot
	dup 'yca ! - 'hpa !
	over 'xca ! swap - 'wpa !
	xypen dotf ;

:polyinir
	lin 'lin> !
	picktra 4 << tra + @+
	cpy>pad
	@+ d>xy rot @ d>xy rot
	2dup + 1 >> 'yca ! - abs 'hpa !
	2dup + 1 >> 'xca ! - abs 'wpa !
	xypen dotf ;

:mvscala
	xypen
	yfix 3 >> yca - 'yfa !
	xfix 3 >> xca - 'xfa !
	yfa hpa 16 <</ 'ysa !
	xfa wpa 16 <</ 'xsa !
	escalapoly
	rebox ;

:mvscalax
	xypen drop
	xfix 3 >> xca - 'xfa !
	1.0 'ysa !
	xfa wpa 16 <</ 'xsa !
	escalapoly
	rebox ;

:mvscalay
	xypen nip
	yfix 3 >> yca - 'yfa !
	yfa hpa 16 <</ 'ysa !
	1.0 'xsa !
	escalapoly
	rebox ;

:rotapolya
	xypen
	swap xfix 3 >> xca -
	swap yfix 3 >> yca -
	atan2
	xf xca - yf yca -
	atan2
	- 0.25 + sincos 'xsa ! 'ysa !
	rotapoly
	rebox ;

#emove

:dnp
	inpoly 0? ( drop -1 'picktra ! ; ) drop
	xmin xmax + 1 >> ymax | punto de x escala
	inmouse 1? ( drop polyini 'mvscalay 'emove ! ; ) drop
	xmax ymin ymax + 1 >> | punto de y escala
	inmouse 1? ( drop polyini 'mvscalax 'emove ! ; ) drop
	xmax ymax | punto de xy escala
	inmouse 1? ( drop polyini 'mvscala 'emove ! ; ) drop
	xmin ymin | punto de rotar
	inmouse 1? ( drop polyinir 'rotapolya 'emove ! ; ) drop
	xypen dotf
	'movepoly 'emove ! | mover
	;

:upp
|trace
	;

:modoeditp
	vesgui
	picktra -? ( drop 'setpicktra onClick ; ) drop
	xmin ymin xmax ymax	box.dot
	negro
	xmin xmax + 1 >> ymin ymax + 1 >> 5 cruz
	verde
	xmin ymin p2
	blanco
	xmax ymax p1
	xmax ymin ymax + 1 >> p1
	xmin xmax + 1 >> ymax p1
	'dnp emove 'upp guiMap
	;

|------------------------------------
:relim
	0? ( drop ; ) drop
	dup 4 +
	@+ gc>xy
	ymin <? ( dup 'ymin ! ) drop
	xmin <? ( dup 'xmin ! ) drop
	@ gc>xy
	ymax >? ( dup 'ymax ! ) drop
	xmax >? ( dup 'xmax ! ) drop
	;

:sumlim
	$7fffffff dup 'xmin ! 'ymin !
	$80000000 dup 'xmax ! 'ymax !
	lin >a
	tra ( tra> <?
		a@+ relim
		16 + ) drop ;

:dnsel
	xypen dup 'ymin ! 'ymax ! dup 'xmin ! 'xmax ! ;
:movsel
	xypen 'ymax ! 'xmax ! ;

:dentro?
	d>xy
	yf yfa between -? ( 2drop 0 ; ) drop
	xf xfa between -? ( drop 0 ; ) drop
	1 ;

#cntsel

:nosel
	lin 'lin> !
	$7fff dup 'xmin ! dup 'ymin ! dup 'xmax !
	'ymax ! ;

:upselc
	$c <? ( drop dentro? 1? ( rot 1 + rot rot ) drop ; )
	2drop swap 1? ( 1 'cntsel +! ) b!+ 0 swap ;

:upsel
	xmin xfix 3 >> xmax xfix 3 >>
	over <? ( swap ) 'xfa ! 'xf !
	ymin yfix 3 >> ymax yfix 3 >>
	over <? ( swap ) 'yfa ! 'yf !
	0 'cntsel !
	lin >b
	0
	ves ( ves> <?
    	@+ dup $f and upselc
    	) 2drop
    b> 0 over ! 'lin> !
    cntsel 0? ( drop nosel ; ) drop
	sumlim
	;

:copia | ves --
	 ( @+ dup $f and $c <? drop , ) drop , drop ;

:delsel0
	b@+ 0? ( drop copia ; ) 2drop ;

:delsel
	mark
	lin >b
	tra ( tra> <?
       	@+	| tra' inicio
        delsel0 12 + ) drop
	here empty
	ves >b
	here ( over <? @+ b!+ ) 2drop
	b> 0 over ! 'ves> !
	buildtra
	-1 'picktra !
	0 'cursor !
	;

:draw | adr --
	( @+ dup $f and $c <? 2 << 'ltra + @ ex ) 3drop ;

:draw0
	b@+ 0? ( 2drop ; ) drop draw ;

:drawselecc
	lin >b
	tra ( tra> <?
       	@+	| tra' inicio
		draw0 12 + )
	drop ;

:move0
	b@+ 1? ( drop movetr dup movelim drop ; ) 2drop ;

:movesel
	xypen
	yfix 3 >> dup yf - 'yfa ! 'yf !
	xfix 3 >> dup xf - 'xfa ! 'xf !

|	xmin ymin
|	yfa + -$1fff <? ( 2drop ; ) drop
|	xfa + -$1fff <? ( drop ; ) drop
|	xmax ymax
|	yfa + $1fff >? ( 2drop ; ) drop
|	xfa + $1fff >? ( drop ; ) drop

	lin >b
	tra ( tra> <?
       	@+	| tra' inicio
    	move0 12 + )
	drop
	sumlim
    ;

:inbox?
	xypen
	ymin ymax between -? ( 2drop 0 ; ) drop
	xmin xmax between -? ( drop 0 ; ) drop
	1 ;

:dnps
|	xmin xmax + 1 >> ymax | punto de x escala
|	inmouse 1? ( drop selini 'smvscalay 'emove ! ; ) drop
|	xmax ymin ymax + 1 >> | punto de y escala
|	inmouse 1? ( drop selini 'smvscalax 'emove ! ; ) drop
|	xmax ymax | punto de xy escala
|	inmouse 1? ( drop selini 'smvscala 'emove ! ; ) drop
|	xmin ymin | punto de rotar
|	inmouse 1? ( drop polyinir 'srotapolya 'emove ! ; ) drop
	inbox? 0? ( drop lin 'lin> ! dnsel ; ) drop
	xypen dotf
	'movesel 'emove ! | mover
	;

:selecttr
	xmin ymin xmax ymax	box.dot
	negro
	xmin xmax + 1 >> ymin ymax + 1 >> 5 cruz
	verde
	xmin ymin p2
	blanco
	xmax ymax p1
	xmax ymin ymax + 1 >> p1
	xmin xmax + 1 >> ymax p1
	rojo
	fonti xmin ymin atxy cntsel "%d" print
	drawselecc
	'dnps emove onDnMove
	;

:modosel
	lin lin> <? ( drop selecttr ; ) drop
	vesgui
	'dnsel 'movsel 'upsel guiMap
	xmin ymin xmax ymax
	pick3 1 + pick3 1 + pick3 1 + pick3 1 +
	blanco rectbox
	negro rectbox
	;


|------------------------------------
#ddmodo 0
#ddbotonera 'i_pencil 'i_box 'i_circ 0
#ddbotonerax 'drawpoint 'drawbox 'drawcir 0

:toodraw
	ddmodo
	'ddmodo 'ddbotonera ibtnmode
	ddmodo <>? ( ddmodo 2 << 'ddbotonerax + @ 'mdraw ! )
	drop
	;

:toovista
	[ sv 1 << 'sv ! ; ] 'i_zoomi ibtnf 4 'ccx +!
	[ sv 1 >> 'sv ! ; ] 'i_zoomo ibtnf 4 'ccx +!
	'vistall 'i_box ibtnf 4 'ccx +!
	;

:tooeditn
	picktra -? ( drop ; ) drop
	'delnodo 'i_del ibtnf 4 'ccx +!
	'insnodo 'i_ins ibtnf 4 'ccx +!
	;

:colpoly
	picktra -? ( drop ; )
    4 << tra + @ lastnode 4 -
	@ 8 >> 'color ! ;

:polycol
	picktra -? ( drop ; )
    4 << tra + @ lastnode 4 -
    dup @ $f and color 8 << or swap ! ;

:tooeditp
	picktra -? ( drop ; ) drop
	'cpypoly 'i_copy ibtnf 4 'ccx +!
	'uppoly 'i_front ibtnf 4 'ccx +!
	'dnpoly 'i_back ibtnf 4 'ccx +!
	'polycol 'i_tint ibtnf 4 'ccx +!
	'colpoly 'i_pick ibtnf 4 'ccx +!
	'delpoly 'i_trash ibtnf 4 'ccx +!
	;

:toolsel
|	'i.object_group 0 btnric gcdn | group
|	'i.object_ungroup 0 btnric gcdn	| ungroup
| move
| rota
| escale
	'delsel 'i_trash ibtnf	| del
	;

|------- modos
#modos 'mododraw 'modovista 'modoeditp  'modoeditn 'modosel
#tools 'toodraw 'toovista 'tooeditp 'tooeditn 'toolsel

|----- botonera
#modogui 'mododraw
#modotoo 'toodraw

:setmodo
	dup 'modo ! 2 <<
	dup 'modos + @ 'modogui !
	'tools + @ 'modotoo !

	lin 'lin> !
	'cursor0 'ecursor !
	;

#colorfondo $ffffff
#egrilla 2

:drawves
	xv yv vspos sv dup vsize
	colorfondo 'ink ! vesfill
	gris egrilla 1 << rgrilla
	ves vsprite
	;


#icbotonera 'i_draw 'i_eye 'i_star 'i_staro 'i_ray 0
|'i.magic 4 botonmodo

#icmode

:botonera
	home
	$777777 'ink !
	2 backlines

	blanco
	0 6 atxy
	" R3 Vsprite" print

	sw 200 - 0 atxy
	icmode
	'icmode 'icbotonera ibtnmode
	icmode <>? ( icmode setmodo )
	drop
	[ colorfondo not 'colorfondo ! ; ] 'i_wb ibtnf 4 'ccx +!
	'resetves 'i_trash ibtnf 4 'ccx +!
|	'i.undo 0 btnf
|	'i.repeat 0 btnf
	$ff0000 'ink !
	'exit 'i_exit ibtnf

	$0 'ink !
	260 0 atxy
    modotoo ex

	dlgColor
	;

:loadincode
	;

:saveincode
	mark
	ves> $ffff + 'here !
	mark
	"#draw " ,print
	ves ( ves> <?
		ves> over - 2 >> $7 nand? ( ,cr ) drop
		@+ $ffffffff and  "$%h " ,print
		) drop
	"0" ,print ,cr
	"mem/vscode.r3" savemem
	empty

	empty
	;

:teclado
	key
	<up> =? ( sv 5 >> neg 'yv +! )
	<dn> =? ( sv 5 >> 'yv +! )
	<ri> =? ( sv 5 >> 'xv +! )
	<le> =? ( sv 5 >> neg 'xv +! )
	<pgup> =? ( sv 1 << 'sv ! )
	<pgdn> =? ( sv 1 >> 'sv ! )

|	<f1> =? ( loadincode )
	<f2> =? ( saveincode )

	>esc< =? ( exit )
	drop
	;

|-------- DEBUG
:tr1
	picktra -? ( drop ; )
	4 << tra + @ dup lastnode >r =? ( ">" print ) r> =? ( "<" print )
	;

|-------- DEBUG
:dumptr
	home negro

	ves ( ves> 4 + <=?
		tr1
		ves> =? ( "!" print )
		tra =? ( "*" print )
		@+
		dup $f and $c >=? ( cr ) drop
		"%h " print cr
		) drop
	tra lin ( lin> <?
		@+ "%h " print
		swap @+ @ "%h " print
		cr
		12 + swap
		) 2drop
	cr
	picktra " pk: %d" print cr
	cursor " cu: %h" print cr
	ymax ymin xmax xmin "%d %d %d %d" print
	;

:dumpe
	home verde
	cr
	ecursor
	'cursor0 =? ( drop "cursor0" print ; )
	'cursor0c =? ( drop "cursor0c" print ; )
	'cursor1 =? ( drop "cursor1" print ; )
	'cursor2 =? ( drop "cursor2" print ; )
	'cursor3 =? ( drop "cursor3" print ; )
	'cursor4 =? ( drop "cursor4" print ; )
	'cursor4c =? ( drop "cursor4c" print ; )
	'cursor5 =? ( drop "cursor5" print ; )
	drop "*" print ;

	;

|-------- DEBUG

:main
	cls home gui
	drawves
	modogui ex
	botonera
	teclado

|		dumptr |-------- DEBUG
|		dumpe
	0 rows 1 - gotoxy
	" F2 - CODE " $5f5f5f bprint
	acursor ;

:inimem
	mark
	fonti
	$454545 'paper !
	dlgColorIni
	iniXFB
	here dup 'ves ! dup 'ves> ! 0 swap !
	resetves
	vistall
	0 24 xydlgColor!
	;

:	inimem
	ves "mem/notepad.vsp" load 0 swap !
	ves ( @+ 1? drop ) swap 4 - 'ves> !
	buildtra
	'main onshow
	ves ves> over - "mem/notepad.vsp" save
	;
