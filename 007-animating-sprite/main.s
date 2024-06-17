; ==========================================================================
; Aliases/Labels
; ==========================================================================

; these are aliases for the used Memory Mapped Registers
INIDSP          = $2100         ; Initial settings for the screen
OBJSEL          = $2101         ; Object Size $ object data area designation
OAMADDL         = $2102         ; Adress for acessing OAM
OAMADDH         = $2103
OAMDATA         = $2104         ; Data for OAM write
VMAINC          = $2115         ; VRAM address increment value designation
VMADDL          = $2116         ; Adress for VRAM read and write
VMADDH          = $2117
VMDATAL         = $2118         ; Data for VRAM write
VMDATAH         = $2119         ; Data for VRAM write
CGADD           = $2121         ; Address for CGRAM read and write
CGDATA          = $2122         ; Data for CGRAM write
TM              = $212c         ; Main screen designation
NMITIMEN        = $4200         ; Enable flag for V-Blank
RDNMI           = $4210         ; Read the NMI flag status

; ==========================================================================
; Assembler Directives
; ==========================================================================
.p816                           ; Set the assembler to 65816 code

; ==========================================================================
; Includes
; ==========================================================================
.segment "SPRITEDATA"
SpriteData:     .incbin "sprite.bin"
ColorData:      .incbin "sprite.pal"

; ==========================================================================
; Initialization
; ==========================================================================
.proc   ResetHandler
        sei
        clc
        xce
        lda     #$8f
        sta     INIDSP
        stz     NMITIMEN

        ; Transfer VRAM Data
        stz     VMADDL
        stz     VMADDH
        lda     #$80
        sta     VMAINC
        ldx     #$00
VRAMLoop:
        lda     SpriteData, X   ; Get bitplane 0/2 byte from the sprite data
        sta     VMDATAL         ; Write the byte in A to VRAM
        inx                     ; Increment counter/offset
        lda     SpriteData, X   ; Get bitplane 1/3 byte from the sprite data
        sta     VMDATAH         ; Write the byte in A to VRAM
        inx                     ; Increment counter/offset
        cpx     #$C0            ; Check whether we have written $18 * $20 = $120 bytes to VRAM (four sprites)
        bcc     VRAMLoop        ; If X is smaller than $80, continue the loop

        ; Transfer CGRAM data
        lda     #$80
        sta     CGADD
        ldx     #$00
CGRAMLoop:
        lda     ColorData, X    ; Get the color low byte
        sta     CGDATA          ; Store it in CGRAM
        inx
        lda     ColorData, X    ; Get the color high byte
        sta     CGDATA
        inx
        cpx     #$20            ; Check whether 32/$20 bytes were transfered
        bcc     CGRAMLoop

        .byte $42, $00

        ; Setup OAM Data
        stz     OAMADDL
        stz     OAMADDH

        ; OAM Data for first sprite
        lda     # (256/2 - 8)   ; Horizontal position of first sprite
        sta     OAMDATA
        lda     # (224/2 - 8)   ; Vertical position of first sprite
        sta     OAMDATA
        lda     #$00            ; Name of first sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for second sprite
        lda     # (256/2)       ; horizontal position of second sprite
        sta     OAMDATA
        lda     # (224/2 - 8)   ; vertical position of second sprite
        sta     OAMDATA
        lda     #$01            ; name of second sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for third sprite
        lda     # (256/2 - 8)   ; horizontal position of third sprite
        sta     OAMDATA
        lda     # (224/2)       ; vertical position of third sprite
        sta     OAMDATA
        lda     #$02            ; name of third sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for fourth sprite
        lda     # (256/2)       ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     # (224/2)       ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$03            ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for fifth sprite
        lda     # (256/2 - 8)
        sta     OAMDATA
        lda     # (224/2 + 8)
        sta     OAMDATA
        lda     #$04
        sta     OAMDATA
        lda     #$00
        sta     OAMDATA

        ; OAM data for fifth sprite
        lda     # (256/2)
        sta     OAMDATA
        lda     # (224/2 + 8)
        sta     OAMDATA
        lda     #$05
        sta     OAMDATA
        lda     #$00
        sta     OAMDATA

        ; Make objects visible
        lda     #$10
        sta     TM

        ; Release forced blanking, set screen to full brightness
        lda     #$0f
        sta     INIDSP

        ; Enable NMI, turn on automatic joypad polling
        lda     #$81
        sta     NMITIMEN

        jmp     GameLoop
.endproc

; ==========================================================================
; Game Loop
; ==========================================================================
.proc   GameLoop
        wai                     ; Wait for NMI / VBlank

        ; Here we would place all of the game logic and loop forever

        jmp     GameLoop
.endproc

; ==========================================================================
; NMI Handler
; ==========================================================================
.proc   NMIHandler
        lda     RDNMI            ; read NMI status, acknowledge NMI

        ; This is where we would do graphics update

        rti
.endproc

; ==========================================================================
; IRQ Handler
; ==========================================================================
.proc   IRQHandler
        ; code
        rti
.endproc

; ==========================================================================
; Footer
; ==========================================================================
.segment "VECTOR"
; native mode   COP,        BRK,          ABT,
.addr           $0000,      $0000,        $0000
;               NMI,        RST,          IRQ
.addr           NMIHandler, $0000,        $0000

.word           $0000,      $0000    ; four unused bytes

; emulation m.  COP,        BRK,          ABT,
.addr           $0000,      $0000,        $0000
;               NMI,        RST,          IRQ
.addr           $0000,      ResetHandler, $0000