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

mol addrep top
mol modrep 2 0
mol modmaterial 2 0 EdgyShiny
mol modstyle 2 0 QuickSurf 0.80 1.80 0.5 3.0
mol modselect 2 0 {name Cu S}
mol modcolor 2 top Name

mol selupdate 0 top 0
mol colupdate 0 top 0

scale by _SCALE_
rotate z by _ROTZ_
rotate y by _ROTY_
rotate x by _ROTX_
translate by _TRANSX_ _TRANSY_ _TRANSZ_

render TachyonInternal _FILENAME__mol.tga

exit
