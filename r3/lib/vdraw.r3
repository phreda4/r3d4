| PHReda 2010
| Virtual Draw
|
|-------------
#vec
#xa #ya

:hline | xd yd xa --
	pick2 - 0? ( drop vec ex ; )
	-? ( rot over + rot rot neg )
	( 1? 1 - >r
		2dup vec ex
		swap 1 + swap
		r> ) 3drop ;

:rline | xd yd --
	ya =? ( xa hline ; )
	xa ya pick2 <? ( 2swap )	| xm ym xM yM
	pick2 - >r			| xm ym xM  r:canty
	pick2 - r@ 16 <</
	rot 16 << rot rot
	r> 				|xm<<16 ym delta canty
	1 + ( 1? 1 - >r >r
		over 16 >> over pick3 r@ + 16 >> hline
		1 + swap
		r@ + swap
		r> r> )
	4drop ;

|---- recorre por punto
::vline! | x y --
	2dup rline
	'ya ! 'xa ! ;

::vop! | 'set --
	'vec !
	xypen 'ya ! 'xa ! ;

::vop | x y  --
	'ya ! 'xa ! ;
