
LVLACT_X      = 0
LVLACT_Y      = 1
LVLACT_F      = 2
LVLACT_T      = 3
LVLACT_H      = 4

LVLACT_ONETIME = 32

ACTORXDISTANCE  = 12
ACTORYDISTANCE  = 8

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ADDACTORS                                                                    ³
;³                                                                             ³
;³Adds actors from the leveldata.                                              ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

addallactors:     lda #0
                  sta temp1
                  lda lvlactstart
                  sta lvlactcurr
                  lda lvlactstart+1
                  sta lvlactcurr+1
                  jmp addactors_common

addactors:        if SHOWCOMPREMOVE>0
                  lda #$00
                  sta $d020
                  endif
                  lda #LVLACT_ONETIME
                  sta temp1
addactors_common: lda mapx
                  sec
                  sbc #$01
                  sta temp2
                  lda mapy
                  sec
                  sbc #$01
                  sta temp3
addact_loop:      ldy #LVLACT_T
                  lda (lvlactcurr),y
                  beq addact_next
                  ldy #LVLACT_X
                  lda (lvlactcurr),y
                  sec
                  sbc temp2
                  cmp #ACTORXDISTANCE
                  bcs addact_next
                  iny
                  lda (lvlactcurr),y
                  sec
                  sbc temp3
                  cmp #ACTORYDISTANCE
                  bcc addact_ok
addact_next:      dec temp1
                  beq addact_alldone
                  lda lvlactcurr
                  clc
                  adc #5
                  sta lvlactcurr
                  bcc addact_next2
                  inc lvlactcurr+1
addact_next2:     lda lvlactcurr
                  cmp lvlactend
                  bne addact_loop
                  lda lvlactcurr+1
                  cmp lvlactend+1
                  bne addact_loop
                  lda lvlactstart
                  sta lvlactcurr
                  lda lvlactstart+1
                  sta lvlactcurr+1
                  jmp addact_loop
addact_alldone:   rts
addact_ok:        ldy #ACTI_FIRSTCOMMON
                  lda #ACTI_LASTCOMMON
                  jsr getfreeactor
                  bcs addact_success
                  ldy #LVLACT_T                         ;OUT OF ACTORS!
                  lda (lvlactcurr),y                    ;Is the new actor
                  cmp #ACT_WORKSTATION                  ;a computer?
                  bcc addact_nocomp
                  cmp #ACT_CDTOWER+1                    ;In that case, just
                  bcs addact_nocomp                     ;move to the next
                  jmp addact_next
addact_nocomp:    ldx #ACTI_FIRSTCOMMON
addact_trytofind: lda actt,x                    ;Try to remove a computer
                  cmp #ACT_WORKSTATION
                  bcc addact_trynext
                  cmp #ACT_CDTOWER+1
                  bcc addact_removecomp
addact_trynext:   inx
                  cpx #ACTI_LASTCOMMON+1
                  bcc addact_trytofind
                  if SHOWCOMPREMOVE>0
                  lda #$02                      ;Error. No room for actor
                  sta $d020
                  endif
                  jmp addact_alldone

addact_removecomp:jsr rfa_remove
                  if SHOWCOMPREMOVE>0
                  lda #$05
                  sta $d020
                  endif
                  txa
                  tay
                  jsr gfa_found                 ;Perform the full actor
                                                ;datastructure cleanup
                                                ;Then move on...



addact_success:   tya
                  tax
                  ldy #LVLACT_X
                  lda (lvlactcurr),y
                  sta actxh,x
                  iny
                  lda (lvlactcurr),y
                  sta actyh,x
                  iny
                  lda (lvlactcurr),y
                  ror
                  ror
                  ror
                  and #$c0
                  sta actxl,x
                  lda (lvlactcurr),y
                  asl
                  asl
                  asl
                  asl
                  and #$c0
                  sta actyl,x
                  if CHECKINSIDESPAWN>0
                  sty nowallspawn+1
                  jsr getcharposinfo
                  and #CI_DOOR
                  bne nowallspawn
                  and #CI_OBSTACLE|CI_HIGHOBSTACLE
                  beq nowallspawn
                  inc $d020
nowallspawn:      ldy #$00
                  endif
                  lda (lvlactcurr),y
                  and #$70
                  asl
                  sta actd,x
                  iny
                  lda (lvlactcurr),y
                  sta actt,x
                  iny
                  cmp #ACT_ITEM
                  bne addact_noitem
                  lda (lvlactcurr),y
                  sta actf,x
                  jmp addact_itemdone
addact_noitem:    lda #$00
                  sta acthphi,x
                  lda (lvlactcurr),y
                  cmp #$a0
                  bcc addact_hpok
                  sbc #$a0
                  inc acthphi,x
addact_hpok:      sta acthplo,x
addact_itemdone:  lda lvlactcurr
                  sta actorglo,x
                  lda lvlactcurr+1
                  sta actorghi,x
                  ldy #LVLACT_T
                  lda #$00
                  sta (lvlactcurr),y
                  jmp addact_next

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³REMOVEFARACTORS                                                              ³
;³                                                                             ³
;³Removes too far actors back to the leveldata.                                ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

removeallactors:  ldx #ACTI_FIRSTCOMMON
raa_loop:         lda actt,x
                  beq raa_skip
                  jsr rfa_remove
raa_skip:         inx
                  cpx #ACTI_LASTENEMYBULLET+1
                  bcc raa_loop
                  rts

removefaractors:  ldx #ACTI_FIRSTCOMMON
                  lda mapx
                  sec
                  sbc #$01
                  sta temp2
                  lda mapy
                  sec
                  sbc #$01
                  sta temp3
rfa_loop:         lda actt,x
                  beq rfa_next
                  lda actxh,x
                  sec
                  sbc temp2
                  cmp #ACTORXDISTANCE
                  bcs rfa_removeit
                  lda actyh,x
                  sec
                  sbc temp3
                  cmp #ACTORYDISTANCE
                  bcc rfa_next
rfa_removeit:     jsr rfa_remove
rfa_next:         inx
                  cpx #ACTI_LASTCOMMON+1
                  bcc rfa_loop
                  rts


rfa_remove:
                  lda actorglo,x
                  sta temp4
                  ora actorghi,x
                  bne rfa_putback
                  lda #$00
                  sta actt,x
                  sta acthplo,x
                  sta acthphi,x
                  rts
rfa_putback:
                  lda actorghi,x
                  sta temp5
                  ldy #LVLACT_X
                  lda actxh,x
                  sta (temp4),y
                  iny
                  lda actyh,x
                  sta (temp4),y
                  iny
                  lda actxl,x
                  rol
                  rol
                  rol
                  and #$03
                  sta temp6
                  lda actyl,x
                  lsr
                  lsr
                  lsr
                  lsr
                  and #$0c
                  sta temp7
                  lda actd,x
                  clc
                  adc #$10
                  lsr
                  and #$70
                  ora temp6
                  ora temp7
                  sta (temp4),y
                  iny
                  lda actt,x
                  sta (temp4),y
                  lda #ACT_NONE
                  sta actt,x
                  lda (temp4),y
                  iny
                  cmp #ACT_ITEM
                  bne rfa_noitem
                  lda actf,x
                  jmp rfa_lowhp
rfa_noitem:       lda acthplo,x
                  ldy acthphi,x
                  beq rfa_lowhp
                  clc
                  adc #$a0
rfa_lowhp:        ldy #LVLACT_H
                  sta (temp4),y
rfa_skiphp:       lda #$00
                  sta actorglo,x
                  sta actorghi,x
                  sta acthplo,x
                  sta acthphi,x
                  rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³DEPACKFLOOR                                                                  ³
;³                                                                             ³
;³Depacks compressed mapdata.                                                  ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

depackfloor:      jsr hidescreen
                  lda floor
                  tay
                  asl
                  tax
                  lda #$0c
                  sta bgcolor2+1
                  lda #$0f
                  sta bgcolor3+1
                  lda floortbl,x
                  sta depack_getbyte+1
                  lda floortbl+1,x
                  sta depack_getbyte+2
                  lda lvlacttbl,x
                  sta lvlactstart
                  sta lvlactcurr
                  lda lvlacttbl+1,x
                  sta lvlactstart+1
                  sta lvlactcurr+1
                  lda lvlacttbl+2,x
                  sta lvlactend
                  lda lvlacttbl+3,x
                  sta lvlactend+1
                  jmp depack

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³DEPACKACTORDATA                                                              ³
;³                                                                             ³
;³Depacks compressed levelactor-data of the initial game state.                ³
;³                                                                             ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

depackactordata:  lda #<initialstate
                  sta depack_getbyte+1
                  lda #>initialstate
                  sta depack_getbyte+2
                  jmp depack

tempreg         = temp1
bitstr          = temp2
LZPOS           = temp3

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³PUCRUNCH DECOMPRESSOR                                                        ³
;³                                                                             ³
;³SHORT+IRQLOAD         354 bytes                                              ³
;³no rle =~             -83 bytes -> 271                                       ³
;³fixed params =~       -48 bytes -> 306                                       ³
;³                      223 bytes                                              ³
;³Parameters: -                                                                ³
;³Returns: -                                                                   ³
;³Modifies: A,X,Y                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SHORT = 1       ; assume file is ok
IRQLOAD = 1

depack: ldx #5
222$    jsr getbyt      ; skip 'p', 'u', endAddr HI&LO, leave starting escape in A
        dex
        bne 222$
        sta esc+1       ; starting escape
        jsr getbyt      ; read startAddr
        sta outpos+1
        jsr getbyt
        sta outpos+2
        jsr getbyt      ; read # of escape bits
        sta escB0+1
        sta escB1+1
        lda #8
        sec
        sbc escB1+1
        sta noesc+1     ; 8-escBits

        jsr getbyt
        sta mg+1        ; maxGamma + 1
        lda #9
        sec
        sbc mg+1        ; 8 - maxGamma == (8 + 1) - (maxGamma + 1)
        sta longrle+1
        jsr getbyt
        sta mg1+1       ; (1<<maxGamma)
        asl
        clc
        sbc #0
        sta mg21+1      ; (2<<maxGamma) - 1
        jsr getbyt
        sta elzpb+1

        ldx #$03
2$      jsr getbyt      ; Get 3 bytes, 2 unused (exec address)
        dex             ; and rleUsed. X is 0 after this loop
        bne 2$

        ;jsr getbyt     ; exec address
        ;sta lo+1       ; lo
        ;jsr getbyt
        ;sta hi+1       ; hi
        ;
        ;jsr getbyt     ; rleUsed
        ;ldx #0

        tay
        sty bitstr
0$      beq 1$          ; Y == 0 ?
        jsr getbyt
        sta table,x
        inx
        dey
        bne 0$
1$      ; setup bit store - $80 means empty
        lda #$80
        sta bitstr
        jmp main

getbyt  jsr getnew
        lda bitstr
        ror
        rts

newesc  ldy esc+1       ; remember the old code (top bits for escaped byte)
escB0   ldx #2          ; ** PARAMETER  0..8
        jsr getchkf     ; get & save the new escape code
        sta esc+1
        tya             ; pre-set the bits
        ; Fall through and get the rest of the bits.
noesc   ldx #6          ; ** PARAMETER  8..0
        jsr getchkf
        jsr putch       ; output the escaped/normal byte
        ; Fall through and check the escape bits again
main    ldy #0          ; Reset to a defined state
        tya             ; A = 0
escB1   ldx #2          ; ** PARAMETER  0..8
        jsr getchkf     ; X = 0
esc     cmp #0
        bne noesc
        ; Fall through to packed code

        jsr getval      ; X = 0
        sta LZPOS       ; xstore - save the length for a later time
        lsr             ; cmp #1        ; LEN == 2 ? (A is never 0)
        bne lz77        ; LEN != 2      -> LZ77
        ;tya            ; A = 0
        jsr get1bit     ; X = 0
        lsr             ; bit -> C, A = 0
        bcc lz77_2      ; A=0 -> LZPOS+1
        ;***FALL THRU***

        ; e..e01
        jsr get1bit     ; X = 0
        lsr             ; bit -> C, A = 0
        bcc newesc      ; e..e010
        ;***FALL THRU***

        ; e..e011
srle    iny             ; Y is 1 bigger than MSB loops
        jsr getval      ; Y is 1, get len, X = 0
        sta LZPOS       ; xstore - Save length LSB
mg1     cmp #64         ; ** PARAMETER 63-64 -> C clear, 64-64 -> C set..
        bcc chrcode     ; short RLE, get bytecode

longrle ldx #2          ; ** PARAMETER  111111xxxxxx
        jsr getbits     ; get 3/2/1 more bits to get a full byte, X = 0
        sta LZPOS       ; xstore - Save length LSB

        jsr getval      ; length MSB, X = 0
        tay             ; Y is 1 bigger than MSB loops

chrcode jsr getval      ; Byte Code, X = 0
        tax             ; this is executed most of the time anyway
        lda table-1,x   ; Saves one jump if done here (loses one txa)

        cpx #32         ; 31-32 -> C clear, 32-32 -> C set..
        bcc 1$          ; 1..31, we got the right byte from the table

        ; Ranks 32..64 (11111°xxxxx), get byte..
        txa             ; get back the value (5 valid bits)
        ldx #3
        jsr getbits     ; get 3 more bits to get a full byte, X = 0

1$      ldx LZPOS       ; xstore - get length LSB
        inx             ; adjust for cpx#$ff;bne -> bne
dorle   stx tempreg
        jsr putch
        ldx tempreg
        dex
        bne dorle       ; xstore 0..255 -> 1..256
        dey
        bne dorle       ; Y was 1 bigger than wanted originally
mainbeq beq main        ; reverse condition -> jump always


lz77    jsr getval      ; X = 0
mg21    cmp #127        ; ** PARAMETER  Clears carry (is maximum value)
        bne noeof
eof:    rts

noeof   sbc #0          ; C is clear -> subtract 1  (1..126 -> 0..125)
elzpb   ldx #0          ; ** PARAMETER (more bits to get)
        jsr getchkf     ; clears Carry, X = 0

lz77_2  sta LZPOS+1     ; offset MSB
        jsr getbyte     ; clears Carry, X = 0
        ; Note: Already eor:ed in the compressor..
        ;eor #255       ; offset LSB 2's complement -1 (i.e. -X = ~X+1)
        adc outpos+1    ; -offset -1 + curpos (C is clear)
        ldx LZPOS       ; xstore = LZLEN (read before it's overwritten)
        sta LZPOS

        lda outpos+2
        sbc LZPOS+1     ; takes C into account
        sta LZPOS+1     ; copy X+1 number of chars from LZPOS to outpos+1
        ;ldy #0         ; Y was 0 originally, we don't change it

        inx             ; adjust for cpx#$ff;bne -> bne
        stx tempreg

lzslow  lda (LZPOS),y   ; using abs,y is 3 bytes longer, only 1 cycle/byte faster
        jsr outpos
        iny             ; Y does not wrap because X=0..255 and Y initially 0
        dec tempreg
        bne lzslow      ; X loops, (256,1..255)
        jmp main

putch:
outpos  sta $aaaa       ; ** parameter
        inc outpos+1    ; ZP
        bne outposdone
        inc outpos+2    ; ZP
outposdone:
        rts

getnew  pha             ; 1 Byte/3 cycles
        jsr depack_getbyte
0$      sec
        rol             ; Shift out the next bit and
                        ;  shift in C=1 (last bit marker)
        sta bitstr      ; bitstr initial value = $80 == empty
        pla             ; 1 Byte/4 cycles
        rts
        ; 25+12 = 37

; getval : Gets a 'static huffman coded' value
n; ** Scratches X, returns the value in A **
getval  inx             ; X <- 1
        txa             ; set the top bit (value is 1..255)
gv0     asl bitstr
        bne 1$
        jsr getnew
1$      bcc getchk      ; got 0-bit
        inx
mg      cpx #7          ; ** PARAMETER unary code maximum length + 1
        bne gv0
        beq getchk      ; inverse condition -> jump always
        ; getval: 18 bytes
        ; 15 + 17*n + 6+15*n+12 + 36*n/8 = 33 + 32*n + 36*n/8 cycles

; getbits: Gets X bits from the stream
; ** Scratches X, returns the value in A **
getbyte ldx #7
get1bit inx             ;2
getbits asl bitstr
        bne 1$
        jsr getnew
1$      rol             ;2
getchk  dex             ;2              more bits to get ?
getchkf bne getbits     ;2/3
        clc             ;2              return carry cleared
        rts             ;6+6

depack_getbyte:   lda $1000
                  inc depack_getbyte+1
                  bne dgb_ok
                  inc depack_getbyte+2
dgb_ok:           rts

