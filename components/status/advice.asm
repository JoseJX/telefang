INCLUDE "telefang.inc"

SECTION "Status Screen Advice Code", ROMX[$4A40], BANK[$1]
;Synchronize already-loaded status screen palettes with SGB mode.
;Not bank safe on its own.
Status_ADVICE_SyncUpSGBPalettes::
    ld a, M_SGB_Pal01 << 3 + 1
    ld b, 0
    ld c, 1
    call PatchUtils_CommitStagedCGBToSGB
    
    ld a, M_SGB_Pal23 << 3 + 1
    ld b, 5
    ld c, 6
    call PatchUtils_CommitStagedCGBToSGB
    ret
    
Status_ADVICE_StateInitTilemaps::
    M_AdviceSetup
    
    ld bc, 0
    ld e, 1
    ld a, 0
    call Banked_RLEDecompressTMAP0
    ld bc, 0
    ld e, 1
    ld a, 0
    call Banked_RLEDecompressAttribsTMAP0
    
    ;Load SGB ATF.
    ;We don't convert colors until after the denjuu is in place, so we just want
    ;to get the status screen attributes in place.
    ld a, 4
    ld b, 0
    ld c, 0
    ld d, 0
    ld e, 0
    call Banked_SGB_ConstructPaletteSetPacket
    
    M_AdviceTeardown
    ret

Status_ADVICE_StateDrawDenjuu::
    M_AdviceSetup
    
    call Status_ADVICE_SyncUpSGBPalettes

    ; Set up habitat metasprite
    ld bc, $49 ; "Habitat:"
    call Banked_LoadMaliasGraphics

    ; #178 in metasprite bank 8 is MetaSprite_zukan_denjuu_name.
    ld a, $80
    ld [W_LCDC_MetaspriteAnimationBank], a
    ld a, 178
    ld [W_LCDC_MetaspriteAnimationIndex], a
    ld a, 5
    ld [W_LCDC_NextMetaspriteSlot], a
    ld a, 11 * 8
    ld [W_LCDC_MetaspriteAnimationXOffsets + 5], a
    ld a, 5 * 8 + 4
    ld [W_LCDC_MetaspriteAnimationYOffsets + 5], a
    call LCDC_BeginMetaspriteAnimation

    ld a, 2 ; Object palette 0
    ld bc, 7 ; Palette 7
    call CGBLoadObjectPaletteBanked

    ;Original replaced code
    ld a, 4
    call Banked_LCDC_SetupPalswapAnimation
    
    M_AdviceTeardown
    ret

Status_ADVICE_StateSwitchDenjuu::
    M_AdviceSetup
    
    call Status_ADVICE_SyncUpSGBPalettes
    
    ; Original replaced code
    ld a, [W_Status_SelectedDenjuuPersonality]
    ld bc, $8D80
    ld de, StringTable_denjuu_personalities
    call MainScript_DrawCenteredName75

    ; Habitat string replaced with the right-aligned one.
    call Status_ADVICE_DrawRightAlignedHabitatNameInner
    
    M_AdviceTeardown
    ret

Status_ADVICE_DrawRightAlignedHabitatName::
    M_AdviceSetup

    ; Original replaced code
    ld a, [W_Status_SelectedDenjuuPersonality]
    call MainScript_DrawCenteredName75

    ; Habitat string replaced with the right-aligned one.
    call Status_ADVICE_DrawRightAlignedHabitatNameInner

    M_AdviceTeardown
    ret

Status_ADVICE_DrawRightAlignedHabitatNameInner::
    ; When using MainScript_ADVICE_DrawRightAlignedHabitatName,
    ; the habitat name index has to be gotten in advance.
    ld a, [W_Status_SelectedDenjuuSpecies]
    ld c, $D
    call Banked_Battle_LoadSpeciesData
    ld a, [W_Battle_RetrSpeciesByte]
    ld [W_StringTable_ROMTblIndex], a

    ld a, [W_MainScript_VWFNewlineWidth]
    push af
    ld a, 7
    ld [W_MainScript_VWFNewlineWidth], a
    
    ld de, StringTable_denjuu_habitats
    ld bc, $8780
    ld a, BANK(MainScript_ADVICE_DrawRightAlignedHabitatName)
    ld hl, MainScript_ADVICE_DrawRightAlignedHabitatName
    rst $20 ; CallBankedFunction

    pop af
    ld [W_MainScript_VWFNewlineWidth], a
    ret

Status_ADVICE_StateExit::
    M_AdviceSetup
    
    ;Load neutral/grayscale ATF
    ld a, 0
    ld b, 0
    ld c, 0
    ld d, 0
    ld e, 0
    call Banked_SGB_ConstructPaletteSetPacket

    ; This is called after fade-out on the status screen accessed from the
    ; pause menu, but before the fade-out when accessed from battle.
    ; In battle, the habitat sprite needs to be cleared elsewhere.
    ld a, [W_Status_CalledFromContactScreen]
    cp 0
    jr z, .doNotRemoveHabitatYet

    ld de, W_MetaSpriteConfig1 + M_MetaSpriteConfig_Size * 5
    call LCDC_ClearSingleMetasprite
.doNotRemoveHabitatYet

    ;Original replaced code
    xor a
    ld [W_Status_SubState], a
    xor a
    ld [W_MetaSpriteConfig1], a
    
    M_AdviceTeardown
    ret
