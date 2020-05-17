| test virtual stack
| PHREDA

^r3/lib/sys.r3
^r3/lib/rand.r3
^r3/lib/print.r3

^r3/lib/trace.r3

|------- SHOW
:show
	cls home
	$ff00 'ink !
	" r" print over .d emits cr
	cr

	key
	>esc< =? ( exit )
	drop
	;

|------- BOOT
:
	3 'show onshow
	;