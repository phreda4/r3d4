|SCR 512 512
| Example 1

^r3/lib/gui.r3
^r3/lib/print.r3
^r3/lib/rand.r3
^r3/lib/3d.r3

#cc

:drawc
	0 300 op
	0 0 ( 2.0 <? swap
		dup pick2 cos 200 1.0 */ 300 + line
		3 + swap 0.01 + ) 2drop ;

:test
	cls home
	$ffffff 'ink !
	over " r%d" print cr
	cr
	$ff00 'ink !
	here "%h" print cr cr
	msec 2 << cos "%f" print cr
	drawc

	omode
| freelook
	0.2 mrotx
	0 0 40.0  mtrans
|	drawcube

	key
	>esc< =? ( exit )
	<up> =? ( 10 'cc +! )
	<dn> =? ( -1 'cc +! )
	drop
	;

:ini
	mark
	;

:
	ini
	3 'test onshow
;

