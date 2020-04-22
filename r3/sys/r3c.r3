|MEM 8192  | 8MB
| r3 compiler
| PHREDA 2019
|------------------
^./r3base.r3
^./r3pass1.r3
^./r3pass2.r3
^./r3pass3.r3
^./r3pass4.r3
^./r3gencod.r3
^./r3gendat.r3

:r3-genset
	mark
	";---r3 setings" ,ln
	switchresx "XRES equ %d" ,format ,cr
	switchresy "YRES equ %d" ,format ,cr
	switchfull "FULL equ %d" ,format ,cr
	switchmem "MEMSIZE equ 0x%h" ,format ,cr
	0 ,c
	"asm/set.asm"
	savemem
	empty ;

::r3c | str --
	r3name
	here dup 'src !
	'r3filename

	dup "load %s" slog

	2dup load | "fn" mem
	here =? ( "no src" slog ; )
	0 swap c!+ 'here !
	0 'error !
	0 'cnttokens !
	0 'cntdef !
	'inc 'inc> !
	" pass1" slog
	swap r3-stage-1
	error 1? ( "ERROR %s" slog ; ) drop
	cntdef cnttokens "toks:%d def:%d" slog
	" pass2" slog
	r3-stage-2
	1? ( "ERROR %s" slog ; ) drop
	code> code - 2 >> "..code:%d" slog
	" pass3" slog
	r3-stage-3
	" pass4" slog
	r3-stage-4
	" genset" slog
	r3-genset
	" gencode" slog
	r3-gencode
	" gendata" slog
	r3-gendata
	;

: mark
	cls
	$ff00 'ink ! " PHREDA - 2019" print cr
	$ff0000 'ink ! " r3 compiler" print cr
	$ffffff 'ink !
	redraw

	"r3/test/test.r3"
|	"r3/test/testgui.r3"
	r3c

|    "asm\fasm.exe asm\r3fasm.asm > log.asm" sys
    "asm\fasm.exe asm\r3fasm.asm" sys
	waitesc
	;

