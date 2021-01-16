| r3 interactive
| experiment for make a r3computer like jupiter ace
| PHREDA 2021

^./sconsolepc.r3
^r3/lib/parse.r3
^r3/lib/gui.r3

|--- Memory map
#sysdic | system diccionary
#basdic | base diccionary
#spad	| scratchpad
#memory
#memory>

|--- memory new definition
| tt(2bit)-codename(30bits) (5chars)
| prev(16bits)-next(16bits)
| tokens or data
|
| #var 0 :cua dup * ;
|
| #var (0)(+4) 0 :cua (-9)(4) [dup] [*] [;]
|
| 34 cua 'var !
|

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

:word2code | "" -- code
	6 0 rot				| cnt acc adr
	( c@+ $ff and
		32 >?
		char6bit
		rot 6 << or		| cnt adr acc
		rot 1 -			| adr acc cnt
		0? ( drop nip ; )
		swap rot ) 2drop nip ;

#buffer * 16

:6bitchar | 6bc -- char
	$3f and $1f + ;

:code2name | nn -- buf
	'buffer 15 + 0 over c! 1 -
	( swap 1? dup 6bitchar pick2 c! 6 >>>
		swap 1 - ) drop 1 + ;
|--------------------------------------------
#wsys
"bye" "words" "see" "edit" "forget"
""

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

:xbye 
:xword 
:xsee 
:xedit 
:xforget
	;

#xsys 'xbye 'xword 'xsee 'xedit 'xforget


:makedicc | adr list -- adr'
	swap >a
	( dup c@ 1? drop
		dup name2code a!+
		>>0 ) 2drop
	0 a!+ a> ;


#error
#lerror

:?dicc | adr dicc -- nro+1/0
	swap word2code
	over
	( @+ 1?
		pick2 =? ( drop pick2 - 2 >> nip nip ; )
		drop ) 4drop 0 ;

:?base	basdic ?dicc ;
:?sys	sysdic ?dicc ;

:?word | adr -- adr/0
	word2code
	;

:.def	| :
	;
:.var	| #
	;

:.sys | nro --
	"sis %d" c.print ;
:.base	| nro --
	"base %d" c.print ;
:.str | adr --
	"str " c.print ;
:.lit | adr -- adr
	"lit " c.print ;
:.word | nro --
	"word %h" c.print ;
:.adr | nro --
	"'word %h" c.print ;

:wrd2token | str -- str'
	( dup c@ $ff and 33 <?
		0? ( nip ; ) drop 1 + )	| trim0
|	$5e =? ( drop >>cr ; )	| $5e ^  Include
|	$7c =? ( drop .com ; )	| $7c |	 Comentario
	$3A =? ( drop .def ; )	| $3a :  Definicion
	$23 =? ( drop .var ; )	| $23 #  Variable
	$22 =? ( drop .str ; )	| $22 "	 Cadena
	$27 =? ( drop 			| $27 ' Direccion
		1 + ?word 1? ( .adr ; ) drop
		"Addr not exist" 'error !
		dup 1 - 'lerror !
		drop 0 ; )
	drop
	dup isNro 1? ( drop .lit ; ) drop	| number
	dup ?sys 1? ( .sys ; ) drop
	dup ?base 1? ( .base ; ) drop	| base
	?word 1? ( .word ; ) drop		| word
 	"Word not found" 'error !
	dup 'lerror !
	drop 0 ;

:parse | str --
	0 'error !
	( wrd2token 1? >>sp ) drop
	error 1? ( "%s %d" c.print c.cr ; ) drop
	;

:parse&run
	x y c.at 'spad c.semit c.cr

	'spad parse

	0 'spad !
	newpad
	;


:main
	drawcon
	keyinput

	key
	>esc< =? ( exit )
	<ret> =? ( parse&run )
|	<f1> =? ( wordlist )
	drop
	;

:mm
	mark
	here
	dup 'sysdic !
	'wsys makedicc
	dup 'basdic !
	'wbase makedicc
	dup 'spad !
	1024 +
	dup 'memory !
	dup 'memory> !
	;

:
	mm
	c.cls
	63 c.ink
	"r3 console" c.print c.cr
	0 'spad ! newpad

	'main onshow ;