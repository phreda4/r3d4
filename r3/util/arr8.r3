| Array 8 vals
| PHREDA 2017,2018
|------
^r3/lib/mem.r3

::p.ini | cantidad list --
	here dup rot !+ ! 5 << 'here +! ;

::p.clear | list --
	dup 4 + @ swap ! ;

::p!+ | 'act list -- adr
	dup >r @ !+
	32 r> +! ;

::p! | list -- adr
	dup >r @
	32 r> +! ;

:delp | list end now -- list end- now-
	nip over @ | recalc end!!
	32 - 2dup 4 qmove
	dup pick3 !
	swap 32 - ;

::p.draw | list --
	dup @+ swap @
	( over <?
		dup @+ ex 0? ( drop delp )
		32 + ) 3drop ;

::p.nro | nro list -- adr
	4 + @ swap 5 << + ;

::p.cnt | list --
	@+ swap @ | last fist
	- 5 >> ;

::p.del | adr list --
	>a a@ 32 - 4 qmove a> dup @ 32 - swap ! ;

::p.mapv | 'vector list --
	@+ swap @
	( over <?
		pick2 ex
		32 + ) 3drop ;

::p.mapd | 'vector list --
	@+ swap @
	( over <?
		pick2 ex 0? ( drop dup delp )
		32 + ) 3drop ;

