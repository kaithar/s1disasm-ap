mapping = {}
mapping[" "] = 0x00
mapping["~"] = 0x200
mapping.update({'┌': 0x7B2, '┗': 0x7B3, '┓': 0x7B4, '┛': 0x7B5, '┏': 0x7B6, '└': 0x7B7, '┐': 0x7B8, '┘': 0x7B9})
mapping.update({'©': 0x2E7, '🅂': 0x2E8, '🄴': 0x2E9,'🄶': 0x2EA,'🄰': 0x2EB, '🄂': 0x2EC, '🄊': 0x2ED, '⑨': 0x2EE, '①': 0x2EF})
mapping.update({k:i+0x680 for i,k in enumerate("0123456789$-=>}YZABCDEFGHIJKLMNOPQRSTUVWX")})

SEGASTRING = [0x2E8,0x2EF,0x2E7,0x2E8,0x2E9,0x2EA,0x2EB,0x2EC,0x2ED,0x2EE,0x2EF]

inputdata = (
'       ~ ~              M TURNS   '
'       ~ ~              GREEN WHEN' 
'       ~ ~              CHECKED   ' 
'       ~ ~                        ' 
'       ~ ~              > SHOWS   ' 
'       ~ ~                KEYS GOT' 
'       ~ ~                        ' 
'       ~ ~                    ┌┗┓┛' 
'       ~ ~                    ┏└┐┘' 
'       ~ ~                    ┌┗┓┛' 
'       ~ ~                    ┏└┐┘' 
'       ~ ~                    ┌┗┓┛' 
'       ~ ~                    ┏└┐┘' 
'       ~ ~                        ' 
'       ~ ~                        ' 
'       ~ ~              CHECK INFO' 
'       ~ ~              PAGE FOR  ' 
'       ~ ~              GAME RULES' 
'       ~ ~                        ' 
'       ~ ~~               APP-0070' 
'                                  ' 
'                       -----------')

newdata = [mapping.get(c,0x0) for c in "{:{pad}}".format(inputdata,pad=0).upper()]
newdata: list[int] = newdata[:0-len(SEGASTRING)]+SEGASTRING
outbytes = bytes()
for w in newdata:
   outbytes += w.to_bytes(2)

with open("tilemaps/Title Screen.unc", "rb+") as romfile:
    romcontent = romfile.read()
    if len(romcontent) != len(outbytes):
       print(f"Length mismatch! {len(romcontent)=} != {len(outbytes)=}")
    else:
      for i in range(0, len(outbytes)):
        if romcontent[i] != outbytes[i]:
          print(f"@{i:04x} {romcontent[i]:02x} -> {outbytes[i]:02X}")
      romfile.seek(0)
      romfile.write(outbytes)
