| r3 compiler
| pass 1 - load all includes and define order of compiler
| PHREDA 2018
|----------------
^r3/lib/str.r3
^r3/lib/parse.r3
^r3/lib/trace.r3

^./r3base.r3

|----------- comments / configuration
:escom
	"WIN|" =pre 1? ( drop 4 + ; ) drop | Compila para WINDOWS

	"FULL" =pre 1? ( drop				| FULL
		1 'switchfull !
		>>cr ; ) drop
	"SCR" =pre 1? ( drop				| SCR 640 480
		4 +
		trim str>nro 'switchresx !
		trim str>nro 'switchresy !
		>>cr ; ) drop
	"MEM" =pre 1? ( drop				| MEM 640
		4 +
		trim str>nro 'switchmem !
		>>cr ; ) drop
    >>cr ;


:includepal | str car -- str'
	$7c =? ( drop escom ; )		| $7c |	 Comentario
	$3A =? ( 1 'cntdef +! )		| $3a :  Definicion
	$23 =? ( 1 'cntdef +! )		| $23 #  Variable
	1 'cnttokens +!
	$22 =? ( drop >>" ; )		| $22 "	 Cadena
	drop >>sp ;

|----------- includes
:ininc? | str -- str adr/0
	'inc ( inc> <?
		@+ pick2 =s 1? ( drop ; ) drop
		4 + ) drop 0 ;

:load.inc | str -- str new ; incluye codigo
    here over		| str here str

|	"." =pre 1? ( drop 2 + 'path "%s%w" mformat )( drop "%w" mformat )
|	'r3path "%s/%l" mformat

	"%l" mformat
|	dup slog

	load here =? ( drop 0 "File not found" dup 'error ! slog ; ) | no existe
	here
	0 rot c!+ 'here !
	;

:add.inc | src here -- src
	over inc> !+ !+ 'inc> ! ;

:includes | src --
	dup ( trimcar 1?
		( $5e =? drop | $5e ^  Include
			ininc? 0? ( drop
				load.inc 0? ( drop ; ) |no existe
				includes
				error 1? ( drop ; ) drop
				dup ) drop
			>>cr trimcar )
		includepal
		) 2drop
	add.inc ;

::r3-stage-1 | filename str -- err/0
	0 'switchfull !
	640 'switchresx	!
	480 'switchresy !
	$10 'switchmem !
	includes
	;
