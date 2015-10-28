.include "shell.inc"
.include "ppu.s"

.define oam_fill $0C

.define saved_sp	dp+0
.redefine dp		dp+2

.macro save_sp
	ld	(saved_sp),sp
.endm

.macro restore_sp
	lda	saved_sp
	ld	l,a
	lda	saved_sp+1
	ld	h,a
	ld	sp,hl
.endm

; Enables LCD rendering. If it was disabled, this
; results in being synchronized to refresh.
enable_lcd:
	wreg	LCDC,$81
	ret

; Disables LCD rendering
disable_lcd:
	call	wait_vbl
	wreg	LCDC,0
	delay_msec 20
	ret

; Fills OAM with A,A+1...A+$9E
; Preserved: BC, DE, HL
fill_oam:
	ld	a,oam_fill
	push	hl
	ld	hl,$FE00
-	ld	(hl),a
	inc	a
	inc	l
	bit	7,l
	jr	z,-
	bit	5,l
	jr	z,-
	pop	hl
	ret


; Compares OAM with A,A+1...A+$9E.
; Z if same, NZ if different
; Preserved: BC, DE, HL
cp_oam:
	ld	a,oam_fill
	ld	hl,$FE00
-	cp	(hl)
	ret	nz
	inc	a
	inc	l
	bit	7,l
	jr	z,-
	bit	5,l
	jr	z,-
	xor	a
	ret


; Prints contents of OAM
print_oam:
	ld	a,oam_fill
	ld	hl,$FE00
loop:
	push	af
	ld	a,l
	and	$0F
	jr	nz,++
	or	l
	jr	z,+
	call	print_newline
+	ld	a,l
	call	print_a
++	pop	af
	
	push	af
	cp	(hl)
	jr	z,+
	ld	a,(hl)
	sub	oam_fill
	call	print_a
	jr	skip
+	push	hl
	print_str "-- "
	pop	hl
skip:
	pop	af
	inc	a
	
	inc	l
	bit	7,l
	jr	z,loop
	bit	5,l
	jr	z,loop
	call	print_newline
	ret
