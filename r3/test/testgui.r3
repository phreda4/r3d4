^r3/lib/sys.r3
^r3/lib/math.r3
^r3/lib/str.r3
^r3/lib/mem.r3
^r3/lib/print.r3
^r3/lib/input.r3
|^r3/lib/btn.r3

#k
#c

:teclado
	key
	>esc< =? ( exit )
	1? ( 'k ! ; )
	drop
	char
	1? ( 'c ! ; )
	drop
	;

#pad * 32
#pad2 * 64
#pad3 * 16

#cv 0

:vec
	1 'cv +!
	;

:main
	cls home gui
	$ff00 'ink !
	guidump
	inputdump

	cr
	$ffffff 'ink !
	"key: " print k .h print cr
	"char: " print c .h print cr

	"tx1:" print cr
	'pad 32 input cr

	"tx2:" print cr
	'pad2 64 input cr

	"tx3:" print cr
    'vec 'pad3 16 inputex cr
	cv "%d" print cr

	"cv:" print
	'cv inputint

	200 300 100 100 guibox

	$ff 'ink !
	[ $ff00 'ink ! ; ] onClick
	xr1 yr1 xr2 yr2 fillbox

	teclado
	acursor
	;

: 33 'main onshow ;
