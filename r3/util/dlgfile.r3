| File load/save
| PHREDA 2020
|---------------
^r3/lib/gui.r3
^r3/lib/btn.r3
^r3/lib/fontpc.r3
^r3/lib/fontj.r3
^r3/lib/input.r3

##path * 1024
##ext * 32
##filename * 1024

#xdlg 0 #ydlg 0
#wdlg 0 #hdlg 0

|----------------------
:dlgFileIni
	sh rows 4 - cch * swap over - 1 >> 'ydlg ! 'hdlg !
	sw cols 4 - ccw * swap over - 1 >> 'xdlg ! 'wdlg !
	;

:dlgtitle
	xdlg 4 + ydlg 4 + atxy
	$ffffff 'ink !
	printc
	;

:dlgback
	cls home gui
	wdlg hdlg
	xdlg ydlg
	$696969 'ink ! fillrect
	wdlg 4 - cch 6 +
	xdlg 2 + ydlg 2 +
	$006900 'ink ! fillrect

	$00 'ink !
	wdlg 12 - cch 6 +
	xdlg 6 + ydlg cch 1 << +
	fillrect

	wdlg 12 - cch 6 +
	xdlg 6 + ydlg cch 2 << +
	fillrect

	$ffffff 'ink !
	xdlg 8 + ydlg cch 1 << + 3 + atxy
	'path 64 input
	xdlg 8 + ydlg cch 2 << + 3 + atxy
	'filename 64 input

	;

|----------------------
:fileload
	dlgback
	"load File " dlgtitle

	key
	>esc< =? ( exit )
	drop
	;

::dlgFileLoad
	dlgFileIni
	"hola" 'filename strcpy
	'fileload onshow
	;

|----------------------
:filesave
	dlgback
	"save file" dlgtitle

	key
	>esc< =? ( exit )
	drop
	;

::dlgFileSave
	dlgFileIni
	"que" 'filename strcpy
	'filesave onshow
	;


|------------------------------
:main

	cls home
	key
	>esc< =? ( exit )
	<f1> =? ( dlgFileLoad )
	<f2> =? ( dlgFileSave )
	drop
	;

:
|	fontpc
	fontj2
'main onshow ;