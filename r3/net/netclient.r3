| client test
| PHREDA 2020
^r3/lib/gui.r3
^r3/lib/input.r3

#mensaje * 1024
#sockclient 0
#ip 0 0
#nn 0
#err 0

:sendmsg
	sockclient 0? ( drop ; )
	'mensaje count tcpsend
	'err !
	sockclient tcpclose
	0 'sockclient !
	'ip tcpopen 'sockclient !
	1 'nn +!
	;

:main
	cls home gui
	"r3 client" print cr
	err nn msec "%h %d err:%d" print cr
	'ip q@ "IP:%h" print cr cr
	sockclient "CLIENT:%h" print cr cr
	'mensaje 64 input cr cr
	key
	>esc< =? ( exit )
	<ret> =? ( sendmsg 	0 'mensaje ! refreshfoco )
	drop ;

:netini
	'ip "localhost" 9999 nethost | cliente port=9999
	'ip tcpopen 'sockclient !
	;

:netend
	sockclient tcpclose
	;

:
	netini
	'main onshow
	netend ;