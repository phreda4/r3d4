| VM r3
| PHREDA 2020
|-------------
^./r3base.r3
^./r3stack.r3

^r3/lib/xfb.r3

##REGA 0 0
##REGB 0 0

#sopx #sopy
#sink

:emu**
	>xfb 
	ink 'sink !
	opx 'sopx ! opy 'sopy !
	;

:**emu
	sink 'ink !
	sopx sopy op
	xfb> ;

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
:.EX	TOS .DROP 4 'RTOS +! swap RTOS ! ;

|-- condicionales
:.0?	vTOS 1? ( drop @ ; ) drop 4 + ;
:.1?	vTOS 0? ( drop @ ; ) drop 4 + ;
:.+?	vTOS -? ( drop @ ; ) drop 4 + ;
:.-?	vTOS $80000000 nand? ( drop @ ; ) drop 4 + ;

:.=?	vNOS vTOS <>? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.<?	vNOS vTOS >=? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.>?	vNOS vTOS <=? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.<=?	vNOS vTOS >? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.>=?	vNOS vTOS <? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.<>?	vNOS vTOS =? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.A?	vNOS vTOS nand? ( drop @ .DROP ; ) drop 4 + .DROP ;
:.N?	vNOS vTOS and? ( drop @ .DROP ; ) drop 4 + .DROP ;

:.B?	vPK2 vNOS vTOS bt? ( drop @ .2DROP ; ) drop 4 + .2DROP ;

|--------------------
:.>R	4 'RTOS +! TOS RTOS ! .DROP ;
:.R>	.DUP RTOS dup @ 'TOS ! 4 - 'RTOS ! ;
:.R@	.DUP RTOS @ 'TOS ! ;

:.AND	vNOS vTOS and .2DROP PUSH.NRO ;
:.OR	vNOS vTOS or .2DROP PUSH.NRO ;
:.XOR	vNOS vTOS xor .2DROP PUSH.NRO ;
:.NOT	vTOS not .DROP PUSH.NRO ;
:.+		vNOS vTOS + .2DROP PUSH.NRO ;
:.-		vNOS vTOS - .2DROP PUSH.NRO ;
:.*		vNOS vTOS * .2DROP PUSH.NRO ;
:./		vNOS vTOS / .2DROP PUSH.NRO ;
:.*/	vPK2 vNOS vTOS */ .3DROP PUSH.NRO ;
:.*>>	vPK2 vNOS vTOS *>> .3DROP PUSH.NRO ;
:.<</	vPK2 vNOS vTOS <</ .3DROP PUSH.NRO ;
:./MOD	vNOS vTOS /mod swap .2DROP PUSH.NRO PUSH.NRO ;
:.MOD	vNOS vTOS mod .2DROP PUSH.NRO ;
:.ABS	vTOS abs .DROP PUSH.NRO ;
:.NEG	vTOS neg .DROP PUSH.NRO ;
:.CLZ	vTOS clz .DROP PUSH.NRO ;
:.SQRT	vTOS sqrt .DROP PUSH.NRO ;
:.<<	vNOS vTOS << .2DROP PUSH.NRO ;
:.>>	vNOS vTOS >> .2DROP PUSH.NRO ;
:.>>>	vNOS vTOS >>> .2DROP PUSH.NRO ;

:.>A	vTOS 'REGA q! .DROP ;
:.A>	REGA PUSH.NRO ;
:.A@	REGA @ PUSH.NRO ;
:.A!	vTOS REGA ! .DROP ;
:.A+	vTOS 'REGA q+! .DROP ;
:.A@+	REGA dup 4 + 'REGA q! @ PUSH.NRO ;
:.A!+	vTOS REGA dup 4 + 'REGA ! ! .DROP ;

:.>B	vTOS 'REGB q! .DROP ;
:.B>	REGB PUSH.NRO ;
:.B@	REGB @ PUSH.NRO ;
:.B!	vTOS REGB ! .DROP ;
:.B+	vTOS 'REGB q+! .DROP ;
:.B@+	REGB dup 4 + 'REGB q! PUSH.NRO ;
:.B!+	vTOS REGB dup 4 + 'REGB ! ! .DROP ;

:.@		vTOS @ TOS.NRO! ;
:.C@	TOS c@ TOS.NRO! ;
:.Q@	TOS q@ TOS.NRO! ;
:.!		vNOS vTOS ! .2DROP ;
:.C!	vNOS vTOS c! .2DROP ;
:.Q!	vNOS vTOS q! .2DROP ;
:.+!	vNOS vTOS +! .2DROP ;
:.C+!	vNOS vTOS c+! .2DROP ;
:.Q+!	vNOS vTOS q+! .2DROP ;
:.@+	vTOS @ 4 aTOS q+! PUSH.NRO ;
:.!+	vNOS vTOS ! .NIP 4 aTOS q+! ;
:.C@+	vTOS c@ 1 aTOS q+! PUSH.NRO ;
:.C!+	vNOS vTOS c! .NIP 1 aTOS +! ;
:.Q@+	vTOS q@ 8 aTOS q+! PUSH.NRO ;
:.Q!+	vNOS vTOS q! .NIP 8 aTOS +! ;

:.MOVE	vPK2 vNOS vTOS move .3DROP ;
:.MOVE>	vPK2 vNOS vTOS move> .3DROP ;
:.FILL	vPK2 vNOS vTOS fill .3DROP ;
:.CMOVE	vPK2 vNOS vTOS cmove .3DROP ;
:.CMOVE>	vPK2 vNOS vTOS cmove> .3DROP ;
:.CFILL	vPK2 vNOS vTOS cfill .3DROP ;
:.QMOVE	vPK2 vNOS vTOS qmove .3DROP ;
:.QMOVE>	vPK2 vNOS vTOS qmove> .3DROP ;
:.QFILL	vPK2 vNOS vTOS qfill .3DROP ;

:.UPDATE	update ;
:.REDRAW	redraw ;
:.MEM	here PUSH.NRO ;
::.SW	sw 1 >> PUSH.NRO ;
::.SH	sh 1 >> PUSH.NRO ;
:.FRAMEV	vframe PUSH.NRO ;
:.XYPEN	xypen swap PUSH.NRO PUSH.NRO ;
:.BPEN  bpen PUSH.NRO ;
:.KEY	key PUSH.NRO ;
:.CHAR	char PUSH.NRO ;

:.MSEC msec PUSH.NRO ;
:.TIME time PUSH.NRO ;
:.DATE date PUSH.NRO ;

:.LOAD	vNOS vTOS load .NIP TOS.NRO! ;
:.SAVE	vPK2 vNOS vTOS save .3DROP ;
:.APPEND vPK2 vNOS vTOS append .3DROP ;

:.FFIRST vTOS ffirst TOS.NRO! ;
:.FNEXT fnext PUSH.NRO ;

:.SYS vTOS sys .DROP ; | ???
:.SLOAD vTOS sload TOS.NRO! ;
:.SFREE vTOS sfree .DROP ;
:.SPLAY vTOS splay .DROP ;
:.MLOAD vTOS mload TOS.NRO! ;
:.MFREE vTOS mfree .DROP ;
:.MPLAY vTOS mplay .DROP ;
:.INK	sink PUSH.NRO ;
:.'INK	'sink PUSH.NRO ;
:.ALPHA	vTOS alpha .DROP ;
:.OPX	opx PUSH.NRO ;
:.OPY	opy PUSH.NRO ;
:.OP	vNOS vTOS op .2DROP ;
:.LINE	vNOS vTOS line .2DROP ;
:.CURVE vPK3 vPK2 vNOS vTOS curve .4DROP ;
:.CURVE3	vPK5 vPK4 vPK3 vPK2 vNOS vTOS curve3 .6DROP ;
:.PLINE	vNOS vTOS pline .2DROP ;
:.PCURVE vPK3 vPK2 vNOS vTOS pcurve .4DROP ;
:.PCURVE3	vPK5 vPK4 vPK3 vPK2 vNOS vTOS pcurve3 .6DROP ;
:.POLI	poli ;


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

