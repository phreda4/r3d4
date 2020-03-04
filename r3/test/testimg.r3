|--MEM 8192
^r3/lib/sys.r3
^r3/lib/mem.r3
^r3/lib/print.r3
^r3/lib/sprite.r3

^r3/util/loadimg.r3

#ima1
#ima2

:teclado
	key >esc< =? ( exit ) drop 	;

:main
	cls home
	xypen ima1 sprite
	teclado
	;

:
	mark
	"a1a.png" loadimg 'ima1 !
	'main onshow ;
