| r3 arena
| PHREDA 2020
|---------------------
| multi machine simulator
|
| Memory Map for every CPU
|  4+16+16+512+512= 1060 ~~ 1kb machine
|--------------------
| 0 - DataS|RetS|IP 4(4)4(4)7(9)
| 1 - A					+4
| 2 - B             	+8
| 3 - ???           	+12
| 0..15 | DATA STACK 	+16
| 0..15 | RETURN STACK	+80
| 0..512 | CODE-DATA	+144
| 0..512 | DATA
|--------------------
| MACHINE R3

#r3mac
"JMP" "CALL" "LIT" "LIT32" "JZ" "JNZ" "JP" "JN"
"JE" "JNE" "JA" "JNA" "JL" "JLE" "JG" "JGE"
"RET" "EX" "DUP" "DROP" "OVER" "PICK2" "PICK3" "PICK4"
"SWAP" "NIP" "ROT" "2DUP" "2DROP" "3DROP" "4DROP" "2OVER"
"2SWAP" "AND" "OR" "XOR" "+" "-" "*" "/"
"MOD" "<<" ">>" ">>>" "/MOD" "*/" "*>>" "<</"
"NOT" "NEG" "ABS" "SQRT" "CLZ" "@" "C@" "@+"
"C@+" "!" "C!" "!+" "C!+" "+!" "C+!" ">A"
"A>" "A@" "A!" "A+" "A@+" "A!+" ">B" "B>"
"B@" "B!" "B+" "B@+" "B!+"

#nowr3cpu

:r3ip | -- ip
	nowr3cpu dup @ $1ff and | 512 bytes of code
	swap 144 + + ;

:r3DatS | -- 'datS
	nowr3cpu dup @ 16 >> $f and	| deep 16
	swap 16 + :

:r3RetS | -- 'retS
	nowr3cpu dup @ 24 >> $f and | deep 16
	swap 80 + :






