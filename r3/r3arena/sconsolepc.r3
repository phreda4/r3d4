| Super console
| PHREDA 2021
^r3/lib/gui.r3
^r3/lib/fontpc.r3


| 80x30
#screen * 9600

#c.x #c.y
#c.cursor
#c.atrib $ff000000


::c.ink | color --
	26 <<
	c.atrib $00ff0000 and
	or 'c.atrib ! ;

::c.paper | color --
	18 <<
	c.atrib $ff000000 and
	or 'c.atrib ! ;

:c.rand
	'screen >b 80 30 * ( 1? 1 - random b!+ ) drop ;


:c.in
	c.x c.y
::c.at | x y --
	80 * + 2 <<
	'screen + 'c.cursor ! ;

:c.uscroll
	'screen
	80 2 << over +
	80 30 *
	move
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
	sprint
	( c@+ 1? c.emit ) 2drop ;


::c.cls
	'screen dup 'c.cursor !
	0 'c.x ! 0 'c.y !
	80 30 * ( 1? 1 - c.atrib rot !+ swap ) 2drop ;

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
	dup $1f and 6 <<
	swap 8 >> $3f and or ;

|--------------------------
::c.keys
	char
	1? ( uni2ascii c.emit ; )
	drop
	key
	>esc< =? ( exit )
	<f2> =? ( c.cls )
	<f3> =? ( c.uscroll )
	<ret> =? ( c.cr )

	<le> =? ( c.le )
	<ri> =? ( c.ri )
	<up> =? ( c.up )
	<dn> =? ( c.dn )
	drop
	;

|---------------------------------------------
#c1 $ff00
#c2 $0
#vblink

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

:color1
	dup 26 >> $3f and get6paleta 'c1 !
	$200000 and? ( c1 vblink xor 'c1 ! )
	;

:color2
	dup 18 >> $3f and get6paleta 'c2 !
	$200000 and? ( c2 vblink xor 'c2 ! )
	;

:decodechar | y -xc -- y -xc pix
	b@+
	color1 color2
	$10000 and? ( decodegrap ; )

	$ff and 4 << 'font8x16 + pick2 $f and + c@
	$80 pix $40 pix $20 pix $10 pix $8 pix $4 pix $2 pix $1 pix
	drop
	;

:drawline | y --
	dup 4 >> 80 2 << * 'screen + >b | nextcharline
	80 ( 1? 1 - decodechar ) drop ;

:drawcon
	0 blink 1? ( $ffffff or swap ) drop 'vblink !
	vframe >a
	 0 ( 480 <?
		drawline
		sw 640 - 2 << a+
		1 + ) drop ;

:main
	drawcon

	key
	>esc< =? ( exit )
	drop
	;

:
	c.cls
	c.rand
	$ff00 c.ink
	"r3 console" c.print c.cr
	$ff c.ink
	0 ( 64 <?
		dup c.ink "test+* " c.print 1 + ) drop

	'main onshow ;