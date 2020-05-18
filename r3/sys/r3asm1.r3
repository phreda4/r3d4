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
	"mov rcx,[rbp]" ,ln
	"mov [rbp],rax" ,ln
	"mov rax,[rbp-8]" ,ln
	"mov [rbp-8],rcx" ,ln ;
:,2DUP
	"mov rcx,[rbp]" ,ln
	"mov [rbp+8],rax" ,ln
	"mov [rbp+8*2],rcx" ,ln
	"add rbp,8*2" ,ln ;
:,2OVER
	"mov [rbp+8],rax" ,ln
	"add rbp,8*2" ,ln
	"mov rbx,[rbp-8*4]" ,ln
	"mov [rbp],rbx" ,ln
	"mov rax,[rbp-8*3]" ,ln ;
:,2SWAP
	"xchg rax,[rbp-8]" ,ln
	"mov rcx,[rbp-8*2]" ,ln
	"xchg rcx,[rbp]" ,ln
	"mov [rbp-8*2],rcx" ,ln ;

|----------------------
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

|---- Optimization WORDS
#preval * 32
#prevale * 32
#prevalv 0

:,TOS	'preval ,s ;
:,TOSE	'prevale ,s ;
:>TOS   dup 'preval strcpy 'prevale strcpy ;
:>TOSE  'prevale strcpy ;

:varget
	"movsxd rbx," ,s ,TOS ,cr
	"rbx" >TOS
	"ebx" >TOSE ;

|-------------------------------------
:g[
	pushbl
	dup "jmp ja%h" ,print ,cr
	"anon%h:" ,print ,cr
	;
:g]
	popbl
	dup "ja%h:" ,print ,cr
	,DUP
	"mov rax,anon%h" ,print ,cr
	;

:gEX
	"mov rcx,rax" ,ln
	,DROP
	dup @ $ff and
	16 <>? ( drop "call rcx" ,ln ; ) drop
	"jmp rcx" ,ln ;

:g0?
	"or rax,rax" ,ln
	?? "jnz _o%h" ,print ,cr ;

:g1?
	"or rax,rax" ,ln
	?? "jz _o%h" ,print ,cr ;

:g+?
	"or rax,rax" ,ln
	?? "js _o%h" ,print ,cr ;

:g-?
	"or rax,rax" ,ln
	?? "jns _o%h" ,print ,cr ;

:g<?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	?? "jge _o%h" ,print ,cr ;

:g>?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	?? "jle _o%h" ,print ,cr ;

:g=?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	?? "jne _o%h" ,print ,cr ;

:g>=?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	?? "jl _o%h" ,print ,cr ;

:g<=?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	?? "jg _o%h" ,print ,cr ;

:g<>?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	?? "je _o%h" ,print ,cr ;

:gA?
	"mov rbx,rax" ,ln
	,drop
	"test rax,rbx" ,ln
	?? "jz _o%h" ,print ,cr ;

:gN?
	"mov rbx,rax" ,ln
	,drop
	"test rax,rbx" ,ln
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
	"push rax" ,ln ,drop ;

:gR>
	,dup "pop rax" ,ln ;

:gR@
	,dup "mov rax,[rsp]" ,ln ;


:gAND
	| regNOS
	"and #1,#0" ,asm
	.drop ;

:gOR    "or rax,[rbp]" ,ln ,nip ;

:gXOR   "xor rax,[rbp]" ,ln ,nip ;

:gNOT	"not rax" ,ln ;

:gNEG   "neg rax" ,ln ;

:g+		"add rax,[rbp]" ,ln ,nip ;

:g-
	| regNOS
	"sub #1,#0" ,asm
	.drop ;

:g*		"imul rax,[rbp]" ,ln ,nip ;

:g/
	"mov rbx,rax" ,ln
	,drop
	"cqo" ,ln
	"idiv rbx" ,ln	;

:g*/
	"mov rbx,rax" ,ln
	"mov rcx,[rbp]" ,ln
	,2drop
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
	,drop
	"cqo" ,ln
	"idiv rbx" ,ln
	"mov rax,rdx" ,ln ;

:gABS
	"cqo" ,ln
	"add rax,rdx" ,ln
	"xor rax,rdx" ,ln ;

:gSQRT
	"cvtsi2sd xmm0,rax" ,ln
	"sqrtsd xmm0,xmm0" ,ln
	"cvtsd2si rax,xmm0" ,ln ;

:gCLZ
	"bsr rax,rax" ,ln
	"xor rax,63" ,ln ;

:g<<
	"mov cl,al" ,ln
	,drop "shl rax,cl" ,ln ;

:g>>
	"mov cl,al" ,ln ,drop
	"sar rax,cl" ,ln ;

:g>>>
	"mov cl,al" ,ln
	,drop
	"shr rax,cl" ,ln ;

:setA.RM.CC
	cell.fillreg  | reg used?
	DPK2 regA? 0? ( ) drop
	DNOS reg/M? 0? ( ) drop
	DTOS regC/C? 0? ( ) drop
	freeD
	;

:g*>>
	setA.RM.CC
	"cqo;imul #1;shrd rax,rdx,$0" ,asm
    .2drop
	DTOS cellA!
	;

:g<</
	"mov rcx,rax" ,ln
	"mov rbx,[rbp]" ,ln
	,2DROP
	"cqo" ,ln
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
	"movsxd rbx,dword [rax]" ,ln
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
	,dup "movsxd rax,dword[r8]" ,ln ;

:gA!
	"mov dword[r8],eax" ,ln ,drop ;

:gA+
	"add r8,rax" ,ln ,drop ;

:gA@+
	,dup "movsxd rax,dword[r8]" ,ln
	"add r8,4" ,ln ;

:gA!+
	"mov dword[r8],eax" ,ln
	"add r8,4" ,ln ,drop ;

:g>B
	"mov r9,rax" ,ln ,drop ;

:gB>
	,dup "mov rax,r9" ,ln ;

:gB@
	,dup "movsxd rax,dword[r9]" ,ln ;

:gB!
	"mov dword[r9],eax" ,ln ,drop ;

:gB+
	"add r9,rax" ,ln ,drop ;

:gB@+
	,dup "movsxd rax,dword[r9]" ,ln
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
	,dup "mov eax,dword[SYSXM]" ,ln
	,dup "mov eax,dword[SYSYM]" ,ln ;
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

|----------- Number
:gdec
	getcte PUSH.NRO
|	,DUP
|	getcte 0? ( drop "xor rax,rax" ,ln ; )
|	"mov rax," ,s ,d ,cr
	;

|----------- Calculate Number
:ghex  | really constant folding number
	getcte2 PUSH.NRO
|	,DUP "mov rax," ,s getcte2 ,d ,cr
	;

|----------- adress string
:gstr
	,DUP "mov rax,str" ,s
	dup 4 - @ 8 >>> ,h ,cr
	;

|----------- adress word
:gdwor
	,DUP "mov rax,w" ,s getval ,h ,cr ;		|--	'word

|----------- adress var
:gdvar
	,DUP "mov rax,w" ,s getval ,h ,cr ;		|--	'var

|----------- var
:gvar
	,DUP "movsxd rax,dword[w" ,s getval ,h "]" ,ln ;	|--	[var]


|----------- call word
:gwor
	dup @ $ff and
	16 =? ( drop getval "jmp w%h" ,print ,cr ; ) drop | ret?
	getval "call w%h" ,print ,cr ;

|-----------------------------------------
#vmc
0 0 0 0 0 0 0 gdec ghex gdec gdec gstr gwor gvar gdwor gdvar
g; g( g) g[ g] gEX g0? g1? g+? g-? g<? g>? g=? g>=? g<=? g<>?
gA? gN? gB? .dup ,DROP ,OVER ,PICK2 ,PICK3 ,PICK4 ,SWAP ,NIP ,ROT ,2DUP ,2DROP ,3DROP ,4DROP
,2OVER ,2SWAP g>R gR> gR@ gAND gOR gXOR g+ g- g* g/ g<< g>> g>>> gMOD
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
	|"asm/code.asm" savemem

	$ff and 2 << 'vmc + @ ex ;


::genasmcode | duse --
	0? ( 1 + ) | if empty, add TOS for not forget!!
	stk.start
	'bcode ( bcode> <?
		@+
		codestep
		) drop ;