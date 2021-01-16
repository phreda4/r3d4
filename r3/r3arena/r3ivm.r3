| virtual machine for
| simplest encoding  - 1 byte token
| PHREDA 2021

#TOS #NOS #RTOS
#RA #RB
#STACK * 1024

:i;		RTOS @ 4 'RTOS +! ;
|		RTOS @ 4 'RTOS +! 0? ( r> drop ) ; | *** REPEAT
:i(		;
:i)		@+ 48 << 48 >> + 2 - ;
:i[		@+ 48 << 48 >> + 2 - ;
:i]		4 'NOS +! TOS NOS ! @+ 48 << 48 >> + 2 - 'TOS ! ;
:iEX	-4 'RTOS +! RTOS ! TOS 4 'NOS +! NOS @ 'TOS ! ;
:i0?	TOS 1? ( drop @+ 48 << 48 >> + ; ) drop 2 + ; | +4 (16bit)+
:i1?    TOS 0? ( drop @+ 48 << 48 >> + ; ) drop 2 + ;
:i+?    TOS -? ( drop @+ 48 << 48 >> + ; ) drop 2 + ;
:i-?	TOS +? ( drop @+ 48 << 48 >> + ; ) drop 2 + ;
:i<?    NOS @ TOS >=? ( 'TOS ! -4 'NOS ! @+ 48 << 48 >> + ; ) 'TOS ! -4 'NOS ! 2 + ;
:i>?	NOS @ TOS <=? ( 'TOS ! -4 'NOS ! @+ 48 << 48 >> + ; ) 'TOS ! -4 'NOS ! 2 + ;
:i=?    NOS @ TOS <>? ( 'TOS ! -4 'NOS ! @+ 48 << 48 >> + ; ) 'TOS ! -4 'NOS ! 2 + ;
:i>=?	NOS @ TOS <? ( 'TOS ! -4 'NOS ! @+ 48 << 48 >> + ; ) 'TOS ! -4 'NOS ! 2 + ;
:i<=?	NOS @ TOS >? ( 'TOS ! -4 'NOS ! @+ 48 << 48 >> + ; ) 'TOS ! -4 'NOS ! 2 + ;
:i<>?	NOS @ TOS =? ( 'TOS ! -4 'NOS ! @+ 48 << 48 >> + ; ) 'TOS ! -4 'NOS ! 2 + ;
:iAND?	NOS @ TOS NAND? ( 'TOS ! -4 'NOS ! @+ 48 << 48 >> + ; ) 'TOS ! -4 'NOS ! 2 + ;
:iNAND?	NOS @ TOS AND? ( 'TOS ! -4 'NOS ! @+ 48 << 48 >> + ; ) 'TOS ! -4 'NOS ! 2 + ;
:iBT?	NOS dup 4 - @ swap @ TOS BT? ( 'TOS ! -8 'NOS ! @+ 48 << 48 >> + ; ) 'TOS ! -8 'NOS ! 2 + ;
:iDUP	4 'NOS +! TOS NOS ! ;
:iDROP	NOS dup @ 'TOS ! 4 - 'NOS ! ;
:iOVER	4 'NOS +! TOS NOS ! NOS 8 - 'TOS ! ;
:iPICK2	4 'NOS +! TOS NOS ! NOS 12 - 'TOS ! ;
:iPICK3	4 'NOS +! TOS NOS ! NOS 16 - 'TOS ! ;
:iPICK4	4 'NOS +! TOS NOS ! NOS 20 - 'TOS ! ;
:iSWAP  NOS @ TOS NOS ! 'TOS ! ;
:iNIP	-4 'NOS +! ;
:iROT	TOS NOS 4 - @ 'TOS ! NOS @ NOS 4 - !+ ! ;
:i2DUP  iOVER iOVER ;
:i2DROP	NOS dup 4 - @ 'TOS ! 8 - 'NOS ! ;
:i3DROP	NOS dup 8 - @ 'TOS ! 12 - 'NOS ! ;
:i4DROP	NOS dup 12 - @ 'TOS ! 16 - 'NOS ! ;
:i2OVER iPICK2 iPICK2 ;
:i2SWAP	TOS NOS @ NOS 4 - dup 4 - @ NOS ! @ 'TOS ! NOS 8 - !+ ! ;
:i@		TOS @ 'TOS ! ;
:iC@	TOS c@ 'TOS ! ;
:i@+    TOS @+ 'TOS ! 4 'NOS +! NOS ! ;
:iC@+	TOS c@+ 'TOS ! 4 'NOS +! NOS ! ;
:i!		NOS @ TOS ! NOS dup 4 - @ 'TOS ! 8 - 'NOS ! ;
:iC!	NOS @ TOS c! NOS dup 4 - @ 'TOS ! 8 - 'NOS ! ;
:i!+	NOS @ TOS !+ 'TOS ! -4 'NOS ! ;
:iC!+	NOS @ TOS c!+ 'TOS ! -4 'NOS ! ;
:i+!	NOS @ TOS +! -4 'NOS ! ;
:iC+!	NOS @ TOS c+! -4 'NOS ! ;
:i>A	TOS 'RA ! NOS dup @ 'TOS ! 4 - 'NOS ! ;
:iA>	4 'NOS +! TOS NOS ! RA 'TOS ! ;
:iA@	4 'NOS +! TOS NOS ! RA @ 'TOS ! ;
:iA!	TOS RA ! NOS dup @ 'TOS ! 4 - 'NOS ! ;
:iA+	TOS 'RA +! NOS dup @ 'TOS ! 4 - 'NOS ! ;
:iA@+	4 'NOS +! TOS NOS ! RA @+ 'TOS 'RA ! ;
:iA!+   TOS RA !+ 'RA ! NOS dup @ 'TOS ! 4 - 'NOS ! ;
:i>B    TOS 'RB ! NOS dup @ 'TOS ! 4 - 'NOS ! ;
:iB>    4 'NOS +! TOS NOS ! RB 'TOS ! ;
:iB@	4 'NOS +! TOS NOS ! RB @ 'TOS ! ;
:iB!	TOS RB ! NOS dup @ 'TOS ! 4 - 'NOS ! ;
:iB+	TOS 'RB +! NOS dup @ 'TOS ! 4 - 'NOS ! ;
:iB@+	4 'NOS +! TOS NOS ! RB @+ 'TOS 'RB ! ;
:iB!+	TOS RB !+ 'RB ! NOS dup @ 'TOS ! 4 - 'NOS ! ;
:iNOT	TOS not 'TOS ! ;
:iNEG	TOS neg 'TOS ! ;
:iABS	TOS abs 'TOS ! ;
:iSQRT	TOS sqrt 'TOS ! ;
:iCLZ	TOS clz 'TOS ! ;
:iAND	NOS @ TOS AND 'TOS ! -4 'NOS +! ;
:iOR	NOS @ TOS OR 'TOS ! -4 'NOS +! ;
:iXOR	NOS @ TOS XOR 'TOS ! -4 'NOS +! ;
:i+		NOS @ TOS + 'TOS ! -4 'NOS +! ;
:i-		NOS @ TOS - 'TOS ! -4 'NOS +! ;
:i*		NOS @ TOS * 'TOS ! -4 'NOS +! ;
:i/		NOS @ TOS / 'TOS ! -4 'NOS +! ;
:iMOD	NOS @ TOS MOD 'TOS ! -4 'NOS +! ;
:i<<	NOS @ TOS << 'TOS ! -4 'NOS +! ;
:i>>	NOS @ TOS >> 'TOS ! -4 'NOS +! ;
:i>>>	NOS @ TOS >>> 'TOS ! -4 'NOS +! ;
:i/MOD	NOS @ TOS /MOD 'TOS ! NOS ! ;
:i*/	NOS dup 4 - @ swap @ TOS */ 'TOS ! -8 'NOS +! ;
:i*>>	NOS dup 4 - @ swap @ TOS *>> 'TOS ! -8 'NOS +! ;
:i<</	NOS dup 4 - @ swap @ TOS <</ 'TOS ! -8 'NOS +! ;
:iMOV	NOS dup 4 - @ swap @ TOS  move NOS dup 8 - @ 'TOS ! 12 - 'NOS ! ;
:iMOV>	NOS dup 4 - @ swap @ TOS  move> NOS dup 8 - @ 'TOS ! 12 - 'NOS ! ;
:iFILL	NOS dup 4 - @ swap @ TOS  fill NOS dup 8 - @ 'TOS ! 12 - 'NOS ! ;
:iCMOV	NOS dup 4 - @ swap @ TOS  cmove NOS dup 8 - @ 'TOS ! 12 - 'NOS ! ;
:iCMOV>	NOS dup 4 - @ swap @ TOS  cmove> NOS dup 8 - @ 'TOS ! 12 - 'NOS ! ;
:iCFILL NOS dup 4 - @ swap @ TOS  cfill NOS dup 8 - @ 'TOS ! 12 - 'NOS ! ;
:iLIT1	4 'NOS +! TOS NOS ! @+ 48 << 48 >> 'TOS ! ; | 16 bits
:iLIT2	4 'NOS +! TOS NOS ! @+ 'TOS ! ;	| 32 bits
:iLITs	4 'NOS +! TOS NOS ! c@+ over 'TOS ! + ;	| 8+s bits
:iJMP   @ ;	| 32 bits
:iJMPR  @ 48 << 48 >> + ; 				| 16 bits
:iCALL	@+ swap -4 'RTOS ! RTOS ! ; 	| 32 bits
:iADR	4 'NOS +! TOS NOS ! @+ 'TOS ! ;	| 32 bits (iLIT)
:iVAR	4 'NOS +! TOS NOS ! @+ @ 'TOS ! ;	| 32 bits

#r3maci
i; i( i) i[ i] iEX i0? i1? i+? i-? 				|0-9
i<? i>? i=? i>=? i<=? i<>? iAND? iNAND? iBT? 	|10-18
iDUP iDROP iOVER iPICK2 iPICK3 iPICK4 iSWAP iNIP 	|19-26
iROT i2DUP i2DROP i3DROP i4DROP i2OVER i2SWAP 	|27-33
i@ iC@ i@+ iC@+ i! iC! i!+ iC!+ i+! iC+! 		|34-43
i>A iA> iA@ iA! iA+ iA@+ iA!+ 					|44-50
i>B iB> iB@ iB! iB+ iB@+ iB!+ 					|51-57
iNOT iNEG iABS iSQRT iCLZ						|58-62
iAND iOR iXOR i+ i- i* i/ iMOD					|63-70
i<< i>> i>>> i/MOD i*/ i*>> i<</				|71-77
iMOV iMOV> iFILL iCMOV iCMOV> iCFILL			|78-83
iLIT1 iLIT2 iLITs iJMP iJMPR iCALL				|84-89
iADR iVAR										|90-91
			|90-127

:exlit | 7 bit number
	4 'NOS +! TOS NOS !
	57 << 57 >> 'TOS ! ; | 7 to 64 bits // in 32bits 25 <<

::vmstep | ip -- ip'
	c@+ $80 and? ( exlit ; )
	2 << 'r3maci + @ ex ;

::vmrun | ip -- ip'
	( 1? | *** avoid with REPEAT
		c@+ $80 and? ( exlit ; )
		2 << 'r3maci + @ ex ) ;

::vmreset
	'stack 'NOS ! 0 'TOS !
	'stack 255 2 << +
	0 over ! 'RTOS !
	;
