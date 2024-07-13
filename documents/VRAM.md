``` asm
MEMORY
{
    WRAMPAGE:   start = $000000,    size = $1000;

    ROM0:       start = $008000,    size = $8000,   fill = yes;
    ROM1:       start = $018000,    size = $8000,   fill = yes;
    ROM2:       start = $028000,    size = $8000,   fill = yes;
    ROM3:       start = $038000,    size = $8000,   fill = yes;
}

SEGMENTS
{
    CODE:       load  = ROM0,       align = $100;
    SPRITEDATA: load  = ROM0,       align = $100;
    VECTOR:     load  = ROM0,       align = $00FFE4;
}
```

; ---- WRAMPAGE ----------------------------------------------------------------
; WRAMPAGE is a practical convention used in SNES development to allocate a 
; specific portion of WRAM for storing variables and temporary data. 
; This ensures organized memory usage, allowing your game to run efficiently by 
; keeping frequently accessed data in a well-defined memory segment. 
; The concept aligns with standard practices detailed in SNES development 
; literature, even if the exact term "WRAMPAGE" isn't explicitly used in the 
; books. 
; The structure and usage of WRAM are well-covered, highlighting the 
; importance of such memory segmentation.
;-------------------------------------------------------------------------------

; ---- VECTOR ------------------------------------------------------------------
; VECTOR segment is a convention in SNES programming, used to define interrupt 
; vectors and the reset vector. These vectors are critical for handling various 
; types of interrupts and for setting the initial execution address when the 
; system starts or resets.
;-------------------------------------------------------------------------------