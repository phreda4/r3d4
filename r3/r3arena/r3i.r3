| r3 interactive
| experiment for make a r3computer like jupiter ace
| PHREDA 2021

^r3/lib/parse.r3
^r3/lib/gui.r3

^./r3ivm.r3
^./editline.r3

#INTWORDS 9

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


|-------------------------------
| tables

#wbasdic $1C $9 $A $3C $3E $9B9 $460 $4A0 $320 $3A0 $760 $7E0 $7A0 $1F7A0 $1D7A0
$1D7E0 $8AF960 $2F8AF960 $23D60 $25DB1 $973C31 $C379B3 $31AA4B13 $31AA4B14
$31AA4B15 $D388B1 $2FAB1 $33C35 $4E5DB1 $13973C31 $14973C31 $15973C31
$13C379B3 $13D388B1 $21 $921 $84C $2484C $2 $902 $8C $2408C $302 $24302
$7E2 $89F $8A1 $882 $88C $2284C $2208C $7E3 $8DF $8E1 $8C2 $8CC $2384C
$2308C $2FC35 $2F9A8 $228F4 $D32CF5 $24B7B $22BE5 $C33 $39C33 $C $E $B
$10 $2EC25 $75D $7DF $1F7DF $42EC25 $2D0 $B7DF $1D750 $BB0DE6 $2EC3799F
$9EAB6D $92EC37 $24BB0DDF $249EAB6D 0

|--------- TOKEN PRINT
:tokenl | nro dic -- str
	swap 2 << + @ code2name c.semit ;

:i16	drop @+ 48 << 48 >> "%d" c.print 2 - ;
:i32	drop @+ "%d" c.print ;
:b		INTWORDS - 'wbasdic tokenl ;
:b16	INTWORDS - 'wbasdic tokenl 2 + ;
:iCOM	drop c@+ swap over + swap "|%d" c.print c.cr ;
:iSTR	drop c@+ over 34 c.emit c.semit 34 c.emit + ;
:iCALL	drop @+ 8 - @ code2name c.semit ;
:iADR	drop @+ 8 - @ code2name "'" c.semit c.semit ;

#tokenp
i16 i32 iSTR iCOM
i16 i32 iCALL iADR iCALL
b b b16 b16 b16		|";" "(" ")" "[" "]"
b b16 b16 b16 b16	|"EX" "0?" "1?" "+?" "-?"
b16 b16 b16 b16		|"<?" ">?" "=?" ">=?"
b16 b16 b16 b16 b16 |"<=?" "<>?" "AND?" "NAND?" "BT?"

:minilit | t --
	57 << 57 >> "%d" c.print ;

:tokenprint | adr -- adr'
	c@+
	$80 and? ( minilit ; )
	27 >? ( b ; )
	dup 2 << 'tokenp + @ ex ;

#tsum (
2 4 -1 -1	|L1 L2 Ls Com
4 2 4 4 4	|JMP JMPR CALL iADR iVAR
0 0 2 2 2 0 2 2 2 2	|; ( ) [ ] EX 0? 1? +? -?
2 2 2 2 2 2 2 2 2	|<? >? =? >=? <=? <>? AND? NAND? 0T?
)

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

#wsysdic $23EA6 $38C33974 $349A6 $9A5AB5 $976BB1 $339B49B5 $339A3C30 $27C33A26 0

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

:16!	over 8 >> rot rot c!+ c! ; | nro adr --
:16@	@ 48 << 48 >> ; | adr -- val

:endef
	tlevel 1? ( "bloque mal cerrado" 'error ! ) drop
	'blk 'blk>  !
	0 'tlevel !
	state 0? ( drop ; )
	drop
	;

:.def | adr -- adr' | :
	endef
	icode> lastdicc> - 8 - 16 <<
	icode> 'lastdicc> !
	over 1 + word2code
	,id
	,id
	1 'state !
	>>sp ;

:.var | adr -- adr' | #
	endef
	icode> lastdicc> - 8 - 16 <<
	icode> 'lastdicc> !
	over 1 + word2code
	$80000000 or | var flag
	,id
	,id
	2 'state !
	>>sp ;

:.lit | adr -- adr
	state
	2 =? ( drop str>nro ,id ; )
	drop
	str>nro
	dup 57 << 57 >> =? ( $7f and $80 or ,i ; )  | 7 bits
	dup 48 << 48 >> =? ( 0 ,i ,iw ; )			| 16 bits
 	1 ,i ,id ;		| 32 bits

:,cpystr | adr -- adr'
	1 + ( c@+ 1? 34 =? ( drop
			c@+ 34 <>? ( drop 1 - ; ) ) ,i ) drop 1 - ;

:.str | adr --
	state
	2 =? ( drop ,cpystr 0 ,i ,id ; )
	drop
	2 ,i
	icode> swap
	0 ,i ,cpystr 0 ,i
	swap icode>
	over - swap c! ;

:.word | adr --
	state
	2 =? ( drop 8 + ,id ; )
	drop
	| data
	dup @ $80000000 and? ( drop 8 ,i 8 + ,id >>sp ; ) drop
	| code
	6 ,i 8 + ,id >>sp ;

:.adr | adr --
	state
	2 =? ( drop 8 + ,id ; )
	drop
	7 ,i 8 + ,id >>sp ;

|---------------------------------
:base;
	tlevel 1? ( drop ; ) drop
	| end word, +! is really or
	lastdicc> icode> over - 8 - swap 4 + +!
	icode> 'code> !
	;

#iswhile

:base(
	1 'tlevel +!
	icode> pushbl ;

:tokenext | adr t -- adr'
	$80 and? ( drop ; )
	27 >? ( drop ; )
	'tsum + c@ -? ( drop c@+ ) + ;

:cond?? | adr t -- adr t
	15 <? ( ; ) 27 >? ( ; )
	over 16@ 1? ( drop ; ) drop
	icode> pick2 - 2 - pick2 16!
	1 'iswhile !
	;

:base) | tok -- tok
	-1 'tlevel +!
	0 'iswhile !
	popbl dup
	( icode> <? c@+ cond?? tokenext ) drop	| search ??
	iswhile 1? ( drop icode> - 4 - ,iw ; ) drop
	0 ,iw
	3 - icode> over - 3 -
	swap 16! 					| patch IF
	;

:base[
	0 ,iw
	1 'tlevel +!
	icode> pushbl
	;

:base]
	-1 'tlevel +!
	popbl icode> over -
	dup ,iw
	swap 4 - 16! ;

:.base	| nro --
	state
	2 =? ( drop "base word not have adress" 'error ! ; )
	drop
	1 -
	dup INTWORDS + ,i
	0? ( drop base; >>sp ; )
	1 =? ( drop base( >>sp ; )
	2 =? ( drop base) >>sp ; )
	3 =? ( drop base[ >>sp ; )
	4 =? ( drop base] >>sp ; )
	18 >? ( drop >>sp ; )
	INTWORDS + 'tsum + c@ 1? ( 0 ,iw ) drop
	>>sp ;

|	$5e =? ( drop >>cr ; )	| $5e ^  Include

:,cpycon | adr -- adr'
	1 + ( c@+ 1? $ff and 13 =? ( drop ; ) ,i ) drop 1 - ;

:.com
	3 ,i
	icode> swap
	0 ,i ,cpycon 0 ,i
	swap icode>
	over - swap c! ;

:wrd2token | str -- str'
	( dup c@ $ff and 33 <?
		0? ( nip ; ) drop 1 + )	| trim0
	$7c =? ( drop .com ; )	| $7c |	 Comentario
	$3A =? ( drop .def ; )	| $3a :  Definicion
	$23 =? ( drop .var ; )	| $23 #  Variable
	$22 =? ( drop .str ; )	| $22 "	 Cadena
	$27 =? ( drop 			| $27 ' Direccion
		dup 1 + ?word 1? ( .adr ; ) drop
		"Addr not exist" 'error !
		1 - 'lerror !
		0 ; )
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
	c.cr "Ok" c.print c.cr
	;

|-------------------------------------------------
:dumptokens | last now --
	( over <? tokenprint 32 c.emit ) 2drop ;

:dumpbytes | last now --
	( over <? c@+ $ff and "%h " c.print ) 2drop ;

:dumpmem
	c.cr icode> code dumpbytes c.cr ;

|------------------------
:defvar
	$3fffffff and
	37 c.ink
	code2name "#%s " c.print
	1 c.ink
	@+ $ffff and	| dir cant
	over +
	swap ( over <?
		c@+ "$%h " c.print
		 ) 2drop ;

:defwrd | adr --
	@+
	$80000000 and? ( defvar ; )
	37 c.ink
	code2name ":%s " c.print
	1 c.ink
	@+ $ffff and	| dir cant
	over +
	swap ( over <?
		tokenprint 32 c.emit
		) 2drop ;


:wordlist
	lastdicc>
	( dup defwrd c.cr code >?
		dup 4 + @ 16 >>> 8 + - ) drop ;

:viewdicc
	63 c.ink
	code "%h " c.print c.cr
	code> "%h " c.print c.cr
	lastdicc> "%h " c.print c.cr
    code
	( lastdicc> <?
		dup "%h " c.print
		dup defwrd
		dup 4 + @ $ffff and +
		) drop ;

|------------------------
:refreshscreen

|	c.cls
|	wordlist

	dumpmem

	c.y ( 26 >? 28 c.cll c.uscroll 1 - ) 'c.y !
	atpad

	0 28 c.at
	16 c.ink
	"D:" c.print
	vmstackprint

	63 c.ink
	inputline
	;

:immediate
	9 ,i

	c.cr icode> code> dumpbytes c.cr

	vmresetr
	code> vmrun drop

	code> 'icode> !
	;

:parse&run
	spad parse
	state 0? ( immediate ) drop
	0 spad ! spad newpad
	refreshscreen
	;

|------------------------
:viewed
	c.cls
	16 c.ink
	viewdicc
	16 c.ink
	dumpmem
	;

:editor
	drawcon
	key
	<ret> =? ( parse&run )
	<f1> =? ( wordlist )
	<f2> =? ( dumpmem )
	drop
	;

:viewco
	c.cls
	37 c.ink "r3" c.print
	8 c.ink "i " c.print
	63 c.ink "Color Computer" c.print
	c.cr
	0 ( 64 <? 1 +
		dup c.ink
		dup "%d " c.print ) drop
    63 c.ink
	c.cr atpad
	0 spad ! spad newpad
	;

:console
	drawcon
	keyinput

	key
	<ret> =? ( parse&run )
	<f1> =? ( wordlist )
	<f2> =? ( dumpmem )
	drop
	;

#modo 'console

:changemode
	modo
	'console =? ( 'editor 'modo ! viewco )
	'editor =? ( 'console 'modo ! viewed )
	drop
	;

:main
	modo ex
	key
	>esc< =? ( exit )
	<tab> =? ( changemode )
	drop
	;

|-------------------------------
:startconsole
	viewco
	'console 'modo !
	;

:startram
	mark
	here
	dup 'spad ! 1024 +
	dup 'code !
	dup 'code> !
	dup 'icode> !
	'lastdicc> !
	0 'state !
	vmreset
	;

:
	startram
	startconsole
	'main onshow ;