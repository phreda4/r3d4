| generate amd64 code
| BASIC GENERATOR
| PHREDA 2020
|-------------
^./r3base.r3

#nstr 0

#anon * 40 | 10 niveles ** falta inicializar si hay varias ejecuciones
#anon> 'anon
#nanon 0

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
	"add rbp,8" ,ln
	"mov [rbp],rax" ,ln ;
:,DROP
	"mov rax,[rbp]" ,ln
	"sub rbp,8" ,ln ;
:,NIP
	"sub rbp,8" ,ln ;
:,2DROP
	"mov rax,[rbp-8]" ,ln
	"sub rbp,8*2" ,ln ;
:,3DROP
	"mov rax,[rbp-8*2]" ,ln
	"sub rbp,8*3" ,ln ;
:,4DROP
	"mov rax,[rbp-8*3]" ,ln
	"sub rbp,8*4" ,ln ;

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
	"add rbp,8*2" ,ln ;
:,2OVER
	"mov [rbp+8],rax" ,ln
	"add rbp,8*2" ,ln
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
:g0 :g: :g:: :g# :g: :g| :g^ ;

|---- Optimization WORDS
#aux * 32

:,TOS
	'aux ,s ;
:>TOS
	'aux strcpy ;

:oand	"and rax," ,s ,TOS ,cr ;
:oor	"or rax," ,s ,TOS ,cr ;
:oxor	"xor rax," ,s ,TOS ,cr ;
:o+		"add rax," ,s ,TOS ,cr ;
:o-		"sub rax," ,s ,TOS ,cr ;
:o*		"imul rax," ,s ,TOS ,cr ;

:o<<	"shl rax," ,s ,TOS ,cr ;
:o<<m	"mov rcx," ,s ,TOS ,cr
		"shl rax,cl" ,ln ;

:o>>	"sar rax," ,s ,TOS ,cr ;
:o<<m	"mov rcx," ,s ,TOS ,cr
		"sar rax,cl" ,ln ;

:o>>>	"shr rax," ,s ,TOS ,cr ;
:o>>m	"mov rcx," ,s ,TOS ,cr
		"shr rax,cl" ,ln ;

:ocmp  	"cmp rax," ,s ,TOS ,cr ;
:otes	"test rax," ,s ,TOS ,cr ;

:o/		"mov rbx," ,s ,TOS ,cr
		"cdq" ,ln
		"idiv rbx" ,ln ;

:o/m	"cdq" ,ln
		"idiv " ,s ,TOS ,cr ;

:oMOD	"mov rbx," ,s ,TOS ,cr
		"cdq" ,ln
		"idiv rbx" ,ln
		"mov rax,rdx" ,ln ;

:oMODm	"cdq" ,ln
		"idiv " ,s ,TOS ,cr
		"mov rax,rdx" ,ln ;

:o/MOD	"mov rbx," ,s ,TOS ,cr
		"cdq" ,ln
		"idiv rbx" ,ln
		"add ebp,8" ,ln
		"mov [rbp],rax" ,ln
		"mov rax,rdx" ,ln ;

:o/MODm	"cdq" ,ln
		"idiv " ,s ,TOS ,cr
		"add ebp,8" ,ln
		"mov [rbp],rax" ,ln
		"mov rax,rdx" ,ln ;

:o*/	"mov rcx,[rbp]" ,ln
		"cdq" ,ln
		"imul rcx" ,ln
		"idiv " ,s ,TOS ,cr
		"sub rbp,8*2" ,ln ;

:g*>>
	;

:g<</
	;

:optimice?
	| <? .. n?
	| and or xor + - * / << >> >>> mod
	;

:gdec
	,DUP getcte "mov rax,$%h" ,format ,cr  ;

:ghex
	,DUP getcte2 "mov rax,$%h" ,format ,cr ;

:gstr
	,DUP nstr "mov rax,str%h" ,format ,cr 1 'nstr +! ;

:gdwor
	,DUP
	getval "mov rax,w%h" ,format ,cr ;		|--	3 word  'word

:gdvar
	,DUP
	getval
	"mov rax,w%h" ,format ,cr ;			|--	3 word  'word

:gvar
	,DUP
	getval
	"movsxd rax,dword[w%h]" ,format ,cr ;	|--	4 var   [var]

:gwor
	dup @ $ff and
	16 =? ( drop getval "jmp w%h" ,format ,cr ; ) drop | ret?
	getval
	"call w%h" ,format ,cr ;

:g;
	dup 8 - @ $ff and
	12 =? ( drop ; ) | tail call  call..ret?
	drop
	"ret" ,ln ;

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
	1 'nanon +!
	nanon dup anon> !+ 'anon> !
	dup "jmp ja%h" ,format cr
	"anon%h:" ,format ,cr
	;
:g]
	-4 'anon> +!
	anon> @
	dup "ja%h:" ,format ,cr
	"add rbp,8" ,ln
	"mov rax,anon%h" ,format ,cr
	;

:gEX
	"mov rcx,rax" ,ln
	,DROP
	over @ $ff and
	16 <>? ( drop "call rcx" ,asm ; ) drop
	"jmp rcx" ,asm ;

:g0?
	gwhilejmp
	"or rax,rax" ,ln
	getval "jnz _o%h" ,format ,cr
	;

:g1?
	gwhilejmp
	"or rax,rax" ,asm
	getval "jz _o%h" ,format ,cr
	;

:g+?
	gwhilejmp
	"or rax,rax" ,asm
	getval "js _o%h" ,format ,cr
	;

:g-?
	gwhilejmp
	"or rax,rax" ,asm
	getval "jns _o%h" ,format ,cr
	;

:g<?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	gwhilejmp
	getval "jge _o%h" ,format ,cr
	;

:g>?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	gwhilejmp
	getval "jle _o%h" ,format ,cr
	;

:g=?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	gwhilejmp
	getval "jne _o%h" ,format ,cr
	;

:g>=?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	gwhilejmp
	getval "jl _o%h" ,format ,cr
	;

:g<=?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	gwhilejmp
	getval "jg _o%h" ,format ,cr
	;

:g<>?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	gwhilejmp
	getval "je _o%h" ,format ,cr
	;

:gA?
	"mov rbx,rax" ,ln
	,drop
	"test rax,rbx" ,ln
	gwhilejmp
	getval "jnz _o%h" ,format ,cr
	;

:gN?
	"mov rbx,rax" ,ln
	,drop
	"test rax,rbx" ,ln
	gwhilejmp
	getval "jz _o%h" ,format ,cr
	;

:gB?
	| sub nos2,nos
	| cmp nos,tos-nos
	"cmp #2,#1" ,asm
	,2drop
	gwhilejmp
	getval "jge _o%h" ,format ,cr
	;

:g>R
	"push rax" ,ln ,drop ;

:gR>
	,dup "pop rax" ,ln ;

:gR@
	,dup "mov rax,[rsp]" ,ln ;

:gAND
	"and rax,[rbp]" ,ln ,nip ;

:gOR
	"or rax,[rbp]" ,ln ,nip ;

:gXOR
	"xor rax,[rbp]" ,ln ,nip ;

:gNOT
	"not rax" ,ln ;

:gNEG
	"neg rax" ,ln ;

:g+
	"add rax,[rbp]" ,ln ,nip ;

:g-
	"neg rax" ,ln
	"add rax,[rbp]" ,ln ,nip ;

:g*
	"imul rax,[rbp]" ,ln ,nip ;

:g/
	"mov rbx,rax" ,ln
	,drop
	"cdq" ,ln
	"idiv rbx" ,ln
	;

:g*/
	"mov rbx,rax" ,ln
	"mov rcx,[rbp]" ,ln
	,2drop
	"cdq" ,ln
	"imul rcx" ,ln
	"idiv rbx" ,ln
	;

:g/MOD
	"mov rbx,rax" ,ln
	"mov rax,[rbp]" ,ln
	"cdq" ,ln
	"idiv rbx" ,ln
	"mov [rbp],rax" ,ln
	"xchg rax,rdx" ,ln
	;

:gMOD
	"mov rbx,rax" ,ln
	,drop
	"cdq" ,ln
	"idiv rbx" ,ln
	"mov rax,rdx" ,ln
	;

:gABS
	"cdq" ,ln
	"add rdx,rdx" ,ln
	"xor rax,rdx" ,ln ;

:gSQRT
	"call sqrt" ,ln ;

:gCLZ
	"bsr rax,rax" ,ln
	"xor rax,63" ,ln ;

:g<<
	"mov cl,al" ,ln
	,drop
	"shl rax,cl" ,ln ;

:g>>
	"mov cl,al" ,ln
	,drop
	"sar rax,cl" ,ln ;

:g>>>
	"mov cl,al" ,ln
	,drop
	"shr rax,cl" ,ln ;

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
	"movsxd rax,dword [rax]" ,ln ;

:gC@
	"movsx rax,byte [rax]" ,ln ;

:gQ@
	"mov rax,qword[rax]" ,ln ;

:g@+
	"movsx rbx,dword [rax]" ,ln
	"add rax,4" ,ln
	,dup
	"mov rax,rbx" ,ln ;

:gC@+
	"movsx rbx,byte [rax]" ,ln
	"add rax,1" ,ln
	,dup
	"mov rax,rbx" ,ln ;

:gQ@+
	"mov rbx,[rax]" ,ln
	"add rax,8" ,ln
	,dup
	"mov rax,rbx" ,ln ;

:g!
	"mov rcx,[rbp]" ,ln
	"mov dword[rax],ecx" ,ln ,2DROP ;

:gC!
	"mov rcx,[rbp]" ,ln
	"mov byte[rax],cl" ,ln ,2DROP ;

:gQ!
	"mov rcx,[rbp]" ,ln
	"mov [rax],rcx" ,ln ,2DROP ;

:g!+
	"mov rcx,[rbp]" ,ln
	"mov dword[rax],ecx" ,ln
	"add rax,4" ,ln ,NIP ;

:gC!+
	"mov rcx,[rbp]" ,ln
	"mov byte[rax],cl" ,ln
	"add rax,1" ,ln ,NIP ;

:gQ!+
	"mov rcx,[rbp]" ,ln
	"mov [rax],rcx" ,ln
	"add rax,8" ,ln ,NIP ;

:g+!
	"mov rcx,[rbp]" ,ln
	"add dword[rax],ecx" ,ln ,2DROP ;

:gC+!
	"mov rcx,[rbp]" ,ln
	"add byte [rax],cl" ,ln ,2DROP ;

:gQ+!
	"mov rcx,[rbp]" ,ln
	"add [rax],rcx" ,ln ,2DROP ;


:g>A
	"mov r8,rax" ,ln ,drop ;

:gA>
	,dup "mov rax,r8" ,ln ;

:gA@
	,dup "mov rax,[r8]" ,ln ;

:gA!
	"mov [r8],rax" ,ln ,drop ;

:gA+
	"add r8,rax" ,ln ,drop ;

:gA@+
	,dup "mov eax,dword[r8]" ,ln
	"add r8,4" ,ln ;

:gA!+
	"mov dword[r8],eax" ,ln
	"add r8,4" ,ln ,drop ;

:g>B
	"mov r9,rax" ,ln ,drop ;

:gB>
	,dup "mov rax,r9" ,ln ;

:gB@
	,dup "mov rax,[r9]" ,ln ;

:gB!
	"mov [r9],rax" ,ln ,drop ;

:gB+
	"add r9,rax" ,ln ,drop ;

:gB@+
	,dup "mov eax,dword[r9]" ,ln
	"add r9,4" ,ln ;

:gB!+
	"mov dword[r9],eax" ,ln
	"add r9,4" ,ln ,drop ;


:gMOVE
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep movsd" ,ln
	,3DROP ;

:gMOVE>
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"lea rsi,[rsi+rcx*4-4]" ,ln
	"lea rdi,[rdi+rcx*4-4]" ,ln
	"std" ,ln
	"rep movsd" ,ln
	"cld" ,ln
	,3DROP ;

:gFILL
	"mov rcx,rax" ,ln
	"movsxd rax,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep stosd" ,ln
	,3DROP ;

:gCMOVE
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep movsb" ,ln
	,3DROP ;

:gCMOVE>
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"lea rsi,[rsi+rcx-1]" ,ln
	"lea rdi,[rdi+rcx-1]" ,ln
	"std" ,ln
	"rep movsb" ,ln
	"cld" ,ln
	,3DROP ;

:gCFILL
	"mov rcx,rax" ,ln
	"movsxd rax,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep stosb" ,ln
	,3DROP ;

:gQMOVE
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep movsq" ,ln
	,3DROP ;

:gQMOVE>
	"mov rcx,rax" ,ln
	"movsxd rsi,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"lea rsi,[rsi+rcx*8-8]" ,ln
	"lea rdi,[rdi+rcx*8-8]" ,ln
	"std" ,ln
	"rep movsq" ,ln
	"cld" ,ln
	,3DROP ;

:gQFILL
	"mov rcx,rax" ,ln
	"movsxd rax,dword[rbp]" ,ln
	"movsxd rdi,dword[rbp-8]" ,ln
	"rep stosq" ,ln
	,3DROP ;

:gMEM
	,dup "mov rax,[FREE_MEM]" ,ln ;
:gSW
	,dup "mov rax,XRES" ,ln ;
:gSH
	,dup "mov rax,YRES" ,ln ;
:gFRAMEV
	,dup "mov rax,[SYSFRAME]" ,ln ;
:gXYPEN
	,dup "mov rax,[SYSXM]" ,ln
	,dup "mov rax,[SYSYM]" ,ln ;
:gBPEN
	,dup "mov eax,dword[SYSBM]" ,ln ;
:gKEY
	,dup "mov eax,dword[SYSKEY]" ,ln ;
:gCHAR
	,dup "mov eax,dword[SYSCHAR]" ,ln ;
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


|-----------------------------------------
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
	drop
	'bcode ( bcode> <?
		@+
		"; " ,s dup ,tokenprint ,cr
		codestep
|		"asm/code.asm" savemem | debug
		) drop ;