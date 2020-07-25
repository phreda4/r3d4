| teris r3
| PHREDA 2020
|-------------------
^r3/lib/gui.r3
^r3/lib/rand.r3

#playfield * 800 | 10 * 20 * 4

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

#suma
	$000 $001 $002 $003
	$100 $101 $102 $103
	$200 $201 $202 $203
	$300 $301 $302 $303

#player 0 0 0 0
#jugadors 0
#playercolor 0
#points 0
#nextpiece 0
#speed 300

:pf2screen | n -- y x
    dup $ff and 4 << 50 +
	swap 8 >> 4 << 100 +
	;

:block | x y --
	2dup op
	over 15 + over pline
	over 15 + over 15 + pline
	over over 15 + pline
	pline poli ;

:draw_block | y x -- y x
	a@+ 0? ( drop ; ) 'ink !
	2dup or pf2screen block ;

:draw_playfield
	'playfield >a
	0 ( $1400 <?
		1 ( 11 <?
			draw_block
			1 + ) drop
		$100 + ) drop ;

:r>j | ( adr -- v adr  )
	dup @ 2 << 'rotate> + @ swap ;

:rotate>_piece | ( --- )
	'player r>j !+ r>j !+ r>j !+ r>j ! ;

:j2t | ( -- )
	2 << 'suma + @ jugadors + ;

:j2f | ( v -- )
	j2t
	pf2screen
	block ;

:draw_player | ( --- )
	playercolor 'ink !
	'player @+ j2f @+ j2f @+ j2f @ j2f ;

:dpf
	2 << 'suma + @ 15 + pf2screen block ;

:draw_nextpiece
	nextpiece dup 2 << 'colors + @ 'ink !
	1 - 4 << 'pieces +
	@+ dpf @+ dpf @+ dpf @ dpf ;

:rand1.7 | -- rand1..7
    ( rand dup 16 >> xor $7 and 0? drop ) ;

:new_piece
	nextpiece
	'player
	over 1 - 4 << 'pieces +
	4 move | dst src cnt
	2 << 'colors + @ 'playercolor !
	5 'jugadors !
	rand1.7 'nextpiece !
	;

:coord2f | coord -- realcoord
	dup $f and 1 - | x
	swap 8 >> 10 * +
	2 << 'playfield + ;

:check | pos -- 0/pos
	$1400 >? ( drop 0 ; )
	dup coord2f @ 1? ( 2drop 0 ; ) drop
	$ff and
	0? ( drop 0 ; )
	10 >? ( drop 0 ; )
	;

:collision | suma -- sumareal ; 0 there was a collision
	'player
	@+ j2t pick2 + check 0? ( nip nip ; ) drop
	@+ j2t pick2 + check 0? ( nip nip ; ) drop
	@+ j2t pick2 + check 0? ( nip nip ; ) drop
	@ j2t over + check 0? ( nip ; ) drop
	;

:rcollision | -- 0/1
	'player
	@+ 2 << 'rotate> + @ j2t check 0? ( nip ; ) drop
	@+ 2 << 'rotate> + @ j2t check 0? ( nip ; ) drop
	@+ 2 << 'rotate> + @ j2t check 0? ( nip ; ) drop
	@ 2 << 'rotate> + @ j2t check ;

:j2tt
	j2t coord2f playercolor swap ! ;

#combo
#combop 0 40 100 300 1200

:removeline |
	'playfield dup 40 + swap a> pick2 - 2 >> move>
	-1 'speed +!
	4 'combo +! ;

:testline
	'combop 'combo !
	'playfield >a
	0 ( $1400 <?
		0 1 ( 11 <?
			a@+ 1? ( rot 1 + rot rot ) drop
			1 + ) drop
		10 =? ( removeline ) drop
		$100 + ) drop
	combo @ 'points +!
	;

:fixed
	'player @+ j2tt @+ j2tt @+ j2tt @ j2tt
	testline
	new_piece
	;

:logic
	$100 collision 0? ( drop fixed ; )
	'jugadors +!
	;

:translate
	collision 'jugadors +! ;

:rotate
	rcollision 0? ( drop ; ) drop
	rotate>_piece ;

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

	draw_playfield
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
