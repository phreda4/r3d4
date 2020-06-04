|test sort
| PHREDA
| from r4 lib
|-----------------------
^r3/lib/gui.r3
^r3/util/sort.r3
^r3/util/sortradix.r3

#s1 "uno"
#s2 "dos"
#s3 "tres"
#s4 "cuatro"
#s5 "cinco"
#s6 "seis"
#s7 "siete"
#s8 "ocho"
#s9 "nueve"

#listas s1 1 s2 2 s3 3 s4 4 s5 5 s6 6 s7 7 s8 8 s9 9
#lista 5 5 4 4 8 8 3 3 1 1 6 6 7 7 8 8 9 9

:test
	cls home gui $ffffff 'ink !
	over "%d" print cr
	'lista 8 ( 1? 1 - swap @+ "%d" print @+ "->%d" print cr swap ) 2drop
	cr
	'listas
	8 ( 1? 1 - swap @+ "%s " print @+ "->%d" print cr swap ) 2drop

	key
	>esc< =? ( exit )
	<f1> =? ( 8 'lista shellsort2 )
	<f2> =? ( 8 'listas sortstr )
	<f3> =? ( 8 'lista radixsort )
	drop
	;

: 33 'test onshow drop ;
