import struct, os

# Sorry if this looks cursed, I want it compact
# Short version: 
#   The string literal is the order of the text sprites, enumerate gives index and letter, dict-comp that flipped
#   List-comp desired input string after upper() to get an array of bytes, use get(c,0xFF) to make missing letters a space
# Shuffle the literal to port to a different order font
_TEXTTBL = {k:i for i,k in enumerate("0123456789$-=>}YZABCDEFGHIJKLMNOPQRSTUVWX")}
_TEXTTBLINV = {v: k for k,v in _TEXTTBL.items()}
_TEXTTBLINV[0xFF] = ' '

def _encode_str(s: str, pad=0):
    return [_TEXTTBL.get(c,0xFF) for c in "{:{pad}}".format(s,pad=pad).upper()]

# def _dencode_str(s: str):
    #_TEXTTBL_INV.get()
    #return [_TEXTTBL.get(c,0xFF) for c in "{:{pad}}".format(s,pad=pad).upper()]

orig = ''.join([
'GREEN  1 }      ',
' HILL  2 }      ',
'       3 }      ',
'MARBLE 1 }      ',
' ZONE  2 }      ',
'       3 }      ',
'SPRING 1 }      ',
' YARD  2 }      ',
'       3 }      ',
'LABY   1 }      ',
' RINTH 2 }      ',
'       3 }      ',
'STAR   1 }      ',
' LIGHT 2 }      ',
'       3 }      ',
'SCRAP  1 }      ',
' BRAIN 2 }      ',
'       3 }      ',
'FINAL ZONE      ',
'SPECIALS        ',
'RESET SAVE      ',
'                ',
'BOSSES          ',
'EMERALDS        ',
'BUFFS           ',
'SPINDASH ENABLED',
'START AND C TO EXIT LEVEL                                                               '
])

with open("misc/Level Select Text.bin", "rb+") as romfile:
    romcontent = romfile.read()
    out = ""
    for b in romcontent:
        out += _TEXTTBLINV.get(b,' ')
    for i in range(0, len(out),0x10):
      print(orig[i:i+0x10])
      print(out[i:i+0x10])
    new = bytes(_encode_str(orig))
    romfile.seek(0)
    romfile.write(new)

print(_encode_str('\x09'))