RASTER_GSCREEN  = 0                             ;Raster interrupt numbers
RASTER_PANEL    = 1
RASTER_SPRITE   = 2

RASTER_GSCREEN_POS = 16                         ;Positions for the raster
RASTER_PANEL_POS = 221                          ;interrupts
RASTER_PANEL2_POS = 231                         ;interrupts

TEXT_D018       = $de                           ;$d018 value for scorepanel

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³INITRASTER                                                                   ³
;³                                                                             ³
;³Initializes cycling of raster interrupts and switches KERNAL off.            ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

initraster:     sei
                lda #$35                        ;Set all ROM off, IO on.
                sta $01
                lda #<raster_idle               ;Set an idle-IRQ which will
                sta $0314                       ;be used when KERNAL is on
                lda #>raster_idle
                sta $0315
                lda #<nmi                       ;Set NMI, both the hardware
                sta $0318                       ;vector and the vector used by
                sta $fffa                       ;KERNAL
                lda #>nmi
                sta $0319
                sta $fffb
                lda #<raster_gscreen            ;Set vector & raster position
                sta $fffe                       ;for next IRQ
                lda #>raster_gscreen
                sta $ffff
                lda #RASTER_GSCREEN_POS
                sta $d012
                lda $d011
                and #$7f                        ;Set high bit of raster
                sta $d011                       ;position (0)
                lda #$7f                        ;Set timer interrupt off
                sta $dc0d
                lda #$01                        ;Set raster interrupt on
                sta $d01a
                lda $dc0d                       ;Acknowledge timer interrupt
                cli
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³RASTER_IDLE                                                                  ³
;³                                                                             ³
;³Raster interrupt routine to be called when KERNAL is switched on. Does       ³
;³nothing except acknowledges raster interrupts.                               ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: -                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

raster_idle:  dec $d019
              jmp $ea81

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³RASTER_GSCREEN                                                               ³
;³                                                                             ³
;³Gamescreen raster interrupt.                                                 ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: -                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

raster_gscreen: cld
                sta savea
                stx savex
                sty savey
rgscr_scrx:     lda #$17                        ;Set gamescreen scrolling
                sta $d016
rgscr_scry:     lda #$07
                sta $d011
                ora #$07
                sta rpanel_sety+1
                ldy screen
                lda d018tbl,y                   ;Correct screendata ptr
                sta $d018
bgcolor2:       lda #$00
                sta $d022
bgcolor3:       lda #$00
                sta $d023

rgscr_nonewspr: lda #$00
                sta $d015
                bne rgscr_notzerospr            ;Are there sprites to be
                                                ;displayed?
rgscr_gotopanel:lda #<raster_panel              ;Set vector & raster position
                sta $fffe                       ;for next IRQ
                lda #>raster_panel
                sta $ffff
                lda #RASTER_PANEL_POS
                sta $d012
                lda savea
                ldx savex
                ldy savey
                dec $d019                       ;Acknowledge IRQ
nmi:            rti
rgscr_notzerospr:
                lda frameptrtbl,y               ;Frames must go to the
                sta rspr_loadf+2                ;correct screen
                lda #<raster_sprite             ;Jump to "plan" the next
                sta $fffe                       ;sprite IRQ
                lda #>raster_sprite
                sta $ffff
                ldy irqsprstart                 ;Init sprite counter
                jmp rspr_firstirq

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³RASTER_PANEL                                                                 ³
;³                                                                             ³
;³Scorepanel raster interrupt. Increases also rastercount and plays music/sfx. ³
;³plays music/sfx.                                                             ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: rastercount                                                        ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

raster_panel:   sta savea
                lda $d011                       ;Are we going to hit a bad
                cmp #$15                        ;line when setting the
                beq rpanel_badline              ;new $d011 & $d018 values?
rpanel_sety:    lda #$17
                sta $d011
                pha                             ;No, delay
                pla
                pha
                pla
                nop
                nop
                nop
                nop
                nop
rpanel_badline: lda #$57
                sta $d011
                lda #TEXT_D018                  ;Set textscreen screen ptr.
                sta $d018                       ;and charset
                cld
                stx savex
                sty savey
rpanel_direct:  lda #191                        ;Set empty spriteframes
                sta textscreen+1016
                sta textscreen+1017
                sta textscreen+1018
                sta textscreen+1019
                sta textscreen+1020
                sta textscreen+1021
                sta textscreen+1022
                sta textscreen+1023
                ldx #$00                        ;Set background color
                stx $d015                       ;Sprites off
                lda #PANELMC1
                sta $d022
                lda #PANELMC2                   ;Set multicolors
                sta $d023
                lda #$ff
                sta $d001                       ;Set all sprites to bottom
                sta $d003                       ;of the screen
                sta $d005
                sta $d007
                sta $d009
                sta $d00b
                sta $d00d
                sta $d00f
                lda #$1a
                sta $d016                       ;Set X scrolling
                inc rastercount
                lda frameupdateflag             ;New frame to display?
                beq rpanel_nonewframe
                stx frameupdateflag
                lda scrollx                     ;Put new finescrollvalues into
                lsr
                lsr
                lsr
                ora #$10                        ;use
                sta rgscr_scrx+1
                lda scrolly
                lsr
                lsr
                lsr
                ora #$10
                sta rgscr_scry+1
                lda sortsprstart
                sta irqsprstart
                ldy sortsprend
                lda #MAXSPR*2+1                 ;Make an endmark
                sta sprorder,y
                lda #$ff
                cpy sortsprstart                ;Any sprites?
                bne rpanel_notzerospr
                lda #$00
rpanel_notzerospr:
                sta rgscr_nonewspr+1
rpanel_nonewframe:
                lda #<raster_panel2             ;Set vector & raster position
                sta $fffe                       ;for next IRQ
                lda #>raster_panel2
                sta $ffff
                lda #RASTER_PANEL2_POS
                sta $d012
                lda savea
                ldx savex
                ldy savey
                dec $d019
                rti

raster_panel2:  cld
                sta savea
                stx savex
                sty savey
                lda #$17
                sta $d011                       ;Screen visible
                jsr music+3                     ;Play music/sound FX
                lda #<raster_gscreen            ;Set vector & raster position
                sta $fffe                       ;for next IRQ
                lda #>raster_gscreen
                sta $ffff
                lda #RASTER_GSCREEN_POS
                sta $d012
                lda savea
                ldx savex
                ldy savey
                dec $d019
                rti

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³RASTER_SPRITE                                                                ³
;³                                                                             ³
;³Sprite multiplexer                                                           ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: -                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

raster_sprite:  cld
                sta savea
                stx savex
                sty savey
rspr_direct:    ldy irqsprcount

rspr_load:      ldx sprorder,y
                lda spry,x
                cmp irqsprcmp
                bcs rspr_loaddone
                sty rspr_resty+1
                ldy sprphys2,x
                bmi rspr_loadskip
                lda spry,x
                sta $d001,y
                lda sprxl,x
                sta $d000,y
                lda sprxh,x
                sta $d010
                ldy sprphys,x
                lda sprf,x
rspr_loadf:     sta screen1+$3f8,y
                lda sprc,x
                sta $d027,y
rspr_loadskip:
rspr_resty:     ldy #$00
                iny
                bpl rspr_load

rspr_loaddone:  cmp #$ff                        ;Endmark?
                beq rspr_alldone
rspr_firstirq:  sty irqsprcount
                ldx sprorder,y
                lda spry,x
                adc #SPRIRQBELOW                ;Carry = 0
                sta irqsprcmp
                sbc #SPRIRQBELOW+SPRIRQABOVE-1  ;Carry = 0, subtract one less
                sta $d012
                sbc #$03                        ;Carry = 1
                cmp $d012                       ;Late from next sprite-IRQ?
                bcc rspr_direct
                lda savea
                ldx savex
                ldy savey
                dec $d019                       ;Acknowledge IRQ
                rti
rspr_alldone:   lda #<raster_panel              ;Set vector & raster position
                sta $fffe                       ;for next IRQ
                lda #>raster_panel
                sta $ffff
                lda #RASTER_PANEL_POS
                sta $d012
                sbc #$03                        ;Carry = 1
                cmp $d012                       ;Late from the scorepanel IRQ?
                bcc rspr_latepanel
                lda savea
                ldx savex
                ldy savey
                dec $d019                       ;Acknowledge IRQ
                rti
rspr_latepanel: lda $d012                       ;Wait until we're actually
                cmp #RASTER_PANEL_POS           ;there
                bcc rspr_latepanel
                lda #$5f
                sta $d011
                lda #TEXT_D018                  ;Set textscreen screen ptr.
                sta $d018                       ;and charset
                jmp rpanel_direct

frameptrtbl:    dc.b >(screen1+$3f8)
                dc.b >(screen2+$3f8)

