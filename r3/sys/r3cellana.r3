| analisis, detect static cell
| PHREDA 2019
|-------------------------
^./r3stack.r3

#itok 0

#lastdircode 0 | ultima direccion de codigo

##ncell 0	| cnt cells

##cellf * 4096	| flags
##cellv * 4096 | vida de celda | vr iii fff

| Info de celdas
| RR WW FFFF
| R cnt de lecturas
| W cnt de escrituras
| flags........
|  $1 in W		| word
|  $2 out W
|  $4 in C		| call
|  $8 out C
| $10 var
| $20 dir var
| $40 dir code
| $80 copia de A en cellt
| $100 celda exec
| $800 celda ya asignada (para vreg)
| $1000 celda A
| $2000 celda C
| $4000 celda SI
| $8000 celda DI

:cellnew | -- nro
	ncell
	0 over 2 << 'cellf + !
|	dup itok ";ini:%d r:%d" ,format ,cr | DEBUG
	itok over 2 << 'cellv + ! | inicio de vida
	dup 1 + 'ncell !
	;

:cellend | nro ---
|	dup itok ";end:%d r:%d" ,format ,cr | DEBUG
	itok 10 <<
	swap 2 << 'cellv +
	dup @ $ff000fff and
	rot or swap ! ;

::cellnewg2 | -- nc
	ncell dup 1 + 'ncell ! ;

::cellnewg | -- vreg
	ncell dup 1 + 'ncell !
	2 << 'cellv + @
	24 >>
	;

:cellconv | 'cell vreg -- 'cell vreg
	2dup swap cell.REG
	;

::cellstart | --
  	0 'ncell !
	'PSP 8 + ( NOS <=? dup
|		cellnewg 1? ( cellconv ) 2drop
		cellnewg 2drop
		4 + ) drop
	'PSP NOS <? (	| eax already
|		'TOS cellnewg 1? ( cellconv ) 2drop
		'TOS cellnewg 2drop
		) drop
	;

|------ from TOS
:cellr | --
	$1000000 TOS 8 >> 2 << 'cellf + +! ;

:cellw | --
	$10000 TOS 8 >> 2 << 'cellf + +! ;

:cellfl | -- adr flg
	TOS 8 >> 2 << 'cellf + dup @ ;

:cellA cellfl $1000 or swap ! ;
:cellC cellfl $2000 or swap ! ;
:cellSI	cellfl $4000 or swap ! ;
:cellDI	cellfl $8000 or swap ! ;

|------

:valtok	dup 4 - @ 8 >> ;

:codtok	valtok 'lastdircode ! ;

:newREG	cellnew push.CTE ;

:endREG .pop 8 >> cellend ;

::anaDeepStack | deep --
	IniStack
	0 'itok !
	0 'ncell !
	( 1? 1 - newREG cellW ) drop ;

|------------------------------------------

:idec  newREG ;
:istr
	dup 4 - @ 8 >>> src +
	strusestack ( 1? 1 - endREG ) drop
	newREG
	;
:iwor
	valtok
	dic>du
	dup ( 1? 1 - endREG ) drop
	+ ( 1? 1 - newREG ) drop
	;
:ivar  codtok newREG ;
:idwor codtok newREG ;
:idvar codtok newREG ;
:i; cellA ;
:i(	stk.push ;
:i) stk.pop	;

:gwhilejmp
	valtok 3 << blok + @ $10000000 and
	1? ( stk.drop stk.push ) | while
	drop
	;

:i[
:i]
	;
:iEX
	.drop
	lastdircode dic>du
	dup ( 1? 1 - endREG ) drop
	+ ( 1? 1 - newREG ) drop
	;

|---- pila
:iDUP 	.dup ;
:iOVER  .over ;
:iPICK2 .pick2 ;
:iPICK3 .pick3 ;
:iPICK4 .pick4 ;
:i2OVER	.2over ;

:iSWAP	.swap ;
:iNIP   .nip ;
:iROT   .rot ;
:i2DUP  .2dup ;
:i2SWAP .2swap ;

:iDROP  endreg ;
:i4DROP idrop
:i3DROP idrop
:i2DROP	idrop idrop ;

:i>R	.>r ;
:iR>    .r> ;
:iR@	.r@ ;

:iop2a1	endREG endREG newreg cellW ; | + - * and or xor
:iop1a1	endreg newreg cellW ; | neg not

:i/
	endREG endREG newreg cellW ;
:i*/
	endREG endREG endREG newreg cellW ;
:i/MOD
	endREG endREG newreg cellW newreg cellW ;
:iMOD
	endREG endREG newreg cellW ;
:iABS
	endREG newreg cellW ;
:iSQRT
	endREG newreg cellW ;
:iCLZ
	endREG newreg cellW ;
:i<<
:i>>
:i>>>
	endREG endREG newreg cellW ;
:i*>>
:i<</
	endREG endREG endREG newreg cellW ;

:i@
:iC@
:iQ@
	cellW ;
:i@+
:iC@+
:iQ@+
	cellW newreg ;
:i!
:iC!
:iQ!
	endREG endREG  ;
:i!+
:iC!+
:iQ!+
	cellW endREG ;
:i+!
:iC+!
:iQ+!
	endREG endREG ;
:i>A	endReg ;
:iA>    newReg ;
:iA@    newReg ;
:iA!    endReg ;
:iA+    endReg ;
:iA@+   newReg ;
:iA!+   endReg ;
:i>B    endReg ;
:iB>    newReg ;
:iB@    newReg ;
:iB!    endReg ;
:iB+    endReg ;
:iB@+   newReg ;
:iB!+   endReg ;

:iMOVE :iMOVE>
:iCMOVE :iCMOVE>
:iQMOVE :iQMOVE>
	cellA endReg cellC endReg cellDI endReg ;
:iFILL :iCFILL :iQFILL
	cellC endReg cellDI endReg cellSI endReg ;

:iUPDATE :iREDRAW
	;
:iMEM
:iSW :iSH :iFRAMEV
:iXYPEN :iBPEN :iKEY :iCHAR
:iMSEC :iTIME :iDATE
	newReg ;
:iLOAD
	endReg ;
:iSAVE
:iAPPEND
	endReg endReg endReg ;
:iFFIRST
	;
:iFNEXT
	newReg ;

:iSYS
	endReg ;

:i0? cellr gwhilejmp ;
:i1? cellr endREG cellr gwhilejmp ;
:i2? cellr endREG cellr endREG cellr gwhilejmp ;

#vmc
0 0 0 0 0 0 0 idec idec idec idec istr iwor ivar idwor idvar
i; i( i) i[ i] iEX i0? i0? i0? i0? i1? i1? i1? i1? i1? i1? 
i1? i1? i2? iDUP iDROP iOVER iPICK2 iPICK3 iPICK4 iSWAP iNIP iROT i2DUP i2DROP i3DROP i4DROP
i2OVER i2SWAP i>R iR> iR@ iop2a1 iop2a1 iop2a1 iop2a1 iop2a1 iop2a1 i/ i<< i>> i>>> iMOD 
i/MOD i*/ i*>> i<</ iop1a1 iop1a1 iABS iSQRT iCLZ i@ iC@ iQ@ i@+ iC@+ iQ@+ i! 
iC! iQ! i!+ iC!+ iQ!+ i+! iC+! iQ+!
i>A iA> iA@ iA! iA+ iA@+ iA!+
i>B iB> iB@ iB! iB+ iB@+ iB!+
iMOVE iMOVE> iFILL
iCMOVE iCMOVE> iCFILL
iQMOVE iQMOVE> iQFILL
iUPDATE iREDRAW
iMEM iSW iSH iFRAMEV
iXYPEN iBPEN iKEY iCHAR
iMSEC iTIME iDATE
iLOAD iSAVE iAPPEND
iFFIRST iFNEXT
iSYS

::anastep | tok --
	1 'itok +!
	$ff and 2 << 'vmc + @
	1? ( ex ; )
	drop ;

|------------------------------------------
##cntvreg 1

:cused | nro -- used
	2 << 'cellf + @ $800 and ;

:clivei | nro -- live
	2 << 'cellv + @ $3ff and ;

:clivee | nro -- live
	2 << 'cellv + @ 10 >> $3ff and ;

:cellreg | nro -- vreg
	2 << 'cellv + @ 24 >> ;

:cellreg! | vr nro --
	2 << 'cellv + dup @ $ffffff and rot 24 << or swap ! ;

:cellreg? | nro -- n/0
	2 << 'cellf + @ 16 >> $ff and ;

:reuse? | ini act -- ini act vreg/0
	dup cused 1? ( drop 0 ; ) drop
	dup clivee pick2 >? ( drop 0 ; ) drop
	dup ;

:searchend | ini desde -- vreg/0
	( 1? 1 -
      	reuse? 1? ( nip nip 1 + ; ) drop
		) 2drop 0 ;

:marcau
	$800 over 2 << 'cellf + +! ;

:reusa | n reu -- n
	1 - marcau
	cellreg over cellreg!
	;

:needreg | n a -- a
	dup cellreg? 0? ( drop marcau ; ) drop
	dup clivei over searchend
	1? ( reusa ; ) drop
	cntvreg over cellreg!
	1 'cntvreg +!
	;

:calcvreg | --
	1 'cntvreg !
	0 ( ncell <?
		needreg
		1 + ) drop ;

::anaend
    ( NOS 'PSP >? drop
		endREG ) drop
	calcvreg ;

|------------------------------------------
:inlife | end ini nro -- end ini nro 1/0
	dup 2 << 'cellf + @ 16 >> $ff and 0? ( ; ) | no es cte
	drop
	dup 2 << 'cellv + @	| end ini nro val
	dup $3ff and pick4 >? ( 2drop 0 ; ) drop	|empieza despues
	10 >> $3ff and pick2 <? ( drop 0 ; ) drop
	1
	;

|------------------------ info
| flags........
|  $1 in W		| word
|  $2 out W
|  $4 in C		| call
|  $8 out C
| $10 var
| $20 dir var
| $40 dir code
| $80 copia de A
:cflags
	$1 an? ( " >W" ,s )
	$2 an? ( " W>" ,s )
	$4 an? ( " >C" ,s )
	$8 an? ( " C>" ,s )
	$10 an? ( " V" ,s )
	$20 an? ( " 'D" ,s )
	$40 an? ( " 'C" ,s )
	$80 an? ( " CPY" ,s )
	$100 an? ( " EXE" ,s )
	$800 an? ( " U" ,s )

	$1000 an? ( " A" ,s )
	$2000 an? ( " C" ,s )
	$4000 an? ( " SI" ,s )
	$8000 an? ( " DI" ,s )
	drop ;

:cconst
	9 ,c " CTE" ,s
	" R:" ,s dup 24 >> $ff and ,d
	cflags
	over 2 << 'cellf + @
	0? ( drop ; )
	256 <? ( ,sp ,d ; )
	@ "%h" ,sp ,format
	;


:celli | nro --
	2 << 'cellf + @
|	dup 16 >> $ff and
|	0? ( drop cconst ; ) drop
	" R:" ,s dup 24 >> $ff and ,d
	" W:" ,s dup 16 >> $ff and ,d
	cflags
	;

:cellvida | nro --
	2 << 'cellv + @
	dup 10 >> $3ff and
	over $3ff and
	" (%d:%d)" ,format
	24 >> $ff and " %d" ,format
	;

::cellinfo
	"; ---- cells ----" ,s ,cr
	0 ( ncell <?
		"; " ,s dup ,h
		dup celli
		dup cellvida
		,cr
		1 + ) drop ;
