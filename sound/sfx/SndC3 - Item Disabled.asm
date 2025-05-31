Snd_SS_Item_Disabled:
	smpsHeaderStartSong 1
	smpsHeaderVoice     .Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel	cPSG2, .PSG2, $00, $00

; PSG2 Data
.PSG2:
	smpsModSet	1, 1, 26, 53
	dc.b	nCs1, $06
	smpsStop

; Song seems to not use any FM voices
.Voices:

; Padding to make this take the same space as the old Giant Ring sound effect

	dc.l $DEADC0DE,$DEADC0DE,$DEADC0DE,$DEADC0DE
	dc.l $DEADC0DE,$DEADC0DE,$DEADC0DE,$DEADC0DE
	dc.l $DEADC0DE,$DEADC0DE,$DEADC0DE,$DEADC0DE
	dc.l $DEADC0DE,$DEADC0DE,$DEADC0DE,$DEADC0DE
	dc.l $DEADC0DE,$DEADC0DE,$DEADC0DE,$DEADC0DE
	dc.l $DEADC0DE,$DEADC0DE,$DEADC0DE,$DEADC0DE
	dc.l $DEADC0DE,$DEADC0DE