| edit-code
| PHREDA 2007
|---------------------------------------
^r3/lib/math.r3
^r3/lib/mem.r3
^r3/lib/print.r3
^r3/lib/sprite.r3

^r3/lib/fontm.r3
^r3/fntm/droidsans13.fnt

#name * 1024

#pantaini>	| comienzo de pantalla
#pantafin>	| fin de pantalla
#prilinea	| primera linea visible
#cntlinea

#inisel		| inicio seleccion
#finsel		| fin seleccion

#fuente  	| fuente editable
#fuente> 	| cursor
#$fuente	| fin de texto

#clipboard	|'clipboard
#clipboard>

#undobuffer |'undobuffer
#undobuffer>

|----- find text
#findpad * 64
#findmode


|----- edicion
:lins  | c --
	fuente> dup 1 - $fuente over - 1 + cmove>
	1 '$fuente +!
:lover | c --
	fuente> c!+ dup 'fuente> !
	$fuente >? ( dup '$fuente ! ) drop
:0lin | --
	0 $fuente c! ;

#modo 'lins

:back
	fuente> fuente <=? ( drop ; )
	dup 1 - c@ undobuffer> c!+ 'undobuffer> !
	dup 1 - swap $fuente over - 1 + cmove
	-1 '$fuente +!
	-1 'fuente> +! ;

:del
	fuente>	$fuente >=? ( drop ; )
    1 + fuente <=? ( drop ; )
	9 over 1 - c@ undobuffer> c!+ c!+ 'undobuffer> !
	dup 1 - swap $fuente over - 1 + cmove
	-1 '$fuente +! ;

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

#1sel #2sel

:selecc	| agrega a la seleccion
	mshift 0? ( dup 'inisel ! 'finsel ! ; ) drop
	inisel 0? ( fuente> '1sel ! ) drop
	fuente> dup '2sel !
	1sel over <? ( swap )
	'finsel ! 'inisel !
	;

:khome
	selecc
	fuente> 1 - <<13 1 + 'fuente> !
	selecc ;

:kend
	selecc
	fuente> >>13  1 + 'fuente> !
	selecc ;

:scrollup | 'fuente -- 'fuente
	pantaini> 1 - <<13 1 - <<13  1 + 'pantaini> !
	prilinea 1? ( 1 - ) 'prilinea !
	selecc ;

:scrolldw
	pantaini> >>13 2 + 'pantaini> !
	pantafin> >>13 2 + 'pantafin> !
	1 'prilinea +!
	selecc ;

:colcur
	fuente> 1 - <<13 swap - ;

:karriba
	fuente> fuente =? ( drop ; )
	selecc
	dup 1 - <<13		| cur inili
	swap over - swap	| cnt cur
	dup 1 - <<13			| cnt cur cura
	swap over - 		| cnt cura cur-cura
	rot min + fuente max
	'fuente> !
	selecc ;

:kabajo
	fuente> $fuente >=? ( drop ; )
	selecc
	dup 1 - <<13 | cur inilinea
	over swap - swap | cnt cursor
	>>13 1 +    | cnt cura
	dup 1 + >>13 1 + 	| cnt cura curb
	over -
	rot min +
	'fuente> !
	selecc ;

:kder
	selecc
	fuente> $fuente <?
	( 1 + 'fuente> ! selecc ; ) drop
	;

:kizq
	selecc
	fuente> fuente >?
	( 1 - 'fuente> ! selecc ; ) drop
	;

:kpgup
	selecc
	20 ( 1?
		1 - karriba ) drop
	selecc ;

:kpgdn
	selecc
	20 ( 1?
		1 - kabajo ) drop
	selecc ;

|------------------------------------------------
:loadtxt | -- cargar texto
	mark
	here 'name getpath
	load 0 swap c!

	|-- queda solo cr al fin de linea
	fuente dup 'pantaini> !
	here ( c@+ 1?
		13 =? ( over c@
				10 =? ( rot 1 + rot rot ) drop )
		10 =? ( drop c@+ 13 <>? ( drop 1 - 13 ) )
		rot c!+ swap ) 2drop '$fuente !
	0lin

	empty
	;

:savetxt
	mark	| guarda texto
	fuente ( c@+ 1?
		13 =? ( ,c 10 ) ,c ) 2drop
	'name savemem
	empty ;

:runfile
	savetxt
	mark
	"r3 " ,s 'name ,s ,eol
	empty here sys drop
	;
	
:mkplain
	savetxt
	"r3 r3/sys/r3plain.r3" sys drop
	;

|-------------------------------------------
:copysel
	inisel 0? ( drop ; )
	clipboard swap
	finsel over - pick2 over + 'clipboard> !
	cmove
	;

:borrasel
	inisel finsel $fuente finsel - 4 + cmove
	finsel inisel - neg '$fuente +!

|	fuente>
|	inisel >=? ( finsel <=? ( inisel 'fuente> ! )( finsel inisel - over swap - 'fuente> ! ) )  drop

	0 dup 'inisel ! 'finsel ! ;

:kdel
	inisel 0? ( drop del ; )
	drop borrasel ;

:kback
	inisel 0? ( drop back ; )
	drop borrasel ;

|-------------
| Edit CtrE
|-------------
:posfijo? | adr -- desde/0
	( c@+ 1?
		46 =? ( drop ; )
		drop )
	nip ;

:editvalid | adr -- adr 1/0
    "ico" =pre 1? ( ; ) drop
    "bmr" =pre 1? ( ; ) drop
    "vsp" =pre 1? ( ; ) drop
    "spr" =pre
	;

#ncar
:controle
	savetxt
	fuente> ( dup 1 - c@ $ff and 32 >? drop 1 - ) drop | busca comienzo
	dup c@
	$5E <>? ( 2drop ; ) | no es ^
	drop
	dup fuente - 'ncar !
	dup 2 + posfijo? 0? ( 2drop ; )
	editvalid 0? ( 3drop ; ) drop
	swap 1 + | ext name
	mark
	dup c@ 46 =? ( swap 2 + 'path ,s ) drop
	,w
|	dup "mem/inc-%w.mem" mformat savemem
	empty
|	"r4/system/inc-%w.txt" mformat run
	drop
	;

|-------------
:controlc | copy
	copysel ;

|-------------
:controlx | move
	controlc
	borrasel ;

|-------------
:controlv | paste
	clipboard clipboard> over - 0? ( 3drop ; ) | clip cnt
	fuente> dup pick2  + swap | clip cnt 'f+ 'f
	$fuente over - 1 + cmove>	| clip cnt
	fuente> rot rot | f clip cnt
	dup '$fuente +!
	cmove
	clipboard> clipboard - 'fuente> +!
	;

|-------------
:controlz | undo
	undobuffer>
	undobuffer =? ( drop ; )
	1 - dup c@
	9 =? ( drop 1 - dup c@ [ -1 'fuente> +! ; ] >r )
	lins 'undobuffer> ! ;

|-------------
:=w | w1 w2 -- 1/0
	( c@+ 32 >?
		toupp rot c@+ toupp rot - 1? ( 3drop 0 ; ) drop swap ) 3drop 1 ;

:exactw | adr 1c act cc -- adr 1c act 1/0
	drop dup pick3 =w ;

:setcur | adr 1c act 1
	drop nip nip 'fuente> ! ;

:controla | -- ;find prev
	'findpad
	dup c@ $ff and
	0? ( 2drop ; )
	toupp
	fuente> 1 - | adr 1c act
	( fuente >?
		dup c@ toupp pick2 =? ( exactw 1? ( setcur ; ) )
		drop 1 - ) 3drop ;

:controls | -- ;find next
	'findpad
	dup c@ $ff and
	0? ( drop ; )
	toupp
	fuente> 1 + | adr 1c act
	( $fuente <?
		dup c@ toupp pick2 =? ( exactw 1? ( setcur ; ) )
		drop 1 + ) 3drop ;

:controlf | -- ;find
	findmode 1 xor 'findmode !
|	0 update dro
|	refreshfoco
	;

|-------------
:controld | buscar definicion
	;

:controln  | new
	| si no existe esta definicion
	| ir justo antes de la definicion
	| agregar palabra :new  ;
	;

|------ Dibuja codigo

:drawsel | com -- com
	inisel 0? ( drop ; ) drop
|	finsel >=? ( ; )
|	dup ( inisel <? c@+ 13 =? ( 2drop ; ) gemit )
|	sel>> $88 'ink !
|	( finsel <? c@+ 13 =? ( 2drop sel<< ; ) gemit )
|	drop sel<<
	;

|---------------------------------------
:lineacom | adr c -- adr++
	( 13 =? ( drop 1 - ; ) emit c@+ 1? )
	drop 1 - ;

:palstr | adr c -- adr++
	( emit c@+ 34 =? ( emit ; ) $ff and 31 >? )
	drop 1 - ;

:npal
	( $ff and 32 >? emit c@+ )
	drop 1 - ;

:col_inc $0 $ffff00 fontmcolor ;
:col_com $0 $555555 fontmcolor ;
:col_cod $0 $ff0000 fontmcolor ;
:col_dat $0 $ff00ff fontmcolor ;
:col_str $0 $ffffff fontmcolor ;
:col_adr $0 $ffff fontmcolor ;
:col_nor $0 $ff00 fontmcolor ;

:wordcolor | adr c -- ar..
	32 =? ( drop sp ; )
	9 =? ( drop tab ; )
	$5e =? ( col_inc npal ; )	| $5e ^  Include
	$7c =? ( col_com lineacom ; )	| $7c |	 Comentario
	$3A =? ( col_cod npal ; )		| $3a :  Definicion
	$23 =? ( col_dat npal ; )	| $23 #  Variable
	$22 =? ( col_dat palstr ; )	| $22 "	 Cadena
	$27 =? ( col_adr npal ; )		| $27 ' Direccion
|	over 1 - isNro 1? ( drop amarillo npal ; ) drop
|	over 1 - ?macro 1? ( drop verde npal ; ) drop		| macro
	col_nor npal ;

:codelinecolor | adr -- adr++/0
	col_nor
	( c@+ 1?
		13 =? ( drop ; )
		wordcolor
		) nip ;

:linenro | lin -- lin
	$222222 $aaaaaa fontmcolor
	dup prilinea + .d 3 .r. emits sp ;

#ycursor
#xcursor

:emitcur
	13 =? ( drop cr 1 'ycursor +! 0 'xcursor ! ; )
	9 =? ( drop gtab 4 'xcursor ! ; )
	1 'xcursor +!
	noemit ;

:drawcursor
	blink 1? ( drop ; ) drop
	0 1 gotoxy
	prilinea 'ycursor ! 0 'xcursor !
	pantaini>
	( fuente> <? c@+ emitcur ) drop
	32 noemit 32 noemit 32 noemit 32 noemit 32 noemit
	ccx ccy xy>v >a
	cch ( 1? 1 -
		ccw ( 1? 1 -
			a@ not a!+
			) drop
		sw ccw - 2 << a+
		) drop ;

:drawcode
	0 1 gotoxy
	pantaini>
	0 ( cntlinea <?
		linenro
		swap
|		drawsel lf
		codelinecolor 0? ( 2drop ; )
		cr
		swap 1 + ) drop
	$fuente <? ( 1 - ) 'pantafin> !
	fuente>
	( pantafin> >? scrolldw )
	( pantaini> <? scrollup )
	drop
	drawcursor
	;

|-------------- panel control
#panelcontrol

:controlon	1 'panelcontrol ! ;
:controloff 0 'panelcontrol ! ;

:showclip
	cr
 	clipboard> clipboard <>? (
		$ffff 'ink !
		cr
		clipboard ( over <? c@+ emit ) drop
		cr
		) drop
	;

|--- sobre pantalla
:mmemit | adr x xa -- adr x xa
	rot c@+
	13 =? ( 0 nip )
	0? ( drop 1 - rot rot sw + ; )
	9 =? ( drop swap $ffffffe0 and $20 + rot swap ; )
	drop swap ccw + rot swap ;

:cursormouse
	xypen
	pantaini>
	swap cch 1 <<			| x adr y ya
	( over <?
		cch + rot >>13 2 + rot rot ) 2drop
	swap ccw 2 << ccw +	| adr x xa
	( over <? mmemit ) 2drop
	'fuente> ! ;

:dns
	cursormouse
	fuente> '1sel ! ;

:mos
	cursormouse
	fuente> 1sel over <? ( swap )
	'finsel ! 'inisel ! ;

:ups
	cursormouse
	fuente> 1sel over <? ( swap )
	'finsel ! 'inisel ! ;

|---------- manejo de teclado
:buscapad
	fuente 'findpad findstri
	0? ( drop ; ) 'fuente> ! ;

:findmodekey
	$0 'ink !
	|1 linesfill
	" > " emits

	key
    <ret> =? ( controlf )
	>esc< =? ( controlf )
    drop

	$ffffff 'ink !
|	'buscapad 'findpad 31 inputexec
	;

:controlkey
	" F-Find" emits

|	'controle 18 ?key " E-Edit" emits | ctrl-E dit
||	'controlh 35 ?key " H-Help" emits  | ctrl-H elp
|	'controlz 44 ?key " Z-Undo" emits

|	'controlx 45 ?key " X-Cut" emits
|	'controlc 46 ?key " C-Copy" emits
|	'controlv 47 ?key " V-Paste" emits

||	'controld 32 ?key " D-Def" emits

||	'controln 49 ?key " N-New" emits
||	'controlm 50 ?key " M-Mode" emits
|	'controlf 33 ?key " F-Find" emits

|	'controla <up>
|	'controls <dn>
|	'controloff >ctrl<

|	'findpad
|	dup c@ 0? ( 2drop ; ) drop
|	" (%s)" print

	;

:teclado
	char
	1? ( modo ex ; )
	drop
	key
	<back> =? ( kback )
	<del> =? ( kdel )
	<up> =? ( karriba )
	<dn> =? ( kabajo )
	<ri> =? ( kder )
	<le> =? ( kizq )
	<home> =? ( khome )
	<end> =? ( kend )
	<pgup> =? ( kpgup )
	<pgdn> =? ( kpgdn )
	<ins> =? (  modo
				'lins =? ( drop 'lover 'modo ! ; )
				drop 'lins 'modo ! )
	<ret> =? (  13 modo ex )
	<tab> =? (  9 modo ex )
	>esc< =? ( exit )

	<ctrl> =? ( controlon )
	>ctrl< =? ( controloff )

	<f1> =? ( runfile )
	<f4> =? ( mkplain )
	drop
	;

:barratop
	home
	$555555 'ink ! backline
	$ff $ffffff fontmcolor
	" r3 " emits
	$3f $ffffff fontmcolor
	" F1.Run " emits

	" F4.Plain " emits
|------------------------------
|	'debugrun dup <f2> "2Debug" $fff37b flink sp
|	'profiler dup <f3> "3Profile" $fff37b flink sp
|	'mkplain dup <f4> "4Plain" $fff37b flink sp
|	'nowcompile dup <f5> "5Compile" $fff37b flink sp
|	'testcompile <f10>
|------------------------------
	;

:barraestado
	0 rows 1 - gotoxy
	$555555 'ink ! backline
	$7f $ffffff fontmcolor sp
	'name emits sp
	$ff $ffffff fontmcolor sp
	xcursor 1 + .d emits sp
	ycursor 1 + .d emits sp

	panelcontrol 1? ( drop controlkey ; ) drop
	findmode 1? ( drop findmodekey ; ) drop
	;


:editando
	cls
	barratop
	barraestado

|	'dns 'mos 'ups guiMap |------ mouse

	drawcode
	acursor
	teclado
	;

:editor
	0 'paper !
	rows 2 - 'cntlinea !
	'editando onshow
	;

|---- Mantiene estado del editor
:ram
	here	| --- RAM
	dup 'fuente !
	dup 'fuente> !
	dup '$fuente !
	$3ffff +			| 256kb texto
	dup 'clipboard !
	dup 'clipboard> !
	$3fff +				| 16KB
	dup 'undobuffer !
	dup 'undobuffer> !
	$ffff +         	| 64kb
	'here  ! | -- FREE
	mark
	;

|----------- principal
:main
	'name "mem/main.mem" load drop
	'fontdroidsans13 fontm
	ram
	loadtxt
	editor
	savetxt
	;

: mark 4 main ;
