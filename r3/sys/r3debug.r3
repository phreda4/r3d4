|MEM 8192  | 8MB
| r3debug
| PHREDA 2020
|------------------
^./r3base.r3
^./r3pass1.r3
^./r3pass2.r3
^./r3pass3.r3
^./r3pass4.r3

^r3/lib/print.r3
^r3/lib/input.r3
^r3/lib/fontm.r3
^media/fntm/droidsans13.fnt

#name * 1024

::r3debuginfo | str --
	r3name
	here dup 'src !
	'r3filename
	2dup load
|	"load" slog
	here =? ( 3drop "no src" 'error ! ; )
	0 swap c!+ 'here !
	0 'error !
	0 'cnttokens !
	0 'cntdef !
	'inc 'inc> !
	r3fullmode
|	"stage 1" slog
	swap r3-stage-1
	error 1? ( drop ; ) drop
|	"stage 2" slog
	r3-stage-2
	1? ( drop ; ) drop
|	"stage 3" slog
	r3-stage-3
|	"stage 4" slog
	r3-stage-4
|	"stage ok" slog
|	"Ok" 'error !
	;

:no10place | adr
	lerror 0? ( ; )
	0 src ( pick2 <? c@+
		10 <>? ( rot 1 + rot rot )
		drop ) drop nip ;

:savedebug
	mark
	error ,s ,cr
	no10place ,d ,cr
	"mem/debuginfo.db" savemem
	empty ;

:emptyerror
 	0 0	"mem/debuginfo.db" save ;

:exitonerror
	savedebug
	|savedicc savecode
	;

|--------------------------------------------
| ventana de texto
#xcode 5
#ycode 1
#wcode 40
#hcode 20

|----- scratchpad
#outpad * 2048
#inpad * 1024

:immmodekey

	0 hcode 1 + gotoxy
	$0000AE 'ink !
	rows hcode - 1 - backlines

	$ffffff 'ink !
	'outpad text cr
	" > " emits
	'inpad 1024 input

	key
|	>esc< =? ( mode!edit )
|	<f2> =? ( mode!edit )
	drop
	;

:btnf | "" "fx" --
	sp
	$ff0000 'ink ! backprint
	$ffffff 'ink ! emits
	0 'ink ! emits
	;

:barratop
	home
	$B2B0B2 'ink ! backline
	$0 'ink ! sp 'name emits sp
	$af0000 'ink !
	"DICC" "F1" btnf
	"INSPECT" "F2" btnf
	"MEMORY" "F3" btnf
	"RUN" "F4" btnf
	"D3bug " printr
	;

:teclado
	key
	>esc< =? ( exit )

|	<ctrl> =? ( controlon ) >ctrl< =? ( controloff )
|	<shift> =? ( 1 'mshift ! ) >shift< =? ( 0 'mshift ! )

	drop

	;

:debugmain
	cls gui
	barratop
|	drawcode
	teclado
	acursor ;

: mark
	'name "mem/main.mem" load drop
	'name r3debuginfo
	error 1? ( drop exitonerror ; ) drop
	emptyerror
	'name "mem/main.mem" load drop
	'fontdroidsans13 fontm
	'debugmain onshow
	;

