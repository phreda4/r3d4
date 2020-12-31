| multi client TCP
| PHREDA 2020

^r3/lib/gui.r3
^r3/lib/input.r3

#mensaje * 1024
#sockclient 0
#ip 0 0
#nn 0

:sendmsg
	sockclient 'mensaje dup count tcpsend
	'mensaje + 0 swap c!

	sockclient tcpclose
	0 'mensaje !
	1 'nn +!
	;

:main
	cls home gui
	"r3 client" print cr
	nn msec "%h %d" print cr
	'ip q@ "IP:%h" print cr cr
	sockclient "CLIENT:%h" print cr cr
	'mensaje 64 input cr cr
	key
	>esc< =? ( exit )
	<ret> =? ( sendmsg )
	drop ;

:inicio
	'ip "localhost" 9999 NETHOST | server
	'ip tcpOpen 'sockclient !
	;

:
	inicio
	'main onshow ;