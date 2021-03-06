| convert block to text
| help for Cecil
| PHREDA 2021
^r3/lib/gui.r3

#ifile
#efile
#iniblock

:readline | adr -- adr'
	64 ( 1? 1 -
		swap c@+ 0? ( drop 1 - ; )
		,c swap ) drop ;

:trimback |--
	here 64
	( 1? 1 - swap
		1 - dup c@ 32 <>? ( drop 1 + 'here ! drop ; )
		drop swap ) drop 'here ! ;

| 64x16
| 3f*f = $400
:convert
	mark
	here 'iniblock !
	ifile ( efile <?
		readline
		trimback
		13 ,c 10 ,c
		) drop

	"to.txt" savemem
	empty
	;

:
	mark
	here 'ifile !
	ifile "from.blk" load
	( 1 - dup c@ 32 =? drop ) drop | remove 32 from last
	1 +
	dup 'efile !
	0 swap !+ 'here !
	convert
	;

