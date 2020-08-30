#ddx
#dx #dy
#xp #yp

:floor | -- piso?

	;

:piso
	floor 0? ( drop 0.98 'dy +! ; ) drop
	key <up> =? ( drop -8.0 'dy ! ; ) drop
	drop
	0 'dy !
| fit y to map
	;

:player
	key
	<le> =? ( 0.25 'ddx ! )
	<ri> =? ( -0.25 'ddx ! )
	>le< =? ( 0 'ddx ! )
	>ri< =? ( 0 'ddx ! )

 	drop
    dx ddx 0? ( swap 0.8 *. )
	+ 3.0 min -3.0 max 'dx !

	piso
	dx 'xp +!
	dy 'yp +!
	;
