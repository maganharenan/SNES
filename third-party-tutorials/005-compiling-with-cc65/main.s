; ==========================================================================
; File: main.s
; Description: First SNES game using the assembler cc65. For this project
; I will follow the tutorial in the Snes Assembly Adventure site.
; https://georgjz.github.io/snesaa01/
; ==========================================================================

; ==========================================================================
; Assembler Directives
; ==========================================================================
.p816                                ; This will be a 65816 code
.i16                                ; X and Y registers are 16 bit
.a8                                 ; A register is 8 bit

; ==========================================================================
; Init System
; ==========================================================================
.segment "CODE"
.proc ResetHandler              ; Program entry point
    sei                         ; Disable interruptor
    clc                         ; Clear the carry flag
    xce                         ; Switch to native mode

    lda #$81
    sta $4200

    ; Set screen color to red
    stz $2121
    lda #%00011111
    sta $2122
    stz $2122

    lda $0F
    sta $2100

    jmp GameLoop
.endproc

.proc GameLoop
    wai                         ; Wait for NMI
    jmp GameLoop  
.endproc

.proc NMIHandler                ; Called every frame/V-blank
    lda $4210
    rti
.endproc

; ==========================================================================
; Interrupt and Reset vectors for the 65816 CPU
; ==========================================================================
.segment "VECTOR"
; native mode   COP,        BRK,        ABT,
.addr           $0000,      $0000,      $0000
;               NMI,        RST,        IRQ
.addr           NMIHandler, $0000,      $0000

.word           $0000, $0000    ; four unused bytes

; emulation m.  COP,        BRK,          ABT,
.addr           $0000,      $0000,        $0000
;               NMI,        RST,          IRQ
.addr           $0000 ,     ResetHandler, $0000