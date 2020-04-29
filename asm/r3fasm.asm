; r3 container for compile
;
format PE64 GUI 5.0

entry start

;----- SETINGS -----
include 'set.asm'
;----- SETINGS -----

include 'include/win64w.inc'
include 'sdl2.inc'

section '' code readable executable

; from LocoDelAssembly in fasm forum
macro cinvoke64 name, [args]{
common
   PUSH RSP             ;save current RSP position on the stack
   PUSH qword [RSP]     ;keep another copy of that on the stack
   ADD RSP,8
   AND SPL,0F0h         ;adjust RSP to align the stack if not already there
   cinvoke name, args
   POP RSP              ;restore RSP to its original value
}

macro invoke64 name, [args]{
common
   PUSH RSP             ;save current RSP position on the stack
   PUSH qword [RSP]     ;keep another copy of that on the stack
   ADD RSP,8
   AND SPL,0F0h         ;adjust RSP to align the stack if not already there
   invoke name, args
   POP RSP              ;restore RSP to its original value
}

;===============================================
start:
  sub rsp,40
;  cinvoke SDL_Init,SDL_INIT_AUDIO or SDL_INIT_VIDEO ;****
  cinvoke SDL_CreateWindow,_title,\
    SDL_WINDOWPOS_UNDEFINED,SDL_WINDOWPOS_UNDEFINED,\
    XRES,YRES,0
  mov [window],eax
  cinvoke SDL_ShowCursor,0
;  cinvoke SDL_SetWindowFullscreen,[window],SDL_WINDOW_FULLSCREEN
  cinvoke SDL_GetWindowSurface,[window]
  mov rbx,rax
  mov [screen],eax
  mov rdi,[rbx+SDL_Surface.pixels]
  mov [SYSFRAME],rdi
  cinvoke SDL_StartTextInput

  invoke VirtualAlloc,0,MEMSIZE,MEM_COMMIT+MEM_RESERVE,PAGE_READWRITE
  mov [FREE_MEM],rax

  mov rbp,DATASTK
  xor rax,rax
  call INICIO

SYSEND:
  cinvoke SDL_StopTextInput
  cinvoke SDL_DestroyWindow,[window]
  cinvoke SDL_Quit
  add rsp,40
  ret

;----- CODE -----
include 'code.asm'
;----- CODE -----
  ret

;===============================================
align 16
SYSREDRAW:
  push rax rbp   ; c d r8 r9
  cinvoke SDL_UpdateWindowSurface,[window]
  pop rbp rax
  ret

;===============================================
align 16
SYSUPDATE:
  push rax rbp
  xor eax,eax
  mov [SYSKEY],eax
  mov [SYSCHAR],eax
  cinvoke SDL_Delay,10
  cinvoke64 SDL_PollEvent,evt
  test eax,eax
  jz .endr
  mov eax,[evt.type]
  cmp eax,SDL_KEYDOWN
  je upkeyd
  cmp eax,SDL_KEYUP
  je upkeyu
  cmp eax,SDL_MOUSEBUTTONDOWN
  je upmobd
  cmp eax,SDL_MOUSEBUTTONUP
  je upmobu
  cmp eax,SDL_MOUSEMOTION
  je upmomo
  cmp eax,SDL_TEXTINPUT
  je uptext
  cmp eax,SDL_QUIT
  je SYSEND
.endr:
  pop rbp rax
  ret
upkeyd: ;key=(evt.key.keysym.sym&0xffff)|evt.key.keysym.sym>>16;break;
  mov eax,[evt.key.keysym.sym]
  and eax,0xffff
  mov ebx,[evt.key.keysym.sym]
  shr ebx,16
  or eax,ebx
  mov [SYSKEY],eax
  pop rbp rax
  ret
upkeyu: ;key=0x1000|(evt.key.keysym.sym&0xffff)|evt.key.keysym.sym>>16;break;
  mov eax,[evt.key.keysym.sym]
  and eax,0xffff
  mov ebx,[evt.key.keysym.sym]
  shr ebx,16
  or eax,0x1000
  or eax,ebx
  mov [SYSKEY],eax
  pop rbp rax
  ret
upmobd: ;bm|=evt.button.button;break;
  movzx eax,byte[evt.button.button]
  or [SYSBM],eax
  pop rbp rax
  ret
upmobu: ;bm&=~evt.button.button;break;
  movzx eax,[evt.button.button]
  not eax
  and [SYSBM],eax
  pop rbp rax
  ret
upmomo: ;xm=evt.motion.x;ym=evt.motion.y;break;
  mov eax,[evt.motion.x]
  mov [SYSXM],eax
  mov eax,[evt.motion.y]
  mov [SYSYM],eax
  pop rbp rax
  ret
uptext: ;keychar=*(int*)evt.text.text;break;
  movzx eax,byte[evt.text.text]
  mov [SYSCHAR],eax
  pop rbp rax
  ret

;===============================================
SYSMSEC: ;  ( -- msec )
  add rbp,8
  mov [rbp],rax
  invoke GetTickCount
;  cinvoke64 SDL_GetTicks
  ret

;===============================================
align 16
SYSTIME: ;  ( -- hms )
  add rbp,8
  mov [rbp],rax
  invoke GetLocalTime,SysTime
  movzx eax,word [SysTime.wHour]
  shl eax,16
  movzx ebx,word [SysTime.wMinute]
  shl ebx,8
  or eax,ebx
  movzx ebx,word [SysTime.wSecond]
  or eax,ebx
  ret

;===============================================
align 16
SYSDATE: ;  ( -- ymd )
  add rbp,8
  mov [rbp],rax
  invoke GetLocalTime,SysTime
  movzx eax,word [SysTime.wYear]
  shl eax,16
  movzx ebx,word [SysTime.wMonth]
  shl ebx,8
  or eax,ebx
  movzx ebx,word [SysTime.wDay]
  or eax,ebx
  ret

;===============================================
align 16
SYSLOAD: ; ( 'from "filename" -- 'to )
  invoke CreateFile,rax,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,FILE_FLAG_NO_BUFFERING+FILE_FLAG_SEQUENTIAL_SCAN,0
  mov [hdir],rax
  or rax,rax
  mov rax,[rbp]
  jz .loadend
  mov [afile],rax
.again:
  invoke ReadFile,[hdir],[afile],$ffffff,cntr,0 ; hasta 16MB
  mov rax,[cntr]
  add [afile],rax
  or rax,rax
  jnz .again
  invoke CloseHandle,[hdir]
  mov rax,[afile]
.loadend:
  sub rbp,8
  ret

;===============================================
align 16
SYSSAVE: ; ( 'from cnt "filename" -- )
  invoke CreateFile,rax,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_FLAG_SEQUENTIAL_SCAN,0
  mov [hdir],rax
  or rax,rax
  jz .saveend
  mov rdx,[rbp-8]
  mov rcx,[rbp]
  invoke WriteFile,[hdir],rdx,rcx,cntr,0
  cmp [cntr],rcx
  je .saveend
  or rax,rax
  jz .saveend
  invoke CloseHandle,[hdir]
.saveend:
  sub rbp,24
  mov rax,[rbp+8]
  ret

;===============================================
align 16
SYSAPPEND: ; ( 'from cnt "filename" -- )
;        mov rax,[rsp+8] ;FILE_APPEND_DATA=4
  invoke CreateFile,eax,4,0,0,CREATE_ALWAYS,FILE_FLAG_SEQUENTIAL_SCAN,0
  mov [hdir],rax
  or rax,rax
  jz .append
  mov rdx,[rbp-8]
  mov rcx,[rbp]
  invoke WriteFile,[hdir],rdx,rcx,cntr,0
  cmp [cntr],rcx
  je .append
  or rax,rax
  jz .append
  invoke CloseHandle,[hdir]
.append:
  sub rbp,24
  mov rax,[rbp+8]
  ret

;===============================================
SYSFFIRST: ; ( "path" -- fdd ) ;****** r4 32 bits
;	push ebx ecx edx edi esi
	mov rsi,_dir
.bcpy:
	mov bl,[rax]
	or bl,bl
	jz .ends
	mov byte[rsi],bl
	add rax,1
	add rsi,1
	jmp .bcpy
.ends:
	mov dword [rsi],$002A2f2f
	invoke FindFirstFile,_dir,fdd
	mov [hfind],rax
	cmp eax,INVALID_HANDLE_VALUE
	je .nin
	mov rax,fdd
	jmp .fin
.nin:
	xor rax,rax
.fin:
;	pop esi edi edx ecx ebx
	ret

;===============================================
SYSFNEXT: ; ( -- fdd/0) ;****** r4 32 bits
	add rbp,8
	mov [rbp], rax
;	push ebx ecx edx edi esi
	invoke FindNextFile,[hfind],fdd
	or rax,rax
	jz .nin
	mov rax,fdd
	jmp .fin
.nin:
	invoke FindClose,[hfind]
	xor rax,rax
.fin:
;	pop esi edi edx ecx ebx
	ret


;===============================================
SYSYSTEM:	;****** r4 32 bits
	or rax,rax
	jnz .no0
	mov rax,[ProcessInfo.hProcess]
	or rax,rax
	jz .termp
	invoke TerminateProcess,eax,0
	invoke CloseHandle,[ProcessInfo.hThread]
	invoke CloseHandle,[ProcessInfo.hProcess]
	xor rax,rax
    mov [ProcessInfo.hProcess],rax
.termp:
	mov eax,-1
	ret
.no0:
	cmp eax,-1
	jne .non
	mov rax,[ProcessInfo.hProcess]
	or rax,rax
	jz .end
	invoke WaitForSingleObject,[ProcessInfo.hProcess],0
	cmp eax,WAIT_TIMEOUT
	jne .termp
	xor rax,rax
	ret
.non:
	push rax
	push rdi
	push rcx
	xor rax,rax
	mov edi,StartupInfo
	mov ecx,17
	rep stosd
;	invoke ZeroMemory,StartupInfo,StartupInfo.size
	mov eax,17*4
	mov [StartupInfo.cb],eax
	pop rcx
	pop rdi
	pop rax
	invoke CreateProcess,0,eax,0,0,FALSE, 0x08000000,0,0,StartupInfo,ProcessInfo
.end:
	ret

section '.data' data readable writeable

  _title db "r3d",0
  _error db "err",0
  _dir rb 1024

  window dd ?
  screen dd ?

  SysTime SYSTEMTIME
  hfind	dq 0
  hdir dq 0
  afile dq 0
  cntr dq 0
  evt SDL_Event
  fdd WIN32_FIND_DATAA

	ProcessInfo	PROCESS_INFORMATION
	StartupInfo STARTUPINFO


  SYSXM          dd ?
  SYSYM          dd ?
  SYSBM          dd ?
  SYSKEY         dd ?
  SYSCHAR        dd ?
  SYSFRAME       dq ? ;rd XRES*YRES
  FREE_MEM       dq ?
  DATASTK        rq 256


;----- CODE -----
align 16
  include 'data.asm'
;----- CODE -----

section '.idata' import readable

  library kernel32,'KERNEL32',\
          user32,'USER32',\
          sdl2,'SDL2'
  include 'include\api\kernel32.inc'
  include 'include\api\user32.inc'
  include 'sdl2_api.inc'