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
| ALL 0? 1? +? -? =? <>? >? >=? <? <=? and? nand? . . . .

| 0 - IP
| 1 - DS/DR           	+4
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

:DPUSH
:DPOP
:DTOS
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
:iNOT
:iNEG
:iABS
:iSQRT
:iCLZ
:iAND
:iOR
:iXOR
:i+
:i-
:i*
:i/
:iMOD
:i<<
:i>>
:i>>>
:i/MOD
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

:iop | OP	vvvvvv  viiiiiii 00
	$1fc and 'op1 + @ ex ;
	;
:ilit | LIT	vvvvvv  vvvvvvvv 01
	16 << 18 >> DPUSH ;

:ijmp | JMP	xxxx aaaa aaaaaa 10
	nip $ffc and 1 >> ;
	;
:ical | CALL	xxxx aaaa aaaaaa 11
	swap RPUSH $ffc and 1 >> ;

#op0 'iop 'ilit 'ijmp 'ical

:stepvm | 'ip -- ip'
	dup 2 + swap @ 2 << $c and 'op0 + @ ex ;


