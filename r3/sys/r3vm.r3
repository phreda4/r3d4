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
#memixy		| code to inc x y

#sortinc
#memvars	| mem vars		; real mem vars
#freemem	| free mem
#memaux

#srcnow
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

##REGA 0 0
##REGB 0 0
##TOS 0 0
##PSP * 1024
##NOS 'PSP
##RSP * 1024
##RTOS 'RSP

:getbig
	blok + q@ ;

:.DUP
	8 'NOS +! 'TOS q@ NOS q! ;

:PUSH.NRO | nro --
	.DUP 'TOS q! ;

:.OVER     .DUP NOS 8 - q@ 'TOS q! ;
:.PICK2    .DUP NOS 16 - q@ 'TOS q! ;
:.PICK3    .DUP NOS 24 - q@ 'TOS q! ;
:.PICK4    .DUP NOS 32 - q@ 'TOS q! ;
:.2DUP     .OVER .OVER ;
:.2OVER    .PICK3 .PICK3 ;
:.DROP		NOS q@ 'TOS q!	|...
:.NIP		-8 'NOS +! ;
:.2NIP      -16 'NOS +! ;
:.2DROP		NOS 8 - q@ 'TOS q! -16 'NOS +! ;
:.3DROP		NOS 16 - q@ 'TOS q! -24 'NOS +! ;
:.4DROP		NOS 24 - q@ 'TOS q! -32 'NOS +! ;
:.6DROP		NOS 40 - q@ 'TOS q! -48 'NOS +! ;
:.SWAP		NOS q@ 'TOS @ NOS q! 'TOS q! ;
:.ROT		'TOS q@ NOS 8 - q@ 'TOS q! NOS q@ NOS 8 - q!+ q! ;
:.2SWAP		'TOS q@ NOS q@ NOS 8 - dup 8 - q@ NOS q! q@ 'TOS q! NOS 16 - q!+ q! ;

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
:.wor	dup 4 - @ 8 >> dic>tok @ 8 'RTOS q+! swap RTOS q! ;
:.var   dup 4 - @ 8 >> dic>tok @ @ push.nro ;
:.dwor	dup 4 - @ 8 >> dic>tok @ push.nro ;
:.dvar  dup 4 - @ 8 >> dic>tok @ push.nro ;

:.;		RTOS q@ nip -8 'RTOS +! ;

:.EX	'TOS q@ .DROP 8 'RTOS +! swap RTOS q! ;

:jmpr | adr' -- adrj
	dup 4 - @ 8 >> + ;

:.( 	;
:.)		dup 4 - @ 8 >> 0? ( drop ; ) + ;
:.[		jmpr ;
:.]		dup 4 - @ 8 >> PUSH.NRO ;

|--- COND
:.0?	'TOS q@ 1? ( drop jmpr ; ) drop ;
:.1?	'TOS q@ 0? ( drop jmpr ; ) drop ;
:.+?	'TOS q@ -? ( drop jmpr ; ) drop ;
:.-?	'TOS q@ +? ( drop jmpr ; ) drop ;
:.=?	NOS q@ 'TOS q@ <>? ( drop jmpr .DROP ; ) drop .DROP ;
:.<?	NOS q@ 'TOS q@ >=? ( drop jmpr .DROP ; ) drop .DROP ;
:.>?	NOS q@ 'TOS q@ <=? ( drop jmpr .DROP ; ) drop .DROP ;
:.<=?	NOS q@ 'TOS q@ >? ( drop jmpr .DROP ; ) drop .DROP ;
:.>=?	NOS q@ 'TOS q@ <? ( drop jmpr .DROP ; ) drop .DROP ;
:.<>?	NOS q@ 'TOS q@ =? ( drop jmpr .DROP ; ) drop .DROP ;
:.A?	NOS q@ 'TOS q@ nand? ( drop jmpr .DROP ; ) drop .DROP ;
:.N?	NOS q@ 'TOS q@ and? ( drop jmpr .DROP ; ) drop .DROP ;
:.B?	NOS 8 - q@ NOS q@ 'TOS q@ bt? ( drop jmpr .2DROP ; ) drop .2DROP ;


:.AND		NOS q@ 'TOS q@ and .NIP 'TOS q! ;
:.OR		NOS q@ 'TOS q@ or .NIP 'TOS q! ;
:.XOR		NOS q@ 'TOS q@ xor .NIP 'TOS q! ;
:.NOT		'TOS q@ not 'TOS q! ;
:.+			NOS q@ 'TOS q@ + .NIP 'TOS q! ;
:.-			NOS q@ 'TOS q@ - .NIP 'TOS q! ;
:.*			NOS q@ 'TOS q@ * .NIP 'TOS q! ;
:./			NOS q@ 'TOS q@ / .NIP 'TOS q! ;
:.*/		NOS 8 - q@ NOS q@ 'TOS q@ */ .2NIP 'TOS q! ;
:.*>>		NOS 8 - q@ NOS q@ TOS *>> .2NIP 'TOS q! ;  | need LSB (TOS is 32bits)
:.<</		NOS 8 - q@ NOS q@ TOS <</ .2NIP 'TOS q! ;  | need LSB (TOS is 32bits)
:./MOD		NOS q@ 'TOS q@ /mod 'TOS q! NOS q! ;
:.MOD		NOS q@ 'TOS q@ mod .NIP 'TOS q! ;
:.ABS		'TOS q@ abs 'TOS q! ;
:.NEG		'TOS q@ neg 'TOS q! ;
:.CLZ		'TOS q@ clz 'TOS q! ;
:.SQRT		'TOS q@ sqrt 'TOS q! ;
:.<<		NOS q@ TOS << .NIP 'TOS q! ;     | need LSB (TOS is 32bits)
:.>>		NOS q@ TOS >> .NIP 'TOS q! ;     | need LSB (TOS is 32bits)
:.>>>		NOS q@ TOS >>> .NIP 'TOS q! ;    | need LSB (TOS is 32bits)

|--- R
:.>R	8 'RTOS +! 'TOS q@ RTOS q! .DROP ;
:.R>	.DUP RTOS dup q@ 'TOS q! 8 - 'RTOS ! ;
:.R@	.DUP RTOS q@ 'TOS q! ;

|--- REGA
:.>A	'TOS q@ 'REGA q! .DROP ;
:.A>	'REGA q@ PUSH.NRO ;
:.A@	REGA @ PUSH.NRO ;
:.A!	'TOS q@ REGA ! .DROP ;
:.A+	'TOS q@ 'REGA q+! .DROP ;
:.A@+	REGA dup 4 + 'REGA q! @ PUSH.NRO ;
:.A!+	'TOS q@ REGA dup 4 + 'REGA ! ! .DROP ;

|--- REGB
:.>B	'TOS q@ 'REGB q! .DROP ;
:.B>	'REGB q@ PUSH.NRO ;
:.B@	REGB @ PUSH.NRO ;
:.B!	'TOS q@ REGB ! .DROP ;
:.B+	'TOS q@ 'REGB q+! .DROP ;
:.B@+	REGB dup 4 + 'REGB q! @ PUSH.NRO ;
:.B!+	'TOS q@ REGB dup 4 + 'REGB ! ! .DROP ;

:.@		'TOS q@ @ 'TOS q! ;
:.C@	'TOS q@ c@ 'TOS q! ;
:.Q@	'TOS q@ q@ 'TOS q! ;
:.!		NOS q@ 'TOS q@ ! .2DROP ;
:.C!	NOS q@ 'TOS q@ c! .2DROP ;
:.Q!	NOS q@ 'TOS q@ q! .2DROP ;
:.+!	NOS q@ 'TOS q@ +! .2DROP ;
:.C+!	NOS q@ 'TOS q@ c+! .2DROP ;
:.Q+!	NOS q@ 'TOS q@ q+! .2DROP ;
:.@+	'TOS q@ @ 4 'TOS q+! PUSH.NRO ;
:.!+	NOS q@ 'TOS q@ ! .NIP 4 'TOS q+! ;
:.C@+	'TOS q@ c@ 1 'TOS q+! PUSH.NRO ;
:.C!+	NOS q@ 'TOS q@ c! .NIP 1 'TOS +! ;
:.Q@+	'TOS q@ q@ 8 'TOS q+! PUSH.NRO ;
:.Q!+	NOS q@ 'TOS q@ q! .NIP 8 'TOS +! ;

:.MOVE		NOS 8 - q@ NOS q@ 'TOS q@ move .3DROP ;
:.MOVE>		NOS 8 - q@ NOS q@ 'TOS q@ move> .3DROP ;
:.FILL		NOS 8 - q@ NOS q@ 'TOS q@ fill .3DROP ;
:.CMOVE		NOS 8 - q@ NOS q@ 'TOS q@ cmove .3DROP ;
:.CMOVE>	NOS 8 - q@ NOS q@ 'TOS q@ cmove> .3DROP ;
:.CFILL		NOS 8 - q@ NOS q@ 'TOS q@ cfill .3DROP ;
:.QMOVE		NOS 8 - q@ NOS q@ 'TOS q@ qmove .3DROP ;
:.QMOVE>	NOS 8 - q@ NOS q@ 'TOS q@ qmove> .3DROP ;
:.QFILL		NOS 8 - q@ NOS q@ 'TOS q@ qfill .3DROP ;

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

:.LOAD		NOS q@ 'TOS q@ load .NIP 'TOS q! ;
:.SAVE		NOS 8 - q@ NOS q@ 'TOS q@ save .3DROP ;
:.APPEND	NOS 8 - q@ NOS q@ 'TOS q@ append .3DROP ;
:.FFIRST	'TOS q@ ffirst 'TOS q! ;
:.FNEXT		fnext PUSH.NRO ;

:.SYS		'TOS q@ sys .DROP ; | ???
:.SLOAD 	'TOS q@ sload 'TOS q! ;
:.SFREE 	'TOS q@ sfree .DROP ;
:.SPLAY 	'TOS q@ splay .DROP ;
:.MLOAD 	'TOS q@ mload 'TOS q! ;
:.MFREE 	'TOS q@ mfree .DROP ;
:.MPLAY 	'TOS q@ mplay .DROP ;
:.INK		ink PUSH.NRO ;
:.'INK		'ink PUSH.NRO ;
:.ALPHA		'TOS q@ alpha .DROP ;
:.OPX		opx PUSH.NRO ;
:.OPY		opy PUSH.NRO ;
:.OP		NOS q@ 'TOS q@ op .2DROP ;
:.LINE		NOS q@ 'TOS q@ line .2DROP ;
:.CURVE 	NOS 16 - q@ NOS 8 - q@ NOS q@ 'TOS q@ curve .4DROP ;
:.CURVE3	NOS 32 - q@ NOS 24 - q@ NOS 16 - q@ NOS 8 - q@ NOS q@ 'TOS q@ curve3 .6DROP ;
:.PLINE		NOS q@ 'TOS q@ pline .2DROP ;
:.PCURVE 	NOS 16 - q@ NOS 8 - q@ NOS q@ 'TOS q@ pcurve .4DROP ;
:.PCURVE3	NOS 32 - q@ NOS 24 - q@ NOS 16 - q@ NOS 8 - q@ NOS q@ 'TOS q@ pcurve3 .6DROP ;
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

|------ for locate include from src
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
		over a@+ <? ( 3drop a> 8 - @ ; ) drop
		4 a+
		1 + ) 2drop
	a> 4 - @ ;

|---------- generate include/position in src from tokens

#posnow

:getsrcxyinc | adr -- adr ; incremental
	posnow
	( over <? c@+
		1 'sopx +!
		9 =? ( 3 'sopx +! )
		13 =? ( 1 'sopy +! 0 'sopx ! )
		drop ) drop
	dup 'posnow ! ;

:getsrcxy | adr -- adr
	0 'sopx ! 0 'sopy !
	sink 3 << 'inc + 4 + @ | start of include
	'posnow !
	getsrcxyinc ;

:>>next
	dup c@
	34 =? ( drop 1 + >>" trim ; )
	drop
	>>sp trim
	dup c@
	$7c =? ( drop >>cr trim ; )
	drop
	;

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
	over 4 - dup @ $ff not and 6 or swap ! | call tail call
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

|---  transform 1 use Block and release

:transform1 | adr' -- adr'
	srcnow
	getsrcxyinc
	sopy sopx 12 << or sink 24 << or
	pick2 code - memixy + !
	over code - memsrc + !
	srcnow >>next 'srcnow !
	@+ $ff and
|	12 =? ( trwor ) | call
	17 =? ( tr( )
	18 =? ( tr) )
	19 =? ( tr[ )
	20 =? ( tr] )
	22 34 bt? ( transfcond )
	drop ;

:code2mem1 | adr -- adr
	dup 8 + @ 1 and? ( drop ; ) drop	| code only
	dup @ findinclude 'sink ! | include
	dup @ >>next getsrcxy 'srcnow !
	dup adr>toklenreal
	( 1? 1 - swap
		transform1
		swap ) 2drop ;

:sameinc | adr -- adr
	dup @
	dup findinclude
	sink =? ( drop >>next 'srcnow ! ; )
	|---first word in include

	'sink !
	>>next getsrcxy 'srcnow !
	;

:code2mem1 | adr -- adr
	dup 8 + @ 1 and? ( drop ; ) drop	| code only
	sameinc
	dup adr>toklenreal
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
	dup adr>toklenreal
	( 1? 1 - swap
		transform2
		swap ) 2drop ;

|--------
::code2run
	-1 'sink ! | include nr
	dicc ( dicc> <?
		code2mem1
		16 + ) drop
	blok 'memaux !
	dicc ( dicc> <?
		code2mem2
		16 + ) drop	;

|------- IMM CODE
:transformimm
	@+ $ff and
	7 10 bt? ( transflit )
	11 =? ( trstr ) | str
|	12 =? ( trwor ) | call
	17 =? ( tr( )
	18 =? ( tr) )
	19 =? ( tr[ )
	20 =? ( tr] )
	22 34 bt? ( transfcond )
	drop ;

::immcode2run | adr --
	0 'nbloques !	| reuse blocks
	( code> <?
		transformimm
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


|------ PREPARE 2 RUN
::vm2run
	iniXFB
	sortincludes
	here dup 'memsrc !			| array code to source
	code> code - + 'memixy !	| array code to include/X/Y
	code> code - 1 << 'here +!
	code2run
	here 'memvars !
	data2mem
	here 'freemem !
	;

::code2src | code -- src
	code - memsrc + @ ;

::code2ixy | code -- ixy
	code - memixy + @ ;

::src2code | src incnow -- code
	memixy
	( @+ 24 >> pick2 <>?
		drop ) drop nip
	4 - memixy - memsrc + |	first code from include
	( @+ ( 0? drop @+ )
		pick2 <=? drop ) drop	| search src
	nip
	4 - ( dup @ 0? drop 4 - ) drop			| back 1
	4 - ( dup @ 0? drop 4 - ) drop			| back 1
	memsrc - code +
	;

::src2word | src incnow -- word
	src2code
	dicc>
	( 16 - dicc >=?
		dup 4 + @ pick2 <? (  drop nip dicc - 4 >> ; )
		drop ) 2drop
	0 ;

::breakpoint | cursor --
	src2code '<<bp !
	;

::dumpmm
	cls home
	$ff00 'ink !
	memsrc dumpd ;

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
	$ffffff 'ink !
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
	'PSP 16 + ( NOS <=?
		q@+ "%d " print
		) drop
	'PSP NOS <? (
		'TOS q@ "%d " print
		) drop
	cr
	" R) " emits
	'RSP 8 +
	( RTOS <=?
		q@+ "%h " print
		) drop 	;

:printpila
	q@ " %d " sprint $3f6fAf bprint ;

::showvstack
	NOS 16 +
	NOS 'TOS q@ over 8 + q! 'PSP - 3 >>
	14 min
	( 1? swap 8 -
		cols 20 - rows 1 - pick3 - gotoxy
		dup printpila
		swap 1 - ) 2drop

	RTOS 8 +
	RTOS 'RSP - 3 >>
	14 min
	( 1? swap 8 -
		cols 3 - rows 1 - pick3 - gotoxy
		" r " $3f6fAf bprint
|		dup printpila
		swap 1 - ) 2drop
|	cols 34 - rows 1 - gotoxy
|	regb rega " A:%h B:%h" $3f6fAf bprint

	;
