; ==================================
;            * INCLUDES *          #
; ==================================
.INCLUDE "header.inc"
.INCLUDE "init-hardware.asm"

; ==================================
;             * START *            #
; ==================================
.BANK 0 SLOT 0
.ORG 0
.SECTION "MainCode"

Start:
    InitHardware

    STZ $2121
    LDA #%00011111
    STA $2122
    STZ $2122

    LDA #$0F
    STA $2100

forever:
    JMP forever

.ENDS
