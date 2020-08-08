|MEM 8192  | 8MB
| r3debug
| PHREDA 2020
|------------------
^./r3base.r3
^./r3pass1.r3
^./r3pass2.r3
^./r3pass3.r3
^./r3pass4.r3

^./r3vm.r3

^r3/lib/print.r3
^r3/lib/input.r3
^r3/lib/fontm.r3
^media/fntm/droidsans13.fnt

#name * 1024
#namenow * 256

::r3debuginfo | str --
	r3name
	here dup 'src !
	'r3filename
	2dup load
|	"load" slog
	here =? ( 3drop "no src" 'error ! ; )

	src only13

	0 swap c!+ 'here !
	0 'error !
	0 'cnttokens !
	0 'cntdef !
	'inc 'inc> !
	r3fullmode
|	"stage 1" slog
	swap r3-stage-1
	error 1? ( drop ; ) drop
|	"stage 2" slog
	r3-stage-2
	1? ( drop ; ) drop
|	"stage 3" slog
	r3-stage-3
|	"stage 4" slog
	r3-stage-4
|	"stage ok" slog
|	"Ok" 'error !
	;

:no10place | adr
	lerror 0? ( ; )
	0 src ( pick2 <? c@+
		10 <>? ( rot 1 + rot rot )
		drop ) drop nip ;

:savedebug
	mark
	error ,s ,cr
	no10place ,d ,cr
	"mem/debuginfo.db" savemem
	empty ;

:emptyerror
 	0 0	"mem/debuginfo.db" save ;

:exitonerror
	savedebug
	|savedicc savecode
	;

#emode
|------ MEMORY VIEW
#actworld 0
#iniworld 0

:incmap
	'inc ( inc> <?
		@+ swap @+
		rot "%l %h" print cr
		) drop ;

:memorydic
	0 ( rows 4 - <?
		dup 4 << dicc +
		@+ "%w " print
		@+ "%h " print
		@+ "%h " print
		@ "%h " print
		cr
		1 + ) drop
	;

:memorymap
	$ff00 'ink !
	0 1 gotoxy
	memorydic
	;

|------ CODE VIEW
#xcode 5
#ycode 1
#wcode 40
#hcode 25

#xlinea 0
#ylinea 0	| primera linea visible
#ycursor
#xcursor

#xseli	| x ini win
#xsele	| x end win

#pantaini>	| comienzo de pantalla
#pantafin>	| fin de pantalla
#fuente  	| fuente editable
#fuente> 	| cursor
#$fuente	| fin de texto

|------------- sourc code

:col_inc $ff7f00 'ink ! ;
:col_com $666666 'ink ! ;
:col_cod $ff0000 'ink ! ;
:col_dat $ff00ff 'ink ! ;
:col_str $ffffff 'ink ! ;
:col_adr $ffff 'ink ! ;
:col_nor $ff00 'ink ! ;
:col_nro $ffff00 'ink ! ;
:col_select $444444 'ink ! ;

#mcolor

:wcolor
	mcolor 1? ( drop ; ) drop
	over c@
	$5e =? ( drop col_inc ; )				| $5e ^  Include
	$7c =? ( drop col_com 1 'mcolor ! ; )	| $7c |	 Comentario
	$3A =? ( drop col_cod ; )				| $3a :  Definicion
	$23 =? ( drop col_dat ; )				| $23 #  Variable
	$27 =? ( drop col_adr ; )				| $27 ' Direccion
    drop
	over isNro 1? ( drop col_nro ; ) drop
	col_nor
	;

| "" logic
:strcol
	mcolor
	0? ( drop col_str 2 'mcolor ! ; )
	1 =? ( drop ; )
	drop
	over c@ $22 <>? ( drop
		mcolor 3 =? ( drop 2 'mcolor ! ; )
		drop 0 'mcolor ! ; ) drop
	mcolor 2 =? ( drop 3 'mcolor ! ; ) drop
	2 'mcolor !
	;

:iniline
	0 'mcolor !
	xlinea wcolor
	( 1? 1 - swap
		c@+ 0? ( drop nip 1 - ; )
		13 =? ( drop nip 1 - ; )
		9 =? ( wcolor )
		32 =? ( wcolor )
		$22 =? ( strcol )
		drop swap ) drop ;

:emitl
	9 =? ( drop gtab ; )
	emit ccx xsele <? ( drop ; ) drop
	( c@+ 1? 13 <>? drop ) drop 1 -		| eat line to cr or 0
	wcode xcode + gotox
	$ffffff 'ink ! "." print
	;

:drawline
	iniline
	( c@+ 1?
		13 =? ( drop ; )
		9 =? ( wcolor )
		32 =? ( wcolor )
		$22 =? ( strcol )
		emitl
		) drop 1 - ;

|..............................
:linenro | lin -- lin
	$aaaaaa 'ink !
	dup ylinea + 1 + .d 3 .r. emits sp ;

:<<13 | a -- a
	( fuente >=?
		 dup c@
		13 =? ( drop ; )
		drop 1 - ) ;

:>>13 | a -- a
	( $fuente <?
		 dup c@
		13 =? ( drop 1 - ; ) | quitar el 1 -
		drop 1 + )
	drop $fuente 2 - ;

:scrollup | 'fuente -- 'fuente
	pantaini> 1 - <<13 1 - <<13  1 + 'pantaini> !
	ylinea 1? ( 1 - ) 'ylinea ! ;

:scrolldw
	pantaini> >>13 2 + 'pantaini> !
	pantafin> >>13 2 + 'pantafin> !
	1 'ylinea +! ;

|..............................
:drawcode
	pantaini>
	0 ( hcode <?
		0 ycode pick2 + gotoxy
		linenro
		xcode gotox
		swap drawline
		swap 1 + ) drop
	$fuente <? ( 1 - ) 'pantafin> !
 	;

:setcodecursor
	fuente>
	( pantafin> >? scrolldw )
	( pantaini> <? scrollup )
	drop ;



:setsource | src --
	dup 'pantaini> !
	dup 'fuente !
	dup 'fuente> !
	count + '$fuente !
	;

:gotosrc
	;

|---------------------------------
:btnf | "" "fx" --
	sp
	$ff0000 'ink ! backprint
	$ffffff 'ink ! emits
	0 'ink ! emits
	;

:barratop
	home
	$B2B0B2 'ink ! backline
	$0 'ink !
	" D3bug " emits
	"PLAY/VIEW" "TAB" btnf
	"INSPECT" "F2" btnf
	"MEMORY" "F3" btnf
	"RUN" "F4" btnf

	'namenow printr
	;

|----- scratchpad
#outpad * 2048
#inpad * 1024

:console
	xsele cch op
	wcode hcode 1 + gotoxy
	xsele ccy pline
	sw ccy pline
	sw cch pline
	$040486 'ink !
	poli


	0 hcode 1 + gotoxy
	$0000AE 'ink !
	rows hcode - 1 - backlines

	$ffffff 'ink !
	'outpad text cr
	" > " emits
	'inpad 1024 input

	0 rows 1 - gotoxy
	"Play2C" "F1" btnf
	"Step" "F2" btnf
	"StepN" "F3" btnf
	"BREAK" "F4" btnf
	"VIEW" "F6" btnf

	;

|------ MODES

#srcview 0

:srcnow | nro --
	inc> 'inc - 4 >> >=? ( drop 'name 'namenow strcpy src setsource ; )
	4 << 'inc +
	@+ "%l" sprint 'namenow strcpy | warning ! is IN the source code
	@ setsource
	;


:calcselect
	xcode wcode + gotox ccx 'xsele !
	xcode gotox ccx 'xseli !
	;

:mode!imm
	0 'emode !
	rows 7 - 'hcode !
	cols 25 - 'wcode !
	calcselect ;

:mode!view
	1 'emode !
	rows 2 - 'hcode !
	cols 6 - 'wcode !
	calcselect ;

|-------------------------------

:modeimm
	drawcode
	console
	key
	>esc< =? ( exit )
	<f1> =? ( fuente> breakpoint playvm gotosrc )
	<f2> =? ( stepvm gotosrc )
	<f3> =? ( stepvmn gotosrc )
	<f4> =? (  fuente> breakpoint )
|	<f6> =? ( viewscreen )
	<tab> =? ( mode!view )
	drop
	;

:modeview
	memorymap

	0 hcode 1 + gotoxy
	$0000AE 'ink !
	rows hcode - 1 - backlines
	0 rows 1 - gotoxy
	"Search" "F3" btnf

	key
	>esc< =? ( exit )
	<f1> =? ( srcview 1 + inc> 'inc - 4 >> >? ( 0 nip ) dup 'srcview ! srcnow )
|	<f3> =? ( )
|	<f4> =? ( )
|	<ctrl> =? ( controlon ) >ctrl< =? ( controloff )
|	<shift> =? ( 1 'mshift ! ) >shift< =? ( 0 'mshift ! )
	<tab> =? ( mode!imm )

	drop
	;


|------ MAIN


:debugmain
	cls gui
	barratop

	emode
	0? ( modeimm )
	1 =? ( modeview )
	drop

	acursor ;

: mark
	'name "mem/main.mem" load drop
	'name r3debuginfo
	error 1? ( drop exitonerror ; ) drop
	emptyerror
	'name "mem/main.mem" load drop
	'fontdroidsans13 fontm

	calcselect
	'name 'namenow strcpy
	src setsource

	mode!imm

	'debugmain onshow
	;

