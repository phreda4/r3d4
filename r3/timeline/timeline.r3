| About timeline
| PHREDA 2020
|------------------
|MEM $fff

^r3/lib/gui.r3
^r3/lib/sprite.r3
^r3/lib/rand.r3
^r3/util/arr8.r3
^r3/util/penner.r3
^r3/util/loadimg.r3

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

|-----------------------------
:xy2 | int -- x y
	dup 48 << 48 >> swap 16 >> ;

:2xy | x y -- int
	$ffff and 16 << swap $ffff and or ;

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

:drawsprite
	>b
	b@+ -? ( drop ; ) drop
	b@+ dup 48 << 48 >> swap 16 >>
	b@+ dup 48 << 48 >> pick3 - swap 16 >> pick2 -
	b@+ spritesize
	;

:+sprite | spr x1 y1 x2 y2 --
	'drawsprite 'screen p!+ >a
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

#t0
:interpola
	dup 48 << 48 >> swap 16 >> t0 *. + ;

:interlast
	dup 48 << 48 >> swap 16 >> + ;

:setlastcoor
	a@+ >b
	a@+ interlast $ffff and a@+ interlast 16 << or b!+
	a@+ interlast $ffff and a@+ interlast 16 << or b!+
	;

:getxdx | xy xy -- xy xy xdx
	over 48 << 48 >> over 48 << 48 >> over -
	16 << swap $ffff and or ;

:getydy | xy xy -- ydy
	swap 16 >> swap 16 >> over -
	16 << swap $ffff and or ;

|-----------------------------
:evt.on | adr -- adr
	dup 8 + @ 4 + 0 swap ! ;

:+fx.on | sec --
	>r 0 getscr 'evt.on r> +tline ;

|-----------------------------
:evt.off
	dup 8 + @ 4 + -1 swap ! ;

:+fx.off | sec --
	>r 0 getscr 'evt.off r> +tline ;

|-----------------------------
:boxanim0 | screena --
	>a timenow a@+ - 1.0 1000 */ a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	't0 !
	a@+ >b
	a@+ interpola $ffff and a@+ interpola 16 << or b!+
	a@+ interpola $ffff and a@+ interpola 16 << or b!+
	;

:evt.lin |
	'boxanim0 'fx p!+ >a
	dup 12 + @ >b | fxp
	b@+ 1000 *. a!+	| inicio
	1.0 b@+ /. a!+ | tiempo
    dup 8 + @ 8 + a!+ | scr
   	b@+ b@+ |xy2f xy1f
	b@+ b@+ |xy2i xy1i
	rot getxdx a!+ getydy a!+
	swap getxdx a!+ getydy a!+
	;

:+fx.lin | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a
	a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.lin r> +tline ;

|-----------------------------
:boxanim1 | screena --
	>a timenow a@+ - 1.0 1000 */ a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Bac_InOut
	't0 !
	a@+ >b
	a@+ interpola $ffff and a@+ interpola 16 << or b!+
	a@+ interpola $ffff and a@+ interpola 16 << or b!+
	;

:evt.2bou |
	'boxanim1 'fx p!+ >a
	dup 12 + @ >b | fxp
	b@+ 1000 *. a!+	| inicio
	1.0 b@+ /. a!+ | tiempo
    dup 8 + @ 8 + a!+ | scr
   	b@+ b@+ |xy2f xy1f
	b@+ b@+ |xy2i xy1i
	rot getxdx a!+ getydy a!+
	swap getxdx a!+ getydy a!+
	;

:+fx.2bou | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a
	a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.2bou r> +tline	;

|-----------------------------
#mario

:timeline! | --
	'screen p.clear
	'fx p.clear
	itline

	$ff00 40 40 140 70 +box
	1.0 +fx.on
	10 10 2xy 40 40 2xy 100 100 2xy 400 400 2xy 3.0 1.0 +fx.lin
	100 100 2xy 200 200 2xy 10 10 2xy 40 40 2xy 1.2 3.0 +fx.2bou
	4.0 +fx.off

	$ff 200 210 240 280 +box
	3.0 +fx.on
	200 200 2xy 210 210 2xy 400 200 2xy 180 180 2xy 3.0 3.0 +fx.lin
	6.0 +fx.off

	$ff0000 10 10 40 40 +box
	0.0 +fx.on
	-100 100 2xy 0 200 2xy 0 100 2xy 100 200 2xy 0.5 0.0 +fx.2bou
	6.0 +fx.off

	mario 50 50 60 60 +sprite
	0.0 +fx.on
	50 50 2xy 60 60 2xy 100 200 2xy 290 590 2xy 6.0 0.0 +fx.2bou
	18.0 +fx.off

	itime
	;

|-----------------------------
:main
	cls home

	dtime
	tictline

	'fx p.draw
	'screen p.drawo

	$ffffff 'ink !
	"timeline " print
	timenow "%d" print cr
	t0 "%f" print cr

|	dumptline
|	[ dup @+ "%h " print @ "%d" print  cr ; ] 'screen p.mapv cr
|	[ dup @+ "%f " print
|		@+ "%f " print
|		@+ xy2 "%d,%d " print
|		@+ xy2 "%d,%d " print
|		@+ xy2 "%d,%d " print
|		@ xy2 "%d,%d " print
|		cr ; ] 'fxp p.mapv cr


	key
	<f1> =? ( timeline! )
	>esc< =? ( exit )

	drop
	;


:memory
	mark
	here 'timeline !
	$ffff 'here +!
	1024 'screen p.ini
	1024 'fx p.ini
	1024 'fxp p.ini

	"media/img/lolomario.png" loadimg 'mario !
	mario spr.alpha
	itline
	;

: memory 'main onShow ;