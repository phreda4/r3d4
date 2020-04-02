| RAYCASTING
| From Lode's Computer Graphics Tutorial
| PHREDA 2020

^r3/lib/gui.r3

#worldMap (
  4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 7 7 7 7 7 7 7 7
  4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7 0 0 0 0 0 0 7
  4 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
  4 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7
  4 0 3 0 0 0 0 0 0 0 0 0 0 0 0 0 7 0 0 0 0 0 0 7
  4 0 4 0 0 0 0 5 5 5 5 5 5 5 5 5 7 7 0 7 7 7 7 7
  4 0 5 0 0 0 0 5 0 5 0 5 0 5 0 5 7 0 0 0 7 7 7 1
  4 0 6 0 0 0 0 5 0 0 0 0 0 0 0 5 7 0 0 0 0 0 0 8
  4 0 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7 7 7 1
  4 0 8 0 0 0 0 5 0 0 0 0 0 0 0 5 7 0 0 0 0 0 0 8
  4 0 0 0 0 0 0 5 0 0 0 0 0 0 0 5 7 0 0 0 7 7 7 1
  4 0 0 0 0 0 0 5 5 5 5 0 5 5 5 5 7 7 7 7 7 7 7 1
  6 6 6 6 6 6 6 6 6 6 6 0 6 6 6 6 6 6 6 6 6 6 6 6
  8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4
  6 6 6 6 6 6 0 6 6 6 6 0 6 6 6 6 6 6 6 6 6 6 6 6
  4 4 4 4 4 4 0 4 4 4 6 0 6 2 2 2 2 2 2 2 3 3 3 3
  4 0 0 0 0 0 0 0 0 4 6 0 6 2 0 0 0 0 0 2 0 0 0 2
  4 0 0 0 0 0 0 0 0 0 0 0 6 2 0 0 5 0 0 2 0 0 0 2
  4 0 0 0 0 0 0 0 0 4 6 0 6 2 0 0 0 0 0 2 2 0 2 2
  4 0 6 0 6 0 0 0 0 4 6 0 0 0 0 0 5 0 0 0 0 0 0 2
  4 0 0 5 0 0 0 0 0 4 6 0 6 2 0 0 0 0 0 2 2 0 2 2
  4 0 6 0 6 0 0 0 0 4 6 0 6 2 0 0 5 0 0 2 0 0 0 2
  4 0 0 0 0 0 0 0 0 4 6 0 6 2 0 0 0 0 0 2 0 0 0 2
  4 4 4 4 4 4 4 4 4 4 1 1 1 2 2 2 2 2 2 3 3 3 3 3
)

#texture 0 0 0 0 0 0 0 0

#posX #posY
#dirX #dirY
#planeX #planeY

:initex
	mark
	;

#rayDirX
#rayDirY
#sideDistX
#sideDistY
#deltaDistX
#deltaDistY
#perpWallDist
#stepX
#stepY
#side

:calcDistX
	rayDirX sign 16 << 'stepX !
	-? ( drop posX $ffff and 'sideDistX ! ; ) drop
	1.0 posX $ffff and - 'sideDistX ! ;

:calcDistY
	rayDirY sign 16 << 'stepY !
	-? ( drop posY $ffff and 'sideDistY ! ; ) drop
	1.0 posY $ffff and - 'sideDistY ! ;

:maphit | mx my -- hit
	16 >> 24 * swap 16 >> +
	0 <? ( trace )
	24 24 * >? ( trace )
	'worldMap + c@ ;

:step | mx my -- mx' my'
	sideDistX sideDistY <? ( drop
		deltaDistX 'sideDistX +!
		swap stepX + swap 0 'side ! ;
		) drop
	deltaDistY 'sideDistY +!
	stepY + 1 'side ! ;

#texn

:dda | -- mapx mapy
	posX posY
	( 2dup maphit 0?
		drop step )
	'texn !
	;

:perpWall | mapx mapy --
    side 0? ( 2drop posX - 1.0 stepX - 1 >> + rayDirX 0? ( 1.0 + ) /. ; ) drop nip
	posY - 1.0 stepY - 1 >> + rayDirY 0? ( 1.0 + ) /.
	;


#lineHeight
#y1
#y2

:drawline | x -- x
	dup 17 << sw / 1.0 - | 'cameraX ! = 2 * x / (double)w - 1; //x-coordinate in camera space
	dup
	planeX *. dirX + 'rayDirX ! | = dirX + planeX*cameraX;
	planeY *. dirY + 'rayDirY ! | = dirY + planeY*cameraX;
	1.0 rayDirX 0? ( 1.0 + ) /. abs 'deltaDistX !
	1.0 rayDirY 0? ( 1.0 + ) /. abs 'deltaDistY !
	calcDistX
	calcDistY
	dda | mapx mapy
	perpWall 'perpWallDist !
	sh 16 << perpWallDist 
	0? ( 1 + ) /
	'lineHeight !
	sh 1 >> lineHeight 1 >>
	2dup - clamp0 'y1 !
	+ sh clampmax 'y2 !
	dup 2 << vframe + >a
	0
	( y1 <? 1 +
		$ff00 a!
		sw 2 << a+
		)
	( y2 <? 1 +
		$ff a!
		sw 2 << a+
		)
	drop
	;

|      //calculate value of wallX
|      double wallX; //where exactly the wall was hit
|      if(side == 0) wallX = posY + perpWallDist * rayDirY;
|      else          wallX = posX + perpWallDist * rayDirX;
|      wallX -= floor((wallX));

|      //x coordinate on the texture
||      int texX = int(wallX * double(texWidth));
|      if(side == 0 && rayDirX > 0) texX = texWidth - texX - 1;
|      if(side == 1 && rayDirY < 0) texX = texWidth - texX - 1;

|      // TODO: an integer-only bresenham or DDA like algorithm could make the texture coordinate stepping faster
|      // How much to increase the texture coordinate per screen pixel
|      double step = 1.0 * texHeight / lineHeight;
|      // Starting texture coordinate
|      double texPos = (drawStart - h / 2 + lineHeight / 2) * step;
|      for(int y = drawStart; y < drawEnd; y++)
|      {
|        // Cast the texture coordinate to integer, and mask with (texHeight - 1) in case of overflow
|        int texY = (int)texPos & (texHeight - 1);
|        texPos += step;
|        Uint32 color = texture[texNum][texHeight * texY + texX];
|        //make color darker for y-sides: R, G and B byte each divided through two with a "shift" and an "and"
|        if(side == 1) color = (color >> 1) & 8355711;
|        buffer[y][x] = color;
|      }
|    }


:render
	0 ( sw <?
		drawline
		1 + ) drop  ;

:mover | speed --
	dirX over *. posX + posy maphit 0? ( over dirX *. 'posX +! ) drop
	posX over dirY *. posY + maphit 0? ( over dirY *. 'posY +! ) drop
	drop
	;

#angr

:rota
	angr + dup 'angr !
	1.0 polar | bangle largo -- dx dy
	2dup 'dirX ! 'dirY !
	neg 'planeY ! 'planeX !
	;

#vrot
#vmov

:game
	cls
	render
	home
	$ffffff 'ink !
	over "%d" print cr
	posx posy "%f %f " print
	dirX dirY "%f %f " print cr
	key
	<le> =? ( -0.01 'vrot ! )
	<ri> =? ( 0.01 'vrot ! )
	>le< =? ( 0 'vrot ! ) >ri< =? ( 0 'vrot ! )
	<up> =? ( 0.2 'vmov ! )
	<dn> =? ( -0.2 'vmov ! )
	>up< =? ( 0 'vmov ! ) >dn< =? ( 0 'vmov ! )
	>esc< =? ( exit )
	drop

	vrot 1? ( dup rota ) drop
	vmov 1? ( dup mover ) drop
	;

:main
	6.0 'posX ! 6.0 'posY !
	-1.0 'dirX ! 0.0 'dirY !
	0.0 'planeX ! 0.66 'planeY !
	33 31
	'game onshow ;

: initex main ;