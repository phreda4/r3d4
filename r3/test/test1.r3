| test

#x 20
#s "abcde" 

:test1
	10 x +  'x ! 3 ;

#v 'test1

:test2
	x 1 'x +! x + v ex ;

: 's c@ test1 test2 ;

