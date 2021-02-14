^r3/lib/sys.r3
^r3/lib/mem.r3
^r3/lib/str.r3
^r3/lib/print.r3

:screen
	home
	0 'ink !
	backline
	$ff00 'ink !
	over .d emits sp
	pick2 .d emits sp
	pick3 .d emits sp
	pick4 .d emits sp
	key >esc< =? ( exit ) drop
	;

::trace | --
	'screen onshow
	;

::dumpc | adr --
	16 ( 1?
		32 ( 1?
			rot c@+
			$ff and 32 <? ( drop $7e )
			emit
			rot rot 1 - ) drop
		cr 1 - ) 2drop
	waitesc ;

::dumpb | adr --
	16 ( 1?
		16 ( 1?
			rot c@+ $ff and .h print sp
			rot rot 1 - ) drop
		cr 1 - ) 2drop
	waitesc ;

::dumpd | adr --
	16 ( 1?
		8 ( 1?
			rot @+ .d emits sp
			rot rot 1 - ) drop
		cr 1 - ) 2drop
	waitesc ;

::dumpf | adr --
	16 ( 1?
		8 ( 1?
			rot @+ .f emits sp
			rot rot 1 - ) drop
		cr 1 - ) 2drop
	waitesc ;

::slog | ... --
	print cr
	ccy cch + sh >=? ( scrollup ) drop
	redraw	;

::waitkey
	update
	key 0? ( drop waitkey ; ) drop ;

::waitesp
	update
	key >esp< <>? ( drop waitesp ; ) drop ;

::clearlog
	0 0 "filelog.txt" save ;

::filelog | .. str --
	sprint count "filelog.txt" append ;