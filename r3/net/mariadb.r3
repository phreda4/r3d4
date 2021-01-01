| Server test
| PHREDA 2020
|scr 640 480
^r3/lib/gui.r3
^r3/util/console.r3

#socketset

#ip 0 0
#sock 0
#data * 1024

:serverop
	sock 'data 1024	tcprecv
	0? ( drop ; ) drop
	'data 3 + c.print c.cr
	;

:recibe
	socketset 0 NETSETCHECK
	0? ( drop ; ) drop
	"." c.print
	sock netcheck 1? ( serverop ) drop
	;

:sendmsg
	sock "mariadb" count tcpsend
	drop ;

:main
	c.draw
|	c.keys
	recibe

	key
	>esc< =? ( exit )
	<f1> =? ( sendmsg )
	drop
	;

:printserver
	'ip @ dup $ff and
	swap 8 >> dup $ff and
	swap 8 >> dup $ff and
	swap 8 >> $ff and
	swap 2swap swap
	"Server IP Address : %d.%d.%d.%d" c.print c.cr
	'ip 4 + @
	"port: %d" c.print c.cr
	;

:netini
	mark
	sw sh c.full
	$111111 c.paper
	c.cls
	$ff0000 c.ink "r" c.print
	$ff00 c.ink "3" c.print
	$ffffff c.ink " client demo" c.print c.cr


	'ip "localhost" 3306 nethost | 0=server 7777 port
	printserver
	'ip tcpopen 'sock !
	sock "server:%d" c.print c.cr

	1 netset 'socketset !
	socketset sock tcpadd

	;

:netend
    sock 1? ( dup tcpclose ) drop
|	socketset 1? ( dup setfree ) drop
	;

:
	netini
	'main onshow
	netend ;