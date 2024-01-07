SPRMC1          = 10                           ;Sprite multicolors
SPRMC2          = 0
PANELMC1        = 11                           ;Scorepanel multicolors
PANELMC2        = 10

SD_UPLEFT       = 0                             ;Possible screen shifting
SD_UP           = 1                             ;directions (when scrolling)
SD_UPRIGHT      = 2
SD_LEFT         = 3
SD_NOSHIFT      = 4
SD_RIGHT        = 5
SD_DOWNLEFT     = 6
SD_DOWN         = 7
SD_DOWNRIGHT    = 8
SCROLLROWS      = 22                            ;Amount of scrolling rows
MAXBLOCKS       = 256                           ;Maximum amount of different
                                                ;blocks

BV_UP           = $10
BV_DOWN         = $20
BV_LEFT         = $40
BV_RIGHT        = $80

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³INITVIDEO                                                                    ³
;³                                                                             ³
;³Initializes various video registers, like sprite appearance & colors.        ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,temp1-temp4                                                    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

initvideo:      lda #$00
                sta $d020
                sta $d021
                sta $d015                       ;Sprites off
                sta $d01b                       ;Sprites on top of BG
                sta $d017                       ;Sprite Y-expand off
                sta $d01d                       ;Sprite X-expand off
                lda #$ff                        ;Set all sprites multicolor
                sta $d01c
                lda #SPRMC1
                sta $d025                       ;Set sprite multicolor 1
                lda #SPRMC2
                sta $d026                       ;Set sprite multicolor 2
                lda $dd00                       ;Correct videobank
                and #$fc
                sta $dd00
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³INITMAP                                                                      ³
;³                                                                             ³
;³Calculates start addresses for each map-row and for each block.              ³
;³                                                                             ³
;³Parameters: mapsx, mapsy                                                     ³
;³Returns: -                                                                   ³
;³Modifies: A,X,temp1-temp4                                                    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

initmap:        lda #<mapdata                   ;Address of first maprow
                sta temp1
                lda #>mapdata
                sta temp2
                lda #<blocks                    ;Address of first block
                sta temp3
                lda #>blocks
                sta temp4
                ldx #$00                        ;The counter
im_loop:        lda temp2                       ;Store and increase maprow-
                sta maptblhi,x                  ;pointer
                lda temp1
                sta maptbllo,x
                clc
                adc mapsizex
                sta temp1
                bcc im_notover1
                inc temp2
im_notover1:    lda temp4                       ;Store and increase block-
                sta blktblhi,x                  ;pointer
                lda temp3
                sta blktbllo,x
                clc
                adc #$10
                sta temp3
                bcc im_notover2
                inc temp4
im_notover2:    inx                             ;Do 128 rows for the maptable
                beq im_ready
                bpl im_loop
                bmi im_notover1
im_ready:       rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³INITSCROLL                                                                   ³
;³                                                                             ³
;³Resets screen number (doublebuffering), finescrolling & scrolling speed.     ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

initscroll:     lda #$00
                sta screen
is_setscrollpos:lda #$38
                sta scrollx
                sta scrolly
                lda #$00
                sta scrollsx
                sta scrollsy
                lda #SD_NOSHIFT
                sta shiftdir
                jsr sl_calcsprsub
                jmp scrollcolors                ;Put scrollvalues into use

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³SETMAPPOS                                                                    ³
;³                                                                             ³
;³Sets map position as desired and resets block position.                      ³
;³                                                                             ³
;³Parametrit: X,Y - position                                                   ³
;³Palauttaa: -                                                                 ³
;³Modifioi: A                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

setmappos:      stx mapx
                sty mapy
                stx vmapx
                sty vmapy
                lda #$00
                sta blockx
                sta blocky
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³UPDATEBLOCK                                                                  ³
;³                                                                             ³
;³Updates a block on the map, if it's visible.                                 ³
;³                                                                             ³
;³Parameters: A:X coordinate in blocks                                         ³
;³            Y:Y coordinate in blocks                                         ³
;³Returns: -                                                                   ³
;³Modifies: A,Y,temp3-,alo,ahi                                                 ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

updateblock:    stx temp7
                sta temp5
                sec
ub_oldmapx:     sbc #$00
                cmp #11
                bcs ub_done
                asl
                asl
                sec
ub_oldblockx:   sbc #$00
                sta temp3
                lda maptbllo,y
                sta alo
                lda maptblhi,y
                sta ahi
                tya
                sec
ub_oldmapy:     sbc #$00
                cmp #7
                bcs ub_done
                asl
                asl
                sec
ub_oldblocky:   sbc #$00
                sta temp4
                ldy temp5
                lda (alo),y
                tay
                lda blktbllo,y
                sta ub_lda+1
                lda blktblhi,y
                sta ub_lda+2
                ldx screen
                lda scradrtblhi,x
                sta temp6
                ldx #$00
ub_row:         ldy temp4
                cpy #22
                bcs ub_skiprow
                lda scrrowtbllo,y
                sta ub_sta+1
                lda scrrowtblhi,y
                ora temp6
                sta ub_sta+2
                ldy temp3
ub_column:      cpy #39
                bcs ub_skipcolumn
ub_lda:         lda $1000,x
ub_sta:         sta screen1,y
ub_skipcolumn:  iny
                inx
                txa
                and #$03
                bne ub_column
                inc temp4
                cpx #$10
                bcc ub_row
ub_done:        ldx temp7
                rts
ub_skiprow:     txa
                adc #$03                        ;Carry = 1
                tax
                inc temp4
                cpx #$10
                bcc ub_row
                ldx temp7
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³PRINTTEXTC                                                                   ³
;³                                                                             ³
;³Centered text printing                                                       ³
;³                                                                             ³
;³Parameters: Y:row temp1-temp2:address of text                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,temp1-temp2,temp6                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

printtextc:     sty temp6
                ldy #$00
                ldx #40
ptc_getlen:     lda (temp1),y
                beq ptc_ready
                dex
                iny
                bne ptc_getlen
ptc_ready:      txa
                lsr
                tax
                ldy temp6

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³PRINTTEXT                                                                    ³
;³                                                                             ³
;³Prints a zero-terminated string                                              ³
;³                                                                             ³
;³Parameters: X,Y, temp1-temp2:Address of text                                 ³
;³Returns: -                                                                   ³
;³Modifies: A,temp1-temp2,temp6                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

printtext:      sty temp6
                txa
                clc
                adc scrrowtbllo,y
                sta pt_sta1+1
                sta pt_sta3+1
                lda #>textscreen
                adc scrrowtblhi,y
                sta pt_sta1+2
                lda pt_sta1+1
                adc #$28
                sta pt_sta2+1
                sta pt_sta4+1
                lda pt_sta1+2
                adc #$00
                sta pt_sta2+2
                lda pt_sta1+2
                and #$03
                ora #>colors
                sta pt_sta3+2
                lda pt_sta2+2
                and #$03
                ora #>colors
                sta pt_sta4+2
                ldy #$00
pt_printloop:   lda (temp1),y
                beq pt_printend
pt_charok:      sta pt_resta+1
                cmp #44
                beq pt_space
                cmp #46
                bne pt_sta1
pt_space:       lda #$20
pt_sta1:        sta $1000,y
pt_resta:       lda #$00
                cmp #$20
                beq pt_sta2
                clc
                adc #$80
                bcs pt_over
                cmp #$ff
                bcc pt_notover
pt_over:        adc #$10
pt_notover:     cmp #167
                bne pt_sta2
                lda #$20
pt_sta2:        sta $1000,y
                lda #$0f
pt_sta3:        sta $1000,y
pt_sta4:        sta $1000,y
                iny
                jmp pt_printloop
pt_printend:    tya
                sec                             ;Add one more; INY not needed
                adc temp1
                sta temp1
                bcc pt_notover3
                inc temp2
pt_notover3:    ldy temp6
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³HIDESCREEN                                                                   ³
;³                                                                             ³
;³Hides the gamescreen for next screen update.                                 ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

hidescreen:     lda frameupdateflag
                bne hidescreen
                lda irqsprstart                 ;Turn sprites off
                eor #MAXSPR+1
                sta sortsprstart
                sta sortsprend
                jsr sortsprites
                inc frameupdateflag             ;Wait for scorepanel
hscreen_wait:   lda frameupdateflag
                bne hscreen_wait
                lda #$57                        ;Extended color mode + multi-
                sta rgscr_scry+1                ;color mode combined is illegal
                rts                             ;and results in blanking

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³DRAWSCREEN                                                                   ³
;³                                                                             ³
;³Draws the whole gamescreen.                                                  ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y,temp1-temp6                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

drawscreen:     lda #$00
                sta screen
                jsr hidescreen
                ldx mapy
                lda maptbllo,x
                sta temp3
                lda maptblhi,x
                sta temp4
                lda blocky
                asl
                asl
                ora blockx
                sta temp1
                sta temp2
                lda #$00
                sta swdu_sta+1
                ldx screen
                lda scradrtblhi,x
                sta swdu_sta+2
                lda #SCROLLROWS
                sta temp6
drsc_loop:      jsr swdu_common2
                lda swdu_sta+1
                clc
                adc #40
                sta swdu_sta+1
                bcc drsc_notover1
                inc swdu_sta+2
drsc_notover1:  ldy temp1
                lda cpd_tbl,y
                bpl drsc_notover3
                pha
                lda temp3
                clc
                adc mapsizex
                sta temp3
                pla
                bcc drsc_notover3
                inc temp4
drsc_notover3:  and #$0f
                sta temp1
                sta temp2
                dec temp6                       ;All screen rows done?
                bne drsc_loop
                jsr checkvisibility
                jsr updatecolors
                jmp is_setscrollpos

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³SCROLLLOGIC                                                                  ³
;³                                                                             ³
;³Performs all calculations for scrolling, and makes preparations for          ³
;³SCROLLSCREEN + SCROLLCOLORS. This is a routine that allows freedirectional   ³
;³scrolling.                                                                   ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

scrolllogic:    lda blockx
                sta ub_oldblockx+1
                lda blocky
                sta ub_oldblocky+1
                lda mapx
                sta ub_oldmapx+1
                lda mapy
                sta ub_oldmapy+1
                lda scrollsx                    ;Check for going outside the
                beq sl_noxlimit                 ;map in X-direction
                bmi sl_xlimitleft
sl_xlimitright: lda mapx
                clc
                adc #$0a
                cmp mapsizex
                bcc sl_noxlimit
                lda blockx
                beq sl_noxlimit
                lda #$00
                beq sl_xlimit
sl_xlimitleft:  lda mapx
                ora blockx
                bne sl_noxlimit
sl_xlimit:      sta scrollsx
sl_noxlimit:    lda scrollsy                    ;Check for going outside the
                beq sl_noylimit                 ;map in Y-direction
                bmi sl_ylimitup
sl_ylimitdown:  lda mapy
                clc
                adc #$06
                cmp mapsizey
                bcc sl_noylimit
                lda blocky
                cmp #$02
                bcc sl_noylimit
                lda #$00
                beq sl_ylimit
sl_ylimitup:    lda mapy
                ora blocky
                bne sl_noylimit
sl_ylimit:      sta scrollsy
sl_noylimit:    ldx #SD_NOSHIFT                 ;Determine direction of shift
                ldy blocky
                lda scrolly                     ;and precalculate finescroll
                sec                             ;values for next frame
                sbc scrollsy
                bpl sl_gnsyok3
                iny
                cpy #$04
                bcc sl_gnsynotover1
                ldy #$00
                inc mapy
                pha
                lda #$ff                        ;Force visibility update
                sta oldactxh
                sta oldactyh
                pla
sl_gnsynotover1:ldx #SD_DOWN                    ;First vertical
                bne sl_gnsyok4
sl_gnsyok3:     cmp #$40
                bcc sl_gnsyok4
                dey
                bpl sl_gnsynotover2
                ldy #$03
                dec mapy
                pha
                lda #$ff                        ;Force visibility update
                sta oldactxh
                sta oldactyh
                pla
sl_gnsynotover2:ldx #SD_UP
sl_gnsyok4:     and #$3f
                sta scrolly
                sty blocky
                ldy blockx
                lda scrollx                     ;Then horizontal
                sec
                sbc scrollsx
                bpl sl_gnsxok3
                iny
                cpy #$04
                bcc sl_gnsxnotover1
                ldy #$00
                inc mapx
                pha
                lda #$ff                        ;Force visibility update
                sta oldactxh
                sta oldactyh
                pla
sl_gnsxnotover1:inx
                bpl sl_gnsxok4
sl_gnsxok3:     cmp #$40
                bcc sl_gnsxok4
                dey
                bpl sl_gnsxnotover2
                ldy #$03
                dec mapx
                pha
                lda #$ff                        ;Force visibility update
                sta oldactxh
                sta oldactyh
                pla
sl_gnsxnotover2:dex
sl_gnsxok4:     and #$3f
                sta scrollx
                sty blockx
                stx shiftdir
sl_calcsprsub:  lda scrollx             ;Calculate sprite-subtractvalue
                and #$38
                eor #$3f
                sta temp1
                lda blockx
                ror
                ror
                ror
                and #$c0
                ora temp1
                sec
                sbc #248
                sta sprsubxl
                lda mapx
                sbc #0
                sta sprsubxh
                lda scrolly
                and #$38
                eor #$3f
                sta temp1
                lda blocky
                ror
                ror
                ror
                and #$c0
                ora temp1
                sec
                sbc #176
                sta sprsubyl
                lda mapy
                sbc #1
                sta sprsubyh
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³SCROLLSCREEN                                                                 ³
;³                                                                             ³
;³Performs the "hard work" of scrolling part 1: screen shifting.               ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y,temp1-temp5                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

scrollscreen:   lda actxh
                cmp oldactxh
                bne ss_vischeck
                lda actyh
                cmp oldactyh
                beq ss_novischeck
ss_vischeck:    jsr checkvisibility
ss_novischeck:  ldx shiftdir
                cpx #SD_NOSHIFT
                bne ss_continue
ss_donothing:   rts
ss_continue:    ldx shiftdir
                lda screen
                bne sw_usescreen2
sw_usescreen1:  ldy shiftsrctbl,x               ;Get the required shifting
                lda shiftworktbl,x              ;source pointer
                sta sw_shiftcmp1+1
                lda shiftdesttbl,x
                tax
                jmp sw_shiftloop1

sw_usescreen2:  ldy shiftsrctbl,x               ;Get the required shifting
                lda shiftworktbl,x              ;source pointer
                sta sw_shiftcmp2+1
                lda shiftdesttbl,x
                tax
                jmp sw_shiftloop2

sw_shiftdone:   ldx shiftdir
                lda colorjmptbllo,x             ;Perform the jump as required
                sta sw_colorjump+1              ;by shifting direction
                lda colorjmptblhi,x
                sta sw_colorjump+2
sw_colorjump:   jmp $1000

sw_shiftloop1:
N               SET 0
                REPEAT SCROLLROWS
                lda screen1-40+N*40,y
                sta screen2+N*40,x
N               SET N+1
                REPEND
                iny
                inx
sw_shiftcmp1:   cpx #$00
                bcs sw_shiftdone1
                jmp sw_shiftloop1
sw_shiftdone1:  jmp sw_shiftdone

sw_shiftloop2:
N               SET 0
                REPEAT SCROLLROWS
                lda screen2-40+N*40,y
                sta screen1+N*40,x
N               SET N+1
                REPEND
                iny
                inx
sw_shiftcmp2:   cpx #$00
                bcs sw_shiftdone2
                jmp sw_shiftloop2
sw_shiftdone2:  jmp sw_shiftdone

scrollcolors:
sc_wait1:       lda rastercount
                beq sc_wait1
                inc frameupdateflag
sc_wait2:       lda frameupdateflag
                bne sc_wait2
                lda #$00
                sta rastercount
                ldx shiftdir
                cpx #SD_NOSHIFT
                beq sc_noscreenswap
                lda screen
                eor #$01
                sta screen
sw_updatecolors:jmp updatecolors

sc_noscreenswap:lda colorupdateflag
                bne sw_updatecolors
sw_donothing:   rts

sw_upleft:      jsr sw_drawup
                jmp sw_drawleft

sw_up:          jmp sw_drawup

sw_upright:     jsr sw_drawup
                jmp sw_drawright

sw_left:        jmp sw_drawleft

sw_right:       jmp sw_drawright

sw_downleft:    jsr sw_drawleft
                jmp sw_drawdown

sw_down:        jmp sw_drawdown

sw_downright:   jsr sw_drawright
                jmp sw_drawdown

sw_drawright:   ldx mapy                        ;Draw new blocks to the right
                lda maptbllo,x
                sta temp3
                lda maptblhi,x
                sta temp4
                lda mapx
                clc
                adc #$09
                tax
                lda blockx
                clc
                adc #$02
                cmp #$04
                bcc swdr_not1
                and #$03
                inx
swdr_not1:      sta temp1
                txa
                clc
                adc temp3
                sta temp3
                bcc swdr_not2
                inc temp4
swdr_not2:      lda #38
                bne swdl_common

sw_drawleft:    ldx mapy                     ;Draw new blocks to the left
                lda maptbllo,x
                sta temp3
                lda maptblhi,x
                sta temp4
                lda mapx
                clc
                adc temp3
                sta temp3
                bcc sw_dlcalcdone
                inc temp4
sw_dlcalcdone:  lda blockx
                sta temp1
                lda #$00
swdl_common:    sta swdl_sta+1
                lda screen
                eor #$01
                tax
                lda scradrtblhi,x
                sta swdl_sta+2
                lda #SCROLLROWS-1
                sta temp5
                lda blocky
                asl
                asl
                ora temp1
                ldx #$00
swdl_getblock:  sta temp2
                ldy #$00
                lda (temp3),y
                tay
                lda blktbllo,y
                sta swdl_lda+1
                lda blktblhi,y
                sta swdl_lda+2
                ldy temp2
                clc
swdl_lda:       lda $1000,y
swdl_sta:       sta $1000,x
                dec temp5
                bmi swdl_ready
                txa
                adc #40
                tax
                bcc swdl_not2
                inc swdl_sta+2
                clc
swdl_not2:      lda cpd_tbl,y
                tay
                bpl swdl_lda
swdl_block:     lda temp3
                adc mapsizex
                sta temp3
                bcc swdl_not3
                inc temp4
swdl_not3:      lda temp1
                jmp swdl_getblock
swdl_ready:     rts

sw_drawdown:    lda screen                      ;Draw new blocks to the
                eor #$01
                tax
                lda #<(screen1+SCROLLROWS*40-40);bottom of the screen
                sta swdu_sta+1
                lda scradrtblhi,x
                ora #>(SCROLLROWS*40-40)
                sta swdu_sta+2
                lda mapy
                clc
                adc #$05
                tax
                lda blocky
                clc
                adc #$01
                cmp #$04
                bcc swdu_common
                and #$03
                inx
                jmp swdu_common

sw_drawup:      lda screen
                eor #$01
                tax
                lda #$00
                sta swdu_sta+1
                lda scradrtblhi,x
                sta swdu_sta+2
                ldx mapy                        ;Draw new blocks to the
                lda blocky                      ;top of the screen
swdu_common:    ldy maptbllo,x
                sty temp3
                ldy maptblhi,x
                sty temp4
                asl
                asl
                ora blockx
                sta temp2
swdu_common2:   ldx #$00
                ldy mapx
swdu_getblock:  lda (temp3),y
                iny
                sty temp5
                tay
                lda blktbllo,y
                sta swdu_lda+1
                lda blktblhi,y
                sta swdu_lda+2
                ldy temp2
swdu_lda:       lda $1000,y
swdu_sta:       sta screen1,x
                inx
                cpx #39
                bcs swdu_ready
                lda cpr_tbl,y
                tay
                bpl swdu_lda
                and #$0f
                sta temp2
                ldy temp5
                jmp swdu_getblock
swdu_ready:     rts

cvadd4ytbl:
N               set 4
                repeat 40
                dc.b N
N               set N+1
                repend
cvrowtbl:       dc.b 0,11,22,33,44,55,66

checkvisibility:
                inc colorupdateflag
                lda actxh
                sta oldactxh
                lda actyh
                sta oldactyh
                lda mapx
                sta vmapx
                lda mapy
                sta vmapy
                lda actxh
                sec
                sbc mapx
                sta temp1                       ;Original X coord
                sta temp7
                lda actyh
                sec
                sbc mapy
                sta temp2                       ;Original Y coord
                sta temp8
                lda #$ff
                sta temp3                       ;X limit low
                sta temp4                       ;Y limit low
                lda #$0b
                sta temp5                       ;X limit high
                lda #$07
                sta temp6                       ;Y limit high
                ldx #$0a
                lda #$06
cv_cleartbl:    sta cvfinal,x                   ;Clear the table at first
                sta cvfinal+11,x
                sta cvfinal+22,x
                sta cvfinal+33,x
                sta cvfinal+44,x
                sta cvfinal+55,x
                sta cvfinal+66,x
                dex
                bpl cv_cleartbl
                jsr cv_castrayup                ;Then "cast rays" to all 4
           ;     sta temp4                       ;directions and limit the
                jsr cv_castraydown              ;checking area
           ;     sta temp6
                jsr cv_castrayleft
           ;     sta temp3
                jsr cv_castrayright
           ;     sta temp5
cv_upperleft:   jsr cv_getblock
                and #BV_LEFT
                bne cv_upperleftdone
cv_upperleftcont:
                dec temp8
                lda temp8
                cmp temp4
                beq cv_upperleftdone
                jsr cv_getblock
                and #BV_LEFT|BV_DOWN
                bne cv_upperleftdone
                dec temp7
                lda temp7
                cmp temp3
                beq cv_upperleftdone
                jsr cv_getblock
                sta temp10
              ;  and #BV_DOWN                    ;Check the block
              ;  bne cv_upperleftdone
                jsr cv_castrayup                ;If not an obstacle, continue
                jsr cv_castrayleft              ;casting rays
                lda temp10
                and #BV_LEFT
                beq cv_upperleftcont
cv_upperleftdone:
                lda temp1                       ;Restore original pos
                sta temp7
                lda temp2
                sta temp8
cv_upperright:
cv_upperrightcont:
                inc temp7
                lda temp7
                cmp temp5
                beq cv_upperrightdone
                jsr cv_getblock
                and #BV_LEFT
                bne cv_upperrightdone
                dec temp8
                lda temp8
                cmp temp4
                beq cv_upperrightdone
                jsr cv_getblock
                ;sta temp10
                and #BV_DOWN|BV_LEFT                      ;Check the block
                bne cv_upperrightdone
                jsr cv_castrayup                 ;If not an obstacle, continue
                jsr cv_castrayright              ;casting rays
                ;lda temp10
                ;and #BV_UP|BV_RIGHT
                jmp cv_upperrightcont
cv_upperrightdone:
                lda temp1                       ;Restore original pos
                sta temp7
                lda temp2
                sta temp8
cv_lowerright:  jsr cv_getblock
                and #BV_DOWN
                bne cv_lowerrightdone
cv_lowerrightcont:
                inc temp7
                lda temp7
                cmp temp5
                beq cv_lowerrightdone
                jsr cv_getblock
                and #BV_LEFT
                bne cv_lowerrightdone
                inc temp8
                lda temp8
                cmp temp6
                beq cv_lowerrightdone
                jsr cv_getblock
                sta temp10
                and #BV_LEFT                   ;Check the block
                bne cv_lowerrightdone
                jsr cv_castraydown             ;If not an obstacle, continue
                jsr cv_castrayright            ;casting rays
                lda temp10
                and #BV_DOWN
                beq cv_lowerrightcont
cv_lowerrightdone:
                lda temp1                       ;Restore original pos
                sta temp7
                lda temp2
                sta temp8
cv_lowerleft:   jsr cv_getblock
                and #BV_DOWN|BV_LEFT                    ;Check the block
                bne cv_lowerleftdone
cv_lowerleftcont:
                inc temp8
                lda temp8
                cmp temp6
                beq cv_lowerleftdone
                jsr cv_getblock
                and #BV_LEFT
                bne cv_lowerleftdone
                dec temp7
                lda temp7
                cmp temp3
                beq cv_lowerleftdone
                jsr cv_getblock
                sta temp10
                ;and #BV_UP|BV_RIGHT            ;Check the block
                ;bne cv_lowerleftdone
                jsr cv_castraydown             ;If not an obstacle, continue
                jsr cv_castrayleft             ;casting rays
                lda temp10
                and #BV_DOWN|BV_LEFT
                beq cv_lowerleftcont
cv_lowerleftdone:
                rts                            ;Ready!


cv_castrayup:   ldy temp8
                sty temp9
                tya
                clc
                adc mapy
                tay
                lda temp7
                adc mapx
                adc maptbllo,y
                sta alo
                lda maptblhi,y
                adc #$00
                sta ahi
                ldy #$00
                lda (alo),y
                tay
                jmp cv_cruskipfirst
cv_cruloop:     lda temp9
                cmp temp4
                beq cv_crudone2
                ldy #$00
                lda (alo),y
                tay
                lda blkcoltbl,y
                and #BV_DOWN
                bne cv_crudone
cv_cruskipfirst:ldx temp9
                lda cvrowtbl,x
                dex
                stx temp9
                clc
                adc temp7
                tax
                lda blkcoltbl,y
                sta cvfinal,x
                ;and #BV_UP
                ;bne cv_crudone
                lda alo
                sec
                sbc mapsizex
                sta alo
                bcs cv_cruloop
                dec ahi
                bcc cv_cruloop
cv_crudone:     lda temp9
cv_crudone2:    rts

cv_castraydown: ldy temp8
                sty temp9
                tya
                clc
                adc mapy
                tay
                lda temp7
                adc mapx
                adc maptbllo,y
                sta alo
                lda maptblhi,y
                adc #$00
                sta ahi
                ldy #$00
                lda (alo),y
                tay
                jmp cv_crdskipfirst
cv_crdloop:     lda temp9
                cmp temp6
                beq cv_crddone2
                ldy #$00
                lda (alo),y
                tay
                ;lda blkcoltbl,y
                ;and #BV_UP
                ;bne cv_crddone
cv_crdskipfirst:ldx temp9
                lda cvrowtbl,x
                inx
                stx temp9
                clc
                adc temp7
                tax
                lda blkcoltbl,y
                sta cvfinal,x
                and #BV_DOWN
                bne cv_crddone
                lda alo
                adc mapsizex
                sta alo
                bcc cv_crdloop
                inc ahi
                bcs cv_crdloop
cv_crddone:     lda temp9
cv_crddone2:    rts

cv_castrayright:lda temp8
                clc
                adc mapy
                tay
                lda temp7
                sta temp9
                adc mapx
                adc maptbllo,y
                sta alo
                lda maptblhi,y
                adc #$00
                sta ahi
                ldy #$00
                lda (alo),y
                tay
                jmp cv_crrskipfirst
cv_crrloop:     lda temp9
                cmp temp5
                beq cv_crrdone2
                ldy #$00
                lda (alo),y
                tay
                lda blkcoltbl,y
                and #BV_LEFT
                bne cv_crrdone
cv_crrskipfirst:ldx temp8
                lda cvrowtbl,x
                clc
                adc temp9
                tax
                inc temp9
                lda blkcoltbl,y
                sta cvfinal,x
                ;and #BV_RIGHT
                ;bne cv_crrdone
                inc alo
                bne cv_crrloop
                inc ahi
                jmp cv_crrloop
cv_crrdone:     lda temp9
cv_crrdone2:    rts

cv_castrayleft: lda temp8
                clc
                adc mapy
                tay
                lda temp7
                sta temp9
                clc
                adc mapx
                adc maptbllo,y
                sta alo
                lda maptblhi,y
                adc #$00
                sta ahi
                ldy #$00
                lda (alo),y
                tay
                jmp cv_crlskipfirst
cv_crlloop:     lda temp9
                cmp temp3
                beq cv_crldone2
                ldy #$00
                lda (alo),y
                tay
                ;lda blkcoltbl,y
                ;and #BV_RIGHT
                ;bne cv_crldone
cv_crlskipfirst:ldx temp8
                lda cvrowtbl,x
                clc
                adc temp9
                tax
                dec temp9
                lda blkcoltbl,y
                sta cvfinal,x
                and #BV_LEFT
                bne cv_crldone
                lda alo
                bne cv_crlnodechigh
                dec ahi
cv_crlnodechigh:dec alo
                jmp cv_crlloop
cv_crldone:     lda temp9
cv_crldone2:    rts

cv_getblock:    lda temp8
                clc
                adc mapy
                tay
                lda maptbllo,y
                sta alo
                lda maptblhi,y
                sta ahi
                lda temp7
                adc mapx
                tay
                lda (alo),y
                tay
                lda blkcoltbl,y
                rts

updatecolors:   ldx #$00
                stx colorupdateflag
N               set 0
                lda #$04
                sec
                sbc blockx
                sta temp4
                sbc #$01
                sta temp1
                lda #$04
                sec
                sbc blocky
                sta temp2
                repeat SCROLLROWS
                subroutine UPDCOL
                ldy temp1
                lda cvfinal,x
                inx
                sta colors+N*40,y
                dey
                bmi .1
                sta colors+N*40,y
                dey
                bmi .1
                sta colors+N*40,y
                dey
                bmi .1
                sta colors+N*40,y
.1:             ldy temp4
.2:             lda cvfinal,x
                inx
                sta colors+N*40,y
                sta colors+1+N*40,y
                sta colors+2+N*40,y
                sta colors+3+N*40,y
                lda cvadd4ytbl,y
                tay
                cpy #37
                bcc .2
                lda cvfinal,x
                inx
                cpy #39
                bcs .3
                sta colors+N*40,y
                iny
                cpy #39
                bcs .3
                sta colors+N*40,y
.3:             dec temp2
                beq .4
                txa
                sec
                sbc #$0b
                tax
                bpl .5
.4:             lda #$04
                sta temp2
.5:
                subroutine UPDCOLDONE
N               set N+1
                repend
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³GETCHARPOSINFO                                                               ³
;³                                                                             ³
;³Gets charinfo from actor's position                                          ³
;³                                                                             ³
;³Parameters: X:Actor number                                                   ³
;³Returns: A:charinfo                                                          ³
;³Modifies: Y,mapptr                                                           ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

getcharposinfo: ldy actyh,x
                cpy mapsizey                    ;Check that we are within the
                bcs gcpi_out                    ;map
                lda maptbllo,y
                sta alo
                lda maptblhi,y
                sta ahi
                ldy actxh,x
                cpy mapsizex                    ;Check that we are within the
                bcs gcpi_out                    ;map
                lda (alo),y                     ;Take block from map
                tay
                lda blktbllo,y
                sta alo
                lda blktblhi,y
                sta ahi
                lda actyl,x
                lsr
                lsr
                lsr
                lsr
                and #$0c
                sta gcpi_or+1
                lda actxl,x
                rol
                rol
                rol
                and #$03
gcpi_or:        ora #$00
                tay
                lda (alo),y
                tay
                lda charinfotbl,y                  ;Take blockinfo
                rts
gcpi_out:       lda #CI_OBSTACLE                ;Checking from outside the
                rts                             ;map results in an obstacle

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³CLOSETFLASH                                                                  ³
;³                                                                             ³
;³Animation of the network closets                                             ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

closetflash:    lda #$03
                sta temp3
cf_loop:        jsr random
                and #$1f
                tay
                asl
                tax
                lda cfadr,x
                sta temp1
                lda cfadr+1,x
                sta temp2
                lda cfeor,y
                ldy #$00
                eor (temp1),y
                sta (temp1),y
                dec temp3
                bne cf_loop
                rts

