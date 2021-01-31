| frobots
| PHREDA 2021

|MEM $fffff

^r3/lib/gui.r3
^r3/lib/input.r3
^r3/lib/fontj.r3
^r3/lib/3d.r3
^r3/lib/rand.r3
^r3/util/arr16.r3

^./r3ivm.r3
^./r3itok.r3
^./r3iprint.r3

#spad * 256
#output * 8192

#xcam 0 #ycam 0 #zcam 50.0
#objetos 0 0	| finarray iniarray

|----- draw cube -----
:3dop project3d op ;
:3dline project3d line ;

:drawboxz | z --
	-0.5 -0.5 pick2 3dop
	0.5 -0.5 pick2 3dline
	0.5 0.5 pick2 3dline
	-0.5 0.5 pick2 3dline
	-0.5 -0.5 rot 3dline ;

:drawlinez | x1 x2 --
	2dup -0.5 3dop 0.5 3dline ;

:drawcube |
	-0.5 drawboxz
	0.5 drawboxz
	-0.5 -0.5 drawlinez
	0.5 -0.5 drawlinez
	0.5 0.5 drawlinez
	-0.5 0.5 drawlinez ;

:drawbox
	0 drawboxz ;

|-----------------------
:r1 rand 32 << 32 >> 1.0 mod ;
:r10 rand 32 << 32 >> 10.0 mod ;
:r.1 rand 32 << 32 >> 0.1 mod ;
:r.01 rand 32 << 32 >> 0.01 mod ;

:v+ b@+ b> 28 - +! ;

:boink
	dup abs 20.0 >? (
		b> 20 + dup @ neg swap !	| vel
		b> 32 + dup @ neg swap !	| rot
		) drop ;

:draw1 | adr --
	>b
	mpush
	b@+ 'ink !
	b@+ boink b@+ boink b@+ boink
	mtransi
	b@+ mrotxi b@+ mrotyi b@+ mrotzi
	v+
	0.001 b> +!
	v+ v+
	v+ v+ v+
	drawcube
	mpop ;

:addobj
	'draw1 'objetos p!+ >a
	rand a!+
	0 0 0 a!+ a!+ a!+	| position
	0 0 0 a!+ a!+ a!+	| rotation
	r.1 r.1 r.1 a!+ a!+ a!+ | vpos
	r.01 r.01 r.01 a!+ a!+ a!+ | vrot
	;

|----------- Disparo
:disparo | adr --
	>b
	mpush
	-1 b> +!
	b@+ 0? ( ; ) drop
	b@+ b@+ b@+ mtransi
	b@+ mrotxi b@+ mrotyi b@+ mrotzi
	v+ v+ v+
	$ffffff 'ink !
	0.2 0.2 0.2 mscalei
|	drawcube
	drawbox
	mpop ;

:+disparo | vel ang x y --
	'disparo 'objetos p!+ >a
	$ff a!+
	0 swap rot a!+ a!+ a!+	| position
	0 0 pick2 a!+ a!+ a!+	| rotation
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
	io
	$1 and? ( 0.001 turn )
	$2 and? ( -0.001 turn )
	$4 and? ( 0.01 motor )
	$8 and? ( -0.01 motor )
	$10 and? ( 0.2 b> 24 + @ b> 4 + @+ swap @ +disparo )
	$f and 'io !
	;

:robot1 | adr --
	>b
|	keyiorobot
	IOrobot
	mpush
	b@+ 'ink !
	b@+ b@+ b@+ mtransi
	b@+ mrotxi b@+ mrotyi b@+ mrotzi
	v+ v+ v+
|	v+ v+ v+
|	drawcube
	drawbox
	mpop ;

:+robot | x y --
	'robot1 'objetos p!+ >a
	$ff00 a!+
	swap a!+ a!+  0 a!+	| position
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
|	<up> =? ( 0.1 'zcam +! )
|	<dn> =? ( -0.1 'zcam +! )
	<f1> =? ( addobj )
	>esc< =? ( exit )
	drop

	acursor ;

#vm

:main
	fontj2
	mark
	$fff vmcpu 'vm !
	vmreset
	'wsysdic syswor!
	'xsys vecsys!
	100 'objetos p.ini
	-5.0 -5.0 +robot
	-5.0 5.0 +robot
	5.0 5.0 +robot
	5.0 -5.0 +robot
	0 0 +robot
	'screen onshow ;

: main ;