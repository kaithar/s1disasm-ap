; ---------------------------------------------------------------------------
; Subroutine to	prevent	Sonic leaving the boundaries of	a level
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_LevelBound:
		move.l	obX(a0),d1
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(v_limitleft2).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0		; has Sonic touched the	side boundary?
		bhi.s	.sides		; if yes, branch
		move.w	(v_limitright2).w,d0
		addi.w	#$128,d0
		tst.b	(f_lockscreen).w
		bne.s	.screenlocked
		addi.w	#$40,d0

.screenlocked:
		cmp.w	d1,d0		; has Sonic touched the	side boundary?
		bls.s	.sides		; if yes, branch

.chkbottom:
		;Mercury High Speed Camera Fix
		;move.w	(v_limitbtm2).w,d0
		move.w	(v_limitbtm1).w,d0
		;end High Speed Camera Fix

		; The original code does not consider that the camera boundary
		; may be in the middle of lowering itself, which is why going
		; down the S-tunnel in Green Hill Zone Act 1 fast enough can
		; kill Sonic.

		addi.w	#224,d0
		cmp.w	obY(a0),d0	; has Sonic touched the	bottom boundary?
		blt.s	.bottom		; if yes, branch
		rts	
; ===========================================================================

.bottom:
		cmpi.w	#(id_SBZ<<8)+1,(v_zone).w ; is level SBZ2 ?
		bne.w	KillSonic	; if not, kill Sonic
		cmpi.w	#$2000,(v_player+obX).w
		blo.w	KillSonic
		move.b	#id_Title,(v_gamemode).w
		clr.b	(v_lastlamp).w	; clear	lamppost counter
		rts
		; pad
		dc.w 1,2,3
; ===========================================================================

.sides:
		move.w	d0,obX(a0)
		move.w	#0,obX+2(a0)
		move.w	#0,obVelX(a0)	; stop Sonic moving
		move.w	#0,obInertia(a0)
		bra.s	.chkbottom
; End of function Sonic_LevelBound