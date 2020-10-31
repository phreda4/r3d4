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
| 0..1024 | CODE-DATA	+144
|--------------------
| MACHINE R3
^r3/lib/trace.r3

:r3ip | 'machine -- ip
	dup @ $3ff and 144 + + ;

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

:DPUSH | mac ip v -- mac ip
	pick2 4 + dup | stack stack
	@ 1 + $f000f and dup rot ! | tos+1
	$f and 2 << 16 + pick3 + ! ;

:DPOP | mac ip v -- mac ip v D
	pick2 4 + dup
	@ $f001f and 1 - $f000f and dup rot !
	$f and 2 << 16 + pick3 + @ ;

:RPUSH
	pick2 4 + dup | stack stack
	@ $10000 + $f000f and dup rot ! | tos+1
	16 >> $f and 2 << 80 + pick3 + ! ;

:RPOP
	pick2 4 + dup
	@ $1f000f and $10000 - $f000f and dup rot !
	16 >> $f and 2 << 80 + pick3 + @ ;

:toMEM $1ff and 144 + ;

:DTOSa | 'mac 'ip -- 'mac 'ip ATOS
	over 4 + @ $f and 2 << 16 + pick2 + ;

:DTOS | 'mac 'ip -- 'mac 'ip TOS
	DTOSa @ ;

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
	pick2 4 + @ $f and 2 << 16 + pick3 + ! ;

:DTOSNOS!	| val val --
	drop drop
	;

| 'mac ip -- 'mac ip
|-------------------

:iRET	drop RPOP ;
:iEX	RPUSH DPOP $1ff and ;
:iJMP   @ toMEM over + ;
:iCALL	dup RPUSH iJMP ;
:iLIT16	dup @ 48 << 48 >> DPUSH 2 + ;
:iLIT32	dup @ 48 << 32 >> DPOP $ffff and or DPUSH 2 + ;
:iJZ	DTOS 1? ( drop iJMP ; ) drop 2 + ;
:iJNZ   DTOS 0? ( drop iJMP ; ) drop 2 + ;
:iJP    DTOS -? ( drop iJMP ; ) drop 2 + ;
:iJN    DTOS +? ( drop iJMP ; ) drop 2 + ;
:iJA    DTOS nand? ( drop iJMP ; ) drop 2 + ;
:iJNA   DTOS and? ( drop iJMP ; ) drop 2 + ;
:iJE    DTOS <>? ( drop iJMP ; ) drop 2 + ;
:iJNE   DTOS =? ( drop iJMP ; ) drop 2 + ;
:iJL    DTOS >=? ( drop iJMP ; ) drop 2 + ;
:iJLE   DTOS >? ( drop iJMP ; ) drop 2 + ;
:iJG    DTOS <=? ( drop iJMP ; ) drop 2 + ;
:iJGE   DTOS <? ( drop iJMP ; ) drop 2 + ;
:iDUP	DTOS DPUSH ;
:iDROP	over 4 + dup @ $f001f and 1 - $f000f and swap ! ;
:iOVER	over 4 + @ 1 - $f and 2 << 16 + pick2 + @ DPUSH ;
:iPICK2	over 4 + @ 2 - $f and 2 << 16 + pick2 + @ DPUSH ;
:iPICK3	over 4 + @ 3 - $f and 2 << 16 + pick2 + @ DPUSH ;
:iPICK4	over 4 + @ 4 - $f and 2 << 16 + pick2 + @ DPUSH ;
:iSWAP
:iNIP	iSWAP iDROP ;
:iROT
:i2DUP  iOVER iOVER ;
:i2DROP	over 4 + dup @ $f001f and 2 - $f000f and swap ! ;
:i3DROP	over 4 + dup @ $f001f and 3 - $f000f and swap ! ;
:i4DROP	over 4 + dup @ $f001f and 4 - $f000f and swap ! ;
:i2OVER iPICK2 iPICK2 ;
:i2SWAP
:i@		DTOSa dup toMEM pick3 + @ swap ! ;
:iC@	DTOSa dup toMEM pick3 + c@ swap ! ;
:i@+	DTOSa dup @ 4 rot +! toMEM pick3 + @ DPUSH ;
:iC@+	DTOSa dup @ 4 rot +! toMEM pick3 + c@ DPUSH ;
:i!		DPOP DPOP swap toMEM pick3 + ! ; |**
:iC!	DPOP DPOP swap toMEM pick3 + c! ; |**
:i!+
:iC!+
:i+!
:iC+!
:i>A	DPOP pick2 8 + ! ;
:iA>	over 8 + @ DPUSH ;
:iA@	over 8 + @ toMEM pick2 + @ DPUSH ;
:iA!    DPOP pick2 8 + @ toMEM pick3 + ! ;
:iA+	DPOP pick2 8 + +! ;
:iA@+	over 8 + 4 over +! @ toMEM pick2 + @ DPUSH ;
:iA!+	DPOP pick2 8 + 4 over +! @ toMEM pick3 + ! ;
:i>B    DPOP pick2 12 + ! ;
:iB>    over 12 + @ DPUSH ;
:iB@	over 12 + @ toMEM pick2 + @ DPUSH ;
:iB!	DPOP pick2 12 + @ toMEM pick3 + ! ;
:iB+    DPOP pick2 12 + +! ;
:iB@+	over 12 + 4 over +! @ toMEM pick2 + @ DPUSH ;
:iB!+	DPOP pick2 12 + 4 over +! @ toMEM pick3 + ! ;
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
	dup r3ip c@+ $7f and			| 'mac ip e
	2 << 'r3maci + @ ex 			| 'mac ip
	144 - over - $1ff and swap !	|
	;

::vmcompile | "" 'machine --
	;

::vmcodemem | 'machine -- 'adr
	144 + ;

::vmdatamem | 'machine -- 'adr
	144 + 512 + ;

