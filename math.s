;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³SIGNEXPAND                                                                   ³
;³                                                                             ³
;³Takes a 8-bit signed value and creates the highbyte for it.                  ³
;³                                                                             ³
;³Parameters: A:lowbyte                                                        ³
;³Returns:    Y:highbyte                                                       ³
;³Modifies:   Y                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

signexpand:     ldy #$00
                ora #$00                        ;Test sign of A without
                bpl se_positive                 ;changing it
                dey
se_positive:    rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MULS                                                                         ³
;³                                                                             ³
;³Signed multiplication                                                        ³
;³                                                                             ³
;³Parameters: A:first value to be multiplied                                   ³
;³            Y:second value to be multiplied                                  ³
;³Returns:    alo,ahi:Result                                                   ³
;³Modifies:   A,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

muls:           sty alo
muls_eor:       eor alo
                clc
                php
muls_eor2:      eor alo
                bpl muls_notneg1
                eor #$ff
                adc #$01
muls_notneg1:   sta alo
                tya
                beq muls_zero
                bpl muls_notneg2
                eor #$ff
                sta ahi
                jmp muls_common
muls_notneg2:   dey
                sty ahi
muls_common:    lda #$00
                lsr alo
                bcc muls_shift1
                adc ahi
muls_shift1:    ror
                ror alo
                bcc muls_shift2
                adc ahi
muls_shift2:    ror
                ror alo
                bcc muls_shift3
                adc ahi
muls_shift3:    ror
                ror alo
                bcc muls_shift4
                adc ahi
muls_shift4:    ror
                ror alo
                bcc muls_shift5
                adc ahi
muls_shift5:    ror
                ror alo
                bcc muls_shift6
                adc ahi
muls_shift6:    ror
                ror alo
                bcc muls_shift7
                adc ahi
muls_shift7:    ror
                ror alo
                bcc muls_shift8
                adc ahi
muls_shift8:    ror
                ror alo
                plp
                bpl muls_ok
                eor #$ff
                tay
                lda alo
                eor #$ff
                adc #$01
                sta alo
                bcc muls_ok2
                iny
muls_ok2:       tya
muls_ok:        sta ahi
                rts
muls_zero:      plp
                sta alo
                sta ahi
                rts




;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³MULU                                                                         ³
;³                                                                             ³
;³Unsigned multiplication                                                      ³
;³                                                                             ³
;³Parameters: A:first value to be multiplied                                   ³
;³            Y:second value to be multiplied                                  ³
;³Returns:    alo,ahi:Result                                                   ³
;³            A:highbyte of result                                             ³
;³Modifies:   A,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

mulu:           sta alo
                tya
                beq mulu_zero
                dey
                sty ahi
                lda #$00
                lsr alo
                bcc mulu_shift1
                adc ahi
mulu_shift1:    ror
                ror alo
                bcc mulu_shift2
                adc ahi
mulu_shift2:    ror
                ror alo
                bcc mulu_shift3
                adc ahi
mulu_shift3:    ror
                ror alo
                bcc mulu_shift4
                adc ahi
mulu_shift4:    ror
                ror alo
                bcc mulu_shift5
                adc ahi
mulu_shift5:    ror
                ror alo
                bcc mulu_shift6
                adc ahi
mulu_shift6:    ror
                ror alo
                bcc mulu_shift7
                adc ahi
mulu_shift7:    ror
                ror alo
                bcc mulu_shift8
                adc ahi
mulu_shift8:    ror
                sta ahi
                ror alo
                rts
mulu_zero:      sta alo
                sta ahi
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ASR_ROUNDUP                                                                  ³
;³                                                                             ³
;³Aritmetic shift right of a 8-bit value, rounding upwards.                    ³
;³                                                                             ³
;³Parameters: A:value                                                          ³
;³            Y:number of shifts                                               ³
;³Returns:    A:result                                                         ³
;³Modifies:   A,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

asr_roundup:    ora #$00
                bmi asr_rupneg
asr_ruppos:     lsr
                adc #$00
                dey
                bne asr_ruppos
                rts
asr_rupneg:     lsr
                ora #$80
                dey
                bne asr_rupneg
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ASR_ROUNDDOWN                                                                ³
;³                                                                             ³
;³Aritmetic shift right of a 8-bit value, rounding downwards.                  ³
;³                                                                             ³
;³Parameters: A:value                                                          ³
;³            Y:number of shifts                                               ³
;³Returns:    A:result                                                         ³
;³Modifies:   A,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

asr_rounddown:  ora #$00
                bmi asr_rdnneg
asr_rdnpos:     lsr
                dey
                bne asr_rdnpos
                rts
asr_rdnneg:     lsr
                ora #$80
                adc #$00
                dey
                bne asr_rdnneg
                rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³RANDOM                                                                       ³
;³                                                                             ³
;³Returns a 8bit pseudorandom number.                                          ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: A:number ($00-$ff)                                                  ³
;³Modifies: A                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

randomareastart = $2000
randomareaend   = $4000


random:         inc randomadd+1
                bne randomseed
                lda randomadd+2
                cmp #>randomareaend-1
                bcc randomok
                lda #>randomareastart-2
randomok:       adc #$01
                sta randomadd+2
randomseed:     lda #$00
randomadd:      eor randomareastart
                adc #$3b
                sta randomseed+1
                rts


