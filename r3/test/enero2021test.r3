| example for forth2020
| PHREDA

^r3/lib/gui.r3
^r3/lib/trace.r3


#ox #oy

:wop
	2dup 'oy ! 'ox !
	op ;
:wline
	2dup 'oy ! 'ox !
	line ;

:2* 1 << ;

:2/ 1 >> ;

:wCURVE | fx fy cx cy --
	pick3 ox + pick2 2* - abs
	pick3 oy + pick2 2* - abs  +
	8 <? ( 3drop wLINE ; ) drop
	pick3 pick2 + 2/
	pick3 pick2 + 2/		| fx fy cx cy x2 y2
	2swap 					| fx fy x2 y2 cx cy
	oy + 2/ swap
	ox + 2/ swap			| fx fy x2 x2 x1 y1
	pick3 pick2 + 2/
	pick3 pick2 + 2/		| fx fy x2 x2 x1 x1 ex ey
	2swap
	wCURVE wCURVE ;

:main
	cls home

	$ff00 'ink !

	10 10 wop
	100 100 
	100 10 
	wcurve

	acursor
	key
	>esc< =? ( exit )
	drop ;


: 'main onshow ;