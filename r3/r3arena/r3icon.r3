| r3 interactive
| experiment for make a r3computer like jupiter ace
| PHREDA 2021

^r3/lib/gui.r3
^r3/lib/input.r3
^r3/lib/fontj.r3
^r3/lib/trace.r3

^./r3ivm.r3
^./r3itok.r3

#spad * 1024
#output * 8192

|------------------------
:,tokenl | nro dic -- str
	swap 2 << + @ code2name ,s ;

:,i16	drop @+ 48 << 48 >> "%d" ,print 2 - ;
:,i32	drop @+ "%d" ,print ;
:,b		INTWORDS - 'wbasdic ,tokenl ;
:,b16	INTWORDS - 'wbasdic ,tokenl 2 + ;
:,iCOM	drop c@+ over "|" ,s ,s ,cr $ff and + 1 - ;
:,iSTR	drop c@+ over 34 ,c ,s 34 ,c $ff and + 1 - ;
:,iCALL	drop @+ 8 - @ code2name ,s ;
:,iADR	drop @+ 8 - @ $3fffffff and code2name "'" ,s ,s ;

#,tokenp
,i16 ,i32 ,iSTR ,iCOM
,i16 ,i32 ,iCALL ,iADR ,iCALL
,b ,b ,b16 ,b16 ,b16		|";" "(" ")" "[" "]"
,b ,b16 ,b16 ,b16 ,b16	|"EX" "0?" "1?" "+?" "-?"
,b16 ,b16 ,b16 ,b16		|"<?" ">?" "=?" ">=?"
,b16 ,b16 ,b16 ,b16 ,b16 |"<=?" "<>?" "AND?" "NAND?" "BT?"

:,minilit | t --
	57 << 57 >> "%d" ,print  ;

:,token | adr -- adr'
	c@+
	$80 and? ( ,minilit ; )
	27 >? ( ,b ; )
	dup 2 << ',tokenp + @ ex ;

|------------------------
:defw
	code2name ":%s " ,print
	@+ $ffff and	| dir cant
	over +
	swap ( over <? ,token 32 ,c
		) 2drop ;

:defv0
	$3fffffff and code2name "#%s " ,print
	@+ $ffff and	| dir cant
	over +
	swap ( over <? @+ "$%h " ,print	| dword
		 ) 2drop ;

:defv1
	$3fffffff and code2name "#%s " ,print 
	@+ $ffff and	| dir cant
	over +
	swap ( over <? @+ 8 - @ code2name "'%s " ,print | adr
		 ) 2drop ;

:defv2
	$3fffffff and code2name "#%s " ,print
	@ $ffff and	| dir cant
	" * $%h" ,print ,cr ;

#deflist 'defw 'defv0 'defv1 'defv2

:,printdef | adr --
	@+ dup 30 >> $3 and 2 << 'deflist + @ ex ;

|-------------------------------
:error! | str --
	;

:xbye
	exit ;

:wv
	$c0000000 and? ( $3fffffff and ; ) ;

:xwords
	,cr
	'wbasdic ( @+ 1?
		code2name ,s 32 ,c ) 2drop
	code ( code> <?
		@+ wv code2name ,s 32 ,c
		@+ $ffff and +  ) drop ;

:xsee
	vmdeep
	1 <? ( drop "word?" 'error ! ; ) drop
	,cr
    vmpop 8 - ,printdef ;

:xlist
	,cr
    code ( code> <?
		dup ,printdef
		dup 4 + @ $ffff and + 8 +
		,cr
		) drop ;

:xedit
	"edit " 'error ! ;

:xdump
	vmdeep
	2 <? ( drop "need adr and count" 'error ! ; ) drop
|	vmpop vmpop swap over + dumpbytes
	;

:xreset
	code
	dup 'code> !
	dup 'icode> !
	'lastdicc> !
	;

:xstack
	,cr
	'stack 4 + ( NOS <=? @+ " %d" ,print ) drop
	'stack NOS <=? ( TOS " %d " ,print ) drop
	;

:xcclear
	; | code clear

:xcload | "file" --
	; | code load

:xcsave | "file" -- ;code save
	icode> 'here !
	mark
	code> ( icode> <?
		,token
		c@+ dup ,c
		tokenext
		) drop
	"r3/r3arena/data/%s" savemem
	empty
	;

:xdel
	;

:xsavecode
	;

:xloadcode
	;

:xdir
	;

|#wsys "BYE" "WORDS" "SEE" "LIST" "EDIT" "DUMP" "RESET" "STACK" "DIR" ""
#wsysdic
$23EA6 $38C33974 $349A6 $B6AD35 $9A5AB5 $976BB1 $339B49B5 $34D6292C $25AB3
#xsys
'xbye 'xwords 'xsee 'xlist 'xedit 'xdump 'xreset 'xstack

|------------------------
:immediate
	";" r3i2token
|	9 ,i
	vmresetr
	code> vmrun drop
	code> 'icode> !
	;

:parse&run
	'spad
|    dup c@ 0? ( 'state ! drop patchend pinput ; ) drop
	r3i2token
|	state 0? ( immediate ) drop
	0 'spad ! refreshfoco
	;

|------- MAIN
:main
	cls home gui
	$ff00 'ink !
	"r3i" print cr
	$ffffff 'ink !
	"> " print
	'spad 1024 input
	cr
	code ( code> <?
		c@+ $ff and "%h " print ) drop
	key
	<ret> =? ( parse&run )
	>esc< =? ( exit )
	drop
	;

|-------------------------------
:startram
	mark
	$fff r3iram
	vmreset
	'wsysdic syswor!
	'xsys vecsys!
	;

:
	startram
	fontj2
	'main onshow ;