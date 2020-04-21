| generate amd64 code
| BASIC GENERATOR
| PHREDA 2020
|-------------
^./r3base.r3
^./r3stack.r3
^./r3cellana.r3

#lastdircode 0 | ultima direccion de codigo

|--- @@
::getval | a -- a v
	dup 4 - @ 8 >>> ;

::getiw | v -- v iw
    dup 3 << blok + @ $10000000 and ;

::getsrcnro
	dup ?numero 1? ( drop nip nip ; ) drop
	?fnumero 1? ( drop nip ; ) drop
	"error" slog ;

::getcte | a -- a v
	dup 4 - @ 8 >>> src + getsrcnro ;

::getcte2 | a -- a v
	dup 4 - @ 8 >>> 'ctecode + @	;

|--------------------------
:,DUP
	"lea rbp,[rbp+8]" ,ln
	"mov [rbp],rax" ,ln ;
:,DROP
	"mov rax,[rbp]" ,ln
	"lea rbp,[rbp-8]" ,ln ;
:,NIP
	"lea rbp,[rbp-8]" ,ln ;
:,2DROP
	"mov rax,[rbp-8]" ,ln
	"lea rbp,[rbp-8*2]" ,ln ;
:,3DROP
	"mov rax,[rbp-8]" ,ln
	"lea rbp,[rbp-8*3]" ,ln ;
:,4DROP
	"mov rax,[rbp-8*3]" ,ln
	"lea rbp,[rbp-8*4]" ,ln ;

:,OVER
	,DUP "mov rax,[rbp-8]" ,ln ;
:,PICK2
	,DUP "mov rax,[rbp-8*2]" ,ln ;
:,PICK3
	,DUP "mov rax,[rbp-8*3]" ,ln ;
:,PICK4
	,DUP "mov rax,[rbp-8*4]" ,ln ;
:,SWAP
	"xchg rax,[rbp]" ,ln ;
:,ROT
	"mov rdx,[rbp]" ,ln
	"mov [rbp],rax" ,ln
	"mov rax,[rbp-8]" ,ln
	"mov [rbp-8],rdx" ,ln ;
:,2DUP
	"mov rdx,[rbp]" ,ln
	"mov [rbp+8],rax" ,ln
	"mov [rbp+8*2],rdx" ,ln
	"lea rbp,[rbp+8*2]" ,ln ;
:,2OVER
	"mov [rbp+8],rax" ,ln
	"lea rbp,[rbp+8*2]" ,ln
	"pushd [rbp-8*4]" ,ln
	"popd [rbp]" ,ln
	"mov rax,[rbp-8*3]" ,ln ;
:,2SWAP
	"pushd [rbp-8]" ,ln
	"mov [rbp-8],rax" ,ln
	"pushd [rbp-8*2]" ,ln
	"mov rax,[rbp]" ,ln
	"mov [rbp-8*2],rax" ,ln
	"popd [rbp]" ,ln
	"pop rax" ,ln ;

|----------------------
:g0 :g: :g:: :g# :g: :g| :g^    ;

:gdec
	,DUP
	getcte "mov rax,$%h" ,format ,cr
	 ;

:ghex
	,DUP
	getcte2 "mov rax,$%h" ,format ,cr
	 ;


:gstr
	,DUP
	getval "mov rax,STR%h" ,format ,cr
	;

:gdwor
	,DUP
	getval
	dup 'lastdircode !
	push.wrd
	 ;

:gdvar
	,DUP
	getval
	push.wrd
	 ;

:gvar
	,DUP
	getval
	push.var
	 ;

:gwor
	dup @ $ff and
	16 =? ( drop getval "jmp w%h" ,format ,cr ; ) drop | ret?
	getval
	dup "call w%h" ,format ,cr
	;


:g;
	dup 8 - @ $ff and
	12 =? ( drop ; ) | tail call  call..ret?
	drop
	"ret" ,ln
	;

|--- IF
:g(
	getval
	getiw 0? ( 2drop ; ) drop
	"_i%h:" ,format ,cr ;		| while

:g)
	getval
	getiw 1? ( over "jmp _i%h" ,format ,cr ) drop	| while
	"_o%h:" ,format ,cr
	;

:gwhilejmp
	getval getiw
	2drop
	;

|--- REP
:g[
:g]
	;

:gEX
	"mov rcx,rax" ,ln
	,DROP
	over @ $ff and
	16 <>? ( drop "call rcx" ,asm ; ) drop
	"jmp rcx" ,asm ;

:g0?
	gwhilejmp
	'TOS needREG
	"or #0,#0" ,asm
	getval "jnz _o%h" ,format ,cr
	;

:g1?
	gwhilejmp
	'TOS needREG
	"or #0,#0" ,asm
	getval "jz _o%h" ,format ,cr
	;

:g+?
	gwhilejmp
	'TOS needREG
	"or #0,#0" ,asm
	getval "js _o%h" ,format ,cr
	;

:g-?
	gwhilejmp
	'TOS needREG
	"or #0,#0" ,asm
	getval "jns _o%h" ,format ,cr
	;

:g<?
	"cmp #1,#0" ,asm
	.drop
	gwhilejmp
	getval "jge _o%h" ,format ,cr
	;

:g>?
	"cmp #1,#0" ,asm
	.drop
	gwhilejmp
	getval "jle _o%h" ,format ,cr
	;

:g=?
	"cmp #1,#0" ,asm
	.drop
	gwhilejmp
	getval "jne _o%h" ,format ,cr
	;

:g>=?
	"cmp #1,#0" ,asm
	.drop
	gwhilejmp
	getval "jl _o%h" ,format ,cr
	;

:g<=?
	"cmp #1,#0" ,asm
	.drop
	gwhilejmp
	getval "jg _o%h" ,format ,cr
	;

:g<>?
	"cmp #1,#0" ,asm
	.drop
	gwhilejmp
	getval "je _o%h" ,format ,cr
	;

:gA?
	"test #1,#0" ,asm
	.drop
	gwhilejmp
	getval "jnz _o%h" ,format ,cr
	;

:gN?
	"test #1,#0" ,asm
	.drop
	gwhilejmp
	getval "jz _o%h" ,format ,cr
	;

:gB?
	| sub nos2,nos
	| cmp nos,tos-nos
	"cmp #2,#1" ,asm
	.2drop
	gwhilejmp
	getval "jge _o%h" ,format ,cr
	;

:g>R
	"push rax" ,ln
	,drop ;

:gR>
	,dup
	"pop rax" ,ln ;

:gR@
	,dup
	"mov rax,[rsp]" ,ln ;

:gAND
	"and rax,[rbp]" ,ln
	,drop ;

:gOR
	"or rax,[rbp]" ,ln
	,drop ;

:gXOR
	"xor rax,[rbp]" ,ln
	,drop ;

:gNOT
	"not rax" ,ln ;

:gNEG
	"neg rax" ,ln ;

:g+
	"add rax,[rbp]" ,ln
	,drop ;

:g-
	"neg rax" ,ln
	"add rax,[rbp]" ,ln
	,drop ;

:g*
	"imul rax,[rbp]" ,ln
	,drop ;

:g/
	"mov rbx,rax" ,ln
	,drop
	"cdq;idiv rbx" ,ln
	;

:g*/
	"mov rbx,rax" ,ln
	"mov rcx,[rbp]" ,ln
	,2drop
	"cdq;imul rcx;idiv rbx" ,ln
	;

:g/MOD
	"mov rbx,rax" ,ln
	"mov rax,[rbp]" ,ln
	"cdq;idiv rbx" ,ln
	"mov [rbp],rax" ,ln
	"xchg rax,rdx" ,ln
	;

:gMOD
	"mov rbx,rax" ,ln
	,drop
	"cdq;idiv rbx;mov rax,rdx" ,ln
	;

:gABS
	"cdq;add rdx,rdx;xor rax,rdx" ,ln ;

:gSQRT
	"call sqrt" ,ln ;

:gCLZ
	"bsr rax,rax;xor rax,63" ,ln ;

:g<<
	"mov rcx,rax" ,ln
	,drop
	"shl rax,rcx" ,ln
:g>>
	"mov rcx,rax" ,ln
	,drop
	"sar rax,rcx" ,ln
:g>>>
	"mov rcx,rax" ,ln
	,drop
	"shr rax,rcx" ,ln

:g*>>
	"mov rcx,rax" ,ln
	,DROP
	"cdq" ,ln
	"imul dword [rbp]" ,ln
	"shrd rax,rdx,cl" ,ln
	"sar rdx,cl" ,ln
	"test cl,32" ,ln
	"cmovne	rax,rdx" ,ln
	,NIP ;

:g<</
	"mov rcx,rax" ,ln
	"mov rbx,[rbp]" ,ln
	,2DROP
	"cdq" ,ln
    "shld rdx,rax,cl" ,ln
	"shl rax,cl" ,ln
	"idiv rbx" ,ln ;

:g@
	"movsx rax,dword [rax]" ,ln ;

:gC@
	"movsx rax,byte [rax]" ,ln ;

:gQ@
	"mov rax,qword[rax]" ,ln ;

:g@+
	"movsx rbx,dword [rax]" ,ln
	"add rax,4"
	,dup
	"mov rax,rbx" ,ln ;

:gC@+
	"movsx rbx,byte [rax]" ,ln
	"add rax,1"
	,dup
	"mov rax,rbx" ,ln ;

:gQ@+
	"mov rbx,[rax]" ,ln
	"add rax,8"
	,dup
	"mov rax,rbx" ,ln ;

:g!
	"mov rcx,[rbp]" ,ln
	"mov dword[rax],ecx" ,ln
	,2DROP ;

:gC!
	"mov rcx,[rbp]" ,ln
	"mov byte[rax],cl" ,ln
	,2DROP ;

:gQ!
	"mov rcx,[rbp]" ,ln
	"mov [rax],rcx" ,ln
	,2DROP ;

:g!+
	"mov rcx,[rbp]" ,ln
	"mov dword [rax],ecx" ,ln
	"add rax,4" ,ln
	,NIP ;

:gC!+
	"mov rcx,[rbp]" ,ln
	"mov byte [rax],cl" ,ln
	"add rax,1" ,ln
	,NIP ;

:gQ!+
	"mov rcx,[rbp]" ,ln
	"mov [rax],rcx" ,ln
	"add rax,8" ,ln
	,NIP ;

:g+!
	"mov rcx,[rbp]" ,ln
	"add dword [rax],ecx" ,ln
	,2DROP ;

:gC+!
	"mov rcx,[rbp]" ,ln
	"add byte [rax],cl" ,ln
	,2DROP ;

:gQ+!
	"mov rcx,[rbp]" ,ln
	"add [rax],rcx" ,ln
	,2DROP ;


:g>A
	"mov r8,rax" ,ln
	,drop ;

:gA>
	,dup
	"mov rax,r8" ,ln ;

:gA@
	,dup
	"mov rax,[r8]" ,ln ;

:gA!
	"mov [r8],rax" ,ln
	,drop ;

:gA+
	"add r8,rax" ,ln
	,drop ;

:gA@+
	,dup
	"movsx rax,dword [r8];add r8,4" ,asm ;

:gA!+
	"mov dword[r8],rax;add r8,4" ,asm
	,drop ;

:g>B
	"mov r9,rax" ,ln
	,drop ;

:gB>
	,dup
	"mov rax,r9" ,ln ;

:gB@
	,dup
	"mov rax,[r9]" ,ln ;

:gB!
	"mov [r9],rax" ,ln
	,drop ;

:gB+
	"add r9,rax" ,ln
	,drop ;

:gB@+
	,dup
	"movsx rax,dword [r9];add r9,4" ,asm ;

:gB!+
	"mov dword[r9],rax;add r9,4" ,asm
	,drop ;



:gMOVE
	"mov rcx,rax" ,ln
	"mov rsi,dword[rbp]" ,ln
	"mov rdi,dword[rbp-8]" ,ln
	"rep movsd" ,ln
	,3DROP ;

:gMOVE>
	"mov rcx,rax" ,ln
	"mov rsi,dword[rbp]" ,ln
	"mov rdi,dword[rbp-8]" ,ln
	"lea rsi,[rsi+rcx*4-4]" ,ln
	"lea rdi,[rdi+rcx*4-4]" ,ln
	"std" ,ln
	"rep movsd" ,ln
	"cld" ,ln
	,3DROP ;

:gFILL
	"mov rcx,rax" ,ln
	"mov rax,dword[rbp]" ,ln
	"mov rdi,dword[rbp-8]" ,ln
	"rep stosd" ,ln
	,3DROP ;

:gCMOVE
	needESIEDIECX
	"rep movsb" ,asm ;
:gCMOVE>
	needESIEDIECX
	"lea esi,[esi+ecx-1];lea edi,[edi+ecx-1];std;rep movsb;cld" ,asm ;
:gCFILL
	needEDIECXEAX
	"rep stosb" ,asm ;
:gQMOVE
	needESIEDIECX
	"rep movsq" ,asm ;
:gQMOVE>
	needESIEDIECX
	"lea rsi,[rsi+rcx*8-8];lea rdi,[rdi+rcx*8-8];std;rep movsq;cld" ,asm ;
:gQFILL
	needEDIECXEAX
	"rep stosq" ,asm ;

:gUPDATE
	"call SYSREDRAW" ,asm
	;
:gREDRAW
	"call SYSUPDATE" ,asm
	;
:gMEM
	0 PUSH.CTEM ;
:gSW
	0 PUSH.CTE ;
:gSH
	1 PUSH.CTE ;
:gFRAMEV
	1 PUSH.CTEM ;

:gXYPEN
	2 PUSH.CTEM 3 PUSH.CTEM ;
:gBPEN
	4 PUSH.CTEM ;
:gKEY
	5 PUSH.CTEM ;
:gCHAR
	6 PUSH.CTEM ;

:gMSEC
	"call SYSMSEC" ,asm ;
:gTIME
	"call SYSTIME" ,asm ;
:gDATE
	"call SYSDATE" ,asm ;
:gLOAD
	"call SYSLOAD" ,asm ;
:gSAVE
	"call SYSSAVE" ,asm ;
:gAPPEND
	"call SYSAPPEND" ,asm ;

:gFFIRST
:gFNEXT
	;
:gSYS
	;



|----
#vmc
0 0 0 0 0 0 0 gdec ghex gdec gdec gstr gwor gvar gdwor gdvar
g; g( g) g[ g] gEX g0? g1? g+? g-? g<? g>? g=? g>=? g<=? g<>?
gA? gN? gB? ,DUP ,DROP ,OVER ,PICK2 ,PICK3 ,PICK4 ,SWAP ,NIP ,ROT ,2DUP ,2DROP ,3DROP ,4DROP
,2OVER ,2SWAP g>R gR> gR@ gAND gOR gXOR g+ g- g* g/ g<< g>> g>>> gMOD
g/MOD g*/ g*>> g<</ gNOT gNEG gABS gSQRT gCLZ g@ gC@ gQ@ g@+ gC@+ gQ@+ g!
gC! gQ! g!+ gC!+ gQ!+ g+! gC+! gQ+! g>A gA> gA@ gA! gA+ gA@+ gA!+ g>B
gB> gB@ gB! gB+ gB@+ gB!+ gMOVE gMOVE> gFILL gCMOVE gCMOVE> gCFILL gQMOVE gQMOVE> gQFILL gUPDATE
gREDRAW gMEM gSW gSH gFRAMEV gXYPEN gBPEN gKEY gCHAR gMSEC gTIME gDATE gLOAD gSAVE gAPPEND gFFIRST
gFNEXT gSYS


:codestep | token --
	$ff and
|	dup r3tokenname slog
	2 << 'vmc + @ ex ;


::genasmcode | duse --
|	dup cellinig
	cellstart
	'bcode ( bcode> <?
		@+
		"; " ,s dup ,tokenprint 9 ,c ,printstk ,cr
		codestep
|		"asm/code.asm" savemem | debug
		) drop ;