
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

|------
:xbye
	exit ;


|#wsys "BYE" "shoot" "turn" "adv" "stop"
#wsysdic $23EA6 $34A70C35 $D76CEF $22977 $D35C31 0
#xsys 'xbye

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

#vm1 #vm2 #vm3

:dumpvm | adr --
	>a
	8 ( 1? 1 - a@+ $ffffffff and "%h " print ) drop
	cr
	256 a+
	4 ( 1? 1 -
		8 ( 1? 1 -
			a@+ $ffffffff and "%h " print
			) drop cr
		) drop
	;

|----------------------------------
:screen
	cls home gui
	$ff00 'ink !
	"r3i" print cr
	$ffffff 'ink !
	"> " print
	'spad 1024 input
	cr
	dumpvm
	key
	<ret> =? ( parse&run )
	>esc< =? ( exit )
	drop
	acursor ;


:main
	'wsysdic syswor!
	'xsys vecsys!

	fontj2
	mark
	$fff vmcpu 'vm1 !
	$fff vmcpu 'vm2 !
	$fff vmcpu 'vm3 !


	'screen onshow ;

: main ;