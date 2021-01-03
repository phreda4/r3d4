| Super console
| PHREDA 2021
^r3/lib/gui.r3
^r3/lib/fontpc.r3

| 80x30
#screen * 9600

#c1 $ff00
#c2 $0
#vblink

#c.x #c.y
#c.cursor
#c.atrib $ff000000

::c.ink | color --
	26 << c.atrib $00ff0000 and or 'c.atrib ! ;

::c.paper | color --
	18 << c.atrib $ff000000 and or 'c.atrib ! ;

:c.in
	c.x c.y
::c.at | x y --
	80 * + 2 <<
	'screen + 'c.cursor ! ;

:c.uscroll
	'screen 80 2 << over + 80 29 * move
	'screen 80 29 * 2 << + $3f000000 80 fill
	;

::c.cr
	0 'c.x !
	c.y 1 + 30 <? ( 'c.y ! c.in ; ) drop
	c.uscroll c.in ;

::c.emit | char --
	$ff and c.atrib or c.cursor !
	c.x 1 + 80 <? ( 'c.x ! c.in ; ) drop
	0 'c.x !
	c.y 1 + 30 <? ( 'c.y ! c.in ; ) drop
	c.uscroll c.in ;

::c.print | "" --
	sprint ( c@+ 1? c.emit ) 2drop ;

::c.cls
	'screen 'c.cursor ! 0 'c.x ! 0 'c.y !
	'screen c.atrib 80 30 * fill ;

:c.le
	c.x 0 >? ( 1 - 'c.x ! c.in ; ) drop
	80 1 - 'c.x !
	c.y 0 >? ( 1 - 'c.y ! c.in ; ) drop
	c.in ;
:c.ri
	c.x 80 <? ( 1 + 'c.x ! c.in ; ) drop
	0 'c.x !
	c.y 30 <? ( 1 + 'c.y ! c.in ; ) drop
	c.in ;
:c.up
	c.y 0 >? ( 1 - 'c.y ! c.in ; ) drop
	30 1 - 'c.y !
	c.in ;
:c.dn
	c.y 30 <? ( 1 + 'c.y ! c.in ; ) drop
	0 'c.y !
	c.in ;

:uni2ascii
	$80 <? ( ; )
	dup $1f and 6 << swap 8 >> $3f and or ;

|---------------------------------------------

| better with #paleta var
| :get6paleta 2 << 'paleta + @ ;
:get6paleta | n -- col32
	0 swap
	$1 and? ( swap $f or swap )
	$2 and? ( swap $f0 or swap )
	$4 and? ( swap $f00 or swap )
	$8 and? ( swap $f000 or swap )
	$10 and? ( swap $f0000 or swap )
	$20 and? ( swap $f00000 or swap )
	drop ;

:pix | v mask -- v
	and? ( c1 a!+ ; )
	c2 a!+ ;

:2pix | v mask -- v
	and? ( c1 dup a!+ a!+ ; )
	c2 dup a!+ a!+ ;

:decodegrap
	$ffff and
	pick2 2 >> $3 and 2 << >>
	$8 2pix $4 2pix $2 2pix $1 2pix
	drop
	;

:decodechar | y -xc -- y -xc pix
	b@+
	dup 26 >> $3f and get6paleta 'c1 !
	dup 18 >> $3f and get6paleta 'c2 !
	$10000 and? ( decodegrap ; )
	0 swap $20000 and? ( nip vblink swap )
	$ff and 4 << 'font8x16 + pick3 $f and + c@ xor
	$80 pix $40 pix $20 pix $10 pix $8 pix $4 pix $2 pix $1 pix
	drop
	;

:drawline | y --
	dup 4 >> 80 2 << * 'screen + >b | nextcharline
	80 ( 1? 1 - decodechar ) drop ;

#c.prevc

:drawcon
	c.cursor dup @ dup 'c.prevc !
	$20000 or swap !
	0 blink 1? ( $ffffff or swap ) drop 'vblink !
	sw 640 - 1 >>
	sh 480 - 1 >>
	xy>v >a
	0 ( 480 <?
		drawline
		sw 640 - 2 << a+
		1 + ) drop
	c.prevc c.cursor ! ;

|-------------- draw
#xa #ya

::c.pset | x y --
	over 2 >> over 2 >> 80 * + 2 << 'screen + | adr
	rot $3 and rot $3 and 3 xor 2 << + $8000 swap >> | adr bit
	over @ $ffff and c.atrib $10000 or or	| adr bit set
	or swap !
	;

:ihline | xd yd xa --
	pick2 - 0? ( drop c.pset ; )
	-? ( rot over + rot rot neg )
	( 1? 1 - >r
		2dup c.pset
		swap 1 + swap
		r> ) 3drop ;

:ivline | x y y --
	over >? ( swap )
	( over <=?
		pick2 over c.pset
		1 + ) 3drop ;

::rline | xd yd --
	ya =? ( xa ihline ; )
	xa ya pick2 <? ( 2swap )	| xm ym xM yM
	pick2 - 1 + >r			| xm ym xM  r:canty
	pick2 - r@ 16 <</
	rot 16 << $8000 +
	rot rot r> 				|xm<<16 ym delta canty
	( 1? 1 - >r >r
		over 16 >> over pick3 r@ + 16 >> ihline
		1 + swap
		r@ + swap
		r> r> )
	4drop ;

::c.op | x y  --
	'ya ! 'xa ! ;

::c.line | x y --
	2dup rline 'ya ! 'xa ! ;

|--------------------------
:randxy
	rand 320 mod abs
	rand 120 mod abs
	;

::c.keys
	char
	1? ( uni2ascii c.emit ; )
	drop
	key
	>esc< =? ( exit )
	<f2> =? ( c.cls )
	<f3> =? ( c.uscroll )
	<f4> =? ( randxy c.op randxy c.line )
	<f5> =? ( rand c.ink )
	<ret> =? ( c.cr )

	<le> =? ( c.le )
	<ri> =? ( c.ri )
	<up> =? ( c.up )
	<dn> =? ( c.dn )
	drop
	;


:main
	drawcon
	c.keys
	;

:
	c.cls
	63 c.ink
	"r3 console" c.print c.cr
	0 ( 64 <?
		dup c.ink dup "Prueba de texto (color %d ) " c.print 1 + ) drop

	'main onshow ;