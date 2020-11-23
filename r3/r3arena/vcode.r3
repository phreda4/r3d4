|SCR 1280 720
|MEM $1ffff 64MB
||FULL

^r3/lib/gui.r3
^r3/lib/parse.r3
^r3/lib/fontr.r3

^media/rft/robotobold.rft


#vcode
#vcode>

:teclado
	key
	>esc< =? ( exit )
	drop
	;

:main
	cls home
	robotobold 100 fontr!
	$ff00 'ink !
	100 100 atxy
	"1 dup" print cr
	teclado
	;

:mm
	mark
	here dup 'vcode ! 'vcode> !
	$ffff 'here +!
	;

: mm 'main onshow ;