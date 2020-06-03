| r3STACK 2018
| PHREDA
|--------------------

^r3/lib/trace.r3
^r3/sys/r3base.r3

| buffer code
| -make code for generate code, last step
| -save after modification (inline, folding, etc..)

##bcode * 8192
##bcode> 'bcode

| calculated number
| for constant folding.

##ctecode * 8192
##ctecode> 'ctecode

::codeini
	'bcode 'bcode> !
	'ctecode 'ctecode> !
	;

::code!+ | tok --
	bcode> !+ 'bcode> ! ;

::2code!+ | adr -- adr
	dup 4 - @ code!+ ;

::code<< | --
	-4 'bcode> +! ;

::ncode | -- n
	bcode> 'bcode - 2 >> ;

::cte!+ | val --
	ctecode>
	dup 'ctecode - 8 << 8 or | token hex are generated
	code!+
	q!+ 'ctecode> ! ;


|--- Pilas
#REGA
#REGB
##TOS 0
#... * 1024 | for debug!!
##PSP * 1024
##NOS 'PSP
#RSP * 1024
##RTOS 'RSP

| format cell
| type-- $0000000f
| $0 nro	33
| $1 cte    XRES
| $2 str    s01
| $3 wrd    w32
| $4 [wrd]	[w33]
| $5 reg	rax rbx
| $6 stk	[rbp] [rbp+8] ...

| $7 [cte]	[FREEMEM]
| $8 anon

|--Pila
::.DUP		4 'NOS +! TOS NOS ! ;

|-------------------------------
| store value in stack
#stkvalue * 1024
#stkvalue# 0

:newval | -- newval
	stkvalue# dup 1 + 'stkvalue# ! ;

::PUSH.NRO	| nro --
	.DUP
	newval dup 8 << 0 or 'TOS !
	3 << 'stkvalue + q! ;

::PUSH.CTE	| ncte --
	.DUP 8 << 1 or 'TOS ! ;
::PUSH.STR	| vstr --
	.DUP 8 << 2 or 'TOS ! ;
::PUSH.WRD	| vwor --
	.DUP 8 << 3 or 'TOS ! ;
::PUSH.VAR	| var --
	.DUP 8 << 4 or 'TOS ! ;
::PUSH.REG	| reg --
	.DUP 8 << 5 or 'TOS ! ;
::PUSH.STK	| stk --
	.DUP 8 << 6 or 'TOS ! ;
::PUSH.CTEM	| ncte --
	.DUP 8 << 7 or 'TOS ! ;
::PUSH.ANO	| anon --
	.DUP 8 << 8 or 'TOS ! ;


::.POP | -- nro
	TOS NOS @ 'TOS ! -4 'NOS +! ;

::vTOS	TOS 8 >> 3 << 'stkvalue + q@ ;
::vNOS	NOS @ 8 >> 3 << 'stkvalue + q@ ;
::vPK2	NOS 4 - @ 8 >> 3 << 'stkvalue + q@ ;

::.OVER     .DUP NOS 4 - @ 'TOS ! ;
::.PICK2    .DUP NOS 8 - @ 'TOS ! ;
::.PICK3    .DUP NOS 12 - @ 'TOS ! ;
::.PICK4    .DUP NOS 16 - @ 'TOS ! ;
::.2DUP     .OVER .OVER ;
::.2OVER    .PICK3 .PICK3 ;

::.DROP		NOS @ 'TOS !	|...
::.NIP      -4 'NOS +! ;
::.2NIP      -8 'NOS +! ;
::.2DROP    NOS 4 - @ 'TOS ! -8 'NOS +! ;
::.3DROP    NOS 8 - @ 'TOS ! -12 'NOS +! ;
::.4DROP    NOS 12 - @ 'TOS ! -16 'NOS +! ;

::.SWAP     NOS @ TOS NOS ! 'TOS ! ;
::.ROT      TOS NOS 4 - @ 'TOS ! NOS @ NOS 4 - !+ ! ;
::.2SWAP    TOS NOS @ NOS 4 - dup 4 - @ NOS ! @ 'TOS !  NOS 8 - !+ ! ;

|-- Internas
::.LIT		.DUP dup @ 'TOS ! 4 + ;
::.ADR		.DUP dup @ @ 'TOS ! 4 + ;

::.;		RTOS @ nip -4 'RTOS +! ;
::.CALL		4 'RTOS +! dup 4 + RTOS ! @ ;
::.JMP		@ ;

|-- exec
::.EX		TOS .DROP 4 'RTOS +! swap RTOS ! ;

::.popIP	| -- val
	RTOS dup @ swap 4 - RSP max 'RTOS ! ;

|-- condicionales
::.0?		TOS 1? ( drop @ ; ) drop 4 + ;
::.1?		TOS 0?  ( drop @ ; ) drop 4 + ;
::.+?		TOS -?  ( drop @ ; ) drop 4 + ;
::.-?		TOS $80000000 na? ( drop @ ; ) drop 4 + ;

::.=?		NOS @ TOS <>? ( drop @ .DROP ; ) drop 4 + .DROP ;
::.<?		NOS @ TOS >=? ( drop @ .DROP ; ) drop 4 + .DROP ;
::.>?		NOS @ TOS <=? ( drop @ .DROP ; ) drop 4 + .DROP ;
::.<=?		NOS @ TOS >? ( drop @ .DROP ; ) drop 4 + .DROP ;
::.>=?		NOS @ TOS <? ( drop @ .DROP ; ) drop 4 + .DROP ;
::.<>?		NOS @ TOS =? ( drop @ .DROP ; ) drop 4 + .DROP ;
::.A?		NOS @ TOS na? ( drop @ .DROP ; ) drop 4 + .DROP ;
::.N?		NOS @ TOS an? ( drop @ .DROP ; ) drop 4 + .DROP ;

::.B?		NOS @ TOS an? ( drop @ .DROP ; ) drop 4 + .DROP ; |****

::.>R		4 'RTOS +! TOS RTOS ! .DROP ;
::.R>		.DUP RTOS dup @ 'TOS ! 4 - 'RTOS ! ;
::.R@		.DUP RTOS @ 'TOS ! ;

::.AND		vNOS vTOS and .2DROP PUSH.NRO ;
::.OR		vNOS vTOS or .2DROP PUSH.NRO ;
::.XOR		vNOS vTOS xor .2DROP PUSH.NRO ;
::.NOT		vTOS not .DROP PUSH.NRO ;
::.+		vNOS vTOS + .2DROP PUSH.NRO ;
::.-		vNOS vTOS - .2DROP PUSH.NRO ;
::.*		vNOS vTOS * .2DROP PUSH.NRO ;
::./		vNOS vTOS / .2DROP PUSH.NRO ;
::.*/		vPK2 vNOS vTOS */ .3DROP PUSH.NRO ;
::.*>>		vPK2 vNOS vTOS *>> .3DROP PUSH.NRO ;
::.<</		vPK2 vNOS vTOS <</ .3DROP PUSH.NRO ;
::./MOD		vNOS vTOS /mod swap .2DROP PUSH.NRO PUSH.NRO ;
::.MOD		vNOS vTOS mod .2DROP PUSH.NRO ;
::.ABS		vTOS abs .DROP PUSH.NRO ;
::.NEG		vTOS neg .DROP PUSH.NRO ;
::.CLZ		vTOS clz .DROP PUSH.NRO ;
::.SQRT		vTOS sqrt .DROP PUSH.NRO ;
::.<<		vNOS vTOS << .2DROP PUSH.NRO ;
::.>>		vNOS vTOS >> .2DROP PUSH.NRO ;
::.>>>		vNOS vTOS >>> .2DROP PUSH.NRO ;

::.>A		TOS 'REGA ! .DROP ;
::.A>		.DUP REGA 'TOS ! ;
::.A@		.DUP REGA @ 'TOS ! ;
::.A!		TOS REGA ! .DROP ;
::.A+       TOS 'REGA +! .DROP ;
::.A@+		.DUP REGA dup 4 + 'REGA ! @ 'TOS ! ;
::.A!+		TOS REGA dup 4 + 'REGA ! ! .DROP ;

::.>B		TOS 'REGB ! .DROP ;
::.B>		.DUP REGB 'TOS ! ;
::.B@		.DUP REGB @ 'TOS ! ;
::.B!		TOS REGB ! .DROP ;
::.B+       TOS 'REGB +! .DROP ;
::.B@+		.DUP REGB dup 4 + 'REGB ! @ 'TOS ! ;
::.B!+		TOS REGB dup 4 + 'REGB ! ! .DROP ;


:i@			TOS @ 'TOS ! ;
:iC@		TOS c@ 'TOS ! ;
:iD@		TOS q@ 'TOS ! ;
:i!			NOS @ TOS ! .NIP .DROP ;
:iC!		NOS @ TOS c! .NIP .DROP ;
:iQ!		NOS @ TOS q! .NIP .DROP ;
:i+!		NOS @ TOS +! .NIP .DROP ;
:iC+!		NOS @ TOS c+! .NIP .DROP ;
:iQ+!		NOS @ TOS q+! .NIP .DROP ;
:i@+		.DUP 4 NOS +! TOS @ 'TOS ! ;
:i!+		NOS @ TOS ! .NIP 4 'TOS +! ;
:iC@+		.DUP 1 NOS +! TOS c@ 'TOS ! ;
:iC!+		NOS @ TOS c! .NIP 1 'TOS +! ;
:iQ@+		.DUP 2 NOS +! TOS q@ 'TOS ! ;
:iQ!+		NOS @ TOS q! .NIP 2 'TOS +! ;

|-------- constantes del sistema
#syscons "XRES" "YRES"
#sysconm "[FREE_MEM]" "[SYSFRAME]" "dword[SYSXM]" "dword[SYSYM]" "dword[SYSBM]" "dword[SYSKEY]" "dword[SYSCHAR]"

#sysregr "rax" "rbx" "rcx" "rdx" "r8"  "r9"  "r10"  "r11"  "r12"  "r13"  "r14"  "r15"  "rdi" "rsi"
#sysregs "eax" "ebx" "ecx" "edx" "r8d" "r9d" "r10d" "r11d" "r12d" "r13d" "r14d" "r15d" "edi" "esi"
#sysregw  "ax"  "bx"  "cx"  "dx" "r8w" "r9w" "r10w" "r11w" "r12w" "r13w" "r14w" "r15w" "di"  "si"
#sysregb  "al"  "bl"  "cl"  "dl" "r8b" "r9b" "r10b" "r11b" "r12b" "r13b" "r14b" "r15b" "dil" "sil"

:list2str | nro 'list -- str
	swap ( 1? 1 - swap >>0 swap ) drop ;

|---- imprime celda
:value 8 >> ;

:mt0 value 3 << 'stkvalue + q@ ,d ;	|--	0 nro 	33

:mt1 value 'syscons list2str ,s ;	|--	1 cte	XRES
:mt2 value "str" ,s ,h ;			|--	2 str   "hola"
:mt3 value "w" ,s ,h ;				|--	3 word  'word
:mt4 value "dword[w" ,s ,h "]" ,s ;	|--	4 var   [var]

:mt5 value 'sysregs list2str ,s ;	|-- 5 reg 	eax
:mt5b value 'sysregb list2str ,s ;	|-- 5 regb 	al
:mt5w value 'sysregw list2str ,s ;	|-- 5 regw 	ax
:mt5r value 'sysregr list2str ,s ;	|-- 5 reg 	rax

:mt6 value 3 << "qword[rbp" ,s
	0? ( drop "]" ,s ; )
	+? ( "+" ,s ) ,d
	"]" ,s ;

:mt7 value 'sysconm list2str ,s ;	|--	7 ctem [FREE_MEM]
:mt8 value "anon" ,s ,h ;			|--	8 anon

#tiposrm mt0 mt1 mt2 mt3 mt4 mt5 mt6 mt7 mt8
#tiposrmb mt0 mt1 mt2 mt3 mt4 mt5b mt6 mt7 mt8
#tiposrmw mt0 mt1 mt2 mt3 mt4 mt5w mt6 mt7 mt8
#tiposrmq mt0 mt1 mt2 mt3 mt4 mt5r mt6 mt7 mt8

::,cell | val --
	dup $f and 2 << 'tiposrmq + @ ex ;

::,cellb | nro --
	dup $f and 2 << 'tiposrmb + @ ex ;

::,cellw | nro --
	dup $f and 2 << 'tiposrmw + @ ex ;

::,celld | nro --
	dup $f and 2 << 'tiposrm + @ ex ;

::,printstk
	"; [ " ,s
	'PSP 8 + ( NOS <=? @+ ,cell ,sp ) drop
	'PSP NOS <? ( TOS ,cell ) drop
	" ] " ,s
	;

::,printstka
	"; [ " ,s
	'PSP 8 + ( NOS <=? @+ 8 >> "%h " ,print ) drop	
	'PSP NOS <? ( TOS 8 >> "%h " ,print ) drop
	"] " ,s
	;

|---------- ASM
| "add %0,#1" --> add rax,rbx ; TOS,NOS
|
:,cstack | adr -- adr
	c@+
	$30 -
	0? ( drop TOS ,cell ; )
	1 - 2 << NOS swap - @ ,cell ;

:,cstackb | adr -- adr
	c@+
	$30 -
	0? ( drop TOS ,cellb ; )
	1 - 2 << NOS swap - @ ,cellb ;

:,cstackd | adr -- adr
	c@+
	$30 -
	0? ( drop TOS ,celld ; )
	1 - 2 << NOS swap - @ ,celld ;

:,car
	$23 =? ( drop ,cstack ; ) | # qword reg
	$24 =? ( drop ,cstackb ; ) | $ byte reg
	$2A =? ( drop ,cstackd ; ) | * dword reg
	$3b =? ( drop ,cr ; ) | ;
	,c ;

::,asm | str --
	( c@+ 1? ,car ) 2drop
	,cr ;

|-------------------------------------------
#stacknow

#stks * 256 		| stack of stack 64 levels
#stks> 'stks

#memstk * $fff	| stack memory
#memstk> 'memstk

::stack.cnt | -- cnt
	NOS 'PSP - 2 >> ;

::stk.push
	memstk> dup stks> !+ 'stks> !
	>a
	stacknow a!+
	NOS 'PSP - a!+
	'PSP 8 + ( NOS <=? @+ a!+ ) drop
	'PSP NOS <? ( TOS a!+ ) drop
	;

::stk.pop
	-4 'stks> +! stks> @
	dup 'memstk> !
	>a
	a@+ 'stacknow !
	a@+ 'PSP + 'NOS !
	'PSP 8 + ( NOS <=? a@+ swap !+ ) drop
	'PSP NOS <? ( a@+ 'TOS ! ) drop
	;

::stk.drop
	stks> 4 - 'stks <? (
		"asm/code.asm" savemem
		dup "stk.drop %h" slog waitkey
		)
	'stks> !
	stks> @
	'memstk> !
	;


|---------- map cells in stack
::stackmap | xx vector -- xx  ; LAST...TOS
	>a 'PSP 8 +
	( NOS <=? dup >r	| xx 'cell
		a> ex
		r> 4 + ) drop
	'PSP NOS >=? ( drop ; ) drop
	'TOS a> ex ;

::stackmap-1 | xx vector -- xx ; LAST..NOS
	>a 'PSP 8 +
	( NOS <=? dup >r	| xx 'cell
		a> ex
		r> 4 + ) drop ;

::stackmap-2 | xx vector -- xx ; LAST..NOS-1
	>a 'PSP 8 +
	( NOS 4 - <=? dup >r	| xx 'cell
		a> ex
		r> 4 + ) drop ;

::stackmap-3 | xx vector -- xx ; LAST..NOS-2
	>a 'PSP 8 +
	( NOS 8 - <=? dup >r	| xx 'cell
		a> ex
		r> 4 + ) drop ;

::stackmap-4 | xx vector -- xx ; LAST..NOS-2
	>a 'PSP 8 +
	( NOS 12 - <=? dup >r	| xx 'cell
		a> ex
		r> 4 + ) drop ;

|-------- registers used
##maskreg 0

:usereg | 'cell --
	@ dup $f and
	5 <>? ( 2drop ; ) drop
	1 swap 8 >> <<
	maskreg or 'maskreg ! ;

::cell.fillreg
	0 'maskreg ! 'usereg stackmap ;

::cell.fillreg2
	0 'maskreg ! 'usereg stackmap-2 ;

::cell.freeACD
	%1101 maskreg or 'maskreg ! ;

::cell.freeD
	%1000 maskreg or 'maskreg ! ;

::setreg | reg --
	1 swap << maskreg or 'maskreg ! ;

::newreg | -- reg
	0 maskreg
	( 1 an? 1 >> swap 1 + swap ) drop
	dup setreg ;

::.dupNEW
	.dup
	cell.fillreg | search unused reg
	newreg 8 << 5 or 'TOS ! ;

|---- set cell
:cell.STK | stk 'cell --
	"mov [rbp" ,s
	over
	1? ( 3 << +? ( "+" ,s ) ,d drop )
	"]," ,s
	dup @ ,cell
	swap 8 << 6 or swap !
	,cr ;

:setSTK | 'cell --
	NOS over swap - 1 - 2 >>
	dup 8 << 6 or
	pick2 @ =? ( 3drop ; ) drop | ya esta en orden
	swap cell.STK ;

:freeforedx | 'cell --
	dup @
	$305 <>? ( 2drop ; ) drop | reg RDX
	setSTK ;

::freeD
	'freeforedx stackmap ;

|------- convert to normal ; xxx --> ... [rbp-8] rax
#stacknormal * 256

:fillnormal | deep --
	-? ( ";fillnormal -" ,ln drop ; ) |trace drop ; )
	'stacknormal >a
	dup a!+	| stacknow
	dup 2 << a!+
	0? ( drop ; )
	1 - ( 1? dup neg 8 << 6 or a!+ 1 - )
	5 or a!+ ;

|-----------------
|; convert to normal
|-----------------

:cellRBP | deltap 'cell -- deltap
	dup @ $f and 6 <>? ( 2drop ; ) drop | STK?
	over 8 << swap +! ;

:shiftRBP | deltap --	; corre rbp a nuevo lugar
	0? ( drop ; )
	dup neg
	"add rbp," ,s 3 << ,d ,cr
    'cellRBP stackmap drop ;

:scanuse | to from -- to from here
	a> ( NOS 4 + <=? @+ | t f 'a c
		pick3 =? ( drop 4 - ; ) drop
		) drop 0 ;

:resolveADR | from -- from'
	dup $f and
	drop
	;

:cellreguse | to from here --
	over swap !
	"xchg " ,s ,cell "," ,s ,cell ,cr
	;

:cellreg | toREG from --
	scanuse 1? ( cellreguse ; ) drop
	swap
	"mov " ,s ,cell "," ,s ,cell ,cr
	;

:cellstkuse | to from here --
	over $f and
	5 =? ( drop cellreguse ; )
	drop
	newreg
	8 << 5 or dup
	rot !	| to from reg
	dup
	"mov " ,s ,cell "," ,s swap ,cell ,cr
	"xchg " ,s ,cell "," ,s ,cell ,cr
	;

:cellstk | toSTK from --
	scanuse 1? ( cellstkuse ; ) drop
	resolveADR
	swap
	"mov " ,s ,cell "," ,s ,cell ,cr
	;

:cellcpy | to from --
	over =? ( 2drop ; )	| ya esta
	over $f and
    5 =? ( drop cellreg ; )
    6 =? ( drop cellstk ; )
    3drop
    "; error stk dest reg/stk!!" ,ln
	;

:stk.cnv | 'adr --
	cell.fillreg
	TOS NOS 4 + ! | TOS in PSP

	@+ 'stacknow !

	@+ 2 >>
|	NOS 'PSP - <>? ( ; )	| diferent size
	'PSP 8 + >a
	( 1? swap
		@+ a@+ cellcpy 		| to from
		swap 1 - ) 2drop

	NOS 4 + @ 'TOS !
	;

::stk.conv | -- ;****** ojo falta stacknow
	";>>>conv>>>" ,ln
	stks> 4 - @ stk.cnv
	;

::IniStack
	'PSP 'NOS !
	'RSP 'RTOS !
	0 'stkvalue# !
	'stks 'stks> !
	'memstk 'memstk> !
	;

::DeepStack | deep --
	IniStack
	( 1? 1 -
		dup PUSH.REG
		) drop ;

|------- spill reg

:spillhere | cellreg 'stk --
	4 - | cell
	NOS over - 2 >> 1 +
	stacknow stack.cnt - +
	neg | <- where in stack

	over
	cell.STK

	2drop

	NOS 4 + @ 'TOS !
	;

::spill | reg --
	8 << 5 or | cellr
	TOS NOS 4 + ! | TOS in PSP
	'PSP 8 +
	( NOS 4 + <=?
		@+ pick2 =? ( drop spillhere ; )
		drop )
	2drop ;

|------- ini stack in ; ... [rbp-8] rax
::stk.start | deep --
	IniStack
	dup 'stacknow !
	0? ( drop ; )
	1 - ( 1? dup neg push.stk 1 - )
	push.reg ;

:stk.setnormal | deep --
	'PSP 'NOS !
	'RSP 'RTOS !
	dup 'stacknow !
	0? ( drop ; )
	1 - ( 1? dup neg push.stk 1 - )
	push.reg ;

::stk.normal | --
	stacknow dup "; stacknow %d " ,print
	stack.cnt dup " stackcnt %d " ,print ,cr
	- shiftRBP 	| corre ebp a nuevo lugar
	stack.cnt fillnormal
	'stacknormal stk.cnv
	stack.cnt stk.setnormal ;

::stk.gennormal | d u --
	dup ( 1? 1 - .drop ) drop
	+
	0? ( drop ; )
	1 - ( 1? dup neg push.stk 1 - )
	push.reg
	stack.cnt stk.setnormal
	;

|------------------------------------
| remove stack constant to register

:allreg | 'cell --
	dup @ $ff and
	5 =? ( 2drop ; ) | es registro
	6 =? ( 2drop ; )
	drop
	newreg 8 << 5 or
	"mov " ,s dup ,cell "," ,s over @ ,cell ,cr
	swap !
	;

::stk.resolve | --
	'allreg stackmap
	;

|..........................
:change | cell@ reg 'cell -- 'cell reg
	pick2 over @ <>? ( 2drop ; ) drop
	over swap ! ;

:changeCellAll | cell@ reg -- cell@ reg
	'change stackmap ;

|--------------------------------
| $0 nro	33
| $1 cte    RESX
| $2 str    s01
| $3 wrd    w32
| $4 [wrd]	[w33]
| $5 re	rax rbx
| $6 stk	[rbp] [rbp+8] ...
| $7 ctem   [FREEMEM]
| $8 anon	anon1
|---------------
|   R register
|	A rax.reg
|	C rcx.reg/Value
|	G Register/Value
|	D rdi
|	S rsi
|   df rdx.free
|
| NOT	R
| +   	RG
| /   	AR           df
| mod	AR -> D      df
| /mod  AR -> AD     df
| */  	AGR          df
| >>  	RC
| *>> 	AGC          df
| /<< 	ARC          df
| !     GG
| @		G
| MOVE	DSC
| normal
| normal-1 (ex)

:cellG? | cell -- 0/1
	$ff and
	4 =? ( drop 0 ; )
	6 =? ( drop 0 ; )
	7 =? ( drop 0 ; )
	drop 1 ;

:cellR? | cell -- 0/1
	$ff and
	5 =? ( drop 1 ; )
	drop 0 ;

:needreg
	newreg 8 << 5 or
	"mov " ,s dup ,cell "," ,s over @ ,cell ,cr
	swap ! ;

:needvar32
	newreg 8 << 5 or
	"movsxd " ,s dup ,cell "," ,s over @ ,cell ,cr
	swap ! ;

:needmem32
	dup 8 >> 1 >? ( drop needvar32 ; ) drop
	needreg ;

:needreg | 'cell
	dup @ $ff and
	4 =? ( drop needvar32 ; )
	7 =? ( drop needmem32 ; )
	drop
	needreg ;

#cc
|...............
:changereg | nreg 'cell -- nreg
	dup @ NOS 4 - @ <>? ( 2drop ; ) drop
	1 'cc !
	over swap ! ;

:freeregnos
	0 'cc !
	.dupnew
 	TOS 'changereg stackmap-3 drop
	cc 1? ( "mov #0,#2" ,asm ) drop
	.drop ;

:changeregt | nreg 'cell -- nreg
	dup @ NOS @ <>? ( 2drop ; ) drop
	1 'cc !
	over swap ! ;

:freeregtos
	0 'cc !
	.dupnew
 	TOS 'changeregt stackmap-2 drop
	cc 1? ( "mov #0,#1" ,asm ) drop
	.drop ;

|...............
:changeA | nreg 'cell -- nreg
	dup @ $005 <>? ( 2drop ; ) drop
	1 'cc !
	over swap ! ;

:needAU
	0 'cc !
	.dupnew
 	TOS 'changeA stackmap-4 drop
	cc 1? ( "mov #0,rax" ,asm ) drop
	.drop ;

:tosG
	.dupnew | x c nr
	"mov #0,#1" ,asm
	TOS 'changereg stackmap drop
    .drop ;

:nosG
	.dupnew | x c nr
	"mov #0,#2" ,asm
	TOS 'changereg stackmap-2 drop
    .drop ;

|...............

::stk.R
	TOS $ff and $5 =? ( drop freeregtos ; ) drop
	.dupnew
	"mov #0,#1" ,asm
	.nip ;

::stk.G
	TOS cellG? 0? ( tosg ) drop ;

::stk.RG
	NOS @ $ff and $5 =? ( drop freeregnos ; ) drop
	.dupnew
	"mov #0,#2" ,asm
	.swap .rot .drop ;

::stk.GG
	TOS cellG? 0? ( tosg ) drop
	NOS @ cellG? 0? ( nosg ) drop ;

::stk.GR
	TOS cellR? 0? ( tosg ) drop
	NOS @ cellG? 0? ( nosg ) drop ;

::stk.RGG
	NOS 4 - @ $ff and $5 =? ( drop ; ) drop
	.dupnew
	"mov #0,#3" ,asm
	.swap .2swap .nip ;

:needA | cell --

	;

:needR
	;

::stk.AR
	cell.fillreg
	cell.freeD
	NOS @ $005 <>? ( needA ) drop
	TOS $ff and $5 <>? ( needR ) drop
	freeD ;

::stk.AGR
	cell.fillreg
	cell.freeD
	NOS 4 - @ $005 <>? ( needA ) drop
|	NOS @ du

	freeD ;

:changeC | nreg 'cell -- nreg
	dup @ $205 <>? ( 2drop ; ) drop
	over swap ! ;

:needCU
	.dupnew
	"mov #0,#1;xchg rcx,#0" ,asm
	TOS 'changeC stackmap-1 drop
	.drop
	$205 'TOS ! ;

:needCU
	.dupnew
	"mov #0,#1;xchg rcx,#0" ,asm
	TOS 'changereg stackmap-1 drop

:needC | cell -- cell
	$ff and 0? ( ; )
	maskreg %100 an? ( drop needCU ; ) drop
	"mov rcx,#0" ,asm
	$205 'TOS ! ;

::stk.RC
	cell.fillreg
	TOS $205 <>? ( needC ) drop
	NOS @ $ff and 5 =? ( drop ; ) drop
	.dupnew | x c nr
	"mov #0,#2" ,asm
	.swap .rot .drop
	;


::stk.AGC
	cell.fillreg
	TOS $205 <>? ( needC ) drop
	NOS 4 - @ $005 =? ( drop needAU ; ) drop
	NOS @ $005 =? ( drop .rot .rot .swap .rot ; ) drop | "xchg rax,#2" ,asm
	maskreg %1 an? ( needAU ) drop
	NOS 4 - dup @
	"mov rax," ,s ,cell ,cr
	$005 swap !	;


::stk.ARC
	cell.fillreg
	TOS $205 <>? ( needC ) drop

	;


::stk.DSC
	;

