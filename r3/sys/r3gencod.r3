| r3-gencode
| PHREDA 2018
|
^./r3base.r3
^./r3cellana.r3
|^./r3asm1.r3
^./r3asm.r3

#lastdircode

|----- division by constant
| http://www.flounder.com/multiplicative_inverse.htm

#ad		| d absoluto
#t #anc #p
#q1 #r1
#q2 #r2

#divm	| magic mult
#divs   | shift mult

:calcstep
	1 'p +!
	q1 1 << 'q1 ! r1 1 << 'r1 !
	r1 anc >=? ( 1 'q1 +! anc neg 'r1 +! ) drop
	q2 1 << 'q2 ! r2 1 << 'r2 !
	r2 ad >=? ( 1 'q2 +! ad neg 'r2 +! ) drop
	;

:calcmagic | d --
	dup abs 'ad !
    $80000000 over 31 >>> + 't !
    t dup 1 - swap ad mod - 'anc !
    31 'p !
    $80000000 anc / abs 'q1 !
    $80000000 q1 anc * - abs 'r1 !
	$80000000 ad / abs 'q2 !
	$80000000 q2 ad * - abs 'r2 !
	( calcstep
		ad r2 -	| delta
		q1 =? ( r1 0? ( swap 1 + swap ) drop )
		q1 >? drop ) drop
	q2 1 +
	swap -? ( drop neg 'divm ! p 'divs ! ; ) drop
	'divm ! p 'divs ! ;

#TKdup $23
#TKover $25
#TKswap $29
#TKand $35
#TK+ $38
#TK- $39
#TK* $3A
#TK<< $3C
#TK>> $3D
#TK>>> $3E
#TK*>> $42

|--- ajuste por signo
:signadj!+ | --
	TKdup code!+
	63 cte!+
	TK>> code!+
	TK- code!+
	;

|-----------------------------------
:idec | --
	getcte push.nro
	2code!+ ;

:ihex | --
	getcte2 push.nro
	2code!+ ;

:istr
	getval push.str
	2code!+ ;

:idwor
	getval push.wrd
	2code!+ ;

:idvar
	getval push.wrd
	2code!+ ;

|----------- inline cte
:d1 8 >>> src + getsrcnro push.nro ;
:d2 8 >>> push.str ;
:d3 8 >>> push.wrd ;

#tcte d1 d1 d1 d1 d2 d3 d3 d3

:icte | adr word -- adr
	dic>tok @ @ dup
	dup $ff and 7 - 2 << 'tcte + @ ex
	code!+
	;

:ivar
	getval
	dup dic>inf @ $8 an? ( drop icte ; ) drop | inline
	push.var
	2code!+
	;

|----------- inline word

:iwor
	| inline?

	getval
	dic>du
	dup ( 1? 1 - .drop ) drop
	+ ( 1? 1 -  dup push.reg ) drop
	2code!+
	;

|------------
:i;
	2code!+	;

:i(
	2code!+
	stk.push ;

:i)
	2code!+
	stk.pop	;

:i[
:i]
	;

:iex
|	lastdircode dic>du
|	dup ( 1? 1 - .drop ) drop
|	+ ( 1? 1 - dup push.reg ) drop
	2code!+
	;

:gwhilejmp
	getval getiw
	1? ( stk.drop stk.push ) | while
	2drop
	;

:i0? :i1? :i+? :i-?
	2code!+
	gwhilejmp ;

:i<? :i>? :i=? :i>=? :i<=? :i<>? :iA? :iN?
	2code!+
	.drop
	gwhilejmp ;

:iB?
	2code!+
	.2drop
	gwhilejmp ;

:iDUP	2code!+ .dup ;
:iDROP	2code!+ .drop ;
:iOVER	2code!+ .over ;
:iPICK2	2code!+ .pick2 ;
:iPICK3	2code!+ .pick3 ;
:iPICK4	2code!+ .pick4 ;
:iSWAP	2code!+ .swap ;
:iNIP	2code!+ .nip ;
:iROT	2code!+ .rot ;
:i2DUP	2code!+ .2dup ;
:i2DROP	2code!+ .2drop ;
:i3DROP	2code!+ .3drop ;
:i4DROP	2code!+ .4drop ;
:i2OVER	2code!+ .2over ;
:i2SWAP	2code!+ .2swap ;

:i>R .drop 2code!+ ;
:iR> .dup 2code!+ ;
:iR@ .dup 2code!+ ;

:iAND
	nro2stk 0? ( drop .AND ; ) drop
	2code!+
	.drop ;
:iOR
	nro2stk 0? ( drop .OR ; ) drop
	2code!+
	.drop ;
:iXOR
	nro2stk 0? ( drop .XOR ; ) drop
	2code!+
	.drop ;
:iNOT
	nro1stk 0? ( drop .NOT ; ) drop
	2code!+
	;
:iNEG
	nro1stk 0? ( drop .NEG ; ) drop
	2code!+
	;
:i+
	nro2stk 0? ( drop .+ ; ) drop
	2code!+
	.drop ;
:i-
	nro2stk 0? ( drop .- ; ) drop
	2code!+
	.drop ;

|---------------- *
| 8 * --> 3 <<
:*pot
	31 swap clz - cte!+
	TK<< code!+
	;

| 7 * --> dup 3 << swap -
:*pot-1
	TKdup code!+	| dup
	32 swap clz - cte!+
	TK<<	code!+	| <<
	TKswap	code!+	| swap
	TK- code!+ | -
	;

:*nro
	code<<
	vTOS
	dup 1 - na? ( *pot ; )
	dup 1 + na? ( *pot-1 ; )
	drop
	;

:i*
	nro2stk 0? ( drop .* ; ) drop
	nro1stk 0? ( drop *nro ; ) drop
	2code!+
	.drop ;

|---- cte / --> divm divs *>> dup 31 >> -
:/cte
	calcmagic
	divs cte!+
	divm cte!+
	TK*>> code!+ 		| *>>
	signadj!+ ;

|----  2 / --> dup 31 >> + 2/
:/cte2
	TKdup code!+ | dup 31
	31 cte!+
	TK>>> code!+ | >>>
	TK+	code!+ | +
	1 cte!+
	TK>> code!+ | 2/
	;

|----  4 / --> dup 31 >> 30 >>> + 2 >>
:/nro
	code<<
	vTOS
	dup 1 - an? ( /cte ; )
	2 =? ( /cte2 ; )
	swap
	31 cte!+
	TKdup code!+ | dup
	TK>> code!+ | >>
	33 32 pick2 clz - - cte!+ |30
	TK>>> code!+ | >>>
	TK+	code!+	| +
	31 swap clz - cte!+ | 2
	TK>> code!+ | >>
	;

:i/
	nro2stk 0? ( drop ./ ; ) drop
	nro1stk 0? ( drop /nro ; ) drop
	2code!+
	.drop ;

:i<<
	nro2stk 0? ( drop .<< ; ) drop
	2code!+
	.drop ;
:i>>
	nro2stk 0? ( drop .>> ; ) drop
	2code!+
	.drop ;
:i>>>
	nro2stk 0? ( drop .>>> ; ) drop
	2code!+
	.drop ;

|---------------- */
:i*/
	nro3stk 0? ( drop .*/ ; ) drop
	2code!+
	.2drop ;


|---------------- /MOD
:/modcte
	dup
	calcmagic
	TKdup code!+	| dup
	divm cte!+
	divs cte!+
	TK*>> code!+ 	| *>>
	signadj!+
	TKswap	code!+	| swap
	TKover	code!+	| over
	cte!+			| NRO
	TK*	code!+		| *
	TK-	code!+		| -
	;

|----  8 /mod --> dup / swap mod
:/MODnro
	code<<
	vTOS
	dup 1 - an? ( /modcte ; )
	swap
    TKdup code!+ 	| dup
	TKdup code!+	| dup  
    31 cte!+ | 31
	TK>> code!+ | >>
	33 32 pick2 clz - - cte!+ |30
	TK>>> code!+ | >>>
	TK+	code!+	| +
	31 over clz - cte!+ 	| 2
	TK>> code!+ | >>
	TKswap	code!+	| swap
	TKdup code!+ | dup
	31 cte!+ |31
	TK>> code!+ | >>
	33 32 pick2 clz - - cte!+
	TK>>> code!+	| >>>
	TKswap	code!+	| swap
	TKover	code!+	| over
	TK+	code!+	| +
	1 - cte!+  | mask
	TKand code!+	| AND
	TKswap	code!+	| swap
	TK-	code!+	| -
	;


:i/MOD
	nro2stk 0? ( drop ./MOD ; ) drop
	nro1stk 0? ( drop /MODnro ; ) drop
	2code!+
	;

|---------------- MOD
:modcte
	dup
	calcmagic
	divm cte!+
	TKdup code!+ | dup
	divs cte!+
	TK*>> code!+ 		| *>>
	signadj!+
	cte!+	| NRO
	TK*	code!+	| *
	TK-	code!+	| -
	;

|----  8 mod --> $7 and
|	dup 31 >> (33-4)29 >>> swap over + 7 and swap -
:modnro
    code<<
	dup 1 - an? ( modcte ; )
	TKdup code!+ | dup 31
	31 cte!+
	TK>> code!+ | >>
	33 32 pick2 clz - - cte!+
	TK>>> code!+	| >>>
	TKswap	code!+	| swap
	TKover	code!+	| over
	TK+	code!+	| +
	1 - cte!+ | mask
	TKand code!+	| AND
	TKswap	code!+	| swap
	TK-	code!+	| -
	;


:iMOD
	nro2stk 0? ( drop .MOD ; ) drop
	nro1stk 0? ( drop MODnro ; ) drop
	2code!+
	.drop ;

|------------------
:iABS
	nro1stk 0? ( drop .ABS ; ) drop
	2code!+
	;
:iSQRT
	nro1stk 0? ( drop .SQRT ; ) drop
	2code!+
	;
:iCLZ
	nro1stk 0? ( drop .CLZ ; ) drop
	2code!+
	;
:i*>>
	nro3stk 0? ( drop .*>> ; ) drop
	2code!+
	.2drop ;
:i<</
	nro3stk 0? ( drop .<</ ; ) drop
	2code!+
	.2drop ;


:i@ :iC@ :iQ@
	2code!+ ;
:i@+ :iC@+ :iQ@+
	2code!+ .dup ;
:i! :iC! :iQ!
	2code!+ .2drop ;
:i!+ :iC!+ :iQ!+
	2code!+ .drop ;
:i+! :iC+! :iQ+!
	2code!+ .2drop ;

:i>A	2code!+ .drop ;
:iA>	2code!+ .dup ;
:iA@	2code!+ .dup ;
:iA!	2code!+ .drop ;
:iA+    2code!+ .drop ;
:iA@+   2code!+ .dup ;
:iA!+   2code!+ .drop ;

:i>B    2code!+ .drop ;
:iB>    2code!+ .dup ;
:iB@    2code!+ .dup ;
:iB!    2code!+ .drop ;
:iB+    2code!+ .drop ;
:iB@+   2code!+ .dup ;
:iB!+   2code!+ .drop ;

:iMOVE :iMOVE> :iFILL
:iCMOVE :iCMOVE> :iCFILL
:iQMOVE :iQMOVE> :iQFILL
	2code!+ .3drop ;
:iUPDATE :iREDRAW
	2code!+ ;

:iMEM :iSW :iSH :iFRAMEV
:iXYPEN :iBPEN :iKEY :iCHAR
	0 push.cte 2code!+ ;

:iMSEC :iTIME :iDATE
	.dup 2code!+ ;
:iLOAD	|LOAD   ab -- c
	.drop 2code!+ ;

:iSAVE	|SAVE   abc --
:iAPPEND	|APPEND   abc --
	.3drop 2code!+ ;

:iFFIRST	|FFIRST   a -- b
	2code!+ ;
:iFNEXT		|FNEXT     -- a
	.dup 2code!+ ;

:iSYS
	.drop 2code!+ ;


#vmc
0 0 0 0 0 0 0 idec ihex idec idec istr iwor ivar idwor idvar
i; i( i) i[ i] iEX i0? i1? i+? i-? i<? i>? i=? i>=? i<=? i<>?
iA? iN? iB? iDUP iDROP iOVER iPICK2 iPICK3 iPICK4 iSWAP iNIP iROT i2DUP i2DROP i3DROP i4DROP
i2OVER i2SWAP i>R iR> iR@ iAND iOR iXOR i+ i- i* i/ i<< i>> i>>> iMOD
i/MOD i*/ i*>> i<</ iNOT iNEG iABS iSQRT iCLZ i@ iC@ iQ@ i@+ iC@+ iQ@+ i!
iC! iQ! i!+ iC!+ iQ!+ i+! iC+! iQ+! i>A iA> iA@ iA! iA+ iA@+ iA!+ i>B
iB> iB@ iB! iB+ iB@+ iB!+ iMOVE iMOVE> iFILL iCMOVE iCMOVE> iCFILL iQMOVE iQMOVE> iQFILL iUPDATE
iREDRAW iMEM iSW iSH iFRAMEV iXYPEN iBPEN iKEY iCHAR iMSEC iTIME iDATE iLOAD iSAVE iAPPEND iFFIRST
iFNEXT iSYS

0 0 0 0 0 |iINK i'INK iALPHA iOPX iOPY
0 0 0 0 |iOP iLINE iCURVE iCURVE3
0 0 0 0 |iPLINE iPCURVE iPCURVE3 iPOLI

( 0 )

|------------------------------------------
:tocode | adr token -- adr
|	"; " ,s dup ,tokenprint 9 ,c ,printstka ,cr
	$ff and 2 << 'vmc + @ ex ;

:,header | adr -- adr
    ";--------------------------" ,s ,cr
    "; " ,s
	dup dicc - 4 >> ,codeinfo ,cr
	dicc> 16 - =? ( "INICIO:" ,s ,cr ; )
	dup adr>dicname ,s
	":" ,s ,cr ;

|-----------------------------
:gencode | adr --
	dup 8 + @
	1 an? ( 2drop ; )	| code
	12 >> $fff and 0? ( 2drop ; )	| no calls
	drop
	codeini
	,header
	dup 12 + @ $f and
	DeepStack
    ";---------OPT" ,ln |----- generate buffer
	dup adr>toklen
	( 1? 1 - swap
		@+ tocode
		swap ) 2drop

    ";---------ANA" ,ln |----- cell analisys
	dup 12 + @ $f and
	anaDeepStack
	'bcode ( bcode> <?
		@+

		"; " ,s dup ,tokenprint 9 ,c ,printstka ,cr
		"asm/code.asm" savemem | debug

		anastep
		) drop
    anaend

	cellinfo

    ";---------GEN" ,ln |----- generate code
	12 + @ $f and	| use
	genasmcode

	;

|----------------------------
:debugblok
	";---- bloques ----" ,s
	blok >a
	,cr
	nbloques ( 1? 1 -
		nbloques over - "; %h. " ,format
		a@+ dup 28 >>>
		swap $ffffff and
		a@+
		"%d %d %d" ,format ,cr
		) drop ;

|----------------------------
::r3-gencode
	mark
	";---r3 compiler code.asm" ,ln
|	switchfull "; full=%d" ,format ,cr
|	switchresy switchresx "; resx=%d resy=%d" ,format ,cr
|	switchmem "; mem=$%h" ,format ,cr

|	debugblok

	dicc ( dicc> <?
		dup gencode
		16 + ) drop

	0 ,c
	"asm/code.asm"
	savemem
	empty ;

