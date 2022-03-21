INCLUDE "telefang.inc"


SECTION "VS Summon Screen Advice Code", ROMX[$6D90], BANK[$1]
VsSummon_ADVICE_LoadSGBFiles::
	M_AdviceSetup

	xor a
	call Banked_RLEDecompressTMAP0

	call PauseMenu_ADVICE_CheckSGB
	jp z, .return

	ld bc, $4FF
	ld e, $10
	ld hl, $99A2

.tilemapRowLoop
	ld d, 8

.tilemapColumnLoop
	di

.wfb
	ldh a, [REG_STAT]
	and $40		; fix
	jr nz, .wfb

	ld a, c
	ld [hli], a
	ld [hli], a
	ei
	dec d
	jr nz, .tilemapColumnLoop
	dec b
	jr z, .return

; At this stage of the loop the register d should be 0. We will abuse this fact in order to add the value in e to hl via de.
	add hl, de
	jr .tilemapRowLoop

.return
	jp Summon_ADVICE_LoadSGBFiles_SkipSetup

SECTION "VS Summon Screen Advice Code 3", ROMX[$7A1F], BANK[$1F]
VsSummon_ADVICE_CheckSGB::
    ld a, [W_SGB_DetectSuccess]
    or a
    ret z

    ld a, [W_GameboyType]
    cp M_BIOS_CPU_CGB
    ret

VsSummon_ADVICE_DrawOkIndicator::
    call Banked_Status_LoadUIGraphics

    call VsSummon_ADVICE_CheckSGB
    ret z

    ld a, BANK(BattleContactSelectSgb)
    ld hl, $8370
    ld de, BattleContactSelectSgb
    ld bc, $90
    jp Banked_LCDC_LoadTiles

LinkTrade_ADVICE_DrawDenjuuIndicators::
    call $6CB2
    jr VsSummon_ADVICE_DrawDenjuuIndicators.extEntry

VsSummon_ADVICE_DrawDenjuuIndicators::
    call $5694

.extEntry
    call VsSummon_ADVICE_CheckSGB
    ret z

    ld a, [W_Summon_SelectedPageCount]
    cp 2
    jr z, .oneempty
    cp 1
    jr z, .twoempty
    ret

.twoempty
    ld hl, $98EB
    call VsSummon_ADVICE_ClearDenjuuIndicators

.oneempty
    ld hl, $994B
    jp VsSummon_ADVICE_ClearDenjuuIndicators

VsSummon_ADVICE_ClearDenjuuIndicators::
    ld bc, $4FF

.loop
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
    jr nz, .loop
    ret

VsSummon_ADVICE_PrepareTextStyle::
    ld hl, $9400
	
    call VsSummon_ADVICE_CheckSGB
    ret z
	
    ld a, 3
    ld [W_MainScript_TextStyle], a
    ret

VsSummon_ADVICE_LoadDenjuuPalette::
    call Battle_LoadDenjuuPalettePartner

    call VsSummon_ADVICE_CheckSGB
    ret z

    ld b, 5
    ld c, 6
    ld d, M_SGB_Pal23 << 3 + 1
    M_AuxJmp Banked_PatchUtils_CommitStagedCGBToSGB_CBE

    ret

LinkTrade_ADVICE_UnloadSGBFiles::
    ld [W_Battle_4thOrderSubState], a
    jr VsSummon_ADVICE_UnloadSGBFiles.extEntry

VsSummon_ADVICE_UnloadSGBFiles::
    ld [W_SystemState], a

.extEntry
    call VsSummon_ADVICE_CheckSGB
    jr z, .noSGB

    xor a
    ld b, a
    ld c, a
    ld d, a
    ld e, a
    ld [W_MainScript_TextStyle], a
    call Banked_SGB_ConstructPaletteSetPacket

.noSGB
    ret

VsSummon_ADVICE_ExitStatusScreen::
    ld a, [W_Encounter_AlreadyInitialized]
    cp 1
    ret nz
    ld de, W_MetaSpriteConfig1 + M_MetaSpriteConfig_Size * 5
    call LCDC_ClearSingleMetasprite
    ld a, [W_Encounter_AlreadyInitialized]
    ret

LinkTrade_ADVICE_RememberDefectedSpecies::
    ld [W_Victory_DefectedSpeciesForNickname], a
    ld [W_Victory_DefectedContactSpecies], a
    ret

LinkMenu_ADVICE_LoadSGBFilesBattle::
    call VsSummon_ADVICE_CheckSGB
    ret z
    call LinkMenu_ADVICE_LoadSGBWindowTiles
    ld b, $25
    jr LinkMenu_ADVICE_LoadSGBFilesConnection.extEntry

LinkMenu_ADVICE_LoadSGBFilesTrade::
    call VsSummon_ADVICE_CheckSGB
    ret z
    call LinkMenu_ADVICE_LoadSGBWindowTiles
    ld b, $23
    jr LinkMenu_ADVICE_LoadSGBFilesConnection.extEntry

LinkMenu_ADVICE_LoadSGBFilesConnection::
    call VsSummon_ADVICE_CheckSGB
    ret z
    call LinkMenu_ADVICE_LoadSGBWindowTiles
    ld b, $24

.extEntry
    ld a, $21
    ld c, $22
    ld de, $2625
    jp LinkMenu_ADVICE_ConstructPaletteSetFadeAlternative

LinkMenu_ADVICE_LoadSGBFiles::
    call VsSummon_ADVICE_CheckSGB
    ret z
    ld a, $20
    ld bc, $2125
    ld de, $2324
    jp LinkMenu_ADVICE_ConstructPaletteSetFadeAlternative

LinkMenu_ADVICE_LoadSGBFilesMelody::
    ld de, LinkWindowGfx
    ld hl, $9270
    call LinkMenu_ADVICE_LoadSGBWindowTiles.extEntry
    call VsSummon_ADVICE_CheckSGB
    ret z
    call LinkMenu_ADVICE_LoadSGBWindowTiles
    ld a, $21
    ld bc, $2422
    ld d, b
    ld e, b
    jp LinkMenu_ADVICE_ConstructPaletteSetFadeAlternative

LinkMenu_ADVICE_LoadSGBWindowTiles::
    ld a, 3
    ld [W_MainScript_TextStyle], a
    ld hl, $9310
    ld de, LinkWindowSGBGfx

.extEntry
    ld a, BANK(LinkWindowSGBGfx)
    ld bc, $80
    jp Banked_LCDC_LoadTiles

LinkMenu_ADVICE_SGBResetTextStyle::
    ld [W_Battle_4thOrderSubState], a
    ld [W_MainScript_TextStyle], a
    ret

LinkMenu_ADVICE_SGBResetTextStyle_PlusRenewPredefinedSGBFade::
    call LinkMenu_ADVICE_SGBResetTextStyle
    jp Banked_LCDC_RenewPredefinedSGBFade

LinkMenu_ADVICE_ConstructPaletteSetFadeAlternative::
    push af
    ld hl, W_SGB_FadeMethod
    ld a, 1
    ld [hli], a
    ld a, $4B
    ld [hli], a
    ld a, $AB
    add b
    ld [hli], a
    sub b
    add c
    ld [hli], a
    sub c
    add d
    ld [hli], a
    sub d
    add e
    ld [hli], a
    sub e
    add 6
    add b
    ld [hli], a
    sub b
    add c
    ld [hli], a
    sub c
    add d
    ld [hli], a
    sub d
    add e
    ld [hli], a
    ld a, b
    ld [hli], a
    ld a, c
    ld [hli], a
    ld a, d
    ld [hli], a
    ld a, e
    ld [hli], a
    pop af
    ld c, a
    jp Banked_SGB_ConstructATFSetPacket

SECTION "Link Message Window Tiles", ROMX[$7500], BANK[$62]
LinkWindowGfx::
    INCBIN "build/gfx/menu/multiplayer_melody.2bpp"

LinkWindowSGBGfx::
    INCBIN "build/gfx/menu/multiplayer_sgb.2bpp"
