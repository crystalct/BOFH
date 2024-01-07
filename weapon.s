NUM_SHRAPNEL    = 6

FIST_DAMAGE     = $03
WHIP_DAMAGE     = $04
FLAME_DAMAGE    = $03
BULLET_DAMAGE   = $05
ARROW_DAMAGE    = $10
GRENADE_DAMAGE  = $15
BOMB_DAMAGE     = $20
COMPUTER_DAMAGE = $03

BULLET_DURATION = 16
FISTHIT_DURATION = 1
WHIPHIT_DURATION = 3
ARROW_DURATION = 16
GRENADE_DURATION = 50

BULLET_SPEED    = 1
FISTHIT_SPEED   = 1
WHIPHIT_SPEED   = 1
BNDHIT_SPEED    = 1
ARROW_SPEED     = 1
BLOOD_SPEED     = 2
ITEM_SPEED      = 2

ITEM_CAT5       = 0
ITEM_BND        = 1
ITEM_CROSSBOW   = 2
ITEM_PISTOL     = 3
ITEM_SHOTGUN    = 4
ITEM_UZI        = 5
ITEM_FLAMETHR   = 6
ITEM_GRENADES   = 7
ITEM_MEDSMALL   = 8
ITEM_MEDLARGE   = 9
ITEM_INSTRUCT   = 10

WPN_FISTS       = 0
WPN_CAT5        = 1
WPN_BND         = 2
WPN_CROSSBOW    = 3
WPN_PISTOL      = 4
WPN_SHOTGUN     = 5
WPN_UZI         = 6
WPN_FLAMETHR    = 7
WPN_GRENADE     = 8

FIST_DELAY      = 5
WHIP_DELAY      = 5
PISTOL_DELAY    = 10
SHOTGUN_DELAY   = 12
UZI_DELAY       = 2
BND_DELAY       = 1
FLAME_DELAY     = 1
GRENADE_DELAY   = 16
CROSSBOW_DELAY  = 16



;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³CHANGEWEAPON                                                                 ³
;³                                                                             ³
;³Weapon selection routine                                                     ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

changeweapon:   lda actattk+ACTI_BOFH
                bne cw_done
                ldx weapon
                lda ammolo,x
                ora ammohi,x
                bne cw_notzero
                ldx #WPN_FLAMETHR
cw_findbest:    lda ammolo,x
                ora ammohi,x
                bne cw_wpnok
                dex
                bpl cw_findbest
cw_notzero:     ldx keytype
                bpl cw_ok
cw_done:        rts
cw_ok:          cpx #KEY_V
                beq cw_showinstr
                cpx #KEY_SPACE
                beq cw_next
                lda asciitbl,x
                sec
                sbc #"1"
                bcc cw_done
                cmp #9
                bcs cw_done
                tax
                lda ammolo,x
                ora ammohi,x
                beq cw_done
                lda #SFX_SELECT
                jsr playsfx
cw_wpnok:       stx weapon
cw_setupdate:   lda panelupdateflag
                ora #PU_WEAPON
                sta panelupdateflag
                rts
cw_next:        lda #SFX_SELECT
                jsr playsfx
                ldx weapon
cw_nextloop:    inx
                cpx #WPN_GRENADE+1
                bcc cw_nextok
                ldx #WPN_FISTS
cw_nextok:      lda ammolo,x
                ora ammohi,x
                bne cw_wpnok
                beq cw_nextloop

cw_showinstr:   ldx #9
                lda instrview
                asl
                adc instrview
                tay
cw_siloop:      iny
                iny
                iny
                cpy #9*3
                bcc cw_sinotover
                ldy #0
cw_sinotover:   lda haveinstr,y
                ora haveinstr+1,y
                ora haveinstr+2,y
                bne cw_sifound
                dex
                bne cw_siloop
                rts
cw_sifound:
                lda #SFX_SELECT
                jsr playsfx
viewinstr_common:lda bombdivtbl,y
                sta instrview
                lda #60
viewinstr_common2:
                sta instrviewtime
                bne cw_setupdate

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MA_ITEM                                                                      ³
;³                                                                             ³
;³Collectable item routine.                                                    ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ma_workstation:rts

ma_item:        lda actsx,x                   ;An item cannot be collected until
                ora actsy,x                   ;it has come to a halt
                beq mai_still
                jmp moveactor_bounce
mai_still:      ldy #ACTI_BOFH
                lda actt,y                    ;Player alive?
                cmp #ACT_BOFH
                beq mai_ok
mai_nocoll:     rts
mai_ok:         jsr checkcollision
                bcc mai_nocoll
                ldy actf,x
                cpy #ITEM_INSTRUCT
                beq mai_instr
                cpy #ITEM_MEDSMALL
                bcc mai_ammo
mai_medikit:    lda #$15
                cpy #ITEM_MEDLARGE
                bcc mai_notlarge
                lda #$25
mai_notlarge:   jsr addhealth
                bcs mai_remove
mai_noremove:   rts
mai_ammo:       jsr addammo
                bcc mai_noremove
mai_remove:     lda #ACT_NONE
                sta actt,x
                lda #SFX_COLLECT
                jmp playsfx

mai_instr:      jsr random
                and #$1f
                cmp #9*3
                bcs mai_instr
                tay
mai_instr2:     lda wirecolor,y
                beq mai_instr
                lda haveinstr,y
                bne mai_instr
mai_instrfound: lda #$01
                sta haveinstr,y
                lda #$10
                sta ahi
                lda #$00
                sta alo
                jsr addscore
                jsr viewinstr_common
                jmp mai_remove








addhealth:      ldy acthphi+ACTI_BOFH
                bne ah_fail
                sed
                clc
                adc acthplo+ACTI_BOFH
                sta acthplo+ACTI_BOFH
                cld
                bcc ah_notmaxed
ah_maxed:       lda #$01
                sta acthphi+ACTI_BOFH
                lda #$00
                sta acthplo+ACTI_BOFH
ah_notmaxed:    lda panelupdateflag
                ora #PU_HEALTH
                sta panelupdateflag
                sec
                rts
ah_fail:        clc
                rts

addammo:        lda panelupdateflag
                ora #PU_WEAPON
                sta panelupdateflag
                jsr compareammo
                bcs addammo_fail
                cpy weapon
                bcc addammo_noautoselect        ;Never autoselect "worse"
                lda ammolo+1,y                  ;weapon
                ora ammohi+1,y
                ora actattk+ACTI_BOFH
                bne addammo_noautoselect
                cpy #ITEM_GRENADES
                bcs addammo_noautoselect
                tya
                adc #$01
                sta weapon
                jsr cw_setupdate
addammo_noautoselect:
                sed
                lda ammolo+1,y
                clc
                adc ammoaddlo+1,y
                sta ammolo+1,y
                lda ammohi+1,y
                adc ammoaddhi+1,y
                sta ammohi+1,y
                cld
                jsr compareammo
                bcc addammo_ok
                lda ammomaxlo+1,y
                sta ammolo+1,y
                lda ammomaxhi+1,y
                sta ammohi+1,y
addammo_ok:     sec
                rts
addammo_fail:   clc
                rts

compareammo:    lda ammohi+1,y
                cmp ammomaxhi+1,y
                bne ca_ok
                lda ammolo+1,y
                cmp ammomaxlo+1,y
ca_ok:          rts

decammo:        cpx #ACTI_BOFH
                bne ca_ok
                ldy weapon
                lda difficulty
                beq ca_ok
                sed
                lda ammolo,y
                sec
                sbc #$01
                sta ammolo,y
                lda ammohi,y
                sbc #$00
                sta ammohi,y
                cld
                jmp cw_setupdate

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³EXPLODEACTOR                                                                 ³
;³                                                                             ³
;³Turns an actor into an explosion and spawns shrapnel.                        ³
;³                                                                             ³
;³Parameters: X:Actor                                                          ³
;³            A:Initial damage of shrapnel                                     ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
explodeactor:   sta ea_shrapneldmg+1
                lda #NUM_SHRAPNEL
                sta temp9
explodeactor2:  lda #$00
                sta actfd,x
                sta actf,x
                lda #ACT_EXPLOSION
                sta actt,x
                lda #SFX_EXPLOSION
                jsr playsfx
                jsr alertall
ea_shrapnelloop:ldy #ACTI_FIRSTCOMMON
                lda #ACTI_LASTENEMYBULLET
                jsr getfreeactor
                bcc ea_shrapneldone
                lda #ACT_SHRAPNEL
                jsr spawnactor
                jsr random
                sta actd,y
ea_shrapneldmg: lda #$00
                sta acthplo,y
                lda #$02
                sta actf,y
                lda #LOWOBSTACLEHEIGHT*2
                sta acth,y
                stx ea_restx+1
                tya
                tax
                ldy #BULLET_SPEED
                jsr thrustactorfast
ea_restx:       ldx #$00
                dec temp9
                bne ea_shrapnelloop
ea_shrapneldone:rts





;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MA_BLOOD                                                                     ³
;³                                                                             ³
;³Blood move routine.                                                          ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ma_blood:       jsr moveactor
                inc actfd,x
                lda actfd,x
                lsr
                cmp #$03
                bcs mab_done
                sta actf,x
                rts
mab_done:       lda #ACT_NONE
                sta actt,x
                rts


;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MA_SHRAPNEL                                                                  ³
;³                                                                             ³
;³Shrapnel move routine                                                        ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ma_shrapnel:    jsr checkpunish
                jsr moveactor_bounce
                jsr checkpunish
                jsr moveactor_bounce
                sed
                lda acthplo,x
                sec
                sbc #$01
                sta acthplo,x
                cld
                bcs mashr_hpok
                lda #ACT_NONE
                sta actt,x
mashr_hpok:     rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MA_FLAME                                                                     ³
;³                                                                             ³
;³Flame move routine.                                                          ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ma_flame:       jsr checkpunish ;Collision check here
                jsr moveprojectile_checkobstacles
                bcc mafl_nohitwall
                lda #$00
                sta actsx,x
                sta actsy,x
mafl_nohitwall: inc actfd,x
                lda actfd,x
                lsr
                sta actf,x
                cmp #$04
                bcs mablt_disappear2
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MA_BULLET                                                                    ³
;³                                                                             ³
;³Bullet move routine.                                                         ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ma_bullet:      dec acttime,x
                beq mablt_disappear
                jsr checkpunish
                jsr moveprojectile_checkobstacles       ;Move twice for speed
                bcs mablt_hitwall                       ;& good collision
                jsr checkpunish
                jsr moveprojectile_checkobstacles       ;detection
                bcs mablt_hitwall
                lda actt,x
                cmp #ACT_ARROW
                beq mablt_ok
                lda #$80                                ;Hide the sprite
                sta actf,x
mablt_ok:       rts
mablt_disappear:jsr getcharposinfo
                and #CI_HIGHOBSTACLE
                bne mablt_hitwall
mablt_disappear2:
                lda #ACT_NONE
                sta actt,x
                rts
mablt_hitwall:  lda #ACT_SMOKE
                sta actt,x
                lda #$00
                sta actfd,x
                sta actf,x
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MA_GRENADE                                                                   ³
;³                                                                             ³
;³Grenade move routine.                                                        ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ma_grenade:     dec acttime,x
                bne ma_grnnoexplode
                lda #GRENADE_DAMAGE
                jmp explodeactor
ma_grnnoexplode:jsr moveactor_bounce
                jsr moveactor_bounceheight
                lda acth,x
                lsr
                lsr
                lsr
                lsr
                lsr
                sec
                sbc #$01
                bcs ma_grnok
                lda #$00
ma_grnok:       sta actf,x
                rts
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MA_MELEEHIT                                                                  ³
;³                                                                             ³
;³Melee-hit (kind of virtual actor) move routine.                              ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ma_meleehit:    jsr checkpunish
                dec acttime,x
                beq mablt_disappear
                lda actf,x
                bmi mamh_move
                cmp #$01
                bcs mamh_move
                inc actf,x
mamh_move:      jsr moveprojectile_checkobstacles
                bcs mablt_hitwall
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MA_SMOKE                                                                     ³
;³                                                                             ³
;³Smokecloud move routine.                                                     ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ma_smoke:       inc actf,x
                lda actf,x
                cmp #$04
                bcs masmk_done
                rts
masmk_done:     lda #ACT_NONE
                sta actt,x
                rts

ma_explosion:   inc actfd,x
                lda actfd,x
                and #$01
                beq ma_smoke
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³SPAWN...                                                                     ³
;³                                                                             ³
;³Various spawn routines for attacks                                           ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

spawnbullet:    jsr getspawnrange
                jsr getfreeactor
                bcc spblt_fail
                lda #ACT_BULLET
                jsr spawnactor
                lda #BULLET_DAMAGE
                sta acthplo,y
                lda #BULLET_DURATION
                sta acttime,y
                stx temp4
                sty temp5
                ldx temp5
                ldy #BULLET_SPEED
spawncommon:    jsr thrustactorfast
                jsr moveprojectile_checkobstacles
                bcc spblt_ok
                lda #$00
                sta acthplo,x
                sta actsx,x
                sta actsy,x
spblt_ok:       ldx temp4
                ldy temp5
                sec
                rts
spblt_fail:     clc
                rts

spawnflame:     jsr getspawnrange
                jsr getfreeactor
                bcc spblt_fail
                lda #ACT_FLAME
                jsr spawnactor
                lda #FLAME_DAMAGE
                sta acthplo,y
                stx temp4
                sty temp5
                ldx temp5
                ldy #BULLET_SPEED
                jmp spawncommon

spawnarrow:     jsr getspawnrange
                jsr getfreeactor
                bcc spblt_fail
                lda #ACT_ARROW
                jsr spawnactor
                lda #ARROW_DAMAGE
                sta acthplo,y
                lda #ARROW_DURATION
                sta acttime,y
                stx temp4
                sty temp5
                ldx temp5
                ldy #ARROW_SPEED
                jmp spawncommon

spawnfisthit:   jsr getspawnrange
                jsr getfreeactor
                bcc spblt_fail
                lda #ACT_MELEEHIT
                jsr spawnactor
                lda #FIST_DAMAGE
                sta acthplo,y
                lda #FISTHIT_DURATION
                sta acttime,y
                lda #$80
                sta actf,y
                stx temp4
                sty temp5
                ldx temp5
                ldy #FISTHIT_SPEED
                jmp spawncommon

spawnwhiphit:   jsr getspawnrange
                jsr getfreeactor
                bcc spblt_fail
                lda #ACT_MELEEHIT
                jsr spawnactor
                lda actd,y
                jsr limit8dirs
                sta actd,y
                lda #WHIP_DAMAGE
                sta acthplo,y
                lda #WHIPHIT_DURATION
                sta acttime,y
                stx temp4
                sty temp5
                ldx temp5
                ldy #WHIPHIT_SPEED+2
                jsr thrustactorfast
                ldy #WHIPHIT_SPEED
                jmp spawncommon

spawngrenade:   jsr getspawnrange
                jsr getfreeactor
                bcc spgr_fail
                lda #ACT_GRENADE
                jsr spawnactor
                lda #GRENADE_DURATION
                sta acttime,y
                lda #60
                sta acth,y
                lda #10
                sta actsh,y
                sty temp5
                lda #$07
                sec
                sbc actattk,x
                asl
                asl
                tay
                stx temp4
                ldx temp5
                jsr thrustactor
                jsr moveactor_bounce
                ldx temp4
                ldy temp5
                sec
                rts
spgr_fail:      clc
                rts

getspawnrange:  txa
                bne gsr_enemy
                ldy #ACTI_FIRSTPLRBULLET
                lda #ACTI_LASTPLRBULLET
                rts
gsr_enemy:      ldy #ACTI_FIRSTENEMYBULLET
                lda #ACTI_LASTENEMYBULLET
                rts

checkpunish:    lda acthplo,x
                bne csf_cont
                rts
csf_cont:       lda actt,x
                cmp #ACT_SHRAPNEL
                bne csf_noshrapnel
                ldy #ACTI_BOFH
                lda #ACTI_LASTCOMMON+1
                bne csf_ok
csf_noshrapnel: cpx #ACTI_FIRSTENEMYBULLET
                bcs csf_enemy
                ldy #ACTI_FIRSTCOMMON
                lda #ACTI_LASTCOMMON+1
                bne csf_ok
csf_enemy:      ldy #ACTI_BOFH
                lda #ACTI_BOFH+1
csf_ok:         sta csf_cmp+1
csf_loop:       lda actt,y
                beq csf_next
                cmp #ACT_BOFH
                bcc csf_next
                cmp #ACT_CORPSE1
                bcs csf_next
                jsr checkcollision
                bcs csf_punish
csf_next:       iny
csf_cmp:        cpy #$00
                bcc csf_loop
                rts
csf_punish:     lda #SFX_HIT
                cpy #ACTI_BOFH
                bne csf_nobofhhit
                if INFINITEHEALTH>0
                lda #$01
                sta acthphi+ACTI_BOFH
                lda #$00
                sta acthplo+ACTI_BOFH
                endif
                lda panelupdateflag
                ora #PU_HEALTH
                sta panelupdateflag
                lda #SFX_BOFHHIT
csf_nobofhhit:  sta csf_soundnum+1
                lda hitsoundplayed
                bne csf_nohitsound
csf_soundnum:   lda #$00
                sta hitsoundplayed
                jsr playsfx
csf_nohitsound: lda #$01
                sta actc,y
csf_skiphealth: lda #$00
                sta actf,x
                sta actfd,x
                sta actsx,x
                sta actsy,x
                lda #ACT_SMOKE
                sta actt,x
                lda actt,y
                cmp #ACT_BOFH
                beq csf_blood
                cmp #ACT_FISTMAN
                bcc csf_skipdisapp
                lda actmode,y                   ;Wounded enemy will be angry
                cmp #MODE_PATROL
                bne csf_blood
                lda #MODE_HUNT
                sta actmode,y
csf_blood:      lda #ACT_BLOOD
                sta actt,x
                jsr random
                sta actd,x
                sty csf_bloodresty+1
                ldy #BLOOD_SPEED
                jsr thrustactorfast
csf_bloodresty: ldy #$00
csf_skipdisapp: sed
                lda acthplo,y
                sec
                sbc acthplo,x
                sta acthplo,y
                lda acthphi,y
                sbc #$00
                sta acthphi,y
                cld
                lda #$00
                sta acthplo,x
                bcs csf_notover
                sta acthplo,y
                sta acthphi,y
csf_notover:    stx csf_restx+1
                lda acthplo,y
                ora acthplo,y
                bne csf_nodeath
                tya
                tax
                lda actt,x
                cmp #ACT_WORKSTATION
                bcc csf_nocomp
                cmp #ACT_CDTOWER+1
                bcs csf_nocomp
                lda #$00
                sta actorglo,x
                sta actorghi,x
                jsr deccomputers
                lda panelupdateflag
                ora #PU_COMPUTERS
                sta panelupdateflag
                lda #COMPUTER_DAMAGE      ;Maximum damage of shrapnel
                jsr explodeactor
                jmp csf_restx

csf_nocomp:     sty csf_corpseresty+1
                lda actt,y
                cmp #ACT_BOFH+1
                bcc csf_noterrorist
                jsr terroristdeath
                lda actt,y              ;If actor has been transformed into
                cmp #ACT_ITEM           ;an item (no room for additional
                beq csf_sound           ;actors), skip the corpsesequence
csf_noterrorist:asl
                tay
                lda acttbl-2,y          ;Actor datastructure
                sta temp3
                lda acttbl-1,y
                sta temp4
                ldy #ACTS_COLOR
                lda (temp3),y
csf_corpseresty:ldy #$00
                sta actc,y
                lda #ACT_CORPSE1
                sta actt,y
                lda #$10
                sta acttime,y
                lda #$00
                sta actf,y
                sta actorglo,y
                sta actorghi,y
csf_sound:      lda #SFX_DEATH
                jsr playsfx

csf_restx:      ldx #$00
csf_nodeath:    pla
                pla
                rts

deccomputers:   sed
                lda computers
                sec
                sbc #$01
                sta computers
                lda computers+1
                sbc #$00
                sta computers+1
                cld
                rts
