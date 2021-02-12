| frobots
| PHREDA 2021

|MEM $fffff

^r3/lib/gui.r3
^r3/lib/input.r3
^r3/lib/3d.r3
^r3/lib/rand.r3
^r3/util/arr16.r3

^r3/editor/simple-edit.r3

^./r3ivm.r3
^./r3itok.r3
^./r3iprint.r3

#codepath "r3/r3arena/flogo/"

#spad * 256

#vm

#xcam 0 #ycam 0 #zcam 50.0
#screen 0 0	| finarray iniarray

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
	-0.5 -0.5 0 3dop
	0.5 -0.5 0 3dline 0.0 0.9 0 3dline
	-0.5 -0.5 0 3dline ;

:drawshoot
	-0.1 -0.1 0 3dop
	0.1 -0.1 0 3dline 0.1 0.1 0 3dline
	-0.1 0.1 0 3dline -0.1 -0.1 0 3dline ;

:drawbackgroud
	$ffff 'ink !
	-30.0 -30.0 0 3dop
	30.0 -30.0 0 3dline 30.0 30.0 0 3dline
	-30.0 30.0 0 3dline -30.0 -30.0 0 3dline ;


|----------------------------------
:codeturtle
:coderobot | adr --
	>b
	mpush
	b@+ 'ink !
	b@+ b@+ b@+ mtransi
	b@+ mrotxi b@+ mrotyi b@+ mrotzi
	drawturtle
	mpop ;

:+turtle
	'codeturtle 'screen p!+ >a
	$ff00 a!+
	0 a!+ 0 a!+ 0 a!+
	0 a!+ 0 a!+ 0.5 a!+
	;

|----------------------------------
:error!
	drop ;

|-- crobots words
:xturn | degree --
	;

:xscan | resolution -- res
	;

:xcannon | range --
	;
:xdrive | speed --
	;
:xdamage | -- dam
	;
:xspeed | -- spe
	;
:xxyloc | -- x y
	;

|------
:xbye
	exit ;

|#wsys "BYE" "shoot" "turn" "adv" "stop"
#wsysdic $23EA6 $34A70C35 $D76CEF $22977 $D35C31 0

#xsys 'xbye |'xshoot 'xturn 'xadv 'xstop
0

|-------------------
:parserror
	;

:parse&run

|	'spad r3i2token
|	1? ( parserror ) 2drop

|	9 ,i
|	vmresetr
|	code> vmrun drop

	0 'spad !
	refreshfoco
	;

:printinfo | --
	$ffffff 'ink !
	"> " print 'spad 64 input
	key
	<ret> =? ( parse&run )
	drop
	;


:runscr
	cls home gui
	$ffff 'ink !
	" FLogo" print cr
	printinfo
	omode
	xcam ycam zcam mtrans

	'screen p.draw

	key
	>esc< =? ( exit )
	drop
	acursor ;


:modrun
	mark
	vm
	"scratch" 'codepath "%s%w.r3i" sprint
	vmload | load CODE
	'runscr onshow
	empty
	;

|-------------------
:modedit
	"stratch" 'codepath "%s%w.r3i" sprint
	edload
	edrun
	edsave
	;

:menu
	cls home gui
	$ffff 'ink !
	" FLogo " print cr

	0 rows 1 - gotoxy
	$ffffff 'ink !
	"F1-Run " print
	"F2-Edit " print
	cr

	key
	<f1> =? ( modrun )
	<f2> =? ( modedit )
	>esc< =? ( exit )
	drop
	acursor ;

:modmenu
	'menu onShow ;

: |<<< BOOT <<<
	mark
	$fff vmcpu 'vm !	| create CPU
	'wsysdic syswor!
	'xsys vecsys!
	10 'screen p.ini
	+turtle
| editor
	1 2 40 25 edwin
	edram
| menu
	modmenu
	;
