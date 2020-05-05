| rutinas para compilar
| reemplazo para ASM
| PHREDA 2013,2019,2020
|------------------------
^r3/lib/math.r3

#BPP 4 #TOLERANCE 24 #VALUES $10 #QFULL $100 #MASK $f
|#BPP 2 #TOLERANCE 8 #VALUES $4 #QFULL $8 #MASK $3

#FBASE	8

#col1 $ffffff
#col2 0

#tex
#mtx #mty
#ma #mb
#mex #mey

##ink

#px #py
#pxBPP #pyBPP

#ymax -1

|--------- segmentos
| ymin x delta1x ymax
|-----------------------
#segs * $7fff
#segs> 'segs

#heapseg * $1fff
#heapcnt 0

#activos * 2048
#activos> 'activos

#runlenscan * 2048

|---------- GRAFICOS ------------
:setxy | x y -- >a
|	10 << + 2 << vframe + >a ;
	sw * + 2 << vframe + >a ;

|----- mexcla de colores
:acpx!+ | alpha col --
	dup $ff00ff and				| alpha color colorand
	a@ dup $ff00ff and 		| alpha color colorand inkc inkcand
	pick2 - pick4 * 8 >> rot +	| alpha color inkc inkcandl
	$ff00ff and >r				| alpha color inkc
	swap $ff00 and 				| alpha px colorand
	swap $ff00 and 				| alpha colorand pxa
	over - rot * 8 >> + $ff00 and
	r> or a!+  ;

:pxa
	ink acpx!+ ;

:gr_mix | a b al -- c (DWORD col,BYTE alpha)
	>r
	dup $ff00ff and
	pick2 $ff00ff and
	over - r@ * 8 >> + $ff00ff and
    rot rot $ff00 and
	swap $ff00 and
	over - r> * 8 >> + $ff00 and
	or ;

:mixcolor | niv -- color
    1 <? ( col2 nip ; )
    254 >? ( col1 nip ; )
    col1 col2 rot gr_mix ;

:wvline | y x --
	-? ( drop 'py ! ; ) sw >=? ( drop 'py ! ; )
	py pick2 dup 'py !  	| y x py  y
	<? ( swap rot )		| y1 x y2
	-? ( 3drop ; ) sh 1 - clampmax
	rot sh >=? ( 3drop ; ) clamp0 | x y2 y1
	swap over - swap rot swap
	setxy 1 + ( 1? 1 - ink a! sw 2 << a+ ) drop ;

:whline | x y --
	-? ( drop 'px ! ; ) sh >=? ( drop 'px ! ; )
	px pick2 dup 'px !  	| x y px x
	<? ( swap rot )		| x1 y x2
	-? ( 3drop ; ) sw clampmax
	rot sw >=? ( 3drop ; ) clamp0	| y x2 x1
	swap over - swap rot
	setxy 1 + ( 1? 1 - ink a!+ ) drop ;

|------- clipline
:li
	8 <? ( 0 nip ; ) sh 2 - nip ;

:clip1 | y1 x1 y2 x2 c1 -- y1 x1 y2 x2 c1
    li >r
	2swap | y2 x2 y1 x1 X1+=(V-Y1)*(X2-X1)/(Y2-Y1);Y1=V;
 	pick3 pick2 - r@ pick3 - pick4 pick3 - rot */ +
	nip r> swap
	dup sw - not $200000 and
	over $100000 and or
	20 >> >r 2swap r> ;

:clip2 | y1 x1 y2 x2 c2 -- y1 x1 y2 x2 c2
	li >r	| y1 x1 y2 x2 X2+=(V-Y2)*(X2-X1)/(Y2-Y1);Y2=V;
	over pick4 - over pick4 - r@ pick4 - swap rot */ +
	nip r> swap
	dup sw - not $200000 and
	over $100000 and or 20 >> ;

:li
	1 =? ( 0 nip ; ) sw 1 - nip ;

:clip3 | y1 x1 y2 x2 c2 -- y1 x1 y2 x2 c2
	li >r
	swap | y1 x1 x2 y2 	Y2+=(V-X2)*(Y2-Y1)/(X2-X1);X2=V;C2=0;
	dup pick4 - pick2 pick4 - r@ pick4 - rot rot */ +
	nip r> 0 ;

:clip4 | y1 x1 y2 x2 c1 -- y1 x1 y2 x2 c1
	li >r
	2swap swap | y2 x2 x1 y1  Y1+=(V-X1)*(Y2-Y1)/(X2-X1);X1=V;C1=0;
	pick3 over - pick3 pick3 - r@ pick4 - rot rot */ +
	nip r> 2swap 0 ;

:clipline | x2 y2 x1 y1 -- y1 x1 y2 x2 in
	dup $400000 and over sh - 1 + not $800000 and or rot
	dup $100000 and over sw - not $200000 and or rot or
	20 >> >r 2swap
	dup $400000 and over sh - 1 + not $800000 and or rot
	dup $100000 and over sw - not $200000 and or rot or
	20 >> r>
	2dup and 1? ( drop or ; ) drop
	2dup or 0? ( drop or ; ) drop
	>r 12 an? ( clip2 ) r> swap >r 12 an? ( clip1 ) r>
	2dup and 1? ( drop or ; ) drop
	2dup or 0? ( drop or ; ) drop
	>r 1? ( clip4 ) r> swap >r 1? ( clip3 ) r> or ;

:nline21 | | sx dy dx
	16 << over / 		| sx dy ea
	0 rot 				| sx ea ec dy
	( 1? 1 - >r
		over + $ffff0000 an? ( $ffff and pick2 2 << a+ )
		sw 2 << a+
		dup 8 >>
		dup pxa pick3 1 - 2 << a+
		$ff xor pxa pick2 neg 1 - 2 << a+
		r> )
	4drop ;

|*******************************
::LINE | x y --
	py =? ( whline ; ) swap px =? ( wvline ; ) swap | x y
	px py 2over 'py ! 'px !		| x y x2 y2
	pick2 <? ( 2swap )
	-? ( 4drop ; ) 				| y1 x1 x2 y2 ; termina en y neg..
	2swap sh 1 - >=? ( 4drop ; )	| x2 y2 x1 y1 ; termina en y>h
	clipline 1? ( nip 4drop ; ) drop	| y1 x1 y2 x2
	pick2 - swap pick3 -		| y1 x1 dx dy
	0? ( 4drop ; )
	2swap					| dx dy y1 x1
	swap setxy ink a! 		| dx dy
	swap sign rot rot abs	| sx dy dx
	over <? ( nline21 ; )
	swap 16 << over / 		| sx dx ea
	0 rot 					| sx ea ec dx
	( 1? 1 - >r	| sx ea ec
		over + $ffff0000 an? ( $ffff and sw 2 << a+ )
		pick2 2 << a+		| sx ea ec
		dup 8 >> 		| sx ea ec ci
		dup pxa sw 1 - 2 << a+
		$ff xor pxa sw 1 + neg 2 << a+
		r> ) 4drop ;

|*******************************
::OP | xy --
	2dup BPP << 'pyBPP ! BPP << 'pxBPP !
	'py ! 'px ! ;

|*******************************
::CURVE | fx fy cx cy --
	pick3 pxBPP + pick2 1 << - abs
	pick3 pyBPP + pick2 1 << - abs  +
	4 <? ( 3drop LINE ; ) drop
	pick3 pick2 + 1 >>  pick3 pick2 + 1 >>		| fx fy cx cy c2 c2
	2swap 									| fx fy c2 c2 cx cy
	py + 1 >> swap px + 1 >> swap				| fx fy c2 c2 c1 c1
	pick3 pick2 + 1 >>  pick3 pick2 + 1 >>		| fx fy c2 c2 c1 c1 ex ey
	2swap
	CURVE CURVE ;

#x1 #y1 #x2 #y2 #bx #by

|*******************************
:cc3 | ...
	3 <? ( drop 4drop LINE ; ) drop

::CURVE3 | xf yf x2 y2 x1 y1
	pick3 pick2 + 1 >> pick3 pick2 + 1 >> 'by ! 'bx !
	'y1 ! 'x1 !
	pick3 pick2 + 1 >> pick3 pick2 + 1 >> 2swap
	'y2 ! 'x2 !
	over bx + 1 >> over by + 1 >>
	over x2 - abs over y2 - abs + >r
	px x1 + 1 >> py y1 + 1 >>
	over bx + 1 >> over by + 1 >>
	over x1 - abs over y1 - abs + >r
	2swap >r >r
	pick3 pick2 + 1 >> pick3 pick2 + 1 >>
	2swap r> r>
	r> cc3 r> cc3 ;

|-------------------------------------------------
| PINTADO DE POLIGONOS
|-------------------------------------------------
| pos(12) | len(11) | cover(9) |
:getpos 20 >>> ;
:getlen 9 >> $7ff and ;
:getval $1ff and ;
:setpos 20 << ;
:setlen 9 << ;

|------------------- llenadores
:solidofill
	( 1? 1 - ink a!+ ) drop ;

:solidoalpha
	$ff xor
	swap ( 1? 1 - over pxa ) 2drop ;

:rlq
	QFULL =? ( drop solidofill ; )
	1? ( solidoalpha ; )
	drop 2 << a+ ;

:runlenSolid
	'runlenscan
	( @+ 1?
		dup getlen swap getval rlq
		) 2drop
	-4 a+ ;

|----------------- degrade lineal
:Ldegfill
	( 1? 1 -
		mex 8 >> mixcolor a!+
		ma 'mex +! ) drop ;
:Ldegalpha
	$ff xor swap
	( 1? 1 -
		over mex 8 >> mixcolor acpx!+
		ma 'mex +! ) 2drop ;

:rlq
	QFULL =? ( drop Ldegfill ; )
	1? ( Ldegalpha ; )
	drop dup 2 << a+ ma * 'mex +! ;

:runlenLdeg
	mtx neg ma * over BPP >> mty - mb * - 'mex !
	'runlenscan
	( @+ 1?
		dup getlen swap getval rlq
		) 2drop
	-4 a+ ;


|----------------- degrade radial
:distf | dx dy -- dis
	abs swap abs over <? ( swap )
	dup 8 << over 3 << + over 4 << - swap 1 << -
	over 7 << + over 5 << - over 3 << + swap 1 << - ;

:Rdegfill
	( 1? 1 -
	    mex mey distf 16 >> mixcolor a!+
	    ma 'mex +! mb 'mey +!
		) drop ;
:Rdegalpha
	$ff xor swap
	( 1? 1 -
		over
	    mex mey distf 16 >> mixcolor acpx!+
	    ma 'mex +! mb 'mey +!
		) 2drop ;
:rlq
	QFULL =? ( drop Rdegfill ; )
	1? ( Rdegalpha ; )
	drop dup 2 << a+ dup ma * 'mex +! mb * 'mey +! ;

:runlenRdeg
    mtx neg ma * over BPP >> mty - mb * - 'mex !
    mtx neg mb * over BPP >> mty - ma * + 'mey !
	'runlenscan
	( @+ 1?
		dup getlen swap getval rlq
		) 2drop
	-4 a+ ;

|------------------ textura
:Texfill
	( 1? 1 -
	    mex 8 >> $ff and mey $ff00 and or 2 << tex + @ a!+
	    ma 'mex +! mb 'mey +!
		) drop ;
:Texalpha
	$ff xor swap
	( 1? 1 - over
	    mex 8 >> $ff and mey $ff00 and or 2 << tex + @ acpx!+
	    ma 'mex +! mb 'mey +!
		) 2drop ;

:rlq
	QFULL =? ( drop Texfill ; )
	1? ( Texalpha ; )
	drop dup 2 << a+ dup ma * 'mex +! mb * 'mey +! ;

:runlenTex
    mtx neg ma * over BPP >> mty - mb * - 'mex !
    mtx neg mb * over BPP >> mty - ma * + 'mey !
	'runlenscan
	( @+ 1?
		dup getlen swap getval rlq
		) 2drop
	-4 a+ ;

|--------------------
#runlencover 'runlenSolid

|*******************************
::FMAT 'mb ! 'ma ! ;
::FCEN 'mty ! 'mtx ! ;
::FCOL 'col2 ! 'col1 ! ;

::SFILL	'runlenSolid 'runlencover ! ;
::RFILL	'runlenRdeg 'runlencover ! ;
::LFILL	'runlenLdeg 'runlencover ! ;
::TFILL	'runlenTex 'runlencover ! ;

|---------- HEAP
:]heap | nro -- adrr
	2 << 'heapseg + ;

:heap! | nodo --
	heapcnt dup 1 + 'heapcnt !
	( 1?
		dup 1 - 1 >>	| v j i
		dup ]heap @ | v j i vi
		pick3 <? ( 2drop ]heap ! ; )
		rot ]heap !	| v i
		) drop
	'heapseg ! ;

:heapl
	heapcnt >=? ( drop ; )
	]heap @	| val pos ch1 V1 V2
	>? ( drop 1 + dup ]heap @ ) | val pos chm Vm
	;

:moveDown | nodo pos --
	( heapcnt 1 >> <?
		dup 1 << 1 + 		| val pos ch1
		dup ]heap @	| val pos ch1 v1
		over 1 +         | val pos ch1 v1 ch2
		heapl pick3 				| value pos chM vM va
		>=? ( 2drop ]heap ! ; )		| value pos chM vM
		rot over swap ]heap !	| value chM vM
		drop )
	]heap ! ;

:heap@ | -- nodo
	heapseg heapcnt
	1 - ]heap @ 0 MoveDown
	heapcnt 1 -
	0? ( -1 'heapseg ! )
	'heapcnt !
	;

|************************************
:PLINEI | x y --
	pyBPP =? ( drop 'pxBPP ! ; )
	pxBPP pyBPP 2over 'pyBPP ! 'pxBPP !
	pick2 >? ( 2swap ) 				| x2 y2 x1 y1
	sh BPP << >=? ( 4drop ; )
	rot 0 <=? ( 4drop ; ) 			| x2 x1 y1 y2
	ymax >? ( dup 'ymax ! )		| comprueba el mayor
	>r >r FBASE << swap FBASE << 	| x1 x2
	over - r> r@ over -				| x1 (x2-x1) y1 (y2-y1)
	rot swap / swap					| x1 t y1
	-? ( neg over * rot + swap 0 )	| x1 t y1
	dup 16 << segs> 'segs - 4 >> or heap! | ubica en heap
	segs> !+ rot pick2 1 >> + swap !+ !+
	r> swap !+ 'segs> !
	;

|------------------------------------
:clearscan
	0 sw 1 + setlen 'runlenscan !+ ! ;

:searchscan | valor -- valor
	( b@+ 1? 
		getpos over >? ( drop -8 b+ ; )
		drop ) drop
	-8 b+ ;

:inserta1 | --
	b> >r
	b@+
	( b@ 1? swap b!+ )
	swap b!+ b!
	r> >b ;

:inserta2 | --
	b> >r
	b@+ dup | j k
	( b@ 1? rot b!+ )
	rot b!+ swap b!+ b!
	r> >b ;

:add.1 | val pos --
	b@ dup getlen	| val pos v len
	1 =? ( drop nip + b!+ ; )
	drop swap over getpos | val v pos posv
	=? ( inserta1
		drop swap 	| v val
		over $fff001ff and + $200 or b!+
		$100000 + $200 - b! ; )
	b> 4 + @ getpos 1 - | val v pos posf
	=? ( inserta1 | val v pos
		over $200 - b!+
		setpos $200 or swap getval rot + or b!+ ; )
	inserta2 | val v pos
	over $fff001ff and over pick3 getpos - setlen or b!+
	rot | v pos val
	pick2 getval + $200 or over setpos or b!+
	1 + | v pos+1
	b@ dup getpos swap getlen +
	over - setlen swap setpos or
	swap getval or b! ;

:add.len | pos len --
	1 =? ( drop VALUES swap add.1 ; )
	b@ getlen
	over >? (	| pos len lenv
		inserta1
		pick2 setpos pick2 setlen or b@ getval VALUES + or b!+
		over - setlen rot rot + setpos or b@ getval or
		b! ; )
	over <? ( 	| pos len lenv
		b@ VALUES + b!+
		rot over + rot rot -
		add.len ; )
	3drop b@ VALUES + b!+ ;


:coverl
	+? ( rot MASK and VALUES swap -
		over add.1 1 + sw >=? ( 3drop r> drop ; ) |??
		; )
	drop nip 0 'runlenscan >b ;

|	+? ( rot MASK and VALUES swap -
|			over add.1
|			1 + sw >=? ( 3drop ; ) |<<exit
|		)( drop nip 0 'runlenscan >b )

:limup	| xb x0 x1 largo
	sw >? ( sw pick2 - ; )
	dup pick2 - ;

:limdn | xb x1
	0 >? ( rot swap add.len ; )
	drop nip ;

:coverpixels | xb xa --
    over BPP >> -? ( 3drop ; )
	over BPP >> sw >=? ( 4drop ; )
	searchscan
	| xb xa x1 x0
	over =? ( nip rot MASK and rot MASK and -
			1? ( swap add.1 ; )
			2drop ; )
	| xb xa x1 x0
	coverl
	| xb x1 x0
	swap
	limup limdn
	sw <? ( swap MASK and 1? ( swap add.1 ; ) )
	2drop ;

:fillcover
	'runlenscan >b
	'activos ( activos> 4 - <?
		@+ 4 + @ FBASE >> swap @+ 4 + @ FBASE >> rot
		coverpixels
		) drop ;

|-----------------------------
:-activos	| --
	'activos 'activos> ! ;

:activosort | v x t1 --
	( 'activos >? 4 -		| v x t1
		dup @ 				| v x t1 n1
		dup 4 + @			|  v x t1 n1 nx
		pick3 <? ( 2drop nip 4 + ! ; ) drop
		| v x t1 v1
		over 4 + ! )
	nip ! ;

:activos!+ | v --	; agrega ordenado
	dup 4 + @ 	| v x
	activos> 	| v x t1
	dup 4 + 'activos> !
	activosort ;

:activosresort | nodo seg -- nodo	; incrementa y ordena
	dup 4 + @+ swap @ +	| nodo seg newx
	dup pick2 4 + !		| nodo seg newx
	pick2				| nodo seg newx nodo
	activosort ;

:advanceline
	'activos ( activos> <?
		dup @ activosresort 4 + ) drop ;

:delc
	pick4 >? ( drop rot !+ swap ; ) 2drop ;

:deletecopy | nodoa --
	dup 4 + 	| en desde
	( activos> <?
		@+ dup 12 + @	| en desde seg yfin
		delc
		) drop
	'activos> ! ;

:deleteline
	'activos ( activos> <?
		dup @ 12 + @ pick2 =? ( drop deletecopy ; ) drop
		4 + ) drop ;

|-----------------------
:endpoli
	'segs 'segs> !
	-1 'ymax !
	0 'heapcnt ! ;

|*******************************
::POLI
	ymax -? ( drop endpoli ; )
	sh BPP << >? ( sh BPP << 'ymax ! ) drop
	-activos
	heapseg 16 >> dup | newy ymin
	b> >r
	0 over BPP >> setxy
	( ymax <?
        clearscan
		VALUES ( 1? 1 - >r
	    	( over =? nip	| agrega nuevos ordenados
				heap@ $ffff and 4 << 'segs + activos!+
	           	heapseg 16 >> swap )
			fillcover
	        1 +
			deleteline
			advanceline
			r> ) drop
		runlencover ex
		) 2drop
	r> >b
	endpoli	;


|*******************************
:PCURVEI | fx fy cx cy --
	pick3 pxBPP + pick2 1 << - abs
	pick3 pyBPP + pick2 1 << - abs  +
	TOLERANCE <? ( 3drop PLINEI ; ) drop
	pick3 pick2 + 1 >>  pick3 pick2 + 1 >>		| fx fy cx cy c2 c2
	2swap 									| fx fy c2 c2 cx cy
	pyBPP + 1 >> swap pxBPP + 1 >> swap			| fx fy c2 c2 c1 c1
	pick3 pick2 + 1 >>  pick3 pick2 + 1 >>		| fx fy c2 c2 c1 c1 ex ey
	2swap PCURVEI PCURVEI ;

|*******************************
:c3 | ..
	3 <? ( drop 4drop plineI ; ) drop

:PCURVE3I | xf yf x2 y2 x1 y1
	pick3 pick2 + 1 >> pick3 pick2 + 1 >> 'by ! 'bx !
	'y1 ! 'x1 !
	pick3 pick2 + 1 >> pick3 pick2 + 1 >> 2swap
	'y2 ! 'x2 !
	over bx + 1 >> over by + 1 >>
	over x2 - abs over y2 - abs + >r
	pxBPP x1 + 1 >> pyBPP y1 + 1 >>
	over bx + 1 >> over by + 1 >>
	over x1 - abs over y1 - abs + >r
	2swap >r >r
	pick3 pick2 + 1 >> pick3 pick2 + 1 >>
	2swap r> r>
	r> c3 r> c3 ;

::PLINE | x y --
	BPP << swap BPP << swap PLINEI ;

::PCURVE | x y x y --
	>r >r >r BPP << r> BPP << r> BPP << r> BPP <<
	PCURVEI ;

::PCURVE3 | x y x y x y --
	>r >r >r >r >r
	BPP << r> BPP << r> BPP << r> BPP << r> BPP << r> BPP <<
	PCURVE3I ;

|-------- NO IMPLEMENTADAS!
::ALPHA | a --
	drop ;
