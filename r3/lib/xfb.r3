| framebuffer secundario
| PHREDA 2017
|.....MEM
|-------------------------
#fsize
##XFB 0

::iniXFB
	xfb 1? ( drop ; ) drop
	mark here 'xfb !
	sw sh * dup 'fsize !
	2 << 'here +! ;

::XFB>
	vframe xfb fsize MOVE ;

::>XFB
	xfb vframe fsize MOVE ;
