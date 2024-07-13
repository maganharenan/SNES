; ------------------------------------------------------------------------------
;   File: Main.s
;   Description: Contains the main logic of the program
; ------------------------------------------------------------------------------

; ---- Export ------------------------------------------------------------------
.export ResetHandler
.export NMIHandler
; ------------------------------------------------------------------------------

; ---- Assembler Directives ----------------------------------------------------
.p816
; ------------------------------------------------------------------------------

; ---- Includes ----------------------------------------------------------------
.include        "assets.inc"
.include        "GameConstants.inc"
.include        "Init.inc"
.include        "InitSNES.inc"
.include        "Input.inc"
.include        "Joypad.inc"
.include        "MemoryMapWRAM.inc"
.include        "Registers.inc"
.include        "PPU.inc"
; ------------------------------------------------------------------------------

.segment "CODE"
; ---- Reset Handler -----------------------------------------------------------
.proc   ResetHandler
        sei
        clc
        xce
        rep     #$10
        sep     #$20
        lda     #$8F
        sta     INIDISP
        stz     NMITIMEN

        ldx     #$1FFF
        txs

        jsr     ClearRegisters
        jsr     ClearVRAM
        jsr     ClearCGRAM
        jsr     ClearOAMRAM

        jsr     InitDemo
        jmp     GameLoop
.endproc
; ------------------------------------------------------------------------------

; ---- Game Loop ---------------------------------------------------------------
.proc   GameLoop
        wai

        jmp     GameLoop
.endproc
; ------------------------------------------------------------------------------

; ---- NMI Handler -------------------------------------------------------------
.proc   NMIHandler
        lda     RDNMI

        tsx
        pea     OAMMIRROR
        jsr     UpdateOAMRAM
        txs

        rti
.endproc
; ------------------------------------------------------------------------------

; ---- IRQ Handler -------------------------------------------------------------
.proc   IRQHandler
        rti
.endproc
; ------------------------------------------------------------------------------