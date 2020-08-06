| VM r3
| PHREDA 2020
|-------------
^./r3base.r3
^./r3stack.r3

|----------------------

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

:.dec
:.hex
:.dec
:.dec
:.str
:.wor
:.var
:.dwor
:.dvar
	;

|-- Internas
:.LIT		.DUP dup @ 'TOS ! 4 + ;
:.ADR		.DUP dup @ @ 'TOS ! 4 + ;

:.;		RTOS @ nip -4 'RTOS +! ;

:.CALL		4 'RTOS +! dup 4 + RTOS ! @ ;
:.JMP		@ ;

:.(
:.)
:.[
:.]
	;
|-- exec
:.EX		TOS .DROP 4 'RTOS +! swap RTOS ! ;

|-- condicionales
:.0?		TOS 1? ( drop @ ; ) drop 4 + ;
:.1?		TOS 0?  ( drop @ ; ) drop 4 + ;
:.+?		TOS -?  ( drop @ ; ) drop 4 + ;
:.-?		TOS $80000000 nand? ( drop @ ; ) drop 4 + ;

:.=?		NOS @ TOS <>? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.<?		NOS @ TOS >=? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.>?		NOS @ TOS <=? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.<=?		NOS @ TOS >? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.>=?		NOS @ TOS <? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.<>?		NOS @ TOS =? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.A?		NOS @ TOS nand? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.N?		NOS @ TOS and? ( drop @ .DROP ; ) drop 4 + .DROP ;

:.B?		NOS 4 - @ NOS @ TOS bt? ( drop @ .2DROP ; ) drop 4 + .2DROP ; |****

|--------------------
:.>R		4 'RTOS +! TOS RTOS ! .DROP ;
:.R>		.DUP RTOS dup @ 'TOS ! 4 - 'RTOS ! ;
:.R@		.DUP RTOS @ 'TOS ! ;

:.AND		vNOS vTOS and .2DROP PUSH.NRO ;
:.OR		vNOS vTOS or .2DROP PUSH.NRO ;
:.XOR		vNOS vTOS xor .2DROP PUSH.NRO ;
:.NOT		vTOS not .DROP PUSH.NRO ;
:.+		vNOS vTOS + .2DROP PUSH.NRO ;
:.-		vNOS vTOS - .2DROP PUSH.NRO ;
:.*		vNOS vTOS * .2DROP PUSH.NRO ;
:./		vNOS vTOS / .2DROP PUSH.NRO ;
:.*/		vPK2 vNOS vTOS */ .3DROP PUSH.NRO ;
:.*>>		vPK2 vNOS vTOS *>> .3DROP PUSH.NRO ;
:.<</		vPK2 vNOS vTOS <</ .3DROP PUSH.NRO ;
:./MOD		vNOS vTOS /mod swap .2DROP PUSH.NRO PUSH.NRO ;
:.MOD		vNOS vTOS mod .2DROP PUSH.NRO ;
:.ABS		vTOS abs .DROP PUSH.NRO ;
:.NEG		vTOS neg .DROP PUSH.NRO ;
:.CLZ		vTOS clz .DROP PUSH.NRO ;
:.SQRT		vTOS sqrt .DROP PUSH.NRO ;
:.<<		vNOS vTOS << .2DROP PUSH.NRO ;
:.>>		vNOS vTOS >> .2DROP PUSH.NRO ;
:.>>>		vNOS vTOS >>> .2DROP PUSH.NRO ;

:.>A		TOS 'REGA ! .DROP ;
:.A>		.DUP REGA 'TOS ! ;
:.A@		.DUP REGA @ 'TOS ! ;
:.A!		TOS REGA ! .DROP ;
:.A+       TOS 'REGA +! .DROP ;
:.A@+		.DUP REGA dup 4 + 'REGA ! @ 'TOS ! ;
:.A!+		TOS REGA dup 4 + 'REGA ! ! .DROP ;

:.>B		TOS 'REGB ! .DROP ;
:.B>		.DUP REGB 'TOS ! ;
:.B@		.DUP REGB @ 'TOS ! ;
:.B!		TOS REGB ! .DROP ;
:.B+       TOS 'REGB +! .DROP ;
:.B@+		.DUP REGB dup 4 + 'REGB ! @ 'TOS ! ;
:.B!+		TOS REGB dup 4 + 'REGB ! ! .DROP ;

:.@			TOS @ 'TOS ! ;
:.C@		TOS c@ 'TOS ! ;
:.Q@		TOS q@ 'TOS ! ;
:.!			NOS @ TOS ! .NIP .DROP ;
:.C!		NOS @ TOS c! .NIP .DROP ;
:.Q!		NOS @ TOS q! .NIP .DROP ;
:.+!		NOS @ TOS +! .NIP .DROP ;
:.C+!		NOS @ TOS c+! .NIP .DROP ;
:.Q+!		NOS @ TOS q+! .NIP .DROP ;
:.@+		.DUP 4 NOS +! TOS @ 'TOS ! ;
:.!+		NOS @ TOS ! .NIP 4 'TOS +! ;
:.C@+		.DUP 1 NOS +! TOS c@ 'TOS ! ;
:.C!+		NOS @ TOS c! .NIP 1 'TOS +! ;
:.Q@+		.DUP 2 NOS +! TOS q@ 'TOS ! ;
:.Q!+		NOS @ TOS q! .NIP 2 'TOS +! ;

:.MOVE
:.MOVE>
:.FILL
	;
:.CMOVE
	;
:.CMOVE>
	;
:.CFILL
	;
:.QMOVE
	;
:.QMOVE>
	;
:.QFILL
	;

:.UPDATE
:.REDRAW
:.MEM
:.SW
:.SH
:.FRAMEV
:.XYPEN
:.BPEN
:.KEY
:.CHAR

:.MSEC
:.TIME
:.DATE

:.LOAD
:.SAVE
:.APPEND

:.FFIRST
:.FNEXT ;

:.SYS ;
:.SLOAD ;
:.SFREE ;
:.SPLAY ;
:.MLOAD ;
:.MFREE ;
:.MPLAY ;
:.INK
:.'INK
:.ALPHA
:.OPX
:.OPY
:.OP
:.LINE
:.CURVE
:.CURVE3
:.PLINE
:.PCURVE
:.PCURVE3
:.POLI	;


#vmc
0 0 0 0 0 0 0 | i0 i: i:: i# i: i| i^		| 0 1 2 3 4 5 6
.dec .hex .dec .dec .str .wor .var .dwor .dvar
.; .( .) .[ .] .EX .0? .1? .+? .-? .<? .>? .=? .>=? .<=? .<>?
.A? .N? .B? .DUP .DROP .OVER .PICK2 .PICK3 .PICK4 .SWAP .NIP .ROT .2DUP .2DROP .3DROP .4DROP
.2OVER .2SWAP .>R .R> .R@ .AND .OR .XOR .+ .- .* ./ .<< .>> .>>> .MOD
./MOD .*/ .*>> .<</ .NOT .NEG .ABS .SQRT .CLZ .@ .C@ .Q@ .@+ .C@+ .Q@+ .!
.C! .Q! .!+ .C!+ .Q!+ .+! .C+! .Q+! .>A .A> .A@ .A! .A+ .A@+ .A!+ .>B
.B> .B@ .B! .B+ .B@+ .B!+ .MOVE .MOVE> .FILL .CMOVE .CMOVE> .CFILL .QMOVE .QMOVE> .QFILL .UPDATE
.REDRAW .MEM .SW .SH .FRAMEV .XYPEN .BPEN .KEY .CHAR .MSEC .TIME .DATE .LOAD .SAVE .APPEND
.FFIRST .FNEXT
.SYS
.SLOAD .SFREE .SPLAY
.MLOAD .MFREE .MPLAY
.INK .'INK .ALPHA .OPX .OPY
.OP .LINE .CURVE .CURVE3
.PLINE .PCURVE .PCURVE3 .POLI
0

|-------------------------------
| palabras de interaccion
|-------------------------------
##<<ip	| ip
##<<bp	| breakpoint
##code<

::breakpoint | src --
|	memsrc ( @+ pick2 <? )( drop ) drop
|	4 - memsrc - code< +
	'<<bp ! ;

:**emu
	;
:emu**
	;

::resetvm | --
	'PSP 'NOS !
	'RSP 'RTOS !
	0 'TOS !
	<<boot '<<ip !
	;

::stepvm | --
	<<ip 0? ( drop ; )
:stepvmi
	**emu
	(	@+ dup $ff and
		21 >? ( nip )
		2 << 'vmc + @ ex
		code< <=? ) | corte?
	'<<ip !
	emu**
	;

::stepvmn | --
	<<ip 0? ( drop ; )
	dup @ $ff and $c <>? ( drop stepvmi ; ) drop
	**emu
	dup 4 + swap
	( over <>?
		@+ dup $ff and
		21 >? ( nip )
		2 << 'vmc + @ ex
		1? ( '<<ip ! drop emu** ; )
		) nip
	'<<ip !
	emu** ;

::playvm | --
	<<ip 0? ( drop ; )
	**emu
	( <<bp <>?
		@+ dup $ff and
		21 >? ( nip )
		2 << 'vmc + @ ex
		1? )
	'<<ip !
	emu** ;

::tokenexec | token --
	dup $ff and
	21 >? ( nip )
	2 << 'vmc + @ ex ;

