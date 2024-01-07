MAXACT          = 30

LOWOBSTACLEHEIGHT = 50

ACT_NONE        = 0
ACT_BULLET      = 1
ACT_SMOKE       = 2
ACT_MELEEHIT    = 3
ACT_FLAME       = 4
ACT_GRENADE     = 5
ACT_ARROW       = 6
ACT_EXPLOSION   = 7
ACT_ITEM        = 8
ACT_BOFH        = 9
ACT_WORKSTATION = 10
ACT_PRINTER     = 11
ACT_BIGPRINTER  = 12
ACT_LAPTOP      = 13
ACT_PCSERVER    = 14
ACT_SUNSERVER   = 15
ACT_CDTOWER     = 16
ACT_FISTMAN     = 17
ACT_PISTOLMAN   = 18
ACT_SHOTGUNMAN  = 19
ACT_UZIMAN      = 20
ACT_SADIST      = 21
ACT_LEADER      = 22
ACT_TECHNICIAN  = 23
ACT_CORPSE1     = 24
ACT_CORPSE2     = 25
ACT_SHRAPNEL    = 26
ACT_BLOOD       = 27



ACTI_BOFH       = 0
ACTI_FIRSTCOMMON = 1
ACTI_LASTCOMMON = 19

ACTI_FIRSTPLRBULLET = 20
ACTI_LASTPLRBULLET = 24
ACTI_FIRSTENEMYBULLET = 25
ACTI_LASTENEMYBULLET = 29

ACTS_RADIUS     = 0
ACTS_HOTSPOTIDX = 1
ACTS_COLOR      = 2
ACTS_PRIORITY   = 3
ACTS_MOVEROUT   = 4
ACTS_FRAMETBL   = 6

CI_OBSTACLE     = 1
CI_HIGHOBSTACLE = 2
CI_DOOR         = 4
CI_STAIRSDOWN   = 16
CI_STAIRSUP     = 32
CI_STAIRSDIR    = 64+128

STAIRDIRUP      = 0
STAIRDIRRIGHT   = 64
STAIRDIRDOWN    = 128
STAIRDIRLEFT    = 192

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³INITACTORS                                                                   ³
;³                                                                             ³
;³Sets all actors to inactive state.                                           ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

initactors:     ldx #MAXACT-1
                lda #ACT_NONE
ia_loop:        sta actt,x
                sta actorglo,x
                sta actorghi,x
                sta acthplo,x
                sta acthphi,x
                dex
                bpl ia_loop
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³GETFREEACTOR                                                                 ³
;³                                                                             ³
;³Searches for a free actor in the actor table.                                ³
;³                                                                             ³
;³Parameters: A:Last actor to be checked                                       ³
;³            Y:First actor to be checked                                      ³
;³Returns: C=1 Found (Y:Index) C=0 Not found                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

getfreeactor:   sta gfa_cmp+1
gfa_loop:       lda actt,y
                beq gfa_found
gfa_cmp:        cpy #$00
                iny
                bcc gfa_loop
                clc
                rts
gfa_found:      lda #$00
                sta actc,y
                sta actf,y
                sta actfd,y
                sta actsx,y
                sta actsy,y
                sta acttime,y
                sta actmode,y
                sta actctrl,y
                sta actattk,y
                sta actattkd,y
                sta acth,y
                sta actsh,y
                sta actorglo,y
                sta actorghi,y
                sta acthplo,y
                sta acthphi,y
                sec
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³COUNTFREEACTORS                                                              ³
;³                                                                             ³
;³Counts number of free actors in the actor table                              ³
;³                                                                             ³
;³Parameters: A:Last actor to be checked                                       ³
;³            Y:First actor to be checked                                      ³
;³Returns: A:Number of actors                                                  ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

countfreeactors:sta cfa_cmp+1
                lda #$00
                sta cfa_count+1
cfa_loop:       lda actt,y
                bne cfa_cmp
                inc cfa_count+1
cfa_cmp:        cpy #$00
                iny
                bcc cfa_loop
cfa_count:      lda #$00
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³SPAWNACTOR                                                                   ³
;³                                                                             ³
;³Creates an actor with the same location & direction as the host actor.       ³
;³                                                                             ³
;³Parameters: A:Actor type to be spawned                                       ³
;³            X:Host actor                                                     ³
;³            Y:Free actor number                                              ³
;³Returns: -                                                                   ³
;³Modifies: A                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

spawnactor:     sta actt,y
                lda actd,x
                sta actd,y
                lda actxl,x
                sta actxl,y
                lda actxh,x
                sta actxh,y
                lda actyl,x
                sta actyl,y
                lda actyh,x
                sta actyh,y
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³LIMIT8DIRS                                                                   ³
;³                                                                             ³
;³Limits direction to 8 main directions.                                       ³
;³                                                                             ³
;³Parameters: A:Direction                                                      ³
;³Returns: A:Direction                                                         ³
;³Modifies: A                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
limit8dirs:     clc
                adc #$10
                and #$e0
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MOVEACTORS                                                                   ³
;³                                                                             ³
;³Calls move routines of all actors. Actor number is passed in X register      ³
;³(must remain unchanged) and the actor structure address in temp1 & temp2.    ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y,lots of other regs :-)                                       ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

moveactors:     if SHOWACTORS>0
                lda #$00
                sta ma_color+1
                endif
                lda #$00
                sta hitsoundplayed
                jsr random
                and #$01
                tay
                lda shrapnelflashtbl,y
                sta act_shrapnel+ACTS_COLOR
                inc itemflash
                lda itemflash
                lsr
                lsr
                and #$03
                tay
                lda itemflashtbl,y
                sta act_item+ACTS_COLOR
                ldx #MAXACT-1
ma_loop:        lda actt,x
                beq ma_skip
                asl
                tay
                lda acttbl-2,y          ;Actor datastructure
                sta temp1
                lda acttbl-1,y
                sta temp2
                ldy #ACTS_MOVEROUT
                lda (temp1),y
                sta ma_jump+1
                iny
                lda (temp1),y
                sta ma_jump+2
ma_jump:        jsr $1000
                if SHOWACTORS>0
                inc ma_color+1
                endif
ma_skip:        dex
                bpl ma_loop
                if SHOWACTORS>0
ma_color:       lda #$00
                sta $d020
                endif
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³DRAWACTORS                                                                   ³
;³                                                                             ³
;³Fills the sprite table to display the actors onscreen.                       ³
;³NOTE: all out-of-screen sprites will be detected at this phase and not       ³
;³passed to SORTSPRITES                                                        ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y,temp1-temp8                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

drawactors:     lda irqsprstart         ;Get first usable spritenumber
                eor #MAXSPR+1
                sta sortsprstart
                sta sortsprend          ;Assume: 0 sprites
                clc
                adc #MAXSPR
                sta da_checksprlimit+1
                ldx atcloset
                bmi da_nocloset
                lda bombstat,x
                beq da_nocloset
                jsr drawbomb
da_nocloset:    ldx #$00                ;Start from actor 0
da_loop:        lda actf,x              ;Negative frame = hide sprite
                bmi da_skip
                lda actt,x
                bne da_noskip
da_skip:        inx
                cpx #MAXACT
                bcc da_loop
                rts
da_noskip:      asl
                tay
                lda acttbl-2,y          ;Actor datastructure
                sta temp1
                lda acttbl-1,y
                sta temp2

                lda actyh,x
                sec
                sbc vmapy
                cmp #7
                bcs da_skip
                tay
                lda actxh,x             ;Check visibility against the
                sec                     ;visibility grid
                sbc vmapx
                cmp #11
                bcs da_skip
                adc cvrowtbl,y
                tay
                lda cvfinal,y
                cmp #$08
                bcs da_visible
                lda actc,x              ;Reset flashing also when invisible
                cmp #$01
                bne da_skip
                dec actc,x
                jmp da_skip

da_visible:     lda actd,x              ;Convert the 256 directions into 8
                adc #16
                lsr
                lsr
                lsr
                lsr
                lsr
                clc
                adc #ACTS_FRAMETBL
                tay
                lda (temp1),y           ;Baseframe
                adc actf,x
                sta temp4
                ldy #ACTS_PRIORITY
                lda (temp1),y           ;Sprite priority
                sta da_storep+1
                dey
                lda actc,x              ;Sprite color
                beq da_default
                cmp #$01
                bne da_nodefault
                dec actc,x
                jmp da_nodefault
da_default:     lda (temp1),y
da_nodefault:   sta da_storec+1
                dey
                lda (temp1),y           ;Frametable index
                sta temp3
                lda actxl,x             ;Take the X-coord and convert from
                sec                     ;world to screen coords
                sbc sprsubxl
                sta temp5
                lda actxh,x
                sbc sprsubxh
                lsr
                ror temp5
                lsr
                ror temp5
                lsr
                ror temp5
                sta temp6
                lda actyl,x             ;Take the Y-coord and convert from
                sec                     ;world to screen coords
                sbc sprsubyl
                sta temp7
                lda actyh,x
                sbc sprsubyh
                lsr
                ror temp7
                lsr
                ror temp7
                lsr
                ror temp7
                sta temp8

                stx temp2               ;Store actorcounter
                cpx #$00
                bne da_notplayer
                lda acthplo,x           ;Dead BOFH doesn't need a sight :-)
                ora acthphi,x
                beq da_notplayer
                jsr drawsight

da_notplayer:   ldx sortsprend
da_sprloop:     ldy temp3
                lda hotspottbl,y
                clc
                bmi da_xhsneg
da_xhspos:      adc temp5
                sta sprxl,x
                lda temp6
                adc #$00
                jmp da_xhscommon
da_xhsneg:      adc temp5
                sta sprxl,x
                lda temp6
                adc #$ff
da_xhscommon:   sta sprxh,x
                cmp #$01
                bcc da_xok
                bne da_sprskip          ;X outside visible range
                lda sprxl,x
                cmp #79
                bcs da_sprskip
da_xok:         lda hotspottbl+1,y
                clc
                bmi da_yhsneg
da_yhspos:      adc temp7
                sta spry,x
                lda temp8
                adc #$00
                jmp da_yhscommon
da_yhsneg:      adc temp7
                sta spry,x
                lda temp8
                adc #$ff
da_yhscommon:   bne da_sprskip          ;Y outside visible range
                lda spry,x
                cmp #MINSPRY
                bcc da_sprskip
                cmp #MAXSPRY
                bcs da_sprskip
                lda temp4
                sta sprf,x
da_storep:      lda #$00
                sta sprpri,x
da_storec:      lda #$00
                sta sprc,x
                inx
da_checksprlimit:cpx #$00                ;All sprites used up?
                bcs da_outofspr
da_sprready:    stx sortsprend
da_sprskip:
                ldx temp2
                jmp da_skip
da_outofspr:    rts

drawsight:      lda atcloset
                bpl da_outofspr
                ldy actd,x
                lda sintbl,y
                ldy #1
                jsr asr_rounddown
                sec
                sbc #$08
                jsr signexpand
                ldx sortsprend
                clc
                adc temp5
                sta sprxl,x
                tya
                adc temp6
                sta sprxh,x
                cmp #$01
                bcc ds_xok
                bne ds_skip
                lda sprxl,x
                cmp #79
                bcs ds_skip
ds_xok:         ldx temp2
                ldy actd,x
                lda costbl,y
                eor #$ff
                adc #$01                        ;Carry is always 0 at this
                ldy #1                          ;point
                jsr asr_rounddown
                sec
                sbc #$08
                jsr signexpand
                ldx sortsprend
                clc
                adc temp7
                sta spry,x
                tya
                adc temp8
                bne ds_skip
                lda spry,x
                cmp #MINSPRY
                bcc ds_skip
                cmp #MAXSPRY
                bcs ds_skip
                lda #FR+36
                sta sprf,x
                lda #PRI_HIGH                   ;Sight will be shown over
                sta sprpri,x                    ;anything else
                lda #$01
                sta sprc,x
                inc sortsprend
ds_skip:        rts


drawbomb:       ldx sortsprend
                ldy #$00
                lda #FR+112
db_loop1:       sta sprf,x
                clc
                adc #$01
                pha
                lda #$01
                sta sprxh,x
                lda bombcoltbl,y
                sta sprc,x
                lda #PRI_HIGH
                sta sprpri,x
                pla
                inx
                iny
                cpy #$09
                bcc db_loop1
                ldx sortsprend
                lda #1
                sta sprxl,x
                sta sprxl+3,x
                sta sprxl+6,x
                lda #25
                sta sprxl+1,x
                sta sprxl+4,x
                sta sprxl+7,x
                lda #49
                sta sprxl+2,x
                sta sprxl+5,x
                sta sprxl+8,x
                lda #159
                sta spry,x
                sta spry+1,x
                sta spry+2,x
                lda #180
                sta spry+3,x
                sta spry+4,x
                sta spry+5,x
                lda #201
                sta spry+6,x
                sta spry+7,x
                sta spry+8,x
                ldx atcloset
                lda bombstat,x
                cmp #BOMB_ACTIVE
                bne db_nowireflash
                ldy wirenumber
                lda sortsprend
                clc
                adc wirenumberxlat,y
                tax
                lda itemflash
                lsr
                lsr
                and #$03
                tay
                lda bombflashtbl,y
                sta sprc,x
                cpx sortsprend
                bne db_notfirstwire
                sta sprc+3,x
db_notfirstwire:lda timefr                      ;Flashing timer
                cmp #$02
                bcs db_nowireflash
                lda #$04
                jsr modifybombframe
db_nowireflash: lda atcloset
                asl
                adc atcloset
                tay
                lda #$03
                sta temp1
db_wires:       lda wirestat,y                  ;Display cut wires
                beq db_nowire
                ldx wirecolor,y
                dex
                lda wirenumberxlat,x
                jsr modifybombframe
db_nowire:      iny
                dec temp1
                bne db_wires
                lda sortsprend
                clc
                adc #$09
                sta sortsprend
                rts

modifybombframe:clc
                adc sortsprend
                tax
                lda sprf,x
                clc
                adc #$09
                sta sprf,x
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³SEEPLAYER                                                                    ³
;³                                                                             ³
;³Checks if actor X can see the BOFH                                           ³
;³                                                                             ³
;³Parameters: X:Actor number                                                   ³
;³Returns: C=0 no C=1 yes                                                      ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

seeplayer:      lda actyh,x
                sec
                sbc vmapy
                cmp #7
                bcs sp_no
                tay
                lda actxh,x             ;Check visibility against the
                sec                     ;visibility grid
                sbc vmapx
                cmp #11
                bcs sp_no
                adc cvrowtbl,y
                tay
                lda cvfinal,y
                cmp #$08
                rts
sp_no:          clc
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³INVIEW                                                                       ³
;³                                                                             ³
;³Checks if the BOFH is in actor X's field of vision (90 degrees)              ³
;³                                                                             ³
;³Parameters: X:Actor number                                                   ³
;³Returns: C=0 no C=1 yes                                                      ³
;³Modifies: A,temp3-temp8                                                      ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

inview:         jsr seeplayer
                bcc iv_not
                ldy #ACTI_BOFH
                jsr findangle
                sec
                sbc actd,x
                bmi iv_neg
                cmp #$20
                bcs iv_not
                sec
                rts
iv_neg:         cmp #$e0
                rts
iv_not:         clc
                rts


;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³FINDDISTANCE                                                                 ³
;³                                                                             ³
;³Find distance of actor X relative to actor Y                                 ³
;³                                                                             ³
;³Parameters: X,Y:Actor numbers (both actors must exist)                       ³
;³Returns: A:Distance (in blocks)                                              ³
;³Modifies: A,temp3-temp6                                                      ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

finddistance:   jsr finddistcommon
                lda temp4
                cmp temp6
                bcs fd_ok
                lda temp6
fd_ok:          rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³FINDANGLE                                                                    ³
;³                                                                             ³
;³Find angle of actor X relative to actor Y                                    ³
;³                                                                             ³
;³Parameters: X,Y:Actor numbers (both actors must exist)                       ³
;³Returns: A:Angle (0-255)                                                     ³
;³Modifies: A,temp3-temp8                                                      ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

finddistcommon: sty temp8
                lda #$00
                sta temp7                       ;Quadrant
                lda actxl,x
                sec
                sbc actxl,y
                sta temp3
                lda actxh,x
                sbc actxh,y
                sta temp4
                bpl fa_noneg1
                lda #$02
                sta temp7
                lda temp3
                clc
                adc #$01
                eor #$ff
                sta temp3
                lda temp4
                eor #$ff
                adc #$00
                sta temp4
fa_noneg1:      lda actyl,x
                sec
                sbc actyl,y
                sta temp5
                lda actyh,x
                sbc actyh,y
                sta temp6
                bpl fa_noneg2
                inc temp7
                lda temp5
                clc
                adc #$01
                eor #$ff
                sta temp5
                lda temp6
                eor #$ff
                adc #$00
                sta temp6
fa_noneg2:      rts

findangle:      jsr finddistcommon
fa_divide:      lsr temp4               ;Keep dividing with 2 until coords
                ror temp3               ;are below 256
                lsr temp6
                ror temp5
                lda temp4
                ora temp6
                bne fa_divide
                lda temp5
                and #$f0
                sta fa_ora+1
                lda temp3
                lsr
                lsr
                lsr
                lsr
fa_ora:         ora #$00
                tay
                lda temp7
                beq fa_quadrant0       ; 0  2
                cmp #$03               ;
                beq fa_quadrant3       ; 1  3
                cmp #$02
                beq fa_quadrant2
fa_quadrant1:   lda #$80
                ora atantbl,y
                ldy temp8
                rts
fa_quadrant2:   lda atantbl,y
                ldy temp8
                rts
fa_quadrant0:   lda #$00
                sec
                sbc atantbl,y
                ldy temp8
                rts
fa_quadrant3:   lda #$80
                sec
                sbc atantbl,y
                ldy temp8
                rts




;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³CHECKCOLLISION                                                               ³
;³                                                                             ³
;³Checks collision of 2 actors.                                                ³
;³                                                                             ³
;³Parameters: X,Y:Actor numbers (both actors must exist)                       ³
;³Returns: C=1 if collision happens                                            ³
;³Modifies: A,temp3-temp5                                                      ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

checkcollision: lda actxl,x
                sec
                sbc actxl,y
                sta temp3
                lda actxh,x
                sbc actxh,y
                beq cc_ok1
                cmp #$ff
                bcc cc_nocoll2
                lda temp3
                beq cc_nocoll
                eor #$ff
                adc #$00
                sta temp3
cc_ok1:         lda actyl,x
                sec
                sbc actyl,y
                sta temp4
                lda actyh,x
                sbc actyh,y
                beq cc_ok2
                cmp #$ff
                bcc cc_nocoll2
                lda temp4
                beq cc_nocoll
                eor #$ff
                adc #$00
                sta temp4
cc_ok2:         lda temp3
                clc
                adc temp4
                bcs cc_nocoll
                sta cc_cmp+1
                lda actt,y
                asl
                sty temp5
                tay
                lda acttbl-2,y          ;Actor datastructure
                sta temp3
                lda acttbl-1,y
                sta temp4
                ldy #ACTS_RADIUS
                lda (temp1),y
                adc (temp3),y
cc_cmp:         cmp #$00
                ldy temp5
                rts
cc_nocoll:      clc
cc_nocoll2:     rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MOVEACTOR                                                                    ³
;³                                                                             ³
;³Moves actor in both X & Y-dirs.                                              ³
;³                                                                             ³
;³Parameters: X:Actor number                                                   ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

moveactor:      lda actsx,x
                jsr signexpand
                clc
                adc actxl,x
                sta actxl,x
                tya
                adc actxh,x
                sta actxh,x
                lda actsy,x
                jsr signexpand
                clc
                adc actyl,x
                sta actyl,x
                tya
                adc actyh,x
                sta actyh,x
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MOVEACTORX                                                                   ³
;³                                                                             ³
;³Moves actor only in X-dir.                                                   ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

moveactorx:     lda actsx,x
moveactorxdir:  jsr signexpand
                clc
                adc actxl,x
                sta actxl,x
                tya
                adc actxh,x
                sta actxh,x
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MOVEACTORY                                                                   ³
;³                                                                             ³
;³Moves actor only in Y-dir.                                                   ³
;³                                                                             ³
;³Parameters: X:Actor number                                                   ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

moveactory:     lda actsy,x
moveactorydir:  jsr signexpand
                clc
                adc actyl,x
                sta actyl,x
                tya
                adc actyh,x
                sta actyh,x
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MOVEPROJECTILE_CHECKOBSTACLES                                                ³
;³                                                                             ³
;³Moves projectile actor, checking background collisions.                      ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

moveprojectile_checkobstacles:
                jsr moveactor
                jsr getcharposinfo
                and #CI_HIGHOBSTACLE
                clc
                beq mpco_ok
                sec
mpco_ok:        rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MOVEACTOR_BOUNCE                                                             ³
;³                                                                             ³
;³Moves bouncing actor (grenades, items).                                      ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

moveactor_bounce:
                jsr getcharposinfo
                and #CI_OBSTACLE
                bne mab_nolowobst
                lda acth,x
                cmp #LOWOBSTACLEHEIGHT
                bcs mab_nolowobst
                jsr storepos
                jsr moveactorx
                jsr getcharposinfo
                and #CI_HIGHOBSTACLE|CI_OBSTACLE
                beq mab_xok
                jsr restorepos
                lda actsx,x
                clc
                eor #$ff
                adc #$01
                sta actsx,x
mab_xok:        jsr storepos
                jsr moveactory
                jsr getcharposinfo
                and #CI_HIGHOBSTACLE|CI_OBSTACLE
                beq mab_yok
                jsr restorepos
                lda actsy,x
                clc
                eor #$ff
                adc #$01
                sta actsy,x
mab_yok:        lda acth,x
                bne mab_inair
                lda #0
                ldy #1
                jmp brakeactor
mab_inair:      rts

mab_nolowobst:  jsr storepos
                jsr moveactorx
                jsr getcharposinfo
                and #CI_HIGHOBSTACLE
                beq mab_xok2
                jsr restorepos
                lda actsx,x
                clc
                eor #$ff
                adc #$01
                sta actsx,x
mab_xok2:       jsr storepos
                jsr moveactory
                jsr getcharposinfo
                and #CI_HIGHOBSTACLE
                beq mab_yok2
                jsr restorepos
                lda actsy,x
                clc
                eor #$ff
                adc #$01
                sta actsy,x
mab_yok2:       jmp mab_yok

moveactor_bounceheight:
                lda acth,x
                clc
                adc actsh,x
                sta acth,x
                bpl mabh_ok
                lda #$00
                sta acth,x
                lda actsh,x
                clc
                adc #$01
                eor #$ff
                lsr
                sta actsh,x
                rts
mabh_ok:        beq mabh_onground
                dec actsh,x
mabh_onground:  rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MOVEACTOR_ROTATE_CHECKOBSTACLES                                              ³
;³                                                                             ³
;³Moves & rotates (human) actor, checking background collisions.               ³
;³                                                                             ³
;³Parameters: X:Actor number                                                   ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

moveactor_rotate_checkobstacles:
                lda actsd,x
                clc
                adc actd,x
                sta actd,x
moveactor_checkobstacles:
                jsr storepos
                jsr moveactor
                jsr getcharposinfo              ;First try movement in both
                and #CI_OBSTACLE|CI_HIGHOBSTACLE|CI_DOOR|CI_STAIRSUP|CI_STAIRSDOWN
                beq maco_moveok
                tay
                and #CI_DOOR
                bne maco_door
                txa
                bne maco_nodoor
                tya
                and #CI_STAIRSUP|CI_STAIRSDOWN
                bne maco_stairs
                beq maco_nodoor
maco_moveok:    rts
maco_nodoor:    jsr restorepos
                jsr moveactorx                  ;Then only in X-dir
                jsr getcharposinfo
                and #CI_OBSTACLE|CI_HIGHOBSTACLE|CI_DOOR|CI_STAIRSUP|CI_STAIRSDOWN
                beq maco_moveok2
                tay
                and #CI_DOOR
                bne maco_door
                txa
                bne maco_nodoor2
                tya
                and #CI_STAIRSUP|CI_STAIRSDOWN
                bne maco_stairs
                beq maco_nodoor2
maco_moveok2:   lda #$00                        ;Zero Y-speed
                sta actsy,x
                rts
maco_nodoor2:   jsr restorepos
                jsr moveactory                  ;Then only in Y-dir
                jsr getcharposinfo
                and #CI_OBSTACLE|CI_HIGHOBSTACLE|CI_DOOR|CI_STAIRSUP|CI_STAIRSDOWN
                beq maco_moveok3
                tay
                and #CI_DOOR
                bne maco_door
                txa
                bne maco_nodoor3
                tya
                and #CI_STAIRSUP|CI_STAIRSDOWN
                bne maco_stairs
                beq maco_nodoor3
maco_moveok3:   lda #$00                        ;Zero X-speed
                sta actsx,x
                rts
maco_nodoor3:   jsr restorepos
                lda #$00
                sta actsx,x
                sta actsy,x
                rts

maco_door:      jsr flipdoor
                jsr getcharposinfo
                and #CI_OBSTACLE|CI_HIGHOBSTACLE
                bne maco_nodoor3
                rts

maco_stairs:    ldx #$00
                jsr getcharposinfo
                sta temp3
                and #CI_STAIRSUP+CI_STAIRSDOWN
                bne cs_ok
                rts
cs_ok:          and #CI_STAIRSUP
                beq cs_notup
                inc floor
                lda floor
                cmp #$06
                bcc cs_notup
                lda #$00
                sta floor
cs_notup:       lda temp3
                and #CI_STAIRSDOWN
                beq cs_notdown
                dec floor
                bpl cs_notdown
                lda #$05
                sta floor
cs_notdown:     lda temp3
                rol
                rol
                rol
                and #$03
                tay
                lda cs_xtbllo,y           ;Move player in direction of stairs
                clc
                adc actxl,x
                sta actxl,x
                lda cs_xtblhi,y
                adc actxh,x
                sta actxh,x
                lda cs_ytbllo,y
                clc
                adc actyl,x
                sta actyl,x
                lda cs_ytblhi,y
                adc actyh,x
                sta actyh,x
                jsr removeallactors
                jsr depackfloor
                jsr addallactors
                lda #5*25
                sta stairdelay
stairdelayloop: jsr updatetime
                ;lda #$ff
                ;sta panelupdateflag
                ;jsr updatepanel
                dec stairdelay
                bne stairdelayloop
                jsr drawscreen
                ldx #$00
                pla
                pla
                rts

flipdoor:       lda floor
                bne flip_ok
                lda bombs                       ;Server room door doesn't open
                beq flip_ok                     ;before all bombs are defused
                lda actxh,x
                cmp #SERVERROOM_DOOR_X
                bne flip_ok
                lda actyh,x
                cmp #SERVERROOM_DOOR_Y
                bne flip_ok
                rts
flip_ok:        ldy actyh,x
                lda maptbllo,y
                sta alo
                lda maptblhi,y
                sta ahi
                ldy actxh,x
                lda (alo),y
                eor #$01
                sta (alo),y
                lda #$ff
                sta oldactxh
                sta oldactyh
                lda actxh,x
                ldy actyh,x
                jmp updateblock


storepos:       lda actxl,x
                sta actorxltemp
                lda actxh,x
                sta actorxhtemp
                lda actyl,x
                sta actoryltemp
                lda actyh,x
                sta actoryhtemp
                rts

restorepos:     lda actorxltemp
                sta actxl,x
                lda actorxhtemp
                sta actxh,x
                lda actoryltemp
                sta actyl,x
                lda actoryhtemp
                sta actyh,x
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³RTHRUSTACTOR                                                                 ³
;³                                                                             ³
;³Gives angular (rotational) speed to actor.                                   ³
;³                                                                             ³
;³Parameters: X:Actor number                                                   ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

rthrustactor:   clc
                adc actsd,x
                sta actsd,x
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³THRUSTACTORFAST                                                              ³
;³                                                                             ³
;³Gives speed to actor.                                                        ³
;³                                                                             ³
;³Parameters: X:Actor number                                                   ³
;³            Y:Number of right shifts of speed                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y,temp3                                                          ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

thrustactorfast:sty temp3
                ldy actd,x
                lda sintbl,y
                ldy temp3
                beq taf_skipasr1
                jsr asr_rounddown
taf_skipasr1:   clc
                adc actsx,x
                sta actsx,x
                ldy actd,x
                lda costbl,y
                ldy temp3
                beq taf_skipasr2
                jsr asr_rounddown
taf_skipasr2:   sta temp3
                lda actsy,x
                sec
                sbc temp3
                sta actsy,x
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³THRUSTACTOR                                                                  ³
;³                                                                             ³
;³Gives speed to actor.                                                        ³
;³                                                                             ³
;³Parameters: X:Actor number                                                   ³
;³            Y:Multiplier                                                     ³
;³Returns: -                                                                   ³
;³Modifies: A,Y,temp3                                                          ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

thrustactor:    sty temp3
                ldy actd,x
                lda sintbl,y
                ldy temp3
                jsr muls
                clc
                bpl ta_xok
                ldy alo
                beq ta_xok
                sec
ta_xok:         adc actsx,x
                sta actsx,x
                ldy actd,x
                lda costbl,y
                ldy temp3
                jsr muls
                sec
                bpl ta_yok
                ldy alo
                beq ta_yok
                clc
ta_yok:         lda actsy,x
                sbc ahi
                sta actsy,x
                rts


;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³BRAKEACTOR                                                                   ³
;³                                                                             ³
;³Reduces speed of actor.                                                      ³
;³                                                                             ³
;³Parameters: A:How slowly rotationspeed decreases                             ³
;³            X:Actor number                                                   ³
;³            Y:How slowly movespeed decreases                                 ³
;³                                                                             ³
;³Returns: -                                                                   ³
;³Modifies: A,Y,temp3-temp4                                                    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

brakeactor:     sta temp4
                sty temp3
                lda actsx,x
                jsr asr_roundup
                sta ba_sbcx+1
                lda actsx,x
                sec
ba_sbcx:        sbc #$00
                sta actsx,x
                lda actsy,x
                ldy temp3
                jsr asr_roundup
                sta ba_sbcy+1
                lda actsy,x
                sec
ba_sbcy:        sbc #$00
                sta actsy,x
                lda actsd,x
                ldy temp4
                jsr asr_roundup
                sta ba_sbcd+1
                lda actsd,x
                sec
ba_sbcd:        sbc #$00
                sta actsd,x
                rts

getabsspeed:    lda actsx,x
                bpl gas_ok1
                eor #$ff
                clc
                adc #$01
gas_ok1:        tay
                jsr mulu
                sta temp4
                lda alo
                sta temp3
                lda actsy,x
                bpl gas_ok2
                eor #$ff
                clc
                adc #$01
gas_ok2:        tay
                jsr mulu
                lda alo
                clc
                adc temp3
                php
                rol
                rol
                rol
                and #$03
                sta alo
                plp
                lda ahi
                adc temp4
                asl
                asl
                ora alo
                tay
                lda sqrttbl,y
                rts

walkanimation:  lda actattk,x
                bne wa_attk
                jsr getabsspeed
                clc
                adc actfd,x
                sta actfd,x
                lsr
                lsr
                lsr
                lsr
                and #$03
                tay
                lda walkfrtbl,y
                sta actf,x
                rts
wa_attk:        ldy #$01
                dec actattk,x
                bmi wa_noarm
                ldy #$03
wa_noarm:       tya
                sta actf,x
                rts

