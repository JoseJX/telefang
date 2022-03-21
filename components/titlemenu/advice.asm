INCLUDE "telefang.inc"

SECTION "Menu - Name Entry Underscore Gfx", ROMX[$4200], BANK[$62]
TitleMenu_UnderscoreGfx::
    INCBIN "build/components/titlemenu/resources/text_entry_underscores.2bpp"

TitleMenu_UnderscoreDMGGfx::
    INCBIN "build/components/titlemenu/resources/text_entry_underscores_dmg.2bpp"

SECTION "Title Menu Underscore Gfx Loader", ROMX[$7DD2], BANK[$4]
TitleMenu_ADVICE_LoadUnderscoreGfx::
    call PauseMenu_SelectTextStyle
    ld hl, $9600
    ld de, TitleMenu_UnderscoreGfx
    call TitleMenu_ADVICE_CanUseCGBTiles
    jr z, .loadGraphic
    ld e, TitleMenu_UnderscoreDMGGfx & $FF

.loadGraphic
    ld a, BANK(TitleMenu_UnderscoreGfx)
    ld bc, $50
    jp Banked_LCDC_LoadTiles

SECTION "TitleMenu Check If Either SGB or CGB", ROMX[$5A8B], BANK[$4]
TitleMenu_ADVICE_CanUseCGBTiles::
; Sets the z flag if in CGB or SGB mode.
    ld a, [W_SGB_DetectSuccess]
    dec a
    ret z
    ld a, [W_GameboyType]
    cp M_BIOS_CPU_CGB
    ret
    nop
    nop
    nop

;TODO: Move all the above advice into this section
SECTION "Title Menu Aux-Code Advice", ROMX[$4340], BANK[$1]
TitleMenu_ADVICE_StateLoadGraphics::
    M_AdviceSetup
    
    call ClearGBCTileMap0
    call ClearGBCTileMap1
    call LCDC_ClearMetasprites
    
    nop
    nop
    call TitleMenu_ADVICE_CanUseCGBTiles_Alt
    jr z, .cgbGfx
    
.dmgGfx
    ld bc, $5E
    call Banked_LoadMaliasGraphics
    ld bc, $55
    call Banked_LoadMaliasGraphics
    jr .advice_exit

.cgbGfx
    ld bc, $5D
    call Banked_LoadMaliasGraphics
    ld bc, $1B
    call Banked_LoadMaliasGraphics
    
.advice_exit
    M_AdviceTeardown
    ret

TitleMenu_ADVICE_LoadSGBFiles::
    M_AdviceSetup
    
    ld a, $32
    call Sound_IndexMusicSetBySong
    ld [W_Sound_NextBGMSelect], a
	
TitleMenu_ADVICE_LoadSGBFiles_externalEntry::
	 
    call PauseMenu_ADVICE_CheckSGB
    jr z, .return

    ; Reset the text style in case the link menu dumps us here after an interrupted connection.
    xor a
    ld [W_MainScript_TextStyle], a

    ;Load our ATF
    ld c, 3
    call Banked_SGB_ConstructATFSetPacket
    
    call PauseMenu_ADVICE_CGBToSGB02Shorthand
    call PauseMenu_ADVICE_CGBToSGB56Shorthand
    
.return
    M_AdviceTeardown
    ret
    
TitleMenu_ADVICE_LoadSGBFilesSoundTest::
    M_AdviceSetup
    
    ld a, 4
    ld [W_PauseMenu_SelectedCursorType], a
	
TitleMenu_ADVICE_LoadSGBFilesSoundTest_externalEntry::
    
    ld c, 6
    call Banked_SGB_ConstructATFSetPacket
    
    M_AdviceTeardown
    ret
    
TitleMenu_ADVICE_UnloadSGBFilesSoundTest::
    M_AdviceSetup
    
    ld a, M_TitleMenu_StateMenuInputHandler
    ld [W_SystemSubState], a
    
    ld c, 3
    call Banked_SGB_ConstructATFSetPacket
    
    M_AdviceTeardown
    ret
    
TitleMenu_ADVICE_UnloadSGBFilesOverworld::
    M_AdviceSetup
    
    ld a, 5
    ld [W_SystemState], a
    
    ;Load a neutral ATF
    xor a
    ld b, a
    ld c, a
    ld d, a
    ld e, a
    call Banked_SGB_ConstructPaletteSetPacket
    
    M_AdviceTeardown
    ret
    
TitleMenu_ADVICE_CanUseCGBTiles_Alt::
; A bank 1 copy of TitleMenu_ADVICE_CanUseCGBTiles.
    ld a, [W_SGB_DetectSuccess]
    dec a
    ret z
    ld a, [W_GameboyType]
    cp M_BIOS_CPU_CGB
    ret

SECTION "Title Menu Aux-Code Advice 2", ROMX[$5560], BANK[$1]
TitleMenu_ADVICE_LoadSGBFilesTimeInput::
    M_AdviceSetup
    ld a, 5
    ld [W_PauseMenu_SelectedCursorType], a
    jp TitleMenu_ADVICE_LoadSGBFilesSoundTest_externalEntry

SECTION "Title Menu Aux-Code Advice 3", ROMX[$5D30], BANK[$1]
TitleMenu_ADVICE_Nickname_RedrawTiles::
	di

.wfb
	ldh a, [REG_STAT]
	and $40		; fix
	jr nz, .wfb

	ld a, [hli]
	ld [hli], a
	ld a, [hli]
	ld [hli], a
	ei
	dec b
	jr nz, TitleMenu_ADVICE_Nickname_RedrawTiles
	ret

TitleMenu_ADVICE_Nickname_RemapBlankTiles::
	ld hl, $9921
	ld de, $FF18
	ld c, 3

.rowloop
	ld b, 8

.maploop
	di

.wfb
	ldh a, [REG_STAT]
	and $40		; fix
	jr nz, .wfb

	ld a, [hl]
	cp $D0
	jr nz, .ignore

	ld a, d
	ld [hl], a

.ignore
	ei
	inc hl
	dec b
	jr nz, .maploop

	ld a, e
	add l
	ld l, a
	dec c
	jr nz, .rowloop
	ret

TitleMenu_ADVICE_Nickname_RemapTilesToBlank::
	ld bc, $4FF

.maploop
	di

.wfb
	ldh a, [REG_STAT]
	and $40		; fix
	jr nz, .wfb
	
	ld a, c
	ld [hli], a
	ld [hli], a
	ei
	dec b
	jr nz, .maploop
	ret

TitleMenu_ADVICE_InitNickname::
	M_AdviceSetup

	ld a, 4
	call Banked_LCDC_SetupPalswapAnimation

	call PauseMenu_ADVICE_CheckSGB
	jr z, .return

	ld hl, $98E1
	call TitleMenu_ADVICE_Nickname_RemapTilesToBlank
	ld hl, $9901
	call TitleMenu_ADVICE_Nickname_RemapTilesToBlank
	ld l, $81
	call TitleMenu_ADVICE_Nickname_RemapTilesToBlank
	call TitleMenu_ADVICE_Nickname_RemapBlankTiles

	ld hl, $8E50
	ld b, $14
	call TitleMenu_ADVICE_Nickname_RedrawTiles
	ld hl, $95C0
	ld b, $C
	call TitleMenu_ADVICE_Nickname_RedrawTiles
	ld hl, $9700
	ld b, $20
	call TitleMenu_ADVICE_Nickname_RedrawTiles
	
	ld c, $12
	call Banked_SGB_ConstructATFSetPacket

	ld hl, W_LCDC_CGBStagingOBPaletteArea + (M_LCDC_CGBStagingAreaStride * 4) + (M_LCDC_CGBColorSize * 2) + 1
	call FusionLabEvo_ADVICE_FixOBPaletteForSGB
	
	ld a, M_SGB_Pal01 << 3 + 1
	ld bc, $C
	call PatchUtils_CommitStagedCGBToSGB

	call PauseMenu_ADVICE_CGBToSGB56Shorthand

.return

	M_AdviceTeardown
	ret

TitleMenu_ADVICE_SaveDenjuuNicknameFromBuffer::
	M_AdviceSetup

	ld h, 0
	add hl, hl
	ld b, h
	ld c, l
	add hl, hl
	push hl
	add hl, bc
	ld a, S_SaveClock_NicknameArray >> 8
	add h
	ld d, a
	ld e, l
	ld b, BANK(S_SaveClock_NicknameArray)
	ld a, $A
	ld [REG_MBC3_SRAMENABLE], a
	ld a, 2
	ld [REG_MBC3_SRAMBANK], a
	ld hl, W_MainScript_CenteredNameBuffer
	ld b, M_SaveClock_DenjuuNicknameSize
	call Banked_Memcpy_INTERNAL
	pop de
	ld a, S_SaveClock_NicknameExtensionArray >> 8
	add d
	ld d, a
	ld b, 4
	call Banked_Memcpy_INTERNAL

	M_AdviceTeardown
	ret
