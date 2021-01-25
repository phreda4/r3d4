| r3 arena
| CPU2
| PHREDA 2020
|---------------------
| multi machine simulator
|
| Memory Map for every CPU
|--------------------
| OP	vvvvvv  viiiiiii 00
| LIT	vvvvvv  vvvvvvvv 01
| JMP	xxxx aa aaaaaaaa 10
| CALL	xxxx aa aaaaaaaa 11

| 10 bit adress	- 1kb
| 14 bit literal load -
| 7 bit mini literal load
| 128 op

| xxxx conditional
| ALL 0? 1? +? -? =? <>? >? >=? <? <=? and? nand? aa bb cc 

| 0 - IP
| 1 - rs/ds           	+4
| 2 - A					+8
| 3 - B             	+12
| 0..15 | DATA STACK 	+16
| 0..15 | RETURN STACK	+80
| 0..512 | CODE-DATA	+144
| 0..512 | DATA
|--------------------
| MACHINE R3

#r3cond
"ALL" "0?" "1?" "+?" "-?" "=?" "<>?" ">?" ">=?" "<?" "<=?" "and?" "nand?" "." "." "." "."
#r3mac
"" "LIT" "JMP" "CALL"
#r3op
"RET" "EX" "DUP" "DROP" "OVER" "PICK2" "PICK3" "PICK4"
"SWAP" "NIP" "ROT" "-ROT" "2DUP" "2DROP" "3DROP" "4DROP"
"2OVER" "2SWAP"
"@" "C@" "@+" "C@+" "!" "C!" "!+" "C!+" "+!" "C+!"
">A" "A>" "A@" "A!" "A+" "A@+" "A!+"
">B" "B>" "B@" "B!" "B+" "B@+" "B!+"
"NOT" "NEG" "ABS" "SQRT" "CLZ"
"AND" "OR" "XOR" "+" "-" "*" "/" "MOD"
"<<" ">>" ">>>" "/MOD" "*/" "*>>" "<</"

| stack representation
| $10..$14..$18..$1C..$20...$40 ... $3c and

:ADS | 'mac -- adr ; adress data stack
	dup 4 + @ $3c and + ;
:+DS
	dup 4 + dup @ $4 + $ff00ff and swap ! ;
:-DS
	dup 4 + dup @ dup $ff and $4 - $10 max  $ff00ff and swap ! ;



#DATS #RETS

:GETSKS | mac
	dup 4 + @+ dup $f and 'DATS ! 16 >> $f and 'RETS ! ;
:SETSKS | mac
	RETS 16 << DATS or over 4 + ! ;


:DPUSH | 'mac 'ip V --
	DATS 1 + $f and dup 'DATS !
	2 << $10 + pick2 + ! ;

:DPOP | 'mac 'ip -- 'mac 'ip V
	DATS dup 2 << $10 + pick3 + @
	swap 1 - $f and 'DATS ! ;


:DNOSTOS | -- N T
	;
:DTOS!	| V --
	;

:DTOS
	DATS 2 << $10 + pick3 + @
	;
:DNIP
:RPUSH
:RPOP
	;

:iRET
:iEX
:iDUP
:iDROP
:iOVER
:iPICK2
:iPICK3
:iPICK4
:iSWAP
:iNIP
:iROT
:i-ROT
:i2DUP
:i2DROP
:i3DROP
:i4DROP
:i2OVER
:i2SWAP
:i@
:iC@
:i@+
:iC@+
:i!
:iC!
:i!+
:iC!+
:i+!
:iC+!
:i>A
:iA>
:iA@
:iA!
:iA+
:iA@+
:iA!+
:i>B
:iB>
:iB@
:iB!
:iB+
:iB@+
:iB!+
:iNOT	DTOS NOT DTOS! ;
:iNEG	DTOS NEG DTOS! ;
:iABS	DTOS ABS DTOS! ;
:iSQRT	DTOS SQRT DTOS! ;
:iCLZ	DTOS CLZ DTOS! ;
:iAND	DNOSTOS AND DTOS! ;
:iOR    DNOSTOS OR DTOS! ;
:iXOR	DNOSTOS XOR DTOS! ;
:i+		DNOSTOS + DTOS! ;
:i-		DNOSTOS - DTOS! ;
:i*		DNOSTOS * DTOS! ;
:i/		DNOSTOS / DTOS! ;
:iMOD	DNOSTOS MOD DTOS! ;
:i<<	DNOSTOS << DTOS! ;
:i>>	DNOSTOS >> DTOS! ;
:i>>>	DNOSTOS >> DTOS! ;
:i/MOD	DNOSTOS /MOD ;
:i*/
:i*>>
:i<</
	;

#op1 iRET iEX iDUP iDROP iOVER iPICK2 iPICK3 iPICK4
iSWAP iNIP iROT i-ROT i2DUP i2DROP i3DROP i4DROP
i2OVER i2SWAP
i@ iC@ i@+ iC@+ i! iC! i!+ iC!+ i+! iC+!
i>A iA> iA@ iA! iA+ iA@+ iA!+
i>B iB> iB@ iB! iB+ iB@+ iB!+
iNOT iNEG iABS iSQRT iCLZ
iAND iOR iXOR i+ i- i* i/ iMOD i<< i>> i>>>
i/MOD i*/ i*>> i<</

| 'mac 'ip V
:iop | OP	vvvvvv  viiiiiii 00
	dup $1fc and 'op1 + @ ex ;

:ilit | LIT	vvvvvv  vvvvvvvv 01
	48 << 50 >> DPUSH ;

:call
:c0?
:c1?
:c+?
:c-?
:c=?
:c<>?
:c>?
:c>=?
:c<?
:c<=?
:cand?
:cnand?

#opc 0 c0? c1? c+? c-? c=? c<>? c>? c>=? c<? c<=? cand? cnand? 0 0 0 0

:cond??
	dup 10 >> $c and 0? ( ; )
	'opc + @ ex ;

:ijmp | JMP	xxxx aaaa aaaaaa 10
	cond??
	1? ( drop ; ) drop
	nip $ffc and 1 >>
	$1ff and ;

:ical | CALL	xxxx aaaa aaaaaa 11
	cond??
	1? ( drop ; ) drop
	swap RPUSH $ffc and 1 >>
	$1ff and ;

#op0 'iop 'ilit 'ijmp 'ical

:stepvm | 'mac 'ip -- 'mac ip'
	dup 2 + swap @ dup 2 << $c and 'op0 + @ ex ;


