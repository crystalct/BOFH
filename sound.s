MUSIC_INGAME    = 0
MUSIC_HISCORE   = 1
MUSIC_VICTORY   = 2
MUSIC_STOP      = 3

SFX_PISTOL      = 0
SFX_FIST        = 1
SFX_WHIP        = 2
SFX_BND         = 3
SFX_SHOTGUN     = 4
SFX_UZI         = 5
SFX_FLAME       = 6
SFX_CROSSBOW    = 7
SFX_EXPLOSION   = 8
SFX_THROW       = 9
SFX_HIT         = 10
SFX_DEATH       = 11
SFX_COLLECT     = 12
SFX_SELECT      = 13
SFX_CUTWIRE     = 14
SFX_BOFHHIT     = 15

playsfx:        stx psfx_restx+1
                sty psfx_resty+1
                asl
                tay
                lda sfxtbl,y
                ldx sfxtbl+1,y
                ldy musicmode
                beq psfx_allchans
                ldy #$01
psfx_common:    jsr music+9
psfx_restx:     ldx #$00
psfx_resty:     ldy #$00
                rts
psfx_allchans:  ldy nextsndchn
                iny
                cpy #$03
                bcc psfx_chanok
                ldy #$00
psfx_chanok:    sty nextsndchn
                jmp psfx_common



togglemusic:    lda keytype
                cmp #KEY_M
                bne tm_not
                lda musicmode
                eor #$01
                sta musicmode
                beq tm_off
tm_on:          lda tunenum
                jmp playtune_ok
tm_off:         lda #$03
                sta prevtune
                jmp music
tm_not:         rts

playtune:       sta tunenum
                lda musicmode
                beq tm_off
                lda tunenum
                cmp prevtune
                beq playtune_skip
playtune_ok:    sta prevtune
                jmp music
playtune_skip:  rts

playtune2:      cmp prevtune
                beq playtune_skip
                sta tunenum
                sta prevtune
                jmp music
