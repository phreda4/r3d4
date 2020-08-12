| VM r3
| PHREDA 2020
|-------------
^./r3base.r3
^./r3stack.r3

^r3/lib/xfb.r3

##<<ip	| ip
##<<bp	| breakpoint
##code<

##REGA 0 0
##REGB 0 0

#sopx #sopy #sink

:emu**
	>xfb
	ink 'sink !
	opx 'sopx ! opy 'sopy !
	;

:**emu
	sink 'ink !
	sopx sopy op
	xfb> ;

|----------
::getsrcnro
	dup ?numero 1? ( drop nip nip ; ) drop
	str>fnro nip ;

::getcte | a -- a v
	dup 4 - @ 8 >>> src + getsrcnro ;

:.dec
	getcte push.nro ;
:.hex
	getcte push.nro ;
:.bin
	getcte push.nro ;

:.fix
	dup 4 - @ 8 >> push.nro ;

:.str
	;
:.wor
	;
:.var
	;
:.dwor
	;
:.dvar
	;

:.;		RTOS @ nip -4 'RTOS +! ;

:.EX	TOS .DROP 4 'RTOS +! swap RTOS ! ;

|--- COD
:jmpr | adr' -- adrj
	dup 4 - @ 8 >> + ;

:.( ;
:.)		dup 4 - @ 8 >> 0? ( drop ; ) + ;
:.[		jmpr ;
:.]		dup 4 - @ 8 >> PUSH.NRO ;

:.0?	vTOS 1? ( drop jmpr ; ) drop ;
:.1?	vTOS 0? ( drop jmpr ; ) drop ;
:.+?	vTOS -? ( drop jmpr ; ) drop ;
:.-?	vTOS +? ( drop jmpr ; ) drop ;
:.=?	vNOS vTOS <>? ( drop jmpr .DROP ; ) drop .DROP ;
:.<?	vNOS vTOS >=? ( drop jmpr .DROP ; ) drop .DROP ;
:.>?	vNOS vTOS <=? ( drop jmpr .DROP ; ) drop .DROP ;
:.<=?	vNOS vTOS >? ( drop jmpr .DROP ; ) drop .DROP ;
:.>=?	vNOS vTOS <? ( drop jmpr .DROP ; ) drop .DROP ;
:.<>?	vNOS vTOS =? ( drop jmpr .DROP ; ) drop .DROP ;
:.A?	vNOS vTOS nand? ( drop jmpr .DROP ; ) drop .DROP ;
:.N?	vNOS vTOS and? ( drop jmpr .DROP ; ) drop .DROP ;
:.B?	vPK2 vNOS vTOS bt? ( drop jmpr .2DROP ; ) drop .2DROP ;

|--- R
:.>R	4 'RTOS +! TOS RTOS ! .DROP ;
:.R>	.DUP RTOS dup @ 'TOS ! 4 - 'RTOS ! ;
:.R@	.DUP RTOS @ 'TOS ! ;

|--- REGA
:.>A	vTOS 'REGA q! .DROP ;
:.A>	REGA PUSH.NRO ;
:.A@	REGA @ PUSH.NRO ;
:.A!	vTOS REGA ! .DROP ;
:.A+	vTOS 'REGA q+! .DROP ;
:.A@+	REGA dup 4 + 'REGA q! @ PUSH.NRO ;
:.A!+	vTOS REGA dup 4 + 'REGA ! ! .DROP ;

|--- REGB
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
:.MEM		here PUSH.NRO ;
:.SW		sw PUSH.NRO ;
:.SH		sh PUSH.NRO ;
:.VFRAME	vframe PUSH.NRO ;
:.XYPEN		xypen swap PUSH.NRO PUSH.NRO ;
:.BPEN		bpen PUSH.NRO ;
:.KEY		key PUSH.NRO ;
:.CHAR		char PUSH.NRO ;

:.MSEC		msec PUSH.NRO ;
:.TIME		time PUSH.NRO ;
:.DATE		date PUSH.NRO ;

:.LOAD		vNOS vTOS load .NIP TOS.NRO! ;
:.SAVE		vPK2 vNOS vTOS save .3DROP ;
:.APPEND	vPK2 vNOS vTOS append .3DROP ;
:.FFIRST	vTOS ffirst TOS.NRO! ;
:.FNEXT		fnext PUSH.NRO ;

:.SYS	vTOS sys .DROP ; | ???
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
0 0 0 0 0 0 0
.dec .hex .bin .fix .str .wor .var .dwor .dvar
.; .( .) .[ .] .EX .0? .1? .+? .-? .<? .>? .=? .>=? .<=? .<>?
.A? .N? .B? .DUP .DROP .OVER .PICK2 .PICK3 .PICK4 .SWAP .NIP .ROT .2DUP .2DROP .3DROP .4DROP
.2OVER .2SWAP .>R .R> .R@ .AND .OR .XOR .+ .- .* ./ .<< .>> .>>> .MOD
./MOD .*/ .*>> .<</ .NOT .NEG .ABS .SQRT .CLZ .@ .C@ .Q@ .@+ .C@+ .Q@+ .!
.C! .Q! .!+ .C!+ .Q!+ .+! .C+! .Q+! .>A .A> .A@ .A! .A+ .A@+ .A!+ .>B
.B> .B@ .B! .B+ .B@+ .B!+ .MOVE .MOVE> .FILL .CMOVE .CMOVE> .CFILL .QMOVE .QMOVE> .QFILL .UPDATE
.REDRAW .MEM .SW .SH .VFRAME .XYPEN .BPEN .KEY .CHAR .MSEC .TIME .DATE .LOAD .SAVE .APPEND
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

::breakpoint | src --
|	memsrc ( @+ pick2 <? )( drop ) drop
|	4 - memsrc - code< +
	'<<bp ! ;

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
	(	@+ $ff and 2 << 'vmc + @ ex
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
		@+ $ff and 2 << 'vmc + @ ex
		1? ( '<<ip ! drop emu** ; )
		) nip
	'<<ip !
	emu** ;

::playvm | --
	<<ip 0? ( drop ; )
	**emu
	( <<bp <>?
		@+ $ff and 2 << 'vmc + @ ex
		1? )
	'<<ip !
	emu** ;

::tokenexec | adr+ token -- adr+
	$ff and 2 << 'vmc + @ ex ;


::stackprintvm
	" D) " emits
	'PSP 8 + ( NOS <=?
		@+ STKval "%d " print
		) drop
	'PSP NOS <? (
		TOS STKval "%d " print
		) drop
	cr
	" R) " emits
	'RSP 4 + ( RTOS <=?
		@+ STKval "%d " print
		) drop 	;

|---------- PREPARE CODE FOR RUN
|cdec chex cdec cdec cstr cwor cvar cdwor cdvar |7..15
|c; c( c) c[ c] cEX |16..21
|c0? c1? c+? c-? c<? c>? c=? c>=? c<=? c<>? cA? cN? cB? |22..34
|

:tokvalue | 'adr tok -- 'adr tok value
	over 4 - @ 8 >>> ;

:transflit | adr' tok -- adr' tok | ; 7..10
	tokvalue src +			| string in src

	| dex,hex,bin,fix

	str>nro nip
	8 << 10 or
	pick2 4 - !
	;

:blwhile? | -- fl
	tokvalue 3 << blok + @ $10000000 and ;

:blini | -- end?
	tokvalue 3 << blok + @ $ffffff and 2 << code + ;

:blend | -- end?
	tokvalue 3 << blok + 4 + @ 2 << code + ;

:patch! | adr tok value -- adr tok
	pick2 4 - dup @ $ff and rot or swap !


:transfcond | adr' tok -- adr' tok | ; 22..34
	blend pick2 - 8 << | delta jump
	patch! ;

:tr( | adr' tok -- adr' tok
	;
:tr) | adr' tok -- adr' tok
	blwhile? 0? ( drop over 4 - dup @ $ff and swap ! ; ) drop
	blini pick2 - 8 << | delta
	patch! ;

:tr[ | adr' tok -- adr' tok
	blend pick2 - 8 <<
	patch! ;

:tr] | adr' tok -- adr' tok
	blini 8 <<
	patch! ;

:transform | adr' -- adr'
	@+ $ff and
	7 10 bt? ( transflit )
|	17 =? ( tr( )
|	18 =? ( tr) )
	19 =? ( tr[ )
	20 =? ( tr] )
	22 34 bt? ( transfcond )
	drop
	;

:code2mem | adr -- adr
	dup 8 + @ 1 and? ( drop ; ) drop	| code only
	dup adr>toklen
	( 1? 1 - swap
		transform
		swap ) 2drop ;

::code2run
	dicc ( dicc> <?
		code2mem
		16 + ) drop ;

::newcode2run | adr --
	( code> <?
		transform
	 	) drop ;

|---------- PREPARE DATA FOR RUN
:var2mem | adr -- adr
	dup 8 + @ 1 nand? ( drop ; ) drop	| data only

	;

::data2mem
	dicc ( dicc> <?
		var2mem
		16 + ) drop ;
