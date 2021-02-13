| FLOGO
| forth logo interpreter
| PHREDA 2021
|-------------------------
|MEM $fffff

^r3/lib/gui.r3
^r3/lib/input.r3
^r3/lib/3d.r3
^r3/lib/xfb.r3

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

#xcam 0 #ycam 0 #zcam 50.0

:camscreen
	omode
	xcam ycam zcam mtrans ;

|----- draw cube -----
:3dop project3d op ;
:3dline project3d line ;

:drawboxz | z --
	-0.5 -0.5 pick2 3dop
	0.5 -0.5 pick2 3dline 0.5 0.5 pick2 3dline
	-0.5 0.5 pick2 3dline -0.5 -0.5 rot 3dline ;

:drawlinez | x1 x2 --
	2dup -0.5 3dop 0.5 3dline ;

:drawcube |
	-0.5 drawboxz 0.5 drawboxz
	-0.5 -0.5 drawlinez 0.5 -0.5 drawlinez
	0.5 0.5 drawlinez -0.5 0.5 drawlinez ;

:drawbox
	0 drawboxz ;

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

:xink
	1 needstack 1? ( drop ; ) drop
	vmpop 'tcolor ! ;

:xfoward
	1 needstack 1? ( drop ; ) drop
	xfb>
	tcolor 'ink !
	camscreen
	tx ty tz 3dop
	taz vmpop polar 'ty +! 'tx +!
	tx ty tz 3dline
	>xfb ;

:xback
	1 needstack 1? ( drop ; ) drop
	xfb>
	tcolor 'ink !
	camscreen
	tx ty tz 3dop
	taz vmpop neg polar 'ty +! 'tx +!
	tx ty tz 3dline
	>xfb ;

:xleft
	1 needstack 1? ( drop ; ) drop
	vmpop 'taz +! ;

:xright
	1 needstack 1? ( drop ; ) drop
	vmpop neg 'taz +! ;

:xhome	0 'tx ! 0 'ty ! 0 'tz ! ;
:xcls	cls >xfb xhome ;
:xbye	exit ;

#wsys "BYE" "HOME" "CLS" "INK" "FOWARD" "BACK" "LEFT" "RIGHT" 0
#xsysexe 'xbye 'xhome 'xcls 'xink 'xfoward 'xback 'xleft 'xright
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

:printinfo | --
	0 rows 10 - gotoxy
	$ffff 'ink !
	"FLogo " print cr
	$ffffff 'ink !
	cr
	"> " print 'spad 64 input cr
	$ff00 'ink !
	error 1? ( dup print ) drop
	key
	<ret> =? ( parse&run )
	drop
	;

|-------------------
:modedit
	"stratch" filename
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
	fonti
	iniXFB cls >xfb
	$fff vmcpu 'vm !	| create CPU

	'wsysdic 'wsys makedicc
	'wsysdic syswor!
	'xsysexe vecsys!

	0 1 cols 1 - rows 12 - edwin edram

	modrun
	;
