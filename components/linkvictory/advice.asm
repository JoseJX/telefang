INCLUDE "telefang.inc"

SECTION "Link Victory Advice Code", ROMX[$79D5], BANK[$1F]
LinkVictory_ADVICE_SubStateDrawDefectionScreen::
	ld a, M_SaveClock_DenjuuStatSize
	
.eraseLoop
	ld [hl], 0
	inc hl
	dec a
	jr nz, .eraseLoop
	ret

LinkVictory_ADVICE_TileLowByteBlanketFill::
	ld c, $FF

.drawloop
	di

.wfb
	ldh a, [REG_STAT]
	and $40		; fix
	jr nz, .wfb
	ld a, c
	ld [hli], a
	inc hl
	ld a, c
	ld [hli], a
	ei
	inc hl
	dec b
	jr nz, .drawloop
	ret

LinkVictory_ADVICE_DrawPhoneNumber::
	push af
	push hl
	push bc
	push de
	call Banked_Status_LoadPhoneDigits_NowWithSGBSupport
	pop de
	ld a, $FF
	ld hl, $99C2
	call vmempoke
	ld l, $D1
	call vmempoke
	ld b, $10
	ld hl, $9A02

.loop
	call vmempoke
	dec b
	jr nz, .loop
	pop bc
	pop hl
	pop af
	jp Banked_Status_DrawPhoneNumberForStatus

LinkVictory_ADVICE_OnExit::
	ld [W_Battle_4thOrderSubState], a
	ld [W_MainScript_TextStyle], a
	ret
