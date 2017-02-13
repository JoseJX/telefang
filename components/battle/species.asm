INCLUDE "components/battle/species.inc"

;TODO: Symbolize the addresses needed to load this data.
SECTION "Battle Denjuu Species Info Functions", ROM0[$3A35]
;Load a byte from the species-wide data at $1D4B48.
; A = Species (clobbers W_Status_SelectedDenjuuSpecies)
; C = Data index (which byte you want back)
; Returns retrieved value in W_Battle_RetrSpeciesByte
Battle_LoadSpeciesData::
    ld hl, $4B48
    ld [W_Status_SelectedDenjuuSpecies], a
    cp 0
    jr z, .indexFromZero
    ld d, 0
    ld a, M_Battle_SpeciesStride
    ld e, a
    ld a, [W_Status_SelectedDenjuuSpecies]
    
.mulLoop
    add hl, de
    dec a
    jr nz, .mulLoop

.indexFromZero
    ld d, 0
    ld a, c
    ld e, a
    add hl, de
    ld a, [hl]
    ld [W_Battle_RetrSpeciesByte]
    
    ;Return value directly if it's not a base stat.
    ld a, c
    cp M_Battle_Move1
    ret nc
    
    ;Return value directly if B < 2...
    ;TODO: What purpose does this serve? All known callers of the banksafe
    ;wrapper don't set B. Sounds like a bug factory.
    ld a, b
    cp 2
    ret c
    
    dec b
    ld d, 0
    ld a, b
    ld e, a
    push de ; push b - 1 but 16-bit
    
    ld a, c
    ld b, a
    ld a, [W_Status_SelectedDenjuuSpecies]
    call Banked_Battle_LoadLevelupData
    pop de
    
    ld a, e
    cp 1
    jr nz, .multiplyByArgB
    ld a, [W_Battle_RetrLevelupByte]
    cp 1
    jr nz, .multiplyByArgB
    ld e, 1
    jr .addSecondaryConstant

.multiplyByArgB
    ld b, 0
    ld a, [W_Battle_RetrLevelupByte]
    ld c, a
    call System_Multiply16
    sra d
    rr e

.addSecondaryConstant
    ld a, [W_Battle_RetrSpeciesByte]
    ld a, a
    add a, e
    ld [W_Battle_RetrSpeciesByte], a
    ret

SECTION "Battle Denjuu Species Levelup Info Functions", ROM0[$3BA9]
;Read the per-levelup scale factor for a particular denjuu and level.
;
;A = Denjuu Species ID
;B = Level
;
;The returned value controls how the denjuu's base stats grow when
;their level increases.
;
;Essentially: return (*0x4715)[A][B];
;Intended to be called from a banksafe function that enters ROM27.
Battle_LoadLevelupData:
    ld hl, $4715
    ld de, 6
    cp 0
    jr z, .noIndex

.mulx6Loop
    add hl, de
    dec a
    jr nz, .mulx6Loop

.noIndex
    ld d, 0
    ld a, b
    ld e, a
    add hl, de
    ld a, [hl]
    ld [W_Battle_RetrLevelupByte], a
    ret