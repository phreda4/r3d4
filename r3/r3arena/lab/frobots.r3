| frobots
| PHREDA 2021

|MEM $fffff

^r3/lib/gui.r3
^r3/lib/input.r3
^r3/lib/fontj.r3
^r3/lib/3d.r3
^r3/lib/rand.r3
^r3/util/arr16.r3

^./../r3ivm.r3
^./../r3itok.r3
^./../r3iprint.r3

#spad * 256
#output * 8192

#xcam 0 #ycam 0 #zcam 50.0
#objetos 0 0	| finarray iniarray

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

:drawtank
	-0.5 -0.5 0 3dop
	0.5 -0.5 0 3dline 0.5 0.5 0 3dline
	-0.5 0.5 0 3dline -0.5 -0.5 0 3dline
	-0.2 -0.2 0 3dop
	0.2 -0.2 0 3dline 0.0 0.9 0 3dline
	-0.2 -0.2 0 3dline ;

:drawshoot
	-0.1 -0.1 0 3dop
	0.1 -0.1 0 3dline 0.1 0.1 0 3dline
	-0.1 0.1 0 3dline -0.1 -0.1 0 3dline ;


|-----------------------
:v+ b@+ b> 28 - +! ;

|----------- Disparo
:disparo | adr --
	>b
	mpush
	-1 b> +!
	b@+ 0? ( ; ) drop
	b@+ b@+ b@+ mtransi
|	b@+ mrotxi b@+ mrotyi b@+ mrotzi | no rota balas
	12 b+
	v+ v+ v+
	$ffffff 'ink !
	drawshoot
	mpop ;

:+disparo | vel ang x y --
	'disparo 'objetos p!+ >a
	$ff a!+
	0 swap rot a!+ a!+ a!+	| position
	0 0 0 a!+ a!+ a!+	| rotation
	swap polar
	0 swap rot a!+ a!+ a!+	| vpos
	;

|----------------------------------
#io

:io!	io or 'io ! ;
:io-!	not io and 'io ! ;

:keyiorobot
|	rand 8 >> $f and 'io !
	key
	<le> =? ( 1 io! ) >le< =? ( 1 io-! )
	<ri> =? ( 2 io! ) >ri< =? ( 2 io-! )
	<up> =? ( 4 io! ) >up< =? ( 4 io-! )
	<dn> =? ( 8 io! ) >dn< =? ( 8 io-! )
	<esp> =? ( $10 io! )
	drop
	;

:motor	b> 24 + @ swap polar b> 8 + +! b> 4 + +! ;
:turn   b> 24 + +! ;

:IOrobot
	|io
	code 256 + 8 + @
	$1 and? ( 0.001 turn )
	$2 and? ( -0.001 turn )
	$4 and? ( 0.02 motor )
	$8 and? ( -0.02 motor )
	$10 and? ( 0.2 b> 24 + @ b> 4 + @+ swap @ +disparo )
	$f and code 256 + 8 +  !
	;

:coderobot | adr --
	>b
	b@+ dup vm@ ip code + vmstep code - 'ip ! vm!
	IOrobot
	mpush
	b@+ 'ink !
	b@+ b@+ b@+ mtransi
	|b@+ mrotxi b@+ mrotyi	| no rotate in x and y
	8 b+ 
	b@+ mrotzi
	drawtank
	mpop ;

:+robot | x y color "code" --
	'coderobot 'objetos p!+ >a
	$fff vmcpu	| create CPU
	dup a!+		| vm
	swap vmload | load CODE
	a!+
	swap a!+ a!+ 0 a!+	| position
	0 0 0 a!+ a!+ a!+	| rotation
	0 0 0 a!+ a!+ a!+ | vpos
	0 0 0 a!+ a!+ a!+ | vrot
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

:xshoot
	$10 io! ;
:xturn
	vmdeep 1 <? ( drop "word?" error! ; ) drop
	vmpop $3 and io! ;
:xadv
	vmdeep 1 <? ( drop "word?" error! ; ) drop
	vmpop $3 and 2 << io! ;
:xstop
	$f io-! ;



|#wsys "BYE" "shoot" "turn" "adv" "stop"
#wsysdic $23EA6 $34A70C35 $D76CEF $22977 $D35C31 0
#xsys 'xbye 'xshoot 'xturn 'xadv 'xstop

:immediate
	9 ,i | ; in the end
	vmresetr
	code> vmrun drop
	code> 'icode> !
	;

:parse&run
	'spad
|    dup c@ 0? ( 'state ! drop patchend pinput ; ) drop
	r3i2token
	state 0? ( immediate ) drop
	0 'spad ! refreshfoco
	;
|----------------------------------
:screen
	cls home gui
	$ff00 'ink !
	"r3i" print cr
	$ffffff 'ink !
	"> " print
	'spad 1024 input

	omode
	xcam ycam zcam mtrans
	'objetos p.draw

	key
	<ret> =? ( parse&run )
	>esc< =? ( exit )
	drop

	acursor ;

:main
	fontj2
	mark
	'wsysdic syswor!
	'xsys vecsys!
	100 'objetos p.ini
	-5.0 -5.0 $ff00 "r3/r3arena/test1.r3i" +robot
	-5.0 5.0 $ff0000 "r3/r3arena/test2.r3i" +robot
	5.0 -5.0 $ff "r3/r3arena/test3.r3i" +robot
|	5.0 5.0 $ff00ff "r3/r3arena/test2.r3i" +robot

	'screen onshow ;

: main ;