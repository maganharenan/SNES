.INCLUDE "header.inc"

.EQU z_HL               $20
.EQU z_L                $20
.EQU z_H                $21
.EQU z_HLU              $22

.ORGA                   $8000

MyProgram:
    SEI
    CLC
    XCE

    REP                 #%00010000
    .INDEX              16

; ==========================================================================
;                             * SCREEN SETUP *                             ;
; ==========================================================================
    LDA                     #%00010001
    STA                     $210B

    STZ                     $2107

    LDA                     #%10001111
    STA                     $2100

    STZ                     $2115

    LDA                     #%00001001
    STA                     $2105

; ==========================================================================
;                          * COLOR PALETTE SETUP *                         ;
; ==========================================================================
    ; Color 0 = Black
    STZ                     $2121
    STZ                     $2122
    STZ                     $2122

    ; Color 1 - Purple
    LDA                     #%00001111
    STA                     $2122
    LDA                     #%00111100
    STA                     $2122

    ; Color 2 - Cyan
    LDA                     #%11100000
    STA                     $2122
    LDA                     #%01111111
    STA                     $2122

    ; Color 3 - White
    LDA                     #%11111111
    STA                     $2122
    LDA                     #%01111111
    STA                     $2122

; ==========================================================================
;                           * TRANSFER PATTERN *                           ;
; ==========================================================================
    LDA                     #<Bitmap
    STA                     z_L
    LDA                     #>Bitmap
    STA                     z_H
    LDA                     #Bitmap>>16
    STA                     z_HLU

    LDX                     #$1000
    STX                     $2116
    LDY                     #0

Patterns_NextWord:
    LDA                     [z_HL], y
    INY
    STA                     $2119

    LDA                     [z_HL], y
    INY
    STA                     $2118

    CPY                     #(Bitmap_End-Bitmap)
    BNE                     Patterns_NextWord

; ==========================================================================
;                          * SET SCROLL POSITION *                         ;
; ==========================================================================
    STZ                     $210D
    STZ                     $210D
    LDA                     #-1
    STA                     $210E
    STZ                     $210E
    STZ                     $2116
    STZ                     $2117

; ==========================================================================
;                             * CLEAR TILE MAP *                           ;
; ==========================================================================
    LDX                     #$400

ClearTilemap:
    STZ                     $2119
    STZ                     $2118
    DEX
    BNE                     ClearTilemap

; ==========================================================================
;                             * TURN SCREEN ON *                           ;
; ==========================================================================
    LDA                     #%00000001
    STA                     $212C

    LDA                     #%00001111
    STA                     $2100

; ==========================================================================
;                           * START THE PROGRAM *                          ;
; ==========================================================================
	SEP                     #%00010000	
    .INDEX                  8

	LDX                     #4
    LDY                     #4 				
	JMP                     StartDraw

infloop:
    JSR                     ReadJoystick
    LDA                     z_H
    BEQ                     infloop

; ==========================================================================
;                              * PLAYER INPUT *                            ;
; ==========================================================================
StartDraw:
    LDA                     z_H
    PHA
        JSR                 RemovePlayer
    PLA
    STA                     z_H
    AND                     #%00010000
    BEQ                     JoyNotUp
    CPY                     #0
    BEQ                     JoyNotUp
    DEY

JoyNotUp:
    LDA                     z_H
    AND                     #%00100000
    BEQ                     JoyNotDown
    CPY                     #27
    BEQ                     JoyNotDown
    INY

JoyNotDown:
    LDA                     z_H
    AND                     #%01000000
    BEQ                     JoyNotLeft
    CPX                     #0
    BEQ                     JoyNotLeft
    DEX

JoyNotLeft:
    LDA                     z_H
    AND                     #%10000000
    BEQ                     JoyNotRight
    CPX                     #31
    BEQ                     JoyNotRight
    INX

JoyNotRight:
    JSR                     DrawPlayer

    PHX
        REP                 #%00010000
        .INDEX              16

        LDX                 #65535

PauseX:
        DEX
        BNE                 PauseX

        SEP                 #%00010000
        .INDEX              8
    PLX
    JMP                     infloop

ReadJoystick:
    TXA
    PHA
        LDX                 #$01
        STX                 $4016
        DEX
        STX                 $4016

        LDX                 #8

ReadJoystick_Loop:
        LDA                 $4016
        LSR
        ROR                 z_H
        DEX
        BNE                 ReadJoystick_Loop
    PLA
    TAX
    RTS

; ==========================================================================
;                                * PLAYER *                                ;
; ==========================================================================
RemovePlayer:
    LDA                     #0
    JMP                     DrawTile

DrawPlayer:
    LDA                     #1

DrawTile:
    PHX
    PHY
        PHA
            TYA
            STA             z_H
            LDA             #0
            CLC
            ROR             z_H
            ROR
            ROR             z_H
            ROR
            ROR             z_H
            ROR
            STA             z_L
            TXA
            ADC             z_L
            STA             z_L

WaitVblank:
            LDA             $4212
            AND             #%10000000
            BEQ             WaitVblank
            LDA             z_L
            STA             $2116
            LDA             z_H
            STA             $2117

            STZ             $2119
        PLA
        STA                 $2118
    PLY
    PLX
    RTS

; ==========================================================================
;                                * BITMAP *                                ;
; ==========================================================================
Bitmap:	;Empty Tile
	.db                     0, 0, 0, 0, 0, 0, 0, 0
	.db                     0, 0, 0, 0, 0, 0, 0, 0
	.db                     0, 0, 0, 0, 0, 0, 0, 0
	.db                     0, 0, 0, 0, 0, 0, 0, 0

	;                         11111111 000000000 	- Bitplane 1/0 - Smiley
	.db                     %00000000, %00111100     ;  0
    .db                     %00000000, %01111110     ;  1
    .db                     %00100100, %11111111     ;  2
    .db                     %00000000, %11111111     ;  3
    .db                     %00000000, %11111111     ;  4
    .db                     %00100100, %11011011     ;  5
    .db                     %00011000, %01100110     ;  6
    .db                     %00000000, %00111100     ;  7
	;                        33333333  22222222 	- Bitplane 3/2
    .db                     %00000000, %00000000     ;  0
    .db                     %00000000, %00000000     ;  1
    .db                     %00000000, %00000000     ;  2
    .db                     %00000000, %00000000     ;  3
    .db                     %00000000, %00000000     ;  4
    .db                     %00000000, %00000000     ;  5
    .db                     %00000000, %00000000     ;  6
    .db                     %00000000, %00000000     ;  7
Bitmap_End:	

.ORG $FFFA
	.DW $0000
	.DW $8000
	.DW $0000