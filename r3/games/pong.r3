| Version del pong traducida a :r4 y r3
| PHREDA 2009,2020
|----------------------------------------------------------
^r3/lib/gui.r3

|-------------------------------------------
#dig0 ( %1111 %1001 %1001 %1001 %1111 )
#dig1 ( %0001 %0001 %0001 %0001 %0001 )
#dig2 ( %1111 %0001 %1111 %1000 %1111 )
#dig3 ( %1111 %0001 %1111 %0001 %1111 )
#dig4 ( %1001 %1001 %1111 %0001 %0001 )
#dig5 ( %1111 %1000 %1111 %0001 %1111 )
#dig6 ( %0001 %0001 %1111 %1001 %1111 )
#dig7 ( %1111 %0001 %0001 %0001 %0001 )
#dig8 ( %1111 %1001 %1111 %1001 %1111 )
#dig9 ( %1111 %1001 %1111 %0001 %0001 )

#digits 'dig0 'dig1 'dig2 'dig3 'dig4 'dig5 'dig6  'dig7 'dig8 'dig9

#xx #yy
#startx #starty

:** | 0/1 --
	and 1? ( 20 dup xx yy fillrect ) drop
	20 'xx +! ;

:drawd | addr --
	starty 'yy !
	5 ( 1? 1 - swap c@+ startx 'xx !
			dup %1000 ** dup %0100 ** dup %0010 ** %0001 **
			20 'yy +! swap ) 2drop ;

:drawdigit | n --
  2 << 'digits + @ drawd ;

:drawnumber | n x y --
  'starty ! 'startx !
  dup 10 / 10 mod drawdigit
  100 'startx +! 10 mod drawdigit ;

:ftoy
	sh 1 >> 16 *>> sh 1 >> + ;
:ftox
	sw 1 >> 16 *>> sw 1 >> + ;

|-------------------------------------------
#ldir #rdir
#ballx #bally
#balldx #balldy
#leftbaty 0 #rightbaty 0
#leftscore 0 #rightscore 0
#score


:doreset |( -- )
	0 'leftscore ! 0 'rightscore !
:resetball
	0 'leftbaty ! 0 'rightbaty !
	0 'ballx ! 0 'bally !
	0.01 'balldx !
	0.02 rand $10000 and? ( drop neg dup ) drop 'balldy !
	0 'score !
	;

:drawback
	cls
	$2200 'ink !
	sw 1 >> 32 - sh 16 - 2dup
	16 8 fillrect
	sw 1 >> 8 + 8 fillrect
	$ff0000 'ink !
	leftscore sw 1 >> 200 - 20 drawnumber
	20 100 10 leftbaty ftoy 50 - fillrect
	$ff 'ink !
	rightscore sw 1 >> 20 + 20 drawnumber
	20 100 sw 30 - rightbaty ftoy 50 - fillrect
	$ffffff 'ink !
	20 20
	ballx ftox 10 - bally ftoy 10 -
	fillrect
	;

:doresetball | --
	resetball
	drawback
	1000 waitms
	;

:golpe
	balldx 1.001 *. neg 'balldx !
	over 4 >> neg 'balldy +! ;

:paleta | xact xcorr ypaleta -- xact
	bally - dup abs 0.2 >? ( 3drop ; ) drop
	3 >> neg 'balldy +!
	balldx neg 1.04 *. 'balldx !
	nip ;


:juego
	drawback

	leftbaty ldir + -0.75 clampmin 0.75 clampmax 'leftbaty !
	rightbaty rdir + -0.75 clampmin 0.75 clampmax 'rightbaty !

	ballx balldx +
	-0.92 <? (
		-0.92 leftbaty paleta
		-1.0 <? ( 1 'rightscore +! 1 'score ! )
		 )
	0.92 >? (
		0.92 rightbaty paleta
		1.0 >? ( 1 'leftscore +! 1 'score ! )
		)
	'ballx !

	bally balldy +
	-0.92 <? ( -0.92 nip balldy neg 'balldy ! )
	0.92 >? ( 0.92 nip balldy neg 'balldy ! )
	'bally !

	score 1? ( doresetball ) drop
	key
	>esc< =? ( exit )
	>esp< =? ( doreset )

	<a> =? ( -0.06 'ldir ! )
	<z> =? ( 0.06 'ldir ! )
	<a> $1000 or =? ( 0 'ldir ! )
	<z> $1000 or =? ( 0 'ldir ! )
	<dn> =? ( 0.06 'rdir ! )
	<up> =? ( -0.06 'rdir ! )
	>up< =? ( 0 'rdir ! )
	>dn< =? ( 0 'rdir ! )
	drop
	;

: 	0 'paper !
	doresetball
	'juego onshow ;
