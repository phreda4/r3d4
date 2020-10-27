| test

^r3/lib/gui.r3

#x 20
#s "abcde"

:fillrect  | w h x y --
  xy>v >a
  ( 1? 1 -
    a> ink pick3 fill
	sw 2 << a+
    ) 2drop ;
:tt
	1? ( drop ; )
	2 + tt ;
:test1
	$ff00ff00ff00ff 10 x +  'x ! 3 ;

#v 'test1

:test2
	"hola" ( c@+ 1? swap ) x 1 'x +! x + v ex ;

:main
	cls home
	$ff00 'ink !

	"hola" emits
	cr
	0 'seed !
	16 ( 1? 1 -
		rand dup "%d " print
		sh 4 >> mod
		"%d " print cr
		) drop
	key >esc< =? ( exit ) drop
	;
:
	'main onshow
;

