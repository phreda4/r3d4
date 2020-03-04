| LoadPng
| PHREDA 2015
|------------

#len_bits 0 0 0 0 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 0 6
#len_base 3 4 5 6 7 8 9 10 11 13 15 17 19 23 27 31 35 43 51 59 67 83 99 115 131 163 195 227 258 323
#dist_bits 0 0 0 0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 11 11 12 12 13 13
#dist_base 1 2 3 4 5 7 9 13 17 25 33 49 65 97 129 193 257 385 513 769 1025 1537 2049 3073 4097 6145 8193 12289 16385 24577
#clcidx 16 17 18 0 8 7 9 6 10 5 11 4 12 3 13 2 14 1 15

#dynsta * 1216 | (16+288)x4
#dyndta * 1216
#codetr * 1216
#lens * 320
#off * 64

#hlit
#hdist
#hclen

#bbit
#bitl

|---- bitstream
::read32 | mem -- mem c
	@+
	dup $ff and 24 << over $ff00 and 8 << or
	over $ff0000 and 8 >> or swap 24 >> $ff and or ;

::read1bit | adr -- adr bit
	bitl 0? ( drop c@+ 'bbit ! 8 )
	1 - 'bitl !
	bbit dup 1 >> 'bbit !
	1 and ;

::readnbit | adr n -- adr nro
	swap 0 >a
	bbit bitl 0 | a bb bn len
	( pick4 <? swap	| a bb len bn
    	0? ( drop nip swap c@+ rot 8 )
		1 - pick2 1 and
		pick2 << a+
		rot 1 >> swap rot 1 + ) drop
	'bitl ! 'bbit !
	nip a> ;

::readbyte | adr -- adr byte
	0 'bitl ! c@+ $ff and ;

|-----------------------------------------
:decodesym | adr dt -- adr sym
	dup 4 + >a swap
	0 0	( 					| dt a sum cur
		1 << rot read1bit		| dt sum cur a 1
		rot + rot a@+		| dt a cur sum l
		rot over -			| dt a sum l cur-l
		rot rot + swap
		+? ) | **
	+ 2 << rot 64 + + @ ;

:len1
	0? ( drop ; )
	2 << 'off + dup @  | cnt n len  off valo
	1 rot +!			| cnt n len  valo
	2 << 64 + a> +
	pick2 swap !
	;

:buildtree | cnt len table --
	dup 0 16 fill
	>a 2dup swap	| cnt len len cnt
	( 1? 1 - swap
		c@+ $ff and 2 << a> + 1 swap +! swap ) 2drop
	0 a!			| cnt len
	0 a> 'off ( 'off 64 + <?
		pick2 swap !+ | 0 r 'off
		>r @+ rot + swap r>
		) 3drop
	0 ( pick2 <? swap c@+	| cnt n len  length
		$ff and len1
		swap 1 + ) 3drop ;

:decodel
	rot swap | lenf a len n
	( 1? 1 -
		0 rot c!+ swap
		) drop
	rot swap ;

:decodeloop | lenf len a sym -- a lenf len
	16 <? ( rot c!+ rot swap ; )
	16 =? ( drop over 1 - c@ swap 2 readnbit 3 + | lenf len prev a n
			>r rot r> | lenf prev a len n
			( 1? 1 - >r
				pick2 swap c!+	| lenf prev a len+
				r> ) drop
			rot drop rot swap ; )
	17 =? ( drop 3 readnbit 3 + decodel ; ) drop
	7 readnbit 11 + decodel ;

:decodetree | a -- a
	5 readnbit 257 + 'hlit !
	5 readnbit 1 + 'hdist !
	4 readnbit 4 + 'hclen !
	0 0 0 0 0 'lens !+ !+ !+ !+ ! | 20 zeros in lens
	'clcidx >b
	hclen ( 1? 1 - swap
		3 readnbit b@+	| cnt a 3b inx
		'lens + c! swap ) drop
	19 'lens 'codetr buildtree
	'lens dup hlit hdist + + swap	| a lenf len
	( over <?
		rot 'codetr decodesym	| lenf len a sym
		decodeloop
		) 2drop
	hlit 'lens 'dynsta buildtree
	hdist 'lens hlit + 'dyndta buildtree ;

:fixtree
	'dynsta >a
	7 ( 1? 1 - 0 a!+ ) drop
	24 a!+ 152 a!+ 112 a!+ 24 a+
	0
	( 24 <? dup 256 + a!+ 1 + )
	( 168 <? dup 24 - a!+ 1 + )
	( 176 <? dup 112 + a!+ 1 + )
	( 288 <? dup 32 - a!+ 1 + )
	drop
	'dyndta >a
	5 ( 1? 1 - 0 a!+ ) drop
	32 a!+ 40 a+
	0 ( 32 <? dup a!+ 1 + )
	drop ;

:inflatesym | a sym -- a
	256 <? ( ,c ; )
	257 - 2 << swap 	| sym a
	over 'len_bits + @
	readnbit			| sym a length
	rot 'len_base + @ +	| a length
	swap 'dyndta decodesym | length a dist
	2 << swap			| length dist a
	over 'dist_bits + @
	readnbit			| length dist a off
	rot 'dist_base + @ + | length a offs
	here swap - rot 	| a here length
	( 1? 1 - swap c@+ ,c swap ) 2drop ;

:nocompress | adr -- adr
	readbyte swap readbyte 8 << rot or
	swap 2 + swap
	( 1? 1 - swap c@+ ,c swap ) drop ;

:infla
	( 'dynsta decodesym 256 <>?
		inflatesym ) drop ;

:typeinflate | adr -- adr
	2 readnbit
	0? ( drop nocompress ; )
	1 =? ( drop fixtree infla ; ) drop
	decodetree
	infla ;

|-----------
:inflate | in --
	0 'bitl !
	( read1bit 0? drop
		typeinflate
		) drop
	typeinflate drop ;

#wpng
#hpng
#dpng	| deph
#cpng	| color
#opng	| compression
#fpng	| filter
#ipng	| interlace

#key.rgb

#pxsize

#idat>
#databyte

#imem
#palsize
#pal
#img
#emem

|------ filter
#wf

:paeth2 | a b pa pb -- p
	over >=? ( 3drop ; ) 2drop nip ;

:paeth | a b c -- p
	pick2 pick2 + over - 	| a b c p
	pick3 over - abs swap	| a b c pa p
	pick3 over - abs swap	| a b c pa pb p
	pick3 - abs				| a b c pa pb pc
	pick2 >=? ( drop rot drop paeth2 ; ) | a b pa pb
	>r >r drop rot drop r> r> | b c pb pc
	paeth2 ;


:fnoneline | x y data x -- x y data
	+ ;

:fsubline | x y data x -- x y data
	pxsize - swap pxsize + swap
	( 1? 1 - swap
		dup pxsize - c@ over c+! 1 +
		swap ) drop ;

:fupline | x y data x -- x y data
	( 1? 1 - swap
		dup wf - c@ over c+! 1 +
		swap ) drop ;

:favgline | x y data x -- x y data
	pxsize ( 1? >r
		1 - swap
		dup wf - c@ $ff and 1 >> over c+! 1 + swap
		r> 1 - ) drop
	( 1? 1 - swap
		dup pxsize - c@ $ff and over wf - c@ $ff and + 1 >> over c+! 1 +
		swap ) drop ;

:favgline0 | x y data x -- x y data
	pxsize - swap pxsize + swap
	( 1? 1 - swap
		dup pxsize - c@ $ff and 1 >> over c+! 1 +
		swap ) drop ;

:fpaeline | x y data x -- x y data
	pxsize ( 1? >r
		1 - swap
		0 over wf - c@ $ff and 0 paeth
		over c+! 1 + swap
		r> 1 - ) drop
	( 1? 1 - swap
		dup pxsize - c@ $ff and
		over wf - c@ $ff and
		pick2 wf - pxsize - c@ $ff and
		paeth over c+! 1 +
		swap ) drop ;

:fpaeline0 | x y data x -- x y data
	pxsize - swap pxsize + swap
	( 1? 1 - swap
		dup pxsize - c@ $ff and 0 0
		paeth over c+! 1 +
		swap ) drop ;

#linefilter fnoneline fsubline fupline favgline fpaeline
#linefilter0 fnoneline fsubline fnoneline favgline0 fpaeline0

:unfilter | w h data -- data
	pick2 1 + 'wf !
	swap 1 - swap
	c@+ | x y data filte
	pick3 swap
	$7 and 2 << 'linefilter0 + @ ex | x y data
	swap
	( 1? 1 - swap
		c@+   | x y data filter
		pick3 swap
		$7 and 2 << 'linefilter + @ ex | x y data
		swap ) drop nip ;

#adambox $33 $33 $23 $22 $12 $11 $01 -1

:unfilteradam | --
	databyte
	'adambox >b
	( b@+ +?
		wpng over 4 >> >> pxsize *
		hpng rot $f and >>
		rot unfilter
		) 2drop ;

|------ convert
|//greyscale
:mode01 | b -- pixel ;modo 0 ; modo 0 1bits
:mode02 | b -- pixel ;modo 0 ; modo 2 1bits
:mode04 | b -- pixel ;modo 0 ; modo 4 1bits
	;
:mode08 | b -- b pixel ; modo 0 8bits
	c@+ $ff and
	key.rgb <>? ( drop $ff000000 ; )
	over 8 << dup 8 << or or or ;

|//RGB color
:mode28
	c@+ $ff and 16 << swap
	c@+ $ff and 8 <<  swap
	c@+ $ff and rot or rot or
	key.rgb <>? ( $ff000000 or ) ;

|//indexed color (palette)
:mode38
	c@+ $ff and 2 << pal + @ ;

:mode34
:mode32
:mode31
	;
|//greyscale with alpha
:mode48
	c@+ $ff and
	dup 8 << dup 8 << or or
	swap c@+ 24 << rot or ;

|//RGB with alpha
:mode68
	@+ dup $ff and 16 << over $ff0000 and 16 >> or swap $ff00ff00 and or ;

#modec

|------ interlace
| sx sy x y
#arrayadam7
$8800
$8840
$4804
$4420
$2402
$2210
$1201
0

:ppixel! | y x c -- y x
	pick2 wpng * pick2 + 2 << img + ! ;

:adam7step | v --
	dup 12 >> $f and
	over 8 >> $f and
	rot dup 4 >> $f and
	swap $f and
    databyte >a
	( hpng <?
		1 a+
		over ( wpng <?
			a> modec ex swap >a
			ppixel!
			pick4 + ) drop
		 pick2 + ) 4drop
	a> 'databyte ! ;

:convertadam7
	'arrayadam7 ( @+ 1? adam7step ) 2drop ;

:convert
	img >a
	databyte
	hpng ( 1?
		swap 1 + swap
		wpng ( 1?
			rot modec ex a!+
			rot rot 1 - ) drop
		1 - ) 2drop
	;

|-----------------------------------------
:readlen | adr -- adr len
	dup 8 - @
	dup $ff and 24 << over $ff00 and 8 << or
	over $ff0000 and 8 >> or swap 24 >> $ff and or ;

:didat | adr -- adr'
	readlen | adr len
	idat> pick2 pick2 cmove | des scr cnt
	dup 'idat> +!
	+ ;

:dplte
	readlen | adr len
	pal >a
	2dup ( +? 3 - swap
		c@+ swap c@+ swap c@+
		$ff and rot $ff and 8 << or rot $ff and 16 << or $ff000000 or
		a!+
		swap ) 2drop
	+ ;

:dtrns
	readlen | adr len
	+ ;

:readchunk | adr code -- adr'
	$54414449 =? ( drop didat ; ) | IDAT
	$45544c50 =? ( drop dplte ; ) | PLTE
	$534e5274 =? ( drop dtrns ; ) | tRNS
	drop readlen + ; | desconocido, saltea

#colchan ( 1 0 3 1 2 0 4 0 0 )
#colmode mode08 0 mode28 mode38 mode48 0 mode68

:pngheader | 'mem -- 0/mem
	12 +
	read32 'wpng !
	read32 'hpng !
	c@+ 'dpng !
	c@+
	0 'palsize !
	3 =? ( $3ff 'palsize ! )
	dup 'colchan + c@ dpng * 7 + 3 >> 'pxsize !
	dup 2 << 'colmode + @ 'modec !
	'cpng !
	c@+ 'opng !
	c@+ 'fpng !
	c@+	'ipng !

	imem 8 +
|	dup 'pal ! palsize +
	dup 'img ! wpng hpng * 2 << +
	'emem !

	img 'idat> !
	emem 'pal !
	;

:exitok
	emem 'here !
	wpng hpng 12 << or	| size
	| transparente******
	imem !
	imem
	;

|-----------------------------------------
::loadPNG | "" -- 'img/0
	'codetr 0 2 fill
	here swap load
	here =? ( drop 0 ; ) drop
	here dup 'imem !
	@+ $474e5089 <>? ( 2drop 0 ; ) drop | magic
	pngheader 0? ( ; )  | header error
	$ff000000 'key.rgb !
	( 8 + @+ $444e4549 <>?   | IEND
		readchunk ) 2drop
	emem palsize + dup 'databyte ! 'here !
	img 2 + inflate
	ipng 1? ( drop unfilteradam convertadam7 exitok ; ) drop
	wpng pxsize * hpng databyte	unfilter drop
	convert exitok ;
