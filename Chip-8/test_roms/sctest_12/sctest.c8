; Test programm for SCHIP emulators
; Written by Sergey Naydenov (c) 2010
; e-mail: tronix286@rambler.ru
;
; Compile with CHIPPER v2.1 by Christian Egeberg:
; CHIPPER SCTEST.SC SCTEST.C8
;
; History:
;   ver 1.0
;   ver 1.1
;           + Check FX1E (I = I + VX) buffer overflow
;   ver 1.2
;           + Check emulator initialization
;           * fix ERROR BCD print procedure

OPTION BINARY 
ALIGN OFF     

	jp main
copyr:	
	da ' Tronix (c) 2010 '
main:
;	high
	cls
			; check emulator initialization:
			; all registers must be set to zeroes
	se vf,0  	
	jp errorI	
	se ve,0 	
	jp errorI	
	se vd,0 
	jp errorI
	se vc,0
	jp errorI
	se vb,0
	jp errorI
	se va,0
	jp errorI
	se v9,0
	jp errorI
	se v8,0
	jp errorI
	se v7,0
	jp errorI
	se v6,0
	jp errorI
	se v5,0
	jp errorI
	se v4,0
	jp errorI
	se v3,0
	jp errorI
	se v2,0
	jp errorI
	se v1,0
	jp errorI
	se v0,0
	jp errorI
	
	ld v0,0		; fill all registers by hands
	ld v1,1		; but we don't know, how work FX65 instruction
	ld v2,2
	ld v3,3
	ld v4,4
	ld v5,5
	ld v6,6
	ld v7,7
	ld v8,8
	ld v9,9
	ld va,#a
	ld vb,#b
	ld vc,#c
	ld vd,#d
	ld ve,#e
	ld vf,#f

			; check FX65 (load VX from mem) instruction

	ld I, nullreg   ; fill all reg with null
	ld vf, [I]	

	se vf,0  	
	jp error1	; oh shi... FX65 don't work, print error number
	se ve,0 	; with special error1 function, not used FX65
	jp error1	; and 8x5 font. Just draw sprites: ERROR 0
	se vd,0 
	jp error1
	se vc,0
	jp error1
	se vb,0
	jp error1
	se va,0
	jp error1
	se v9,0
	jp error1
	se v8,0
	jp error1
	se v7,0
	jp error1
	se v6,0
	jp error1
	se v5,0
	jp error1
	se v4,0
	jp error1
	se v3,0
	jp error1
	se v2,0
	jp error1
	se v1,0
	jp error1
	se v0,0
	jp error1
			; Okay, FX65 instruchion ok, we can use it


			; Check font 8x5 loaded. We need it for draw
			; error numbers.
	
	ld v0,0		; symbol 0
	ld f,v0		; I pos to symbol 0
	ld v0,[I]	; load to v0 first 8 bits
	sne v0,0
	jp error_font	; Write ERROR 1 with sprites.

			; So, font loaded, now we can print error numbers
			; using system font

			; Test BCD instructions. We need it for print
	ld I, Score	; errors number
	ld ve,123       
	ld B, ve
	ld v2, [I]
	se v0,1
	jp errorBCD	; BCD error. We can't draw error number
	se v1,2		; but draw_number procedure use BCD
	jp errorBCD	; so, we just draw ERROR BCD on the screen
	se v2,3
	jp errorBCD

			; Check math operation
			; check addition
	ld ve, 2	; set error = 2
	ld vf, 0	; set carry flag to null
	ld v0, 254
	ld v1, 1
	add v0, v1	; add without overflow. VF must be 0
	se vf,0
	jp error
	ld ve, 3	; set error = 3
	se v0,255	; check addition result
	jp error

	ld ve, 4	; set error = 4
	add v0, v1	; add with overflow. VF must be 1
	se vf,1
	jp error
	ld ve, 5	; set error = 5
	se v0, 0	; check addition result
	jp error
			; Test substraction. V1 = 1
	ld v0, 1
	ld ve, 6
	ld vf, 0	; set flag to 0
	sub v0, v1	; sub v0-v1. VF must be 1. result must be 0
	se vf, 1
	jp error
	ld ve, 7	; set error = 7
	se v0, 0
	jp error

	ld ve, 8	; set error = 8
	sub v0,v1	; sub 0-1. VF must be 0. result must be 255
	se vf, 0
	jp error
	ld ve, 9	; set error = 9
	se v0,255
	jp error

	ld v0,1
	ld ve,10	; set error = 10
	ld vf, 0 	; set carry to 0
	subn v0,v1	; substract v1-v0. VF must be 1. Result must be 0.
	se vf, 1
	jp error
	ld ve, 11	; set error = 11
	se v0, 0
	jp error

	ld ve, 12	; set error = 12
	ld v0,1
	ld v1,0
	subn v0,v1	; substract v1-v0. VF must be 0. Result must be 255
	se vf, 0
	jp error
	ld ve, 13	; set error = 13
	se v0,255
	jp error
			; Test SHR
	ld v0, 255
	ld ve, 14	; set error = 14
	ld vf, 0	; set VF = 0
	shr v0		; 255 shr 1. VF must be 1, result = 127
	se vf,1
	jp error
	ld ve, 15	; set error = 15
	se v0,127
	jp error

	ld v0, 64
	ld ve, 16	; set error = 16
	shr v0		; 64 shr 1. VF must be 0, result 32
	se vf, 0
	jp error
	ld ve,17	; set error = 17
	se v0,32
	jp error
			; Test SHL
	ld ve, 18	; set error = 18
	ld vf, 1	; set flag to 1
	shl v0		; 32 shl 1. VF = 0. Result = 64
	se vf, 0
	jp error
	ld ve, 19	; set error = 19
	se v0,64
	jp error

	ld v0,250
	ld ve, 20	; set error = 20
	shl v0		; 250 * 2. VF must be 1, Result 244 (?)
	se vf, 1
	jp error
	ld ve, 21	; set error = 21
	se v0,244
	jp error

			; Check for unofficial XOR command
	ld v1, 123
	ld ve,22	; set error = 22
	xor v0,v1
	se v0,143
	jp error

			; Check for HP48 flags save/load
			; FX75 and FX85 instructions

	ld I, fillreg	; fill V0-V7 registers with 0,1,2,3,4,5,6,7
	ld v7, [I]
	ld R, v7   	; save all reg to HP48 flags
	ld I, nullreg   ; fill V0-V7 with nulls
	ld v7, [I]
	ld v7, R	; restore all registers from HP48 flags
	ld ve,23	; set error = 23
	se v7,7		; check FX85 intstruction worked
	jp error
	se v6,6
	jp error
	se v5,5
	jp error
	se v4,4
	jp error
	se v3,3
	jp error
	se v2,2
	jp error
	se v1,1
	jp error
	se v0,0
	jp error

			; Check FX1E (I = I + VX) buffer overflow
	ld ve, 24	; set error = 24
	ld I, #FFE	; move to #FFE offset
	ld v0, 2
	ld vf, 0	; set flag to zero
	add I, v0	; make buffer overflow (#FFE+2 = #1000)
	se vf, 1	; if flag set, thats OK
	jp error

	jp passed	; all tests passed

errorBCD:
	call draw_error
	add v0,10
	ld v2, #B	; B symbol
	ld f, v2
	drw v0,v1,5
	add v0,5
	ld v2, #c	; C symbol	
	ld F, v2
	drw v0,v1,5
	add v2,1	; D symbol
	ld F, v2
	add v0,5
	drw v0,v1,5
	jp fin

errorI:
	call draw_error
	add v0,10
	ld I, symbolI
	drw v0,v1,5
	add v0, 6
	ld I, symbolN
	drw v0,v1,5
	add v0, 6
	ld I, symbolI
	drw v0,v1,5
	jp fin

error1:
	call draw_error
	add v0,10
	ld I, Symbol0
	drw v0,v1,5
	jp fin

error_font:
	call draw_error
	add v0,10
	ld I, Symbol1
	drw v0,v1,5
	jp fin

error:			; in VE - error number
	call draw_error
	call draw_number
	jp fin
	

;// PROCEDURE
draw_error:	
	ld v0,0
	ld v1,0
	ld I,symbolE	; E symbol
	drw v0, v1, 5
	add v0, 5
	ld I,symbolR	; R symbol
	drw v0, v1, 5
	add v0, 6
	drw v0, v1, 5
	ld I,symbol0  	; O symbol
	add v0, 6
	drw v0, v1, 5
	ld I,symbolR 	; R symbol
	add v0, 5
	drw v0, v1, 5
	RET

;// PROCEDURE
draw_number:
	ld v4, v0
	add v4, 10
	ld v5, v1
    	LD  I,  Score   ; Get address of Score
    	LD  B,  VE      ; Stores in memory BCD representation of VE
    	LD  V2, [I]     ; Reads V0...V2 in memory, so the score
    	LD  F,  V0      ; I points to hex char in V1, so the 1st score char
    	DRW V4, V5, 5   ; Draw 8*5 sprite at (V4,V5) from M[I], so char V1
    	ADD V4, 6     ; Set X to the X coord. of 2nd score char
	ld f, v1
	drw v4, v5, 5
	add v4, 6
    	LD  F, V2       ; I points to hex char in V2, so 2nd score char
    	DRW V4, V5, 5   ; Draw 8*5 sprite at (V4,V5) from M[I], so char V2
	RET

fin:	jp fin

Score:
	dw #0000
	db 0
symbol1:
	db $...1....
	db $..11....
	db $...1....
	db $...1....
	db $...1....
symbol0:
	dw #F090
	dw #9090
	db #f0
symbolE:
	dw #F080
	dw #F080
	db #F0
symbolI:
	db $11111...
	db $..1.....
	db $..1.....
	db $..1.....
	db $11111...
symbolN:
	db $1...1...
	db $11..1...
	db $1.1.1...	
	db $1..11...
	db $1...1...
symbolR:
	db $111.....
	db $1..1....
	db $111.....
	db $1..1....
	db $1...1...
symbolK:
	db $1..1....
	db $1.1.....
	db $11......
	db $1.1.....
	db $1..1....

NullReg:
	dw #0000
	dw #0000
	dw #0000
	dw #0000
	dw #0000
	dw #0000
	dw #0000
	dw #0000

FillReg:
	dw #0001
	dw #0203
	dw #0405
	dw #0607

passed:
	ld v0,0
	ld v1,0
	ld F,v0 ; O symbol
	drw v0, v1, 5
	add v0, 5
	ld I, SymbolK
	drw v0, v1, 5
	jp fin