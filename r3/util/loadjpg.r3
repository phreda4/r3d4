| JPG decoder
| PHREDA 2015
|-----------------------
^r3/lib/mem.r3

^r3/lib/trace.r3

#emem
#restart

#imgrows
#imgcols
#NumComp
#HuffACTableY
#HuffDCTableY
#HuffACTableCbCr
#HuffDCTableCbCr
#SamplesY
#QuantTableY
#SamplesCbCr
#QuantTableCbCr

| index(16)-length(8)-code(8)
#HuffmanDC0 * 1028
#HuffmanDC1 * 1028
#HuffmanAC0 * 1028
#HuffmanAC1 * 1028

#QuantTable * 512 | 2x8x8

#bbit
#bitl

#YVector1 * 256 | 4 for Y attr
#YVector2 * 256
#YVector3 * 256
#YVector4 * 256
#CbVector * 256 | Cb attr
#CrVector * 256 | Cr attr

#dcCoef
#huffAC
#huffDC
#QuantNum

#tempa * 256
#tempw * 256

#JPGzz (
 0  1  8 16  9  2  3 10 17 24 32 25 18 11  4  5
12 19 26 33 40 48 41 34 27 20 13  6  7 14 21 28
35 42 49 56 57 50 43 36 29 22 15 23 30 37 44 51
58 59 52 45 38 31 39 46 53 60 61 54 47 55 62 63 -1 )

#aanscales | precomputed values scaled up by 14 bits
  16384  22725  21407  19266  16384  12873   8867   4520
  22725  31521  29692  26722  22725  17855  12299   6270
  21407  29692  27969  25172  21407  16819  11585   5906
  19266  26722  25172  22654  19266  15137  10426   5315
  16384  22725  21407  19266  16384  12873   8867   4520
  12873  17855  16819  15137  12873  10114   6967   3552
   8867  12299  11585  10426   8867   6967   4799   2446
   4520   6270   5906   5315   4520   3552   2446   1247

:get8 | adr -- adr+ 8b
	c@+ $ff and ;

:get16 | adr -- adr+ 16b
	c@+ $ff and 8 << swap c@+ $ff and rot or ;

:readNumber | adr -- adr+ 16b
	2 + get16 ;
:readComm | adr -- adr+
	get16 2 - ( 1? 1 - swap 1 + swap ) drop ;

|------------------------------
:readbit | adr -- adr bit
	bitl 0? ( drop c@+ $ff and
		$ff =? ( swap 1 + swap )
		'bbit ! 8 )
	1 - 'bitl !
	bbit dup 1 << 'bbit !
	7 >> 1 and ;


| index(16)-code(8)-length(8)
:decodeHuf | a list -- a nro
	>a
	readbit 1 | bitfiel cnt
	( a@+ 1?	| bitfield cnt code
		dup $ff and
		( pick2 >?
			>r >r >r 1 << swap readbit rot or r> 1 + r> r> )
		drop 	| bitfield cnt code
		16 >> $ffff and pick2 =? ( 3drop a> 4 - @ 8 >> $ff and ; )
		drop
		) 3drop
	-1 ;

:recbits | a n -- a v
	0 rot pick2 | n 0 a n
	( 1? 1 - rot 1 << rot readbit rot or swap rot ) drop | n nro a
	rot 1 swap << | nro a cat
	pick2 1 << <=? ( drop swap ; )
	1 - neg rot + ;

|--------------------------
:getcase1
	get8 dup 15 and swap 4 >> * 'SamplesY !
	get8 'QuantTableY ! ;

:getcase2
	get8 dup 15 and swap 4 >> * 'SamplesCbCr !
	get8 'QuantTableCbCr ! ;

:getcasen
	1 =? ( drop getcase1 ; ) drop getcase2 ;

:JPGGetImageAttr | adr -- adr+
	3 +	| Length of segment
	get16 'imgrows !
	get16 'imgcols !
	get8	| Number of components
	( 1? swap
		get8 getcasen
		swap 1 - ) drop ;

|----------------------------------
#curnum

:getHuffTable | a table -- a total
	>a
	emem >b
	16 ( 1? 1 - swap
		get8 b!+ swap ) drop

	0 'curnum !
	emem 0 ( 16 <? 1 +	| adr ht i
		rot rot 			| i adr ht
		@+ ( 1? 1 - rot 	| i ht cnt adr
	        get8 8 << pick4 or curnum 16 << or a!+
			1 'curnum +!
			rot rot ) drop
		curnum 1 << 'curnum !
		rot ) 2drop			| adr ht
	0 a! ;

:tableHuff | a -- a
	get8
	$00 =? ( drop 'HuffmanDC0 getHuffTable ; )
	$01 =? ( drop 'HuffmanDC1 getHuffTable ; )
	$10 =? ( drop 'HuffmanAC0 getHuffTable ; )
	$11 =? ( drop 'HuffmanAC1 getHuffTable ; )
	drop ;

:JPGGetHuffTables | a -- a
	get16 2 - over + swap
	( over <? tableHuff ) nip ;

|-----------------
:PGGetQuantTables | a -- a
	get16 2 - over + swap
	( over <?
		get8
		1 and 8 << 'QuantTable + >a
		'jpgzz ( c@+ +? 	| a zz index
			2 << rot get8		| zz index a byte
			pick2 'aanscales + @ * 12 >> | zz index a value
			rot a> + !			| zz a
			swap ) 2drop
		) nip ;

|-----------------
:SOSline
	get8
	1 =? ( drop get8 dup 15 and 'HuffACTableY ! 4 >> 'HuffDCTableY ! ; )
	drop get8 dup 15 and 'HuffACTableCbCr ! 4 >> 'HuffDCTableCbCr ! ;

:JPGGetSOS | a --
	2 + get8 dup 'NumComp !
	( 1? 1 - swap SOSline swap ) drop
	3 + ;

|-----------------
:cleartempa
	'tempa 0 64 fill ;

:]inarray | n n -- d
	swap 3 << + 2 << 'tempa + ;

:]qarray | n n -- d
	swap 3 << + 2 << QuantNum + ;

:]warray | n n -- d
	swap 3 << + 2 << 'tempw + ;

:]inq@* | n n -- v
	swap 3 << + 2 << dup 'tempa + @ swap QuantNum + @ * ;

|----------------------------------------
:1.0823*  277 * 8 >> ;
:1.4142*  362 * 8 >> ;
:1.8477*  473 * 8 >> ;
:-2.613*  -669 * 8 >> ;

#t0 #t1 #t2 #t3 #t4 #t5 #t6 #t7
#a0 #a1 #a2 #a3

:pass1f
	0 over ]inq@* 't0 !
	2 over ]inq@* 't1 !
	4 over ]inq@* 't2 !
	6 over ]inq@* 't3 !
	t0 t2 2dup + 'a0 ! - 'a1 !
	t1 t3 2dup + 'a3 ! - 1.4142* a3 - 'a2 !
	a0 a3 2dup + 't0 ! - 't3 !
	a1 a2 2dup + 't1 ! - 't2 !
	1 over ]inq@* 't4 !
	3 over ]inq@* 't5 !
	5 over ]inq@* 't6 !
	7 over ]inq@* 't7 !
	t6 t5 2dup + 'a3 ! - 'a0 !
	t4 t7 2dup + 'a1 ! - 'a2 !
	a1 a3 + 't7 !
	a0 a2 + 1.8477*
	a0 -2.613* over + t7 - 't6 !
	a1 a3 - 1.4142* t6 - 't5 !
	a2 1.0823* swap - t5 + 't4 !
	dup 2 << 'tempw + >a
	t0 t7 + a!+ 28 a+ t1 t6 + a!+ 28 a+
	t2 t5 + a!+ 28 a+ t3 t4 - a!+ 28 a+
	t3 t4 + a!+ 28 a+ t2 t5 - a!+ 28 a+
	t1 t6 - a!+ 28 a+ t0 t7 - a!
	;

:pass1 | col -- col
	dup 2 << 'tempa + 32 +
	@+ 1? ( 2drop pass1f ; ) drop
	@+ 1? ( 2drop pass1f ; ) drop
	@+ 1? ( 2drop pass1f ; ) drop
	@+ 1? ( 2drop pass1f ; ) drop
	@+ 1? ( 2drop pass1f ; ) drop
	@+ 1? ( 2drop pass1f ; ) drop
	@ 1? ( drop pass1f ; ) drop
	0 over ]inq@* over 2 << 'tempw + >a
	dup a!+ 28 a+ dup a!+ 28 a+ dup a!+ 28 a+
	dup a!+ 28 a+ dup a!+ 28 a+ dup a!+ 28 a+
	dup a!+ 28 a+ a! ;


:]out | out col val x y
	swap 3 << + 2 << pick3 + ;

:pass2 | out col -- out col
	dup 0 ]warray @ over 4 ]warray @ 2dup + 'a0 ! - 'a1 !
	dup 2 ]warray @ over 6 ]warray @ 2dup + 'a3 ! - 1.4142* a3 - 'a2 !
	a0 a3 2dup + 't0 ! - 't3 !
	a1 a2 2dup + 't1 ! - 't2 !
	dup 5 ]warray @ over 3 ]warray @ 2dup + 'a3 ! - 'a0 !
	dup 1 ]warray @ over 7 ]warray @ 2dup + 'a1 ! - 'a2 !
	a1 a3 + 't7 !
	a0 a2 + 1.8477*
	a0 -2.613* over + t7 - 't6 !
	a1 a3 - 1.4142* t6 - 't5 !
	a2 1.0823* swap - t5 + 't4 !

	dup 5 << pick2 + >a | dup 0 ]out
	t0 t7 + 5 >> 128 + 255 clamp0max a!+
	t1 t6 + 5 >> 128 + 255 clamp0max a!+
	t2 t5 + 5 >> 128 + 255 clamp0max a!+
	t3 t4 - 5 >> 128 + 255 clamp0max a!+
	t3 t4 + 5 >> 128 + 255 clamp0max a!+
	t2 t5 - 5 >> 128 + 255 clamp0max a!+
	t1 t6 - 5 >> 128 + 255 clamp0max a!+
	t0 t7 - 5 >> 128 + 255 clamp0max a!
	;

:JPGidct | out --
	0 ( 8 <? pass1 1 + ) drop
	0 ( 8 <? pass2 1 + ) 2drop ;

|---------------
:block0
	0? ( drop 15 <>? ( 63 + ) b+ ; )
	swap b+			| a bit
	recbits			| a bitVal
	b> 'jpgzz + c@ 2 << 'tempa + !
	1 b+ ;

:JPGGetBlock | a out -- a
	swap cleartempa
	huffDC decodehuf -? ( ; )
	recbits
	dcCoef + dup 'dcCoef ! 'tempa !
	1 ( >b 	| out a i
		huffAC decodehuf		| a v
		dup 4 >> swap 15 and	| a zeros bit
		block0
		b> 64 <? ) drop
	swap JPGidct
	;

|---------------
#dcY
#dcCb
#dcCr

:QuantNum! | nro --
	1 and 8 << 'QuantTable + 'QuantNum ! ;

:huffAC! | nro --
	0? ( drop 'HuffmanAC0 'huffAC ! ; ) drop
	'HuffmanAC1 'huffAC ! ;

:huffDC! | nro --
	0? ( drop 'HuffmanDC0 'huffDC ! ; ) drop
	'HuffmanDC1 'huffDC ! ;

| Do color space conversion from YCbCr to RGB
:2rgb | y cb cr -- rgb32
	pick2 over 128 - 45 * 5 >> +
	255 clamp0max 16 <<
	pick3 pick3 128 - 11 * 5 >> -
	rot 128 - 23 * 5 >> -
	255 clamp0max 8 << or
	rot rot 128 - 57 * 5 >> +
	255 clamp0max or ;

:xyimg | x y -- adr
	imgcols * + 2 << emem + ;

:dorest | y a -- y a
	2 + 0 'bitl !
	0 'dcY ! 0 'dcCb ! 0 'dcCr ! ;

|----------------------
:n2cbcr | nro -- cb cr
	2 << dup 'CbVector + @ swap 'CrVector + @ ;

:q134
	pick4 pick2 + imgcols >=? ( drop ; )
	pick4 pick2 + imgrows >=? ( 2drop ; )
	xyimg >a
	2dup 3 << + 2 << 'YVector1 + @
	pick2 1 >> pick2 1 >> 3 << +
	n2cbcr 2rgb a! ;

:q234
	pick4 pick2 + 8 + imgcols >=? ( drop ; )
	pick4 pick2 + imgrows >=? ( 2drop ; )
	xyimg >a
	2dup 3 << + 2 << 'YVector2 + @
	pick2 1 >> 4 + pick2 1 >> 3 << +
	n2cbcr 2rgb a! ;

:q334
	pick4 pick2 + imgcols >=? ( drop ; )
	pick4 pick2 + 8 + imgrows >=? ( 2drop ; )
	xyimg >a
	2dup 3 << + 2 << 'YVector3 + @
	pick2 1 >> pick2 1 >> 4 + 3 << +
	n2cbcr 2rgb a! ;

:q434
	pick4 pick2 + 8 + imgcols >=? ( drop ; )
	pick4 pick2 + 8 + imgrows >=? ( 2drop ; )
	xyimg >a
	2dup 3 << + 2 << 'YVector4 + @
	pick2 1 >> 4 + pick2 1 >> 4 + 3 << +
	n2cbcr 2rgb a! ;

:modo34 | x y a -- x y a ;3 components (Y-Cb-Cr) 4 samplesY
	dcY 'dcCoef !
	QuantTableY QuantNum!
	HuffACTableY huffAC!
	HuffDCTableY huffDC!
	'YVector1 JPGGetBlock -? ( drop ; ) | $ffd9
	'YVector2 JPGGetBlock -? ( drop ; )
	'YVector3 JPGGetBlock -? ( drop ; )
	'YVector4 JPGGetBlock -? ( drop ; )
	dcCoef 'dcY !
	dcCb 'dcCoef !
	QuantTableCbCr QuantNum!
	HuffACTableCbCr huffAC!
	HuffDCTableCbCr huffDC!
	'CbVector JPGGetBlock -? ( drop ; )
	dcCoef 'dcCb !
	dcCr 'dcCoef !
	QuantTableCbCr QuantNum!
	'CrVector JPGGetBlock -? ( drop ; )
	dcCoef 'dcCr !
	0 ( 8 <? 0 ( 8 <? q134 1 + ) drop 1 + ) drop
	0 ( 8 <? 0 ( 8 <? q234 1 + ) drop 1 + ) drop
	0 ( 8 <? 0 ( 8 <? q334 1 + ) drop 1 + ) drop
	0 ( 8 <? 0 ( 8 <? q434 1 + ) drop 1 + ) drop ;

:bb
	imgcols <? ( rot ; ) drop
	restart 1? ( drop dorest 0 ) | y a xx
	rot 16 +
	;

:build34 | a -- a
	0 'dcY ! 0 'dcCb ! 0 'dcCr !
	0 0 ( imgrows <?		| a x y
		rot modo34 rot		| y a x
		16 + bb
		) 2drop ;

|----------------------
:q132
	pick4 pick2 + imgcols >=? ( drop ; )
	pick4 pick2 + imgrows >=? ( 2drop ; )
	xyimg >a
	2dup 3 << + 2 << 'YVector1 + @
	pick2 1 >> pick2 1 >> 3 << +
	n2cbcr 2rgb a! ;

:q232
	pick4 pick2 + 8 + imgcols >=? ( drop ; )
	pick4 pick2 + imgrows >=? ( 2drop ; )
	xyimg >a
	2dup 3 << + 2 << 'YVector2 + @
	pick2 1 >> 4 + pick2 1 >> 3 << +
	n2cbcr 2rgb a! ;

:modo32 | a -- a
	dcY 'dcCoef !
	QuantTableY QuantNum!
	HuffACTableY huffAC!
	HuffDCTableY huffDC!
	'YVector1 JPGGetBlock -? ( drop ; ) | $ffd9
	'YVector2 JPGGetBlock -? ( drop ; )
	dcCoef 'dcY !
	dcCb 'dcCoef !
	QuantTableCbCr QuantNum!
	HuffACTableCbCr huffAC!
	HuffDCTableCbCr huffDC!
	'CbVector JPGGetBlock -? ( drop ; )
	dcCoef 'dcCb !
	dcCr 'dcCoef !
	QuantTableCbCr QuantNum!
	'CrVector JPGGetBlock -? ( drop ; )
	dcCoef 'dcCr !
	0 ( 8 <? 0 ( 8 <? q132 1 + ) drop 1 + ) drop
	0 ( 8 <? 0 ( 8 <? q232 1 + ) drop 1 + ) drop ;

:bb
	imgcols <? ( rot ; ) drop
	restart 1? ( drop dorest 0 ) | y a xx
	rot 8 + ;

:build32  | a -- a
	0 'dcY ! 0 'dcCb ! 0 'dcCr !
	0 0 ( imgrows <?		| a x y
		rot modo32 rot		| y a x
		16 + bb
		) 2drop ;

|----------------------
:q131
	pick4 pick2 + imgcols >=? ( drop ; )
	pick4 pick2 + imgrows >=? ( 2drop ; )
	xyimg >a
	2dup 3 << + 2 << 'YVector1 + @
	pick2 1 >> pick2 1 >> 3 << +
	n2cbcr 2rgb a! ;

:modo31 | a -- a
	dcY 'dcCoef !
	QuantTableY QuantNum!
	HuffACTableY huffAC!
	HuffDCTableY huffDC!
	'YVector1 JPGGetBlock -? ( drop ; ) | $ffd9
	dcCoef 'dcY !
	dcCb 'dcCoef !
	QuantTableCbCr QuantNum!
	HuffACTableCbCr huffAC!
	HuffDCTableCbCr huffDC!
	'CbVector JPGGetBlock -? ( drop ; )
	dcCoef 'dcCb !
	dcCr 'dcCoef !
	QuantTableCbCr QuantNum!
	'CrVector JPGGetBlock -? ( drop ; )
	dcCoef 'dcCr !
	0 ( 8 <? 0 ( 8 <? q131 1 + ) drop 1 + ) drop ;

:bb
	imgcols <? ( rot ; ) drop
	restart 1? ( drop dorest 0 ) | y a xx
	rot 8 + ;

:build31  | a -- a
	0 'dcY ! 0 'dcCb ! 0 'dcCr !
	0 0 ( imgrows <? 		| a x y
		rot modo31 rot		| y a x
		8 + bb
		) 2drop ;

|----------------------
:q110
	pick4 pick2 + imgcols >=? ( drop ; )
	pick4 pick2 + imgrows >=? ( 2drop ; )
	xyimg >a
	2dup 3 << + 2 << 'YVector1 + @
	255 clamp0max
	dup 8 << or dup 8 << or a! ;

:modo10 | a -- a
	dcY 'dcCoef !
	QuantTableY QuantNum!
	HuffACTableY huffAC!
	HuffDCTableY huffDC!
	'YVector1 JPGGetBlock -? ( drop ; ) | $ffd9
	dcCoef 'dcY !
	0 ( 8 <? 0 ( 8 <? q110 1 + ) drop 1 + ) drop ;

:bb
	imgcols <? ( rot ; ) drop
	restart 1? ( drop dorest 0 ) | y a xx
	rot 8 + ;

:build10  | a -- a
	0 'dcY ! 0 'dcCb ! 0 'dcCr !
	0 0 ( imgrows <?		| a x y
		rot modo10 rot		| y a x
		8 + bb
		) 2drop ;

|----------------------
:buildimg
	0 'bitl !
	NumComp 4 << SamplesY or
	$34 =? ( drop build34 ; )
	$32 =? ( drop build32 ; )
	$31 =? ( drop build31 ; )
	$10 =? ( drop build10 ; )
	drop ;

:decodetype | adr v -- adr
	$ffc0 =? ( drop JPGGetImageAttr ; )
	$ffc1 =? ( drop JPGGetImageAttr ; )
	$ffc2 =? ( drop JPGGetImageAttr ; ) | progresive not work!!
	$ffc4 =? ( drop JPGGetHuffTables ; )
	$ffdb =? ( drop PGGetQuantTables ; )
	$ffdd =? ( drop readNumber 'restart ! ; )
	$ffda =? ( drop JPGGetSOS 0 ; )
	$fffe =? ( drop readComm ; )
	$ffe0 >=? ( $ffef <=? ( drop readComm ; ) )
	2drop 0 0 ;

|---------------------------------
::loadjpg | "" -- adr/0
	here swap load
	here =? ( drop 0 ; ) 'emem !
	here
	get16 $ffd8 <>? ( 2drop 0 ; ) drop
	( get16 decodetype 1? ) drop
	0? ( ; )
	buildimg drop
	here >a
	imgcols imgrows 12 << or a!+	| size
	a> emem imgcols imgrows * 2 << dup >r move
	here r> 4 + 'here +! ;

