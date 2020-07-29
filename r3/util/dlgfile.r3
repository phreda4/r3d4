| File load/save
| PHREDA 2020
|---------------
^r3/lib/gui.r3
^r3/lib/btn.r3
^r3/lib/input.r3

##path * 1024
##ext * 32
##filename * 1024

#xdlg 0 #ydlg 0
#wdlg 0 #hdlg 0

|--------------------------------
:FNAME | adr -- adrname
|WIN| 44 +
|LIN| 19 +
|WEB| 19 +
|RPI| 11 +
	;

:FDIR | adr -- dir
|WIN| @ 4 >>
|LIN| 18 + c@ 2 >>
|WEB| 18 + c@ 2 >>
|RPI| 10 + c@ 2 >>
	;

#files
#files>
#filenow
#fileini
#filelines
#filen
#filen>
#nfiles

|----------------------
:fileadd
	dup FNAME
	"." = 1? ( 2drop ; ) drop
	filen> files> !+ 'files> !
	dup FDIR files> !+ 'files> !
	FNAME filen> strcpyl 'filen> !
	;

:findlast | -- adr
	'path ( c@+ 1? drop ) drop ;

:searchlast
	findlast
	files ( files> <?
		@+ pick2 = 1? ( drop 4 - files - 3 >> 'filenow ! drop ; )
		drop 4 + ) 2drop
	0 'filenow !
	;

:reload
	files 'files> !
	filen 'filen> !
	'path
	ffirst ( fileadd fnext 1? ) drop
	files> files - 3 >> 'nfiles !
	0 'fileini !
	searchlast
	refreshfoco
	;

:dlgFileIni
	sh rows 4 - cch * swap over - 1 >> 'ydlg ! 'hdlg !
	sw cols 4 - ccw * swap over - 1 >> 'xdlg ! 'wdlg !
	rows 15 - 'filelines !
	mark
	here dup 'files !
	4096 + dup 'filen !
	'here !
	reload
	;

:dlgFileEnd
	empty
	;
:dlgtitle
	xdlg 4 + ydlg 4 + atxy
	$ffffff 'ink !
	printc
	;

:fillback
	$ffffff 'ink !
	xdlg 8 + pick2
    wdlg 16 - cch
	2swap fillrect
	;

:colorline | n --
	filenow =? ( fillback $0 'ink ! ; )
	$ffffff 'ink ! ;

:printline | n --
	3 << files + @+
	swap @
	1 and? ( "/" emits ) drop
	emits ;

:linefile | n x -- n x
	over fileini +
	nfiles >=? ( drop ; )
	colorline
	printline
	;

:lineup
	filenow 1 - clamp0 fileini <? ( dup 'fileini ! )
	'filenow ! ;

:linedn
	filenow 1 + nfiles 1 - clampMax
	fileini filelines + >=? ( dup filelines - 1 + 'fileini ! )
	'filenow ! ;

:setfile
	filenow 3 << files + @ 'filename strcpy ;

:backfolder
	'path ( c@+ 1? drop ) drop 1 -
	( 'path >?
		dup c@ $2f =? ( drop 0 swap c! reload ; )
		drop 1 - ) drop
	reload ;

:setfolder
    filenow 3 << files + @
	dup ".." = 1? ( 2drop backfolder ; ) drop
	"/" 'path strcat
	'path strcat
	reload
	;

:linenter
	filenow 3 << files + 4 + @
	1 and? ( drop setfolder ; ) drop
	setfile ;

:teclado
	key
	<up> =? ( lineup )
	<dn> =? ( linedn )
	<ret> =? ( linenter )
	>esc< =? ( exit )
	drop ;

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

	xdlg 8 + ydlg cch 3 << +
	wdlg 16 - over 4 + cch filelines * + pick2 -
	2swap fillrect

	$ffffff 'ink !
	xdlg 8 + ydlg cch 1 << + 3 + atxy
	'path emits | 64 input


	ydlg cch 3 << + 4 +
	0 ( filelines <? swap
		xdlg 8 + over atxy
		linefile
		cch + swap 1 + ) 2drop
	;

|----------------------
:fileload
	dlgback
	"load File " dlgtitle
	xdlg 8 + ydlg cch 2 << + 3 + atxy
	'filename emits
	teclado
	;

::dlgFileLoad
	dlgFileIni
|	"hola" 'filename strcpy
	'fileload onshow
	dlgFileEnd
	;

|----------------------
:filesave
	dlgback
	"save file" dlgtitle
	xdlg 8 + ydlg cch 2 << + 3 + atxy
	'filename 64 input
	teclado
	;

::dlgFileSave
	dlgFileIni
|	"que" 'filename strcpy
	'filesave onshow
	dlgFileEnd
	;


::dlgSetPath
	'path strcpy ;

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
"." dlgSetPath
'main onshow ;