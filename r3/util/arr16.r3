| Array 16 vals
| PHREDA 2018
|------
^r3/lib/mem.r3

::p.ini | cantidad list --
	here dup rot !+ ! 6 << 'here +! ;

::p.clear | list --
	dup 4 + @ swap ! ;

::p.cnt | list -- cnt
	@+ swap @ | last fist
	- 6 >> ;

::p.nro | nro list -- adr
	4 + @ swap 6 << + ;

::p!+ | 'act list -- adr
	dup >r @ !+
	64 r> +! ;

::p! | list -- adr
	dup >r @
	64 r> +! ;

:delp | list end now -- list end- now-
	nip over @ | recalc end!!
	64 - 2dup 8 qmove
	dup pick3 !
	swap 64 - ;

::p.draw | list --
	dup @+ swap @
	( over <?
		dup @+ ex 0? ( drop delp )
		64 + ) 3drop ;

::p.del | adr list --
	>r r@ @ 64 - 8 qmove
	-64 r> +! ;
|dup @ 64 - swap ! ;

::p.mapv | 'vector list --
	@+ swap @
	( over <?
		pick2 ex
		64 + ) 3drop ;

::p.mapd | 'vector list --
	@+ swap @
	( over <?
		pick2 ex 0? ( drop dup delp )
		64 + ) 3drop ;
