| FLOGO
| forth logo interpreter
| PHREDA 2021
|-------------------------
|MEM $fffff

^r3/lib/gui.r3
^r3/lib/input.r3
^r3/lib/3d.r3
^r3/lib/rand.r3
^r3/lib/xfb.r3
^r3/lib/fontr.r3

^media/rft/robotoregular.rft

^r3/editor/simple-edit.r3

^./r3ivm.r3
^./r3itok.r3
^./r3iprint.r3

#codepath "r3/r3arena/flogo/"

:filename
	'codepath "%s%w.r3i" sprint ;

#spad * 256
#vm

|---- LOGO
#tpen 1			| 0-up n-grosor
#tcolor $ffffff
#tx #ty #tz
#tax #tay #taz 0.5
#xte #yte

#xcam 0 #ycam 0 #zcam 50.0

:camscreen
	omode
	xcam ycam zcam mtrans ;

|----- draw cube -----
:3dop project3d op ;
:3dline project3d line ;

:drawturtle
	-0.5 0 -0.5 3dop
	0.5 0 -0.5 3dline 0.5 0 0.5 3dline
	-0.5 0 0.5 3dline -0.5 0 -0.5 3dline
	0 1.0 0 3dline 0.5 0 0.5 3dline
	-0.5 0 0.5 3dop
	0 1.0 0 3dline 0.5 0 -0.5 3dline
	;

|----------------------------------
:error!
	'error ! ;

:turtle
	tx ty tz mtransi
	tax mrotxi tay mrotyi taz mrotzi
	tcolor 'ink !
	drawturtle ;

:needstack | cnt -- 0/error
	vmdeep >? ( "empty stack!" error! )
	0 nip ;

|-------- WORDS
:xfoward
	1 needstack 1? ( drop ; ) drop
	tcolor 'ink !
	camscreen
	tx ty tz 3dop
	taz vmpop polar 'ty +! 'tx +!
	tpen 0? ( drop ; ) drop
	xfb>
	tx ty tz 3dline
	>xfb ;

:xback
	1 needstack 1? ( drop ; ) drop
	tcolor 'ink !
	camscreen
	tx ty tz 3dop
	taz vmpop neg polar 'ty +! 'tx +!
	tpen 0? ( drop ; ) drop
	xfb>
	tx ty tz 3dline
	>xfb ;


:xleft  1 needstack 1? ( drop ; ) drop vmpop 'taz +! ;
:xright	1 needstack 1? ( drop ; ) drop vmpop neg 'taz +! ;
:xpu	0 'tpen ! ;
:xpd	1 'tpen ! ;
:xps	1 needstack 1? ( drop ; ) drop vmpop 'tpen ! ;
:xink	1 needstack 1? ( drop ; ) drop vmpop 'tcolor ! ;
:xpaper	1 needstack 1? ( drop ; ) drop vmpop 'paper ! ;
:xhome	0 'tx ! 0 'ty ! 0 'tz ! 0.5 'taz ! ;
:xcls	cls >xfb xhome ;
:xbye	exit ;

:xrand	rand vmpush ;


:xtext
	1 needstack 1? ( drop ; ) drop
	xfb>
	camscreen
	robotoregular 0.8 fontr!
	xte 'ccx ! yte 'ccy !
	vmpop code +
	( c@+ 1?
		dup fontradr remit3d
		fontrw 'ccx +!
		) 2drop
	ccx 'xte ! ccy 'yte !
	>xfb ;

:xsetxy
	2 needstack 1? ( drop ; ) drop
	vmpop 'yte !
	vmpop 'xte !
	;

#wsys "WORDS" "BYE" "HOME" "CLS" "INK" "PAPER"
"FD" "BK" "LT" "RT" "PU" "PD" "PS"
"RAND" "TEXT" "SETXY"

:xwords
	xfb>
	home
	'wbasdic ( @+ 1?		| core
		code2name emits?cr 32 emit ) 2drop
    'wsys ( dup c@ 1? drop	| sys
		dup emits?cr 32 emit >>0 ) 2drop
	code 256 + | skip stack
	( code> <?				| user
		@+ code2name emits?cr 32 emit
		@+ $ffff and + ) drop
	>xfb ;


#xsysexe 'xwords 'xbye 'xhome 'xcls 'xink 'xpaper
'xfoward 'xback 'xleft 'xright 'xpu 'xpd 'xps
'xrand 'xtext 'xsetxy

#wsysdic * 1024 | 256 words

|-------------------
:parse&run
	'spad r3i2token
	1? ( error! drop ; ) 2drop
	'msgok error!

	9 ,i
	vmresetr
	code> vmrun drop
	code> 'icode> !

	0 'spad !
	refreshfoco
	;

:printstack
	"["  print
	CODE 4 + ( NOS <=? @+ " %d" print ) drop
	CODE NOS <=? ( TOS " %d " print ) drop
	"]" print
	;

:printinfo | --
	0 rows 10 - gotoxy
	$ffff 'ink !	"FLogo " print
	$ff00 'ink ! printstack
	cr
	$ffffff 'ink !  "> " print 'spad 64 input cr
	$ff00 'ink !    error 1? ( dup print cr ) drop

	0 rows 1 - gotoxy
	"F2-Edit" print
	key
	<ret> =? ( parse&run )
	drop
	;

|-------------------
:modedit
	"scratch" filename
	edload
	edrun
	edsave

	vm
	"scratch" filename
	vmload | load and compile CODE
	;

|-------------------
:runscr
	xfb>
	fontj2
	home gui
	printinfo
	camscreen
	turtle

	key
	<f2> =? ( modedit )
	>esc< =? ( exit )
	drop
	acursor ;

:modrun
	mark
	vm
	"scratch" filename
	vmload | load CODE
	'runscr onshow
	empty
	;

|------------
|<<< BOOT <<<
|------------
:
	mark
	fontj2
	iniXFB cls >xfb
	$fff vmcpu 'vm !	| create CPU

	'wsysdic 'wsys makedicc
	'wsysdic syswor!
	'xsysexe vecsys!

	0 1 cols 1 - rows 12 - edwin edram

	modrun
	;
