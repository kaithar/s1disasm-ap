import struct, os

c = 0
for f in [ "ghz1.bin", "ghz2.bin", "ghz3.bin",
           "mz1.bin",  "mz2.bin",  "mz3.bin",
           "syz1.bin", "syz2.bin", "syz3.bin",
           "lz1.bin",  "lz2.bin",  "lz3.bin",
           "slz1.bin", "slz2.bin", "slz3.bin",
           "sbz1.bin", "sbz2.bin", "sbz3.bin"]:
    with open(f"objpos/{f}", "rb+") as romfile:
        romcontent = romfile.read()
        out: list[int] = []
        for i in range(0, len(romcontent),0x6):
            out.extend(romcontent[i:i+5])
            if romcontent[i+4] == 0xA6:
              out.append(c)
              c += 1
            else:
              out.append(romcontent[i+5])
            print(f"{romcontent[i]:02x}{romcontent[i+1]:02x} {romcontent[i+2]:02x}{romcontent[i+3]:02x} {romcontent[i+4]:02x}  {romcontent[i+5]:02x}")
            print(f"{out[-6]:02x}{out[-5]:02x} {out[-4]:02x}{out[-3]:02x} {out[-2]:02x}  {out[-1]:02x}")
        new = bytes(out)
        romfile.seek(0)
        romfile.write(new)
