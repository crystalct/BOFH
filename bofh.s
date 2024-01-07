HAVEALLINSTRUCTIONS = 0
ALLTECHNICIANS = 0
INFINITEHEALTH = 0
SEEENDFIRST = 0
SHOWACTORS = 0
SHOWCOMPREMOVE = 0
CHECKINSIDESPAWN = 0
SHOWBORED = 0

TITLESCREEN_MAX = 9
TITLESCREEN_DELAY = 15
HSCNAMELENGTH = 12

                processor 6502
                org $0800

                include define.s
                incbin bofhmus.raw

                org start

                jsr initsprites
                jsr initraster
                jsr initvideo
                jsr initmap
                jsr initscroll
                jsr hidescreen
                jsr loadhiscore
                if SEEENDFIRST>0
                jsr initgame
                jmp victory
                endif

title:          lda #MUSIC_INGAME
                jsr playtune2
                jsr hidescreen
                jsr initfireeff
title_nofireinit:
                lda #$00
                sta titlescreen
title_nofireinit2:
                lda #$ff
                sta panelupdateflag
                jsr updatepanel
titleloop_new:  lda #$00
                sta rastercount
                sta titledelay
                jsr cleartextscreen
                jsr showtextscreen
                lda titlescreen
                asl
                tax
                lda titletxttbl,x
                sta temp1
                lda titletxttbl+1,x
                sta temp2
                bne nohiscore
                lda #$00
                sta hiscorerow
                sta hiscoreindex
title_hiscores: jsr printhiscorerow
                lda hiscoreindex
                clc
                adc #$10
                sta hiscoreindex
                ldy hiscorerow
                iny
                iny
                sty hiscorerow
                cpy #20
                bne title_hiscores
                jmp titleloop_nonew
nohiscore:
titleloop_print:jsr printtextscreen
titleloop_nonew:jsr getfireclick
                bcs diffsel
                jsr fireblit
                jsr fireeff
                lda rastercount
                cmp #50
                bcc titleloop_nonew
                sec
                sbc #50
                sta rastercount
                inc titledelay
                lda titlescreen
                bne titleloop_normaldelay
                lda titledelay
                cmp #TITLESCREEN_DELAY/2
                bcc titleloop_nonew
                bcs titleloop_gotonew
titleloop_normaldelay:
                lda titledelay
                cmp #TITLESCREEN_DELAY
                bcc titleloop_nonew
titleloop_gotonew:
                ldy titlescreen
                iny
                cpy #TITLESCREEN_MAX
                bcc titlenotover
                ldy #$00
titlenotover:   sty titlescreen
                jmp titleloop_new

diffsel:        jsr cleartextscreen
                ldy #8
                lda #<difftext
                sta temp1
                lda #>difftext
                sta temp2
                jsr printtextc
diffselloop:    ldy #10
                lda difficulty
                asl
                tax
                lda difftexttbl,x
                sta temp1
                lda difftexttbl+1,x
                sta temp2
                jsr printtextc
diffsel_wait:   lda #2
                jsr rasterdelay
                jsr getfireclick
                bcs newgame
                lda prevjoy
                bne diffsel_notdown
                lda joystick
                and #JOY_DOWN+JOY_LEFT
                beq diffsel_notup
                dec difficulty
                bpl diffselloop
                lda #DI_INSANE
                sta difficulty
                bne diffselloop
diffsel_notup:  lda joystick
                and #JOY_UP+JOY_RIGHT
                beq diffsel_notdown
                inc difficulty
                lda difficulty
                cmp #DI_INSANE+1
                bcc diffselloop
                lda #DI_PRACTICE
                sta difficulty
                beq diffselloop
diffsel_notdown:jmp diffsel_wait



newgame:        lda #MUSIC_INGAME
                jsr playtune
                jsr initgame
                ldx #36
                ldy #44
                jsr setmappos
                jsr drawscreen
loopbegin:      lda #$00
                sta rastercount
loop:           jsr getcontrols
                jsr togglemusic
                jsr scrolllogic
                jsr changeweapon
                jsr addactors
                jsr removefaractors
                jsr defuse
                jsr moveactors
                jsr updatetime
                jsr updatepanel
                jsr checkscroll
                jsr scrollscreen
                jsr drawactors
                jsr sortsprites
                jsr closetflash
                jsr scrollcolors
                lda keytype
                cmp #KEY_RUNSTOP
                bne nopause
                jmp pause
nopause:        lda difficulty
                beq novictory
                lda bombs                       ;All bombs defused?
                bne novictory
                lda leaders                     ;All leaders dead?
                bne novictory
                lda floor                       ;BOFH in the server room?
                bne novictory
                lda actxh+ACTI_BOFH
                cmp #30
                bcc novictory
                cmp #34
                bcs novictory
                lda actyh+ACTI_BOFH
                cmp #49
                bcc novictory
                cmp #52
                bcs novictory
                inc victorycount
                lda victorycount
                cmp #25
                bcc novictory
                lda actt+ACTI_BOFH              ;Still alive?
                cmp #ACT_BOFH
                beq victory
novictory:      lda actt+ACTI_BOFH
                bne loop
                beq gameover

pause:          ldx #$05
pauseloop1:     lda pausetext,x
                sta panelstring,x
                dex
                bpl pauseloop1
                jsr updp_skipweapon
pauseloop2:     jsr getcontrols
                lda keytype
                cmp #KEY_Q
                beq gameover
                cmp #KEY_RUNSTOP
                bne pauseloop2
                lda #$ff
                sta panelupdateflag
                jmp nopause

gameover:       lda #$ff
                sta panelupdateflag
                jsr updatepanel
                jsr hidescreen
                jsr initfireeff
                jmp enterhiscore

victory:        jsr removeallactors
healthbonus:    lda acthplo+ACTI_BOFH
                ora acthphi+ACTI_BOFH
                beq hb_done
                sed
                lda acthplo+ACTI_BOFH
                sec
                sbc #$01
                sta acthplo+ACTI_BOFH
                lda acthphi+ACTI_BOFH
                sbc #$00
                sta acthphi+ACTI_BOFH
                cld
                lda #$00
                sta alo
                lda #$01
                sta ahi
                jsr addscore
                lda #SFX_SELECT
                jsr playsfx
                lda #$ff
                sta panelupdateflag
                lda #4
                jsr rasterdelay
                jsr getcontrols
                jsr updatepanel
                jmp healthbonus
hb_done:        lda #50
                jsr rasterdelay

timebonus:      lda #$00
                sta time
                lda time+1
                beq tb_done
                sed
                lda time+1
                sec
                sbc #$01
                sta time+1
                cld
                lda #$00
                sta alo
                lda #$02
                sta ahi
                jsr addscore
                lda #SFX_SELECT
                jsr playsfx
                lda #$ff
                sta panelupdateflag
                lda #4
                jsr rasterdelay
                jsr getcontrols
                jsr updatepanel
                jmp timebonus

tb_done:        lda #50
                jsr rasterdelay
                lda #<lvlact0
                sta lvlactcurr
                lda #>lvlact0
                sta lvlactcurr+1
serverbonus:    ldy #LVLACT_T
                lda (lvlactcurr),y
                cmp #ACT_PCSERVER
                bcc sb_skip
                cmp #ACT_CDTOWER+1
                bcs sb_skip
                jsr deccomputers
                lda #$00
                sta alo
                lda #$50
                sta ahi
                jsr addscore
                lda #SFX_SELECT
                jsr playsfx
                lda #$ff
                sta panelupdateflag
                lda #12
                jsr rasterdelay
                jsr getcontrols
                jsr updatepanel
sb_skip:        lda lvlactcurr
                clc
                adc #$05
                sta lvlactcurr
                lda lvlactcurr+1
                adc #$00
                sta lvlactcurr+1
                lda lvlactcurr
                cmp #<lvlact1
                bne serverbonus
                lda lvlactcurr+1
                cmp #>lvlact1
                bne serverbonus

sb_done:        lda #50
                jsr rasterdelay

wkstbonus:      lda computers
                ora computers+1
                beq wkstb_done
                jsr deccomputers
                lda #$50
                sta alo
                lda #$00
                sta ahi
                jsr addscore
                lda computers
                ora computers+1
                beq wkstb_nosecond
                jsr deccomputers
                lda #$50
                sta alo
                lda #$00
                sta ahi
                jsr addscore
wkstb_nosecond: lda #SFX_SELECT
                jsr playsfx
                lda #$ff
                sta panelupdateflag
                lda #4
                jsr rasterdelay
                jsr getcontrols
                jsr updatepanel
                jmp wkstbonus
wkstb_done:     lda #50
                jsr rasterdelay
                jsr hidescreen
                jsr initfireeff
                lda #MUSIC_VICTORY
                jsr playtune2
                lda #<victorytext
                sta temp1
                lda #>victorytext
                sta temp2
                jsr cleartextscreen
                jsr printtextscreen
                jsr showtextscreen
victoryloop:    jsr getfireclick
                bcs exitvictoryloop
                jsr fireblit
                jsr fireeff
                jmp victoryloop
exitvictoryloop:jmp enterhiscore

rasterdelay:    sta rd_cmp+1
                lda #$00
                sta rastercount
rd_loop:        lda rastercount
rd_cmp:         cmp #$00
                bcc rd_loop
                rts

printtextscreen:ldy #$00
pts_loop:       jsr printtextc
                sty temp3
                ldy #$00
                lda (temp1),y
                beq pts_end
                ldy temp3
                iny
                iny
                jmp pts_loop
pts_end:        rts

showtextscreen: lda #$09
                sta bgcolor2+1
                lda #$0a
                sta bgcolor3+1
                lda #2
                sta screen
                lda #$18
                sta rgscr_scrx+1
                lda #$17
                sta rgscr_scry+1
                rts

initfireeff:    ldx #$00
ife_loop:       lda #$00
                sta screen1,x
                sta screen1+256,x
                sta screen1+512,x
                lda #$0f
                sta colors,x
                sta colors+256,x
                sta colors+512,x
                lda #$00
                sta screen1+768,x
                cpx #72
                bcs ife_skip
                lda #$0f
                sta colors+768,x
ife_skip:       inx
                bne ife_loop
                rts

fireeff:        lda #<screen1
                sta temp1
                lda #>screen1
                sta temp2
                jmp fireeff_loop
fireeff_next:   inc temp1
                bne fireeff_loop
                inc temp2
fireeff_loop:   ldy #40
                lda (temp1),y
                ldy #41
                clc
                adc (temp1),y
                ldy #80
                adc (temp1),y
                ldy #81
                adc (temp1),y
                lsr
                lsr
                sec
                sbc #$02
                bcs fireeff_ok
                lda #$00
fireeff_ok:     ldy #0
                sta (temp1),y
                lda temp1
                cmp #<(screen1+20*40+39)
                bne fireeff_next
                lda temp2
                cmp #>(screen1+20*40+39)
                bne fireeff_next
                ldx #80
fireeff_random: jsr random
                and #$3f
                clc
                adc #$08
                cmp #$40
                bcc fireeff_randomok
                lda #$3f
fireeff_randomok:
                sta screen1+21*40,x
                dex
                bpl fireeff_random
                rts

fireblit:       ldx #$00
fireblit_loop:  lda textscreen,x
                cmp #33
                bcs fireblit_skip1
                lda screen1,x
                lsr
                lsr
                sta textscreen,x
fireblit_skip1: lda textscreen+256,x
                cmp #33
                bcs fireblit_skip2
                lda screen1+256,x
                lsr
                lsr
                sta textscreen+256,x
fireblit_skip2: lda textscreen+512,x
                cmp #33
                bcs fireblit_skip3
                lda screen1+512,x
                lsr
                lsr
                sta textscreen+512,x
fireblit_skip3: cpx #72
                bcs fireblit_skip4
                lda textscreen+768,x
                cmp #33
                bcs fireblit_skip4
                lda screen1+768,x
                lsr
                lsr
                sta textscreen+768,x
fireblit_skip4: inx
                bne fireblit_loop
                rts

cleartextscreen:
                ldx #$00
cts_loop:       lda #$20
                sta textscreen,x
                sta textscreen+256,x
                sta textscreen+512,x
                cpx #72
                bcs cts_skip
                sta textscreen+768,x
cts_skip:       inx
                bne cts_loop
                rts

enterhiscore:   lda #$00
                sta hiscoreindex
                lda #12
                sta hiscorerow
ehsc_checkloop: ldx #$02
                ldy hiscoreindex
                iny
                iny
ehsc_checkloop2:lda score,x                     ;Compare two digits at a time
                cmp hiscores+HSCNAMELENGTH,y
                bcc ehsc_chklow
                bne ehsc_found
                dey
                dex
                bpl ehsc_checkloop2
ehsc_chklow:    lda hiscoreindex
                clc
                adc #$10
                sta hiscoreindex
                cmp #160
                bcc ehsc_checkloop
                lda #MUSIC_INGAME
                jsr playtune2                   ;No hiscore
                jmp title_nofireinit
ehsc_found:     ldy #144                        ;Shift other hiscores downwards
                bne ehsc_shiftcmp
ehsc_shiftloop: lda hiscores,y
                sta hiscores+16,y
ehsc_shiftcmp:  cpy hiscoreindex
                beq ehsc_shiftdone
                dey
                jmp ehsc_shiftloop
ehsc_shiftdone: ldx #$00
                stx hiscorecursor
ehsc_clearname: lda #" "                        ;Clear player's name & store
                cpx #HSCNAMELENGTH              ;player's score
                bcc ehsc_clearname2
                lda score-HSCNAMELENGTH,x
ehsc_clearname2:sta hiscores,y                  ;Clear player's name
                iny
                inx
                cpx #$10
                bcc ehsc_clearname
                lda #MUSIC_HISCORE
                jsr playtune2
                jsr cleartextscreen
                jsr showtextscreen
                lda #<hiscoretext
                sta temp1
                lda #>hiscoretext
                sta temp2
                ldy #6
                jsr printtextc
                iny
                iny
                jsr printtextc
ehsc_loop2:     jsr printhiscorerow
ehsc_loop:      jsr getcontrols
                ldx keytype
                bmi ehsc_loop
                lda asciitbl,x
                beq ehsc_loop
                cmp #13
                beq ehsc_done
                bmi ehsc_delete
ehsc_write:     tay
                lda hiscorecursor
                cmp #HSCNAMELENGTH
                bcs ehsc_loop
                inc hiscorecursor
                sec
ehsc_writecommon:
                adc hiscoreindex
                tax
                tya
                sta hiscores-1,x
                jmp ehsc_loop2
ehsc_delete:    lda hiscorecursor
                beq ehsc_loop
                dec hiscorecursor
                clc
                ldy #" "
                bne ehsc_writecommon
ehsc_done:      jsr savehiscore
                lda #$02
                sta titlescreen
                jmp title_nofireinit2

printhiscorerow:lda hiscoreindex
                lsr
                lsr
                lsr
                tax
                lda hiscoreorder,x
                sta hiscorestring
                lda hiscoreorder+1,x
                sta hiscorestring+1
                ldy #$00
                ldx hiscoreindex
phsr_name:      lda hiscores,x
                sta hiscorestring+3,y
                inx
                iny
                cpy #HSCNAMELENGTH
                bcc phsr_name
                ldx hiscoreindex
                lda hiscores+HSCNAMELENGTH,x
                jsr convert2
                stx hiscorestring+20
                sty hiscorestring+21
                ldx hiscoreindex
                lda hiscores+HSCNAMELENGTH+1,x
                jsr convert2
                stx hiscorestring+18
                sty hiscorestring+19
                ldx hiscoreindex
                lda hiscores+HSCNAMELENGTH+2,x
                jsr convert2
                stx hiscorestring+16
                sty hiscorestring+17
                ldy hiscorerow
                lda #<hiscorestring
                sta temp1
                lda #>hiscorestring
                sta temp2
                jmp printtextc

loadhiscore:    jsr loadprepare
                jsr loadsetlfs
                jsr loadsetnam
                lda #$00
                ldx #<hiscores
                ldy #>hiscores
                jsr load
                lda #$35
                sta $01
                rts

savehiscore:    jsr loadprepare
                lda #$0f
                ldy #$0f
                jsr loadsetlfs2
                lda #15
                ldx #<scratch
                ldy #>scratch
                jsr setnam
                jsr open
                lda #$0f
                jsr close
                jsr loadsetlfs
                jsr loadsetnam
                lda #<hiscores
                sta temp1
                lda #>hiscores
                sta temp2
                ldx #<(hiscores+160)
                ldy #>(hiscores+160)
                lda #temp1
                jsr save
                lda #$35
                sta $01
                rts

loadprepare:    lda #$36
                sta $01
                lda #$57
                sta $d011
                lda #$00
                sta $d015
                sta $d404
                sta $d404+7
                sta $d404+14
                sta $9d                         ;Disable KERNAL messages
                rts

loadsetlfs:     lda #$ff
                ldy #$00
loadsetlfs2:    ldx $ba
                bne ldevnotzero
                ldx #$08
ldevnotzero:    jmp setlfs

loadsetnam:     lda #12
                ldx #<hiscorename
                ldy #>hiscorename
                jmp setnam

                include raster.s
                include screen.s
                include sprite.s
                include sound.s
                include actor.s
                include control.s
                include math.s
                include player.s
                include enemy.s
                include weapon.s
                include level.s
                include data.s

