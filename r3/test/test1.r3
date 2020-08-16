| test

#x 20
#s "abcde" 

:test1
	$ff00ff00ff00ff 10 x +  'x ! 3 ;

#v 'test1

:test2
	"hola" ( c@+ 1? swap ) x 1 'x +! x + v ex ;

: 's c@ test1 test2 ;

