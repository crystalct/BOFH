MAXSPR          = 31                            ;Maximum amount of sprites
MINSPRY         = 34
MAXSPRY         = 219
SPRROWS         = 12

FR              = 32

SPRIRQABOVE     = 11
SPRIRQBELOW     = 4
SPRDISTANCE     = 20+SPRIRQABOVE-1

PRI_LOW         = $ff
PRI_MED         = $00
PRI_HIGH        = $01

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³INITSPRITES                                                                  ³
;³                                                                             ³
;³Initializes the sprite double-buffering. To be called before firing up       ³
;³raster interrupts.                                                           ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

initsprites:    sei
                lda #$00
                sta rgscr_nonewspr+1
                sta irqsprstart
                sta sortsprstart
                sta sortsprend
                sta frameupdateflag
                lda #$ff
                sta spry+MAXSPR*2+1
                cli
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³SORTSPRITES                                                                  ³
;³                                                                             ³
;³Sorts the sprites for the sprite-multiplexer.                                ³
;³                                                                             ³
;³Parameters: sortsprstart, sortsprend                                         ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y,temp1-temp6,zeropage tables reserved for sorting             ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

sortsprites:    lda #$00
N               set 0
                repeat 16
                sta rmod16amount+N
N               set N+1
                repend
                lda sortsprend
                cmp sortsprstart
                bne sspr_notzero
                rts
sspr_notzero:   sta sspr_loop1cmp+1
                sta sspr_loop2cmp+1
                sta sspr_loop4cmp+1
                ldy sortsprstart
sspr_loop1:     lda spry,y
                and #$0f
                sta sprymod16,y
                tax
                inc rmod16amount,x
                iny
sspr_loop1cmp:  cpy #$00
                bcc sspr_loop1
                lda #$00
                clc
N               set 0
                repeat 16
                sta rmod16index+N
                adc rmod16amount+N
N               set N+1
                repend
                sta sspr_loop3cmp+1
                lda #$00
N               set 0
                repeat SPRROWS
                sta rdiv16amount+N
N               set N+1
                repend
                ldy sortsprstart
sspr_loop2:     ldx spry,y
                lda sprydiv16tbl-$20,x
                sta sspr_storediv16+1
                tax
                inc rdiv16amount,x
                ldx sprymod16,y                 ;Intermediate sorting phase:
                lda rmod16index,x               ;sort by Y mod 16
                inc rmod16index,x
                tax
                sty sprorderim,x
sspr_storediv16:lda #$00
                sta sprydiv16,x
sspr_skip2:     iny
sspr_loop2cmp:  cpy #$00
                bcc sspr_loop2
                lda sortsprstart
                clc
N               set 0
                repeat SPRROWS
                sta rdiv16index+N
                adc rdiv16amount+N
N               set N+1
                repend
                ldy #$00
sspr_loop3:     ldx sprydiv16,y                 ;Final sorting phase:
                lda rdiv16index,x               ;Sort by Y div 16
                inc rdiv16index,x
                tax
                lda sprorderim,y
                sta sprorder,x
                iny
sspr_loop3cmp:  cpy #$00
                bcc sspr_loop3
                lda #$00
                sta oldspry
                sta oldspry+1
                sta oldspry+2
                sta oldspry+3
                sta oldspry+4
                sta oldspry+5
                sta oldspry+6
                sta oldspry+7
                ldy sortsprstart
                sty temp5
sspr_loop4:     ldx sprorder,y                  ;Final loop: find suitable
                lda spry,x                      ;physical spritenumbers
                sec                             ;(according to priorities)
                sbc #SPRDISTANCE                ;and precalculate $d010 values
                sta temp1
                lda sprpri,x
                bne sspr_notmedpri
                jmp sspr_primed
sspr_notmedpri: bpl sspr_prihigh

sspr_prilow:    lda oldspry+7
                cmp temp1
                bcc sspr_prifound7
                lda oldspry+6
                cmp temp1
                bcc sspr_prifound6
                lda oldspry+5
                cmp temp1
                bcc sspr_prifound5
                lda oldspry+4
                cmp temp1
                bcc sspr_prifound4
                lda oldspry+3
                cmp temp1
                bcc sspr_prifound3
                lda oldspry+2
                cmp temp1
                bcc sspr_prifound2
                lda oldspry+1
                cmp temp1
                bcc sspr_prifound1
                lda oldspry+0
                cmp temp1
                bcc sspr_prifound0
                bcs sspr_prinotfound

sspr_prihigh:   lda oldspry
                cmp temp1
                bcc sspr_prifound0
                lda oldspry+1
                cmp temp1
                bcc sspr_prifound1
                lda oldspry+2
                cmp temp1
                bcc sspr_prifound2
                lda oldspry+3
                cmp temp1
                bcc sspr_prifound3
                lda oldspry+4
                cmp temp1
                bcc sspr_prifound4
                lda oldspry+5
                cmp temp1
                bcc sspr_prifound5
                lda oldspry+6
                cmp temp1
                bcc sspr_prifound6
                lda oldspry+7
                cmp temp1
                bcc sspr_prifound7
                bcs sspr_prinotfound
sspr_prifound0: lda #$00
                bpl sspr_prifound
sspr_prifound1: lda #$01
                bpl sspr_prifound
sspr_prifound2: lda #$02
                bpl sspr_prifound
sspr_prifound3: lda #$03
                bpl sspr_prifound
sspr_prifound4: lda #$04
                bpl sspr_prifound
sspr_prifound5: lda #$05
                bpl sspr_prifound
sspr_prifound6: lda #$06
                bpl sspr_prifound
sspr_prifound7: lda #$07
                bpl sspr_prifound
sspr_prinotfound:
                lda #$80
                sta sprphys2,x
                jmp sspr_loop4skip

sspr_primed:    lda oldspry+4
                cmp temp1
                bcc sspr_prifound4
                lda oldspry+3
                cmp temp1
                bcc sspr_prifound3
                lda oldspry+5
                cmp temp1
                bcc sspr_prifound5
                lda oldspry+2
                cmp temp1
                bcc sspr_prifound2
                lda oldspry+6
                cmp temp1
                bcc sspr_prifound6
                lda oldspry+1
                cmp temp1
                bcc sspr_prifound1
                lda oldspry+7
                cmp temp1
                bcc sspr_prifound7
                lda oldspry+0
                cmp temp1
                bcc sspr_prifound0
                bcs sspr_prinotfound

sspr_prifound:  sta sprphys,x
                tay
                asl
                sta sprphys2,x
                lda spry,x
                sta oldspry,y
                lda sprxh,x
                beq sspr_d010zero
                lda temp6
                ora sprortbl,y
                bne sspr_d010ok
sspr_d010zero:  lda temp6
                and sprandtbl,y
sspr_d010ok:    sta temp6
                sta sprxh,x
sspr_continue:
sspr_loop4skip:
sspr_continue2: ldy temp5
                iny
sspr_loop4cmp:  cpy #$00
                bcs sspr_loop4done
                sty temp5
                jmp sspr_loop4
sspr_loop4done: rts

