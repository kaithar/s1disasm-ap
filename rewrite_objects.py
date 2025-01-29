import struct, os, json

output_stats = {
  'count_by_zone': [],
  'monitors_by_zones': {
  }   
}

c = 0
d = 0
for f in [ "ghz1.bin", "ghz2.bin", "ghz3.bin",
           "mz1.bin",  "mz2.bin",  "mz3.bin",
           "syz1.bin", "syz2.bin", "syz3.bin",
           "lz1.bin",  "lz2.bin",  "lz3.bin",
           "slz1.bin", "slz2.bin", "slz3.bin",
           "sbz1.bin", "sbz2.bin", "sbz3.bin"]:
    mbz = []
    if not os.path.exists(f"objpos/{f}.orig"):
       os.rename(f"objpos/{f}", f"objpos/{f}.orig")
    with open(f"objpos/{f}.orig", "rb") as romfile, open(f"objpos/{f}", "wb+") as outfile:
        romcontent = romfile.read()
        out: list[int] = []
        for i in range(0, len(romcontent),0x6):
            out.extend(romcontent[i:i+4])
            if romcontent[i+4] == 0xA6 or romcontent[i+4] == 0x26:
              if romcontent[i+5] > 0x0F:
                 out.extend([0x71, romcontent[i+5]])
              else:
                 out.extend([0xA6, c])
                 mbz.append([f"Monitor {c}", c, *struct.unpack_from('>HH',romcontent,i)])
                 c += 1
            else:
              out.extend(romcontent[i+4:i+6])
            print(f"{romcontent[i]:02x}{romcontent[i+1]:02x} {romcontent[i+2]:02x}{romcontent[i+3]:02x} {romcontent[i+4]:02x}  {romcontent[i+5]:02x}")
            print(f"{out[-6]:02x}{out[-5]:02x} {out[-4]:02x}{out[-3]:02x} {out[-2]:02x}  {out[-1]:02x}")
        print(f"# Zone completed at {c} with {c-d} monitors")
        output_stats["count_by_zone"].append(c-d)
        output_stats["monitors_by_zones"][f] = mbz
        d = c
        new = bytes(out)
        outfile.seek(0)
        outfile.write(new)

json.dump(output_stats,open("auto_monitors.json","w"))