| simple snake game
| PHREDA 2020

^r3/lib/gui.r3

#gs 20	| box size
#tc 20	| arena size
#px 10 #py 10	| player pos
#xv #yv			| player velocity
#ax 15 #ay 15	| fruit pos
#trail * 1024	| tail array
#trail> 'trail
#tail 5			| tail size

:pack | x y -- xy
	16 << or ;

:unpack | xy -- x y
	dup $ffff and swap 16 >> ;

:rpush | v --
	trail> !+ 'trail> ! ;

:rshift | --
	'trail dup 4 + trail> over - 2 >> move> -4 'trail> +! ;

:drawbox | x y --
	gs * swap
	gs * swap
	over gs + 2 -
	over gs + 2 -
	fillbox ;

:hit? | x y -- x y
	py <>? ( ; )
	swap px <>? ( swap ; ) swap
	5 'tail !
	;

:vlimit | v -- v
	0 <? ( drop tc 1 - ; )
	tc >=? ( drop 0 ; )
	;

:randtc | -- r
	rand tc mod abs ;

:game
	15 framelimit
	cls

	px xv + vlimit 'px !
	py yv + vlimit 'py !

	$ff 'ink !
	'trail ( trail> <?
		@+ unpack hit? drawbox ) drop

	px py pack rpush
	tail ( trail> 'trail - 2 >> <? rshift ) drop

	px ax - py ay - or 0? (
		1 'tail +! randtc 'ax ! randtc 'ay !
		) drop

	$ff0000 'ink !
	ax ay drawbox

	key
	<up> =? ( -1 'yv ! 0 'xv ! )
	<dn> =? ( 1 'yv ! 0 'xv ! )
	<le> =? ( -1 'xv ! 0 'yv ! )
	<ri> =? ( 1 'xv ! 0 'yv ! )
	>esc< =? ( exit )
	drop
	;

: 'game onshow ;