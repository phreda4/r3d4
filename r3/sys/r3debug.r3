|MEM 8192  | 8MB
| r3debug
| PHREDA 2020
|------------------
^./r3base.r3
^./r3pass1.r3
^./r3pass2.r3
^./r3pass3.r3
^./r3pass4.r3

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
	"Ok" 'error ! ;

:savedebug
	mark
	error ,s ,cr
	lerror ,d ,cr
	"mem/debuginfo.db" savemem
	empty
	;

: mark
	'name "mem/main.mem" load drop
	'name r3debuginfo
	savedebug
	;

