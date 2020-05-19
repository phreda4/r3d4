| generate amd64 code
| OPT 1 GENERATOR
| - The stack is virtual
| PHREDA 2020
|-------------
^./r3base.r3

#stbl * 40 | 10 niveles ** falta inicializar si hay varias ejecuciones
#stbl> 'stbl

#nblock 0

:pushbl | -- block
	nblock
	dup 1 + 'nblock !
	dup stbl> !+ 'stbl> ! ;

:popbl | -- block
	-4 'stbl> +! stbl> @ ;

|--- @@
::getval | a -- a v
	dup 4 - @ 8 >>> ;

::getsrcnro
	dup ?numero 1? ( drop nip nip ; ) drop
	str>fnro nip
	;

::getcte | a -- a v
	dup 4 - @ 8 >>> src + getsrcnro ;

::getcte2 | a -- a v
	dup 4 - @ 8 >>> 'ctecode + q@ ;

|--- END
:g;
	dup 8 - @ $ff and
	12 =? ( drop ; ) | tail call  call..ret?
	21 =? ( drop ; ) | tail call  EX
	drop
	"ret" ,ln ;

|--- IF/WHILE

::getiw | v -- iw
    3 << blok + @ $10000000 and ;

:g(
	getval getiw 0? ( pushbl 2drop ; ) drop
	pushbl
	"_i%h:" ,print ,cr ;		| while

:g)
	getval getiw
	popbl swap
	1? ( over "jmp _i%h" ,print ,cr ) drop	| while
	"_o%h:" ,print ,cr ;

:?? | -- nblock
	getval getiw
	0? ( drop nblock ; ) drop stbl> 4 - @ ;

|---
:g[
	pushbl
	dup "jmp ja%h" ,print ,cr
	"anon%h:" ,print ,cr
	;
:g]
	popbl
	dup "ja%h:" ,print ,cr
	PUSH.ANO
|	,DUP
|	"mov rax,anon%h" ,print ,cr
	;

:gEX
	"mov rcx,#0" ,ln
	.DROP
	| normalize
	dup @ $ff and
	16 <>? ( drop "call rcx" ,ln ; ) drop
	"jmp rcx" ,ln ;

:g0?
	"or #0,#0" ,asm
	?? "jnz _o%h" ,print ,cr ;

:g1?
	"or #0,#0" ,asm
	?? "jz _o%h" ,print ,cr ;

:g+?
	"or #0,#0" ,asm
	?? "js _o%h" ,print ,cr ;

:g-?
	"or #0,#0" ,asm
	?? "jns _o%h" ,print ,cr ;

:g<?
	"cmp #1,#0" ,asm
	.drop
	?? "jge _o%h" ,print ,cr ;

:g>?
	"cmp #1,#0" ,asm
	.drop
	?? "jle _o%h" ,print ,cr ;

:g=?
	"cmp #1,#0" ,asm
	.drop
	?? "jne _o%h" ,print ,cr ;

:g>=?
	"cmp #1,#0" ,asm
	.drop
	?? "jl _o%h" ,print ,cr ;

:g<=?
	"cmp #1,#0" ,asm
	.drop
	?? "jg _o%h" ,print ,cr ;

:g<>?
	"cmp #1,#0" ,asm
	.drop
	?? "je _o%h" ,print ,cr ;

:gA?
	"test #1,#0" ,asm
	.drop
	?? "jz _o%h" ,print ,cr ;

:gN?
	"test #1,#0" ,asm
	.drop
	?? "jnz _o%h" ,print ,cr ;

:gB?
	"sub rbp,8*2" ,ln
	"mov rbx,[rbp+8]" ,ln
	"xchg rax,rbx" ,ln
	"cmp rax,[rbp+8*2]" ,ln
	?? "jge _o%h" ,print ,cr
	"cmp rax,rbx"
	?? "jle _o%h" ,print ,cr
	;

:g>R
	"push #0" ,asm 
	.drop ;

:gR>
	.dupnew 
	"pop #0" ,asm ;

:gR@
	.dupnew 
	"mov #0,[rsp]" ,asm ;


:gAND
	| regNOS
	"and #1,#0" ,asm
	.drop ;

:gOR
	| regNOS
	"or #1,#0" ,asm
	.drop ;

:gXOR
	| regNOS
	"xor #1,#0" ,asm
	.drop ;

:gNOT
	"not #0" ,asm ;

:gNEG
	"neg #0" ,asm ;

:g+
	| regNOS
	"add #1,#0" ,asm
	.drop ;

:g-
	| regNOS
	"sub #1,#0" ,asm
	.drop ;

:g*
	| regNOS
	"imul #1,#0" ,asm
	.drop ;

:g/
	"mov rbx,rax" ,ln
|	,drop
	"cqo;idiv #0" ,asm
	.drop
	;

:g*/
	"mov rbx,rax" ,ln
	"mov rcx,[rbp]" ,ln
|	,2drop
	"cqo" ,ln
	"imul rcx" ,ln
	"idiv rbx" ,ln 	;

:g/MOD
	"mov rbx,rax" ,ln
	"mov rax,[rbp]" ,ln
	"cqo" ,ln
	"idiv rbx" ,ln
	"mov [rbp],rax" ,ln
	"xchg rax,rdx" ,ln 	;

:gMOD
	"mov rbx,rax" ,ln
|	,drop
	"cqo" ,ln
	"idiv rbx" ,ln
	"mov rax,rdx" ,ln ;

:gABS
	"cqo" ,ln
	"add rax,rdx" ,ln
	"xor rax,rdx" ,ln ;

:gSQRT
	"cvtsi2sd xmm0,#0;sqrtsd xmm0,xmm0;cvtsd2si #0,xmm0" ,asm ;

:gCLZ
	"bsr #0,#0;xor #0,63" ,asm ;

:g<<
	"shl #1,$0" ,asm
	.drop ;
|	"mov cl,al" ,ln
|	,drop "shl rax,cl" ,ln ;

:g>>
	"sar #1,$0" ,asm
	.drop ;
|	"mov cl,al" ,ln ,drop
|	"sar rax,cl" ,ln ;

:g>>>
	"shr #1,$0" ,asm
	.drop ;
|	"mov cl,al" ,ln
|	,drop
|	"shr rax,cl" ,ln ;

|---------------
:changeC | nreg 'cell -- nreg
	dup @ $205 <>? ( 2drop ; ) drop
	over swap ! ;

:CisUsed
	newreg dup setreg
	dup push.reg
	"mov #0,#1;xchg rcx,#0" ,asm
	8 << 5 or 'changeC stackmap-2
	drop
	.drop
	$205 'TOS ! ;

:CVinTOS | RCX or value in TOS
	TOS
	$205 =? ( drop ; )		| is RCX
	$ff and 0? ( drop ; )	| is value
	drop
	maskreg %100 an? ( drop CisUsed ; ) drop
	"mov rcx,#0" ,asm
	$205 'TOS !
	;

|---------------
:RinNOS | any reg in NOS
	NOS @ $ff and 5 =? ( drop ; ) drop
	newreg dup setreg
	8 << 5 or
	"mov " ,s dup ,cell ",#1" ,asm
	NOS !
	;

|---------------
:changeA | nreg 'cell -- nreg
	dup @ $005 <>? ( 2drop ; ) drop
	over swap ! ;

:AisUsed
	newreg dup setreg
	dup push.reg
	"mov #0,#3;xchg rax,#0" ,asm
	.drop
	8 << 5 or 'changeA stackmap-2 drop
	$005 NOS 4 - !
	;

:AinDPK2
	NOS 4 - @ $005 =? ( drop ; ) drop
	maskreg %1 an? ( drop AisUsed ; ) drop
	"mov rax,#2" ,asm
	5 NOS 4 - !
	;

|---------------
:changeA | nreg 'cell -- nreg
	dup @ $005 <>? ( 2drop ; ) drop
	over swap ! ;

:setA.RM.CC
	cell.fillreg
	cell.freeACD

	CVinTOS
	RinNOS
	AinDPK2
	freeD

	newreg
	cell.fillreg2
	maskreg 1 na? ( 2drop ; ) drop
	"mov " ,s 8 << 5 or dup ,cell  ",rax" ,ln
	'changeA stackmap-2 | nreg
	drop
	;

:g*>>
	setA.RM.CC
	"cqo;imul #1;shrd rax,rdx,$0" ,asm
    .2drop
	DTOS cellA!
	;

:g<</
	setA.RM.CC
    "cqo;shld rdx,rax,$0;shl rax,$0;idiv #1" ,asm
	.2drop
	DTOS cellA!
	;

:g@
	"movsxd #0,dword[#0]" ,asm ;

:gC@
	"movsx #0,byte[#0]" ,asm ;

:gQ@
	"mov #0,qword[#0]" ,asm ;

:g@+
	.dupnew
	"movsxd #0,dword[#1];add #1,4" ,asm ;

:gC@+
	.dupnew
	"movsx #0,byte[#1];add #1,1" ,asm ;

:gQ@+
	.dupnew
	"mov #0,[#1];add #1,8" ,asm ;

:g!
	"mov dword[#0],*1" ,asm
	.2DROP ;

:gC!
	"mov byte[#0],$1" ,asm
	.2DROP ;

:gQ!
	"mov [#0],#1" ,asm
	.2DROP ;

:g!+
	"mov dword[#0],*1;add #0,4" ,asm
	.NIP ;

:gC!+
	"mov byte[#0],$1;add #0,1" ,asm
	.NIP ;

:gQ!+
	"mov [#0],#1;add #0,8" ,asm
	.NIP ;

:g+!
	"add dword[#0],*1" ,asm
	.2DROP ;

:gC+!
	"add byte[#0],$1" ,asm
	.2DROP ;

:gQ+!
	"add [#0],#1" ,asm
	.2DROP ;

:g>A
	"mov rsi,#0" ,asm
	.drop ;

:gA>
	.dupnew
	 "mov #0,rsi" ,asm ;

:gA@
	.dupnew
	"movsxd #0,dword[rsi]" ,asm ;

:gA!
	"mov dword[rsi],#0" ,asm
	.drop ;

:gA+
	"add rsi,#0" ,asm 
	.drop ;

:gA@+
	.dupnew 
	"movsxd #0,dword[rsi];add rsi,4" ,asm ;

:gA!+
	"mov dword[rsi],*0;add rsi,4" ,asm 
	.drop ;

:g>B
	"mov rdi,#0" ,asm
	.drop ;

:gB>
	.dupnew 
	"mov #0,rdi" ,asm ;

:gB@
	.dupnew
	"movsxd #0,dword[rdi]" ,asm ;

:gB!
	"mov dword[rdi],#0" ,asm
	.drop ;

:gB+
	"add rdi,#0" ,asm
	.drop ;

:gB@+
	.dupnew
	"movsxd #0,dword[rdi];add rdi,4" ,asm ;

:gB!+
	"mov dword[rdi],*0;add rdi,4" ,asm
	.drop ;

:gMOVE
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep movsd" ,ln
	.3DROP ;

:gMOVE>
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"lea rsi,[rsi+rcx*4-4]" ,ln
	"lea rdi,[rdi+rcx*4-4]" ,ln
	"std" ,ln
	"rep movsd" ,ln
	"cld" ,ln
	.3DROP ;

:gFILL
	"mov rcx,rax" ,ln
	"movsxd rax,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep stosd" ,ln
	.3DROP ;

:gCMOVE
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep movsb" ,ln
	.3DROP ;

:gCMOVE>
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"lea rsi,[rsi+rcx-1]" ,ln
	"lea rdi,[rdi+rcx-1]" ,ln
	"std" ,ln
	"rep movsb" ,ln
	"cld" ,ln
	.3DROP ;

:gCFILL
	"mov rcx,rax" ,ln
	"movsxd rax,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep stosb" ,ln
	.3DROP ;

:gQMOVE
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep movsq" ,ln
	.3DROP ;

:gQMOVE>
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"lea rsi,[rsi+rcx*8-8]" ,ln
	"lea rdi,[rdi+rcx*8-8]" ,ln
	"std" ,ln
	"rep movsq" ,ln
	"cld" ,ln
	.3DROP ;

:gQFILL
	"mov rcx,rax" ,ln
	"movsxd rax,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep stosq" ,ln
	.3DROP ;


:gMEM
	0 push.ctem ;
:gSW
	0 push.cte ;
:gSH
	1 push.cte ;
:gFRAMEV
	1 push.ctem ;
:gXYPEN
	2 push.ctem 3 push.ctem ;
:gBPEN
	4 push.ctem ;
:gKEY
	5 push.ctem ;
:gCHAR
	6 push.ctem ;
:gUPDATE
	"call SYSREDRAW" ,ln ;
:gREDRAW
	"call SYSUPDATE" ,ln ;
:gMSEC
	"call SYSMSEC" ,ln ;
:gTIME
	"call SYSTIME" ,ln ;
:gDATE
	"call SYSDATE" ,ln ;
:gLOAD
	"call SYSLOAD" ,ln ;
:gSAVE
	"call SYSSAVE" ,ln ;
:gAPPEND
	"call SYSAPPEND" ,ln ;
:gFFIRST
	"call SYSFFIRST" ,ln ;
:gFNEXT
	"call SYSFNEXT" ,ln ;
:gSYS
	"call SYSYSTEM" ,ln ;

|----------- Number
:gdec
	getcte PUSH.NRO ;

|----------- Calculate Number
:ghex  | really constant folding number
	getcte2 PUSH.NRO ;

|----------- adress string
:gstr
	dup 4 - @ 8 >>> PUSH.STR ;

|----------- adress word
:gdwor
	getval PUSH.WRD ; |--	'word

|----------- adress var
:gdvar
	getval PUSH.WRD ; |--	'var

|----------- var
:gvar
	getval PUSH.VAR ; |--	[var]

|----------- call word
:gwor
	| stack normalize
	dup @ $ff and
	16 =? ( drop getval "jmp w%h" ,print ,cr ; ) drop | ret?
	getval "call w%h" ,print ,cr ;

|-----------------------------------------
#vmc
0 0 0 0 0 0 0 gdec ghex gdec gdec gstr gwor gvar gdwor gdvar
g; g( g) g[ g] gEX g0? g1? g+? g-? g<? g>? g=? g>=? g<=? g<>?
gA? gN? gB? .DUP .DROP .OVER .PICK2 .PICK3 .PICK4 .SWAP .NIP .ROT .2DUP .2DROP .3DROP .4DROP
.2OVER .2SWAP g>R gR> gR@ gAND gOR gXOR g+ g- g* g/ g<< g>> g>>> gMOD
g/MOD g*/ g*>> g<</ gNOT gNEG gABS gSQRT gCLZ g@ gC@ gQ@ g@+ gC@+ gQ@+ g!
gC! gQ! g!+ gC!+ gQ!+ g+! gC+! gQ+! g>A gA> gA@ gA! gA+ gA@+ gA!+ g>B
gB> gB@ gB! gB+ gB@+ gB!+ gMOVE gMOVE> gFILL gCMOVE gCMOVE> gCFILL gQMOVE gQMOVE> gQFILL gUPDATE
gREDRAW gMEM gSW gSH gFRAMEV gXYPEN gBPEN gKEY gCHAR gMSEC gTIME gDATE gLOAD gSAVE gAPPEND gFFIRST
gFNEXT gSYS

:ctetoken
	8 >>> 'ctecode + q@ "$" ,s ,h ;

::,tokenprinto
	dup dup $ff and 8 =? ( drop ctetoken ; ) drop
	,tokenprint ;

:codestep | token --
	"; " ,s ,tokenprinto 9 ,c ,printstk ,cr
|	"asm/code.asm" savemem
	$ff and 2 << 'vmc + @ ex ;


::genasmcode | duse --
	0? ( 1 + ) | if empty, add TOS for not forget!!
	stk.start
	'bcode ( bcode> <?
		@+
		codestep
		) drop ;