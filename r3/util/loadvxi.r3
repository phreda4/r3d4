| read voxie files
| PHREDA 2017
|-----------------
^r3/lib/gui.r3
^r3/lib/trace.r3

#xsize #ysize #zsize
#data
#paleta

::loadvxi | "fn" --
	here dup rot load 'here !
	@+ 'xsize ! @+ 'ysize ! @+ 'zsize !
	12 + | xyz offset
	dup 'data !
	xsize ysize * zsize * +
	'paleta !
	;

:bswapc
	dup 16 >> $ff and
	over 16 << $ff0000 and
	or swap $ff00 and or ;

:getpal dup 1 << + paleta + @ bswapc ;

::mapvxi32 | 'vector --
	>r data >r
	xsize ( 1?
		ysize ( 1?
			zsize ( 1?
				r> c@+
				$ff and $ff <>? ( getpal pick4 pick4 pick4 r@ ex dup )
				drop >r 1 - ) drop
			1 - ) drop
		1 - ) drop
	r> drop r> drop ;

::mapvox8 | 'vector --
	>r data >r
	xsize ( 1?
		ysize ( 1?
			zsize ( 1?
				r> c@+
				$ff and $ff <>? ( pick4 pick4 pick4 r@ ex dup )
				drop >r 1 - ) drop
			1 - ) drop
		1 - ) drop
	r> drop r> drop ;

:apow
	0 swap ( 1? 1 >> swap 1 + swap ) drop 1 - ;

::vxiqsize | -- qsize
	zsize ysize max xsize max
	1 ( 1024 <?
		over >=? ( nip apow ; )
		1 << ) nip apow ;
