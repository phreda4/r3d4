| Server test
| PHREDA 2020
|scr 640 240
^r3/lib/gui.r3
^r3/util/console.r3

#socketset
#serverip 0 0
#serversock 0

| active,socket,peer,n,a,m,e,e
#players * 1024
#players> 'players

:+player | "name" peer socket active --
	players> >a
	a!+ a!+ a!+
	5 ( 1? 1 -
		swap @+ a!+ swap
		) 2drop
	0 a> 1 - c!
	a> 'players> ! ;


:printplay
	@+ "a:%d " c.print
	@+ "s:%h " c.print
	@+ "d:%h " c.print
	4 5 * +
	c.cr
	;

:serverop
	"severop" c.print c.cr
	serversock TCPACCEPT | newsock
	socketset over TCPADD
	"jugador n" over TCPADR rot 1 +player
	'players ( players> <? printplay ) drop
	;

#data * 1024

:clientop | adr -- adr+8*4
	dup 'players - 5 << "client %d" c.print c.cr
	dup 4 + @ netcheck 0? ( drop 8 4 * + ; ) drop
	dup 4 + @ 'data 512 TCPRECV
|	-? ( finconeccion )
	drop
	'data c.print c.cr
	8 4 * +
	;

:net
	socketset 0 NETSETCHECK
	0? ( drop ; ) drop
	"." c.print
	serversock netcheck 1? ( serverop ) drop
	socketset 0 NETSETCHECK
	0? ( drop ; ) drop
	'players ( players> <? clientop ) drop
	;

:main
	c.draw
|	c.keys
	net

	key
	>esc< =? ( exit )
	drop
	;

:printserver | 'ip --
	@+ dup $ff and
	swap 8 >> dup $ff and
	swap 8 >> dup $ff and
	swap 8 >> $ff and
	"Server IP Address : %d.%d.%d.%d" c.print c.cr
	@
	dup 8 >> $ff and swap $ff and 8 << or
	"port: %d" c.print c.cr
	;

:netini
	mark
	sw sh c.full
	$111111 c.paper
	c.cls
	$ff0000 c.ink "r" c.print
	$ff00 c.ink "3" c.print
	$ffffff c.ink " server demo" c.print c.cr

	16 netset 'socketset !
	'serverip 0 7777 nethost | 0=server 7777 port
	'serverip printserver
	'serverip tcpopen 'serversock !
	serversock "server:%d" c.print c.cr
	socketset serversock tcpadd

	'players 'players> !
	;

:netend
    serversock 1? ( dup tcpclose ) drop
	socketset 1? ( dup setfree ) drop
	;

:
	netini
	'main onshow
	netend ;