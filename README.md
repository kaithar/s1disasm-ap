S1 Archipelago patch
====================

This is based on s1disasm_git, changes in this branch are my work but only that.  For the purpose of the Archipelago experience, the following changes have been made:

- Sonic doesn't lose lives when dying.
- SRAM has been enabled to persist AP data between runs.
- Press C on a pause screen to immediately exit whatever level you're in.
- The inital start screen is removed in favour of direct to Level Select
- Since the start screen is gone, the Demo loop is also gone.
- Level Select has been overhauled to display the AP data so you can tell where to hunt.
- Level Select level order corrected, obviously.
- Because AP, a mechanism for monitor state persistance is added.
- Because AP, content of monitors are all now 10 rings.  Sorry.
- Because AP, Special Stages are played strictly in order until completed.
- Because AP, Special Stages completion and emeralds are divorced. AP got the emeralds.
- Because AP, boss completes are recorded now.
- Special Stage: Return to special stage after exit
- Special Stage: AP-toggled deactivation of Goal blocks, they turn into normal on touch.
- Special Stage: For byte alignment reasons, the UP block is now disabled.
- Special Stage: Continues jingle removed, result screen delay reduced from 6s to 1s
- Technical change (you won't see): Monitor objects have had the item field replaced with an id 
- ReadySonic: Fixes the bug that makes Sonic incorrectly use his walking animation when near solids.

The details and theories of Archipelago mode:
- Each monitor in the game is an AP check. Completing the level doesn't release the level.
- Monitors stay broken, to help you track which you need to break.
- Emeralds are AP items, other people need to find them for you.
- Special stages contain a check instead of an emerald.
- Bosses trigger a check the first time you kill them.
- Infinite lives but not invulnerable.
- Once people find some of your rings you're safe from all but instant kills.
- Given S1 specials are kinda miserable to play, they're nerfed quite a bit.

s1disasm_git
============

The very latest Sonic 1 Disassembly.

See: http://info.sonicretro.org/Disassemblies

DISCLAIMER:
Any and all content presented in this repository is presented for informational and educational purposes only.
Commercial usage is expressly prohibited. Sonic Retro claims no ownership of any code in these repositories.
You assume any and all responsibility for using this content responsibly. Sonic Retro claims no responsibiliy or warranty.
