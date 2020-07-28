^r3/lib/gui.r3

#digits (
%1111 %1..1 %1..1 %1..1 %1111
%...1 %...1 %...1 %...1 %...1
%1111 %...1 %1111 %1... %1111
%1111 %...1 %1111 %...1 %1111
%1..1 %1..1 %1111 %...1 %...1
%1111 %1... %1111 %...1 %1111
%...1 %...1 %1111 %1..1 %1111
%111. %...1 %...1 %...1 %...1
%1111 %1..1 %1111 %1..1 %1111
%1111 %1..1 %1111 %...1 %...1
)

:**
	and? ( $ff00 a!+ ; )
	4 a+ ;

:drawline | adr -- adr
	c@+
	%1... **
	%.1.. **
	%..1. **
	%...1 **
	drop
	;

:nextline
	sw 4 - 2 << a+ ;

:drawd | addr --
	5 ( 1? 1 - swap
		drawline
		nextline
		swap ) 2drop ;

:drawdigit | n --
	5 * 'digits + drawd ;

:xy>v | x y -- v
	sw * + 2 << vframe + ;

:main
	cls

	msec 7 >>

	dup 10 / 10 mod

	20 20 xy>v >a
	drawdigit

	10 mod
	xypen xy>v >a
	drawdigit

	key >esc< =? ( exit ) drop
	;

:
	'main onshow
;

