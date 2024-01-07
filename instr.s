                processor 6502
                org 2048

JOY_FIRE        = 16

                include define.s
                incbin bofhmus.bin

                org start

                jsr initraster
                lda #$00
                jsr music
                lda #$0b
                sta $d011
                lda $dd00
                and #$fc
                ora #$03
                sta $dd00
                lda #$00
                sta $d020
                sta $d021
                sta $d015
                lda #$18
                sta $d016
                sta $d018
                ldx #$00
loop:           lda $4000,x
                sta $0400,x
                lda $4100,x
                sta $0500,x
                lda $4200,x
                sta $0600,x
                lda $4300,x
                sta $0700,x
                lda $4400,x
                sta $d800,x
                lda $4500,x
                sta $d900,x
                lda $4600,x
                sta $da00,x
                lda $4700,x
                sta $db00,x
                inx
                bne loop
                lda #$3b
                sta $d011
wait:           jsr getfireclick
                bcs exitwait
                lda prevjoy
                bne wait
                lda joystick
                and #JOY_FIRE
                bne exitwait
                lda keytype
                bmi wait
exitwait:       jmp instrstart

initraster:     sei
                lda #<raster
                sta $0314
                lda #>raster
                sta $0315
                lda #$fa
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

uninitraster:   sei
                lda #<$ea31
                sta $0314
                lda #>$ea31
                sta $0315
                lda #$00
                sta $d01a
                lda #$81
                sta $dc0d
                inc $d019
                cli
                rts

raster:         jsr music+3
                inc rastercnt
                dec $d019
                jmp $ea81

                org $2000
                incbin bofh.raw

                org $4800

instrstart:     lda #3
                sta $d011
                lda #8
                sta $d016
                lda #$32
                sta $d018
                lda $dd00
                and #$fc
                sta $dd00
                lda #$3f
                sta finescroll
                ldx #$00
                lda #$01
instrcolors:    sta $d800,x
                sta $d900,x
                sta $da00,x
                sta $db00,x
                dex
                bne instrcolors
                lda #<instrtext
                sta textptr
                lda #>instrtext
                sta textptr+1

                lda #-8*8
                sta scrollspeed

instrforced:    jsr waitraster
                jsr doscroll
                lda textptr
                cmp #<textstart
                bne instrforced
                lda textptr+1
                cmp #>textstart
                bne instrforced
                lda #0
                sta scrollspeed

instrloop:      jsr waitraster
                jsr doscroll
                jsr getcontrols
                jsr docontrol
                lda keytype
                cmp #KEY_F7
                beq exit
                cmp #KEY_SPACE
                bne instrloop
                jsr uninitraster
                jmp loadgame
exit:           lda #$03
                sta $d011
                jmp 64738

waitraster:     lda rastercnt
waitraster2:    cmp rastercnt
                beq waitraster2
                rts

doscroll:       lda finescroll
                clc
                adc scrollspeed
                bmi dos_down
                cmp #$40
                bcs dos_up
dos_setd011:    sta finescroll
                lsr
                lsr
                lsr
                and #$07
                ora #$10
                sta $d011
                rts
dos_down:       and #$3f
                jsr dos_setd011
                lda textptr
                cmp #<textend
                bne dos_downok
                lda textptr+1
                cmp #>textend
                bne dos_downok
                lda #$00
                sta scrollspeed
                jmp dos_setd011
dos_downok:     lda textptr
                clc
                adc #40
                sta textptr
                lda textptr+1
                adc #0
                sta textptr+1
                jmp dos_drawtext

dos_up:         and #$3f
                jsr dos_setd011
                lda textptr
                cmp #<textstart
                bne dos_upok
                lda textptr+1
                cmp #>textstart
                bne dos_upok
                lda #$00
                sta scrollspeed
                lda #$3f
                jmp dos_setd011
dos_upok:       lda textptr
                sec
                sbc #40
                sta textptr
                lda textptr+1
                sbc #0
                sta textptr+1
dos_drawtext:   lda textptr
                sta dos_lda1+1
                sta dos_lda3+1
                sta dos_lda5+1
                sta dos_lda7+1
                clc
                adc #$80
                sta dos_lda2+1
                sta dos_lda4+1
                sta dos_lda6+1
                sta dos_lda8+1
                ldx textptr+1
                stx dos_lda1+2
                stx dos_lda2+2
                inx
                stx dos_lda3+2
                stx dos_lda4+2
                inx
                stx dos_lda5+2
                stx dos_lda6+2
                inx
                stx dos_lda7+2
                stx dos_lda8+2
                bcc dos_dtok
                inc dos_lda2+2
                inc dos_lda4+2
                inc dos_lda6+2
                inc dos_lda8+2
dos_dtok:       ldx #$00
dos_loop1:
dos_lda1:       lda $1000,x
                sta $cc00,x
dos_lda2:       lda $1000,x
                sta $cc80,x
dos_lda3:       lda $1000,x
                sta $cd00,x
dos_lda4:       lda $1000,x
                sta $cd80,x
                inx
                bpl dos_loop1
                ldx #$00
dos_loop2:
dos_lda5:       lda $1000,x
                sta $ce00,x
dos_lda6:       lda $1000,x
                sta $ce80,x
dos_lda7:       lda $1000,x
                sta $cf00,x
dos_lda8:       lda $1000,x
                sta $cf80,x
                inx
                bpl dos_loop2
                rts

docontrol:      lda joystick
                and #JOY_DOWN
                beq dc_notup
                lda scrollspeed
                bpl dc_upok
                cmp #-8*8
                beq dc_notdown
                bcc dc_notdown
dc_upok:        dec scrollspeed
                dec scrollspeed
                rts
dc_notup:       lda joystick
                and #JOY_UP
                beq dc_brake
                lda scrollspeed
                bmi dc_downok
                cmp #8*8
                bcs dc_notdown
dc_downok:      inc scrollspeed
                inc scrollspeed
dc_notdown:     rts

dc_brake:       lda scrollspeed
                beq dc_notdown
                bmi dc_downok
                bpl dc_upok

                include control.s

asciitbl:       dc.b 255,13,0,0,0,0,0,0
                dc.b "3WA4ZSE",0
                dc.b "5RD6CFTX"
                dc.b "7YG8BHUV"
                dc.b "9IJ0MKON"
                dc.b 0,"PL",0,".",0,"@,"
                dc.b 0,0,0,0,0,0,0,"/"
                dc.b "1",0,0,"2 ",0,"Q",0

keyrowbit:      dc.b $fe,$fd,$fb,$f7,$ef,$df,$bf,$7f
kcrownum:       dc.b 7,1,1,1,2,1,2,2,1,6
kcrowand:       dc.b $40,$02,$40,$04,$04,$10,$80,$10,$80,$10

kcjoybits:      dc.b JOY_LEFT+JOY_UP
                dc.b JOY_UP
                dc.b JOY_RIGHT+JOY_UP
                dc.b JOY_LEFT
                dc.b JOY_RIGHT
                dc.b JOY_LEFT+JOY_DOWN
                dc.b JOY_DOWN
                dc.b JOY_RIGHT+JOY_DOWN
                dc.b JOY_FIRE
                dc.b JOY_FIRE

finescroll:     dc.b 0
scrollspeed:    dc.b 0
rastercnt:      dc.b 0
textptr:        dc.w 0

                     ;0123456789012345678901234567890123456789
instrtext:      dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
textstart:      dc.b "                                        "
                dc.b "     BOFH: SERVERS UNDER SIEGE V1.0     "
                dc.b "                                        "
                dc.b "   A COVERT BITOPS PRODUCTION IN 2002   "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                  MANUAL                "
                dc.b "                                        "
                dc.b "    USE JOYSTICK IN PORT 2 TO SCROLL,   "
                dc.b "    SPACE TO LOAD GAME OR F7 TO EXIT.   "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "THE STORY:                              "
                dc.b "                                        "
                dc.b "TAKE THE ROLE OF A BOFH AS YOU ARRIVE   "
                dc.b "LATE AT WORK TO FIND YOUR WORKPLACE     "
                dc.b "OVERRUN BY A GROUP OF INSANE ACTIVISTS. "
                dc.b "THEY HAVE ORDERED PERSONNEL TO LEAVE,   "
                dc.b "TAKEN ALL WORKSTATIONS AND SERVERS AS   "
                dc.b "HOSTAGES AND SET UP BOMBS IN NETWORK    "
                dc.b "EQUIPMENT CLOSETS. OF COURSE, THIS MAKES"
                dc.b "YOU BOIL WITH WRATH AND THE ONLY LOGICAL"
                dc.b "COURSE OF ACTION SEEMS TO BE WAGING WAR "
                dc.b "ON THE ACTIVISTS SINGLE-HANDEDLY.       "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "THE MISSION:                            "
                dc.b "                                        "
                dc.b "YOUR GOAL IS TO COMBAT THE ACTIVIST     "
                dc.b "LEADERS AT THE SIXTH FLOOR AND FINALLY  "
                dc.b "RECLAIM THE SERVER ROOM BUT FIRST YOU   "
                dc.b "MUST DEFUSE THE BOMBS IN THE NETWORK    "
                dc.b "EQUIPMENT CLOSETS. SEARCH THE ACTIVISTS "
                dc.b "YOU HAVE KILLED FOR EXTRA WEAPONS, FIRST"
                dc.b "AID KITS AND BOMB DEFUSING INSTRUCTIONS "
                dc.b "(FROM TECHNICIANS IN GREEN UNIFORM.)    "
                dc.b "ALSO SEEK USEFUL TOOLS FROM THE         "
                dc.b "BUILDING.                               "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "HOW TO PLAY:                            "
                dc.b "                                        "
                dc.b "YOU SEE THE BOFH, AND THE SURROUNDINGS  "
                dc.b "FROM AN OVERHEAD VIEW. FOR CONTROL, USE "
                dc.b "JOYSTICK PORT 2 OR THE KEYS QWE         "
                dc.b "                            A D + SHIFT "
                dc.b "                            ZXC         "
                dc.b "                                        "
                dc.b "PRESS UP/DOWN TO WALK FORWARDS/BACKWARDS"
                dc.b "AND LEFT/RIGHT TO ROTATE LEFT/RIGHT.    "
                dc.b "FIRE BUTTON USES THE CURRENTLY ACTIVE   "
                dc.b "WEAPON.                                 "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "OTHER KEY CONTROLS:                     "
                dc.b "                                        "
                dc.b "M       - MUSIC ON/OFF                  "
                dc.b "Q       - QUIT GAME (WHEN PAUSED)       "
                dc.b "V       - VIEW DEFUSING INSTRUCTIONS    "
                dc.b "1-9     - SELECT WEAPONS                "
                dc.b "SPACE   - SELECT NEXT WEAPON            "
                dc.b "RUNSTOP - PAUSE GAME                    "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "STATUS:                                 "
                dc.b "                                        "
                dc.b "THE STATUS LINE AT THE BOTTOM OF SCREEN "
                dc.b "SHOWS YOUR SCORE, HEALTH, TIME UNTIL THE"
                dc.b "BOMBS EXPLODE, NUMBER OF BOMBS,ACTIVISTS"
                dc.b "AND COMPUTERS REMAINING, YOUR CURRENTLY "
                dc.b "ACTIVE WEAPON AND AMMUNITION LEFT.      "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "WEAPONS:                                "
                dc.b "                                        "
                dc.b "1 - FISTS                               "
                dc.b "2 - CAT-5 WHIP. THIS CAN BE FOUND FROM  "
                dc.b "    THE IT-ENGINEER'S ROOM ON THE SECOND"
                dc.b "    FLOOR, TO THE LEFT OF THE LOBBY     "
                dc.b "    STAIRCASE.                          "
                dc.b "3 - ELECTRIC DRILL                      "
                dc.b "4 - CROSSBOW. HOLD DOWN FIRE TO AIM,    "
                dc.b "    RELEASE TO FIRE.                    "
                dc.b "5 - PISTOL                              "
                dc.b "6 - SHOTGUN. MAKES MORE DAMAGE WHEN YOU "
                dc.b "    MANAGE TO HIT WITH ALL PELLETS (IN  "
                dc.b "    CLOSE RANGE.)                       "
                dc.b "7 - SUBMACHINEGUN                       "
                dc.b "8 - FLAMETHROWER                        "
                dc.b "9 - GRENADES. HOLD DOWN FIRE TO INCREASE"
                dc.b "    THROW STRENGTH AND RELEASE TO THROW."
                dc.b "                                        "
                dc.b "                                        "
                dc.b "THE ENEMIES:                            "
                dc.b "                                        "
                dc.b "ENEMIES CAN BE IDENTIFIED FROM THE COLOR"
                dc.b "OF THEIR UNIFORM.                       "
                dc.b "                                        "
                dc.b "DARK GREY  - FIST-GUY                   "
                dc.b "LIGHT GREY - PISTOL-GUY                 "
                dc.b "RED        - SHOTGUN-GUY                "
                dc.b "LIGHT BLUE - SUBMACHINEGUN-GUY          "
                dc.b "CYAN       - CROSSBOW-GUY               "
                dc.b "GREEN      - TECHNICIAN                 "
                dc.b "BLACK      - LEADER                     "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "DEFUSING BOMBS:                         "
                dc.b "                                        "
                dc.b "FROM EACH TECHNICIAN YOU GET ONE LETTER."
                dc.b "FOR EACH CLOSET CONTAINING A BOMB       "
                dc.b "THERE'S A 3-LETTER CODE THAT INDICATES  "
                dc.b "(AS FIRST LETTERS OF THE COLOR NAMES)   "
                dc.b "WHAT 3 WIRES MUST BE CUT. THE ORDER     "
                dc.b "DOESN'T MATTER BUT CUTTING ANY OF THE   "
                dc.b "4 'WRONG' WIRES WILL RESULT IN          "
                dc.b "DETONATION OF THE BOMB (AND OF ALL THE  "
                dc.b "OTHERS, BECAUSE THE BOMBS CONTAIN AN    "
                dc.b "ETHERNET INTERFACE. :-))                "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "DEFEAT/VICTORY:                         "
                dc.b "                                        "
                dc.b "THE GAME IS LOST IF THE BOFH DIES, OR IF"
                dc.b "THE BOMBS EXPLODE. YOU HAVE WON WHEN ALL"
                dc.b "BOMBS HAVE BEEN DEFUSED, THE LEADERS    "
                dc.b "HAVE BEEN DEFEATED AND YOU'RE STANDING  "
                dc.b "IN THE SERVER ROOM, STILL ALIVE.        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "HINTS:                                  "
                dc.b "                                        "
                dc.b "* AS TECHNICIANS SEE YOU THEY TRY TO RUN"
                dc.b "  AWAY - IT MIGHT BE HARD TO FIND THEM  "
                dc.b "  AGAIN IF YOU LET THEM GO!             "
                dc.b "                                        "
                dc.b "* TRY TO SNEAK UP ON AN ENEMY FROM      "
                dc.b "  BEHIND.                               "
                dc.b "                                        "
                dc.b "* CONSERVE AMMUNITION BY PUNCHING OR    "
                dc.b "  WHIPPING UNARMED ACTIVISTS. SILENT    "
                dc.b "  METHODS OF ATTACK WILL NOT ATTRACT    "
                dc.b "  ENEMIES, LIKE GUNFIRE, FLAMETHROWER   "
                dc.b "  AND EXPLOSIONS DO.                    "
                dc.b "                                        "
                dc.b "* THE CROSSBOW IS AT ITS BEST WHEN      "
                dc.b "  ENEMIES HAVEN'T NOTICED YOU YET.      "
                dc.b "                                        "
                dc.b "* USE GRENADES WITH CAUTION: THEY CAN   "
                dc.b "  CAUSE MUCH DAMAGE, ALSO TO YOU!       "
                dc.b "                                        "
                dc.b "* IF AN ENEMY DROPS A FIRST AID KIT AND "
                dc.b "  YOU'RE ALREADY AT FULL HEALTH, TRY TO "
                dc.b "  REMEMBER THE PLACE - YOU'LL NEED IT   "
                dc.b "  LATER... SAME GOES FOR AMMUNITION     "
                dc.b "  (THERE'S A CERTAIN MAXIMUM OF BULLETS "
                dc.b "  YOU CAN CARRY.)                       "
                dc.b "                                        "
                dc.b "* EVERY TIME YOU GO UP/DOWN STAIRS      "
                dc.b "  REDUCES TIME BY 5 SECONDS. SO TRY TO  "
                dc.b "  PLAN YOUR ROUTE WITH MINIMAL FLOOR    "
                dc.b "  CHANGES.                              "
                dc.b "                                        "
                dc.b "* BE PREPARED WHEN YOU ENTER THE SIXTH  "
                dc.b "  FLOOR - THE LEADERS MIGHT HAVE        "
                dc.b "  POWERFUL WEAPONRY.                    "
                dc.b "                                        "
                dc.b "* IF YOU WIN, BONUS IS AWARDED FOR      "
                dc.b "  SURVIVED COMPUTERS. SERVERS ARE       "
                dc.b "  CONSIDERED ESPECIALLY VALUABLE, SO TRY"
                dc.b "  TO PERSUADE THE LEADERS TO EXIT THE   "
                dc.b "  SERVER ROOM AND COMBAT THEM OUTSIDE.  "
                dc.b "                                        "
                dc.b "* IF YOU DEFUSE A BOMB WITHOUT ALL THE  "
                dc.b "  LETTERS (BY GUESSING), YOU RECEIVE AN "
                dc.b "  ADDITIONAL 10000 POINTS. THIS IS NOT  "
                dc.b "  REALLY RECOMMENDED, UNLESS YOU'RE     "
                dc.b "  RUNNING OUT OF TIME...                "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "THE MAP:                                "
                dc.b "                                        "
                dc.b "KJA1,KJA2,KJA3,KJB,KJD,KJE,KJF AND KJR  "
                dc.b "ARE THE NETWORK EQUIPMENT CLOSETS. X    "
                dc.b "MARKS THE STARTING POSITION.            "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "BASEMENT:                               "
                dc.b "                                        "
                dc.b "                  aabfaaaaaaaa          "
                dc.b "                  aaaaaaaaaaaa          "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "1ST FLOOR:                              "
                dc.b "                                        "
                dc.b "     aaaaaaaaaaaaaaaaaaaaaa             "
                dc.b "    aaaaaabkaaaaaaaaaaaaaaa             "
                dc.b "    aaaaaaaaaaaaabjaaaaaaaa             "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        abi                      "
                dc.b "  aabha        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaaaaaaaaaaaaaaaaaaaaaaaaa          "
                dc.b "  aaaaaaaaabcaaalaaaaaaaaaaaaa          "
                dc.b "  aaaaaaaaaaaaa                         "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "2ND FLOOR:                              "
                dc.b "                                        "
                dc.b "     aaaaaaaaaaaaaaaaaaaaaa             "
                dc.b "    aaaaaaaaaaaaaaaaaaaaaaa             "
                dc.b "    aaaaaaaaaaaaaaaaaaaaaaa             "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaa        aaa                      "
                dc.b "  aaaaaaaaaaaaaaaaaaaaaaaaaaaa          "
                dc.b "  aaaaaaaaaaaaaaaaaaaaaaaaaabg          "
                dc.b "  aaaaaaaaaaaaaaaaaaaaa                 "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "3RD FLOOR:                              "
                dc.b "                                        "
                dc.b "  aaaaaaaaaaaaaaaaaaaaaaaaaaaa          "
                dc.b "  aaaaaaabdaaaaaaaaaaaaaaaaaaa          "
                dc.b "  aaaaaaaaaaaaaaaaaaaaa                 "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "4TH FLOOR:                              "
                dc.b "                                        "
                dc.b "  aaaaaaaaaaaaa                         "
                dc.b "  aaaaaaaaaaaaa                         "
                dc.b "  aaaaaaaaaaaaa                         "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "5TH FLOOR:                              "
                dc.b "                                        "
                dc.b "  aaaaaaaaaaaaa                         "
                dc.b "  aaaaaaaabeaaa                         "
                dc.b "  aaaaaaaaaaaaa                         "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "6TH FLOOR: (CONTAINS SERVER ROOM)       "
                dc.b "                                        "
                dc.b "        aaaaaaa                         "
                dc.b "        aaaaaaa                         "
                dc.b "        aaaaaaa                         "
                dc.b "                                        "
                dc.b "                                        "
                DC.B "ORIGINAL PC VERSION CREDITS:            "
                DC.B "                                        "
                DC.B "MAIN DESIGN & PROGRAMMING:              "
                DC.B "LASSE \\RNI                             "
                DC.B "                                        "
                dc.b "ADDITIONAL DESIGN & PROGRAMMING:        "
                dc.b "KALLE NIEMITALO                         "
                dc.b "OLLI NIEMITALO                          "
                DC.B "                                        "
                dc.b "GRAPHICS:                               "
                dc.b "LASSE \\RNI                             "
                dc.b "OLLI NIEMITALO                          "
                dc.b "                                        "
                dc.b "VOICES,GUN,FIST,WHIP & EXPLOSION SOUNDS:"
                dc.b "LASSE \\RNI                             "
                dc.b "                                        "
                dc.b "DRILL,SHELL,LOADING & RICOCHET SOUNDS:  "
                dc.b "OLLI NIEMITALO                          "
                dc.b "                                        "
                dc.b "MUSIC:                                  "
                dc.b "OLLI NIEMITALO                          "
                dc.b "TUOMAS M[KEL[                           "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "C64 VERSION CREDITS:                    "
                dc.b "                                        "
                dc.b "PROGRAMMING, GRAPHICS AND SOUNDS:       "
                DC.B "LASSE \\RNI                             "
                dc.b "                                        "
                dc.b "MUSIC:                                  "
                dc.b "OLLI NIEMITALO                          "
                dc.b "                                        "
                dc.b "PUCRUNCH COMPRESSOR:                    "
                dc.b "PASI OJALA                              "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "BOFH HOMEPAGE:                          "
                dc.b "HTTP://COVERTBITOPS.CJB.NET             "
                dc.b "                                        "
                dc.b "AUTHORS' EMAIL:                         "
                dc.b "LOORNI@STUDENT.OULU.FI                  "
                dc.b "ONIEMITA@STUDENT.OULU.FI                "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "CLOSING WORDS (BY LASSE)                "
                dc.b "                                        "
                dc.b "BOFH:SERVERS UNDER SIEGE IS BASED ON AN "
                dc.b "ACTUAL BUILDING AND THE BOFHS WHO WORK  "
                dc.b "THERE. THEY DON'T COMBAT VIOLENT        "
                dc.b "PARAMILITARY ACTIVISTS BUT FACE OTHER NO"
                dc.b "LESS FORMIDABLE THREATS EACH DAY :-) ALL"
                dc.b "THE RESPECT TO THEM AND THEIR WORK!     "
                dc.b "                                        "
                dc.b "THIS GAME USES SOME ROUTINES AND IDEAS  "
                dc.b "FROM THE CANCELLED DETECTIVE TAKASHI, SO"
                dc.b "IT DIDN'T GO ENTIRELY TO WASTE!         "
textend:        dc.b "                                        "
                dc.b "GREETINGS TO ALL WHO ARE STILL ACTIVE   "
                dc.b "WITH THE C64; ESPECIALLY ROMAN CHLEBEC, "
                dc.b "MILO & MALTE MUNDT, VOLKER RUST, JASON  "
                dc.b "KELK, RICHARD BAYLISS, LORIN MILLSAP.   "

                dc.b "                                        "
                dc.b "THANKS TO BOFH BETATESTERS:             "
                dc.b "AYO STEPHENSON, CARLOS, DANIEL OLSSON,  "
                dc.b "HENU HEINO, KARSTEN ENGSTLER, LANG FERI,"
                dc.b "MAFF RIGNALL, MATTHEW ALLEN, MIKAEL     "
                dc.b "BACKLUND, OTTO J[RVINEN, PETER          "
                dc.b "KANNENGIESSER, LORDNIKON, STUART TOOMER,"
                dc.b "WOODMAN, ZOLTAN MUCSANYI.               "
                dc.b "                                        "
                dc.b "SPECIAL THANKS TO PASI OJALA FOR        "

                dc.b "PUCRUNCH, WITHOUT IT THIS WOULD HAVE    "
                dc.b "BEEN IMPOSSIBLE TO REALIZE AS AN ONE-   "
                dc.b "PART GAME!                              "
                dc.b "                                        "
                dc.b "AND A MESSAGE TO CRACKERS: THIS TIME    "
                dc.b "THERE'S NO INGAME CHEATS, SO YOU HAVE   "
                dc.b "ALL THE JOY OF IMPLEMENTING THEM! TRY   "
                dc.b "NOT TO CHANGE VARIABLES FROM WITHIN AN  "
                dc.b "INTERRUPT, IT CAN BE UNPREDICTABLE!     "
                dc.b "                                        "

                org $c000

loadgame:       lda #$03
                sta $d011
                lda #$00
                sta $d404
                sta $d404+7
                sta $d404+14
                sta $9d                         ;Disable KERNAL messages
                cli
loadsetlfs:     lda #$02
                ldy #$00
loadsetlfs2:    ldx $ba
                bne ldevnotzero
                ldx #$08
ldevnotzero:    jsr setlfs
loadsetnam:     lda #7
                ldx #<bofhname
                ldy #>bofhname
                jsr setnam
                jsr open
                ldx #$02
                jsr chkin
                jsr chrin
                sta load_sta+1
                lda status
                bne load_error
                jsr chrin
                sta load_sta+2
load_loop:      jsr chrin
load_sta:       sta $1000
                inc load_sta+1
                bne load_flash
                inc load_sta+2
load_flash:     sta $d020
                lda #$00
                sta $d020
                lda status
                bne loaddone
                jmp load_loop
loaddone:       lda #$00
                sta $d020
                lda #$02
                jsr close
                jmp 2061

load_error:     lda #$02
                sta $d020
                sta $d021
                jsr close
                jmp 64738

bofhname:       dc.b "BOFH V*"

                org $c800
                incbin bofhinst.chr
                ds.b 1024,32
