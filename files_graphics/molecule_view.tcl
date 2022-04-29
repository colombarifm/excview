# Generates a CPK molecular representation with the default atom coloring

display resize        800 600
display height        3.800000
display distance      -1.000000
display depthcue      on
display cuedensity    0.30
display nearclip set  0.01
display projection    Orthographic
axes location         off
light 0               on
light 1               on
light 2               off
light 3               off

color Display Background white

mol addrep top
mol modrep 1 0
mol modmaterial 1 0 EdgyShiny
mol modstyle 1 0 CPK 1.00 0.50 50 50
mol modselect 1 0 {all}
mol modcolor 1 top Name

mol selupdate 0 top 0
mol colupdate 0 top 0

scale by 1.15
rotate z by -90
rotate y by  15
translate by 0 0 0

render TachyonInternal _FILENAME__mol.tga

exit
