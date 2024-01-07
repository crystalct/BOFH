;BOFH.S data

victorytext:    dc.b " ",0
                dc.b "THE MASSACRE IS OVER, AND THE BOFH HAS",0
                dc.b "PREVAILED. HE FEELS DELIGHT AS ALL THE",0
                dc.b "SERVERS AND WOKRSTATIONS WILL NOW BE",0
                dc.b "UNDER HIS SOLE COMMAND AGAIN. AND",0
                dc.b "ALTHOUGH HE DOESN'T CARE ABOUT IT, MAYBE",0
                dc.b "THE LUSERS WILL RESPECT HIM MORE NOW.",0
                dc.b "OF COURSE ALL THE DAMAGE MUST BE",0
                dc.b "REPAIRED BUT IT WON'T BE HIS JOB!",0
                dc.b " ",0,0


scratch:        dc.b "S0:"
hiscorename:    dc.b "BOFH HISCORE"

hiscorestring:  dc.b "                      ",0

titletxttbl:    dc.w titlep
                dc.w title0
                dc.w 0                  ;Hiscores
                dc.w title1
                dc.w title2
                dc.w title3
                dc.w title4
                dc.w title5
                dc.w title6

difftexttbl:    dc.w diff0
                dc.w diff1
                dc.w diff2
                dc.w diff3
                dc.w diff4

hiscorerow:     dc.b 0
hiscorecursor:  dc.b 0
hiscoreindex:   dc.b 0
titlescreen:    dc.b 0
titledelay:     dc.b 0

;SCREEN.S data

cfadr:          dc.w chars+204*8+6
                dc.w chars+204*8+6
                dc.w chars+205*8+6
                dc.w chars+205*8+6
                dc.w chars+206*8+6
                dc.w chars+206*8+6
                dc.w chars+207*8+1
                dc.w chars+207*8+1

                dc.w chars+208*8+1
                dc.w chars+208*8+1
                dc.w chars+209*8+1
                dc.w chars+209*8+1
                dc.w chars+214*8+1
                dc.w chars+214*8+3
                dc.w chars+214*8+5
                dc.w chars+214*8+7

                dc.w chars+215*8+1
                dc.w chars+215*8+3
                dc.w chars+215*8+5
                dc.w chars+215*8+7
                dc.w chars+216*8+1
                dc.w chars+216*8+3
                dc.w chars+216*8+7
                dc.w chars+230*8+1

                dc.w chars+230*8+5
                dc.w chars+230*8+7
                dc.w chars+231*8+1
                dc.w chars+231*8+3
                dc.w chars+231*8+7
                dc.w chars+232*8+1
                dc.w chars+232*8+5
                dc.w chars+232*8+7

cfeor:          dc.b %00110000
                dc.b %00000011
                dc.b %00110000
                dc.b %00000011
                dc.b %00110000
                dc.b %00000011
                dc.b %00110000
                dc.b %00000011

                dc.b %00110000
                dc.b %00000011
                dc.b %00110000
                dc.b %00000011
                dc.b %00001100
                dc.b %00001100
                dc.b %00001100
                dc.b %00001100

                dc.b %00001100
                dc.b %00001100
                dc.b %00001100
                dc.b %00001100
                dc.b %00001100
                dc.b %00001100
                dc.b %00001100
                dc.b %00110000

                dc.b %00110000
                dc.b %00110000
                dc.b %00110000
                dc.b %00110000
                dc.b %00110000
                dc.b %00110000
                dc.b %00110000
                dc.b %00110000






cpr_tbl:        dc.b $01,$02,$03,$80
                dc.b $05,$06,$07,$84
                dc.b $09,$0a,$0b,$88
                dc.b $0d,$0e,$0f,$8c

cpd_tbl:        dc.b $04,$05,$06,$07
                dc.b $08,$09,$0a,$0b
                dc.b $0c,$0d,$0e,$0f
                dc.b $80,$81,$82,$83

sprortbl:       dc.b %00000001
                dc.b %00000010
                dc.b %00000100
                dc.b %00001000
                dc.b %00010000
                dc.b %00100000
                dc.b %01000000
                dc.b %10000000

sprandtbl:      dc.b %11111110
                dc.b %11111101
                dc.b %11111011
                dc.b %11110111
                dc.b %11101111
                dc.b %11011111
                dc.b %10111111
                dc.b %01111111

colorjmptbllo:  dc.b <sw_upleft
                dc.b <sw_up
                dc.b <sw_upright
                dc.b <sw_left
                dc.b <sw_donothing
                dc.b <sw_right
                dc.b <sw_downleft
                dc.b <sw_down
                dc.b <sw_downright

colorjmptblhi:  dc.b >sw_upleft
                dc.b >sw_up
                dc.b >sw_upright
                dc.b >sw_left
                dc.b >sw_donothing
                dc.b >sw_right
                dc.b >sw_downleft
                dc.b >sw_down
                dc.b >sw_downright

shiftsrctbl:    dc.b 0,0,1
                dc.b 40,40,41
                dc.b 80,80,81

shiftdesttbl:   dc.b 1,0,0
                dc.b 1,0,0
                dc.b 1,0,0

shiftworktbl:   dc.b 39,39,38
                dc.b 39,39,38
                dc.b 39,39,38

blockdxtbl:     dc.b -1, 0, 1
                dc.b -1, 0, 1
                dc.b -1, 0, 1

blockdytbl:     dc.b -1,-1,-1
                dc.b 0,0,0
                dc.b 1,1,1

scrrowtbllo:
N               set 0
                repeat 25
                dc.b <(N*40)
N               set N+1
                repend

scrrowtblhi:
N               set 0
                repeat 25
                dc.b >(N*40)
N               set N+1
                repend

scradrtblhi:    dc.b >screen1, >screen2, >textscreen
d018tbl:        dc.b $c0, $d0, $de

colorupdateflag:dc.b $00
oldactxh:       dc.b $ff
oldactyh:       dc.b $ff
vmapx:          dc.b $00
vmapy:          dc.b $00

mapsizex:       dc.b 74
mapsizey:       dc.b 54


;CONTROL.S data

asciitbl:       dc.b 255,13,0,0,0,0,0,0
                dc.b "3WA4ZSE",0
                dc.b "5RD6CFTX"
                dc.b "7YG8BHUV"
                dc.b "9IJ0MKON"
                dc.b 0,"PL",0,".",0,"@,"
                dc.b 0,0,0,0,0,0,0,"/"
                dc.b "1",0,0,"2 ",0,"Q",0

keyrowbit:      dc.b $fe,$fd,$fb,$f7,$ef,$df,$bf,$7f
kcrownum:       dc.b 7,1,1,1,2,1,2,2,1,6
kcrowand:       dc.b $40,$02,$40,$04,$04,$10,$80,$10,$80,$10

kcjoybits:      dc.b JOY_LEFT+JOY_UP
                dc.b JOY_UP
                dc.b JOY_RIGHT+JOY_UP
                dc.b JOY_LEFT
                dc.b JOY_RIGHT
                dc.b JOY_LEFT+JOY_DOWN
                dc.b JOY_DOWN
                dc.b JOY_RIGHT+JOY_DOWN
                dc.b JOY_FIRE
                dc.b JOY_FIRE





;MATH.S data

sintbl:         dc.b 0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45
                dc.b 48,51,54,57,59,62,65,67,70,73,75,78,80,82,85,87
                dc.b 89,91,94,96,98,100,102,103,105,107,108,110,112,113,114,116
                dc.b 117,118,119,120,121,122,123,123,124,125,125,126,126,126,126,126
costbl:         dc.b 127,126,126,126,126,126,125,125,124,123,123,122,121,120,119,118
                dc.b 117,116,114,113,112,110,108,107,105,103,102,100,98,96,94,91
                dc.b 89,87,85,82,80,78,75,73,70,67,65,62,59,57,54,51
                dc.b 48,45,42,39,36,33,30,27,24,21,18,15,12,9,6,3
                dc.b 0,-3,-6,-9,-12,-15,-18,-21,-24,-27,-30,-33,-36,-39,-42,-45
                dc.b -48,-51,-54,-57,-59,-62,-65,-67,-70,-73,-75,-78,-80,-82,-85,-87
                dc.b -89,-91,-94,-96,-98,-100,-102,-103,-105,-107,-108,-110,-112,-113,-114,-116
                dc.b -117,-118,-119,-120,-121,-122,-123,-123,-124,-125,-125,-126,-126,-126,-126,-126
                dc.b -127,-126,-126,-126,-126,-126,-125,-125,-124,-123,-123,-122,-121,-120,-119,-118
                dc.b -117,-116,-114,-113,-112,-110,-108,-107,-105,-103,-102,-100,-98,-96,-94,-91
                dc.b -89,-87,-85,-82,-80,-78,-75,-73,-70,-67,-65,-62,-59,-57,-54,-51
                dc.b -48,-45,-42,-39,-36,-33,-30,-27,-24,-21,-18,-15,-12,-9,-6,-3
                dc.b 0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45
                dc.b 48,51,54,57,59,62,65,67,70,73,75,78,80,82,85,87
                dc.b 89,91,94,96,98,100,102,103,105,107,108,110,112,113,114,116
                dc.b 117,118,119,120,121,122,123,123,124,125,125,126,126,126,126,126

sqrttbl:        dc.b 0,1,1,1,2,2,2,2,2,3,3,3,3,3,3,3
                dc.b 4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5
                dc.b 5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6
                dc.b 6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
                dc.b 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
                dc.b 8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
                dc.b 9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10
                dc.b 10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11
                dc.b 11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11
                dc.b 12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12
                dc.b 12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13
                dc.b 13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13
                dc.b 13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14
                dc.b 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
                dc.b 14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
                dc.b 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15

atantbl:        dc.b 0,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
                dc.b 0,32,45,50,54,55,57,58,58,59,59,60,60,60,61,61
                dc.b 0,18,32,40,45,48,50,52,54,55,55,56,57,57,58,58
                dc.b 0,13,23,32,37,41,45,47,49,50,52,53,54,54,55,55
                dc.b 0,9,18,26,32,36,40,42,45,46,48,49,50,51,52,53
                dc.b 0,8,15,22,27,32,35,38,41,43,45,46,47,49,50,50
                dc.b 0,6,13,18,23,28,32,35,37,40,41,43,45,46,47,48
                dc.b 0,5,11,16,21,25,28,32,34,37,39,40,42,43,45,46
                dc.b 0,5,9,14,18,22,26,29,32,34,36,38,40,41,42,44
                dc.b 0,4,8,13,17,20,23,26,29,32,34,36,37,39,40,41
                dc.b 0,4,8,11,15,18,22,24,27,29,32,33,35,37,38,40
                dc.b 0,3,7,10,14,17,20,23,25,27,30,32,33,35,36,38
                dc.b 0,3,6,9,13,16,18,21,23,26,28,30,32,33,35,36
                dc.b 0,3,6,9,12,14,17,20,22,24,26,28,30,32,33,34
                dc.b 0,2,5,8,11,13,16,18,21,23,25,27,28,30,32,33
                dc.b 0,2,5,8,10,13,15,17,19,22,23,25,27,29,30,32


;WEAPON.S data

ammomaxlo:      dc.b <$999
                dc.b <$999
                dc.b <$999
                dc.b <$50
                dc.b <$200
                dc.b <$100
                dc.b <$200
                dc.b <$500
                dc.b <$20
ammomaxhi:      dc.b >$999
                dc.b >$999
                dc.b >$999
                dc.b >$50
                dc.b >$200
                dc.b >$100
                dc.b >$200
                dc.b >$500
                dc.b >$20

ammoaddlo:      dc.b <$999
                dc.b <$999
                dc.b <$999
                dc.b <$10
                dc.b <$15
                dc.b <$10
                dc.b <$30
                dc.b <$100
                dc.b <$3

ammoaddhi:      dc.b >$999
                dc.b >$999
                dc.b >$999
                dc.b >$10
                dc.b >$15
                dc.b >$10
                dc.b >$30
                dc.b >$100
                dc.b >$3


;SOUND.S data

sfxtbl:         dc.w sfx_pistol,sfx_fist,sfx_whip,sfx_bnd,sfx_shotgun,sfx_uzi
                dc.w sfx_flame,sfx_crossbow,sfx_explosion,sfx_throw,sfx_hit,sfx_death
                dc.w sfx_collect,sfx_select,sfx_cutwire,sfx_bofhhit

sfx_pistol:     dc.b $00                ;Attack/Decay
                dc.b $e9                ;Sustain/Release
                dc.b $08                ;Pulse (nybbles reversed)
                dc.b $c0,$81
                dc.b $a8,$41
                dc.b $be,$80
                dc.b $bc
                dc.b $ba
                dc.b $b8
                dc.b $b6
                dc.b $b4
                dc.b $b2
                dc.b $b0
                dc.b $ae
                dc.b $ac
                dc.b $aa
                dc.b $a8
                dc.b $a6
                dc.b $a4
                dc.b $a2
                dc.b $a0
                dc.b $9e
                dc.b $9c
                dc.b $00

sfx_fist:       dc.b $42                ;Attack/Decay
                dc.b $b7                ;Sustain/Release
                dc.b $00                ;Pulse (nybbles reversed)
                dc.b $c5,$81
                dc.b $c2,$80
                dc.b $f8
                dc.b $00

sfx_whip:       dc.b $52                ;Attack/Decay
                dc.b $b9                ;Sustain/Release
                dc.b $00                ;Pulse (nybbles reversed)
                dc.b $c0,$81
                dc.b $c1
                dc.b $c2
                dc.b $c3
                dc.b $c4,$80
                dc.b $c3
                dc.b $c2
                dc.b $c1
                dc.b $c0
                dc.b $bf
                dc.b $be
                dc.b $bd
                dc.b $bc
                dc.b $00

sfx_bnd:        dc.b $00
                dc.b $e9
                dc.b $01
                dc.b $b4,$51
                dc.b $a4
                dc.b $b4
                dc.b $a4
                dc.b $a8,$50
                dc.b $a6
                dc.b $a4
                dc.b $a2
                dc.b $a0
                dc.b $9f
                dc.b $9e
                dc.b $9d
                dc.b $9c
                dc.b $9b
                dc.b $9a
                dc.b $00

sfx_shotgun:    dc.b $00                ;Attack/Decay
                dc.b $ea                ;Sustain/Release
                dc.b $08                ;Pulse (nybbles reversed)
                dc.b $ac,$41
                dc.b $a4
                dc.b $90,$81
                dc.b $98
                dc.b $9c,$80
                dc.b $98
                dc.b $94
                dc.b $90
                dc.b $98
                dc.b $94
                dc.b $90
                dc.b $8c
                dc.b $8a
                dc.b $88
                dc.b $86
                dc.b $84
                dc.b $82
                dc.b $00

sfx_uzi:        dc.b $00                ;Attack/Decay
                dc.b $e8                ;Sustain/Release
                dc.b $08                ;Pulse (nybbles reversed)
                dc.b $c0,$81
                dc.b $a8,$41
                dc.b $c0,$80
                dc.b $bc
                dc.b $be
                dc.b $ba
                dc.b $b8
                dc.b $b6
                dc.b $b4
                dc.b $b2
                dc.b $b0
                dc.b $00

sfx_flame:      dc.b $02                ;Attack/Decay
                dc.b $e8                ;Sustain/Release
                dc.b $00                ;Pulse (nybbles reversed)
                dc.b $a8,$81
                dc.b $a4,$80
                dc.b $a0
                dc.b $a4
                dc.b $a0
                dc.b $a4
                dc.b $a0
                dc.b $a4
                dc.b $00

sfx_crossbow:   dc.b $82
                dc.b $d2
                dc.b $00
                dc.b $cc,$81
                dc.b $fc
                dc.b $cc,$80
                dc.b $f8
                dc.b $00

sfx_explosion:  dc.b $00
                dc.b $ea
                dc.b $08
                dc.b $b0,$81
                dc.b $a8,$41
                dc.b $a4
                dc.b $a0
                dc.b $90,$81
                dc.b $92
                dc.b $94
                dc.b $96,$80
                dc.b $94
                dc.b $92
                dc.b $90
                dc.b $92
                dc.b $94
                dc.b $96
                dc.b $94
                dc.b $92
                dc.b $90
                dc.b $92
                dc.b $94
                dc.b $96
                dc.b $94
                dc.b $92
                dc.b $90
                dc.b $92
                dc.b $94
                dc.b $96
                dc.b $94
                dc.b $92
                dc.b $90
                dc.b $92
                dc.b $94
                dc.b $96
                dc.b $94
                dc.b $92
                dc.b $90
                dc.b $00

sfx_throw:      dc.b $00
                dc.b $ca
                dc.b $00
                dc.b $bf,$11
                dc.b $bf
                dc.b $be,$10
                dc.b $be
                dc.b $bd
                dc.b $bd
                dc.b $bc
                dc.b $bc
                dc.b $bb
                dc.b $bb
                dc.b $ba
                dc.b $ba
                dc.b $b9
                dc.b $b9
                dc.b $b8
                dc.b $b8
                dc.b $b7
                dc.b $b7
                dc.b $b6
                dc.b $b6
                dc.b $b5
                dc.b $b5
                dc.b $b4
                dc.b $b4
                dc.b $00

sfx_hit:        dc.b $00                ;Attack/Decay
                dc.b $e8                ;Sustain/Release
                dc.b $08                ;Pulse (nybbles reversed)
                dc.b $c8,$81
                dc.b $a8,$41
                dc.b $a7,$40
                dc.b $a6
                dc.b $a5
                dc.b $a4
                dc.b $a3
                dc.b $a2
                dc.b $a1
                dc.b $00

sfx_death:      dc.b $00
                dc.b $ea
                dc.b $08
                dc.b $c4,$81
                dc.b $c0,$81
                dc.b $ac,$41
                dc.b $bc,$81
                dc.b $aa,$40
                dc.b $ba,$80
                dc.b $a8,$40
                dc.b $b8,$80
                dc.b $a6,$40
                dc.b $b6,$80
                dc.b $a4,$40
                dc.b $b4,$80
                dc.b $a2,$40
                dc.b $b2,$80
                dc.b $a0,$40
                dc.b $b0,$80
                dc.b $9e,$40
                dc.b $ae,$80
                dc.b $9c,$40
                dc.b $ac,$80
                dc.b $9a,$40
                dc.b $aa,$80
                dc.b $98,$40
                dc.b $a8,$80
                dc.b $96,$40
                dc.b $a6,$80
                dc.b $94,$40
                dc.b $a4,$80
                dc.b $92,$40
                dc.b $a2,$80
                dc.b $90,$40
                dc.b $a0,$80
                dc.b $00

sfx_collect:    dc.b $01                ;Attack/Decay
                dc.b $6a                ;Sustain/Release
                dc.b $08                ;Pulse (nybbles reversed)
                dc.b $b0,$41
                dc.b $b0
                dc.b $b4,$40
                dc.b $b4
                dc.b $b7
                dc.b $b7
                dc.b $b0
                dc.b $b0
                dc.b $b4
                dc.b $b4
                dc.b $b7
                dc.b $b7
                dc.b $b0
                dc.b $b0
                dc.b $b4
                dc.b $b4
                dc.b $b7
                dc.b $b7
                dc.b $b0
                dc.b $b0
                dc.b $b4
                dc.b $b4
                dc.b $b7
                dc.b $b7
                dc.b $00

sfx_select:     dc.b $00                ;Attack/Decay
                dc.b $57                ;Sustain/Release
                dc.b $04                ;Pulse (nybbles reversed)
                dc.b $b0,$41
                dc.b $b0
                dc.b $b7
                dc.b $b7,$40
                dc.b $b0
                dc.b $b0
                dc.b $b7
                dc.b $b7
                dc.b $b0
                dc.b $b0
                dc.b $b7
                dc.b $b7
                dc.b $b0
                dc.b $b0
                dc.b $b7
                dc.b $b7
                dc.b $b0
                dc.b $b0
                dc.b $b7
                dc.b $b7
                dc.b $b0
                dc.b $b0
                dc.b $b7
                dc.b $b7
                dc.b $00

sfx_cutwire:    dc.b $00                ;Attack/Decay
                dc.b $e5                ;Sustain/Release
                dc.b $08                ;Pulse (nybbles reversed)
                dc.b $c8,$81
                dc.b $ac,$41
                dc.b $c4,$81
                dc.b $c0,$80
                dc.b $bc
                dc.b $bb
                dc.b $ba
                dc.b $00

sfx_bofhhit:    dc.b $00                ;Attack/Decay
                dc.b $e8                ;Sustain/Release
                dc.b $08                ;Pulse (nybbles reversed)
                dc.b $c8,$81
                dc.b $ab,$41
                dc.b $a9
                dc.b $aa
                dc.b $a8
                dc.b $a9,$40
                dc.b $a7
                dc.b $a8
                dc.b $a6
                dc.b $a7
                dc.b $a5
                dc.b $a6
                dc.b $a4
                dc.b $a5
                dc.b $00

nextsndchn:     dc.b 0
musicmode:      dc.b 1
tunenum:        dc.b 0
prevtune:       dc.b $ff

;ACTOR.S data

hitsoundplayed: dc.b 0

actt:           ds.b MAXACT,0
actxl:          ds.b MAXACT,0
actxh:          ds.b MAXACT,0
actyl:          ds.b MAXACT,0
actyh:          ds.b MAXACT,0
actsd:          ds.b MAXACT,0
acth:           ds.b MAXACT,0
actsh:          ds.b MAXACT,0
actsx:          ds.b MAXACT,0
actsy:          ds.b MAXACT,0
actd:           ds.b MAXACT,0
actf:           ds.b MAXACT,0
actfd:          ds.b MAXACT,0
actattk:        ds.b MAXACT,0
actattkd:       ds.b MAXACT,0
actc:           ds.b MAXACT,0
actmode:        ds.b MAXACT,0
acttime:        ds.b MAXACT,0
actctrl:        ds.b MAXACT,0
acthplo:        ds.b MAXACT,0
acthphi:        ds.b MAXACT,0
actorglo:       ds.b MAXACT,0
actorghi:       ds.b MAXACT,0

walkfrtbl:      dc.b 1,0,1,2

acttbl:         dc.w act_bullet
                dc.w act_smoke
                dc.w act_meleehit
                dc.w act_flame
                dc.w act_grenade
                dc.w act_arrow
                dc.w act_explosion
                dc.w act_item
                dc.w act_bofh
                dc.w act_workstation
                dc.w act_printer
                dc.w act_bigprinter
                dc.w act_laptop
                dc.w act_workstation ;PC server
                dc.w act_sunserver   ;SUN server
                dc.w act_cdtower ;CD tower
                dc.w act_fistman
                dc.w act_pistolman
                dc.w act_shotgunman
                dc.w act_uziman
                dc.w act_sadist
                dc.w act_leader
                dc.w act_technician
                dc.w act_corpse1
                dc.w act_corpse2
                dc.w act_shrapnel
                dc.w act_blood

act_bofh:       dc.b 6*8        ;Radius (8 units = pixel)
                dc.b 0          ;Hotspottable index
                dc.b 6          ;Default color
                dc.b PRI_MED    ;Sprite priority
                dc.w ma_bofh    ;Move routine
                dc.b FR+0,FR+4,FR+8,FR+12,FR+16,FR+20,FR+24,FR+28 ;First framenumber for each dir.

act_bullet:     dc.b 5*8
                dc.b 0
                dc.b 7
                dc.b PRI_MED
                dc.w ma_bullet
                dc.b FR+37,FR+38,FR+39,FR+40,FR+41,FR+42,FR+43,FR+44

act_smoke:      dc.b 1*8
                dc.b 0
                dc.b 15
                dc.b PRI_MED
                dc.w ma_smoke
                dc.b FR+45,FR+45,FR+45,FR+45,FR+45,FR+45,FR+45,FR+45

act_meleehit:   dc.b 8*8
                dc.b 2
                dc.b 5
                dc.b PRI_MED
                dc.w ma_meleehit
                dc.b FR+49,FR+51,FR+53,FR+55,FR+57,FR+59,FR+61,FR+63

act_flame:      dc.b 6*8
                dc.b 0
                dc.b 7
                dc.b PRI_HIGH
                dc.w ma_flame
                dc.b FR+65,FR+65,FR+65,FR+65,FR+65,FR+65,FR+65,FR+65

act_grenade:    dc.b 2*8
                dc.b 0
                dc.b 5
                dc.b PRI_LOW
                dc.w ma_grenade
                dc.b FR+69,FR+69,FR+69,FR+69,FR+69,FR+69,FR+69,FR+69

act_arrow:      dc.b 5*8
                dc.b 0
                dc.b 1
                dc.b PRI_MED
                dc.w ma_bullet
                dc.b FR+72,FR+73,FR+74,FR+75,FR+72,FR+73,FR+74,FR+75

act_explosion:  dc.b 12*8
                dc.b 0
                dc.b 7
                dc.b PRI_HIGH
                dc.w ma_explosion
                dc.b FR+76,FR+76,FR+76,FR+76,FR+76,FR+76,FR+76,FR+76

act_item:       dc.b 4*8
                dc.b 0
                dc.b 7
                dc.b PRI_LOW
                dc.w ma_item
                dc.b FR+80,FR+80,FR+80,FR+80,FR+80,FR+80,FR+80,FR+80

act_workstation:dc.b 6*8
                dc.b 0
                dc.b 1
                dc.b PRI_LOW
                dc.w ma_workstation
                dc.b FR+94,FR+95,FR+96,FR+97,FR+98,FR+99,FR+100,FR+101

act_printer:    dc.b 5*8
                dc.b 0
                dc.b 1
                dc.b PRI_LOW
                dc.w ma_workstation
                dc.b FR+102,FR+103,FR+102,FR+103,FR+102,FR+103,FR+102,FR+103

act_bigprinter: dc.b 8*8
                dc.b 0
                dc.b 1
                dc.b PRI_LOW
                dc.w ma_workstation
                dc.b FR+104,FR+105,FR+104,FR+105,FR+104,FR+105,FR+104,FR+105

act_laptop:     dc.b 8*8
                dc.b 0
                dc.b 11
                dc.b PRI_LOW
                dc.w ma_workstation
                dc.b FR+106,FR+107,FR+108,FR+109,FR+106,FR+107,FR+108,FR+109

act_sunserver:  dc.b 6*8
                dc.b 0
                dc.b 1
                dc.b PRI_LOW
                dc.w ma_workstation
                dc.b FR+110,FR+110,FR+110,FR+110,FR+110,FR+110,FR+110,FR+110

act_cdtower:    dc.b 6*8
                dc.b 0
                dc.b 1
                dc.b PRI_LOW
                dc.w ma_workstation
                dc.b FR+111,FR+111,FR+111,FR+111,FR+111,FR+111,FR+111,FR+111

act_fistman:    dc.b 6*8
                dc.b 0
                dc.b 11
                dc.b PRI_MED
                dc.w ma_terrorist
                dc.b FR+0,FR+4,FR+8,FR+12,FR+16,FR+20,FR+24,FR+28 ;First framenumber for each dir.

act_pistolman:  dc.b 6*8
                dc.b 0
                dc.b 12
                dc.b PRI_MED
                dc.w ma_terrorist
                dc.b FR+0,FR+4,FR+8,FR+12,FR+16,FR+20,FR+24,FR+28 ;First framenumber for each dir.

act_shotgunman: dc.b 6*8
                dc.b 0
                dc.b 2
                dc.b PRI_MED
                dc.w ma_terrorist
                dc.b FR+0,FR+4,FR+8,FR+12,FR+16,FR+20,FR+24,FR+28 ;First framenumber for each dir.

act_uziman:     dc.b 6*8
                dc.b 0
                dc.b 14
                dc.b PRI_MED
                dc.w ma_terrorist
                dc.b FR+0,FR+4,FR+8,FR+12,FR+16,FR+20,FR+24,FR+28 ;First framenumber for each dir.

act_sadist:     dc.b 6*8
                dc.b 0
                dc.b 3
                dc.b PRI_MED
                dc.w ma_terrorist
                dc.b FR+0,FR+4,FR+8,FR+12,FR+16,FR+20,FR+24,FR+28 ;First framenumber for each dir.

act_leader:     dc.b 6*8
                dc.b 0
                dc.b 0
                dc.b PRI_MED
                dc.w ma_terrorist
                dc.b FR+0,FR+4,FR+8,FR+12,FR+16,FR+20,FR+24,FR+28 ;First framenumber for each dir.

act_technician: dc.b 6*8
                dc.b 0
                dc.b 5
                dc.b PRI_MED
                dc.w ma_terrorist
                dc.b FR+0,FR+4,FR+8,FR+12,FR+16,FR+20,FR+24,FR+28 ;First framenumber for each dir.

act_corpse1:    dc.b 6*8
                dc.b 0
                dc.b 0
                dc.b PRI_LOW
                dc.w ma_corpse1
                dc.b FR+0,FR+4,FR+8,FR+12,FR+16,FR+20,FR+24,FR+28 ;First framenumber for each dir.

act_corpse2:    dc.b 6*8
                dc.b 0
                dc.b 0
                dc.b PRI_LOW
                dc.w ma_corpse2
                dc.b FR+32,FR+33,FR+34,FR+35,FR+32,FR+33,FR+34,FR+35 ;First framenumber for each dir.

act_shrapnel:   dc.b 10*8
                dc.b 0
                dc.b 1
                dc.b PRI_MED
                dc.w ma_shrapnel
                dc.b FR+91,FR+91,FR+91,FR+91,FR+91,FR+91,FR+91,FR+91

act_blood:      dc.b 2*8
                dc.b 0
                dc.b 2
                dc.b PRI_HIGH
                dc.w ma_blood
                dc.b FR+91,FR+91,FR+91,FR+91,FR+91,FR+91,FR+91,FR+91

actordefaulthp: dc.b 0 ;ACT_BULLET      = 1
                dc.b 0 ;ACT_SMOKE       = 2
                dc.b 0 ;ACT_MELEEHIT    = 3
                dc.b 0 ;ACT_FLAME       = 4
                dc.b 0 ;ACT_GRENADE     = 5
                dc.b 0 ;ACT_ARROW       = 6
                dc.b 0 ;ACT_EXPLOSION   = 7
                dc.b 0 ;ACT_ITEM        = 8
                dc.b $a0 ;ACT_BOFH        = 9
                dc.b $08 ;ACT_WORKSTATION = 10
                dc.b $05 ;ACT_PRINTER     = 11
                dc.b $13 ;ACT_BIGPRINTER  = 12
                dc.b $05 ;ACT_LAPTOP      = 13
                dc.b $10 ;ACT_PCSERVER    = 14
                dc.b $10 ;ACT_SUNSERVER   = 15
                dc.b $10 ;ACT_CDTOWER     = 16
                dc.b $15 ;ACT_FISTMAN     = 17
                dc.b $10 ;ACT_PISTOLMAN   = 18
                dc.b $15 ;ACT_SHOTGUNMAN  = 19
                dc.b $10 ;ACT_UZIMAN      = 20
                dc.b $10 ;ACT_SADIST      = 21
                dc.b $60 ;ACT_LEADER      = 22
                dc.b $13 ;ACT_TECHNICIAN  = 23
                dc.b $0 ;ACT_CORPSE1     = 24
                dc.b $0 ;ACT_CORPSE2     = 25
                dc.b $0 ;ACT_SHRAPNEL    = 26
                dc.b $0 ;ACT_BLOOD       = 27


hotspottbl:     dc.b -9,-8
                dc.b -13,-11

bombcoltbl:     dc.b 1,2,3,1,11,4,7,6,5
bombflashtbl:   dc.b 12,15,1,15
wirenumberxlat: dc.b 0,1,2,5,8,7,6
itemflash:      dc.b 0
itemflashtbl:   dc.b 15,7,1,7
shrapnelflashtbl:dc.b 12,15

cs_xtbllo:      dc.b <0,<16*8,<0,<(-16*8)
cs_xtblhi:      dc.b >0,>16*8,>0,>(-16*8)
cs_ytbllo:      dc.b <(-16*8),<0,<16*8,<0
cs_ytblhi:      dc.b >(-16*8),>0,>16*8,>0

stairdelay:     dc.b 0

;ENEMY.S data

enemyjumptbl:   dc.w ma_patrol
                dc.w ma_hunt
                dc.w ma_goround
                dc.w ma_goround
                dc.w ma_grenadeattack

enemycloseenoughtbl:dc.b 1,4,3,3,5,2,1

enemyattacktbl: dc.b $58,$17,$13,$11,$13,$17,$80
contattacktbl:  dc.b $00,$00,$00,$d0,$c8,$e8,$00

watblx:         dc.b 0,8*8,8*8,8*8,0,-8*8,-8*8,-8*8
watbly:         dc.b -8*8,-8*8,0,8*8,8*8,8*8,0,-8*8

boredtbl:       dc.b $fc,$fc,$fd,$fe,$ff

tscoretbl:      dc.w $0350
                dc.w $0750
                dc.w $1000
                dc.w $1500
                dc.w $2000
                dc.w $5000
                dc.w $2000

titemtbl:       dc.b $ff
                dc.b ITEM_PISTOL
                dc.b ITEM_SHOTGUN
                dc.b ITEM_UZI
                dc.b ITEM_CROSSBOW
                dc.b ITEM_FLAMETHR
                dc.b $ff

itemtbl:        ds.b 12,$ff
                dc.b ITEM_MEDSMALL,ITEM_MEDSMALL,ITEM_MEDLARGE,ITEM_GRENADES

levelitemtbl:   ds.b 1,ITEM_FLAMETHR
                ds.b 1,ITEM_UZI
                ds.b 1,ITEM_SHOTGUN
                ds.b 2,ITEM_GRENADES
                ds.b 3,ITEM_PISTOL
                ds.b 5,ITEM_MEDSMALL
                ds.b 3,ITEM_MEDLARGE


enemytypetbl:   dc.b ACT_FISTMAN
                dc.b ACT_FISTMAN
                dc.b ACT_PISTOLMAN
                dc.b ACT_PISTOLMAN
                dc.b ACT_PISTOLMAN
                dc.b ACT_SHOTGUNMAN
                dc.b ACT_UZIMAN
                dc.b ACT_SADIST

bombtbl:        dc.b 0,4,6,8,9

enemytbl:       dc.w $0000
                dc.w $0100
                dc.w $0150
                dc.w $0200
                dc.w $0250

enemyspdtbl:    dc.b 25
                dc.b 24
                dc.b 22
                dc.b 24
                dc.b 23
                dc.b 25
                dc.b 24

enemywpntbl:    dc.b WPN_FISTS
                dc.b WPN_PISTOL
                dc.b WPN_SHOTGUN
                dc.b WPN_UZI
                dc.b WPN_CROSSBOW
                dc.b WPN_FLAMETHR
                dc.b WPN_FISTS

enemypatroltbl: dc.b 0
                dc.b JOY_UP
                dc.b JOY_UP
                dc.b JOY_UP
                dc.b JOY_UP
                dc.b JOY_UP
                dc.b JOY_LEFT
                dc.b JOY_RIGHT



;SPRITE.S data

sprydiv16tbl:   ds.b 16,$00
                ds.b 16,$01
                ds.b 16,$02
                ds.b 16,$03
                ds.b 16,$04
                ds.b 16,$05
                ds.b 16,$06
                ds.b 16,$07
                ds.b 16,$08
                ds.b 16,$09
                ds.b 16,$0a
                ds.b 16,$0b
                ds.b 16,$0c

sprorder:
sprymod16:      ds.b MAXSPR*2+2,0
sprydiv16:      ds.b MAXSPR*2+2,0
sprf:           ds.b MAXSPR*2+2,0
sprc:           ds.b MAXSPR*2+2,0
sprxl:          ds.b MAXSPR*2+2,0
sprxh:          ds.b MAXSPR*2+2,0
spry:           ds.b MAXSPR*2+2,0
sprpri:         ds.b MAXSPR*2+2,0
sprphys:        ds.b MAXSPR*2+2,0
sprphys2:       ds.b MAXSPR*2+2,0

;PLAYER.S data

bombstat:       ds.b 9,0
wirestat:       ds.b 9*3,0
haveinstr:      ds.b 9*3,0
wirecolor:      ds.b 9*3,0

victorycount:   dc.b 0
explcolor:      dc.b 0
detonate:       dc.b 0
atcloset:       dc.b 0
wirenumber:     dc.b 0
instrview:      dc.b 0
instrviewtime:  dc.b 0
score:          dc.b 0,0,0
terrorists:     dc.b 0,0
bombs:          dc.b 0
instructions:   dc.b 0
leaders:        dc.b 0
computers:      dc.b 0,0
time:           dc.b 0,0
timefr:         dc.b 0
ammolo:         dc.b $99
                ds.b 8,0
ammohi:         dc.b $99
                ds.b 8,0
difficulty:     dc.b DI_EASY
weapon:         dc.b 0
floor:          dc.b 0

panelupdateflag:dc.b 0

                     ;012345678901234567890123456789012345678
panelstring:    dc.b "000000 #000 $000 00:00 %0 &000      000",0

pausetext:      dc.b "PAUSED"

closetname:     dc.b "KJA1"
                dc.b "KJA2"
                dc.b "KJA3"
                dc.b "KJB1"
                dc.b "KJB2"
                dc.b "KJD "
                dc.b "KJE "
                dc.b "KJF "
                dc.b "KJR "

wirelettertbl:  dc.b "WRCPGBY"

closetf:        dc.b 1,3,5,0,2,1,1,1,1
closetx:        dc.b 32,23,32,53,71,11,44,49,23
closety:        dc.b 45,44,45,40,45,34,33,18,12

explcol1:       dc.b 12,10,7,1
explcol2:       dc.b 15,7,1,1


weaponchartbl:  dc.b 96
                dc.b 96+5
                dc.b 96+10
                dc.b 96+40
                dc.b 96+15
                dc.b 96+20
                dc.b 96+25
                dc.b 96+30
                dc.b 96+35

bombdivtbl:     ds.b 3,0
                ds.b 3,1
                ds.b 3,2
                ds.b 3,3
                ds.b 3,4
                ds.b 3,5
                ds.b 3,6
                ds.b 3,7
                ds.b 3,8

;LEVEL.S data

table:            ds.b 31,0     ;For PUCRUNCH

floortbl:         dc.w floor0
                  dc.w floor1
                  dc.w floor2
                  dc.w floor3
                  dc.w floor4
                  dc.w floor5

lvlacttbl:        dc.w lvlact0
                  dc.w lvlact1
                  dc.w lvlact2
                  dc.w lvlact3
                  dc.w lvlact4
                  dc.w lvlact5
                  dc.w lvlact6

floor0:           incbin floor0.pak
floor1:           incbin floor1.pak
floor2:           incbin floor2.pak
floor3:           incbin floor3.pak
floor4:           incbin floor4.pak
floor5:           incbin floor5.pak

initialstate:     incbin state.pak


;OTHER DATA

                org lvlact0
                dc.b 0

                org blocks
                incbin level0.blk
                org charinfotbl
                incbin level0.chr
                org sprites
                incbin bofh.spr
                incbin common.spr
                incbin computer.spr
                incbin bomb.spr

titlep:         dc.b " ",0
                dc.b " ",0
                dc.b " ",0
                dc.b "COVERT BITOPS PRESENTS",0
                dc.b " ",0
                dc.b "AN OLDSKOOL PRODUCTION IN 2002",0
                dc.b " ",0
                dc.b " ",0
                dc.b " ",0
                dc.b " ",0,0

title0:         dc.b "BOFH:SERVERS UNDER SIEGE V1.0",0
                dc.b " ",0
                dc.b "ORIGINAL DESIGN, CODE, GFX AND MUSIC:",0
                dc.b "LASSE \\RNI      OLLI NIEMITALO",0
                dc.b "KALLE NIEMITALO   TUOMAS M[KEL[",0
                dc.b " ",0
                dc.b "C64 CODE AND GFX: LASSE \\RNI",0
                dc.b "C64 MUSIC: OLLI NIEMITALO",0
                dc.b "PUCRUNCH: PASI OJALA",0
                dc.b " ",0,0

                     ;0123456789012345678901234567890123456789
title1:         dc.b "TAKE THE ROLE OF A BOFH AS YOU ARRIVE",0
                dc.b "LATE AT WORK TO FIND YOUR WORKPLACE",0
                dc.b "OVERRUN BY A GROUP OF INSANE ACTIVISTS.",0
                dc.b "THEY HAVE ORDERED PERSONNEL TO LEAVE,",0
                dc.b "TAKEN ALL WORKSTATIONS AND SERVERS AS",0
                dc.b "HOSTAGES AND SET UP BOMBS IN NETWORK",0
                dc.b "EQUIPMENT CLOSETS. OF COURSE, THIS MAKES",0
                dc.b "YOU BOIL WITH WRATH AND THE ONLY LOGICAL",0
                dc.b "COURSE OF ACTION SEEMS TO BE WAGING WAR",0
                dc.b "ON THE ACTIVISTS SINGLE-HANDEDLY.",0,0

title2:         dc.b " ",0
                dc.b "TO BE ABLE TO ENTER AND CONQUER BACK THE",0
                dc.b "SERVER ROOM AT THE 6TH FLOOR YOU MUST",0
                dc.b "FIRST DEFUSE ALL THE BOMBS.",0
                dc.b " ",0
                dc.b "CUT 3 WIRES IN ANY ORDER TO DEFUSE A",0
                dc.b "BOMB. INSTRUCTIONS IN THE FORM OF WIRE",0
                dc.b "COLORS' FIRST LETTERS CAN BE TAKEN FROM",0
                dc.b "THE TECHNICIANS BY FORCE.",0,0
                dc.b " ",0,0

title3:         dc.b "IDENTIFYING THE ACTIVISTS:",0
                dc.b " ",0
                dc.b "GREY    FIST-GUY    ",0
                dc.b "LT.GREY PISTOL-GUY  ",0
                dc.b "RED     SHOTGUN-GUY ",0
                dc.b "LT.BLUE SMG-GUY     ",0
                dc.b "CYAN    CROSSBOW-GUY",0
                dc.b "GREEN   TECHNICIAN  ",0
                dc.b "BLACK   LEADER      ",0
                dc.b " ",0,0

title4:         dc.b " ",0
                dc.b "CONTROL: JOY PORT 2 OR QWEADZXC+SHIFT",0
                dc.b " ",0
                dc.b "V   VIEW INSTRUCTIONS ",0
                dc.b "M   MUSIC ON/OFF      ",0
                dc.b "Q   QUIT (WHEN PAUSED)",0
                dc.b "1-9 SELECT WEAPON     ",0
                dc.b "SPC NEXT WEAPON       ",0
                dc.b "R/S PAUSE ON/OFF      ",0
                dc.b " ",0,0

title5:         dc.b " ",0
                dc.b "WEAPONS:",0
                dc.b " ",0
                dc.b "1 FISTS          6 SHOTGUN      ",0
                dc.b "2 CAT-5 WHIP     7 SUBMACHINEGUN",0
                dc.b "3 ELECTRIC DRILL 8 FLAMETHROWER ",0
                dc.b "4 CROSSBOW       9 GRENADES     ",0
                dc.b "5 PISTOL                        ",0
                dc.b " ",0
                dc.b " ",0,0

title6:         dc.b " ",0
                dc.b "BOFH HOMEPAGE:",0
                dc.b " ",0
                dc.b "HTTP://COVERTBITOPS.CJB.NET",0
                dc.b " ",0
                dc.b "AUTHORS' EMAIL:",0
                dc.b " ",0
                dc.b "LOORNI@STUDENT.OULU.FI",0
                dc.b "ONIEMITA@STUDENT.OULU.FI",0
                dc.b " ",0,0

hiscoretext:    dc.b "YOU ARE A LEGENDARY BOFH",0
                dc.b "ENTER YOUR NAME USING KEYBOARD",0

difftext:       dc.b "SELECT DIFFICULTY:",0

diff0:          dc.b "PRACTICE",0
diff1:          dc.b "  EASY  ",0
diff2:          dc.b " MEDIUM ",0
diff3:          dc.b "  HARD  ",0
diff4:          dc.b " INSANE ",0

hiscoreorder:   dc.b "01020304050607080910"

                org screen1-64
emptysprite:    ds.b 64,0

                org screen1
                ds.b 21*40,0
                ds.b 4*40,32
                ds.b 16,0
                ds.b 8,191

                org textscreen
                ds.b 21*40,0
                ds.b 4*40,32
                ds.b 16,0
                ds.b 8,191

                org textchars
                incbin scorescr.chr



