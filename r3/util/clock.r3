| Reloj y Almanaque
| PHREDA 2011,2020
|-----------------------
^r3/util/polygr.r3


#xc #yc
#ss

::clocksize | s xc yc --
	'yc ! 'xc ! 'ss ! ;

|--------- reloj
:aguja | ang largo --
	polar
	xc pick2 3 >> - yc pick2 3 >> + op
	xc rot + yc rot - line ;

::clock | --
	$ffffff 'ink !
	ss
	0 ( 1.0 <?
		dup pick2 polar
		swap xc + swap yc + op
		dup pick2 dup 4 >> - polar
		swap xc + swap yc + line
		0.0834 + ) drop
	4 - >r
	time | -- h(8)m(8)s(8)
	dup 16 >> $ff0000 'ink ! 1.0 12 */ r@ 1 >> aguja
	dup 8 >> $ff00 'ink ! 1.0 60 */ r@ dup 2 >> - aguja
	$ff and $ffffff 'ink ! 1.0 60 */ r> aguja ;


::agujaex | ang largo --
	polar
	xc pick2 3 >> - yc pick2 3 >> + gop
	xc rot + yc rot - gline ;

:circle | largo -- largo
	0 dup pick2 polar swap xc + swap yc + op
	( 0.99 <? 0.01 +
		dup pick2 polar swap xc + swap yc + pline
		) drop
	poli ;

::clockexp
	ss
	$0 'ink ! 8 + circle
	$ffffff 'ink ! 16 - circle
	$0 'ink ! 3 linegr!
	0 ( 1.0 <?
		dup pick2 polar swap xc + swap yc + gop
		dup pick2 dup 3 >> - polar swap xc + swap yc + gline
		0.0834 + ) drop
	8 - >r
	time | -- h(8)m(8)s(8)
	dup 16 >> 4 linegr! 60 * over + 1.0 720 */ r@ 1 >> agujaex
	dup 8 >> $ff and 3 linegr! 60 * over + 1.0 3600 */ r@ dup 2 >> - agujaex
	$ff and 2 linegr! $ff0000 'ink ! 1.0 60 */ r> 32 - agujaex ;

