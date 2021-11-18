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

|---- borra desordenado (mas rapido)
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

|---- borra ordenado!!
:delpo | list end now --
	dup dup 32 +
	pick3 over - 3 >> qmove
	swap 32 - dup pick3 !
	swap 32 - ;

::p.drawo | list --
	dup @+ swap @
	( over <?
		dup @+ ex 0? ( drop delpo )
		32 + ) 3drop ;

::p.nro | nro list -- adr
	4 + @ swap 5 << + ;

::p.last | nro list -- adr
	@ 32 - ;

::p.cnt | list -- cnt
	@+ swap @ | last fist
	- 5 >> ;

::p.cpy | adr 'list --
	dup @ rot 4 qmove
	32 swap +! ;

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

::p.mapi | 'vector fin ini list --
	4 + @
	rot 5 << over +
	rot 5 << rot +
	( over <?
		pick2 ex
		32 + ) 3drop ;

::p.deli | fin ini list --
	4 + @
	rot 5 << over +
	rot 5 << rot +
	( over <?
		dup delp
		32 + ) 3drop ;

::p.map2 | 'vec 'list ---
	@+ swap @
	( over <?
		dup 32 + ( pick2 <?
			pick3 ex
			32 + ) drop
		32 + ) 3drop ;
