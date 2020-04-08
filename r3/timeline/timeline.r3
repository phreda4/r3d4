| About timeline
| PHREDA 2020
|------------------
|MEM $fff

^r3/lib/gui.r3
^r3/lib/rand.r3
^r3/util/arr8.r3

#screen 0 0
#fx 0 0

#fxp 0 0

|------ tiempo
#prevt
#timenow

:itime
	msec 'prevt ! 0 'timenow ! ;

:dtime
	msec dup prevt - 'timenow +! 'prevt ! ;

|------ linea de tiempo
#timeline 0
#timeline< 0
#timeline> 0

:itline
	timeline
	dup 'timeline> !
	'timeline< !
	;

:searchless | time adr --time adr
	( 16 - timeline >=?
		dup @	| time adr time
		pick2 <=? ( drop 16 + ; )
		drop ) 16 + ;

:+tline	| 'fx 'scr event time --
	1000 *.
	timeline> searchless | adr
	dup dup 16 + swap timeline> over - 2 >> move>
	>a a!+ a!+ a!+ a!
	16 'timeline> +! ;

:tictline
	timeline< timenow
	( over
		timeline> =? ( 'timeline< ! 2drop ; )
		@ >?
		swap
		dup 4 + @ ex
		16 + swap ) drop
	'timeline< ! ;

:dumptline
	timeline
	( timeline> <?
		timeline< =? ( "> " print )
		@+ "%d " print
		@+ "%d " print
		@+ "%d " print
		@+ "%d " print cr
		) drop ;

|------ duracion convertida
:a
|	>a
|	timenow a@+ - a@+ *. | 0--1.0
|	1.0 >=? ( drop setlastcoor 0 ; )
|	Bac_InOut

	;

:+evento
	;


|-----------------------------
:xy2 | int -- x y
	dup 48 << 48 >> swap 16 >> ;

:2xy | x y -- int
	16 >> $ffff and swap $ffff and or ;

:drawbox
	>b
	b@+ -? ( drop ; ) drop
	b@+ xy2 b@+ xy2 b@+ 'ink !
	fillbox ;

:+box | color x1 y1 x2 y2 --
	'drawbox 'screen p!+ >a
	-1 a!+
	2swap
	16 << swap $ffff and or a!+
	16 << swap $ffff and or a!+
	a!+
	;

|-----------------------------
:getscr | -- adrlast
	'screen p.last ;

:getfx | -- adrlast
	'fxp p.last ;

|-----------------------------
:evt.on | adr -- adr
	dup 8 + @ 4 + 0 swap ! ;

:+fx.on | sec --
	>r 0 getscr 'evt.on r> +tline ;


:evt.off
	dup 8 + @ 4 + -1 swap ! ;

:+fx.off | sec --
	>r 0 getscr 'evt.off r> +tline ;

#t0
:interpola
	dup 48 << 48 >> swap 16 >> t0 *. + ;

:fxanimbox-lin | screena --
	>a
	timenow a@+ - a@+ *.
	1.0 >=? ( drop 0 ; )
	't0 !
	a@+ >b
	a@+ interpola $ffff and a@+ interpola 16 << or b!+
	a@+ interpola $ffff and a@+ interpola 16 << or b!+
	;


:evt.lin |
	dup 8 + @ | scr
	over 12 + @ | scr fxp
	2drop
	;

:+fx.lin | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a
	a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.lin r> +tline ;


:evt.2bou |
	;

:+fx.2bou | xy1 xy2 xy1f xy2f duracion inicio --
	>r
	'fxp p! >a
	a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.lin r> +tline	;

|-----------------------------
:event1
	$ff0000 10 10 40 40 +box ;
:event2
	$ff00 40 40 140 70 +box ;
:event3
	$ff 200 210 240 280 +box ;


:timeline! | --
	'screen p.clear
	'fx p.clear

	$ff00 40 40 140 70 +box
	1.0 +fx.on
	10 10 2xy 40 40 2xy 100 100 2xy 200 200 2xy 1.2 2.0 +fx.lin
	100 100 2xy 200 200 2xy 10 10 2xy 40 40 2xy 1.2 3.0 +fx.2bou
	4.2 +fx.off
	5.0 +fx.on
	6.0 +fx.off

	$ff 200 210 240 280 +box
	3.0 +fx.on
	200 200 2xy 210 210 2xy 400 200 2xy 180 180 2xy 3.0 3.0 +fx.lin
	5.0 +fx.off

	$ff0000 10 10 40 40 +box
	0.0 +fx.on
	-100 100 2xy 0 200 2xy 0 100 2xy 100 200 2xy 0.5 0.0 +fx.2bou
	6.0 +fx.off
	;

|-----------------------------

:main
	cls home

	dtime
	tictline


	$ff00 'ink !
	"timeline " print
	timenow "%d" print cr

|	dumptline
|	[ dup @+ "%h " print @ "%d" print  cr ; ] 'screen p.mapv cr


	key
	<f1> =? ( itline timeline! itime )

	>esc< =? ( exit )
	drop

	'screen p.drawo
	'fx p.draw
	;


:memory
	mark
	here 'timeline !
	$ffff 'here +!
	1024 'screen p.ini
	1024 'fx p.ini
	1024 'fxp p.ini

	itline
	;

: memory 'main onShow ;