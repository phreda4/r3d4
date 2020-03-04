^r3/lib/gui.r3

#pp

:main
  cls home
  "sonido" print
  pp "p:%h" print cr
  key
  <f1> =? ( pp splay )
  >esc< =? ( exit )
  drop
  ;

:
  mark
  "media/snd/piano.wav" sload 'pp !
  'main onshow
  ;