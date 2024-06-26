.MEMORYMAP
    SLOTSIZE $8000
    DEFAULTSLOT 0
    SLOT 0 $8000
.ENDME

.ROMBANKSIZE $8000
.ROMBANKS 8

.SNESHEADER
  ID "SNES"                     
  
  NAME "Background Color     "

  SLOWROM
  LOROM

  CARTRIDGETYPE $00
  ROMSIZE $08
  SRAMSIZE $00
  COUNTRY $01 
  LICENSEECODE $00  
  VERSION $00 
.ENDSNES

.SNESNATIVEVECTOR
  COP EmptyHandler
  BRK EmptyHandler
  ABORT EmptyHandler
  NMI EmptyHandler
  IRQ EmptyHandler
.ENDNATIVEVECTOR

.SNESEMUVECTOR
  COP EmptyHandler
  ABORT EmptyHandler
  NMI EmptyHandler
  RESET Start
  IRQBRK EmptyHandler
.ENDEMUVECTOR

.BANK 0 SLOT 0                 
.ORG 0                         
.SECTION "EmptyVectors" SEMIFREE

EmptyHandler:
    rti
.ENDS

.EMPTYFILL $00