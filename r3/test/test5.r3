| Sistema de Particulas
| PHREDA 2019
|MEM $ffff
^r3/lib/sys.r3
^r3/lib/rand.r3
^r3/lib/print.r3
^r3/lib/trace.r3

#fx 0 0

:xypos
	rand sw mod abs 16 << rand sh mod abs 16 << ;
:vxypos
	rand 15.0 mod rand 15.0 mod ;

#memo * 128

:test1 | a b c d ---
	'memo >b
	$ff00 b!+
	2swap
	swap b!+ b!+
	swap b!+ b!+
	;

:dumptest
	'memo >a
	a@+
	a@+ a@+
	a@+ a@+
	"%f %f " print
	"%f %f " print
	"%h " print
	cr ;

|------- SHOW
#v 3.0
:show
	cls home
	$ff00 'ink !
	" r" print over .d print cr
	"hit <f1> !!" print cr
	cr
	dumptest

	v 63 >>> "%d" print cr

	key
	>esc< =? ( exit )
	<f1> =? ( xypos vxypos test1 )

	drop
	;

|------- RAM
:ram
	mark
	xypos vxypos test1
|    $ff 'ink  ! cls home 'memo dumpf
	;

|------- BOOT
: ram
3
'show onshow
;