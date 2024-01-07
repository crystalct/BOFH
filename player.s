DI_PRACTICE     = 0
DI_EASY         = 1
DI_MEDIUM       = 2
DI_HARD         = 3
DI_INSANE       = 4

PU_SCORE        = 1
PU_HEALTH       = 2
PU_TERRORISTS   = 4
PU_TIME         = 8
PU_BOMBS        = 16
PU_COMPUTERS    = 32
PU_WEAPON       = 64

BOMB_NONE       = 0
BOMB_ACTIVE     = 1
BOMB_DEFUSED    = 2

WI_UNCUT        = 0
WI_CUT          = 1

SERVERROOM_DOOR_X = 36
SERVERROOM_DOOR_Y = 48

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³INITGAME                                                                     ³
;³                                                                             ³
;³Game state initialisation.                                                   ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

initgame:       jsr initactors
                lda #$00
                sta score
                sta score+1
                sta score+2
                sta instrviewtime
                sta instrview
                sta wirenumber
                sta detonate
                sta victorycount
                tay
                jsr getfreeactor
                lda #41
                sta actxh+ACTI_BOFH
                lda #47
                sta actyh+ACTI_BOFH
                lda #0
                sta actxl+ACTI_BOFH
                sta actyl+ACTI_BOFH
                sta actd+ACTI_BOFH
                lda #ACT_BOFH
                sta actt+ACTI_BOFH
                lda #1
                sta floor
                jsr depackfloor
                jsr depackactordata
                jsr processactors
                jsr addallactors

                ldx #$08
                lda #$00
                ldy difficulty
                bne clearwpn
                lda #$99
clearwpn:       sta ammolo,x
                sta ammohi,x
                dex
                bpl clearwpn
                lda #$99
                sta ammolo+WPN_FISTS
                sta ammohi+WPN_FISTS
                lda #WPN_FISTS
                sta weapon
                lda #$60
                sta time+1
                lda #$00
                sta time
                sta timefr
                lda #$01
                sta acthphi
                lda #$00
                sta acthplo
                lda #$ff
                sta panelupdateflag
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³PROCESSACTORS                                                                ³
;³                                                                             ³
;³Game state initialisation (actors).                                          ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

processactors:  lda #$00
                sta computers
                sta computers+1
                sta terrorists
                sta terrorists+1
                lda #3
                sta leaders
                ldx #9*3-1
                lda #$00
pa_clearbombs:  sta wirestat,x                  ;Reset bomb&instruction status
                sta haveinstr,x
                if HAVEALLINSTRUCTIONS>0
                inc haveinstr,x
                endif
                sta wirecolor,x
                dex
                bpl pa_clearbombs
                ldx #8
pa_clearcl:     sta bombstat,x
                dex
                bpl pa_clearcl
                ldx difficulty
                lda bombtbl,x
                sta bombs
                txa
                asl
                tax
                lda enemytbl,x
                sta pa_enemycmp1+1
                lda enemytbl+1,x
                sta pa_enemycmp2+1

                ldx #$00
pa_placebomb:   cpx bombs
                beq pa_placebombdone
pa_pbrandom:    jsr random
                and #$0f
                cmp #$09
                bcs pa_pbrandom
                tay
                lda bombstat,y
                bne pa_pbrandom
                lda #BOMB_ACTIVE
                sta bombstat,y
                sty temp1
                tya
                asl
                adc temp1
                tay
pa_firstwire:   jsr random
                and #$07
                beq pa_firstwire
                cmp #$06
                bcs pa_firstwire
                sta wirecolor,y
pa_secondwire:  jsr random
                and #$07
                cmp #$07
                beq pa_secondwire
                cmp wirecolor,y
                beq pa_secondwire
                bcc pa_secondwire
                sta wirecolor+1,y
pa_thirdwire:   jsr random
                and #$07
                cmp wirecolor,y
                beq pa_thirdwire
                bcc pa_thirdwire
                cmp wirecolor+1,y
                beq pa_thirdwire
                bcc pa_thirdwire
                sta wirecolor+2,y
                inx
                jmp pa_placebomb

pa_placebombdone:
                lda #<lvlact0
                sta temp1
                lda #>lvlact0
                sta temp2
pa_loop:        ldy #LVLACT_T
                lda (temp1),y
                cmp #ACT_WORKSTATION
                bcc pa_nocomp
                cmp #ACT_CDTOWER+1
                bcs pa_nocomp
                tax
                lda actordefaulthp-1,x
                iny
                sta (temp1),y
                dey
                sed
                lda computers
                clc
                adc #$01
                sta computers
                lda computers+1
                adc #$00
                sta computers+1
                cld

pa_nocomp:      lda (temp1),y
                cmp #ACT_FISTMAN
                bcc pa_noterrorist
                bne pa_skiprandomize
                jsr random
                and #$07
                tax
                lda enemytypetbl,x
                if ALLTECHNICIANS>0
                lda #ACT_TECHNICIAN
                endif
                sta (temp1),y
pa_skiprandomize:
                tax
                lda actordefaulthp-1,x
                iny
                sta (temp1),y
                dey
                jsr random
                and #$70
                dey
                ora (temp1),y                           ;Randomize direction
                sta (temp1),y
                iny
                sed
                lda terrorists
                clc
                adc #$01
                sta terrorists
                lda terrorists+1
                adc #$00
                sta terrorists+1
                cld

pa_noterrorist: lda (temp1),y
                cmp #ACT_ITEM
                bne pa_noitem
                iny
                lda (temp1),y
                cmp #ITEM_CAT5
                beq pa_noitem               ;Never lose the CAT-5 whip
                cmp #ITEM_BND               ;B&Ds are always at their assigned
                beq pa_noitemrandom         ;places
                jsr random
                and #$0f
                tax
                lda levelitemtbl,x
                sta (temp1),y
pa_noitemrandom:dey
                jsr random
                cmp #$70
                bcc pa_noitemremove
                lda #ACT_NONE
                sta (temp1),y
pa_noitemremove:
pa_noitem:
                lda temp1
                clc
                adc #$05
                sta temp1
                bcc pa_nextok
                inc temp2
pa_nextok:      lda temp1
                cmp #<lvlact6
                beq pa_checkhigh
                jmp pa_loop
pa_checkhigh:   lda temp2
                cmp #>lvlact6
                beq pa_done
                jmp pa_loop
pa_done:        lda bombs
                asl
                adc bombs
                sta temp3                       ;Number of technicians
                sta instructions

pa_loopagain:   lda #<lvlact0                   ;Now loop again to remove
                sta temp1                       ;unnecessary enemies and add
                lda #>lvlact0                   ;technicians
                sta temp2
pa_loop2:       ldy #LVLACT_T
                lda (temp1),y
                cmp #ACT_FISTMAN
                bcc pa_skipremove
                ldx difficulty                  ;On PRACTICE all enemies will
                beq pa_doremove                 ;be removed
                cmp #ACT_LEADER
                beq pa_skipremove
                cmp #ACT_TECHNICIAN
                beq pa_skipremove
                lda terrorists
pa_enemycmp1:   cmp #$00
                bne pa_removeok
                lda terrorists+1
pa_enemycmp2:   cmp #$00
                bne pa_removeok
                lda temp3                       ;All technicians done?
                beq pa_alldone
                jsr random
                cmp #$08                        ;Small chance of turning
                bcs pa_skipremove               ;an enemy to a technician
                lda #ACT_TECHNICIAN
                sta (temp1),y
                iny
                lda actordefaulthp+ACT_TECHNICIAN-1     ;Correct hitpoints
                sta (temp1),y
                dey
                dec temp3
                jmp pa_skipremove
pa_removeok:    jsr random
                cmp #$60
                bcs pa_skipremove
pa_doremove:    lda #ACT_NONE
                sta (temp1),y
                jsr decterrorists
pa_skipremove:  lda temp1
                clc
                adc #$05
                sta temp1
                bcc pa_nextok2
                inc temp2
pa_nextok2:     lda temp1
                cmp #<lvlact6
                beq pa_checkhigh2
                jmp pa_loop2
pa_checkhigh2:  lda temp2
                cmp #>lvlact6
                beq pa_done2
                jmp pa_loop2
pa_done2:       lda difficulty
                beq pa_alldone
                jmp pa_loopagain
pa_alldone:     rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³DEFUSE                                                                       ³
;³                                                                             ³
;³Bomb defusing stuff.                                                         ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

defuse:         lda #$ff
                sta atcloset
                lda detonate                    ;Bombs exploding?
                beq df_nodet
                jmp dodetonation
df_nodet:       lda actt+ACTI_BOFH
                cmp #ACT_BOFH                   ;Dead men can't defuse bombs :-)
                beq df_alive
                rts
df_alive:       ldx #8
df_search:      lda floor
                cmp closetf,x
                bne df_next
                lda actxh+ACTI_BOFH
                cmp closetx,x
                bne df_next
                lda actyh+ACTI_BOFH
                cmp closety,x
                bne df_next
                stx atcloset
                jmp df_found
df_next:        dex
                bpl df_search
                rts
df_found:       stx instrview
                lda #2
                jsr viewinstr_common2
                lda bombstat,x                  ;Is there a bomb?
                cmp #BOMB_ACTIVE
                beq df_bomb
                rts
df_bomb:        lda prevjoy
                bne df_noctrl
                lda joystick
                and #JOY_LEFT
                beq df_notleft
                dec wirenumber
                bpl df_notleft
                lda #$06
                sta wirenumber
df_notleft:     lda joystick
                and #JOY_RIGHT
                beq df_notright
                inc wirenumber
                lda wirenumber
                cmp #$07
                bcc df_notright
                lda #$00
                sta wirenumber
df_notright:    lda joystick
                and #JOY_FIRE
                bne df_fire
df_noctrl:      rts
df_fire:        lda atcloset
                asl
                adc atcloset
                tax
                ldy #$03
df_findwire:    lda wirecolor,x
                sec
                sbc #$01
                cmp wirenumber
                beq df_correctwire
                inx
                dey
                bne df_findwire
                lda #SFX_CUTWIRE
                jsr playsfx
detonatebombs:  lda #150
                sta detonate
                lda #$00
                sta explcolor
                rts
df_correctwire: lda wirestat,x
                bne df_wirecut
                lda #WI_CUT
                sta wirestat,x
                lda #SFX_CUTWIRE
                jsr playsfx
                lda #$00
                sta alo
                lda #$20                        ;2000 points for each wire
                sta ahi
                jsr addscore
                lda bombdivtbl,x
                asl
                adc bombdivtbl,x
                tay
                lda wirestat,y                  ;All wires cut?
                and wirestat+1,y
                and wirestat+2,y
                beq df_wirecut
                lda #SFX_COLLECT
                jsr playsfx
                ldx atcloset
                lda #BOMB_DEFUSED
                sta bombstat,x
                dec bombs
                lda panelupdateflag
                ora #PU_BOMBS
                sta panelupdateflag
                lda #$00
                sta alo
                lda #$40                        ;4000 points for finishing
                sta ahi                         ;the defusing
                jsr addscore
                lda haveinstr,y
                and haveinstr+1,y
                and haveinstr+2,y
                bne df_hadinstr
                lda #$00
                sta alo
                lda #$50
                sta ahi
                jsr addscore                    ;Additional 10000 for defusing
                jsr addscore                    ;without instructions
df_hadinstr:
df_wirecut:     rts


dodetonation:   ldx explcolor
                lda explcol1,x
                sta bgcolor2+1
                lda explcol2,x
                sta bgcolor3+1
                dex
                bpl df_explcolorok
                ldx #$00
df_explcolorok: stx explcolor
                jsr random
                and #$3f
                sta scrollx
                jsr random
                and #$3f
                sta scrolly
                ldy #ACTI_FIRSTCOMMON           ;Spawn some nice explosions
                lda #ACTI_LASTENEMYBULLET
                jsr getfreeactor
                bcc df_detnoexpl
                tya
                tax
df_randomcloset:jsr random
                and #$0f
                cmp #$09
                bcs df_randomcloset
                tay
                lda bombstat,y
                cmp #BOMB_ACTIVE
                bne df_detnoexpl
                lda floor
                cmp closetf,y
                bne df_detnotonthisfloor
                lda #$03
                sta explcolor
                lda closetx,y
                sta actxh,x
                lda closety,y
                sta actyh,x
                jsr random
                sta actxl,x
                jsr random
                sta actyl,x
                lda #BOMB_DAMAGE
                sta ea_shrapneldmg+1
                lda #2
                sta temp9
                jsr explodeactor2
                jmp df_detnoexpl
df_detnotonthisfloor:
                jsr random
                cmp #$a0
                bcs df_detnoexpl
                lda #SFX_EXPLOSION
                jsr playsfx
df_detnoexpl:   dec detonate
                bne df_detnotcomplete
                lda #ACT_NONE                   ;If BOFH isn't dead yet, now
                sta actt+ACTI_BOFH              ;make him disappear...
df_detnotcomplete:
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MA_BOFH                                                                      ³
;³                                                                             ³
;³Player move routine.                                                         ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ma_bofh:        lda joystick
                ldy atcloset
                bmi ma_bofhctrlok       ;Prevent attacks when at a closet
                and #255-JOY_FIRE
                pha
                lda #$00
                sta actattk,x
                pla
ma_bofhctrlok:  sta actctrl,x
                lda #24
                sta mah_posspeed+1
                lda #-24
                sta mah_negspeed+1
                lda weapon
                sta actweapon
                jmp ma_human

ma_human:       lda actattk,x
                bne mah_skipmove
                lda actctrl,x
                and #JOY_UP
                beq mah_notup
mah_posspeed:   ldy #0
                jsr thrustactor
mah_notup:      lda actctrl,x
                and #JOY_DOWN
                beq mah_notdown
mah_negspeed:   ldy #0
                jsr thrustactor
mah_notdown:
mah_skipmove:   lda actctrl,x
                and #JOY_RIGHT
                beq mah_notright
mah_posrspeed:  lda #2
                jsr rthrustactor
mah_notright:   lda actctrl,x
                and #JOY_LEFT
                beq mah_notleft
mah_negrspeed:  lda #-2
                jsr rthrustactor
mah_notleft:    jsr walkanimation
                lda #3
                ldy #2
                jsr brakeactor
                jsr moveactor_rotate_checkobstacles
                lda actattkd,x
                beq mah_nodelay
                dec actattkd,x
                rts
mah_nodelay:    lda actctrl,x
                and #JOY_FIRE
                beq mah_nofire
                lda actweapon
                asl
                tay
                lda mah_wpnjumptbl,y
                sta mah_wpnjump+1
                lda mah_wpnjumptbl+1,y
                sta mah_wpnjump+2
                cpx #ACTI_BOFH
                bne mah_wpnjump
                ldy actweapon               ;Ammo check for player
                lda ammolo,y
                ora ammohi,y
                beq mah_noattack
mah_wpnjump:    jmp $0000
mah_nofire:     lda actattk,x
                cmp #$04
                bcc mah_noattack
                lda actweapon
                cmp #WPN_GRENADE
                beq mah_grenaderelease
                cmp #WPN_CROSSBOW
                beq mah_arrowrelease
mah_noattack:   rts
mah_grenaderelease:
                jsr spawngrenade
                bcc mah_grenadefail
                lda #3
                sta actattk,x
                lda #GRENADE_DELAY
                sta actattkd,x
                lda #SFX_THROW
                jsr playsfx
                jmp decammo
mah_grenadefail:rts
mah_arrowrelease:
                jsr spawnarrow
                bcc mah_grenadefail
                lda #3
                sta actattk,x
                lda #CROSSBOW_DELAY
                sta actattkd,x
                lda #SFX_CROSSBOW
                jsr playsfx
                jmp decammo






mah_wpnjumptbl: dc.w mah_fist
                dc.w mah_whip
                dc.w mah_bnd
                dc.w mah_crossbow
                dc.w mah_pistol
                dc.w mah_shotgun
                dc.w mah_uzi
                dc.w mah_flamethr
                dc.w mah_grenade

mah_fist:       jsr spawnfisthit
                lda #0
                sta actfd,x
                lda #3
                sta actattk,x
                lda #FIST_DELAY
                sta actattkd,x
                lda #SFX_FIST
                jmp playsfx

mah_whip:       jsr spawnwhiphit
                lda #0
                sta actfd,x
                lda #3
                sta actattk,x
                lda #WHIP_DELAY
                sta actattkd,x
                lda #SFX_WHIP
                jmp playsfx

mah_bnd:        jsr spawnfisthit
                lda #0
                sta actfd,x
                lda #2
                sta actattk,x
                lda #BND_DELAY
                sta actattkd,x
                lda #SFX_BND
                jsr playsfx
                jsr decammo
                jmp decammo

mah_pistol:     jsr spawnbullet
                bcc mah_pfail
                lda #PISTOL_DELAY
                sta actattkd,x
                jsr alertall
                lda #SFX_PISTOL
mah_sndcommon:  jsr playsfx
                jmp decammo
mah_pfail:      rts

mah_uzi:        jsr spawnbullet
                bcc mah_pfail
                lda #UZI_DELAY
                sta actattkd,x
                jsr alertall
                lda #SFX_UZI
                bne mah_sndcommon

mah_flamethr:   jsr spawnflame
                bcc mah_pfail
                lda #FLAME_DELAY
                sta actattkd,x
                jsr alertall
                lda #SFX_FLAME
                bne mah_sndcommon


mah_shotgun:    jsr getspawnrange
                jsr countfreeactors
                cmp #$03
                bcc mah_pfail
                jsr alertall
                lda #SHOTGUN_DELAY
                sta actattkd,x
                lda #SFX_SHOTGUN
                jsr playsfx
                jsr decammo
                lda #$fe
                jsr turnspawnbullet
                lda #$80
                sta actf,y
                lda #$04
                jsr turnspawnbullet
                lda #$80                      ;Show muzzle only for center
                sta actf,y                    ;bullet
                lda #$fe
turnspawnbullet:clc
                adc actd,x
                sta actd,x
                jmp spawnbullet

mah_grenade:    lda actattk,x
                bmi mah_grenadehold
                lda #$ff
                sta actattk,x
                rts
mah_grenadehold:cmp #$ec
                bcs mah_ghok
                lda #$ec
                sta actattk,x
mah_ghok:       rts

mah_crossbow:   lda #$05
                sta actattk,x
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ADDSCORE                                                                     ³
;³                                                                             ³
;³Adds score to player.                                                        ³
;³                                                                             ³
;³Parameters: alo,ahi: score to add                                            ³
;³Returns: -                                                                   ³
;³Modifies: A                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

addscore:       sed
                lda score
                clc
                adc alo
                sta score
                lda score+1
                adc ahi
                sta score+1
                lda score+2
                adc #$00
                sta score+2
                cld
                lda panelupdateflag
                ora #PU_SCORE
                sta panelupdateflag
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³CHECKSCROLL                                                                  ³
;³                                                                             ³
;³Checks player's position on the screen and scrolls if necessary.             ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

checkscroll:    lda actxl
                sec
                sbc sprsubxl
                sta temp1
                lda actxh
                sbc sprsubxh
                sta temp2
                lda temp1
                sec
                sbc #$c0
                sta temp1
                lda temp2
                sbc #$05
                lsr
                ror temp1
                lsr
                ror temp1
                lsr
                ror temp1
                lsr
                ror temp1
                lda temp1
                bmi cs_xneg
                cmp #8*2
                bcc cs_xok
                lda #8*2
                bne cs_xok
cs_xneg:        cmp #-8*2
                bcs cs_xok
                lda #-8*2
cs_xok:         asl
                asl
                sta scrollsx
                lda actyl
                sec
                sbc sprsubyl
                sta temp1
                lda actyh
                sbc sprsubyh
                sta temp2
                lda temp1
                sec
                sbc #$40
                sta temp1
                lda temp2
cs_ysub:        sbc #$04
                lsr
                ror temp1
                lsr
                ror temp1
                lsr
                ror temp1
                lsr
                ror temp1
                lda temp1
                bmi cs_yneg
                cmp #8*2
                bcc cs_yok
                lda #8*2
                bne cs_yok
cs_yneg:
cs_notzero:     cmp #-8*2
                bcs cs_yok
                lda #-8*2
cs_yok:         asl
                asl
                sta scrollsy
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³UPDATETIME                                                                   ³
;³                                                                             ³
;³Decreases bomb countdown.                                                    ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

updatetime:   lda detonate
              bne updt_alldone
              lda bombs                         ;When bombs have been
              bne updt_ok                       ;defused, countdown stops
updt_alldone: rts
updt_ok:      inc timefr
              ldy #":"
              ldx timefr
              cpx #12
              bcc updt_signok
              ldy #" "
updt_signok:  cpy panelstring+19
              beq updt_samesign
              sty panelstring+19
              lda panelupdateflag
              ora #PU_TIME
              sta panelupdateflag
updt_samesign:cpx #25
              bcc updt_alldone
              lda #$00
              sta timefr
              sed
              lda time
              sec
              sbc #$01
              sta time
              bcs updt_alldone2
              lda #$59
              sta time
              lda time+1
              sbc #$00
              sta time+1
              bcs updt_alldone2
              lda #$00
              sta time
              sta time+1
              jsr detonatebombs
updt_alldone2:cld
              lda panelupdateflag
              ora #PU_TIME
              sta panelupdateflag
              rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³UPDATEPANEL                                                                  ³
;³                                                                             ³
;³Updates scorepanel display.                                                  ³
;³                                                                             ³
;³Parameters: panelupdateflag - Bitfield of things to update                   ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

updatepanel:    lda instrviewtime
                beq updp_ninstr
                dec instrviewtime
                bne updp_ninstr
                lda panelupdateflag
                ora #PU_WEAPON
                sta panelupdateflag
updp_ninstr:    lda panelupdateflag
                bne updp_ok
                rts
updp_ok:        lsr panelupdateflag
                bcc updp_skipscore
                lda score+2
                jsr convert2
                stx panelstring
                sty panelstring+1
                lda score+1
                jsr convert2
                stx panelstring+2
                sty panelstring+3
                lda score
                jsr convert2
                stx panelstring+4
                sty panelstring+5
updp_skipscore: lsr panelupdateflag
                bcc updp_skiphealth
                lda acthphi
                jsr convert1
                sty panelstring+8
                lda acthplo
                jsr convert2
                stx panelstring+9
                sty panelstring+10
updp_skiphealth:lsr panelupdateflag
                bcc updp_skipterrorists
                lda terrorists+1
                jsr convert1
                sty panelstring+13
                lda terrorists
                jsr convert2
                stx panelstring+14
                sty panelstring+15
updp_skipterrorists:
                lsr panelupdateflag
                bcc updp_skiptime
                lda time+1
                jsr convert2
                stx panelstring+17
                sty panelstring+18
                lda time
                jsr convert2
                stx panelstring+20
                sty panelstring+21
updp_skiptime:  lsr panelupdateflag
                bcc updp_skipbombs
                lda bombs
                jsr convert1
                sty panelstring+24
updp_skipbombs: lsr panelupdateflag
                bcc updp_skipcomputers
                lda computers+1
                jsr convert1
                sty panelstring+27
                lda computers
                jsr convert2
                stx panelstring+28
                sty panelstring+29
updp_skipcomputers:
                lsr panelupdateflag
                bcs updp_weapon2
                jmp updp_skipweapon
updp_weapon2:   lda instrviewtime
                beq updp_weapon
updp_instrview: lda instrview
                asl
                asl
                tax
                ldy #$00
updp_iv1:       lda closetname,x
                sta panelstring+31,y
                inx
                iny
                cpy #$04
                bcc updp_iv1
                lda #" "
                sta panelstring+31,y
                lda instrview
                tax
                ldy bombstat,x
                cpy #BOMB_ACTIVE
                bne updp_defused
                asl
                adc instrview
                tax
                lda #"-"
                ldy haveinstr,x
                beq updp_ni1
                ldy wirecolor,x
                lda wirelettertbl-1,y
updp_ni1:       sta panelstring+36
                inx
                lda #"-"
                ldy haveinstr,x
                beq updp_ni2
                ldy wirecolor,x
                lda wirelettertbl-1,y
updp_ni2:       sta panelstring+37
                inx
                lda #"-"
                ldy haveinstr,x
                beq updp_ni3
                ldy wirecolor,x
                lda wirelettertbl-1,y
updp_ni3:       sta panelstring+38
                jmp updp_skipweapon
updp_defused:   lda #"O"
                sta panelstring+36
                lda #"K"
                sta panelstring+37
                lda #" "
                sta panelstring+38
                jmp updp_skipweapon
updp_weapon:    ldy weapon
                ldx weaponchartbl,y
                stx panelstring+31
                inx
                stx panelstring+32
                inx
                stx panelstring+33
                inx
                stx panelstring+34
                inx
                stx panelstring+35
                lda ammohi,y
                and #$0f
                ora #$30
                sta panelstring+36
                lda ammolo,y
                jsr convert2
                stx panelstring+37
                sty panelstring+38
updp_skipweapon:lda #$00
                sta panelupdateflag
                lda #<panelstring
                sta temp1
                lda #>panelstring
                sta temp2
                ldx #0
                ldy #22
                jmp printtext

convert2:       pha
                lsr
                lsr
                lsr
                lsr
                ora #$30
                tax
                pla
convert1:       and #$0f
                ora #$30
                tay
                rts

