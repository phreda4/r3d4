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

#lastdircode 0 | ultima direccion de codigo

:codtok	dup 'lastdircode ! ;

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
	stk.normal
	"ret" ,ln ;

|--- IF/WHILE

::getiw | v -- iw
    3 << blok + @ $10000000 and ;

:g(
	stk.resolve
	stk.push
	getval getiw 0? ( pushbl 2drop ; ) drop
	pushbl
	"_i%h:" ,print ,cr ;		| while

:g)
	dup 8 - @ $ff and
	16 <>? ( stk.conv ) | tail call  call..ret?
	drop

	stk.pop
	getval getiw
	popbl swap
	1? ( over "jmp _i%h" ,print ,cr ) drop	| while
	"_o%h:" ,print ,cr ;

:?? | -- nblock
	getval getiw
	0? ( drop nblock ; ) drop
	stk.drop stk.push
	stbl> 4 - @ ;

|---
:g[		|  this disapear when pre process the word
	pushbl
	dup "jmp ja%h" ,print ,cr
	"anon%h:" ,print ,cr
	;
:g]		|  this disapear when pre process the word
	popbl
	dup "ja%h:" ,print ,cr
	push.ano
	;

:gEX
	'TOS cellR
	"mov rcx,#0" ,asm .drop
	stk.normal	| normalize

   	lastdircode dic>du drop stk.2normal | exit stack calc

	dup @ $ff and
	16 <>? ( drop "call rcx" ,ln ; ) drop
	"jmp rcx" ,ln ;

:g0?
	'TOS cellR
	"or #0,#0" ,asm
	?? "jnz _o%h" ,print ,cr ;

:g1?
	'TOS cellR
	"or #0,#0" ,asm
	?? "jz _o%h" ,print ,cr ;

:g+?
	'TOS cellR
	"or #0,#0" ,asm
	?? "js _o%h" ,print ,cr ;

:g-?
	'TOS cellR
	"or #0,#0" ,asm
	?? "jns _o%h" ,print ,cr ;

:g<?
	'TOS cellA
	NOS cellR
	"cmp #1,#0" ,asm
	.drop
	?? "jge _o%h" ,print ,cr ;

:g>?
	'TOS cellA
	NOS cellR
	"cmp #1,#0" ,asm
	.drop
	?? "jle _o%h" ,print ,cr ;

:g=?
	'TOS cellA
	NOS cellR
	"cmp #1,#0" ,asm
	.drop
	?? "jne _o%h" ,print ,cr ;

:g>=?
	'TOS cellA
	NOS cellR
	"cmp #1,#0" ,asm
	.drop
	?? "jl _o%h" ,print ,cr ;

:g<=?
	'TOS cellA
	NOS cellR
	"cmp #1,#0" ,asm
	.drop
	?? "jg _o%h" ,print ,cr ;

:g<>?
	'TOS cellA
	NOS cellR
	"cmp #1,#0" ,asm
	.drop
	?? "je _o%h" ,print ,cr ;

:gA?
	'TOS cellA
	NOS cellR
	"test #1,#0" ,asm
	.drop
	?? "jz _o%h" ,print ,cr ;

:gN?
	'TOS cellA
	NOS cellR
	"test #1,#0" ,asm
	.drop
	?? "jnz _o%h" ,print ,cr ;

:gB?
	NOS 4 - cellR
	NOS cellA
	TOS cellA
	"cmp #2,#0" ,asm
	?? "jge _o%h" ,print ,cr
	"cmp #2,#1" ,asm
	?? "jle _o%h" ,print ,cr
	.2drop ;

:g>R
	"push #0" ,asm .drop ;

:gR>
	.dupnew
	"pop #0" ,asm ;

:gR@
	.dupnew
	"mov #0,[rsp]" ,asm ;


:gAND
	NOS cellR
	'TOS cellA
	"and #1,#0" ,asm .drop ;

:gOR
	NOS cellR
	'TOS cellA
	"or #1,#0" ,asm .drop ;

:gXOR
	NOS cellR
	'TOS cellA
	"xor #1,#0" ,asm .drop ;

:gNOT
	'TOS cellR
	"not #0" ,asm ;

:gNEG
	'TOS cellR
	"neg #0" ,asm ;

:g+
	NOS cellR
	'TOS cellA
	"add #1,#0" ,asm .drop ;

:g-
	NOS cellR
	'TOS cellA
	"sub #1,#0" ,asm .drop ;

:g*
	NOS cellR
	'TOS cellA
	"imul #1,#0" ,asm .drop ;

:g/
	stk.AR
	"cqo;idiv #0" ,asm .drop ;

:g*/
	stk.ARR
	"cqo;imul #1;idiv #0" ,asm .2drop ;

:g/MOD
	stk.AR
	"cqo;idiv #0" ,asm
	;

:gMOD
	stk.AR
	"cqo;idiv #0" ,asm .drop
	;

:gABS
	'TOS cellR freeD
	"mov rdx,#0;sar rdx,63;add #0,rdx;xor #0,rdx" ,asm ;

:gSQRT
	'TOS cellR
	"cvtsi2sd xmm0,#0;sqrtsd xmm0,xmm0;cvtsd2si #0,xmm0" ,asm ;

:gCLZ
	'TOS cellR
	"bsr #0,#0;xor #0,63" ,asm ;

:g<<
	stk.RC
	"shl #1,$0" ,asm .drop ;

:g>>
	stk.RC
	"sar #1,$0" ,asm .drop ;

:g>>>
	stk.RC
	"shr #1,$0" ,asm .drop ;

:v*>>
	"cqo;imul #1" ,asm
	vTOS
	64 <? ( drop "shrd rax,rdx,$0" ,asm .2drop ; )
	64 >? ( "sar rdx," ,s dup 64 - ,d ,cr )
	drop
	"mov rax,rdx" ,ln
	.2drop ;

:g*>>
	stk.ARC2RAC
	TOS $ff and 0? ( drop v*>> ; ) drop
	"cqo;imul #1;shrd rax,rdx,$0" ,asm
    .2drop ;

:g<</
	stk.ARC
    "cqo;shld rdx,rax,$0;shl rax,$0;idiv #1" ,asm
	.2drop
	;

:g@
	'TOS cellI
	"movsxd #0,dword[#0]" ,asm ;

:gC@
	'TOS cellI
	"movsx #0,byte[#0]" ,asm ;

:gQ@
	'TOS cellI
	"mov #0,qword[#0]" ,asm ;

:g@+
	'TOS cellR
	.dupnew
	"movsxd #0,dword[#1];add #1,4" ,asm ;

:gC@+
	'TOS cellR
	.dupnew
	"movsx #0,byte[#1];add #1,1" ,asm ;

:gQ@+
	'TOS cellR
	.dupnew
	"mov #0,[#1];add #1,8" ,asm ;

:g!
	'TOS cellI
	NOS cellI
	"mov dword[#0],*1" ,asm
	.2DROP ;

:gC!
	'TOS cellI
	NOS cellI
	"mov byte[#0],$1" ,asm .2DROP ;

:gQ!
	'TOS cellI
	NOS cellI
	"mov [#0],#1" ,asm .2DROP ;

:g!+
	stk.GR
	"mov dword[#0],*1;add #0,4" ,asm .NIP ;

:gC!+
	stk.GR
	"mov byte[#0],$1;add #0,1" ,asm .NIP ;

:gQ!+
	stk.GR
	"mov [#0],#1;add #0,8" ,asm .NIP ;

:g+!
	stk.GR
	"add dword[#0],*1" ,asm .2DROP ;

:gC+!
	stk.GR
	"add byte[#0],$1" ,asm .2DROP ;

:gQ+!
	stk.GR
	"add [#0],#1" ,asm .2DROP ;

:g>A
	"mov rsi,#0" ,asm .drop ;

:gA>
	.dupnew
	 "mov #0,rsi" ,asm ;

:gA@
	.dupnew
	"movsxd #0,dword[rsi]" ,asm ;

:gA!
	stk.G
	"mov dword[rsi],*0" ,asm .drop ;

:gA+
	stk.G
	"add rsi,#0" ,asm .drop ;

:gA@+
	.dupnew
	"movsxd #0,dword[rsi];add rsi,4" ,asm ;

:gA!+
	stk.G
	"mov dword[rsi],*0;add rsi,4" ,asm .drop ;

:g>B
	"mov rdi,#0" ,asm .drop ;

:gB>
	.dupnew
	"mov #0,rdi" ,asm ;

:gB@
	.dupnew
	"movsxd #0,dword[rdi]" ,asm ;

:gB!
	stk.G
	"mov dword[rdi],*0" ,asm .drop ;

:gB+
	stk.G
	"add rdi,#0" ,asm .drop ;

:gB@+
	.dupnew
	"movsxd #0,dword[rdi];add rdi,4" ,asm ;

:gB!+
	stk.G
	"mov dword[rdi],*0;add rdi,4" ,asm .drop ;

:gMOVE
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
|.................... RDI RSI RCX
	"rep movsd" ,ln
	.3DROP ;

:gMOVE>
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
|.................... RDI RSI RCX
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
|.................... RDI RAX RCX
	"rep stosd" ,ln
	.3DROP ;

:gCMOVE
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
|.................... RDI RSI RCX
	"rep movsb" ,ln
	.3DROP ;

:gCMOVE>
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
|.................... RDI RSI RCX
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
|.................... RDI RAX RCX
	"rep stosb" ,ln
	.3DROP ;

:gQMOVE
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
|.................... RDI RSI RCX
	"rep movsq" ,ln
	.3DROP ;

:gQMOVE>
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
|.................... RDI RSI RCX
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
|.................... RDI RAX RCX
	"rep stosq" ,ln
	.3DROP ;


:gMEM
	0 PUSH.CTEM ;
:gSW
	0 push.cte ;
:gSH
	1 push.cte ;
:gFRAMEV
	1 PUSH.CTEM ;
:gXYPEN
	2 PUSH.CTEM
	3 PUSH.CTEM
	;
:gBPEN
	4 PUSH.CTEM
	;
:gKEY
	5 PUSH.CTEM
	.dupnew "mov *0,#1" ,asm .nip ;
:gCHAR
	6 PUSH.CTEM
	.dupnew "mov *0,#1" ,asm .nip ;
:gUPDATE
	"call SYSREDRAW" ,ln ;
:gREDRAW
	"call SYSUPDATE" ,ln ;
:gMSEC
|	"call SYSMSEC" ,ln

	%101 stk.freereg  | rax rcx need free
	"invoke GetTickCount" ,asm
	0 push.reg | rax is the result
	;
:gTIME
	%101 stk.freereg | rax rcx need free
	"call SYSTIME" ,ln
	0 push.reg | rax is the result
	;
:gDATE
	%101 stk.freereg | rax rcx need free
	"call SYSDATE" ,ln
	0 push.reg | rax is the result
	;
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
:gSLOAD
	"call SYSSLOAD" ,ln ;
:gSFREE
	"call SYSSFREE" ,ln ;
:gSPLAY
	"call SYSSPLAY" ,ln ;
:gMLOAD
	"call SYSMLOAD" ,ln ;
:gMFREE
	"call SYSMFREE" ,ln ;
:gMPLAY
	"call SYSMPLAY" ,ln ;

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
	getval codtok PUSH.WRD ;	|--	'word

|----------- adress var
:gdvar
	getval codtok PUSH.WRD ;	|--	'var

|----------- var
:gvar
    getval codtok PUSH.VAR		|--	[var]
	.dupnew "mov *0,#1" ,asm .nip ;

|----------- call word
:gwor
	stk.normal
	dup @ $ff and
	16 =? ( drop getval "jmp w%h" ,print ,cr ; ) drop | ret?
	getval
	dup "call w%h" ,print ,cr
	dic>du drop stk.2normal | exit stack calc
	;

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
gSLOAD gSFREE gSPLAY
gMLOAD gMFREE gMPLAY


:ctetoken
	8 >>> 'ctecode + q@ "$" ,s ,h ;

::,tokenprinto
	dup dup $ff and 8 =? ( drop ctetoken ; ) drop
	,tokenprint ;

:codestep | token --
	"; " ,s ,tokenprinto 9 ,c ,printstk ,cr
|	"asm/code.asm" savememinc
	$ff and 2 << 'vmc + @ ex ;


::genasmcode | duse --
|	0? ( 1 + ) | if empty, add TOS for not forget!!
	1 +
	stk.start
	'bcode ( bcode> <?
		@+ codestep ) drop ;
