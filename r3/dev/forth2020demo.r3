| demo program for forth2020
| graphics and sound from the game DELTA made by MC
|--
|Ship sprites from Jacob Zinman-Jeanes:
|  http://gamedev.tutsplus.com/articles/news/enjoy-these-totally-free-space-based-shoot-em-up-sprites/
|--
|Explosion sprite from:
|  http://www.nordenfelt-thegame.com/blog/category/dev-log/page/3/
|--
|mp3 files from:
|  https://github.com/jakesgordon/javascript-delta
|--
|MEM 2048

^r3/lib/gui.r3
^r3/lib/sprite.r3
^r3/util/loadimg.r3

#spr_ship
#spr_enemy
#spr_explosion

#snd_shoot
#snd_explosion

#xp 40.0 #yp 100.0
#vxp #vyp

#xs #ys

#xa 500.0 #ya 130.0

#xss #yss #nss

:player
	yp vyp + 10.0 max sh 40 - 16 << min 'yp !
	msec 7 >> $3 and
	xp 16 >> yp 16 >>
	spr_ship ssprite ;

:explode
	xss 0? ( drop ; ) drop
	nss 16 >>
	xss yss
	spr_explosion ssprite

	-1 'xss +!
	0.2 'nss +!
	nss 16.5 >? ( 0 'xss ! ) drop
	;

:+explode
	xa 16 >> 10 - 'xss !
	ya 16 >> 10 - 'yss !
	0 'nss !
	snd_explosion splay
	;

:newovni
	rand sh 60 - 16 << mod abs 30 + 'ya !
	sw 16 << 'xa ! ;

:hit??
	xa 16 >> 20 + xs -
	ya 16 >> 15 + ys - distfast
	20 >? ( drop ; ) drop
	0 'xs !
	+explode
	newovni
	;

:shoot
	xs 0? ( drop ; ) drop
	7 'xs +!
	xs sw >? ( 0 'xs ! drop ; ) drop
	hit??
	$ffffff 'ink !
	xs ys op
	xs 10 + ys line
	;

:+shoot
	xs 1? ( drop ; ) drop
	yp 16 >> 14 + 'ys !
	xp 16 >> 30 + 'xs !
	snd_shoot splay
	;

:ovni | --
	rand 2.0 mod 'ya +!
	-2.0 'xa +!
	xa -10.0 <? ( newovni ) drop
	msec 9 >> 6 mod
	xa 16 >> ya 16 >>
	spr_enemy ssprite ;

:ini
	rerand
	mark
	64 29 "media/img/Spritesheet_64x29.png" loadimg tileSheet 'spr_ship !
	40 30 "media/img/eSpritesheet_40x30.png" loadimg tileSheet 'spr_enemy !
	64 64 "media/img/explosion.png" loadimg tileSheet 'spr_explosion !
	"media/snd/shoot.mp3" sload 'snd_shoot !
	"media/snd/explode.mp3" sload 'snd_explosion !
	;

#ss * 4096 |
#ss> 'ss

:pset
	sw * + 2 << vframe + $ffffff swap ! ;

:drawstar
	dup @
	$2000 -
	-? ( $fff and sw 12 << or )
	dup 12 >> over $fff and pset
	swap !+ ;

:drawback
	'ss ( ss> <?
		drawstar ) drop ;

:fillback
	'ss >a
	1024 ( 1? 1 -
		rand sw mod abs 12 <<
		rand sh mod abs or
		a!+
		) drop
	a> 'ss> ! ;

:game
	cls home

	snd_shoot "%h " print
	drawback
	player
	shoot
	ovni
	explode

	key
	>esc< =? ( exit )
	<up> =? ( -2.0 'vyp ! )
	<dn> =? ( 2.0 'vyp ! )
	>up< =? ( 0 'vyp ! )
	>dn< =? ( 0 'vyp ! )
	<esp> =? ( +shoot )
	drop
	;

:	ini
	fillback
	'game onshow ;
