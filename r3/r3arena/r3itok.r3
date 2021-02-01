| r3 interactive
| experiment for make a r3computer like jupiter ace
| PHREDA 2021

^r3/lib/parse.r3
^r3/lib/gui.r3
^r3/lib/trace.r3

^./r3ivm.r3

##INTWORDS 9

|--- Memory map
##icode>
##lastdicc>

##state	| imm/compiling
#tlevel	| tokenizer level

##error
##lerror

|--- memory new definition
| tt(2bit)-codename(30bits) (5chars)
| prev(16bits)-next(16bits)
| tokens or data
|
| #var 0 :cua dup * ;
| #var (0)(+4) 0 :cua (-9)(4) [dup] [*] [;]
| 34 cua 'var !
|----------------------

:char6bit | char -- 6bitchar
	$1f - dup $40 and 1 >> or $3f and ;

::name2code | "" -- 32
|	0 over 10 + c! | cut 10=64bits 5=32bits
	0 ( swap c@+ 1? char6bit rot 6 << or ) 2drop ;

::word2code | "" -- code
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

::code2name | nn -- buf
	'buffer 15 + 0 over c! 1 -
	( swap 1? dup 6bitchar pick2 c! 6 >>>
		swap 1 - ) drop 1 + ;

|-------------------------------
##wbasdic $1C $9 $A $3C $3E $9B9 $460 $4A0 $320 $3A0 $760 $7E0 $7A0 $1F7A0 $1D7A0
$1D7E0 $8AF960 $2F8AF960 $23D60 $25DB1 $973C31 $C379B3 $31AA4B13 $31AA4B14
$31AA4B15 $D388B1 $2FAB1 $33C35 $4E5DB1 $13973C31 $14973C31 $15973C31
$13C379B3 $13D388B1 $21 $921 $84C $2484C $2 $902 $8C $2408C $302 $24302
$7E2 $89F $8A1 $882 $88C $2284C $2208C $7E3 $8DF $8E1 $8C2 $8CC $2384C
$2308C $2FC35 $2F9A8 $228F4 $D32CF5 $24B7B $22BE5 $C33 $39C33 $C $E $B
$10 $2EC25 $75D $7DF $1F7DF $42EC25 $2D0 $B7DF $1D750 $BB0DE6 $2EC3799F
$9EAB6D $92EC37 $24BB0DDF $249EAB6D 0

#tsum (
2 4 -1 -1	|L1 L2 Ls Com
4 2 4 4 4	|JMP JMPR CALL iADR iVAR
0 0 2 2 2 0 2 2 2 2	|; ( ) [ ] EX 0? 1? +? -?
2 2 2 2 2 2 2 2 2	|<? >? =? >=? <=? <>? AND? NAND? 0T?
)

::tokenext | adr t -- adr'
	$80 and? ( drop ; )
	27 >? ( drop ; )
	'tsum + c@ -? ( drop c@+ ) + ;

|-------------------------------
#systemwords

:?dicc | adr dicc -- nro+1/0
	swap word2code over
	( @+ 1?
		pick2 =? ( drop pick2 - 2 >> nip nip ; )
		drop ) 4drop 0 ;

:?base	'wbasdic ?dicc ;
:?sys	systemwords ?dicc ;

:?word | adr -- adr/0
	word2code lastdicc>	| code dicc
	( dup @ $3fffffff and
		pick2 =? ( drop nip ; )
		drop code >?
		dup 4 + @ 16 >>> 8 + - ) 2drop 0 ;

|--------------------------
#flagdata
#blk * 128
#blk> 'blk
:pushbl blk> !+ 'blk> ! ;
:popbl -4 'blk> +! blk> @ ;

::,i	icode> c!+ 'icode> ! ;
:,iw	icode> !+ 2 - 'icode> ! ;
:,id	icode> !+ 'icode> ! ;

:16!	over 8 >> rot rot c!+ c! ; | nro adr --
:16@	@ 48 << 48 >> ; | adr -- val

:patchend
	lastdicc>
	dup @ flagdata or over ! 			| save flag (word,var0,var1,var2)
	icode> over
	=? ( 2drop ; ) over
	- 8 - swap 4 +
|	+! 									| for write one time..
	dup @ $ffff0000 and rot or swap !	| for write many..
	icode> 'code> !
	;

:endef
	tlevel 1? ( "bloque mal cerrado" 'error ! ) drop
	'blk 'blk>  !
	0 'tlevel !
	state 0? ( drop ; )	drop
	patchend ;

:newentry | adr -- adr prev codename
	endef
	icode> lastdicc> - 8 - 16 <<
	icode> 'lastdicc> !
	over 1 + word2code ;

:.def | adr -- adr' | :
	newentry
	,id ,id
	1 'state !
	>>sp
	0 'flagdata ! ;

:.var | adr -- adr' | #
	newentry
|	$40000000 or | var flag
	,id ,id
	2 'state !
	>>sp
	$40000000 'flagdata !
	trim "* " =pre 1? ( $c0000000 'flagdata ! ) drop
	;

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
	2 =? ( drop ,cpystr 0 ,i ,id ; )	| data
	drop
	2 ,i
	icode> swap
	0 ,i ,cpystr 0 ,i
	swap icode>
	over - swap c! ;

:.word | adr --
	state
	2 =? ( drop 8 + ,id ; )		| data
	drop
	dup @ $80000000 and? ( drop 8 ,i 8 + ,id >>sp ; ) drop 	| var
	6 ,i 8 + ,id >>sp ; 	| code

:.adr | adr --
	state
	2 =? ( drop 8 + ,id ; )	| data
	drop
	7 ,i 8 + ,id >>sp ;

|---------------------------------
:base;
	tlevel 1? ( drop ; ) drop
	0 'state !
	patchend ;

#iswhile

:base(
	1 'tlevel +!
	icode> pushbl ;


:cond?? | adr t -- adr t
	15 <? ( ; ) 27 >? ( ; )
	over 16@ 1? ( drop ; ) drop
	icode> pick2 - 2 - pick2 16!
	1 'iswhile ! ;

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

:.sys
	state 1? ( 2drop "system words in definition" 'error ! ; ) drop
	3 ,i -1 ,i 1 - ,i >>sp ;

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
	dup ?base 1? ( .base ; ) drop		| base
	dup ?word 1? ( .word ; ) drop		| word
	dup ?sys 1? ( .sys ; ) drop
 	"Word not found" 'error !
	'lerror !
	0 ;

::syswor! 'systemwords ! ;

::r3i2token | str --
	0 'error ! ( wrd2token 1? ) drop ;

::r3reset | ram --
	code> dup 'icode> !
	'lastdicc> !
	0 'state ! ;


::vmload | 'vm "" --
	over vm@
	r3reset
	mark
	here swap load 0 swap c!
	here r3i2token
	vmreset
	empty
	vm!
	;
