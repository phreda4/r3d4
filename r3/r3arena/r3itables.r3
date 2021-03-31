^r3/lib/gui.r3

#sysdic
#basdic
#intdic

#wsys "BYE" "WORDS" "SEE" "LIST" "EDIT" "DUMP" "RESET" "STACK" "DIR"
"shoot" "turn" "adv" "stop" ""

#wbase ";" "(" ")" "[" "]"
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
""

#wint "LIT1" "LIT2" "LITs" "COM" "JMPR" "JMP" "CALL" "ADR" "VAR" ""



:char6bit | char -- 6bitchar
	$1f - dup $40 and 1 >> or $3f and ;

:name2code | "" -- 32
|	0 over 10 + c! | cut 10=64bits 5=32bits
	0 ( swap c@+ 1? char6bit rot 6 << or ) 2drop ;

:word2code | "" -- code
	5 0 rot				| cnt acc adr
	( c@+ $ff and
		32 >?
		char6bit
		rot 6 << or		| cnt adr acc
		rot 1 -			| adr acc cnt
		0? ( drop nip ; )
		swap rot ) 2drop nip ;


:makedicc | adr list -- adr'
	swap >a
	( dup c@ 1? drop
		dup word2code a!+
		>>0 ) 2drop
	0 a!+ a> ;

#buffer * 16

:6bitchar | 6bc -- char
	$3f and $1f + ;

:code2name | nn -- buf
	'buffer 15 + 0 over c! 1 -
	( swap 1? dup 6bitchar pick2 c! 6 >>>
		swap 1 - ) drop 1 + ;

|-------------------------------
:ptable |	sysdic
	( @+ 1?
|		dup "$%h |" ,print code2name ,print ,cr
		"0x%h, " ,print
		) 2drop ;

:savetable
	mark
	"| tables" ,ln
	"#wsysdic" ,ln
	sysdic ptable
	,cr
	"#wbasdic" ,ln
	basdic ptable
	,cr
	"#wintdic" ,ln
	intdic ptable
	,cr
	0 ,c
	"r3/r3arena/tables.r3" savemem
	empty ;

:main
	cls home
	here print
	key
	>esc< =? ( exit )
	<f1> =? ( savetable )
	drop
	;

:
	mark
	here
	dup 'sysdic !
	'wsys makedicc
	dup 'basdic !
	'wbase makedicc
	dup 'intdic !
	'wint makedicc

	'here !
	33 here !

	'main onshow ;