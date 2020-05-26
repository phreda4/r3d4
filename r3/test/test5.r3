| test virtual stack
| PHREDA

^r3/lib/sys.r3
^r3/lib/rand.r3
^r3/lib/print.r3

^r3/lib/trace.r3

|------- SHOW
#v 1.2

:show
	cls home
	$ff00 'ink !
	" r" print over .d emits cr
	v sin .f emits cr
	cr

	$ff00ff 'ink !
	0 0 op sw sh line
	key
	>esc< =? ( exit )
	drop
	;

|------- BOOT
:
	3 'show onshow
	;