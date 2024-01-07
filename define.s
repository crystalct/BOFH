;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?eropage memory usage                                                        ?
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

savea           = $02                           ;Register storage for
savex           = $03                           ;interrupts
savey           = $04
frameupdateflag = $05
rastercount     = $06
irqsprstart     = $07
irqsprcount     = $08
irqsprcmp       = $09

scrollx         = $0a                           ;Fine scrolling, with 3 bits
scrolly         = $0b                           ;subpixel accuracy (0-63)
scrollsx        = $0c                           ;Scrolling speed, with 3 bits
scrollsy        = $0d                           ;subpixel accuracy
shiftdir        = $0e                           ;Direction of shift in scrolling
blockx          = $0f                           ;Upper-left corner position
blocky          = $10                           ;within a block (0-3)
mapx            = $11                           ;Upper-left corner within the
mapy            = $12                           ;map
screen          = $13                           ;Number of gamescreen (0 or 1,                                                ;doublebuffering in use)
sortsprstart    = $14
sortsprend      = $15

oldspry         = $18
rdiv16amount    = $18
rmod16amount    = $18
rdiv16index     = $28
rmod16index     = $28
sprorderim      = $38                           ;This is a large temp array
temp1           = $38                           ;(24 bytes) overlapped by other
temp2           = $39                           ;temp variables, that will be
temp3           = $3a                           ;overwritten by each
temp4           = $3b                           ;SORTSPRITES call
temp5           = $3c
temp6           = $3d
temp7           = $3e
temp8           = $3f
temp9           = $40
temp10          = $41
actorxltemp     = $42
actorxhtemp     = $43
actoryltemp     = $44
actoryhtemp     = $45
lastsprvariable = $4f

joystick        = $50
prevjoy         = $51
sprsubxl        = $52
sprsubxh        = $53
sprsubyl        = $54
sprsubyh        = $55
alo             = $56
ahi             = $57
keyrowtbl       = $58
keytype         = $60
keypress        = $61
actweapon       = $62
lvlactstart     = $64
lvlactend       = $66
lvlactcurr      = $68

status          = $90

;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?on-zeropage memory usage                                                    ?
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

LVLACT_MAX    = 256
hiscores        = $0340
maptbllo        = $0400
maptblhi        = $0480
blktbllo        = $0500
blktblhi        = $0600
cvfinal         = $0700
music           = $0800
start           = $1960
lvlact0         = $8000
lvlact1         = $8000+LVLACT_MAX*5*1
lvlact2         = $8000+LVLACT_MAX*5*2
lvlact3         = $8000+LVLACT_MAX*5*3
lvlact4         = $8000+LVLACT_MAX*5*4
lvlact5         = $8000+LVLACT_MAX*5*5
lvlact6         = $8000+LVLACT_MAX*5*6

mapdata         = $9e63
blocks          = $ae00
blkcoltbl       = $be00

charinfotbl     = $bf00
chars           = $c000
sprites         = $c800
colors          = $d800
screen1         = $f000
screen2         = $f400
textscreen      = $f400
textchars       = $f800

ciout           = $ffa8         ;Kernal routines
listen          = $ffb1
second          = $ff93
unlsn           = $ffae
acptr           = $ffa5
chkin           = $ffc6
chkout          = $ffc9
chrin           = $ffcf
chrout          = $ffd2
ciout           = $ffa8
close           = $ffc3
open            = $ffc0
setmsg          = $ff90
setnam          = $ffbd
setlfs          = $ffba
clrchn          = $ffcc
getin           = $ffe4
load            = $ffd5
save            = $ffd8
