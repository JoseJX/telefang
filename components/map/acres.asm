SECTION "Map Acre Gfx", ROMX[$5B64], BANK[$38]
MapAcreTilemap::
	db $0C,$0D,$0D,$0D,$0D,$0E,$0F,$0D,$10,$11,$12,$13,$14,$15,$16,$17
	db $19,$0D,$0D,$0D,$1A,$1B,$1C,$1D,$1E,$1F,$20,$0C,$21,$22,$23,$24
	db $0D,$0D,$0D,$0D,$0C,$25,$26,$27,$28,$21,$21,$21,$21,$29,$2A,$2B
	db $0D,$0D,$0D,$2C,$2D,$2E,$2F,$30,$31,$21,$21,$21,$21,$32,$33,$34
	db $21,$35,$0D,$36,$37,$38,$39,$3A,$3B,$21,$21,$21,$21,$0C,$3C,$3D
	db $3E,$3F,$40,$41,$42,$43,$44,$45,$0C,$21,$21,$21,$21,$46,$47,$48
	db $49,$21,$4A,$4B,$4C,$4D,$4E,$4F,$50,$21,$21,$21,$21,$51,$0C,$52
	db $53,$21,$54,$55,$56,$57,$58,$59,$5A,$0C,$5B,$5C,$5D,$58,$59,$5A
	db $5E,$21,$5F,$60,$61,$62,$63,$64,$63,$65,$66,$67,$68,$69,$0C,$6A
	db $0C,$0C,$6B,$6C,$0C,$A6,$A6,$A6,$A6,$6D,$0C,$6E,$6F,$70,$71,$72
	db $73,$74,$75,$76,$77,$A6,$21,$21,$A6,$78,$79,$7A,$7B,$7C,$7D,$7E
	db $7F,$80,$81,$A6,$A6,$A6,$21,$21,$A6,$82,$7D,$83,$84,$85,$86,$87
	db $88,$89,$8A,$A6,$21,$21,$21,$21,$8B,$8C,$7D,$8D,$8E,$8F,$90,$91
	db $0C,$92,$0C,$A6,$21,$21,$21,$21,$8B,$93,$7D,$94,$A6,$A6,$95,$A7
	db $96,$97,$98,$A6,$99,$9A,$0C,$21,$8B,$9B,$7D,$9C,$A6,$A6,$95,$23
	db $58,$9D,$5A,$A6,$9E,$9F,$A0,$A1,$8B,$A2,$A3,$A4,$A6,$A6,$A5,$A6

MapAcreAttribmap::
	db 1,0,0,0,0,0,0,0,0,0,0,0,0,4,5,4
	db 0,0,0,0,0,0,0,0,0,1,1,1,1,4,5,4
	db 0,0,0,0,1,0,0,0,0,1,1,1,1,4,3,4
	db 0,0,0,5,1,0,0,0,0,1,1,1,4,4,4,4
	db 0,0,0,5,1,1,1,1,1,1,1,4,1,1,4,1
	db 2,2,0,4,1,0,0,1,1,1,4,1,1,1,4,1
	db 2,2,4,4,1,1,1,0,0,1,1,1,4,1,1,1
	db 2,2,4,1,1,1,1,1,1,1,0,0,0,1,1,1
	db 2,2,4,1,1,5,5,5,5,0,0,0,0,0,1,0
	db 1,1,4,1,1,3,3,3,3,1,1,0,0,0,1,1
	db 1,1,4,1,1,3,1,1,3,1,1,0,0,1,1,1
	db 1,1,4,3,3,3,1,1,3,1,1,0,0,1,1,5
	db 4,4,4,3,1,1,1,1,4,1,1,5,5,5,5,5
	db 1,1,1,3,1,1,1,1,4,1,1,5,3,3,3,3
	db 1,4,1,3,5,5,1,1,4,1,1,5,3,3,3,5
	db 1,1,1,3,5,5,5,5,4,1,1,5,3,3,3,3

MapBackgroundSGBGfx::
	INCBIN "build/components/map/background_sgbtiles.2bpp"

MapAcreGfxOld::
	; Note: Free Space
	REPT $990
	nop
	ENDR

SECTION "Map Indicator Gfx", ROMX[$67C4], BANK[$38]
MapCursorGfx::
	INCBIN "build/components/map/cursor.2bpp"

MapIndicatorGfx::
	INCBIN "build/components/map/indicator.2bpp"

SECTION "Map Background Gfx", ROMX[$6ED4], BANK[$38]
MapBackgroundGfx::
	INCBIN "build/components/map/background_tiles.2bpp"

SECTION "Map Acre Gfx 2", ROMX[$6000], BANK[$77]
MapAcreGfxA::
	INCBIN "build/components/map/acre_tiles1.2bpp"

MapAcreGfxB::
	INCBIN "build/components/map/acre_tiles2.2bpp"

MapAcreSGBGfxA::
	INCBIN "build/components/map/acre_sgbtiles1.2bpp"

MapAcreSGBGfxB::
	INCBIN "build/components/map/acre_sgbtiles2.2bpp"
