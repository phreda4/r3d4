| tetris r3
| PHREDA 2020
|-------------------
^r3/lib/gui.r3
^r3/lib/rand.r3

#grid * 800 | 10 * 20 * 4

#colors 0 $ffff $ff $ff8040 $ffff00 $ff00 $ff0000 $800080

#pieces
	1 5 9 13
	1 5 9 8
	1 5 9 10
	0 1 5 6
	1 2 4 5
	1 4 5 6
	0 1 4 5

#rotate>
	8 4 0 0
	9 5 1 13
	10 6 2 0
	0 7 0 0

#mask
	$000 $001 $002 $003
	$100 $101 $102 $103
	$200 $201 $202 $203
	$300 $301 $302 $303

#player 0 0 0 0
#playeryx 0
#playercolor 0
#points 0
#nextpiece 0
#speed 300

:packed2xy | n -- x y
	   dup $ff and 4 << 50 +
	   swap 8 >> 4 << 100 +
	   ;

:draw_block | ( x y -- )
	2dup op
	over 15 + over pline
	over 15 + over 15 + pline
	over over 15 + pline
	pline poli ;

:visit_block | ( y x -- y x )
	a@+ 0? ( drop ; ) 'ink !
	2dup or packed2xy draw_block ;

:draw_grid | ( --- )
	'grid >a
	0 ( $1400 <?
		1 ( 11 <?
			visit_block
			1 + ) drop
		$100 + ) drop ;

:rotate_block | ( adr -- v adr  )
	dup @ 2 << 'rotate> + @ swap ;

:rotate_piece | ( --- )
	'player
	rotate_block !+
	rotate_block !+
	rotate_block !+
	rotate_block ! ;

:inmask | ( v1 -- v2)
	2 << 'mask + @ ;

:translate_block | ( v -- )
	inmask playeryx + ;

:draw_player_block | ( v -- )
		   translate_block packed2xy draw_block ;

:draw_player | ( --- )
	playercolor 'ink !
	'player
	@+ draw_player_block
	@+ draw_player_block
	@+ draw_player_block
	@ draw_player_block ;

:nthcolor | ( n -- color )
	  2 << 'colors + @ ;

:draw_nextpiece_block | ( v -- )
		      inmask 15 + packed2xy draw_block ;
	  
:draw_nextpiece
	nextpiece dup nthcolor 'ink !
	1 - 4 << 'pieces +
	@+ draw_nextpiece_block
	@+ draw_nextpiece_block
	@+ draw_nextpiece_block
	@ draw_nextpiece_block ;

:rand1.7 | -- rand1..7
    ( rand dup 16 >> xor $7 and 0? drop ) ;

:new_piece
	nextpiece
	'player
	over 1 - 4 << 'pieces +
	4 move | dst src cnt
	nthcolor 'playercolor !
	5 'playeryx !
	rand1.7 'nextpiece !
	;

:packed2gridptr | coord -- realcoord
	dup $f and 1 - | x
	swap 8 >> 10 * +
	2 << 'grid + ;

:block_collision? | pos -- 0/pos
	$1400 >? ( drop 0 ; )
	dup packed2gridptr @ 1? ( 2drop 0 ; ) drop
	$ff and
	0? ( drop 0 ; )
	10 >? ( drop 0 ; )
	;

:piece_collision? | ( v -- v/0 )
	'player
	@+ translate_block pick2 + block_collision? 0? ( nip nip ; ) drop
	@+ translate_block pick2 + block_collision? 0? ( nip nip ; ) drop
	@+ translate_block pick2 + block_collision? 0? ( nip nip ; ) drop
	@ translate_block over + block_collision? 0? ( nip ; ) drop
	;

:piece_rcollision? | ( -- 0/x )
	'player
	@+ 2 << 'rotate> + @ translate_block block_collision? 0? ( nip ; ) drop
	@+ 2 << 'rotate> + @ translate_block block_collision? 0? ( nip ; ) drop
	@+ 2 << 'rotate> + @ translate_block block_collision? 0? ( nip ; ) drop
	@ 2 << 'rotate> + @ translate_block block_collision? ;

#combo
#combop 0 40 100 300 1200

:removeline |
	'grid dup 40 + swap a> pick2 - 2 >> move>
	-1 'speed +!
	4 'combo +! ;

:testline
	'combop 'combo !
	'grid >a
	0 ( $1400 <?
		0 1 ( 11 <?
			a@+ 1? ( rot 1 + rot rot ) drop
			1 + ) drop
		10 =? ( removeline ) drop
		$100 + ) drop
	combo @ 'points +!
	;

:write_block | ( v -- )
	translate_block packed2gridptr playercolor swap ! ;

:stopped
	'player
	@+ write_block
	@+ write_block
	@+ write_block
	@ write_block
	testline
	new_piece
	;

:logic
	$100 piece_collision? 0? ( drop stopped ; )
	'playeryx +!
	;

:translate
	piece_collision? 'playeryx +! ;

:rotate
	piece_rcollision? 0? ( drop ; ) drop
	rotate_piece ;

#ntime
#dtime

:game | ( --- )
	cls home
	$ff00 'ink !
	20 20 atxy "Tetris R3" print

	$444444 'ink !
	128 70 286 96 fillrect
	166 326 62 96 fillrect

	$ffffff 'ink !
	360 100 atxy points "%d" print

	draw_grid
	draw_player
	draw_nextpiece

	msec dup ntime - 'dtime +! 'ntime !
	dtime speed >? ( dup speed - 'dtime !
		logic
		) drop

	key
	>esc< =? ( exit )
	<dn> =? ( 250 'dtime +! )
	<ri> =? ( 1 translate )
	<le> =? ( -1 translate )
	<up> =? ( rotate )
	drop ;

:start | ( --- )
	0 'points !
	300 'speed !
	msec 'ntime ! 0 'dtime !
	rerand
	rand1.7 'nextpiece !
	'game onshow
	;

: start ;
