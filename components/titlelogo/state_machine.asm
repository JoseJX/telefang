INCLUDE "telefang.inc"

SECTION "Title Logo State Machine", ROMX[$5300], BANK[$2]
TitleLogo_GameStateMachine::
    ld a, [W_SystemSubState]
    ld hl,$530A
    call System_IndexWordList
    jp hl
    
TitleLogo_StateTable::
    dw TitleLogo_StateLoadPalettes,TitleLogo_StateLoadGraphics,TitleLogo_StateSmilesoft,TitleLogo_StateFadeIn,TitleLogo_StateWaittime,TitleLogo_StateFadeOut,TitleLogo_StateBonBon,TitleLogo_StateFadeSetup
    dw TitleLogo_StateFadeIn,TitleLogo_StateWaittime,TitleLogo_StateFadeOut,TitleLogo_StateOpeningCredits,TitleLogo_StateFadeSetup,TitleLogo_StateFadeIn,TitleLogo_StateWaittime,TitleLogo_StateFadeOut
    dw TitleLogo_StateNatsume,TitleLogo_StateFadeSetup,TitleLogo_StateFadeIn,TitleLogo_JumpToTulunk,TitleLogo_StateFadeOut,TitleLogo_StateToNext,TitleLogo_StateFadeSetup,TitleLogo_StateFadeOutToNext
    dw TitleLogo_StateWaittime,TitleLogo_StateFadeOut,TitleLogo_StateTulunk,TitleLogo_StateFadeSetup,TitleLogo_StateFadeIn,TitleLogo_StateWaittime,TitleLogo_StateFadeOut,TitleLogo_StateToNext
    dw TitleLogo_StateLoadPalettes,$54EE,$5503,$551F,TitleLogo_StateFadeSetup,TitleLogo_StateFadeIn,$5535,TitleLogo_StateFadeSetup
    dw TitleLogo_StateFadeOut,$5562,TitleLogo_StateMusicReset,TitleLogo_StateGameReset
    
TitleLogo_StateFadeIn::
    ld a, $0
    call LCDC_PaletteFade
    or a
    ret z
    jp System_ScheduleNextSubState
    
TitleLogo_StateFadeOut::
    ld a, $1
    call Banked_LCDC_PaletteFade
    or a
    ret  z
    jp System_ScheduleNextSubState
    
TitleLogo_StateFadeSetup::
    ld a, $4
    call Banked_LCDC_SetupPalswapAnimation
    jp System_ScheduleNextSubState
    
TitleLogo_StateLoadPalettes::
    ld bc, $0
    call Banked_CGBLoadBackgroundPalette
    ld a, $1
    ld [W_CGBPaletteStagedBGP],a
    xor a
    ld [$DC58],a
    jp System_ScheduleNextSubState
    
TitleLogo_StateLoadGraphics::
    call ClearGBCTileMap0
    call ClearGBCTileMap1
    call LCDC_ClearMetasprites
    call $0A0B
    ld hl, $C500
    ld bc, $900
    call memclr
    ld hl, $D400
    ld bc, $200
    call memclr
    ld bc, $3
    call Banked_LoadMaliasGraphics
    ld bc, $4
    call Banked_LoadMaliasGraphics
    jp System_ScheduleNextSubState
    
TitleLogo_StateSmilesoft::
    ld bc, $11
    call Banked_CGBLoadBackgroundPalette
    ld a, 1
    ld bc, 1
    call Title_Logo_SGBColourLogic
    ld a, $1
    ld [W_RLEAttribMapsEnabled],a
    ld bc, $1412
    ld a, $0
    ld hl, $9800
    call LCDC_SetTileAttribsSquare
    ld bc, $2006
    ld a, $1
    ld hl, $98E0
    call LCDC_SetTileAttribsSquare
    ld bc, $0
    ld e, $7
    ld a, $0
    call Banked_RLEDecompressTMAP0
    ld a, $4
    call Banked_LCDC_SetupPalswapAnimation
    ld a, $60
    ld [W_TitleScreen_FrameWaitCountdown], a
    xor a
    ld [$C475], a
    jp System_ScheduleNextSubState
    nop
    nop
    nop
    nop
    nop
    
TitleLogo_StateWaittime::
    ldh a, [$FF8D]
    and a, $1
    jr z, .titleLogoWaitCountdown
    ld a, $0
    call Banked_LCDC_SetupPalswapAnimation
	
	; This presumably skips the logos if the A button is pressed. So if the state pointer table is ever re-arranged then this needs to be adjusted to match.
	
    ld a, $14
    ld [W_SystemSubState], a
    ret
    
.titleLogoWaitCountdown
    ld a,[W_TitleScreen_FrameWaitCountdown]
    dec a
    ld [W_TitleScreen_FrameWaitCountdown], a
    ret nz
    ld a, $4
    call Banked_LCDC_SetupPalswapAnimation
	jp System_ScheduleNextSubState
    
TitleLogo_StateBonBon::
    ld b, $2F
    ld c, $0
    ld d, $0
    ld e, $0
    ld a, $0
    call Banked_SGB_ConstructPaletteSetPacket
    ld bc, $1412
    ld a, $2
    ld hl, $9800
    call LCDC_SetTileAttribsSquare
    ld bc, $0
    ld e, $8
    ld a, $0
    call Banked_RLEDecompressTMAP0
    ld a, $60
    ld [W_TitleScreen_FrameWaitCountdown], a
    ld a, $1
    ld [$C475], a
    ld bc, $11
    call Banked_CGBLoadBackgroundPalette
    jp System_ScheduleNextSubState

TitleLogo_StateOpeningCredits::
    ld bc, $1412
    ld a, $0
    ld hl, $9800
    call LCDC_SetTileAttribsSquare
    ld bc, $0
    ld e, $A
    ld a, $0
    call Banked_RLEDecompressTMAP0
    ld a, $60
    ld [W_TitleScreen_FrameWaitCountdown], a
    ld a, $2
    ld [$C475], a
    ld bc, $11
    call Banked_CGBLoadBackgroundPalette
    ld a, 0
    ld bc, 0
    call Title_Logo_SGBColourLogic
    jp System_ScheduleNextSubState
    nop
    nop
    nop
    nop
    nop

TitleLogo_StateNatsume::
    ld bc, $0
    ld e, $7
    ld a, $0
    call Banked_RLEDecompressAttribsTMAP0
    ld bc, $0
    ld e, $9
    ld a, $0
    call Banked_RLEDecompressTMAP0
    ld a, $60
    ld [W_TitleScreen_FrameWaitCountdown], a
    ld a, $3
    ld [$C475], a
    ld bc, $11
    call Banked_CGBLoadBackgroundPalette
    ld a, 1
    ld bc, 3
    call Title_Logo_SGBColourLogic
    jp System_ScheduleNextSubState
	nop
	nop
	nop
	nop
	nop

TitleLogo_StateToNext::
    ld b, $0
    ld c, $0
    ld d, $0
    ld e, $0
    ld a, $0
    call Banked_SGB_ConstructPaletteSetPacket
    ld a, $1
    ld [W_SystemState], a
    xor a
    ld [W_SystemSubState], a
    ret

TitleLogo_StateFadeOutToNext::
	
	; Most likely unused since the above state is used instead.
	
    ld a, $1
    call Banked_LCDC_PaletteFade
    or a
    ret z
	ld a, $1
    ld [W_SystemState],a
    xor a
    ld [W_SystemSubState], a
    ret
	
TitleLogo_StateForreeeeevveeeeeerrrr::
	
	; A substate that constantly loops onto itself. Likely meant as a placeholder.
	
	ret
  
SECTION "Title Logo State Machine Game Reset", ROMX[$5568], BANK[$2]
TitleLogo_StateMusicReset::
    ld a, $1
    call Sound_IndexMusicSetBySong
    ld [W_Sound_NextBGMSelect], a
    jp System_ScheduleNextSubState
    
TitleLogo_StateGameReset::
    di
    call LCDC_DisableLCD
    xor  a
    ldh  [$FF0F],a
    ldh  [$FFFF],a
    xor  a
    ld [W_SystemSubSubState], a
    ld [W_ShadowREG_HBlankSecondMode], a
    ld [W_HBlank_SecondaryMode], a
    ld [W_HBlank_SCYIndexAndMode], a
    ld [W_ShadowREG_SCX], a
    ld [W_ShadowREG_SCY], a
    ld [W_ShadowREG_WX], a
    ld [W_ShadowREG_WY], a
    ld [W_SerIO_ConnectionState], a
    xor  a
    ldh  [$FF4F], a
    ldh  [$FF70], a
    ldh  [$FF56], a
    call $0439
    call LCDC_ClearDMGPaletteShadow
    ld a, $C3		; no fix
    ld [W_ShadowREG_LCDC], a
    ldh [REG_LCDC], a	; fix
    ei   
    call SerIO_ResetConnection
    ld a,$02		; fix
    ldh [REG_STAT], a	; fix
    xor a
    ldh [$FF0F], a
    ld a, $B
    ldh [$FFFF], a
    xor a
    ld [W_SerIO_ConnectionState], a
    ld a, $1
    ld [W_CGBPaletteStagedBGP], a
    ld [W_CGBPaletteStagedOBP], a
    xor a
    call Banked_CGBLoadBackgroundPalette
    call Banked_CGBLoadObjectPalette
    ld a, $1
    ld [W_OAM_SpritesReady], a
    call LCDC_ClearMetasprites
    xor  a
    ld [W_SystemSubState], a
    ld b, $0
    call Banked_System_CGBToggleClockspeed
    ret
    
TitleLogo_JumpToTulunk::
    ld a, $18
    ld [W_SystemSubState], a
    ret
    
TitleLogo_StateTulunk::
    ld bc, $1406
    xor a
    ld hl, $9800
    call $15CA
    ld bc, $1404
    ld a, $4
    ld hl, $98C0
    call $15CA
    ld bc, $1408
    xor a
    ld hl, $9940
    call $15CA
    ld bc, $0
    ld e, $10
    ld a, $1
    call Banked_RLEDecompressTMAP0
    ld bc, $5C
    call Banked_LoadMaliasGraphics
    ld bc, $11
    call Banked_CGBLoadBackgroundPalette
    ld a, 1
    ld bc, 4
    call Title_Logo_SGBColourLogic
    jp System_ScheduleNextSubState
	
Title_Logo_SGBColourLogic::
    push bc
    ld c, a
    call Banked_SGB_ConstructATFSetPacket
    pop bc
    ld d, M_SGB_Pal01 << 3 + 1
    M_AuxJmp Banked_PatchUtils_CommitStagedCGBToSGB_CBE
    ret
