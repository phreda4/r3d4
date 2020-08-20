|DELTA - MC 2020
|Sprites from Jacob Zinman-Jeanes, below some information included in his package:
|  --
|  These sprites were designed by Jacob Zinman-Jeanes (http://jeanes.co) for Gamedevtuts+ (http://gamedev.tutsplus.com/).
|  http://gamedev.tutsplus.com/articles/news/enjoy-these-totally-free-space-based-shoot-em-up-sprites/
|  --
|
|MEM 2048
|SCR 1600 900

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

| star format:    12 bits for x, 12 bits for y, 4 bits for speed
#nstars  200
#stars * 800 | 4 * nstars

#ship #shipi 0 #shipn 4
#enemy #enemyi 0 #enemyn 6
#explosion #explosioni 0 #explosionn 16

#shoot #explode

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
	  2 << 'stars + newstar packstar swap !
	  1 + ) drop ;

:ini rerand
     inistars
     mark
     64 29 "media/img/Spritesheet_64x29.png" loadimg tileSheet 'ship !
     40 30 "media/img/eSpritesheet_40x30.png" loadimg tileSheet 'enemy !
     64 64 "media/img/explosion.png" loadimg tileSheet 'explosion !
     "media/snd/shoot.mp3" sload 'shoot !
     "media/snd/explode.mp3" sload 'explode ! ;

:keyboard key
	  >esc< =? ( exit ) 
	  drop ;

:unpackbullet | ( packed -- x y )
	      dup %111111111111 and swap 12 >> ;

:yellow $FFFF00 'ink ! ;

:white $FFFFFF 'ink ! ;

:drawbullet | ( packed -- )
	    yellow
	    unpackbullet
	    2dup 4 + swap 4 + swap fillbox
	    white ;

:drawbullets | ( -- )
	     0 ( abullets <? dup
	     2 << 'bullets + @ drawbullet
	     1 + ) drop ;

:printbullets home
	      abullets "Active %d" print cr 
	      nbullets "Total  %d" print cr ;

:packbullet 12 << or ;

#curframe 0
#lastbullet 0

:newbullet | ( -- )
	   xypen 14 + swap 64 + swap
	   packbullet
	   'bullets abullets 2 << + !
	   abullets 1 + 'abullets !
	   shoot splay
	   curframe 'lastbullet ! ;

| use ship speed/direction?
:shoot | ( -- )
       abullets 1 + nbullets =? ( drop ; ) drop
       curframe lastbullet - 5 <? ( drop ; ) drop
       newbullet ;

:drawship | ( x y -- )
	   shipi rot rot ship ssprite
	   shipi 1 + shipn mod 'shipi ! ;
	   
:unpackstar | ( packed -- speed x y )
	    dup %1111 and
	    swap dup 16 >>
	    swap 4 >> %111111111111 and
	    ;

:drawenemy | ( x y -- )
	    'stars @ unpackstar
	    enemyi rot rot enemy ssprite
	    drop | drop speed
	    enemyi 1 + enemyn mod 'enemyi ! ;

:drawexplosion | ( x y -- )
	       'stars 4 + @ unpackstar
	       explosioni 0? ( explode splay ) drop
	       explosioni rot rot explosion ssprite
	       drop | drop speed
	       explosioni 1 + explosionn mod 'explosioni ! ;

:drawstar | ( packed -- )
	   unpackstar 2dup op >r swap - 1 - r> line ;

:drawstars | ( -- )
	    0 ( nstars <? dup
	    2 << 'stars + @ drawstar
	    1 + ) drop ;

:movestar | ( speed x y - speed x' y )
	   pick2 rot swap - -? ( 3drop rnewstar ; ) swap ;

:movestars | ( -- )
	    0 ( nstars <? dup
	    2 << 'stars + dup @ unpackstar movestar packstar swap !
	    1 + ) drop ;

:movebullet | ( x y - x' y )
	    swap 16 + swap ;

:movebullets | ( -- )
	     0 ( abullets <? dup
	     2 << 'bullets + dup @ unpackbullet movebullet packbullet swap !
	     1 + ) drop ;

| shift bullets to eliminate bullet that escaped to the right
:shiftbullets | ( i -- )
	      dup 2 << 'bullets +          | dst
	      swap dup 1 + 2 << 'bullets + | src
	      swap nbullets swap -         | c
	      move
	      abullets 1 - 'abullets ! ;

| identify first bullet that went beyond the screen on the right
:fixbullets | ( -- )
	    0 ( abullets <? dup
	    dup 2 << 'bullets + @ unpackbullet drop sw >? ( drop shiftbullets drop ; ) 2drop
	    1 + ) drop ;

:game cls
      keyboard
      bpen 1? ( shoot ) drop
      printbullets
      drawstars
      drawenemy
      drawexplosion
      xypen drawship
      drawbullets movebullets fixbullets
      movestars
      1 'curframe +! ;

: ini
  'game onshow ;
