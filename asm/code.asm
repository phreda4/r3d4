;---r3 compiler code.asm;--------------------------; :onshow  e     . calls:1 niv:1 len:17 [ a --  ]w47:;---------OPT;---------ANA; 0	; [ 0 ] ; '.exit	; [ 0 1 ] ; !	; [ 0 1 2 ] ; (	; [ 0 ] ; .exit	; [ 0 ] ; 0?	; [ 0 3 ] ; DROP	; [ 0 3 ] ; UPDATE	; [ 0 ] ; DUP	; [ 0 ] ; EX	; [ 0 0 ] ; REDRAW	; [ 0 ] ; )	; [ 0 ] ; 2DROP	; [ 0 3 ] ; 0	; [ ] ; '.exit	; [ 4 ] ; !	; [ 4 5 ] ; ;	; [ ] ; ---- cells ----; 0 R:0 W:1 A (0:13) 1; 1 R:0 W:0 U (1:3) 0; 2 R:0 W:0 U (2:3) 0; 3 R:1 W:0 U (5:15) 0; 4 R:0 W:0 U (14:16) 0; 5 R:0 W:0 U (15:16) 0;---------GEN; 0add rbp,8mov [rbp],raxmov rax,$0; '.exitadd rbp,8mov [rbp],raxmov rax,w46; !mov rcx,[rbp]mov dword[rax],ecxmov rax,[rbp-8]sub rbp,8*2; (_i1:; .exitadd rbp,8mov [rbp],raxmovsxd rax,dword[w46]; 0?or rax,raxjnz _o1; DROPmov rax,[rbp]sub rbp,8; UPDATEcall SYSREDRAW; DUPadd rbp,8mov [rbp],rax; EXmov rcx,raxmov rax,[rbp]sub rbp,8call rcx; REDRAWcall SYSUPDATE; )jmp _i1_o1:; 2DROPmov rax,[rbp-8]sub rbp,8*2; 0add rbp,8mov [rbp],raxmov rax,$0; '.exitadd rbp,8mov [rbp],raxmov rax,w46; !mov rcx,[rbp]mov dword[rax],ecxmov rax,[rbp-8]sub rbp,8*2; ;ret;--------------------------; :exit  e     . calls:1 niv:0 len:4 [  --  ]w48:;---------OPT;---------ANA; 1	; [ ] ; '.exit	; [ 0 ] ; !	; [ 0 1 ] ; ;	; [ ] ; ---- cells ----; 0 R:0 W:0 U A (1:3) 0; 1 R:0 W:0 U (2:3) 0;---------GEN; 1add rbp,8mov [rbp],raxmov rax,$1; '.exitadd rbp,8mov [rbp],raxmov rax,w46; !mov rcx,[rbp]mov dword[rax],ecxmov rax,[rbp-8]sub rbp,8*2; ;ret;--------------------------; :colmix  l     . calls:1 niv:0 len:34 [ abc -- d ]w52:;---------OPT;---------ANA; >R	; [ 0 1 2 ] ; DUP	; [ 0 1 ] ; $ff00ff	; [ 0 1 1 ] ; AND	; [ 0 1 1 3 ] ; PICK2	; [ 0 1 4 ] ; $ff00ff	; [ 0 1 4 0 ] ; AND	; [ 0 1 4 0 5 ] ; OVER	; [ 0 1 4 6 ] ; -	; [ 0 1 4 6 4 ] ; R@	; [ 0 1 4 7 ] ; *	; [ 0 1 4 7 2 ] ; 8	; [ 0 1 4 8 ] ; >>	; [ 0 1 4 8 9 ] ; +	; [ 0 1 4 A ] ; $ff00ff	; [ 0 1 B ] ; AND	; [ 0 1 B C ] ; ROT	; [ 0 1 D ] ; ROT	; [ 1 D 0 ] ; $ff00	; [ D 0 1 ] ; AND	; [ D 0 1 E ] ; SWAP	; [ D 0 F ] ; $ff00	; [ D F 0 ] ; AND	; [ D F 0 10 ] ; OVER	; [ D F 11 ] ; -	; [ D F 11 F ] ; R>	; [ D F 12 ] ; *	; [ D F 12 2 ] ; 8	; [ D F 13 ] ; >>	; [ D F 13 14 ] ; +	; [ D F 15 ] ; $ff00	; [ D 16 ] ; AND	; [ D 16 17 ] ; OR	; [ D 18 ] ; ;	; [ 19 ] ; ---- cells ----; 0 R:0 W:1 (0:23) 1; 1 R:0 W:1 U (0:20) 2; 2 R:0 W:1 (0:27) 3; 3 R:0 W:0 U (3:4) 0; 4 R:0 W:1 U (4:15) 4; 5 R:0 W:0 U (6:7) 0; 6 R:0 W:1 U (7:9) 5; 7 R:0 W:1 U (9:11) 5; 8 R:0 W:1 U (11:13) 5; 9 R:0 W:0 U (12:13) 0; A R:0 W:1 U (13:14) 5; B R:0 W:1 U (14:16) 5; C R:0 W:0 U (15:16) 0; D R:0 W:1 (16:33) 5; E R:0 W:0 U (19:20) 0; F R:0 W:1 (20:31) 4; 10 R:0 W:0 U (22:23) 0; 11 R:0 W:1 U (23:25) 2; 12 R:0 W:1 U (25:27) 2; 13 R:0 W:1 U (27:29) 2; 14 R:0 W:0 U (28:29) 0; 15 R:0 W:1 U (29:30) 2; 16 R:0 W:1 U (30:32) 2; 17 R:0 W:0 U (31:32) 0; 18 R:0 W:1 U (32:33) 2; 19 R:0 W:1 A (33:34) 2;---------GEN; >Rpush raxmov rax,[rbp]sub rbp,8; DUPadd rbp,8mov [rbp],rax; $ff00ffadd rbp,8mov [rbp],raxmov rax,$FF00FF; ANDand rax,[rbp]sub rbp,8; PICK2add rbp,8mov [rbp],raxmov rax,[rbp-8*2]; $ff00ffadd rbp,8mov [rbp],raxmov rax,$FF00FF; ANDand rax,[rbp]sub rbp,8; OVERadd rbp,8mov [rbp],raxmov rax,[rbp-8]; -neg raxadd rax,[rbp]sub rbp,8; R@add rbp,8mov [rbp],raxmov rax,[rsp]; *imul rax,[rbp]sub rbp,8; 8add rbp,8mov [rbp],raxmov rax,$8; >>mov cl,almov rax,[rbp]sub rbp,8sar rax,cl; +add rax,[rbp]sub rbp,8; $ff00ffadd rbp,8mov [rbp],raxmov rax,$FF00FF; ANDand rax,[rbp]sub rbp,8; ROTmov rdx,[rbp]mov [rbp],raxmov rax,[rbp-8]mov [rbp-8],rdx; ROTmov rdx,[rbp]mov [rbp],raxmov rax,[rbp-8]mov [rbp-8],rdx; $ff00add rbp,8mov [rbp],raxmov rax,$FF00; ANDand rax,[rbp]sub rbp,8; SWAPxchg rax,[rbp]; $ff00add rbp,8mov [rbp],raxmov rax,$FF00; ANDand rax,[rbp]sub rbp,8; OVERadd rbp,8mov [rbp],raxmov rax,[rbp-8]; -neg raxadd rax,[rbp]sub rbp,8; R>add rbp,8mov [rbp],raxpop rax; *imul rax,[rbp]sub rbp,8; 8add rbp,8mov [rbp],raxmov rax,$8; >>mov cl,almov rax,[rbp]sub rbp,8sar rax,cl; +add rax,[rbp]sub rbp,8; $ff00add rbp,8mov [rbp],raxmov rax,$FF00; ANDand rax,[rbp]sub rbp,8; ORor rax,[rbp]sub rbp,8; ;ret;--------------------------; :patternxor  l'    . calls:1 niv:1 len:35 [  --  ]w53:;---------OPT;---------ANA; VFRAME	; [ ] ; >A	; [ 0 ] ; SH	; [ ] ; (	; [ 1 ] ; 1?	; [ 1 ] ; 1	; [ 1 ] ; -	; [ 1 2 ] ; SW	; [ 3 ] ; (	; [ 3 4 ] ; 1?	; [ 3 4 ] ; 1	; [ 3 4 ] ; -	; [ 3 4 5 ] ; 2DUP	; [ 3 6 ] ; XOR	; [ 3 6 3 6 ] ; MSEC	; [ 3 6 7 ] ; +	; [ 3 6 7 8 ] ; 8	; [ 3 6 9 ] ; <<	; [ 3 6 9 A ] ; $ff0000	; [ 3 6 B ] ; $ff	; [ 3 6 B C ] ; ROT	; [ 3 6 B C D ] ; colmix	; [ 3 6 C D B ] ; A!+	; [ 3 6 E ] ; )	; [ 3 6 ] ; DROP	; [ 3 4 ] ; )	; [ 3 ] ; DROP	; [ 3 4 ] ; KEY	; [ 3 ] ; 27	; [ 3 F ] ; =?	; [ 3 F 10 ] ; (	; [ 3 F ] ; exit	; [ 3 F ] ; )	; [ 3 F ] ; DROP	; [ 3 F ] ; ;	; [ 3 ] ; ---- cells ----; 0 R:0 W:0 U (1:2) 0; 1 R:1 W:0 U (3:7) 0; 2 R:0 W:0 U (6:7) 0; 3 R:0 W:1 A (7:35) 1; 4 R:1 W:0 U (8:27) 0; 5 R:0 W:0 U (11:12) 0; 6 R:0 W:1 U (12:14) 2; 7 R:0 W:1 U (14:16) 2; 8 R:0 W:0 U (15:16) 0; 9 R:0 W:1 U (16:18) 2; A R:0 W:0 U (17:18) 0; B R:0 W:1 (18:22) 2; C R:0 W:0 U (19:22) 0; D R:0 W:0 U (20:22) 0; E R:0 W:0 U (22:23) 0; F R:1 W:0 U (28:34) 0; 10 R:1 W:0 U (29:30) 0;---------GEN; VFRAMEadd rbp,8mov [rbp],raxmov rax,[SYSFRAME]; >Amov r8,raxmov rax,[rbp]sub rbp,8; SHadd rbp,8mov [rbp],raxmov rax,YRES; (_i6:; 1?or rax,raxjz _o6; 1add rbp,8mov [rbp],raxmov rax,$1; -neg raxadd rax,[rbp]sub rbp,8; SWadd rbp,8mov [rbp],raxmov rax,XRES; (_i7:; 1?or rax,raxjz _o7; 1add rbp,8mov [rbp],raxmov rax,$1; -neg raxadd rax,[rbp]sub rbp,8; 2DUPmov rdx,[rbp]mov [rbp+8],raxmov [rbp+8*2],rdxlea rbp,[rbp+8*2]; XORxor rax,[rbp]sub rbp,8; MSECcall SYSMSEC; +add rax,[rbp]sub rbp,8; 8add rbp,8mov [rbp],raxmov rax,$8; <<mov cl,almov rax,[rbp]sub rbp,8shl rax,cl; $ff0000add rbp,8mov [rbp],raxmov rax,$FF0000; $ffadd rbp,8mov [rbp],raxmov rax,$FF; ROTmov rdx,[rbp]mov [rbp],raxmov rax,[rbp-8]mov [rbp-8],rdx; colmixcall w52; A!+mov dword[r8],eaxadd r8,4mov rax,[rbp]sub rbp,8; )jmp _i7_o7:; DROPmov rax,[rbp]sub rbp,8; )jmp _i6_o6:; DROPmov rax,[rbp]sub rbp,8; KEYadd rbp,8mov [rbp],raxmov eax,dword[SYSKEY]; 27add rbp,8mov [rbp],raxmov rax,$1B; =?mov rbx,raxmov rax,[rbp]sub rbp,8cmp rax,rbxjne _o8; (; exitcall w48; )_o8:; DROPmov rax,[rbp]sub rbp,8; ;ret;--------------------------; :  l     . calls:1 niv:2 len:3 [  --  ]INICIO:;---------OPT;---------ANA; 'patternxor	; [ ] ; onshow	; [ 0 ] ; ;	; [ ] ; ---- cells ----; 0 R:0 W:0 U A (1:2) 0;---------GEN; 'patternxoradd rbp,8mov [rbp],raxmov rax,w53; onshowjmp w47; ; 