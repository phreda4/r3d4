| r3 arena
| CPU1
| PHREDA 2020
|---------------------
| multi machine simulator
|
| Memory Map for every CPU
|  4+16+16+512+512= 1060 ~~ 1kb machine
|--------------------
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

#r3mac
"JMP"   	| 16 bits
"CALL"
"LIT16"
"LIT16u"
"JZ" "JNZ" "JP" "JN" "JE" "JNE" "JA" "JNA"
"JL" "JLE" "JG" "JGE"
"AND8" "OR8" "XOR8" "+8" "-8" "*8" "/8" "MOD8"
"<<8" ">>8" ">>>8" "/MOD8" "*/8" "*>>8" "<</8"
"RET"	| only byte
"EX"
"DUP" "DROP" "OVER" "PICK2" "PICK3" "PICK4" "SWAP" "NIP"
"ROT" "2DUP" "2DROP" "3DROP" "4DROP" "2OVER" "2SWAP"
"@" "C@" "@+" "C@+" "!" "C!" "!+" "C!+" "+!" "C+!"
">A" "A>" "A@" "A!" "A+" "A@+" "A!+"
">B" "B>" "B@" "B!" "B+" "B@+" "B!+"
"NOT" "NEG" "ABS" "SQRT" "CLZ"
"AND" "OR" "XOR" "+" "-" "*" "/" "MOD"
"<<" ">>" ">>>" "/MOD" "*/" "*>>" "<</"

:DTOS | -- TOS
	dup
	;
:DNOSTOS | -- NOS TOS ; dec DSTACK
	dup dup
	;
:DNOSTOS2 | -- NOS TOS ;
	dup dup
	;
:DPNT | -- PK2 NOS TOS ; dec dec DSTACK
	dup dup dup
	;
:DTOS!	| val --
	drop
	;
:DTOSNOS!	| val val --
	drop drop
	;

:DPUSH
:DPOP
:RPUSH
:RPOP

| 'mac ip V
:iJMP   | 16 bits
	8 >> $1ff and
	nip over ! ;

:iCALL

:iLIT16
	8 << 16 >> DPUSH
	2 + ;

:iLIT16u	| 32 bits
	8 << $ffff0000 and
	DPOP $ffff and or
	DPUSH
	3 + ;
:iJZ	| 2 bytes
	TOS 1? ( JMPC ) ;
:iJNZ
:iJP
:iJN
:iJE
:iJNE
:iJA
:iJNA
:iJL
:iJLE
:iJG
:iJGE
:iAND8	7 >> DTOS AND DTOS! ; | 2bytes
:iOR8
:iXOR8
:i+8
:i-8
:i*8
:i/8
:iMOD8
:i<<8
:i>>8
:i>>>8
:i/MOD8
:i*/8
:i*>>8
:i<</8
:iRET	| only byte
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
:iNOT	drop DTOS not DTOS! ;
:iNEG	drop DTOS neg DTOS! ;
:iABS	drop DTOS abs DTOS! ;
:iSQRT	drop DTOS sqrt DTOS! ;
:iCLZ	drop DTOS clz DTOS! ;
:iAND	drop DNOSTOS AND DTOS! ;
:iOR	drop DNOSTOS OR DTOS! ;
:iXOR	drop DNOSTOS XOR DTOS! ;
:i+		drop DNOSTOS + DTOS! ;
:i-		drop DNOSTOS - DTOS! ;
:i*		drop DNOSTOS * DTOS! ;
:i/		drop DNOSTOS / DTOS! ;
:iMOD	drop DNOSTOS MOD DTOS! ;
:i<<	drop DNOSTOS << DTOS! ;
:i>>	drop DNOSTOS >> DTOS! ;
:i>>>	drop DNOSTOS >>> DTOS! ;
:i/MOD	drop DNOSTOS2 /MOD DTOSNOS! ;
:i*/	drop DPNT */ DTOS! ;
:i*>>	drop DPNT */ DTOS! ;
:i<</	drop DPNT */ DTOS! ;

#r3maci
iJMP   | 16 bits
iCALL
iLIT16
iLIT32	| 32 bits
iJZ	iJNZ iJP iJN iJE iJNE iJA iJNA
iJL iJLE iJG iJGE
iAND8 iOR8 iXOR8 i+8 i-8 i*8 i/8 iMOD8
i<<8 i>>8 i>>>8 i/MOD8 i*/8 i*>>8 i<</8
iRET iEX 
iDUP iDROP iOVER iPICK2 iPICK3 iPICK4 iSWAP iNIP
iROT i2DUP i2DROP i3DROP i4DROP i2OVER i2SWAP 
i@ iC@ i@+ iC@+ i! iC! i!+ iC!+ i+! iC+!
i>A iA> iA@ iA! iA+ iA@+ iA!+
i>B iB> iB@ iB! iB+ iB@+ iB!+
iNOT iNEG iABS iSQRT iCLZ
iAND iOR iXOR i+ i- i* i/ iMOD
i<< i>> i>>> i/MOD i*/ i*>> i<</

#nowr3cpu

:r3ip | 'machine -- 'machine ip
	dup @ $1ff and | 512 bytes of code
	over 144 + + ;

:r3DatS | 'machine -- 'machine 'datS
	dup 4 + @ $f and	| deep 16
	over 16 + :

:r3RetS | 'machine -- 'machine 'retS
	dup 4 + @ 16 >> $f and | deep 16
	over 80 + :

:stepvm | 'machine --
	r3ip
	dup @ | get32byte
	dup $7f and 2 <<
	'r3maci + @	| 'mac ip V iex
	ex ;
