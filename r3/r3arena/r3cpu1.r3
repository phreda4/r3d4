| r3 CPU1
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

:r3ip | 'machine -- ip
	@ $1ff and | 512 bytes of code
	over 144 + + ;

:r3DatS | 'machine -- 'datS
	4 + @ $f and	| deep 16
	over 16 + :

:r3RetS | 'machine -- 'retS
	4 + @ 16 >> $f and | deep 16
	over 80 + :

#r3mac
"RET" "EX"
"JMP" "CALL" "LIT16" "LIT32" | 16 bits
"JZ" "JNZ" "JP" "JN" "JE" "JNE" "JA" "JNA"
"JL" "JLE" "JG" "JGE"
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
	dup @ $1ff and
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
:iNOT	DTOS not DTOS! ;
:iNEG	DTOS neg DTOS! ;
:iABS	DTOS abs DTOS! ;
:iSQRT	DTOS sqrt DTOS! ;
:iCLZ	DTOS clz DTOS! ;
:iAND	DNOSTOS AND DTOS! ;
:iOR	DNOSTOS OR DTOS! ;
:iXOR	DNOSTOS XOR DTOS! ;
:i+		DNOSTOS + DTOS! ;
:i-		DNOSTOS - DTOS! ;
:i*		DNOSTOS * DTOS! ;
:i/		DNOSTOS / DTOS! ;
:iMOD	DNOSTOS MOD DTOS! ;
:i<<	DNOSTOS << DTOS! ;
:i>>	DNOSTOS >> DTOS! ;
:i>>>	DNOSTOS >>> DTOS! ;
:i/MOD	DNOSTOS2 /MOD DTOSNOS! ;
:i*/	DPNT */ DTOS! ;
:i*>>	DPNT */ DTOS! ;
:i<</	DPNT */ DTOS! ;

#r3maci
iRET iEX
iJMP iCALL iLIT16 iLIT32	| 16 bits
iJZ	iJNZ iJP iJN iJE iJNE iJA iJNA
iJL iJLE iJG iJGE
iDUP iDROP iOVER iPICK2 iPICK3 iPICK4 iSWAP iNIP
iROT i2DUP i2DROP i3DROP i4DROP i2OVER i2SWAP
i@ iC@ i@+ iC@+ i! iC! i!+ iC!+ i+! iC+!
i>A iA> iA@ iA! iA+ iA@+ iA!+
i>B iB> iB@ iB! iB+ iB@+ iB!+
iNOT iNEG iABS iSQRT iCLZ
iAND iOR iXOR i+ i- i* i/ iMOD
i<< i>> i>>> i/MOD i*/ i*>> i<</




::vmstep | 'machine --
	r3ip c@+ $7f and 2 << 'r3maci + @ | 'mac ip iex
	ex ;

::vmcompile | "" 'machine --
	;

::vmcodemem | 'machine -- 'adr
	144 + ;

::vmdatamem | 'machine -- 'adr
	144 + 512 + ;