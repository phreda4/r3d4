;---r3 compiler code.asm
;--------------------------
; :onshow  e       calls:1 niv:1 len:17 [ a --  ]
w47:
mov r10,rax
mov dword[w46],0
push r10
_i1:
	mov ebx,dword[w46]
	or ebx,ebx
	jnz _o1
	call SYSREDRAW
	mov r10,[rsp]
	call r10
	call SYSUPDATE
	jmp _i1
_o1:
mov dword[w46],0
lea rbp,[rbp-8]
pop rax
ret

;--------------------------
; :exit  e       calls:1 niv:0 len:4 [  --  ]
w48:
mov dword[w46],1
ret

;--------------------------
; :patternxor  l'      calls:1 niv:1 len:40 [  --  ]
w54:
mov rsi,[SYSFRAME]
mov r8,YRES
_i6:
	or r8,r8
	jz _o6
	sub r8,1
	mov r9,XRES
	_i7:
		or r9,r9
		jz _o7
		sub r9,1
		push r9 r8
		call SYSMSEC
		pop r8 r9
		mov rbx,r8
		xor rbx,r9
		add rbx,rax
		shl rbx,8
		mov dword[rsi],ebx
		add rsi,4
	jmp _i7
	_o7:
jmp _i6
_o6:
cmp dword[SYSKEY],27
jne _o8
; (	; [ qword[rbp-4] dword[SYSKEY] ]
; exit	; [ qword[rbp-4] rax ]
	call w48
; )	; [ qword[rbp-4] rax ]
_o8:
ret

;--------------------------
; :  l       calls:1 niv:2 len:3 [  --  ]
INICIO:
lea rbp,[rbp+8]
mov rax,w54
jmp w47
 