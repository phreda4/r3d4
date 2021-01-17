| r3 interactive
| experiment for make a r3computer like jupiter ace
| PHREDA 2021

^r3/lib/parse.r3
^r3/lib/gui.r3

^./r3ivm.r3
^./editline.r3

|--- Memory map
#spad	| scratchpad
#code
#code>
#icode>

#lastdicc>

#state	| imm/compiling
#tlevel	| tokenizer level
#defnow 0

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
|----------------------

:char6bit | char -- 6bitchar
	$1f - dup $40 and 1 >> or $3f and ;

:name2code | "" -- 32
|	0 over 10 + c! | cut 10=64bits 5=32bits
	0 ( swap c@+ 1? char6bit rot 6 << or ) 2drop ;

:word2code | "" -- code
	5 0 rot				| cnt acc adr     | 5 32bits 10 64bits
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


:word2adr | adr -- realadr
	;
|-------------------------------
| tables

#wsysdic $23EA6 $38C33974 $349A6 $9A5AB5 $976BB1 $339B49B5 $339A3C30 $27C33A26 0

#wbasdic $1C $9 $A $3C $3E $9B9 $460 $4A0 $320 $3A0 $760 $7E0 $7A0 $1F7A0 $1D7A0
$1D7E0 $8AF960 $2F8AF960 $23D60 $25DB1 $973C31 $C379B3 $31AA4B13 $31AA4B14
$31AA4B15 $D388B1 $2FAB1 $33C35 $4E5DB1 $13973C31 $14973C31 $15973C31
$13C379B3 $13D388B1 $21 $921 $84C $2484C $2 $902 $8C $2408C $302 $24302
$7E2 $89F $8A1 $882 $88C $2284C $2208C $7E3 $8DF $8E1 $8C2 $8CC $2384C
$2308C $2FC35 $2F9A8 $228F4 $D32CF5 $24B7B $22BE5 $C33 $39C33 $C $E $B
$10 $2EC25 $75D $7DF $1F7DF $42EC25 $2D0 $B7DF $1D750 $BB0DE6 $2EC3799F
$9EAB6D $92EC37 $24BB0DDF $249EAB6D 0

#wintdic $B6AD52 $B6AD53 $B6AD74 $24C2E $AEEC73 $2BBB1 $922B6D $22973 $378B3 0

|--------- TOKEN PRINT
:tokenl | nro dic -- str
	swap 2 << + @ code2name c.semit ;

:b16 | adr t
	swap @+ 48 << 48 >> swap 2 -	| t v adr
	rot 9 - 'wbasdic tokenl swap " %d" c.print ;

:b32
	swap @+				| t adr v
	rot 9 - 'wbasdic tokenl " %d" c.print ;

:b | adr t --
	9 - 'wbasdic tokenl ;

:i8 | adr t --
	swap c@+ | t adr v
	swap over + swap | t adr' v
	rot 'wintdic tokenl " %d" c.print ;

:i16 | adr t --
	swap @+ 48 << 48 >> swap 2 -	| t v adr
	rot 'wintdic tokenl swap " %d" c.print ;

:i32 | adr t --
	swap @+				| t adr v
	rot 'wintdic tokenl " %d" c.print ;

:iCALL
	drop @+ 8 - @ code2name c.semit ;

:iADR
	drop @+ 8 - @ code2name "'" c.semit c.semit ;

#tokenp
i16 i32 i8 i8 i16 i32 iCALL iADR iCALL
b b b16 b16 b16		|";" "(" ")" "[" "]"
b b16 b16 b16 b16	|"EX" "0?" "1?" "+?" "-?"
b16 b16 b16 b16 b16 b16 b16 b16 b16	|"<?" ">?" "=?" ">=?" "<=?" "<>?" "AND?" "NAND?" "BT?"
b b b b b b b b	|"DUP" "DROP" "OVER" "PICK2" "PICK3" "PICK4" "SWAP" "NIP"
b b b b b b b   |"ROT" "2DUP" "2DROP" "3DROP" "4DROP" "2OVER" "2SWAP"
b b b b b b b b b b	|"@" "C@" "@+" "C@+" "!" "C!" "!+" "C!+" "+!" "C+!"
b b b b b b b	|">A" "A>" "A@" "A!" "A+" "A@+" "A!+"
b b b b b b b	|">B" "B>" "B@" "B!" "B+" "B@+" "B!+"
b b b b b		|"NOT" "NEG" "ABS" "SQRT" "CLZ"
b b b b b b b b |"AND" "OR" "XOR" "+" "-" "*" "/" "MOD"
b b b b b b b   |"<<" ">>" ">>>" "/MOD" "*/" "*>>" "<</"
b b b b b b     |"MOVE" "MOVE>" "FILL" "CMOVE" "CMOVE>" "CFILL"

:minilit | t --
	57 << 57 >> "%d" c.print ;

:tokenprint | adr -- adr'
	c@+
	$80 and? ( minilit ; )
	dup 2 << 'tokenp + @ ex ;

#tsum (
2 4 -1 4 2 4 4 4	|"LIT1" "LIT2" "LITs" "JMP" "JMPR" "CALL" iADR iVAR
0 0 2 2 2	|";" "(" ")" "[" "]"
0 2 2 2 2	|"EX" "0?" "1?" "+?" "-?"
2 2 2 2 2 2 2 2 2	|"<?" ">?" "=?" ">=?" "<=?" "<>?" "AND?" "NAND?" "0T?"
0 0 0 0 0 0 0 0	|"DUP" "DROP" "OVER" "PICK2" "PICK3" "PICK4" "SWAP" "NIP"
0 0 0 0 0 0 0   |"ROT" "2DUP" "2DROP" "3DROP" "4DROP" "2OVER" "2SWAP"
0 0 0 0 0 0 0 0 0 0	|"@" "C@" "@+" "C@+" "!" "C!" "!+" "C!+" "+!" "C+!"
0 0 0 0 0 0 0	|">A" "A>" "A@" "A!" "A+" "A@+" "A!+"
0 0 0 0 0 0 0	|">0" "0>" "0@" "0!" "0+" "0@+" "0!+"
0 0 0 0 0		|"NOT" "NEG" "A0S" "SQRT" "CLZ"
0 0 0 0 0 0 0 0 |"AND" "OR" "XOR" "+" "-" "*" "/" "MOD"
0 0 0 0 0 0 0   |"<<" ">>" ">>>" "/MOD" "*/" "*>>" "<</"
0 0 0 0 0 0     |"MOVE" "MOVE>" "FILL" "CMOVE" "CMOVE>" "CFILL"
)

:tokenext | adr -- adr'
	c@+ $80 and? ( drop ; )
	'tsum + c@ -? ( drop c@+ ) + ;

|-------------------------------
:xbye	exit ;
:xwords ;
:xsee   ;
:xedit	;
:xdump	;
:xreset	;
:xreboot	;
:xforget	;

#xsys 'xbye 'xwords 'xsee 'xedit 'xdump 'xreset 'xreboot 'xforget

:.sys | nro --
	"sis %d" c.print ;

|-------------------------------
#error
#lerror

:?dicc | adr dicc -- nro+1/0
	swap word2code over
	( @+ 1?
		pick2 =? ( drop pick2 - 2 >> nip nip ; )
		drop ) 4drop 0 ;

:?base	'wbasdic ?dicc ;
:?sys	'wsysdic ?dicc ;

:?word | adr -- adr/0
	word2code lastdicc>	| code dicc
	( dup @ $3fffffff and
		pick2 =? ( drop nip ; )
		drop code >?
		dup 4 + @ 16 >>> 8 + - ) 2drop 0 ;

|--------------------------
#blk * 128
#blk> 'blk
:pushbl blk> !+ 'blk> ! ;
:popbl -4 'blk> +! blk> @ ;

:,i		icode> c!+ 'icode> ! ;
:,iw	icode> !+ 2 - 'icode> ! ;
:,id	icode> !+ 'icode> ! ;

:16! 	| nro adr --
	over 8 >> rot rot c!+ c! ;

:endef
	'blk 'blk>  !
	1 'tlevel !
	state 0? ( drop ; )
|	1 =? (
	drop
	;

:.def | adr -- adr' | :
	endef
	icode> lastdicc> - 8 - 16 <<
	icode> 'lastdicc> !
	over 1 + word2code ,id
	,id
	1 'state !
	>>sp ;

:.var | adr -- adr' | #
	endef
	icode> lastdicc> - 8 - 16 <<
	icode> 'lastdicc> !
	dup 1 + word2code ,id
	,id
	2 'state !
	>>sp ;

:.lit | adr -- adr
	str>nro
	dup 57 << 57 >> =? ( $7f and $80 or ,i ; )  | 7 bits
	dup 48 << 48 >> =? ( 0 ,i ,iw ; )			| 16 bits
	1 ,i ,id ;		| 32 bits

:," | adr -- adr'
	( c@+ 1? 34 =? ( drop
			c@+ 34 <>? ( drop 1 - ; ) ) ,i ) drop 1 - ;

:.str | adr --
	2 ,i
	icode> pushbl
	0 ,i ," 0 ,i
	popbl icode> over - swap c! ;

:.word | adr --
	| data
	dup @ $80000000 and? ( drop 8 ,i 8 + ,id >>sp ; ) drop
	| code
	6 ,i 8 + ,id >>sp ;

:.adr | nro --
	7 ,i 8 + ,id >>sp ;

|---------------------------------
:base;
	9 + ,i
	-1 'tlevel +!
	tlevel 1? ( drop ; ) drop
	| end word, +! is really or
	lastdicc> icode> over - 8 - swap 4 + +!
	;

#iswhile

:base(
	drop
	1 'tlevel +!
	icode> pushbl
	10 ,i ;

:tokenext | adr -- adr'
	c@+ $80 and? ( drop ; )
	'tsum + c@ -? ( drop c@+ ) + ;

:search?? | adr -- adr'
	c@+
	tokenext

	dup $ff and
	$16 <? ( 2drop ; )
	$22 >? ( 2drop ; )
	swap 8 >> 1? ( 2drop ; ) drop
	pick4 8 << or over 4 - ! | ?? set block
	1 'iswhile !
	;

:base) | tok -- tok
	drop
	-1 'tlevel +!
	0 'iswhile !
	popbl
	( icode> <?
		search??
		) drop
	iswhile 0? ( 2 ,i 0 ,iw ; ) drop nip
	11 ,i ,iw ;


:base[
	drop
	1 'tlevel +!
	icode> pushbl
	12 ,i 0 ,iw ;

:base]
	drop
	-1 'tlevel +!
	popbl
	icode> over - 3 +
	13 ,i dup ,iw
	swap 1 + 16! ;

:.base	| nro --
	1 -
	0? ( base; >>sp ; )
	1 =? ( base( >>sp ; )
	2 =? ( base) >>sp ; )
	3 =? ( base[ >>sp ; )
	4 =? ( base] >>sp ; )
	9 + ,i >>sp ;

|	$5e =? ( drop >>cr ; )	| $5e ^  Include
|	$7c =? ( drop .com ; )	| $7c |	 Comentario

:wrd2token | str -- str'
	( dup c@ $ff and 33 <?
		0? ( nip ; ) drop 1 + )	| trim0
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
	dup ?word 1? ( .word ; ) drop		| word
 	"Word not found" 'error !
	'lerror !
	0 ;

:parse | str --
	0 'error !
	( wrd2token 1? ) drop
	error 1? ( c.semit c.cr lerror name2code "%h " c.print c.cr ; ) drop
	;

|-------------------------------------------------
:dumptokens | last now --
	( over <? tokenprint 32 c.emit ) 2drop ;

:dumpbytes | last now --
	( over <? c@+ $ff and "%h " c.print ) 2drop ;

:dumpmem
	c.cr
	icode> code dumpbytes
	c.cr
	;

|------------------------
:parse&run
	inputprint c.cr
	spad parse
	c.cr

|	icode> code> dumpbytes c.cr
|	icode> code> dumptokens c.cr

	0 spad !
	spad newpad
	;

:defvar
	$3fffffff and
	code2name "#%s " c.print
	@+ $ffff and	| dir cant
	over +
	swap ( over <?
		c@+ "$%h " c.print
		 ) 2drop ;

:defwrd | adr --
	@+
	$80000000 and? ( defvar ; )
	code2name ":%s " c.print
	@+ $ffff and	| dir cant
	over +
	swap ( over <?
		tokenprint 32 c.emit
		) 2drop ;


:wordlist
	lastdicc>
	( dup defwrd c.cr code >?
		dup 4 + @ 16 >>> 8 + - ) drop
	c.cr
	spad newpad
	;

:main
	drawcon
	keyinput

	key
	>esc< =? ( exit )
	<ret> =? ( parse&run )
	<f1> =? ( wordlist )
	<f2> =? ( dumpmem )
	drop
	;

|-------------------------------
:addtest
	$9368a5 ,id
	$3 ,id
	$13 ,i
	$44 ,i
	0 ,i
	icode> 'lastdicc> !
	$9368a6 ,id
	$00030004 ,id | -3
	$13 ,i
	$44 ,i
	$87 ,i
	0 ,i

	icode> 'code> !
	;
|-------------------------------

:mm
	mark
	here
	dup 'spad !
	1024 +
	dup 'code !
	dup 'code> ! dup 'icode> !
	'lastdicc> !
	0 'state !

|	addtest
	;

:
	mm
	c.cls
	63 c.ink
	"r3 console" c.print c.cr
	0 spad ! spad newpad

	'main onshow ;