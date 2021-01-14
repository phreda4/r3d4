| r3 interactive
| experiment for make a r3computer like jupiter ace
| PHREDA 2021

^./sconsolepc.r3
^r3/lib/parse.r3
^r3/lib/gui.r3

#diccb * 1024

#spad * 1024
#spad> 'spad

#memory
#memory>

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

|----------------------
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
	c.x 'x ! c.y 'y !
	1023 'cmax !
	'spad dup 'padi> !
	( c@+ 1? drop ) drop 1 -
	dup 'pad> ! 'padf> !
	'lins 'modo !
	;

|----------------------
:char6bit | char -- 6bitchar
	$1f - dup $40 and 1 >> or $3f and ;

:name2code | "" -- 32
|	0 over 10 + c! | cut 10=64bits 5=32bits
	0 ( swap c@+ 1? char6bit rot 6 << or ) 2drop ;

#buffer * 16

:6bitchar | 6bc -- char
	$3f and $1f + ;

:code2name | nn -- buf
	'buffer 15 + 0 over c! 1 -
	( swap 1? dup 6bitchar pick2 c! 6 >>>
		swap 1 - ) drop 1 + ;
|--------------------------------------------
#wbase
";" "(" ")" "[" "]"
"EX" "0?" "1?" "+?" "-?"
"<?" ">?" "=?" ">=?" "<=?" "<>?" "AND?" "NAND?" "BT?"
"DUP" "DROP" "OVER" "PICK2" "PICK3" "PICK4" "SWAP" "NIP"
"ROT" "2DUP" "2DROP" "3DROP" "4DROP" "2OVER" "2SWAP"
"@" "C@" "@+" "C@+" "!" "C!" "!+" "C!+" "+!" "C+!"
">A" "A>" "A@" "A!" "A+" "A@+" "A!+"
">B" "B>" "B@" "B!" "B+" "B@+" "B!+"
"NOT" "NEG" "ABS" "SQRT" "CLZ"
"AND" "OR" "XOR" "+" "-" "*" "/" "MOD"
"<<" ">>" ">>>" "/MOD" "*/" "*>>" "<</"
"MOVE" "MOVE>" "FILL"
"CMOVE" "CMOVE>" "CFILL"
""


:wordlist
	'diccb >a
	'wbase (
		dup c@ 1? drop
		10 c.ink
		dup c.semit
		11 c.ink
		dup name2code dup " %h " c.print
		a!+
		>>0 ) 2drop
	c.cr
	0 'spad !
	newpad
	;

#error
#lerror

:?base
:?word
	;
:.def
:.var
:.str
:.base
:.adr
:.lit
:.word
	;
:wrd2token | str -- str'
	( dup c@ $ff and 33 <?
		0? ( nip ; ) drop 1 + )	| trim0
|	over "%w" slog | debug
|	$5e =? ( drop >>cr ; )	| $5e ^  Include
|	$7c =? ( drop .com ; )	| $7c |	 Comentario
	$3A =? ( drop .def ; )	| $3a :  Definicion
	$23 =? ( drop .var ; )	| $23 #  Variable
	$22 =? ( drop .str ; )	| $22 "	 Cadena
	$27 =? ( drop 			| $27 ' Direccion
		dup ?base 0 >=? ( .base ; ) drop
		1 + ?word 1? ( .adr ; ) drop
		"Addr not exist" 'error !
		dup 1 - 'lerror !
		drop 0 ; )
	drop
	dup isNro 1? ( drop .lit ; ) drop		| numero
	dup ?base 0 >=? ( .base ; ) drop		| macro
	?word 1? ( .word ; ) drop		| palabra
 	"Word not found" 'error !
	dup 'lerror !
	drop 0 ;

:enterline
	3 c.paper
	x y c.at 'spad c.semit c.cr
	4 c.paper
	'spad name2code
	5 c.paper
	dup "%h" c.print c.cr
	7 c.paper
	code2name c.semit c.cr
	0 c.paper
	0 'spad !
	newpad
	;


:main
	drawcon
	keyinput

	key
	>esc< =? ( exit )
	<ret> =? ( enterline )
	<f1> =? ( wordlist )
	drop
	;

:mm
	mark
	here
	dup 'memory !
	dup 'memory> !
	;

:
	mm
	c.cls
	63 c.ink
	"r3 console" c.print c.cr
	wordlist
    newpad
	'main onshow ;