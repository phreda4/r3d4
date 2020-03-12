| Parse words
| PHREDA 2018
|-----------------
^r3/lib/mem.r3

::>>0 | adr -- adr' ; pasa 0
	( c@+ 1? drop ) drop ;

::>>cr | adr -- adr'
	( c@+ 1? 10 =? ( drop 1 - ; ) 13 =? ( drop 1 - ; ) drop ) drop 1 - ;

::>>sp | adr -- adr'
	( c@+ 1? $ff and 33 <? ( drop 1 - ; ) drop ) drop 1 - ;

::>>" | adr -- adr'
	( c@+ 1? 34 =? ( drop c@+ 34 <>? ( drop 1 - ; ) ) drop ) drop 1 - ;

::trimcar | adr -- adr' c
	( c@+ $ff and 33 <? 0? ( swap 1 - swap ; ) drop ) ;

