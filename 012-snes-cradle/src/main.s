; ------------------------------------------------------------------------------
;   File: JoypadSprite.s
;   Description: Displays a sprite that bounces off the edges
; ------------------------------------------------------------------------------

;----- Export ------------------------------------------------------------------
.export     ResetHandler        ; export the entry point of the demo
.export     NMIHandler
;-------------------------------------------------------------------------------

;----- Assembler Directives ----------------------------------------------------
.p816                           ; tell the assembler this is 65816 code
;-------------------------------------------------------------------------------

;----- Includes ----------------------------------------------------------------
.include        "assets.inc"
.include        "GameConstants.inc"
.include        "Init.inc"
.include        "InitSNES.inc"
.include        "Input.inc"
.include        "Joypad.inc"
.include        "MemoryMapWRAM.inc"
.include        "Registers.inc"
.include        "PPU.inc"
;-------------------------------------------------------------------------------

.segment "CODE"
;-------------------------------------------------------------------------------
;   This is the entry point of the demo
;-------------------------------------------------------------------------------
.proc   ResetHandler
        sei                     ; disable interrupts
        clc                     ; clear the carry flag
        xce                     ; switch the 65816 to native (16-bit mode)
        rep #$10                ; set X and Y to 16-bit
        sep #$20                ; set A to 8-bit
        lda #$8f                ; force v-blanking
        sta INIDISP
        stz NMITIMEN            ; disable NMI
        ; set the stack pointer to $1fff
        ldx #$1fff              ; load X with $1fff
        txs                     ; copy X to stack pointer

        ; initialize SNES
        jsr ClearRegisters
        jsr ClearVRAM
        jsr ClearCGRAM
        jsr ClearOAMRAM

        jsr InitDemo
        jmp GameLoop
.endproc
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Executed during V-Blank
;-------------------------------------------------------------------------------
.proc   GameLoop
        wai                                 ; wait for NMI / V-Blank

        ; push addresses of joy pad data to stack
        ldx #JOYHELD1
        phx
        ldx #JOYTRIGGER1
        phx
        ldx #JOYRAW1
        phx
        jsr ReadJoypad1
        ; stack clean up
        plx
        plx
        plx

        ; push addresses of joypad 1 data to stack
        ldx #JOYHELD1
        phx
        ldx #JOYTRIGGER1
        phx
        ldx #JOYRAW1
        phx
        jsr HandleInput
        ; stack clean up
        plx
        plx
        plx

        jmp GameLoop
.endproc
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Will be called during V-Blank every frame
;-------------------------------------------------------------------------------
.proc   NMIHandler
        lda RDNMI               ; read NMI status, acknowledge NMI

        tsx                     ; save old stack pointer
        pea OAMMIRROR           ; push mirror address to stack
        jsr UpdateOAMRAM        ; update OAMRAM
        txs                     ; restore old stack pointer

        rti
.endproc
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Is not used in this program
;-------------------------------------------------------------------------------
.proc   IRQHandler
        ; code
        rti
.endproc
;-------------------------------------------------------------------------------