|MEM $ffff
^r3/lib/sys.r3
^r3/lib/mem.r3
^r3/lib/print.r3
^r3/lib/sprite.r3

^r3/util/loadimg.r3

#ima1
#ima2
#ima3

:teclado
	key >esc< =? ( exit ) drop 	;

:main
	cls home
	0 0 ima2 sprite
	xypen ima1 sprite
	300 50 ima3 sprite
	teclado
	;

:
	mark
	"media/img/logo.png" loadimg 'ima1 !
	"media/img/cerezo.jpg" loadimg 'ima2 !
	"media/img/colorwheel.png" loadimg 'ima3 !
	'main onshow ;
