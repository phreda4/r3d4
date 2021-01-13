| Super console
| encode name
| PHREDA 2021
^r3/lib/gui.r3
^r3/lib/fontpc.r3

| 80x30
#screen * 9600

#c1 $ff00
#c2 $0
#vblink

#c.x #c.y
#c.cursor
#c.atrib $ff000000

::c.ink | color --
	26 << c.atrib $00ff0000 and or 'c.atrib ! ;

::c.paper | color --
	18 << c.atrib $ff000000 and or 'c.atrib ! ;

::c.at | x y --
	'c.y ! 'c.x !
:c.in
	c.x c.y
	80 * + 2 <<
	'screen + 'c.cursor ! ;

:c.uscroll
	'screen 80 2 << over + 80 29 * move
	'screen 80 29 * 2 << + $3f000000 80 fill
	;

::c.cr
	0 'c.x !
	c.y 1 + 30 <? ( 'c.y ! c.in ; ) drop
	c.uscroll c.in ;

::c.emit | char --
	$ff and c.atrib or c.cursor !
	c.x 1 + 80 <? ( 'c.x ! c.in ; ) drop
	0 'c.x !
	c.y 1 + 30 <? ( 'c.y ! c.in ; ) drop
	c.uscroll c.in ;

::c.print | "" --
	sprint ( c@+ 1? c.emit ) 2drop ;

::c.semit | "" --
	( c@+ 1? c.emit ) 2drop ;

::c.cls
	'screen 'c.cursor ! 0 'c.x ! 0 'c.y !
	'screen c.atrib 80 30 * fill ;

:c.le
	c.x 0 >? ( 1 - 'c.x ! c.in ; ) drop
	80 1 - 'c.x !
	c.y 0 >? ( 1 - 'c.y ! c.in ; ) drop
	c.in ;
:c.ri
	c.x 80 <? ( 1 + 'c.x ! c.in ; ) drop
	0 'c.x !
	c.y 30 <? ( 1 + 'c.y ! c.in ; ) drop
	c.in ;
:c.up
	c.y 0 >? ( 1 - 'c.y ! c.in ; ) drop
	30 1 - 'c.y !
	c.in ;
:c.dn
	c.y 30 <? ( 1 + 'c.y ! c.in ; ) drop
	0 'c.y !
	c.in ;

:uni2ascii
	$80 <? ( ; )
	dup $1f and 6 << swap 8 >> $3f and or ;

|---------------------------------------------
#paleta
$000000 $05fec1 $32af87 $387261 $1c332a $2a5219 $2d8430 $00b716
$50fe34 $a2d18e $84926c $aabab3 $cdfff1 $05dcdd $499faa $2f6d82
$3894d7 $78cef8 $bbc6ec $8e8cfd $1f64f4 $25477e $72629f $a48db5
$f5b8f4 $df6ff1 $a831ee $3610e3 $241267 $7f2387 $471a3a $93274e
$976877 $e57ea3 $d5309d $dd385a $f28071 $ee2911 $9e281f $4e211a
$5b5058 $5e4d28 $7e751a $a2af22 $e0f53f $fffbc6 $dfb9ba $ab8c76
$eec191 $c19029 $f8cb1a $ea7924 $a15e30 $1A1C2C $5D275D $B13E53
$EF7D57 $FFCD75 $A7F070 $38B764 $257179 $29366F $3B5DC9 $ffffff

:get6paleta 2 << 'paleta + @ ;

:pix | v mask -- v
	and? ( c1 a!+ ; )
	c2 a!+ ;

:2pix | v mask -- v
	and? ( c1 dup a!+ a!+ ; )
	c2 dup a!+ a!+ ;

:decodegrap
	$ffff and
	pick2 2 >> $3 and 2 << >>
	$8 2pix $4 2pix $2 2pix $1 2pix
	drop
	;

:decodechar | y -xc -- y -xc pix
	b@+
	dup 26 >> $3f and get6paleta 'c1 !
	dup 18 >> $3f and get6paleta 'c2 !
	$10000 and? ( decodegrap ; )
	0 swap $20000 and? ( nip vblink swap )
	$ff and 4 << 'font8x16 + pick3 $f and + c@ xor
	$80 pix $40 pix $20 pix $10 pix $8 pix $4 pix $2 pix $1 pix
	drop
	;

:drawline | y --
	dup 4 >> 80 2 << * 'screen + >b | nextcharline
	80 ( 1? 1 - decodechar ) drop ;

#c.prevc

:drawcon
	c.cursor dup @ dup 'c.prevc !
	$20000 or swap !
	0 blink 1? ( $ffffff or swap ) drop 'vblink !
	sw 640 - 1 >>
	sh 480 - 1 >>
	xy>v >a
	0 ( 480 <?
		drawline
		sw 640 - 2 << a+
		1 + ) drop
	c.prevc c.cursor ! ;

|--------------------------
#spad * 1024
#spad> 'spad
#x #y

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

#modo 'lins

:chmode
	modo 'lins =? ( drop 'lover 'modo ! ; )
	drop 'lins 'modo ! ;

:refresh
	x y c.at 'spad c.semit 32 c.emit
	pad> padi> - x + y c.at
	;

:keyinput
	char 1? ( modo ex refresh ; ) drop
	key 0? ( drop ; )
	<ins> =? ( chmode )
	<le> =? ( kizq ) <ri> =? ( kder )
	<back> =? ( kback ) <del> =? ( kdel )
	<home> =? ( padi> 'pad> ! ) <end> =? ( padf> 'pad> ! )
	<tab> =? ( ktab )
	drop
	refresh
	;

:newpad
	c.x 'x !
	c.y 'y !

	1023 'cmax !
	'spad dup 'padi> !
	( c@+ 1? drop ) drop 1 -
	dup 'pad> ! 'padf> !
	'lins 'modo !

	;

:enterline
	3 c.paper
	x y c.at 'spad c.semit c.cr
	0 c.paper
	0 'spad !
	newpad
	;

::keys
	keyinput

	key
	>esc< =? ( exit )
	<ret> =? ( enterline )
	drop
	;



:main
	drawcon
	keys
	refresh
	;

:
	c.cls
	63 c.ink
	"r3 console" c.print c.cr
    newpad
	'main onshow ;