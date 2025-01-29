; ---------------------------------------------------------------------------
; Object 72 - teleporter (SBZ)
; ---------------------------------------------------------------------------

Teleport:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Tele_Index(pc,d0.w),d1
		jsr	Tele_Index(pc,d1.w)
		out_of_range.s	.delete
		rts	

.delete:
		jmp	(DeleteObject).l
; ===========================================================================
Tele_Index:	dc.w Tele_Main-Tele_Index
		dc.w loc_166C8-Tele_Index
		dc.w loc_1675E-Tele_Index
		dc.w loc_16798-Tele_Index
; ===========================================================================

Tele_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)     ; Routine 2 is post-init
		move.b	obSubtype(a0),d0     ; Subtype specifies the movement script
		add.w	d0,d0                  ; which is an offset in words...
		andi.w	#$1E,d0              ; Range bounding
		lea	Tele_Data(pc),a2         ; Load address of movement ptr table...
		adda.w	(a2,d0.w),a2         ; ... dd the offset from the ptr table to that for the script.
		move.w	(a2)+,objoff_3A(a0)  ; First word appears to be length of script
		move.l	a2,objoff_3C(a0)     ; Cache the start of the script in the object
		move.w	(a2)+,objoff_36(a0)  ; First X target
		move.w	(a2)+,objoff_38(a0)  ; First Y target

loc_166C8:	; Routine 2
		lea	(v_player).w,a1          ; Get player...
		move.w	obX(a1),d0           ; ... their X co-ord
		sub.w	obX(a0),d0             ; Subtract location of the teleporter from Sonic's location
		btst	#0,obStatus(a0)        ; Check which direction player faces...
		beq.s	loc_166E0              ; branch if facing right
		addi.w	#$F,d0               ; Add 0xF to X difference

loc_166E0:
		cmpi.w	#$10,d0              ; Consider difference - 0x10
		bhs.s	locret_1675C           ; Branch if difference >= 0x10
		move.w	obY(a1),d1           ; Get player's Y
		sub.w	obY(a0),d1             ; Subtract teleporter's Y from it
		addi.w	#$20,d1              ; Add 0x20
		cmpi.w	#$40,d1              ; Then consider deltaY - 0x40
		bhs.s	locret_1675C           ; and branch if deltaY >= 0x40
		tst.b	(f_playerctrl).w       ; Is the player input locked?
		bne.s	locret_1675C           ; If so, branch
		cmpi.b	#7,obSubtype(a0)     ; Is this path number 7?
		bne.s	loc_1670E              ; Branch if not type 7
		cmpi.w	#50,(v_rings).w      ; Consider ring count - 50
		;blo.s	locret_1675C           ; Branch if ring count < 50
		                             ; Reaching here means it's not type 7 OR it's type 7 and rings >= 50 
		bra.s locret_1675C ; CHANGE! This replaces the type 7 and rings < 50 check to disable the top path completely.
loc_1670E:                       ; Entering teleporter...
		addq.b	#2,obRoutine(a0)     ; Set routine 4 as next
		move.b	#$81,(f_playerctrl).w ; lock controls and disable object interaction
		move.b	#id_Roll,obAnim(a1)  ; use Sonic's rolling animation
		move.w	#$800,obInertia(a1)  ; This appears to be the sequence that makes sonic 
		move.w	#0,obVelX(a1)        ;    float up slightly when entering the teleporter
		move.w	#0,obVelY(a1)
		bclr	#5,obStatus(a0)        
		bclr	#5,obStatus(a1)        ; Oddly, this clears the pushing flag, in case you pushed against the wall?
		bset	#1,obStatus(a1)        ; Set that sonic is in the air
		move.w	obX(a0),obX(a1)      ; Set Sonic's location to be that of the teleporter
		move.w	obY(a0),obY(a1)
		clr.b	objoff_32(a0)          ; Clear... what?
		move.w	#sfx_Roll,d0         ; Begin the floaty roll.
		jsr	(PlaySound_Special).l	; play Sonic rolling sound

locret_1675C:
		rts	
; ===========================================================================

loc_1675E:	; Routine 4 - This appears to be the subroutine that delays him floating there
		lea	(v_player).w,a1          ; Get Sonic
		move.b	objoff_32(a0),d0     ; Load time spent spinning
		addq.b	#2,objoff_32(a0)     ; Advance it by 2
		jsr	(CalcSine).l
		asr.w	#5,d0
		move.w	obY(a0),d2           ; This is the gentle bobbing
		sub.w	d0,d2                  ; <
		move.w	d2,obY(a1)           ; <
		cmpi.b	#$80,objoff_32(a0)   ; Check if we've been floating long enough
		bne.s	locret_16796           ; Not long enough, branch to the rts
		bsr.w	sub_1681C              ; Yes! Start moving through the pipe!
		addq.b	#2,obRoutine(a0)     ; ... using subroutine 6
		move.w	#sfx_Teleport,d0
		jsr	(PlaySound_Special).l	; play teleport sound

locret_16796:
		rts	
; ===========================================================================

loc_16798:	; Routine 6
		addq.l	#4,sp
		lea	(v_player).w,a1
		subq.b	#1,objoff_2E(a0)
		bpl.s	loc_167DA
		move.w	objoff_36(a0),obX(a1)
		move.w	objoff_38(a0),obY(a1)
		moveq	#0,d1
		move.b	objoff_3A(a0),d1
		addq.b	#4,d1
		cmp.b	objoff_3B(a0),d1
		blo.s	loc_167C2
		moveq	#0,d1
		bra.s	loc_16800
; ===========================================================================

loc_167C2:
		move.b	d1,objoff_3A(a0)
		movea.l	objoff_3C(a0),a2
		move.w	(a2,d1.w),objoff_36(a0)
		move.w	2(a2,d1.w),objoff_38(a0)
		bra.w	sub_1681C
; ===========================================================================

loc_167DA:
		move.l	obX(a1),d2
		move.l	obY(a1),d3
		move.w	obVelX(a1),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	obVelY(a1),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,obX(a1)
		move.l	d3,obY(a1)
		rts	
; ===========================================================================

loc_16800:
		andi.w	#$7FF,obY(a1)
		clr.b	obRoutine(a0)
		clr.b	(f_playerctrl).w
		move.w	#0,obVelX(a1)
		move.w	#$200,obVelY(a1)
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_1681C:                      ; Choose direction?
		moveq	#0,d0                 ; d0 = 0
		move.w	#$1000,d2           ; d2 = 0x1000    ; Subpixel velocity
		move.w	objoff_36(a0),d0    ; d0 = tgt.x
		sub.w	obX(a1),d0            ; d0 -= sonic.x  ; distance to target
		bge.s	loc_16830             ; if (d0 < 0) {  ; Move left?
		neg.w	d0                    ;   d0 = -d0     ; Negate distance, so it's abs(d0)
		neg.w	d2                    ;   d2 = -d2     ; Negate velocity to move left
		                            ; }
loc_16830:
		moveq	#0,d1                 ; Repeat that with the Y axis so:
		move.w	#$1000,d3           ; d3 is our y subpixel velocity
		move.w	objoff_38(a0),d1
		sub.w	obY(a1),d1            ; d1 is our y distance
		bge.s	loc_16844
		neg.w	d1
		neg.w	d3

loc_16844:                    ; At this point, d0 is delta x and d1 is delta y
		cmp.w	d0,d1               ; Consider d1-d0
		blo.s	loc_1687A           ; if (deltay >= deltax) {
		moveq	#0,d1               ;    d1 = 0          ; Why are we doing this twice?
		move.w	objoff_38(a0),d1  ;    d1 = tgt.y      ; This is the same as loc_16830
		sub.w	obY(a1),d1          ;    d1 -= sonic.y   ; Seems to be just to undo the neg.w d1
		swap	d1                  ;    d1 <<= 16       ; This is different, subpixel multiply
		divs.w	d3,d1             ;    d1 = d1/d3      ; To get travel time
		moveq	#0,d0               ;    d0 = 0          ; Another repeat block
		move.w	objoff_36(a0),d0  ;    d0 = tgt.x      ; Seems to undo sub_1681C's neg.w d0
		sub.w	obX(a1),d0          ;    d0 -= sonic.x
		beq.s	loc_16866           ;    if (d0 != 0) {
		swap	d0                  ;        d0 <<= 16
		divs.w	d1,d0             ;        d0 = d0/d1  ; so, d0 = deltaX/traveltime y?
                              ;    }
loc_16866:
		move.w	d0,obVelX(a1)     ;    sonic.velX = d0
		move.w	d3,obVelY(a1)     ;    sonic.velY = d3 ; This is our actual Y velocity from before
		tst.w	d1                  ;                    ; Testing travel time y?
		bpl.s	loc_16874           ;    if (d1 < 0)
		neg.w	d1                  ;        d1 = -d1

loc_16874:
		move.w	d1,objoff_2E(a0)  ;    tgt.distance = d1
		rts	                      ;    return
; ===========================================================================
                              ; }
loc_1687A:
		moveq	#0,d0               ; d0 = 0        ; Prep register
		move.w	objoff_36(a0),d0  ; d0 = tgt.x    ; Get X target
		sub.w	obX(a1),d0          ; d0 -= sonic.x ; Subtract Sonic's X from target (note, can only go right)
		swap	d0                  ; d0 <<= 16     ; Subpixel compensation
		divs.w	d2,d0             ; d0 = d0/d2    ; d2 should be an X velocity of some kind?
		moveq	#0,d1               ; d1 = 0
		move.w	objoff_38(a0),d1  ; d1 = tgt.y
		sub.w	obY(a1),d1          ; d1 -= sonic.y
		beq.s	loc_16898           ; if (d1 != 0) {
		swap	d1                  ;   d1 <<= 16   ; Subpixel compensation
		divs.w	d0,d1             ;   d1 = d1/d0  ; Why? Because of the stupid rounded corners?
		                          ; }
loc_16898:
		move.w	d1,obVelY(a1)     ; sonic.velY = d1 ; 
		move.w	d2,obVelX(a1)     ; sonic.velX = d2 ; 
		tst.w	d0
		bpl.s	loc_168A6           ; if (d0 < 0)
		neg.w	d0                  ;    d0 = -d0

loc_168A6:
		move.w	d0,objoff_2E(a0)  ; tgt.distance = d0 ; Distance to travel before turning
		rts	
; End of function sub_1681C

; ===========================================================================
Tele_Data:	dc.w .type00-Tele_Data, .type01-Tele_Data, .type02-Tele_Data
		dc.w .type03-Tele_Data, .type04-Tele_Data, .type05-Tele_Data
		dc.w .type06-Tele_Data, .type07-Tele_Data
.type00:	dc.w 4,	$794, $98C
.type01:	dc.w 4,	$94, $38C
.type02:	dc.w $1C, $794,	$2E8
		dc.w $7A4, $2C0, $7D0
		dc.w $2AC, $858, $2AC
		dc.w $884, $298, $894
		dc.w $270, $894, $190
.type03:	dc.w 4,	$894, $690
.type04:	dc.w $1C, $1194, $470
		dc.w $1184, $498, $1158
		dc.w $4AC, $FD0, $4AC
		dc.w $FA4, $4C0, $F94
		dc.w $4E8, $F94, $590
.type05:	dc.w 4,	$1294, $490
.type06:	dc.w $1C, $1594, $FFE8
		dc.w $1584, $FFC0, $1560
		dc.w $FFAC, $14D0, $FFAC
		dc.w $14A4, $FF98, $1494
		dc.w $FF70, $1494, $FD90
.type07:	dc.w 4,	$894, $90
