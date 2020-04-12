|--------------------
| BTN.TXT PHREDA 2010
|--------------------
^r3/lib/gui.r3
^r3/lib/trace.r3

:print2gc | "" --
	ccx 1 - 'xr1 !
	ccy 1 - 'yr1 !
	swprint ccx + 1 + 'xr2 !
	cch ccy + 1 + 'yr2 !
	;

:btn.draw
	xr1 yr1 xr2 yr2 fillbox ;

:botonsimple
	ink $444444 over
	[ swap ; ]	guiI
	'ink ! drop
	xr1 yr1 xr2 yr2 fillbox
	'ink !
	;

::.btnt | acc "txt" --
	ccw 'ccx +!
	print2gc
	-4 dup 'xr1 +! 'yr1 +!
	4 dup 'xr2 +! 'yr2 +!
	botonsimple
	ink >r
	$ffffff 'ink !
	print
	r> 'ink !
|	'bordeyfoco in/foco
	onClick
	ccw 'ccx +!
	;


::.link | acc "txt" --
	ccw 1 >> 'ccx +!
	print2gc
	ccw 1 >> 'xr2 +!
	botonsimple
	ink >r
	$ffffff 'ink !
	print
	r> 'ink !
|	'bordeyfoco in/foco
	onClick
	ccw 1 >> 'ccx +!
	;


::btnt | 'event "texto" --
	ccw 1 >> 'ccx +!
	print2gc
	ccw dup neg 'xr1 +! 'xr2 +!
	cch 1 >> dup neg 'yr1 +! 'yr2 +!
	botonsimple
	ink >r
	$ffffff 'ink !
	print
	r> 'ink !
	onClick
	xr2
|	ccw 1 >>
	'ccx !
	;

::link | acc "txt" --
	ccw 1 >> 'ccx +!
	print2gc
	ccw 1 >> 'xr2 +!
	botonsimple
	ink >r
	$ffffff 'ink !
	print
	r> 'ink !
	onClick
	ccw 1 >> 'ccx +!
	;

:gcxy+!
	dup 'ccx +! 'ccy +! ;

::ibtn | acc 'ico --
	dup
	@ dup $ff and 4 + ccx dup 'xr1 ! + 'xr2 !
	8 >> $ff and 4 + ccy dup 'yr1 ! + 'yr2 !
	btn.draw
	2 [ 1 + ; ] guiI gcxy+!
	0 swap drawcico  | negro
	-2 [ 1 - ; ] guiI gcxy+!
	onClick
	6 'ccx +!
	;

::btnfpx | 'event px py --
	ccy dup 'yr1 ! + 'yr2 !
	ccx dup 'xr1 ! + 'xr2 !
	btn.draw
	onClick
	;
