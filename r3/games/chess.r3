| PHREDA 2020
|-------------------
^r3/lib/gui.r3
^r3/lib/vsprite.r3

^media/vsp/chess.vsp

#i | current piece code
#player | current player: 0 - white, 8 - black
#u | position of pawn after two-square move, 0 after any other move

#cursori | source position of the move
#cursore | target position of the move

#G 120
#x 10 | just ten ;)
#M 10000
#rowsCosts ( -1 0 1 2 2 1 0 -1 ) | cost of the rows/columns

| empty,pawn,king,knight,bishop,rook,queen
#piecesCosts ( 0 99 0 306 297 495 846 ) | cost of the pieces
#piecesDraw	0 'pawn 'king 'knight 'bishop 'rook 'queen 0

#inichess (
07 07 07 07 07 07 07 07 07 07
07 07 07 07 07 07 07 07 07 07
07 21 19 20 22 18 20 19 21 07
07 17 17 17 17 17 17 17 17 07
07 00 00 00 00 00 00 00 00 07
07 00 00 00 00 00 00 00 00 07
07 00 00 00 00 00 00 00 00 07
07 00 00 00 00 00 00 00 00 07
07 25 25 25 25 25 25 25 25 07
07 29 27 28 30 26 28 27 29 07
07 07 07 07 07 07 07 07 07 07
07 07 07 07 07 07 07 07 07 07
)

#board * 120

#bgcolor $666666 $999999
#piezas

:cvsprite | c v --
	swap 8 << $c or swap
	2dup ( @+ 1?
		$c =? ( pick2 pick2 4 - ! )
		drop ) 3drop
	dup vsprite
	( @+ 1? $ffffffff and | fetch 32 bit with sign but compare to 32b in 64b number (no sign)
		pick2 =? ( $c pick2 4 - ! )
		drop ) 3drop ;

:rect | ancho alto x y --
	2swap >r >r
	2dup op over r> + over 2dup line r@ + line
	2dup r> + line line ;

:drcolor
	blink 1? ( drop $ff0000 'ink ! ; )
	drop $ff00 'ink ! ;

:drawcursor
	drcolor
	over 6 << 32 + pick3 6 << 32 + 63 dup 2swap
	rect ;

:vfill | ancho alto x y --
	2swap >r >r
	2dup op over r> + over 2dup pline r@ + pline
	2dup r> + pline pline poli ;

:colcell
	$8 and? ( $ffffff ; )
	$101010 ;

:cellbox | b y x -- b y x
	2dup + 1 and 2 << 'bgcolor + @ 'ink !
	over 6 << 32 +
	over 6 << 32 + swap
	64 dup 2over vfill
	32 + swap 32 + swap vspos
	rot
	cursori =? ( drawcursor )
	c@+ colcell swap
	$7 and 2 << 'piecesDraw + @
	0? ( 2drop rot rot ; )
	cvsprite rot rot ;

:drawboard
	64 dup vsize | size vsprite
	'board 21 +
	0 ( 8 <?
		0 ( 8 <?
			cellbox
			1 + ) drop
		swap 2 + swap
		1 + ) 2drop ;

|-----------------------------
#mbpawn ( 9 11 10 20 9 0 )
#mking ( -1 1 -10 10 -11 -9 9 11 0 )
#mknight ( -21 -19 -12 -8 8 12 19 21 0 )
#mbishop ( -11 -9 9 11 0 )
#mrook ( -1 1 -10 10 0 )
#mqueen ( -1 1 -10 10 -11 -9 9 11 0 )
#mwpawn ( -9 -11 -10 -20 0 )

#moves 'mbpawn 'mking 'mknight 'mbishop 'mrook 'mqueen

:moveforpiece | piece -- list
	dup
	$f and 9 =? ( 2drop 'mwpawn ; ) drop
	$7 and 1 - 2 << 'moves + @ ;


:execmove
	;

:undomove
	;

:searchmove
	;

|-----------------------------
:enmouse | -- board
	xypen
	32 - 6 >> -? ( 2drop ; ) 7 >? ( 2drop ; ) swap
	32 - 6 >> -? ( 2drop ; ) 7 >? ( 2drop ; ) swap
	10 * + 21 +
	'board +
	;


:click
	enmouse
	dup c@
	player xor $f and
	8 >? ( drop 'cursori ! ; )
	cursori 0? ( 3drop ; ) drop
	8 >? ( 2drop ; )
	drop 'cursore !
	cursori c@ $f and	| piece
	9 <? ( drop ; )
	drop
	;

:iniboard
	'board 'inichess 30 move ;

:dump
	$ff00 'ink !
	dup "%d" print cr
	cursori "%h " print
	cr
	cursore "%h " print cr
	cursori 0? ( drop ; )
	c@ "%d" print
	;

:main
	cls home
	drawboard
	guiAll
	'click onClick
	dump
	key
	>esc< =? ( exit )
	drop
	acursor ;

: mark iniboard 'main onshow ;
