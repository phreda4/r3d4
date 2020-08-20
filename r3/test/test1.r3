| test

^r3/lib/gui.r3

#x 20
#s "abcde" 

:test1
	$ff00ff00ff00ff 10 x +  'x ! 3 ;

#v 'test1

:test2
	"hola" ( c@+ 1? swap ) x 1 'x +! x + v ex ;

:main
	cls home
	"hola " print
	key >esc< =? ( exit ) drop
	;

:
cls
$ff 'ink !
10 10 op
400 100 line
 
'main onshow
's c@ test1 test2 
;

