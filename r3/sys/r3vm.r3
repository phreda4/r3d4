| VM r3
| PHREDA 2020
|-------------
^./r3base.r3
^./r3stack.r3

^r3/lib/xfb.r3
^r3/util/sort.r3

##<<ip	| ip
##<<bp	| breakpoint
##code<

| dicc transform to
| src|code|info|mov  << CODE
| src|<mem>|info|mov << DATA

#memsrc		| mem token>src ; code to src
##sortinc
#memvars	| mem vars		; real mem vars
#freemem	| free mem
#memaux

#srcnow

##REGA 0 0
##REGB 0 0

#sopx #sopy #sink

:**emu
	sink 'ink !
	sopx sopy op
	xfb> ;

:emu**
	>xfb
	ink 'sink !
	opx 'sopx ! opy 'sopy !
	;

|----------
:getbig
	blok + q@ ;

:.dec2	dup 4 - @ 8 >> getbig push.nro ;
:.bin2	dup 4 - @ 8 >> getbig push.nro ;
:.hex2	dup 4 - @ 8 >> getbig push.nro ;
:.fix2	dup 4 - @ 8 >> getbig push.nro ;
:.wor2 4 - @ 8 >> dic>tok @ ; | tail call

:.dec	dup 4 - @ 8 >> push.nro ;
:.hex   dup 4 - @ 8 >> push.nro ;
:.bin   dup 4 - @ 8 >> push.nro ;
:.fix   dup 4 - @ 8 >> push.nro ;
:.str   dup 4 - @ 8 >> blok + push.nro ;
:.wor	dup 4 - @ 8 >> dic>tok @ 4 'RTOS +! swap RTOS ! ;
:.var   dup 4 - @ 8 >> dic>tok @ @ push.nro ;
:.dwor	dup 4 - @ 8 >> dic>tok @ push.nro ;
:.dvar  dup 4 - @ 8 >> dic>tok @ push.nro ;

:.;		RTOS @ nip -4 'RTOS +! ;

:.EX	vTOS .DROP 4 'RTOS +! swap RTOS ! ;

:jmpr | adr' -- adrj
	dup 4 - @ 8 >> + ;

:.( 	;
:.)		dup 4 - @ 8 >> 0? ( drop ; ) + ;
:.[		jmpr ;
:.]		dup 4 - @ 8 >> PUSH.NRO ;

|--- COND
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
:.C@	vTOS c@ TOS.NRO! ;
:.Q@	vTOS q@ TOS.NRO! ;
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
:.MEM		freemem PUSH.NRO ;
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

:.SYS		vTOS sys .DROP ; | ???
:.SLOAD 	vTOS sload TOS.NRO! ;
:.SFREE 	vTOS sfree .DROP ;
:.SPLAY 	vTOS splay .DROP ;
:.MLOAD 	vTOS mload TOS.NRO! ;
:.MFREE 	vTOS mfree .DROP ;
:.MPLAY 	vTOS mplay .DROP ;
:.INK		ink PUSH.NRO ;
:.'INK		'ink PUSH.NRO ;
:.ALPHA		vTOS alpha .DROP ;
:.OPX		opx PUSH.NRO ;
:.OPY		opy PUSH.NRO ;
:.OP		vNOS vTOS op .2DROP ;
:.LINE		vNOS vTOS line .2DROP ;
:.CURVE 	vPK3 vPK2 vNOS vTOS curve .4DROP ;
:.CURVE3	vPK5 vPK4 vPK3 vPK2 vNOS vTOS curve3 .6DROP ;
:.PLINE		vNOS vTOS pline .2DROP ;
:.PCURVE 	vPK3 vPK2 vNOS vTOS pcurve .4DROP ;
:.PCURVE3	vPK5 vPK4 vPK3 vPK2 vNOS vTOS pcurve3 .6DROP ;
:.POLI		poli ;

#vmc
0 .dec2 .bin2 .hex2 .fix2 0 .wor2 .dec .bin .hex .fix .str .wor .var .dwor .dvar
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


|---------- PREPARE CODE FOR RUN
:tokvalue | 'adr tok -- 'adr tok value
	over 4 - @ 8 >> ;

:getsrcnro
	dup ?numero 1? ( drop nip nip ; ) drop
	str>fnro nip ;

:valstr
	( c@+ 1?
		34 =? ( drop c@+ 34 <>? ( 2drop ; ) )
		,c ) 2drop ;

:blwhile? | -- fl
	tokvalue 3 << blok + @ $10000000 and ;

:blini | -- end?
	tokvalue 3 << blok + @  $fffffff and 2 << code + ;

:blend | -- end?
	tokvalue 3 << blok + 4 + @ 2 << code + ;

:patch! | adr tok value -- adr tok
	pick2 4 - dup @ $ff and rot or swap ! ;

:transfcond | adr' tok -- adr' tok | ; 22..34
	blend pick2 - 4 + 8 << patch! ;


:trwor
	over @ $ff and
	16 <>? ( drop ; ) drop
	over dup @ $ff not and 6 or swap ! | call tail call
	;

:tr( | adr' tok -- adr' tok
	0 patch! ;	| not need but..

:tr) | adr' tok -- adr' tok
	blwhile? 0? ( drop 0 patch! ; ) drop
	blini pick2 - 4 + 8 << patch! ;

:tr[ | adr' tok -- adr' tok
	blend pick2 - 8 << patch! ;

:tr] | adr' tok -- adr' tok
	blini 8 << patch! ;

:>>next
	dup c@
	34 =? ( drop 1 + >>" trim ; )
	drop
	>>sp trim
	dup c@
	$7c =? ( drop >>cr trim ; )
	drop
	;

|---  transform 1 use Block and release

:transform1 | adr' -- adr'
	srcnow over code - memsrc + !
	srcnow >>next 'srcnow !
	@+ $ff and
	12 =? ( trwor ) | call
	17 =? ( tr( )
	18 =? ( tr) )
	19 =? ( tr[ )
	20 =? ( tr] )
	22 34 bt? ( transfcond )
	drop ;

:code2mem1 | adr -- adr
	dup 8 + @ 1 and? ( drop ; ) drop	| code only
	dup @ >>next 'srcnow !
	dup adr>toklen
	( 1? 1 - swap
		transform1
		swap ) 2drop ;

|---  transform 2 need memory

:storebig | adr tok type big -- adr' tok
	memaux q!
	6 -
	memaux blok - 8 << or pick2 4 - !
	8 'memaux +!
	;

:transflit | adr' tok -- adr' tok | ; 7..10
	tokvalue src +		| string in src
	dup isNro 0? ( 1 + ) 6 + | 7-dec,8-bin,9-hex,10-fix ..
	swap getsrcnro
	dup 40 << 40 >> <>? ( storebig ; )
	8 << or pick2 4 - ! ;

:trstr
	mark
	memaux 'here !
	over 4 - @ 8 >> src + valstr 0 ,c
	memaux blok - 8 << 11 or pick2 4 - !
	here 'memaux !
	empty
	;

:transform2 | adr' -- adr'
	@+ $ff and
	7 10 bt? ( transflit )
	11 =? ( trstr ) | str
	drop ;

:code2mem2 | adr -- adr
	dup 8 + @ 1 and? ( drop ; ) drop	| code only
	dup @ >>next 'srcnow !
	dup adr>toklen
	( 1? 1 - swap
		transform2
		swap ) 2drop ;

|--------
::code2run
	dicc ( dicc> <?
		code2mem1
		16 + ) drop
	blok 'memaux !
	dicc ( dicc> <?
		code2mem2
		16 + ) drop	;

::newcode2run | adr --
	dup ( code> <?
		transform1
	 	) drop
	blok 'memaux !
	( code> <?
		transform2
	 	) drop ;

|------ PREPARE DATA FOR RUN
#gmem ',

:memlit
	tokvalue src + getsrcnro gmem ex ;

:resbyte | reserve memory
	'here +! ;

:memstr | store string
	over 4 - @ 8 >> src + valstr 0 ,c ;

:memwor
	tokvalue dic>tok @ , ;

:getvarmem
	@+ $ff and
	7 10 bt? ( memlit )
	11 =? ( memstr ) | str
	12 15 bt? ( memwor )
	17 =? ( ',c 'gmem ! )	| (
	18 =? ( ', 'gmem ! )	| )
	19 =? ( ',q 'gmem ! )	| [
	20 =? ( ', 'gmem ! )	| ]
	58 =? ( 'resbyte 'gmem ! ) | *
	drop
	;

:var2mem | adr -- adr
	dup 8 + @ 1 nand? ( drop ; ) drop	| data only
	dup adr>toklen
	here pick3 4 + !	| save mem place
	0? ( , drop ; )
	', 'gmem ! 			| save dword default
	( 1? 1 - swap
		getvarmem
		swap ) 2drop ;

::data2mem
	dicc ( dicc> <?
		var2mem
		16 + ) drop ;

|------ for locate code
:sortincludes
	here 'sortinc !
	'inc >a
	0 ( cntinc <?
		4 a+ a@+ ,
		dup ,
		1 + ) drop
	cntinc 1 + sortinc shellsort ;

::findinclude | adr -- nro
	sortinc >a
	0 ( cntinc <?
		over a@+ <? ( 3drop a@ ; ) drop
		4 a+
		1 + ) 2drop
	a@ ;

|------ PREPARE 2 RUN
::vm2run
	iniXFB
	here 'memsrc !
	code2run
	code> code - 'here +!
	sortincludes
	here 'memvars !
	data2mem
	here 'freemem !
	;

::ip2src | -- adr
	<<ip 0? ( ; )
	code - memsrc + @ ;

|-------------------------------
| palabras de interaccion
|-------------------------------

::resetvm | --
	'PSP 'NOS !
	'RSP 'RTOS !
	0 'TOS !
	0 RTOS !
	<<boot '<<ip !
	**emu
	cls
	emu**
	;

::tokenexec | adr+ token -- adr+
	$ff and 2 << 'vmc + @ ex ;

::stepvm
	<<ip 0? ( drop resetvm ; )
	**emu
	@+ $ff and 2 << 'vmc + @ ex
	'<<ip !
	emu**
	;

::stepvmn | --
	<<ip 0? ( drop resetvm ; )
	dup @ $ff and $c <>? ( 2drop stepvm ; ) drop
	**emu
	dup 4 + swap
	( over <>?
		@+ $ff and 2 << 'vmc + @ ex
		1? ) nip
	'<<ip !
	emu** ;

::playvm | --
	<<ip 0? ( drop resetvm ; )
	**emu
	( <<bp <>?
		@+ $ff and 2 << 'vmc + @ ex
		1? )
	'<<ip !
	emu** ;

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
	'RSP 4 +
	( RTOS <=?
		@+ "%h " print
		) drop 	;

::breakpoint | cursor --
| conver to code..
	'<<bp  ! ;