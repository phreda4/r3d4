| bug
| PHREDA 

^r3/lib/sys.r3
^r3/lib/rand.r3
^r3/lib/print.r3
^r3/lib/trace.r3

:vxypos
	rand 32 << 32 >> 15.0 mod rand 32 << 32 >> 15.0 mod ;

#v1 #v2
|------- SHOW
:show
	cls home
	$ff00 'ink !
	" r" print over .d print cr
	cr
	v1 v2 "%f %f" print
	key
	>esc< =? ( exit )
	drop
	;

|------- BOOT
:
	vxypos 'v1 ! 'v2 !
	3 'show onshow
	;