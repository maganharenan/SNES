; ---- Aliases/Label --------------------------------------------------------------
; these are aliases for the Memory Mapped Registers
INIDSP          = $2100         ; inital settings for screen
OBJSEL          = $2101         ; object size $ object data area designation
OAMADDL         = $2102         ; address for accessing OAM
OAMADDH         = $2103
OAMDATA         = $2104         ; data for OAM write
VMAINC          = $2115         ; VRAM address increment value designation
VMADDL          = $2116
VMADDH          = $2117
VMDATAL         = $2118         ; data for VRAM write
VMDATAH         = $2119
CGADD           = $2121         ; address for CGRAM read and write
CGDATA          = $2122         ; data for CGRAM write
TM              = $212c         ; main screen designation
NMITIMEN        = $4200         ; enable flaog for v-blank
MDMAEN          = $420b         ; DMA enable register
RDNMI           = $4210         ; read the NMI flag status
DMAP0           = $4300         ; DMA control register, channel 0
BBAD0           = $4301         ; DMA destination register, channel 0
A1T0L           = $4302         ; DMA source address register low, channel 0
A1T0H           = $4303         ; DMA source address register high, channel 0
A1T0B           = $4304         ; DMA source address register bank, channel 0
DAS0L           = $4305         ; DMA size register low, channel 0
DAS0H           = $4306         ; DMA size register high, channel 0
; ---------------------------------------------------------------------------------

; ---- Memory Map WRAM ------------------------------------------------------------
HOR_SPEED       = $0300
VER_SPEED       = $0301
OAMMIRROR       = $0400         ; location of OAMRAM mirror in WRAM
; ---------------------------------------------------------------------------------

; ---- Game Constants -------------------------------------------------------------
SCREEN_LEFT     = $00
SCREEN_RIGHT    = $FF
SCREEN_TOP      = $00
SCREEN_BOTTOM   = $DF
SPRITE_SPEED    = $02
SPRITE_SIZE     = $08
OAMMIRROR_SIZE  = $0220         ; OAMRAM can hold data for 128 sprites, 4 bytes each
; ---------------------------------------------------------------------------------

; ---- Assembler Directives -------------------------------------------------------
.p816
; ---------------------------------------------------------------------------------

; ---- Includes -------------------------------------------------------------------
.segment "SPRITEDATA"
SpriteData:     .incbin "soldier.bin"
ColorData:      .incbin "soldier.pal"
; ---------------------------------------------------------------------------------

; ---- Program --------------------------------------------------------------------
.segment "CODE"
.proc   ResetHandler
        sei
        clc
        xce
        rep #$10            ; set X and Y to 16-bit
        sep #$20            ; set A to 8-bit
        lda     #$8F            ; force v-blanking
        sta     INIDSP
        stz     NMITIMEN        ; disable NMI

        ldx     #$1FFF          ; load X with $1fff
        txs                     ; copy X to stack pointer

LoadSpritesIntoVRAM:
        tsx                     ; save current stack pointer
        pea     $0000           ; push VRAM destination address to stack
        pea     SpriteData      ; push sprite source address to stack
        lda     #$0300          ; push number of bytes (768/$300) to transfer to stack
        pha
        jsr     LoadVRAM
        txs                     ; "delete" data on stack by restoring old stack pointer

LoadColorsIntoCGRAM:
        tsx                     ; save current stack pointer
        lda     #$80            ; push CGRAM destination address to stack
        pha
        pea     ColorData       ; push color source address to stack
        lda     #$20            ; push number of bytes (32/$20) to transfer to stack
        pha
        jsr     LoadCGRAM       ; transfer color data into CGRAM
        txs                     ; "delete" data on stack by restoring old stack pointer

SetupOAMMirror:
        ldx     #$00

        ; Upper-left sprite
        lda     #(SCREEN_RIGHT/2 - SPRITE_SIZE)         ; Horizontal Position
        sta     OAMMIRROR, X
        inx
        lda     #(SCREEN_BOTTOM/2 - SPRITE_SIZE)        ; Vertical Position
        sta     OAMMIRROR, X
        inx
        lda     #$00                                    ; Sprite name
        sta     OAMMIRROR, X
        inx
        lda     #$00                                    ; no flip, palette 0
        sta     OAMMIRROR, X
        inx
        ; upper-right sprite
        lda #(SCREEN_RIGHT/2)               ; sprite 3, horizontal position
        sta OAMMIRROR, X
        inx                                 ; increment index
        lda #(SCREEN_BOTTOM/2 - SPRITE_SIZE); sprite 3, vertical position
        sta OAMMIRROR, X
        inx
        lda #$01                            ; sprite 3, name
        sta OAMMIRROR, X
        inx
        lda #$00                            ; no flip, palette 0
        sta OAMMIRROR, X
        inx
        ; lower-left sprite
        lda #(SCREEN_RIGHT/2 - SPRITE_SIZE) ; sprite 2, horizontal position
        sta OAMMIRROR, X
        inx                                 ; increment index
        lda #(SCREEN_BOTTOM/2)              ; sprite 2, vertical position
        sta OAMMIRROR, X
        inx
        lda #$02                            ; sprite 2, name
        sta OAMMIRROR, X
        inx
        lda #$00                            ; no flip, palette 0
        sta OAMMIRROR, X
        inx
        ; lower-right sprite
        lda #(SCREEN_RIGHT/2)                ; sprite 4, horizontal position
        sta OAMMIRROR, X
        inx                                 ; increment index
        lda #(SCREEN_BOTTOM/2)              ; sprite 4, vertical position
        sta OAMMIRROR, X
        inx
        lda #$03                            ; sprite 4, name
        sta OAMMIRROR, X
        inx
        lda #$00                            ; no flip, palette 0
        sta OAMMIRROR, X
        inx

        ; move the other sprites off screen
        lda #$ff                ; set the coordinates to (255, 255), which is off screen

OAMLoop:
        sta OAMMIRROR, X
        inx
        cpx #OAMMIRROR_SIZE
        bne OAMLoop

        ; correct extra OAM byte for first four sprites
        ldx #$0200
        lda #$00
        sta OAMMIRROR, X

        ; set initial horizontal and vertical speed
        lda #SPRITE_SPEED
        sta HOR_SPEED
        sta VER_SPEED

        ; .byte $42, $00          ; debugger breakpoint

        ; make Objects visible
        lda #$10
        sta TM
        ; release forced blanking, set screen to full brightness
        lda #$0f
        sta INIDISP
        ; enable NMI, turn on automatic joypad polling
        lda #$81
        sta NMITIMEN

        jmp     GameLoop
.endproc
; ---------------------------------------------------------------------------------

; ---- Game Loop ------------------------------------------------------------------
.proc   GameLoop
        wai                     ; Wait for NMI / VBlank

        .byte   $42, $00        ; Debugger breakpoint

        jmp     GameLoop
.endproc

; ---- NMI Handler ----------------------------------------------------------------
.proc   NMIHandler
        lda RDNMI               ; read NMI status, acknowledge NMI

        ; this is where we would do graphics update
        tsx                     ; save old stack pointer
        pea OAMMIRROR           ; push mirror address to stack
        jsr UpdateOAMRAM        ; update OAMRAM
        txs                     ; restore old stack pointer

        rti
.endproc
; ---------------------------------------------------------------------------------

; ---- IRQ Handler ----------------------------------------------------------------
.proc   IRQHandler
        ; code
        rti
.endproc
; ---------------------------------------------------------------------------------

; ---- Load sprite data into VRAM -------------------------------------------------
;   Parameters: NumBytes: .byte, SrcPointer: .addr, DestPointer: .addr
; ---------------------------------------------------------------------------------
.proc   LoadVRAM
        phx                     ; save old stack pointer

        ; create frame pointer
        phd                     ; push Direct Register to stack
        tsc                     ; transfer Stack to... (via Accumulator)
        tcd                     ; ...Direct Register.

        ; use constants to access arguments on stack with Direct Addressing
        NumBytes    = $07       ; number of bytes to transfer
        SrcPointer  = $08       ; source address of sprite data
        DestPointer = $0a       ; destination address in VRAM

        ; set destination address in VRAM, and address increment after writing to VRAM
        ldx     DestPointer     ; load the destination pointer...
        stx     VMADDL          ; ...and set VRAM address register to it
        lda     #$80
        sta     VMAINC          ; increment VRAM address by 1 when writing to VMDATAH

        ; loop through source data and transfer to VRAM
        ldy     #$0000          ; set register Y to zero, we will use Y as a loop counter and offset

VRAMLoop:
        lda     (SrcPointer, S), Y      ; get bitplane 0/2 byte from the sprite data
        sta     VMDATAL
        iny 
        lda     (SrcPointer, S), Y      ; get bitplane 1/3 byte from the sprite data

        sta     VMDATAH                 ; write the byte in A to VRAM
        iny
        cpy     NumBytes                ; check whether we have written $04 * $20 = $80 bytes to VRAM (four sprites)
        bcc     VRAMLoop                ; if X is smaller than $80, continue the loop

        ; all done
        pld                     ; restore caller's frame pointer
        plx                     ; restore old stack pointer
        rts
.endproc
; ---------------------------------------------------------------------------------

; ---- Load color data into CGRAM -------------------------------------------------
;   NumBytes: .byte, SrcPointer: .byte, DestPointer: .addr
;----------------------------------------------------------------------------------
.proc   LoadCGRAM
        phx                     ; save old stack pointer

        ; create frame pointer
        phd                     ; push Direct Register to stack
        tsc                     ; transfer Stack to... (via Accumulator)

        ; use constants to access arguments on stack with Direct Addressing
        NumBytes    = $07       ; number of bytes to transfer
        SrcPointer  = $08       ; source address of sprite data
        DestPointer = $0a       ; destination address in VRAM

        ; set CGDRAM destination address
        lda     DestPointer     ; get destination address
        sta     CGADD           ; set CGRAM destination address

        ldy     #$0000          ; set Y to zero, use it as loop counter and offset
CGRAMLoop:
        lda (SrcPointer, S), Y  ; get the color low byte
        sta CGDATA              ; store it in CGRAM
        iny                     ; increase counter/offset
        lda (SrcPointer, S), Y  ; get the color high byte
        sta CGDATA              ; store it in CGRAM
        iny                     ; increase counter/offset
        cpy NumBytes            ; check whether 32/$20 bytes were transfered
        bcc CGRAMLoop           ; if not, continue loop

        ; all done
        pld                     ; restore caller's frame pointer
        plx                     ; restore old stack pointer
        rts
.endproc
;----------------------------------------------------------------------------------

; ---- Interrupt and Reset vectors for the 65816 CPU ------------------------------
.segment "VECTOR"
; native mode   COP,        BRK,        ABT,
.addr           $0000,      $0000,      $0000
;               NMI,        RST,        IRQ
.addr           NMIHandler, $0000,      $0000

.word           $0000, $0000    ; four unused bytes

; emulation m.  COP,        BRK,        ABT,
.addr           $0000,      $0000,      $0000
;               NMI,        RST,        IRQ
.addr           $0000,      ResetHandler, $0000
;-------------------------------------------------------------------------------