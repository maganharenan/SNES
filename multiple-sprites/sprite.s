; ==========================================================================
; Aliases/Labels
; ==========================================================================

; these are aliases for the used Memory Mapped Registers
INIDSP          = $2100         ; Initial settings for the screen
OBJSEL          = $2101         ; Object Size $ object data area designation
OAMADDL         = $2102         ; Address for accessing OAM
OAMADDH         = $2103
OAMDATA         = $2104         ; Data for OAM write
VMAINC          = $2115         ; VRAM address increment value designation
VMADDL          = $2116         ; Address for VRAM read and write
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
.p816

; ==========================================================================
; Includes
; ==========================================================================
.segment "SPRITEDATA"
SpriteData:     .incbin "sprite.bin"
ColorData:      .incbin "sprite.pal"

; ==========================================================================
; Init System
; ==========================================================================
.segment "CODE"
.proc   ResetHandler
        sei
        clc
        xce
        rep     #$10                ; set X and Y to 16-bit
        sep     #$20                ; set A to 8-bit

        lda     #$8F
        sta     NMITIMEN

        stz     CGADD
        lda     #%00000001
        sta     CGDATA
        stz     CGDATA

        lda     $0F
        sta     INIDSP

PrepareToHandleVRAM:
        stz     VMADDL
        stz     VMADDH
        lda     #$00C0           ; Increment VRAM address after each write
        sta     VMAINC

        ldx     #$0000

VRAMLoop:
        lda     SpriteData, X   ; Get bitplane 0/2 byte from the sprite data
        sta     VMDATAL         ; Write the byte in A to VRAM
        inx                     ; Increment counter/offset
        lda     SpriteData, X   ; Get bitplane 1/3 byte from the sprite data
        sta     VMDATAH         ; Write the byte in A to VRAM
        inx                     ; Increment counter/offset
        cpx     #$0300          ; Check whether we have written $18 * $20 = $120 bytes to VRAM (four sprites)
        bcc     VRAMLoop        ; If X is smaller than $C0, continue the loop

PrepareToHandleCGRAM:
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
        cpx     #$20          ; Check whether 32/$20 bytes were transferred
        bcc     CGRAMLoop

        .byte $42, $00

SetupOAMData:
        stz     OAMADDL
        stz     OAMADDH

        ; ===============================================================
        ; 1ST OBJ
        ; ===============================================================

        ; OAM Data for first sprite
        lda     #(256/2 - 8 - 32)    ; Horizontal position of first sprite
        sta     OAMDATA
        lda     #(224/2 - 8)    ; Vertical position of first sprite
        sta     OAMDATA
        lda     #$0000            ; Name of first sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for second sprite
        lda     #(256/2 - 32)        ; horizontal position of second sprite
        sta     OAMDATA
        lda     #(224/2 - 8)    ; vertical position of second sprite
        sta     OAMDATA
        lda     #$0001          ; name of second sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for third sprite
        lda     #(256/2 - 8 - 32)    ; horizontal position of third sprite
        sta     OAMDATA
        lda     #(224/2)        ; vertical position of third sprite
        sta     OAMDATA
        lda     #$0002          ; name of third sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for fourth sprite
        lda     #(256/2 - 32)        ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2)        ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$0003          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for fifth sprite
        lda     #(256/2 - 8 - 32)        ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2 + 8)        ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$0004          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for sixth sprite
        lda     #(256/2 - 32)        ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2 + 8)        ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$0005          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; ===============================================================
        ; 2ND OBJ
        ; ===============================================================

        ; OAM Data for first sprite
        lda     #(256/2 - 16)    ; Horizontal position of first sprite
        sta     OAMDATA
        lda     #(224/2 - 8)    ; Vertical position of first sprite
        sta     OAMDATA
        lda     #$0006            ; Name of first sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for second sprite
        lda     #(256/2 - 8)        ; horizontal position of second sprite
        sta     OAMDATA
        lda     #(224/2 - 8)        ; vertical position of second sprite
        sta     OAMDATA
        lda     #$0007          ; name of second sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for third sprite
        lda     #(256/2 - 16)    ; horizontal position of third sprite
        sta     OAMDATA
        lda     #(224/2)        ; vertical position of third sprite
        sta     OAMDATA
        lda     #$0008          ; name of third sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for fourth sprite
        lda     #(256/2 - 8)        ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2)        ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$0009          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for fifth sprite
        lda     #(256/2 - 16)   ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2 + 8)    ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$000A          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for sixth sprite
        lda     #(256/2 - 8)   ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2 + 8)    ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$000B          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; ===============================================================
        ; 3RD OBJ
        ; ===============================================================

        ; OAM Data for first sprite
        lda     #(256/2 + 8)    ; Horizontal position of first sprite
        sta     OAMDATA
        lda     #(224/2 - 8)    ; Vertical position of first sprite
        sta     OAMDATA
        lda     #$000C            ; Name of first sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for second sprite
        lda     #(256/2 + 16)        ; horizontal position of second sprite
        sta     OAMDATA
        lda     #(224/2 - 8)        ; vertical position of second sprite
        sta     OAMDATA
        lda     #$000D          ; name of second sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for third sprite
        lda     #(256/2 + 8)    ; horizontal position of third sprite
        sta     OAMDATA
        lda     #(224/2)        ; vertical position of third sprite
        sta     OAMDATA
        lda     #$000E          ; name of third sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for fourth sprite
        lda     #(256/2 + 16)        ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2)        ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$000F          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for fifth sprite
        lda     #(256/2 + 8)   ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2 + 8)    ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$0010          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for sixth sprite
        lda     #(256/2 + 16)   ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2 + 8)    ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$0011          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; ===============================================================
        ; 4TH OBJ
        ; ===============================================================

        ; OAM Data for first sprite
        lda     #(256/2 + 32)    ; Horizontal position of first sprite
        sta     OAMDATA
        lda     #(224/2 - 8)    ; Vertical position of first sprite
        sta     OAMDATA
        lda     #$0012            ; Name of first sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for second sprite
        lda     #(256/2 + 40)        ; horizontal position of second sprite
        sta     OAMDATA
        lda     #(224/2 - 8)        ; vertical position of second sprite
        sta     OAMDATA
        lda     #$0013          ; name of second sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for third sprite
        lda     #(256/2 + 32)    ; horizontal position of third sprite
        sta     OAMDATA
        lda     #(224/2)        ; vertical position of third sprite
        sta     OAMDATA
        lda     #$0014          ; name of third sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for fourth sprite
        lda     #(256/2 + 40)        ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2)        ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$0015          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for fifth sprite
        lda     #(256/2 + 32)   ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2 + 8)    ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$0016          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; OAM data for sixth sprite
        lda     #(256/2 + 40)   ; horizontal position of fourth sprite
        sta     OAMDATA
        lda     #(224/2 + 8)    ; vertical position of fourth sprite
        sta     OAMDATA
        lda     #$0017          ; name of fourth sprite
        sta     OAMDATA
        lda     #$00            ; no flip, prio 0, palette 0
        sta     OAMDATA

        ; Make objects visible
        lda     #$10
        sta     TM

        ; Release forced blanking, set screen to full brightness
        lda     #$0F
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
        lda     RDNMI                ; Read NMI status, acknowledge NMI

        rti                      ; Return from interrupt
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