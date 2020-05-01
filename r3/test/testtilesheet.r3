| test de tileset
| PHREDA 2020
|MEM $ffff

^r3/lib/gui.r3
^r3/lib/sprite.r3
^r3/util/loadimg.r3

#dibujos
#ndib 1

:main
	cls home gui
	ndib "%d" print

	ndib 8 32 dibujos ssprite

	ndib 1 + 100 100 64 dup dibujos sspritesize
	ndib 2 + 164 100 64 dup dibujos sspritesize

	key
	>esc< =? ( exit )
	<up> =? ( ndib 1 + 'ndib ! )
	<dn> =? ( ndib 1 - clamp0 'ndib ! )
	drop
	acursor
	;

:inimem
	mark
	cls home "cargando..." print redraw

	32 32
	"media/img/open_tileset.old.png"
	loadimg tileSheet 'dibujos !
	;

: inimem 'main onShow ;