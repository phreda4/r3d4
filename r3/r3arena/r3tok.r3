| r3 tokenizer
| original behavior
| PHREDA 2021

^r3/lib/parse.r3
^r3/lib/gui.r3
^r3/lib/trace.r3

^./r3vm.r3

##INTWORDS 9

|--- Memory map
##icode>
##lastdicc>

##state	| imm/compiling
#tlevel	| tokenizer level

##error

#msgok "Ok"
#msgnoblk "Block bad close"
#msgwoa "Core word without adress"
#msgnoa "Addr not exist"
#msgnow "Word not found"

|-------------------------------
#wcoredic ";" "(" ")" "[" "]"
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
"MOVE" "MOVE>" "FILL" "CMOVE" "CMOVE>" "CFILL"

#wsysdic
|-------------------------------
#systemwords

:?dicc | adr dicc -- nro+1/0
	swap word2code over
	( @+ 1?
		pick2 =? ( drop pick2 - 2 >> nip nip ; )
		drop ) 4drop 0 ;


:?core	'wbasdic ?dicc ;

:?sys	wsysdic ?dicc ;

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

:,i		icode> !+ 'icode> ! ;

:patchend
	lastdicc>
	dup @ flagdata or over ! 			| save flag (word,var0,var1,var2)
	icode> over - 8 -
	0? ( 4 + 0 ,id )					| #x1 #x2 case
	swap 4 +
|	+! 									| for write one time..
	dup @ $ffff0000 and rot or swap !	| for write many..
	icode> 'code> !
	;

:endef
	tlevel 1? ( 'msgnoblk 'error ! ) drop
	'blk 'blk>  !
	0 'tlevel !
	state 0? ( drop ; )	drop
	patchend ;

:newentry | adr -- adr prev codename
	endef
	icode> lastdicc> - 8 -
	-? ( 0 nip )
	16 <<
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
	dup @ $c0000000 and? ( drop 8 ,i 8 + code - ,id >>sp ; ) drop 	| var
	6 ,i 8 + code - ,id >>sp ; 	| code

:.adr | adr --
	state
	2 =? ( drop 8 + code - ,id ; )	| data
	drop
	7 ,i 8 + code - ,id >>sp ;

|---------------------------------
:core;
	icode> 6 - c@ 6 =? ( 5 icode> 6 - c! ) drop	| change CALL to JMP
	tlevel 1? ( drop ; ) drop
	0 'state !
	patchend ;

#iswhile

:core(
	1 'tlevel +!
	icode> pushbl ;


:cond?? | adr t -- adr t
	15 <? ( ; ) 27 >? ( ; )
	over 16@ 1? ( drop ; ) drop
	icode> pick2 -  pick2 16!
	1 'iswhile ! ;

:core) | tok -- tok
	-1 'tlevel +!
	0 'iswhile !
	popbl dup
	( icode> <? c@+ cond?? tokenext ) drop	| search ??
	iswhile 1? ( drop icode> - 2 - ,iw ; ) drop	| patch WHILE
|	dup 3 - c@	( ) drop                        | patch REPEAT
	0 ,iw										| patch IF
	3 - icode> over - 2 -
	swap 16!
	;

:core[
	0 ,iw
	1 'tlevel +!
	icode> pushbl
	;

:core]
	-1 'tlevel +!
	popbl icode> over -
	dup ,iw
	swap 4 - 16! ;

:.core	| nro --
	state
	2 =? ( drop 'msgwoa 'error ! ; )
	drop
	1 -
	dup INTWORDS + ,i
	0? ( drop core; >>sp ; )
	1 =? ( drop core( >>sp ; )
	2 =? ( drop core) >>sp ; )
	3 =? ( drop core[ >>sp ; )
	4 =? ( drop core] >>sp ; )
	18 >? ( drop >>sp ; )
	INTWORDS + 'tsum + c@ 1? ( 0 ,iw ) drop
	>>sp ;

:,cpycom | adr -- adr'
	1 + ( c@+ 1? $ff and 13 =? ( drop ; ) ,i ) drop 1 - ;

:.com
	3 ,i
	icode> swap
	0 ,i ,cpycom 0 ,i
	swap icode>
	over - 1 - swap c! ;

:.sys
|	state 1? ( 2drop "system words in definition" 'msgnosys 'error ! ; ) drop
	3 ,i -1 ,i 1 - ,i >>sp ;

:wrd2token | str -- str'
	( dup c@ $ff and 33 <?
		0? ( drop 'msgok 'error ! ; ) drop 1 + )	| trim0
|	dup "%w " slog
	$5e =? ( drop >>cr ; )	| $5e ^  Include
	$7c =? ( drop .com ; )	| $7c |	 Comentario
	$3A =? ( drop .def ; )	| $3a :  Definicion
	$23 =? ( drop .var ; )	| $23 #  Variable
	$22 =? ( drop .str ; )	| $22 "	 Cadena
	$27 =? ( drop 			| $27 ' Direccion
		dup 1 + ?word 1? ( .adr ; ) drop
		'msgnoa 'error ! ; )
	drop
	dup isNro 1? ( drop .lit ; ) drop	| number
	dup ?core 1? ( .core ; ) drop		| core
	dup ?word 1? ( .word ; ) drop		| word
	dup ?sys 1? ( .sys ; ) drop
 	'msgnow 'error ! ;

::syswor! 'systemwords ! ;

::r3i2token | str -- 'str 0/error
	0 'error !
	0 ( drop wrd2token
		error 0? )
	'msgok =? ( drop 0 ; )
	;

::r3reset | ram --
	code> dup 'icode> !
	'lastdicc> !
	0 'state ! ;


::vmload | 'vm "" -- 0/error
	over vm@
	r3reset
	mark
	here swap load 0 swap c!
	here r3i2token 
	1? ( swap 'lerror ! empty ; ) 2drop
	vmreset
	lastdicc> code - 8 + 'ip ! | ultima definicion
	empty
	vm!
	;


