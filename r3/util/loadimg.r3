| load image from diferent sources
| PHREDA 2017
|----------------------------------------
^r3/util/loadjpg.r3
^r3/util/loadpng.r3
^r3/util/loadbmp.r3
^r3/util/loadtga.r3

::loadimg | filename -- img
	".jpg" =pos 1? ( drop loadjpg ; ) drop
	".png" =pos 1? ( drop loadpng ; ) drop
	".bmp" =pos 1? ( drop loadbmp ; ) drop
	".tga" =pos 1? ( drop loadtga ; )
	2drop 0 ;
