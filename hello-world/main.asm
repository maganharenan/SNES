.MEMORYMAP					;Define the memory map of the system
SLOTSIZE $020000			;Define a ROM of $000000-$01FFFF
SLOT 0   $000000			;Start of slot 0  (only slot)
DEFAULTSLOT 0				;Select this slot
.ENDME

.ROMBANKMAP					;Define the ROM map of the cartridge
BANKSTOTAL 1				;Single Bank
BANKSIZE $020000			;Define a Bank of $000000-$01FFFF
BANKS 1						;1 bank of size $020000
.ENDRO

.BANK 0 SLOT 0				;Start the Cartridge bank 0 in Mem Slot 0

.EQU z_HL                   $20
.EQU z_L                    $20
.EQU z_H                    $21
.EQU z_HLU                  $22

.EQU CursorX                $40
.EQU CursorY                $41

.ORGA                       $8000

MyProg:
    SEI
    CLC
    XCE

    REP                     #%00010000
    .INDEX                  16

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
    STZ                     $2121
    STZ                     $2122
    STZ                     $2122

    LDA                     #3
    STA                     $2121
    LDA                     #%11111111
    STA                     $2122
    LDA                     #%00000111
    STA                     $2122

; ==========================================================================
;                           * TRANSFER PATTERN *                           ;
; ==========================================================================
    LDA                     #<BitmapFont
    STA                     z_L
    LDA                     #>BitmapFont
    STA                     z_H
    LDA                     #BitmapFont>>16
    STA                     z_HLU

    LDX                     #$1000
    STX                     $2116

    LDY                     #0

fontchar_loop:
    LDX                     #8

fontchar_NextWord:
    LDA                     [z_HL], y
    STA                     $2119
    STA                     $2118
    INY
    DEX
    BNE                     fontchar_NextWord
    LDX                     #8

fontchar_NextZero:
    STZ                     $2119
    STZ                     $2118
    DEX
    BNE                     fontchar_NextZero
    CPY                     #$300
    BNE                     fontchar_loop

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
    STZ                     CursorX
    STZ                     CursorY

    LDA                     #<txtHelloWorld
    STA                     z_L
    LDA                     #>txtHelloWorld
    STA                     z_H
    LDA                     #txtHelloWorld>>16
    STA                     z_HLU

    JSR                     PrintString

infloop:
    JMP                     infloop

txtHelloWorld:
	.DB                     "Hello WorlD", 255

PrintString:
    LDY                     #0

PrintString_again:
    LDA                     [z_HL], y
    CMP                     #255
    BEQ                     PrintString_Done
    JSR                     PrintChar
    INY
    JMP                     PrintString_again

PrintString_Done:
    RTS

PrintChar:
    AND                     #%11011111
    BEQ                     PrintCharSpace
    SEC
    SBC                     #64

PrintCharSpace:
    PHA
        LDX                 z_HL
        PHX
            LDA             CursorY
            STA             z_H

            LDA             #0
            CLC
            ROR             z_H
            ROR
            ROR             z_H
            ROR
            ROR             z_H
            ROR
            ADC             CursorX
            STA             z_L

WaitVblank:
            LDA             $4212
            AND             #%10000000
            BEQ             WaitVblank
            LDX             z_HL
            STX             $2116
            STZ             $2119
        PLX
        STX                 z_HL
    PLA
    STA                     $2118

    INC                     CursorX
    RTS

; ==========================================================================
;                              * BITMAP FONT *                             ;
; ==========================================================================
BitmapFont:
    .DB                     $00, $00, $00, $00, $00, $00, $00, $00          ;SPACE
	.DB                     $18, $3C, $66, $66, $7E, $66, $24, $00          ;A
	.DB                     $3C, $66, $66, $7C, $66, $66, $3C, $00          ;B
	.DB                     $38, $7C, $C0, $C0, $C0, $7C, $38, $00          ;C
	.DB                     $3C, $64, $66, $66, $66, $64, $38, $00          ;D
	.DB                     $3C, $7E, $60, $78, $60, $7E, $3C, $00          ;E
	.DB                     $38, $7C, $60, $78, $60, $60, $20, $00          ;F
	.DB                     $3C, $66, $C0, $C0, $CC, $66, $3C, $00          ;G
	.DB                     $24, $66, $66, $7E, $66, $66, $24, $00          ;H
	.DB                     $10, $18, $18, $18, $18, $18, $08, $00          ;I
	.DB                     $08, $0C, $0C, $0C, $4C, $FC, $78, $00          ;J
	.DB                     $24, $66, $6C, $78, $6C, $66, $24, $00          ;K
	.DB                     $20, $60, $60, $60, $60, $7E, $3E, $00          ;L
	.DB                     $44, $EE, $FE, $D6, $D6, $D6, $44, $00          ;M
	.DB                     $44, $E6, $F6, $DE, $CE, $C6, $44, $00          ;N
	.DB                     $38, $6C, $C6, $C6, $C6, $6C, $38, $00          ;O
	.DB                     $38, $6C, $64, $7C, $60, $60, $20, $00          ;P
	.DB                     $38, $6C, $C6, $C6, $CA, $74, $3A, $00          ;Q
	.DB                     $3C, $66, $66, $7C, $6C, $66, $26, $00          ;R
	.DB                     $3C, $7E, $60, $3C, $06, $7E, $3C, $00          ;S
	.DB                     $3C, $7E, $18, $18, $18, $18, $08, $00          ;T
	.DB                     $24, $66, $66, $66, $66, $66, $3C, $00          ;U
	.DB                     $24, $66, $66, $66, $66, $3C, $18, $00          ;V
	.DB                     $44, $C6, $D6, $D6, $FE, $EE, $44, $00          ;W
	.DB                     $C6, $6C, $38, $38, $6C, $C6, $44, $00          ;X
	.DB                     $24, $66, $66, $3C, $18, $18, $08, $00          ;Y
	.DB                     $7C, $FC, $0C, $18, $30, $7E, $7C, $00          ;Z

.ORG $FFFA		
	.DW $0000				
	.DW $8000 				
	.DW $0000 				
	