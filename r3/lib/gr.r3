| r3 lib VFRAME play
| PHREDA 2018

^r3/lib/sys.r3
^r3/lib/mem.r3
^r3/lib/math.r3
^r3/lib/rand.r3

##paper 0
##ccx 0 ##ccy 0

##xa 0 ##ya 0

::cls
  vframe paper dup 32 << or sw sh * 1 >> qfill ;

::xy>v | x y -- adr
  sw * + 2 << vframe + ;

::pset | x y --
  xy>v ink swap ! ;

::psetc | c x y --
  xy>v ! ;

::pget | x y -- c
  xy>v @ ;

:hline | xd yd xa --
  pick2 - 0? ( drop pset ; )
  -? ( rot over + rot rot neg )
  >r xy>v ink r> fill ;

:hlineo | xmin yd xmax --
  pick2 - 0? ( drop pset ; )
  >r xy>v ink r> fill ;

:vline | x1 y1 cnt
	rot rot xy>v >a
	( 1? 1 - ink a! sw 2 << a+ ) drop ;

:iline | xd yd --
  ya =? ( xa hline ; )
  xa ya
  pick2 <? ( 2swap )   | xm ym xM yM
  pick2 - 1 + >r	   | xm ym xM  r:canty
  pick2 - 0? ( drop r> vline ; )
  r@ 16 <</
  rot 16 << $8000 +
  rot rot r>           | xm<<16 ym delta canty
  ( 1? 1 - >r >r
    over 16 >> over pick3 r@ + 16 >> hline
    1 + swap
    r@ + swap
    r> r> ) 4drop ;

::bline | x y --
  2dup iline

::op | x y --
  'ya ! 'xa ! ;

::fillrect  | w h x y --
  xy>v >a
  ( 1? 1 -
    a> ink pick3 fill
	sw 2 << a+
    ) 2drop ;

#ym #xm
#dx #dy

:qf
	xm pick2 - ym pick2 - xm pick4 + hlineo
	xm pick2 - ym pick2 + xm pick4 + hlineo ;

::bellipse | x y rx ry --
	'ym ! 'xm !
	over dup * dup 1 <<		| a b c 2aa
	swap dup >a 'dy ! 		| a b 2aa
	rot rot over neg 1 << 1 +	| 2aa a b c
	swap dup * dup 1 << 		| 2aa a c b 2bb
	rot rot * dup a+ 'dx !	| 2aa a 2bb
	swap 1				| 2aa 2bb x y
	pick3 'dy +! dy a+
	xm pick2 - ym xm pick4 + hlineo
	( swap +? swap 		| 2aa 2bb x y
		a> 1 <<
		dx >=? ( rot 1 - rot rot pick3 'dx +! dx a+ )
		dy <=? ( rot rot qf 1 + rot pick4 'dy +! dy a+ )
		drop
		)
	4drop ;

::bcircle | x y r --
	dup bellipse ;

::bcircleb | x y r --
	dup 1 << 'ym ! 1 - 0
	1 'dx ! 1 'dy !
	1 ym - 'xm !
	( over <?  | x0 y0 x y
		pick3 pick2 + pick3 pick2 + pset
		pick3 pick2 - pick3 pick2 + pset
		pick3 pick2 + pick3 pick2 - pset
		pick3 pick2 - pick3 pick2 - pset
		pick3 over + pick3 pick3 + pset
		pick3 over - pick3 pick3 + pset
		pick3 over + pick3 pick3 - pset
		pick3 over - pick3 pick3 - pset
		xm
		0 <=? (
			swap 1 + swap
			dy +
			2 'dy +!
			)
		0 >? (
			rot 1 - rot rot
			2 'dx +!
			dx ym - +
			)
		'xm !
		) 4drop ;

|----
#cf #cc
#sa #sb
#herel

:spanabove | adr y x -- adr y x
	sa 0? ( drop
		2dup swap 1 - -? ( 2drop ; )
		pget cf <>? ( drop ; ) drop
		rot >a 2dup	swap 1 -
		a!+ a!+ a> rot rot
		1 'sa ! ; ) drop
	2dup swap 1 - pget cf =? ( drop ; ) drop
	0 'sa ! ;

:spanbelow | adr y x -- adr y x
	sb 0? ( drop
		2dup swap 1 + sh >=? ( 2drop ; )
		pget cf <>? ( drop ; ) drop
		rot >a 2dup swap 1 +
		a!+ a!+ a> rot rot
		1 'sb ! ; ) drop
	2dup swap 1 + pget cf =? ( drop ; ) drop
	0 'sb ! ;

:fillline | adr y x1 -- adr'
	0 'sa ! 0 'sb !
	( sw <?
		2dup swap pget cf <>? ( 3drop ; ) drop
		dup pick2 pset | adr y x
		spanabove
		spanbelow
		1 + ) 2drop ;

:firstx | y x -- y x
	( +? 2dup swap pget cf <>? ( drop 1 + ; ) drop 1 - ) 1 + ;

::floodfill | c x y --
	2dup pget pick3 =? ( 4drop ; )
	'cf ! rot 'ink !
	here dup 'herel !
	!+ !+	| x y
 	( herel >? 8 - dup @+ swap @	| adr y x
 		firstx	| adr y x1
		fillline
 		) drop ;

|-----------------------------------------
::colavg | a b -- c
	2dup xor $fefefefe and 1 >> >r or r> - ;

::col50% | c1 c2 -- c
	$fefefe and swap $fefefe and + 1 >> ;

::col25% | c1 c2 -- c
	$fefefe and swap $fefefe and over + 1 >> + 1 >> ;

::col33%  | c1 c2 -- c
	$555555 and swap $aaaaaa and or ;

::colmix | c1 c2 m -- c
	pick2 $ff00ff and
	pick2 $ff00ff and
	over - pick2 * 8 >> +
	$ff00ff and >r
	swap $ff00 and
	swap $ff00 and
	over - rot * 8 >> +
	$ff00 and r> or ;

| hsv 1.0 1.0 1.0 --> rgb

:h0 ;				|v, n, m
:h1 >r swap r> ;	|n, v, m
:h2 rot rot ;		|m, v, n
:h3 swap rot ;		|m, n, v
:h4 rot ;			|n, m, v
:h5 swap ;			|v, m, n
#acch h0 h1 h2 h3 h4 h5

::hsv2rgb | h s v -- rgb32
	1? ( 1 - ) $ffff and swap
	0? ( drop nip 8 >> dup 8 << dup 8 << or or ; ) | hvs
	rot 1? ( 1 - ) $ffff and
	dup 1 << + 1 <<	| 6*
	dup 16 >> 	| vshH
	1 na? ( $ffff rot - swap ) | vsfH
	>r $ffff and	| vsf
	1.0 pick2 - pick3 16 *>> | vsfm
	>r
	16 *>> 1.0 swap - | v (1-s*f)
	over 16 *>> r> | vnm
	r> 2 << 'acch + @ ex | rgb
	8 >> swap
	$ff00 and or swap
	8 << $ff0000 and or ;

|-----------------------------------------
::fillbox | x1 y1 x2 y2 --
	2dup op
	swap pick2 pline
	pick2 swap op
	pline poli ;

::rectbox | x1 y1 x2 y2 --
	2dup op
	over pick3 line
	2swap over swap line
	over line line ;

|------------------------------
::box.inv | w h x y --
	xy>v >a
	( 1? 1 -
		over ( 1? 1 - a@ not a!+ ) drop
		sw pick2 - 2 << a+
		) 2drop ;

::box.mix50 | w h x y --
	xy>v >a
	( 1? 1 -
		over ( 1? 1 - a@ ink col50% a!+ ) drop
		sw pick2 - 2 << a+
		) 2drop ;

::box.noise | w h x y --
	xy>v >a
	( 1? 1 -
		over ( 1? 1 - rand8 a!+ ) drop
		sw pick2 - 2 << a+
		) 2drop ;

|--------------------------------
:2sort | x y -- max min
	over >? ( swap ) ;

:dot
	dup msec 5 >> +
	%100 an? ( drop 4 a+ ; ) drop
	a@ not a!+ ;

:dotvline | x y1 y2 --
	2sort
	sh >=? ( 3drop ; ) 0 max
	swap -? ( 3drop ; ) sh 1 - min
	over - 1 +
	>r xy>v >a r>
	( 1? 1 - dot sw 1 - 2 << a+ ) drop ;

:dothline | x1 x2 y --
	-? ( 3drop ; ) sh >=? ( 3drop ; )
	rot	rot 2sort
	sw >=? ( 3drop ; ) 0 max
	swap -? ( 3drop ; ) sw 1 - min
	over - 1 +
	swap rot xy>v >a
	( 1? 1 - dot ) drop ;

::box.dot | x1 y1 x2 y2 --
	pick3 pick3 pick2 dotvline
	over pick3 pick2 dotvline
	pick3 pick2 rot dothline
	swap dothline ;
