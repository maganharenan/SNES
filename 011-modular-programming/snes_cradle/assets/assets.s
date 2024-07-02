; -----------------------------------------------------------------------------
;   File: assets.s
;   Description: Creates a segment for all assets and exports symbols to make
;   them accessible to other parts of the project.
; -----------------------------------------------------------------------------

; ---- Export -----------------------------------------------------------------
.export     SpriteData
.export     ColorData
; -----------------------------------------------------------------------------

; ---- Assset Data ------------------------------------------------------------
.segment "SPRITEDATA"
SpriteData: .incbin "sprite.bin"
ColorData: .incbin "sprite.pal"
; -----------------------------------------------------------------------------