^r3/lib/gui.r3

:main
	cls home
	"Hello Human!" print
	key >esc< =? ( exit ) drop
	;

: 'main onshow ;
