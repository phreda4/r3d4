| main filesystem
| PHREDA 2019
|------------------------

^r3/lib/gui.r3
^r3/lib/input.r3

^r3/lib/mem.r3
^r3/lib/str.r3

^r3/lib/trace.r3

^r3/lib/fontm.r3
^media/fntm/droidsans13.fnt

#reset 0
#path * 1024
#name * 1024

#nfiles
#files * 8192
#files> 'files
#files< 'files
#filen * $3fff
#filen> 'filen

#nivel
#pagina
#actual
#linesv 15

|--------------------------------
:FNAME | adr -- adrname
	44 + ;

:FDIR? | adr -- 1/0
	@ 4 >> 1 and ;

:FINFO | adr -- adr info
	dup FDIR? 0? ( 2 + ; ) drop 0 ;


:getname | nro -- ""
	2 << 'files + @ 8 >> 'filen + ;

:getinfo | nro -- info
	2 << 'files + @ $ff and ;

:getlvl | nro -- info
	2 << 'files + @ 4 >> $f and ;

:chginfo | nro --
	2 << 'files + dup @ $1 xor swap ! ;

|--------------------------------
:files.clear
	0 'nfiles !
	'filen 'filen> !
	'files dup 'files> ! 'files< !
	;

:files!+
	files> ( files< >?
		4 - dup @+ swap !
		) drop
	files< !+ 'files< !
	4 'files> +!
	;

:files.free
	0 'files ( files> <?
		@+ pick2 >? ( swap rot )
		drop ) drop
	8 >> 'filen +
	( c@+ 1? drop ) drop
	'filen> !
	;

:fileadd
	FINFO nivel 4 << or filen> 'filen - 8 << or
	files!+
	FNAME filen> strcpyl 'filen> !
	;

:reload
	'path
	ffirst drop | quita .
	fnext drop	| quita ..
	( fnext 1? fileadd ) drop
	files> 'files - 2 >> 'nfiles !
	;

:rebuild
	"r3" 'path strcpy
	files.clear
	0 'pagina !
	0 'nivel !
	reload
	;

|-----------------------------
:makepath | actual nivel --
	0? ( drop
		"r3/" 'path strcpy
		getname 'path strcat
		; )
	over 1 -
	( dup getlvl pick2 >=?
		drop 1 - ) drop
	over 1 - makepath drop
	"/" 'path strcat
	getname 'path strcat
	;

:expande
	actual dup
	getlvl makepath
   	actual chginfo
	actual getlvl 1 + 'nivel !
    actual 1 + 2 << 'files + 'files< !
	reload
	;

:remfiles
	actual chginfo
	actual getlvl 1 +
	actual 1 +
	( dup getlvl pick2 >=?
		drop 1 + ) drop
	nip
	actual 1 +
	( swap nfiles <?
		dup 2 << 'files + @
		pick2 2 << 'files + !
		1 + swap 1 + ) drop
	2 << 'files + 'files> !
	files> 'files - 2 >> 'nfiles !
	files.free
	;

:contrae
	'path ( c@+ 1? drop ) drop 1 -
	( 'path >?
		dup c@ $2f =? ( drop 0 swap c! remfiles ; )
		drop 1 - ) drop
	remfiles ;

|-------------
#nameaux * 1024

:next/ | adr -- adr'
	( c@+ 1?
		$2f =? ( drop 0 swap 1 - c!+ ; )
		drop ) nip ;

:getactual | adr actual -- actual
	( nfiles <?
		dup getname pick2 = 1? ( drop nip ; )
		drop 1 + ) nip ;


|--------------------------
:remlastpath
	'path ( c@+ 1? drop ) drop 1 -
	( dup c@ $2f <>? drop 1 - ) drop
	0 swap c! ;

:setactual
	actual dup getlvl makepath
	actual getinfo 1 >? ( remlastpath ) drop
	actual getname 'name strcpy
	;

|---------------------
:traverse | adr -- adrname
	dup next/ 0? ( drop ; )
	( dup next/ 1?
		swap
		actual getactual 'actual !
		expande
		) drop ;

:loadm
	'nameaux "mem/menu.mem" load
	'nameaux =? ( drop ; )
	'nameaux dup c@ 0? ( 2drop ; ) drop
	0 'actual !
	0 'path !
	traverse
	actual getactual nip
	pagina linesv + 1 - >=? ( dup linesv - 1 + 'pagina ! )
	'actual !
	drop
	setactual
	;

:savem
    'path 'name strcpy
	"/" 'name strcat
	actual getname 'name strcat
	'name 1024 "mem/menu.mem" save ;

|--------------------------------
:printfn | n
	sp
	dup getlvl 1 << nsp
	dup getinfo $3 and "+- ." + c@ emit
	sp getname emits sp
	;

#filecolor $ff00 $bf00 $bfbfbf $3f00

:colorfile
    dup getinfo $3 and 2 << 'filecolor + @ 'ink ! ;

:backcursor
	$444444 'ink !
	sw 1 >> cch 0 ccy fillrect
	;

:drawl | nro --
	actual =? ( backcursor )
	colorfile
	printfn ;

:drawtree
	0 1 gotoxy
	0 ( linesv <?
		dup pagina +
		nfiles  >=? ( 2drop ; )
|		'clicktree onLineClick
    	drawl
		cr 1 + ) drop ;

|--------------------------
:remlastpath
	'path ( c@+ 1? drop ) drop 1 -
	( dup c@ $2f <>? drop 1 - ) drop
	0 swap c! ;

|--------------------------------
:runfile
	actual -? ( drop ; )
	getinfo $7 and
	2 <? ( drop ; )
	drop
|	'path "r3 ""%s/%s""" sprint sys drop
	'path "r3v ""%s/%s""" sprint sys drop
	;


:editfile
	actual -? ( drop ; )
	getinfo $3 and 2 <>? ( drop ; ) drop
	actual getname 'path "%s/%s" sprint 'name strcpy
	'name 1024 "mem/main.mem" save
	"r3 r3/editor/code-edit.r3" sys drop
	;

#nfile

:newfile
	1 'nfile !
	0 'name !
	;

:remaddtxt | --
	'name ".r3" =pos 1? ( drop ; ) drop
	".r3" swap strcat
	;

:createfile
	remaddtxt
	'name 'path "%s/%s" sprint 'name strcpy

	mark
	"^r3/lib/gui.r3" ,ln ,cr
	":main" ,ln
	"	cls home" ,ln
	"	""Hello Human!"" print" ,ln
	"	key >esc< =? ( exit ) drop" ,ln
	"	;" ,ln ,cr
	": 'main onshow ;" ,ln
	'name savemem
	empty

	'name 1024 "mem/main.mem" save
	'name 1024 "mem/menu.mem" save

	"r3 r3/editor/code-edit.r3" sys drop

	rebuild
	loadm
	;

|--------------------------------
:fenter
	actual
	getinfo $f and
	0? ( drop expande ; )
	1 =? ( drop contrae ; )
	drop

	actual
	getname
	".r3" =pos 1? ( drop runfile ; ) drop
	drop
	;

:fdn
	actual nfiles 1 - >=? ( drop ; )
	1 + pagina linesv + 1 - >=? ( dup linesv - 1 + 'pagina ! )
	'actual !
	setactual ;

:fup
	actual 0? ( drop ; )
	1 - pagina <? ( dup 'pagina ! )
	'actual !
	setactual ;

:fpgdn
	actual nfiles 1 - >=? ( drop ; )
	20 + nfiles >? ( drop nfiles 1 - ) 'actual !
	actual pagina linesv + 1 -
	>=? ( dup linesv - 1 + 'pagina ! ) drop
	setactual ;

:fpgup
	actual 0? ( drop ; )
	20 - 0 <? ( drop 0 )
	pagina <? ( dup 'pagina ! )
	'actual !
	setactual ;

:fhome
	actual 0? ( drop ; ) drop
	0 'actual ! 0 'pagina !
	setactual ;

:fend
	actual nfiles 1 - >=? ( drop ; ) drop
	nfiles 1 - 'actual !
	actual 1 + pagina linesv + 1 -
	>=? ( dup linesv - 1 + 'pagina ! ) drop
	setactual ;


|---------------------------------
:enter
	nfile 0? ( drop fenter ; ) drop
	0 'nfile !
	'name c@ 0? ( drop setactual ; ) drop
	createfile
	;

:teclado
	key
	>esc< =? ( exit )
	<up> =? ( fup )
	<dn> =? ( fdn )
	<pgup> =? ( fpgup )
	<pgdn> =? ( fpgdn )
	<home> =? ( fhome )
	<end> =? ( fend )
	<ret> =? ( enter )

	<f1> =? ( fenter )
	<f2> =? ( editfile )
	<f3> =? ( newfile )

	drop ;

:pfilename
	nfile 0? ( drop
		$444444 'ink ! 0 rows 2 - gotoxy backline
		$ffffff 'ink ! " " emits
		'path emits "/" emits 'name emits ; ) drop
	$006600 'ink ! 0 rows 2 - gotoxy 2 backlines
	$ffffff 'ink ! " " emits
	'path emits "/" emits
	'name 32 input ;

:btnf | "" "fx" --
	sp
	$ff0000 'ink ! backprint
	$ffffff 'ink ! emits
	$ffff 'ink ! emits
	;

:header
	pfilename
	0 rows 1 - gotoxy
	$444444 'ink ! backline
	"Run " "F1" btnf
	"Edit " "F2" btnf
	"New " "F3" btnf

	$444444 'ink !
	0 0 gotoxy backline
	$ff00 'ink !
	" r3 " emits
	$ffffff 'ink !
	;

:inicio
	cls home gui
	header
	drawtree
	teclado
	acursor
	;

|---------------------------------
:main
	'fontdroidsans13 fontm
	rows 3 - 'linesv !
	rebuild
	loadm
	'inicio onshow
	savem
	;

: main ;