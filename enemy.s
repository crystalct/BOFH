MODE_PATROL     = 0
MODE_HUNT       = 1
MODE_GOROUNDLEFT = 2
MODE_GOROUNDRIGHT = 3
MODE_GRENADE    = 4

GRENADEBACKOFFTIME = 48

ma_terrorist:   lda actt,x
                sec
                sbc #ACT_FISTMAN
                tay
                lda enemyspdtbl,y
                sta mah_posspeed+1
                eor #$ff
                clc
                adc #$01
                sta mah_negspeed+1
                lda enemywpntbl,y
                sta actweapon
                lda actmode,x
                asl
                tay
                lda enemyjumptbl,y
                sta ma_tjump+1
                lda enemyjumptbl+1,y
                sta ma_tjump+2
ma_tjump:       jmp $0000

ma_goround:     jsr waytotarget
                bcc ma_goroundok
                jsr adjusttargetangle
ma_goroundok:   jsr gotoangle
                jsr waytoorigtarget
                bcs ma_goroundnotout
                jmp ma_backtohunt
ma_goroundnotout:
                jmp ma_human

ma_hunt:        lda actctrl,x                   ;Some enemies have a
                and #JOY_FIRE                   ;"continuous" attack where
                beq ma_nocontattack             ;they stand still
                lda actt,x
                sec
                sbc #ACT_FISTMAN
                tay
                jsr random
                cmp contattacktbl,y
                bcs ma_nocontattack
                ldy #ACTI_BOFH
                jsr findangle
                sta acttime,x
                jsr gotoangle                   ;Aim (turn to target)
                lda actctrl,x
                and #255-JOY_UP
                ora #JOY_FIRE
                sta actctrl,x
                jmp ma_human

ma_nocontattack:ldy #ACTI_BOFH
                jsr findangle
                sta ma_targetangle+1
                ldy actt,x                      ;Technicians run!
                cpy #ACT_TECHNICIAN
                bne ma_notfleeing
                clc
                adc #$80
ma_notfleeing:  sta acttime,x                   ;Target angle
                jsr gotoangle
                jsr waytotarget
                bcc ma_huntnowall
                jsr random
                cmp #$40
                bcs ma_huntnowall
                and #$01
                ora #MODE_GOROUNDLEFT
                sta actmode,x
                jsr adjusttargetangle
                jmp ma_human
ma_huntnowall:  jsr seeplayer                   ;If gone behind a wall,
                bcs ma_huntsee                  ;there's a chance of the enemy
                jsr random                      ;becoming bored
                ldy difficulty
                cmp boredtbl,y
                bcc ma_huntnotbored
                if SHOWBORED>0
                lda $d020
                adc #$01
                ora #$08
                sta $d020
                endif
                lda #MODE_PATROL
                sta actmode,x
                sta acttime,x
ma_huntnotbored:jmp ma_human
ma_huntsee:     ldy #ACTI_BOFH
                lda actt,y
                cmp #ACT_BOFH                   ;Don't attack if BOFH dead
                bne ma_noattack
                jsr finddistance
                sta temp3
                lda actt,x
                sec
                sbc #ACT_FISTMAN
                tay
                lda temp3
                cmp enemycloseenoughtbl,y       ;Close enough for attack?
                bcs ma_noattack
                lda actd,x                      ;Aim good enough?
                sec
ma_targetangle: sbc #$00
                bpl ma_aimpos
                eor #$ff
                clc
                adc #$01
ma_aimpos:      cmp #$20
                bcs ma_noattack
                jsr random
                sec
                sbc difficulty
                bcc ma_begingrenadeattack
                sbc difficulty
                bcc ma_yesattack
                sbc difficulty
                bcc ma_yesattack
                cmp enemyattacktbl,y
                bcs ma_noattack
ma_yesattack:   lda actctrl,x
                ora #JOY_FIRE
                sta actctrl,x
ma_noattack:    jmp ma_human

ma_begingrenadeattack:
                lda actattkd,x
                bne ma_noattack
                lda actt,x
                cmp #ACT_TECHNICIAN
                beq ma_noattack
                cmp #ACT_SADIST
                beq ma_noattack
                lda #MODE_GRENADE
                sta actmode,x
                lda temp3
                asl
                asl
                adc #$01
                sta acttime,x
                lda #WPN_GRENADE
                sta actweapon
                lda actctrl,x
                ora #JOY_FIRE
                sta actctrl,x
                jmp ma_human

ma_grenadeattack:
                lda #WPN_GRENADE
                sta actweapon
                lda #JOY_FIRE
                sta actctrl,x
                dec acttime,x
                bpl ma_graok
                lda #JOY_DOWN
                sta actctrl,x
                lda #256-GRENADEBACKOFFTIME
                sta acttime,x
                lda #MODE_PATROL
                sta actmode,x
ma_graok:       jmp ma_human

ma_patrol:      jsr wallahead
                bcc ma_patrolnowall
                lda actctrl,x
                cmp #JOY_UP
                bne ma_patrolnowall
                ldy #JOY_LEFT+JOY_UP
                jsr random
                and #$01
                bne ma_patrolwallok
                ldy #JOY_RIGHT+JOY_UP
ma_patrolwallok:tya
                sta actctrl,x
ma_patrolnowall:lda acttime,x
                bmi ma_patrolbackoff
                dec acttime,x
                bpl ma_patroldirok
ma_newdir:      jsr random
                and #$07
                adc #$08
                sta acttime,x
                jsr random
                and #$07
                tay
                lda enemypatroltbl,y
                sta actctrl,x
ma_patroldirok: jsr inview
                bcc ma_nohunt
ma_backtohunt:  lda #MODE_HUNT
                sta actmode,x
ma_nohunt:      jmp ma_human
ma_patrolbackoff:
                inc acttime,x
                jmp ma_nohunt

alertall:       ldy #ACTI_FIRSTCOMMON
aa_loop:        lda actt,y
                cmp #ACT_FISTMAN
                bcc aa_next
                cmp #ACT_TECHNICIAN+1
                bcs aa_next
                lda actmode,y
                cmp #MODE_GRENADE
                beq aa_next
                lda #MODE_HUNT
                sta actmode,y
aa_next:        iny
                cpy #ACTI_LASTCOMMON+1
                bcc aa_loop
                rts

gotoangle:      lda acttime,x
                ldy #JOY_UP
                sec
                sbc actd,x
                beq ma_gotook
                bmi ma_gotoleft
                ldy #JOY_RIGHT+JOY_UP
                bne ma_gotook
ma_gotoleft:    ldy #JOY_LEFT+JOY_UP
ma_gotook:      tya
                sta actctrl,x
                rts

adjusttargetangle:
                lda acttime,x
                ldy actmode,x
                cpy #MODE_GOROUNDLEFT
                beq ata_left
                clc
                adc #$40
                jmp ata_common
ata_left:       sec
                sbc #$40
ata_common:     and #$c0
                sta acttime,x
                rts

waytotarget:    lda acttime,x
                jmp wallahead_common

waytoorigtarget:ldy #ACTI_BOFH
                jsr findangle
                ldy actt,x                      ;Technicians run!
                cpy #ACT_TECHNICIAN
                bne wtot_notfleeing
                clc
                adc #$80
wtot_notfleeing:jmp wallahead_common

wallahead:      lda actd,x
wallahead_common:
                clc
                adc #$10
                rol
                rol
                rol
                rol
                and #$07
                sta temp3
                jsr storepos
                ldy temp3
                lda watblx,y
                jsr signexpand
                clc
                adc actxl,x
                sta actxl,x
                tya
                adc actxh,x
                sta actxh,x
                ldy temp3
                lda watbly,y
                jsr signexpand
                clc
                adc actyl,x
                sta actyl,x
                tya
                adc actyh,x
                sta actyh,x
                jsr getcharposinfo
                and #CI_DOOR|CI_OBSTACLE|CI_HIGHOBSTACLE
                beq wa_not
                and #CI_DOOR
                bne wa_not              ;Door is not a problem
wa_yes:         jsr restorepos
                sec
                rts
wa_not:         jsr restorepos
                clc
                rts





ma_corpse1:     dec acttime,x
                bmi ma_corpse1end
                lda actd,x
                clc
                adc #$10
                sta actd,x
                rts
ma_corpse1end:  inc actt,x
                lda #$40
                sta acttime,x

ma_corpse2:     dec acttime,x
                bmi ma_corpse2end
                lda acttime,x
                cmp #$20
                bcs ma_corpse2noflash
                ror
                ror
                and #$80
                sta actf,x
ma_corpse2noflash:rts
ma_corpse2end:  lda #ACT_NONE
                sta actt,x
                rts

terroristdeath: stx td_restx+1
                sty td_resty+1
                jsr decterrorists
                ldx td_resty+1
                lda actt,x
                cmp #ACT_LEADER
                bne td_noleader
                dec leaders
td_noleader:    sec
                sbc #ACT_FISTMAN
                asl
                tay
                lda tscoretbl,y
                sta alo
                lda tscoretbl+1,y
                sta ahi
                jsr addscore
                lda actt,x
                cmp #ACT_TECHNICIAN
                bne td_notech

                ldy #9*3-1
td_instrcheck:  lda wirecolor,y                         ;Any instructions that
                beq td_instrcheck2                      ;the player doesn't
                lda haveinstr,y                         ;have?
                beq td_instrok
td_instrcheck2: dey
                bpl td_instrcheck
td_instrnotok:  lda #ITEM_MEDLARGE
                jmp td_itemok2
td_instrok:     lda #ITEM_INSTRUCT
                jmp td_itemok2
td_notech:      jsr random
                and #$0f
                tay
                lda itemtbl,y
                bpl td_itemok
                lda actt,x
                sec
                sbc #ACT_FISTMAN
                tay
                lda titemtbl,y
                bmi td_noitem
td_itemok:      ldy actt,x
                cpy #ACT_SADIST                 ;Sadist never carries
                bne td_itemok2                  ;grenades
                cmp #ITEM_GRENADES
                bne td_itemok2
                lda #ITEM_CROSSBOW
td_itemok2:     sta td_itemframe+1
                lda #ACTI_LASTCOMMON
                ldy #ACTI_FIRSTCOMMON
                jsr getfreeactor
                bcs td_itemspawnok
                txa                             ;If there are no free actors,
                tay                             ;remove the corpse
td_itemspawnok: lda #ACT_ITEM
                jsr spawnactor
                jsr random
                sta actd,y
                lda actorglo,x
                sta actorglo,y
                lda actorghi,x
                sta actorghi,y
td_itemframe:   lda #$00
                sta actf,y
                tya
                tax
                ldy #1
                jsr thrustactorfast
td_noitem:
td_restx:       ldx #$00
td_resty:       ldy #$00
                rts

decterrorists:  sed
                lda terrorists
                sec
                sbc #$01
                sta terrorists
                lda terrorists+1
                sbc #$00
                sta terrorists+1
                cld
                lda panelupdateflag
                ora #PU_TERRORISTS
                sta panelupdateflag
                rts

