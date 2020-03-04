|--------------------
| BTN.TXT PHREDA 2010
|--------------------
^r3/lib/gui.r3

::.btnt | acc "txt" --
	ccw 'ccx +!
	print2gc
	ccw 2* 'w +!
	cch 2/ 'h +!
	botonsimple
	ink >r 
	$ffffff 'ink !
	print
	r> 'ink !
	'bordeyfoco in/foco
	guiBtn
	ccw 'ccx +!
	;


::.link | acc "txt" --
	ccw 2/ 'ccx +!
	print2gc
	ccw 2/ 'w +!
	botonsimple
	ink >r
	$ffffff 'ink !
	print
	r> 'ink !
	'bordeyfoco in/foco
	guiBtn
	ccw 2/ 'ccx +!
	;


::btnt | 'event "texto" --
	ccw 2/ 'ccx +!
	print2gc
	ccw 'w +!
	cch 2/ 'h +!
	botonsimple
	ink >r
	$ffffff 'ink !
	print
	r> 'ink !
	guiBtn
	ccw 2/ 'ccx +!
	gc.pop
	;

::link | acc "txt" --
	ccw 2/ 'ccx +!
	print2gc
	ccw 2/ 'w +!
	botonsimple
	ink >r
	$ffffff 'ink !
	print
	r> 'ink !
	guiBtn
	ccw 2/ 'ccx +!
	;

