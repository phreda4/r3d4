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
|SCR 1600 900

^r3/lib/gui.r3
^r3/lib/sys.r3
^r3/lib/mem.r3
^r3/lib/print.r3
^r3/lib/sprite.r3
^r3/lib/math.r3
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
#snd_shoot 0 0
#snd_explosion 0 0
#curframe 0
#lastbullet 0

#nen 16     | up to a hundred

#enx * 400  | (4 * nen)
#eny * 400  | 

#envx * 400 | 
#envy * 400 |

#senx #seny   | sum(enx), sum(eny)
#senvx #senvy | sum(envx), sum(envy)

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
	      senvx senvy "Sum speed: %f %f" print cr
	      envx envy "Sum position: %f %f" print cr ;

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
       'snd_shoot q@ splay ;

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
	       explosioni 0? ( 'snd_explosion q@ splay ) drop
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

:boidprep | ( -- )
	  0 'senx !
	  0 'seny !
	  0 'senvx !
	  0 'senvy !
	  0 ( nen <? dup 2 << 'enx + @ 'senx +! 1 + ) drop
	  0 ( nen <? dup 2 << 'eny + @ 'seny +! 1 + ) drop
	  0 ( nen <? dup 2 << 'envx + @ 'senvx +! 1 + ) drop
	  0 ( nen <? dup 2 << 'envy + @ 'senvy +! 1 + ) drop
	  
	  0 ( nen <? dup 2 << 'v1x + 0.0 swap ! 1 + ) drop
	  0 ( nen <? dup 2 << 'v1y + 0.0 swap ! 1 + ) drop
	  0 ( nen <? dup 2 << 'v2x + 0.0 swap ! 1 + ) drop
	  0 ( nen <? dup 2 << 'v2y + 0.0 swap ! 1 + ) drop
	  0 ( nen <? dup 2 << 'v3x + 0.0 swap ! 1 + ) drop
	  0 ( nen <? dup 2 << 'v3y + 0.0 swap ! 1 + ) drop ;

:rule1x | ( i -- )
       2 << dup                             | i i
       'enx + @                             | i bx
       nen 16 << *. senx swap -             | i (senx - N*bx)
       nen 1 - 100 * 16 << /.               | i ((senx - N*bx)/((N-1)*100))
       swap 'v1x + ! ;

:rule1y | ( i -- )
       2 << dup                             | i i
       'eny + @                             | i bx
       nen 16 << *. seny swap -             | i (senx - N*bx)
       nen 1 - 100 * 16 << /.               | i ((senx - N*bx)/((N-1)*100))
       swap 'v1y + ! ;

| put values in (v1x, v1y)
:rule1 | ( -- )
       0 ( nen <? dup
       dup rule1x rule1y
       1 + ) drop ;

:sq dup *. ;

:neg -1.0 *. ;

:getdxdy | ( i j -- dx dy )
	 2dup             | i j i j
	 2 << 'enx + @    | i j i enxj
	 swap             | i j enxj i
	 2 << 'enx + @    | i j enxj enxi
	 -                | i j dx
	 rot
	 2 << 'eny + @    | j dx enyi
	 rot
	 2 << 'eny + @    | dx enyi enyj
	 -                | dx
	 ;

:rule2helper | ( i j -- )
	     2dup =? ( 3drop ; ) drop                                        | stop if i==j
	     2dup getdxdy 2dup sq swap sq + 200.0 >? ( 2drop 3drop ; ) drop | stop if too far away
	     pick3 2 << dup
	     rot
	     swap 'v2y + dup @ rot - swap !
	     'v2x + dup @ rot - swap !
	     "(%d, %d)" print ;
	     2drop ;
	     
:rule2 0 ( nen <?
              0 ( nen <?
	      	2dup rule2helper
       	      1 + ) drop
	      cr
       1 + ) drop ;

:rule3x | ( i -- )
       2 << dup                      | 4*i 4*i
       'envx + @                     | 4*i bvx
       nen 16 << *. senvx swap -     | 4*i (senvx - N*bvx)
       nen 1 - 16 * 16 << /.          | 4*i ((senvx - N*bvx)/((N-1)*16))
       swap 'v3x + ! ;

:rule3y | ( i -- )
       2 << dup                      | i i
       'envy + @                     | i bvy
       nen 16 << *. senvy swap -     | i (senvy - N*bvy)
       nen 1 - 16 * 16 << /.          | i ((senvy - N*bvy)/((N-1)*16))
       swap 'v3y + ! ;

:rule3 | ( -- )
       0 ( nen <? dup
       	 dup rule3x rule3y
       1 + ) drop ;

:sumrulex | ( -- )
	  2 << dup dup dup   | i i i i
	  'v1x + @           | i i i v1
	  swap 'v2x + @      | i i v1 v2
	  rot 'v3x + @ + +   | 
	  swap 'envx + dup @ rot + swap ! ;

:sumruley | ( -- )
	  2 << dup dup dup   | i i i i
	  'v1y + @           | i i i v1
	  swap 'v2y + @      | i i v1 v2
	  rot 'v3y + @ + +   | 
	  swap 'envy + dup @ rot + swap ! ;

:sumrule | ( -- ) add up rules
	 0 ( nen <? dup
	 dup sumrulex sumruley
	 1 + ) drop ;
	 
:moveenemies | ( -- )       x' = x + vx          y' = y + vy
	     boidprep
	     rule1 rule2 rule3
	     sumrule
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
	 rand abs sw 3 / mod +
	 16 << ;

:raneney sh 3 /
	 rand abs sh 3 / mod +
	 16 << ;

:ranenevx 1.25 ;

:ranenevy 1.25 ;

:iniene | ( -- ) Initialize enemy coordinates
	0 ( nen <? dup
	2 << dup
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
     "media/snd/shoot.mp3" sload 'snd_shoot q!
     "media/snd/explode.mp3" sload 'snd_explosion q! ;

:game cls
      keyboard
      bpen 1? ( shootbullet ) drop
      drawstars
      drawenemy
      drawenemies moveenemies
      printbullets
      drawexplosion
      xypen drawship
      drawbullets movebullets fixbullets
      movestars
      1 'curframe +! ;

: ini
  'game onshow ;
