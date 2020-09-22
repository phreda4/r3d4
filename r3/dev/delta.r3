|DELTA - MC 2020
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
|SCR 800 450

^r3/lib/gui.r3
^r3/lib/sys.r3
^r3/lib/mem.r3
^r3/lib/print.r3
^r3/lib/sprite.r3
^r3/util/loadimg.r3

| bullet format: 12 bits for x, 12 bits for y
#nbullets 16
#abullets 0   | active bullets
#bullets * 64 | 4 * nbullets
#bulletspeed 16

| star format:    12 bits for x, 12 bits for y, 4 bits for speed
#nstars  200
#stars * 800 | 4 * nstars

#spr_ship #shipi 0 #shipn 4
#spr_enemy #enemyi 0 #enemyn 6
#spr_explosion #explosioni 0 #explosionn 16
#snd_shoot #snd_explosion
#curframe 0
#lastbullet 0

#nen 32     | up to a hundred
#enx * 400  | (4 * nen)
#eny * 400  | 
#envx * 400 | 
#envy * 400 | 
#v1x * 400  | Boids rule 1
#v1y * 400  | 
#v2x * 400  | Boids rule 2
#v2y * 400  | 
#v3x * 400  | Boids rule 3
#v3y * 400  | 

:rot- rot rot ; | ( a b c -- c a b )

:nth swap 2 << + ; | ( i adr -- adr' ) computes adress of nth element of 4-byte array

:packstar | ( speed x y - packed )
	  4 << swap 16 << or or ;

:newstar | ( -- speed x y )
	 rand abs 15 mod 1 +  | speed
	 rand abs sw 1 - mod  | x
	 rand abs sh 1 - mod  | y
	 ;

:rnewstar | ( -- speed SW y )
	  newstar nip sw swap ;
	 
:inistars 0 ( nstars <? dup
	  'stars nth newstar packstar swap !
	  1 + ) drop ;

:keyboard key
	  >esc< =? ( exit ) 
	  drop ;

:unpackbullet | ( packed -- x y )
	      dup %111111111111 and swap 12 >> ;

:yellow $FFFF00 'ink ! ;

:white $FFFFFF 'ink ! ;

:draw4box 2dup 4 + swap 4 + swap fillbox ;

:drawbullet | ( packed -- )
	    yellow
	    unpackbullet draw4box
	    white ;

:drawbullets | ( -- )
	     0 ( abullets <? dup
	     'bullets nth @ drawbullet
	     1 + ) drop ;

:printbullets home
	      abullets "Active %d" print cr 
	      nbullets "Total  %d" print cr
	      3.4 7.8 + dup "%f" print cr
	      16 >> "%d" print cr
	      3.4 7.8 *. "%f" print cr ;

:packbullet 12 << or ;

:newbullet | ( -- )
	   xypen 14 + swap 64 + swap
	   packbullet
	   'bullets abullets 2 << + !
	   abullets 1 + 'abullets !
	   curframe 'lastbullet ! ;

:shootbullet  | ( -- )
       abullets 1 + nbullets =? ( drop ; ) drop
       curframe lastbullet - 5 <? ( drop ; ) drop
       newbullet
       snd_shoot splay ;

:drawship | ( x y -- )
	   shipi rot- spr_ship ssprite
	   shipi 1 + shipn mod 'shipi ! ;
	   
:unpackstar | ( packed -- speed x y )
	    dup %1111 and
	    swap dup 16 >>
	    swap 4 >> %111111111111 and ;

:drawenemy | ( x y -- )
	    'stars @ unpackstar
	    enemyi rot- spr_enemy ssprite
	    drop                             | drop speed
	    enemyi 1 + enemyn mod 'enemyi ! ;

:drawexplosion | ( x y -- )
	       'stars 4 + @ unpackstar
	       explosioni 0? ( snd_explosion splay ) drop
	       explosioni rot- spr_explosion ssprite
	       drop                                         | drop speed
	       explosioni 1 + explosionn mod 'explosioni ! ;

:drawstar | ( packed -- )
	   unpackstar 2dup op >r swap - 1 - r> line ;

:drawstars | ( -- )
	    0 ( nstars <? dup
	    'stars nth @ drawstar
	    1 + ) drop ;

:drawenemies | ( -- )
	     0 ( nen <? dup
	     dup
	     'enx nth @ 16 >>
	     swap
	     'eny nth @ 16 >>
	     enemyi rot- spr_enemy ssprite
	     1 + ) drop ;

:moveenemies | ( -- )       x' = x + vx          y' = y + vy          BUG BUG
	     0 ( nen <? dup
	       dup
	       2 << dup 'enx + dup @ rot 'envx + @ + swap !
	       2 << dup 'eny + dup @ rot 'envy + @ + swap !
	     1 + ) drop ;

:movestar | ( speed x y - speed x' y )
	   pick2 rot swap - -? ( 3drop rnewstar ; ) swap ;

:movestars | ( -- )
	    0 ( nstars <? dup
	    'stars nth dup @ unpackstar movestar packstar swap !
	    1 + ) drop ;

:movebullet | ( x y - x' y )
	    swap bulletspeed + swap ;

:movebullets | ( -- )
	     0 ( abullets <? dup
	     'bullets nth dup @ unpackbullet movebullet packbullet swap !
	     1 + ) drop ;

| shift bullets to eliminate bullet that escaped to the right
:shiftbullets | ( i -- )
	      dup 'bullets nth          | dst
	      swap dup 1 + 'bullets nth | src
	      swap nbullets swap -      | c
	      move
	      abullets 1 - 'abullets ! ;

| identify first bullet that went beyond the screen on the right
:fixbullets | ( -- )
	    0 ( abullets <? dup
	    dup 'bullets nth @ unpackbullet drop sw >? ( drop shiftbullets drop ; ) 2drop
	    1 + ) drop ;

:ranenex sw 3 /
	 rand abs sw 6 / mod +
	 16 << ;

:raneney sh 3 /
	 rand abs sh 6 / mod +
	 16 << ;

:ranenevx 1.25 ;

:ranenevy 1.25 ;

:iniene | ( -- ) Initialize enemy coordinates
	0 ( nen <? dup
	2 <<
	dup
	'enx + ranenex swap !
	dup
	'eny + raneney swap !
	dup
	'envx + ranenevx swap !
	'envy + ranenevy swap !
	1 + ) drop ;

:ini rerand
     inistars
     iniene
     mark
     64 29 "media/img/Spritesheet_64x29.png" loadimg tileSheet 'spr_ship !
     40 30 "media/img/eSpritesheet_40x30.png" loadimg tileSheet 'spr_enemy !
     64 64 "media/img/explosion.png" loadimg tileSheet 'spr_explosion !
     "media/snd/shoot.mp3" sload 'snd_shoot !
     "media/snd/explode.mp3" sload 'snd_explosion ! ;

:game cls
      keyboard
      bpen 1? ( shootbullet ) drop
      printbullets
      drawstars
      drawenemy
      drawenemies moveenemies
      drawexplosion
      xypen drawship
      drawbullets movebullets fixbullets
      movestars
      1 'curframe +! ;

: ini
  'game onshow ;
