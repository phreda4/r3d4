|
| PHREDA 2019
^r3/lib/math.r3

#basen

:signo | str -- str signo
	dup c@
	$2b =? ( drop 1 + 0 ; )	| + $2b
	$2d =? ( drop 1 + 1 ; )	| - $2d
	drop 0 ;

:dighex | c --  dig / -1
	$3A <? ( $30 - ; )			| 0..9
	$60 >? ( $57 - $f >? ( drop -1 ) ; )			| a
	$40 >? ( $37 - $f >? ( drop -1 ) ; )			| A
	drop -1 ;

::str$>nro | adr -- adr' nro
	0 swap ( c@+ $2f >?
		dighex -? ( drop 1 - swap ; )
		rot 4 << + swap )
	drop 1 - swap ;

::str%>nro | adr -- adr' nro
	0 swap ( c@+ $2f >?
		$31 >? ( drop 1 - swap ; )
		$30 - rot 1 << + swap )
	drop 1 - swap ;

::str>nro | adr -- adr' nro ;1234 $12f %101 -12
	signo
	over c@ 33 <? ( 2drop 1 - 0 ; ) | caso + y - solos
	swap  1? ( [ neg ; ] >r ) drop
	$24 =? ( drop 1 + 16 'basen ! str$>nro ; )	| $ hexa $24
	$25 =? ( drop 1 + 2 'basen ! str%>nro ; ) 	| % bin  $25
	drop 10 'basen !
	0 swap ( c@+ $2f >? 	| 0 adr car
		$39 >? ( drop 1 - swap ; )			| 0..9
		$30 - rot 10* + swap )
	drop 1 - swap ;

|-----
::?numero | str -- 0 / str' nro 1
	str>nro over c@ 33 <? ( drop 1 ; )
	3drop 0 ;

|----- lee punto fijo ( -43.04 ==> 104 -43 t>fix16  --> $00eedddd
#parte0

::?fnumero | str -- 0/ str' fix 1		; b
	10 'basen !
	signo swap
	dup c@ 33 <? ( 3drop 0 ; ) drop
|	dup 1 + c@ que pasa con .0?
	0 ( over c@ 32 >?				| -1 str 0 dig
		$2e =? ( drop 'parte0 ! 1 over c@ ) 	| 1.33 .. parte0=1 retorna 133
	    $30 <? ( 4drop 0 ; )
	    $39 >? ( 4drop 0 ; )
	    $30 - swap 10* +
		swap 1 + swap )
	drop 1 =? ( parte0 0? ( 4drop 0 ; ) drop ) | casos -. y
	rot >r
	parte0
	16 << $10000 rot
	1 over ( 1 >? 10/ swap 10* swap ) drop
	*/ $ffff and or
	r> 1? ( drop neg 1 ; )
	drop 1 ;

::str>fix | adr -- adr' fix
	dup ?fnumero 0? ( ; ) drop
	rot drop ;
|------------------ NRO
#f | fraccion
#e | exponente

:getfrac | nro adr' char -- nro adr' char
	drop
	1 swap | nro 1 adr'
	( c@+ $2f >?
		$39 >? ( rot 'f ! ; )
		$30 - rot 10* + swap )
	rot 'f ! ;

::getnro | adr -- adr' nro
	trim
	signo
	over c@ 33 <? ( 2drop 1 - 0 ; ) | caso + y - solos
	swap 1? ( [ neg ; ] >r ) drop
	drop
	0 swap ( c@+ $2f >? 	| 0 adr car
		$39 >? ( drop 1 - swap ; )			| 0..9
		$30 - rot 10* + swap )
	drop swap ;

::str>fnro | adr -- adr fnro
	0 'f !
	trim
	signo
	over c@ 33 <? ( 2drop 1 - 0 ; ) | caso + y - solos
	swap 1? ( [ neg ; ] >r ) drop
	drop
	0 swap ( c@+ $2f >?	| 0 adr car
		$39 >? ( drop 1 - swap ; )			| 0..9
		$30 - rot 10* + swap )
	$2e =? ( getfrac )
	drop 1 - swap
	16 << $10000 f
	1 over ( 1 >? 10 / swap 10* swap ) drop
	*/ $ffff and or
	;

:gete
	$65 <>? ( ; ) drop
	getnro dup 'e ! ;

::getfenro | adr -- adr fnro
	0 'f ! 0 'e !
	trim signo
	over c@ 33 <? ( 2drop 1 - 0 ; ) | caso + y - solos
	swap 1? ( [ neg ; ] >r ) drop
	drop
	0 swap ( c@+ $2f >? 	| 0 adr car
		$39 >? ( drop 1 - swap ; )			| 0..9
		$30 - rot 10* + swap )
	$2e =? ( getfrac gete )
	drop 1 - swap
	16 << $10000 f
	1 over ( 1 >? 10 / swap 10* swap ) drop
	*/ $ffff and or
	e 0? ( drop ; )
	+? ( ( 1? 1 - swap 10* swap ) drop ; )
	( 1? 1 + swap 10 / swap ) drop
	;

|----- test solo si es numero (sin calcular)
::isHex |adr c -- 1/0
	( c@+ $2f >?
		dighex -? ( 2drop 0 ; )
		drop )
	33 <? ( 2drop 1 ; ) 2drop 0 ;

::isBin | adr -- 1/0
	( c@+ $2f >?
		$31 >? ( 2drop 0 ; )
		drop )
	33 <? ( 2drop 1 ; ) 2drop 0 ;

::isNro | adr - 1/0
	c@+
	$2b =? ( drop c@+ )		| + $2b
	$2d =? ( drop c@+ )		| - $2d
	33 <? ( 2drop 0 ; )
	$24 =? ( drop isHex ; )	| $ hexa $24
	$25 =? ( drop isBin ; ) | % bin  $25
	( $2e >=?
	|	$2f =? ( 2drop 0 ; ) |  1/2 ?? permitir fracciones?
		$39 >? ( 2drop 0 ; )
		drop c@+ )
	33 <? ( 2drop 1 ; ) 2drop 0 ;

|----------------------------------
::trim | adr -- adr'
	( c@+ 0? ( 33 + ) $ff and 33 <? drop ) drop 1 - ;

::trimc | car adr -- adr'
	( c@+ 0? pick2 =? ( drop nip 1 - ; ) drop ) drop nip 1 - ;

::trim" | adr -- adr'
	( c@+ 1? 34 =? ( drop c@+ 34 <>? ( drop 2 - ; ) ) drop ) drop 1 - ;

| prefijo?
::=pre | adr "str" -- adr 1/0
	over swap
	( c@+ 1?  | adr adr' "str" c
		toupp rot c@+ toupp rot
		<>? ( 3drop 0 ; )
		drop swap ) 3drop
	1 ;

::=s | s1 s2 -- 0/1
	( c@+ $ff and 32 >? toupp >r | s1 s2  r:c2
		swap c@+ $ff and toupp r> | s2 s1 c1 c2
		<>? ( 3drop 0 ; ) drop
		swap ) drop
	swap c@ $ff and 32 >? ( 2drop 0 ; )
	2drop 1 ;


::>>cr | adr -- adr'
	( c@+ 1? 10 =? ( drop 1 - ; ) 13 =? ( drop 1 - ; ) drop ) drop 1 - ;
