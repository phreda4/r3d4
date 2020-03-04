| Sistema de Particulas
| PHREDA 2019

^r3/lib/sys.r3
^r3/lib/rand.r3
^r3/lib/print.r3

^r3/util/arr8.r3

#fx 0 0

:reset
	'fx p.clear
	;

| pixel... vida x y vx vy

:hit
	b> 4 + dup @ neg swap ! ;

:pixel | adr --
	dup @ 1 - 0? ( nip ; )
	swap !+
	>b
	b@+	0 <? ( hit ) sw 16 << >? ( hit )
	b@+	0 <? ( hit ) sh 16 << >? ( hit )
	b@+ b> 12 - +!
	b@+ b> 12 - +!
	b@+ 'ink !	| draw
	16 >> swap
	16 >> swap op
	b> 20 - @ 16 >>
	b> 16 - @ 16 >> line
	;

:+part | x y vx vy --
	'pixel 'fx p!+ >a
	rand $1ff and 40 + a!+ | vida
	2swap swap a!+ a!+	| x y
	swap a!+ a!+	| vx vy
	rand a!+ | color
	;

:xypos
	rand sw mod abs 16 << rand sh mod abs 16 << ;
:vxypos
	rand 15.0 mod rand 15.0 mod ;

:add
	100 ( 1? 1 -
|		xypos							| rand
		xypen 16 << swap 16 << swap		| mouse
		vxypos +part
		) drop ;

|------- SHOW
:show
	cls home
	$ff00 'ink !
	" r" print over .d print cr
	"hit <f1> !!" print

	'fx p.draw

	key
	>esc< =? ( exit )
	<f1> =? ( add )
	<f2> =? ( reset )
	drop
	;

|------- RAM
:ram
	mark
	20000 'fx p.ini
	;

|------- BOOT
: ram
3
'show onshow
;