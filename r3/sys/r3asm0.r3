| generate amd64 code
| BASIC GENERATOR
| - no stack memory, only look next code to generate optimizations
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

|--- IF
:g(
	getval
	getiw 0? ( 2drop ; ) drop
	"_i%h:" ,format ,cr ;		| while

:g)
	getval
	getiw 1? ( over "jmp _i%h" ,format ,cr ) drop	| while
	"_o%h:" ,format ,cr ;

|---- Optimization WORDS
#preval * 32
#prevalv

:,TOS	'preval ,s ;
:>TOS   'preval strcpy ;

:varget
	"movsxd rbx," ,s ,TOS ,cr "rbx" >TOS ;

|-------------------------------------
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
	dup @ $ff and
	16 <>? ( drop "call rcx" ,ln ; ) drop
	"jmp rcx" ,ln ;
:oEX
	"mov rcx," ,s ,TOS ,cr
	dup @ $ff and
	16 <>? ( drop "call rcx" ,ln ; ) drop
	"jmp rcx" ,ln ;

:g0?
	"or rax,rax" ,ln
	getval "jnz _o%h" ,format ,cr ;

:g1?
	"or rax,rax" ,ln
	getval "jz _o%h" ,format ,cr ;

:g+?
	"or rax,rax" ,ln
	getval "js _o%h" ,format ,cr ;

:g-?
	"or rax,rax" ,ln
	getval "jns _o%h" ,format ,cr ;

:g<?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	getval "jge _o%h" ,format ,cr ;
:o<?
	"cmp rax," ,s ,TOS ,cr
	getval "jge _o%h" ,format ,cr ;

:g>?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	getval "jle _o%h" ,format ,cr ;
:o>?
	"cmp rax," ,s ,TOS ,cr
	getval "jle _o%h" ,format ,cr ;

:g=?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	getval "jne _o%h" ,format ,cr ;
:o=?
	"cmp rax," ,s ,TOS ,cr
	getval "jne _o%h" ,format ,cr ;

:g>=?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	getval "jl _o%h" ,format ,cr ;
:o>=?
	"cmp rax," ,s ,TOS ,cr
	getval "jl _o%h" ,format ,cr ;

:g<=?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	getval "jg _o%h" ,format ,cr ;
:o<=?
	"cmp rax," ,s ,TOS ,cr
	getval "jg _o%h" ,format ,cr ;

:g<>?
	"mov rbx,rax" ,ln
	,drop
	"cmp rax,rbx" ,ln
	getval "je _o%h" ,format ,cr ;
:o<>?
	"cmp rax," ,s ,TOS ,cr
	getval "je _o%h" ,format ,cr ;

:gA?
	"mov rbx,rax" ,ln
	,drop
	"test rax,rbx" ,ln
	getval "jz _o%h" ,format ,cr ;
:oA?
	"test rax," ,s ,TOS ,cr
	getval "jz _o%h" ,format ,cr ;

:gN?
	"mov rbx,rax" ,ln
	,drop
	"test rax,rbx" ,ln
	getval "jnz _o%h" ,format ,cr ;
:oN?
	"test rax," ,s ,TOS ,cr
	getval "jnz _o%h" ,format ,cr ;

:gB?
	"sub rbp,8*2" ,ln
	"mov rbx,[rbp+8]" ,ln
	"xchg rax,rbx" ,ln
	"cmp rax,[rbp+8*2]" ,ln
	getval "jge _o%h" ,format ,cr
	"cmp rax,rbx"
	getval "jle _o%h" ,format ,cr
	;

:g>R
	"push rax" ,ln ,drop ;

:gR>
	,dup "pop rax" ,ln ;

:gR@
	,dup "mov rax,[rsp]" ,ln ;


:gAND	"and rax,[rbp]" ,ln ,nip ;
:oAND	"and rax," ,s ,TOS ,cr ;
:oandv	varget "and rax," ,s ,TOS ,cr ;

:gOR    "or rax,[rbp]" ,ln ,nip ;
:oOR	"or rax," ,s ,TOS ,cr ;
:oorv	varget "or rax," ,s ,TOS ,cr ;

:gXOR   "xor rax,[rbp]" ,ln ,nip ;
:oXOR	"xor rax," ,s ,TOS ,cr ;
:oxorv	varget "xor rax," ,s ,TOS ,cr ;

:gNOT	"not rax" ,ln ;

:gNEG   "neg rax" ,ln ;

:g+		"add rax,[rbp]" ,ln ,nip ;
:o+		"add rax," ,s ,TOS ,cr ;
:o+v	varget "add rax," ,s ,TOS ,cr ;

:g-		"neg rax" ,ln "add rax,[rbp]" ,ln ,nip ;
:o-		"sub rax," ,s ,TOS ,cr ;
:o-v	varget "sub rax," ,s ,TOS ,cr ;

:g*		"imul rax,[rbp]" ,ln ,nip ;
:o*		"imul rax," ,s ,TOS ,cr ;
:o*v	varget "imul rax," ,s ,TOS ,cr ;

:g/
	"mov rbx,rax" ,ln
	,drop
	"cqo" ,ln
	"idiv rbx" ,ln	;
:o/
	"mov rbx," ,s ,TOS ,cr
	"cqo" ,ln
	"idiv rbx" ,ln ;
:o/v
	"cqo" ,ln
	"idiv " ,s ,TOS ,cr ;

:g*/
	"mov rbx,rax" ,ln
	"mov rcx,[rbp]" ,ln
	,2drop
	"cqo" ,ln
	"imul rcx" ,ln
	"idiv rbx" ,ln 	;
:o*/
	"mov rbx," ,s ,TOS ,cr
	"cqo" ,ln
	"imul qword[rbp]" ,ln
	"idiv rbx" ,ln
	"sub rbp,8" ,ln ;
:o*/v
	"cqo" ,ln
	"imul qword[rbp]" ,ln
	"idiv " ,s ,TOS ,cr
	"sub rbp,8" ,ln ;


:g/MOD
	"mov rbx,rax" ,ln
	"mov rax,[rbp]" ,ln
	"cqo" ,ln
	"idiv rbx" ,ln
	"mov [rbp],rax" ,ln
	"xchg rax,rdx" ,ln 	;
:o/MOD
	"mov rbx," ,s ,TOS ,cr
	"cqo" ,ln
	"idiv rbx" ,ln
	"add ebp,8" ,ln
	"mov [rbp],rax" ,ln
	"mov rax,rdx" ,ln ;
:o/MODv
	"cqo" ,ln
	"idiv " ,s ,TOS ,cr
	"add ebp,8" ,ln
	"mov [rbp],rax" ,ln
	"mov rax,rdx" ,ln ;

:gMOD
	"mov rbx,rax" ,ln
	,drop
	"cqo" ,ln
	"idiv rbx" ,ln
	"mov rax,rdx" ,ln ;
:oMOD
	"mov rbx," ,s ,TOS ,cr
	"cqo" ,ln
	"idiv rbx" ,ln
	"mov rax,rdx" ,ln ;
:oMODv
	"cqo" ,ln
	"idiv " ,s ,TOS ,cr
	"mov rax,rdx" ,ln ;

:gABS
	"cqo" ,ln
	"add rdx,rdx" ,ln
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
:o<<
	"shl rax," ,s ,TOS ,cr ;
:o<<v
	"mov rcx," ,s ,TOS ,cr
	"shl rax,cl" ,ln ;

:g>>
	"mov cl,al" ,ln ,drop
	"sar rax,cl" ,ln ;
:o>>
	"sar rax," ,s ,TOS ,cr ;
:o>>v
	"mov rcx," ,s ,TOS ,cr
	"sar rax,cl" ,ln ;

:g>>>
	"mov cl,al" ,ln
	,drop
	"shr rax,cl" ,ln ;
:o>>>
	"shr rax," ,s ,TOS ,cr ;
:o>>>v
	"mov rcx," ,s ,TOS ,cr
	"shr rax,cl" ,ln ;

:g*>>
	"mov rcx,rax" ,ln
	,DROP
	"cqo" ,ln
	"imul qword[rbp]" ,ln
	"shrd rax,rdx,cl" ,ln
	"sar rdx,cl" ,ln
	"test cl,64" ,ln
	"cmovne	rax,rdx" ,ln
	,NIP ;
:o*>>
	"cqo" ,ln
	"imul qword[rbp]" ,ln
	,NIP
	prevalv
	64 <? ( "shrd rax,rdx," ,s ,d ,cr ; )
	64 >? ( "sar rdx," ,s dup 64 - ,d ,cr )
	drop
	"mov rax,rdx" ,ln ;
:o*>>v
	"mov rcx," ,s ,TOS ,cr
	"cqo" ,ln
	"imul qword[rbp]" ,ln
	,NIP
	"shrd rax,rdx,cl" ,ln
	"sar rdx,cl" ,ln
	"test cl,64" ,ln
	"cmovne rax,rdx" ,ln ;

:g<</
	"mov rcx,rax" ,ln
	"mov rbx,[rbp]" ,ln
	,2DROP
	"cqo" ,ln
    "shld rdx,rax,cl" ,ln
	"shl rax,cl" ,ln
	"idiv rbx" ,ln ;
:o<</
	"mov rbx,rax" ,ln
	,DROP
	"cqo" ,ln
	   "shld rdx,rax," ,s prevalv ,d ,cr
	"shl rax," ,s prevalv ,d ,cr
	"idiv rbx" ,ln ;
:o<</v
	"mov rcx," ,s ,TOS ,cr
	"mov rbx,rax" ,ln
	,DROP
	"cqo" ,ln
	"shld rdx,rax,cl" ,ln
	"shl rax,cl" ,ln
	"idiv rbx" ,ln ;

:g@
	"movsxd rax,dword [rax]" ,ln ;
:o@
	,dup "movsxd rax,dword [" ,s ,TOS "]" ,ln ;

:gC@
	"movsx rax,byte [rax]" ,ln ;
:oC@
	,dup "movsx rax,byte [" ,s ,TOS "]" ,ln ;

:gQ@
	"mov rax,qword[rax]" ,ln ;
:oQ@
	,dup "mov rax,qword[" ,s ,TOS "]" ,ln ;

:g@+
	"movsxd rbx,dword [rax]" ,ln
	"add rax,4" ,ln
	,dup
	"mov rax,rbx" ,ln ;
:o@+
	,dup
	"mov rbx," ,s ,TOS ,cr
	"movsxd rax,dword [rbx]" ,ln
	"add rbx,4" ,ln
	,dup
	"mov [rbp],rbx" ,ln ;

:gC@+
	"movsx rbx,byte [rax]" ,ln
	"add rax,1" ,ln
	,dup
	"mov rax,rbx" ,ln ;
:oC@+
	,dup
	"mov rbx," ,s ,TOS ,cr
	"movsx rax,byte [rbx]" ,ln
	"add rbx,1" ,ln
	,dup
	"mov [rbp],rbx" ,ln ;

:gQ@+
	"mov rbx,[rax]" ,ln
	"add rax,8" ,ln
	,dup
	"mov rax,rbx" ,ln ;
:oQ@+
	,dup
	"mov rbx," ,s ,TOS ,cr
	"mov rax,[rbx]" ,ln
	"add rbx,8" ,ln
	,dup
	"mov [rbp],rbx" ,ln ;

:g!
	"mov rcx,[rbp]" ,ln
	"mov dword[rax],ecx" ,ln ,2DROP ;
:o!
	"mov dword[" ,s ,TOS "],eax" ,ln ,DROP ;

:gC!
	"mov rcx,[rbp]" ,ln
	"mov byte[rax],cl" ,ln ,2DROP ;
:oC!
	"mov byte[" ,s ,TOS "],al" ,ln ,DROP ;

:gQ!
	"mov rcx,[rbp]" ,ln
	"mov [rax],rcx" ,ln ,2DROP ;
:oQ!
	"mov [" ,s ,TOS "],rax" ,ln ,DROP ;

:g!+
	"mov rcx,[rbp]" ,ln
	"mov dword[rax],ecx" ,ln
	"add rax,4" ,ln ,NIP ;
:o!+
	"mov rcx," ,s ,TOS ,cr
	"mov dword[rcx],eax" ,ln
	"add rcx,4" ,ln ,NIP
	"mov rax,rcx" ,ln ;

:gC!+
	"mov rcx,[rbp]" ,ln
	"mov byte[rax],cl" ,ln
	"add rax,1" ,ln ,NIP ;
:oC!+
	"mov rcx," ,s ,TOS ,cr
	"mov byte[rcx],al" ,ln
	"add rcx,1" ,ln ,NIP
	"mov rax,rcx" ,ln ;

:gQ!+
	"mov rcx,[rbp]" ,ln
	"mov [rax],rcx" ,ln
	"add rax,8" ,ln ,NIP ;
:oQ!+
	"mov rcx," ,s ,TOS ,cr
	"mov [rcx],rax" ,ln
	"add rcx,8" ,ln ,NIP
	"mov rax,rcx" ,ln ;

:g+!
	"mov rcx,[rbp]" ,ln
	"add dword[rax],ecx" ,ln ,2DROP ;
:o+!
	"add dword[" ,s ,TOS "],eax" ,ln ,DROP ;

:gC+!
	"mov rcx,[rbp]" ,ln
	"add byte [rax],cl" ,ln ,2DROP ;
:oC+!
	"add byte[" ,s ,TOS "],al" ,ln ,DROP ;

:gQ+!
	"mov rcx,[rbp]" ,ln
	"add [rax],rcx" ,ln ,2DROP ;
:oQ+!
	"add [" ,s ,TOS "],rax" ,ln ,DROP ;


:g>A	"mov r8,rax" ,ln ,drop ;
:o>A    "mov r8," ,s ,TOS ,cr ;

:gA>    ,dup "mov rax,r8" ,ln ;

:gA@    ,dup "mov rax,[r8]" ,ln ;

:gA!    "mov [r8],rax" ,ln ,drop ;
:oA!    "mov [r8]," ,s ,TOS ,cr ;

:gA+    "add r8,rax" ,ln ,drop ;
:oA+    "add r8," ,s ,TOS ,cr ;

:gA@+
	,dup "mov eax,dword[r8]" ,ln
	"add r8,4" ,ln ;

:gA!+
	"mov dword[r8],eax" ,ln
	"add r8,4" ,ln ,drop ;
:oA!+
	"mov dword[r8]," ,s ,TOS ,cr
	"add r8,4" ,ln ;

:g>B
	"mov r9,rax" ,ln ,drop ;
:o>B
	"mov r9," ,s ,TOS ,cr ;

:gB>
	,dup "mov rax,r9" ,ln ;

:gB@
	,dup "mov rax,[r9]" ,ln ;

:gB!
	"mov [r9],rax" ,ln ,drop ;
:oB!
	"mov [r9]," ,s ,TOS ,cr ;

:gB+
	"add r9,rax" ,ln ,drop ;
:oB+
	"add r9," ,s ,TOS ,cr ;

:gB@+
	,dup "mov eax,dword[r9]" ,ln
	"add r9,4" ,ln ;

:gB!+
	"mov dword[r9],eax" ,ln
	"add r9,4" ,ln ,drop ;
:oB!+
	"mov dword[r9]," ,s ,TOS ,cr
	"add r9,4" ,ln ;


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

|---------------------------------
#vmc1
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 oEX 0 0 0 0
o<? o>? o=? o>=? o<=? o<>?
oA? oN? 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 oAND oOR oXOR o+ o- o* o/ o<< o>> o>>> oMOD
o/MOD o*/ o*>> o<</ 0 0 0 0 0 o@ oC@ oQ@ o@+ oC@+ oQ@+ o!
oC! oQ! o!+ oC!+ oQ!+ o+! oC+! oQ+! o>A 0 0 oA! oA+ 0 oA!+ o>B
0 0 oB! oB+ 0 oB!+ 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0

#vmc2
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 oEX 0 0 0 0
o<? o>? o=? o>=? o<=? o<>?
oA? oN? 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 oAND oOR oXOR o+ o- o* o/ o<< o>> o>>> oMOD
o/MOD o*/ o*>> o<</ 0 0 0 0 0 o@ oC@ oQ@ o@+ oC@+ oQ@+ o!
oC! oQ! o!+ oC!+ oQ!+ o+! oC+! oQ+! o>A 0 0 oA! oA+ 0 oA!+ o>B
0 0 oB! oB+ 0 oB!+ 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0

|----------- Number
:bignumber
	prevalv 31 >>> 0? ( drop ; ) drop
	"mov rbx," ,s ,TOS ,cr
	"rbx" >TOS ;

:decopt
    dup @ $ff and 2 << 'vmc1 + @ 0? ( ; )
	swap getcte	dup 'prevalv ! "$%h" mformat >TOS
	4 + swap
	bignumber ex 1 ;

:gdec
	decopt 1? ( drop ; ) drop
	,DUP
	getcte 0? ( drop "xor rax,rax" ,ln ; )
	"mov rax,$" ,s ,h ,cr  ;

|----------- Calculate Number
:hexopt
	dup @ $ff and 2 << 'vmc1 + @ 0? ( ; ) drop
	swap getcte2 dup 'prevalv ! "$%h" mformat >TOS
	4 + swap | skip next instr
	bignumber ex 1 ;

:ghex  | really constant folding number
	hexopt 1? ( drop ; ) drop
	,DUP "mov rax,$" ,s getcte2 ,h ,cr ;

|----------- adress string
:gstr
	,DUP "mov rax,str" ,s nstr ,h ,cr
	1 'nstr +! ;

|----------- adress word
:sworopt
	dup @ $ff and 2 << 'vmc1 + @ 0? ( ; ) drop
	swap getval	"w%h" mformat >TOS
	4 + swap
	ex 1 ;

:gdwor
	sworopt 1? ( drop ; ) drop
	,DUP "mov rax,w" ,s getval ,h ,cr ;		|--	'word

|----------- adress var
:dvaropt
	dup @ $ff and 2 << 'vmc1 + @ 0? ( ; ) drop
	swap getval	"w%h" mformat >TOS
	4 + swap
	ex 1 ;

:gdvar
	dvaropt 1? ( drop ; ) drop
	,DUP "mov rax,w" ,s getval ,h ,cr ;		|--	'var

|----------- var

:varopt
	dup @ $ff and 2 << 'vmc1 + @ 0? ( ; ) drop
	swap getval "dword[w%h]" mformat >TOS
	4 + swap
	ex 1 ;

:gvar
	varopt 1? ( drop ; ) drop
	,DUP "movsxd rax,dword[" ,s getval ,h "]" ,ln ;	|--	[var]


|----------- call word
:gwor
	dup @ $ff and
	16 =? ( drop getval "jmp w%h" ,format ,cr ; ) drop | ret?
	getval "call w%h" ,format ,cr ;

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
	$ff and 			| dup r3tokenname slog
	2 << 'vmc + @ ex ;

:ctetoken
	8 >>> 'ctecode + q@ "$%h ; calc" mformat ,s ,cr
	;

::,tokenprinto
	"; " ,s
	dup dup $ff and 8 =? ( drop ctetoken ; ) drop
	,tokenprint ,cr
	;

::genasmcode | duse --
	drop
	'bcode ( bcode> <?
		@+
        ,tokenprinto
		codestep
|		"asm/code.asm" savemem | debug
		) drop ;