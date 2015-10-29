 .inesprg 1
 .ineschr 1
 .inesmir 0
 .inesmap 0

 .zp

MOV.Y.LO = $00
MOV.Y.HI = $01
MOV.X.LO = $02
MOV.X.HI = $03
POS.Y.LO = $04
POS.Y.HI = $05
POS.X.LO = $06
POS.X.HI = $07

A.READ = $08
B.READ = $09
SEL.READ = $0A
STA.READ = $0B
UP.READ = $0C
DOWN.READ = $0D
LEFT.READ = $0E
RIGHT.READ = $0F

 .bss

BALL.Y = $700
BALL.T = $701
BALL.S = $702
BALL.X = $703

 .code
 .org $c000

main:
 sei
 cld
 ldx #$ff
 txs
 inx
 stx $2000
 stx $2000
 jsr clr_oam
 jsr palette
 jsr inits
 jsr ppuinit
end:
 jmp end

wait_vblank:
 bit $2002
 bpl wait_vblank
 rts

clr_oam:
 lda #0
 tay
clr2_oam:
 sta $700,y
 iny
 bne clr2_oam
 rts

paldata:
 .db $0f,$00,$10,$30

palette:
 jsr wait_vblank
 lda #$3f
 sta $2006
 lda #0
 sta $2006
 tay
 ldx #$20
do_palette:
 lda paldata,y
 sta $2007
 iny
 tya
 and #3
 tay
 dex
 bne do_palette
 rts

inits:
 lda #128
 sta BALL.Y
 sta BALL.X
 sta <POS.Y.HI
 sta <POS.X.HI
 lda #0
 sta <POS.Y.LO
 sta <POS.X.LO
 sta <MOV.X.LO
 sta <MOV.X.HI
 sta <MOV.Y.LO
 sta <MOV.Y.HI
 sta BALL.S
 lda #1
 sta BALL.T
 rts

ppuinit:
 lda #%10000000
 sta $2000
 lda #%00010000
 sta $2001
 rts

nmi:    ;read joy, joy -> velocity, velocity -> movement/sprites
 jsr readjoy
 jsr process
 jsr apply
int:
 rti

readjoy:
 ldx #1
 stx $4016
 dex
 stx $4016
 ldy #0
do_readjoy:
 ldx $4016
 stx <A.READ,y
 iny
 cpy #8
 bne do_readjoy
 rts

process:
 lda <UP.READ
 eor <DOWN.READ
 beq no_down_read
 lda <UP.READ
 beq no_up_read
 sec
 lda <MOV.Y.LO
 sbc #3
 sta <MOV.Y.LO
 lda <MOV.Y.HI
 sbc #0
 sta <MOV.Y.HI
no_up_read:
 lda <DOWN.READ
 beq no_down_read
 clc
 lda <MOV.Y.LO
 adc #3
 sta <MOV.Y.LO
 lda <MOV.Y.HI
 adc #0
 sta <MOV.Y.HI
no_down_read:
 lda <LEFT.READ
 eor <RIGHT.READ
 beq no_right_read
 lda <LEFT.READ
 beq no_left_read
 sec
 lda <MOV.X.LO
 sbc #3
 sta <MOV.X.LO
 lda <MOV.X.HI
 sbc #0
 sta <MOV.X.HI
no_left_read:
 lda <RIGHT.READ
 beq no_right_read
 clc
 lda <MOV.X.LO
 adc #3
 sta <MOV.X.LO
 lda <MOV.X.HI
 adc #0
 sta <MOV.X.HI
no_right_read:
 rts

apply:
 clc
 lda <POS.Y.LO
 adc <MOV.Y.LO
 sta <POS.Y.LO
 lda <POS.Y.HI
 adc <MOV.Y.HI
 sta <POS.Y.HI
 sta BALL.Y
 clc
 lda <POS.X.LO
 adc <MOV.X.LO
 sta <POS.X.LO
 lda <POS.X.HI
 adc <MOV.X.HI
 sta <POS.X.HI
 sta BALL.X
 lda #7
 sta $4014
 rts

 .bank 1
 .org $fffa
 .dw nmi,main,int
 .bank 2
 .org 0
 .incbin "demo.chr"
