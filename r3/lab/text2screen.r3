| convert text to block
| help for Cecil
| PHREDA 2021
^r3/lib/gui.r3

#ifile
#iniblock

:toline
	here iniblock -
	$7f and $40 =? ( drop ; ) | justo
	$3f and $3f swap -
	1 + ( 1? 1 - 32 ,c ) drop
	;

:charc
|	13 =? ( drop toline ; )
	10 =? ( drop toline ; )
	9 =? ( drop 32 ,c 32 ,c 32 ,c 32 ,c ; )
	32 <? ( 32 nip )
	,c
	;

:rellena
	here iniblock -
	$7ff and $400 =? ( drop ; )
	$3ff and $3ff swap -
	1 + ( 1? 1 - 32 ,c ) drop
	;

| 64x16
| 3f*f = $400
:convert
	mark
	here 'iniblock !
	ifile (
		c@+ 1?
		$ff and charc
		) drop
	rellena

	"to.blk" savemem
	empty
	;

:
	mark
	here 'ifile !
	ifile "from.txt" load
	0 swap !+ 'here !
	convert
	;

