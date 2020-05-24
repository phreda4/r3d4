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
	stk.normal
	"ret" ,ln ;

|--- IF/WHILE

::getiw | v -- iw
    3 << blok + @ $10000000 and ;

:g(
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
:g[
	pushbl
	dup "jmp ja%h" ,print ,cr
	"anon%h:" ,print ,cr
	;
:g]
	popbl
	dup "ja%h:" ,print ,cr
	PUSH.ANO
	;

:gEX
	"mov rcx,#0" ,asm .drop
	stk.normal	| normalize
	dup @ $ff and
	16 <>? ( drop "call rcx" ,ln ; ) drop
	"jmp rcx" ,ln ;

:g0?
	stk.R
	"or #0,#0" ,asm
	?? "jnz _o%h" ,print ,cr ;

:g1?
	stk.R
	"or #0,#0" ,asm
	?? "jz _o%h" ,print ,cr ;

:g+?
	stk.R
	"or #0,#0" ,asm
	?? "js _o%h" ,print ,cr ;

:g-?
	stk.R
	"or #0,#0" ,asm
	?? "jns _o%h" ,print ,cr ;

:g<?
	stk.RG
	"cmp #1,#0" ,asm
	.drop
	?? "jge _o%h" ,print ,cr ;

:g>?
	stk.RG
	"cmp #1,#0" ,asm
	.drop
	?? "jle _o%h" ,print ,cr ;

:g=?
	stk.RG
	"cmp #1,#0" ,asm
	.drop
	?? "jne _o%h" ,print ,cr ;

:g>=?
	stk.RG
	"cmp #1,#0" ,asm
	.drop
	?? "jl _o%h" ,print ,cr ;

:g<=?
	stk.RG
	"cmp #1,#0" ,asm
	.drop
	?? "jg _o%h" ,print ,cr ;

:g<>?
	stk.RG
	"cmp #1,#0" ,asm
	.drop
	?? "je _o%h" ,print ,cr ;

:gA?
	stk.RG
	"test #1,#0" ,asm
	.drop
	?? "jz _o%h" ,print ,cr ;

:gN?
	stk.RG
	"test #1,#0" ,asm
	.drop
	?? "jnz _o%h" ,print ,cr ;

:gB?
	stk.RGG
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
	stk.RG
	"and #1,#0" ,asm .drop ;

:gOR
	stk.RG
	"or #1,#0" ,asm .drop ;

:gXOR
	stk.RG
	"xor #1,#0" ,asm .drop ;

:gNOT
	stk.R
	"not #0" ,asm ;

:gNEG
	stk.R
	"neg #0" ,asm ;

:g+
	stk.RG
	"add #1,#0" ,asm .drop ;

:g-
	stk.RG
	"sub #1,#0" ,asm .drop ;

:g*
	stk.RG
	"imul #1,#0" ,asm .drop ;

:g/
	stk.AR freeD
	"cqo;idiv #0" ,asm .drop ;

:g*/
	stk.AGR freeD
	"cqo;imul #1;idiv #0" ,asm .2drop ;

:g/MOD
	stk.AR freeD
	"cqo;idiv #0" ,asm

	;

:gMOD
	stk.AR freeD
	"cqo;idiv #0" ,asm .drop
	;

:gABS
	stk.R freeD
	"mov rdx,#0;sar rdx,63;add #0,rdx;xor #0,rdx" ,asm ;

:gSQRT
	stk.R
	"cvtsi2sd xmm0,#0;sqrtsd xmm0,xmm0;cvtsd2si #0,xmm0" ,asm ;

:gCLZ
	stk.R
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

:g*>>
	stk.AGC freeD
	"cqo;imul #1;shrd rax,rdx,$0" ,asm
    .2drop ;

:g<</
	stk.ARC freeD
    "cqo;shld rdx,rax,$0;shl rax,$0;idiv #1" ,asm
	.2drop
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
	stk.GG
	"mov dword[#0],*1" ,asm
	.2DROP ;

:gC!
	stk.GG
	"mov byte[#0],$1" ,asm .2DROP ;

:gQ!
	stk.GG
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
	stk.GG
	"add dword[#0],*1" ,asm .2DROP ;

:gC+!
	stk.GG
	"add byte[#0],$1" ,asm .2DROP ;

:gQ+!
	stk.GG
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
	getval PUSH.WRD ;	|--	'word

|----------- adress var
:gdvar
	getval PUSH.WRD ;	|--	'var

|----------- var
:gvar
    getval PUSH.VAR		|--	[var]
	.dupnew
	"mov #0,#1" ,asm
	.nip ;

|----------- call word
:gwor
	stk.normal
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
|	0? ( 1 + ) | if empty, add TOS for not forget!!
	1 +
	stk.start
	'bcode ( bcode> <?
		@+
		codestep
 "asm/code.asm" savemem
		) drop ;