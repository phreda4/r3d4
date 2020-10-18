| r3 arena
| CPU2
| PHREDA 2020
|---------------------
| multi machine simulator
|
| Memory Map for every CPU
|--------------------
| 00-OP
	 vvvvvv viiiiiii
| 01-LIT
|	 vvvvvv vvvvvvvv
| 10-JMP
|    xxxx cond
|        aa aaaaaaaa
| 11-CALL
|    xxxx cond
|        aa aaaaaaaa

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
"@" "C@"
"@+" "C@+"
"!" "C!"
"!+" "C!+"
"+!" "C+!"
">A" "A>" "A@" "A!" "A+" "A@+" "A!+"
">B" "B>" "B@" "B!" "B+" "B@+" "B!+"
"NOT" "NEG" "ABS" "SQRT" "CLZ"

"AND" "OR" "XOR" "+" "-" "*" "/" "MOD"
"<<" ">>" ">>>" "/MOD" "*/" "*>>" "<</"


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




