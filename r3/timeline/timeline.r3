| About timeline
| framerate independient event animation system
| PHREDA 2020
|------------------
|MEM $fff

^r3/lib/gui.r3
^r3/lib/rand.r3
^r3/lib/parse.r3
^r3/lib/sprite.r3

^r3/util/arr8.r3
^r3/util/penner.r3
^r3/util/loadimg.r3
^r3/util/textbox.r3
^r3/util/textfont.r3

#screen 0 0
#fx 0 0
#fxp 0 0

|------ tiempo
#prevt
#timenow

::timeline.start
	msec 'prevt ! 0 'timenow ! ;

:dtime
	msec dup prevt - 'timenow +! 'prevt ! ;

|------ linea de tiempo
#timeline 0
#timeline< 0
#timeline> 0

::timeline.clear
	'fxp p.clear
	'fx p.clear
	'screen p.clear
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
		timeline> =? ( 3drop ; )
		@ >?
		swap
		dup 4 + @ ex
		16 + swap ) drop
	'timeline< ! ;

:dumptline
	timeline< timeline - 4 >> "%d" print cr
	timeline
	( timeline> <?
		timeline< =? ( "> " print )
		@+ "%d " print
		@+ "%d " print
		@+ "%d " print
		@+ "%d " print cr
		) drop ;

|-------------------- LOOP
:evt.restart
	'fx p.clear
	timeline 'timeline< !
	timeline.start ;

::+restart | tiempo --
	>r 0 0 'evt.restart r> +tline ;

|-----------------------------
:xy2 | int -- x y
	dup 48 << 48 >> swap 16 >> ;

:2xy | x y -- int
	$ffff and 16 << swap $ffff and or ;

|-------------------- FILLBOX
:drawbox | adr --
	>b b@+ 1 an? ( drop ; ) 8 >> 'ink !
	b@+ xy2 b@+ xy2
	fillbox ;

::+box | x1 y1 x2 y2 color --
	'drawbox 'screen p!+ >a
	8 << 1 or a!+
	2swap
	16 << swap $ffff and or a!+
	16 << swap $ffff and or a!+
	;

|-------------------- SPRITE
:drawsprite | adr --
	>b b@+ 1 an? ( drop ; ) drop
	b@+ dup 48 << 48 >> swap 16 >>
	b@+ dup 48 << 48 >> pick3 - swap 16 >> pick2 -
	b@+ spritesize
	;

::+sprite | spr x1 y1 x2 y2 --
	'drawsprite 'screen p!+ >a
	1 a!+
	2swap
	16 << swap $ffff and or a!+
	16 << swap $ffff and or a!+
	a!+
	;

|-------------------- TEXTBOX
:drawtbox | adr --
	@+ 1 an? ( 2drop ; ) 8 >> 'ink !
	@+ dup 48 << 48 >> 'tx1 ! 16 >> 'ty1 !
	@+ dup 48 << 48 >> 'tx2 ! 16 >> 'ty2 !
	@+ int2pad
	@+
	dup 24 >> fxfont! 	| fx --
	dup 16 >> $ff and swap $ffff and
	nfont! 		| nro size --
	@+ swap @ textbox ;

| pad=llllyyxx l=interlineado pady padx 16-8-8
| font=fxfosize 8-8-16
::+textbox | "" fx/font/size pad x1 y1 x2 y2 col --
	'drawtbox 'screen p!+ >a
	8 << 1 or a!+
	2swap
	16 << swap $ffff and or a!+
	16 << swap $ffff and or a!+
	a!+	| pad
	a!+	| font
	a!+	| str
	a!+ | centrado
	;

|-------------------- SONIDO
:evt.play
	dup 8 + @ SPLAY ;

::+sound | sonido inicio --
	0 'evt.play 2swap >r swap r> +tline ;

|-------------------- EXEC
::+event | exec inicio --
	0 0 2swap +tline ;

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
	dup 8 + @ 4 + dup @ 1 not and swap ! ;

::+fx.on | sec --
	>r 0 getscr 'evt.on r> +tline ;

|-----------------------------
:evt.off
	dup 8 + @ 4 + dup @ 1 or swap ! ;

::+fx.off | sec --
	>r 0 getscr 'evt.off r> +tline ;


|...........................
:evt.box-gen | adrp --
	'fx p!+ >a
	dup 12 + @ >b | fxp
	b@+ 1000 *. a!+	| inicio
	1.0 b@+ 1000 *.u /. a!+ | tiempo
    dup 8 + @ 8 + a!+ | scr
   	b@+ b@+ |xy2f xy1f
	b@+ b@+ |xy2i xy1i
	rot getxdx a!+ getydy a!+
	swap getxdx a!+ getydy a!+
	;

:boxa-gen
	a@+ >b
	a@+ interpola $ffff and a@+ interpola 16 << or b!+
	a@+ interpola $ffff and a@+ interpola 16 << or b!+
	;

|-----------------------------
:boxanim0 | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	't0 ! boxa-gen ;

:evt.lin |
	'boxanim0 evt.box-gen ;

::+fx.lin | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.lin r> +tline ;

|-----------------------------
:boxanim1 | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Quad_In 't0 ! boxa-gen ;

:evt.1 |
	'boxanim1 evt.box-gen ;

::+fx.QuaIn | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.1 r> +tline ;

|-----------------------------
:boxanim2 | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Quad_Out 't0 ! boxa-gen ;

:evt.2 |
	'boxanim2 evt.box-gen ;

::+fx.QuaOut | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.2 r> +tline ;

|-----------------------------
:boxanim3 | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Quad_InOut 't0 ! boxa-gen ;

:evt.3 |
	'boxanim3 evt.box-gen ;

::+fx.QuaIO | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.3 r> +tline ;

|-----------------------------
:boxanim4 | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Sin_In 't0 ! boxa-gen ;

:evt.4 |
	'boxanim4 evt.box-gen ;

::+fx.SinI | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.4 r> +tline ;

|-----------------------------
:boxanim5 | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Sin_Out 't0 ! boxa-gen ;

:evt.5 |
	'boxanim5 evt.box-gen ;

::+fx.SinO | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.5 r> +tline ;

|-----------------------------
:boxanim6 | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Sin_InOut 't0 ! boxa-gen ;

:evt.6 |
	'boxanim6 evt.box-gen ;

::+fx.SinIO | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.6 r> +tline ;

|-----------------------------
:boxanim7 | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Exp_In 't0 ! boxa-gen ;

:evt.7 |
	'boxanim7 evt.box-gen ;

::+fx.ExpIn | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.7 r> +tline ;

|-----------------------------
:boxanim8 | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Exp_Out 't0 ! boxa-gen ;

:evt.8 |
	'boxanim8 evt.box-gen ;

::+fx.ExpOut | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.8 r> +tline ;

|-----------------------------
:boxanim9 | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Exp_InOut 't0 ! boxa-gen ;

:evt.9 |
	'boxanim9 evt.box-gen ;

::+fx.ExpIO | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.9 r> +tline ;

|-----------------------------
:boxanimA | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Ela_In 't0 ! boxa-gen ;

:evt.A |
	'boxanimA evt.box-gen ;

::+fx.ElaIn | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.A r> +tline ;

|-----------------------------
:boxanimB | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Ela_Out 't0 ! boxa-gen ;

:evt.B |
	'boxanimB evt.box-gen ;

::+fx.ElaOut | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.B r> +tline ;

|-----------------------------
:boxanimC | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Ela_InOut 't0 ! boxa-gen ;

:evt.C |
	'boxanimC evt.box-gen ;

::+fx.ElaIO | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.C r> +tline ;

|-----------------------------
:boxanimD | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Bac_In 't0 ! boxa-gen ;

:evt.D |
	'boxanimD evt.box-gen ;

::+fx.BacIn | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.D r> +tline ;

|-----------------------------
:boxanimE | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Bac_Out 't0 ! boxa-gen ;

:evt.E |
	'boxanimE evt.box-gen ;

::+fx.BacOut | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.E r> +tline ;

|-----------------------------
:boxanimF | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Bac_InOut 't0 ! boxa-gen ;

:evt.F |
	'boxanimF evt.box-gen ;

::+fx.BacIO | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.F r> +tline ;

|-----------------------------
:boxanimG | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Bou_Out 't0 ! boxa-gen ;

:evt.G |
	'boxanimG evt.box-gen ;

::+fx.BouOut | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.G r> +tline ;

|-----------------------------
:boxanimH | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Bou_In 't0 ! boxa-gen ;

:evt.H |
	'boxanimH evt.box-gen ;

::+fx.BouIn | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.H r> +tline ;

|-----------------------------
:boxanimI | screena --
	>a timenow a@+ - a@+ *.
	1.0 >=? ( drop setlastcoor 0 ; )
	Bou_InOut 't0 ! boxa-gen ;

:evt.I |
	'boxanimI evt.box-gen ;

::+fx.BouIO | xy1 xy2 xy1f xy2f duracion inicio --
	dup >r
	'fxp p! >a a!+ a!+ a!+ a!+ a!+ a!+
	getfx getscr 'evt.I r> +tline ;


|-----------------------------
#mario
#son

:timeline! | --
	timeline.clear

	40 40 140 70 $ff00 +box
	1.0 +fx.on
	10 10 2xy 40 40 2xy 100 100 2xy 400 400 2xy 3.0 1.0 +fx.lin
	100 100 2xy 200 200 2xy 10 10 2xy 40 40 2xy 1.2 3.0 +fx.QuaIn
	4.0 +fx.off

	mario 50 50 60 60 +sprite
	0.0 +fx.on
	10 10 2xy 60 60 2xy 100 200 2xy 290 590 2xy 4.0 0.0 +fx.QuaIO
	9.0 +fx.off

	$00 "Hola_a todos" $10d003f $0 100 100 300 300 $ff00ff +textbox
	0.0 +fx.on
	100 100 2xy 300 300 2xy 200 200 2xy 500 500 2xy 3.0 2.0 +fx.QuaOut
	9.0 +fx.off

	son 4.0 +sound

	9.5 +restart

	timeline.start
	;


#listPenner
+fx.lin +fx.QuaIn +fx.QuaOut +fx.QuaIO +fx.SinI +fx.SinO +fx.SinIO
+fx.ExpIn +fx.ExpOut +fx.ExpIO +fx.ElaIn +fx.ElaOut +fx.ElaIO +fx.BacIn
+fx.BacOut +fx.BacIO +fx.BouOut +fx.BouIn +fx.BouIO

#listPennerName
"+fx.lin" "+fx.QuaIn" "+fx.QuaOut" "+fx.QuaIO" "+fx.SinI" "+fx.SinO" "+fx.SinIO"
"+fx.ExpIn" "+fx.ExpOut" "+fx.ExpIO" "+fx.ElaIn" "+fx.ElaOut" "+fx.ElaIO" "+fx.BacIn"
"+fx.BacOut" "+fx.BacIO" "+fx.BouOut" "+fx.BouIn" "+fx.BouIO"

#nowy
#stepy

:possprite | y -- xy1f xy1t xy2f xy2t
	>r 20 r@ 2xy 20 stepy + r@ stepy + 2xy 770 r@ 2xy 770 stepy + r> stepy + 2xy ;

:makelist | name vec nro -- name' vec' nro
	rot >r
	$11 r@ $000001f $0 10 nowy 790 nowy stepy + $ff00 +textbox
	0.0 +fx.on
    r> >>0 rot >r
	mario 20 nowy 20 stepy + nowy stepy + +sprite
	0.0 +fx.on
	nowy possprite 5.0 1.0 r@ @ ex
	nowy possprite 2swap 5.0 7.0 r@ @ ex
	r> 4 + rot
	;

:exampletimeline
	timeline.clear
	sh 19 / 'stepy !
	1 'nowy !
	'listPennerName
	'listPenner
	19 ( 1? makelist stepy 'nowy +! 1 - ) 3drop

	son 6.0 +sound
	son 12.0 +sound

	12.1 +restart

|	'exit 12.1 +event

	timeline.start
	;

|-----------------------------
:debug
	t0 "%f" print cr
	dumptline
	[ dup @+ "%h " print @ "%d" print  cr ; ] 'screen p.mapv cr
	[ dup @+ "%f " print
		@+ "%f " print
		@+ xy2 "%d,%d " print
		@+ xy2 "%d,%d " print
		@+ xy2 "%d,%d " print
		@ xy2 "%d,%d " print
		cr ; ] 'fxp p.mapv cr
	;

:main
	cls
	dtime
	tictline
	'fx p.draw
	'screen p.drawo

	home fonti
	$ffffff 'ink !
	"timeline " print
	timenow "%d" print cr

	|debug

	key
	<f1> =? ( timeline! )
	<f2> =? ( exampletimeline )
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
	"media/snd/piano.wav" sload 'son !
	mario spr.alpha
|	timeline.clear
	;

: memory 'main onShow ;


