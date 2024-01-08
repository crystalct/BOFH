BOFH: Servers Under Siege
-------------------------
It's a fan-made video game for the PC and the C64 developed by Covert Bitops. Based on the Bastard Operator from Hell stories, the game features the titular BOFH finding out that his workplace has been taken over by terrorists. However, said terrorists let all the people in the building leave and have instead took the computers hostage, and planted bombs inside the server racks. The BOFH decides that the logical course of action is to eliminate all the terrorists single-handedly and sneaks in.

In both versions, the goal is to defuse all the bombs in the server racks across the buildings and defeat the terrorist leaders on the sixth floor. The two versions feature similar gameplay with slight differences.

The game, in both of its versions, is available on the [Covert Bitops website](https://cadaver.github.io/).

BOFH: Servers Under Siege v1.1
------------------------------
Version 1.1 is a mod that adds the possibility of maneuvering the protagonist using the standard directions of the joystick and with the help of 2nd fire you can reuse the original use of the joystick (forward/backward, turn right/turn left).




<br>
MIT License

Copyright (c) 1998-2024 Cadaver<br>
Programming, graphics and sound effects by Cadaver Music by Yehar<br>
Original PC game by Cadaver, Yehar, Kalle Niemitalo & Tuomas Mäkelä

<br>
<br>

**Minimum requirements to compile it on a Windows machine:**

Install [GIT](https://git-scm.com/), [MAKE](https://gnuwin32.sourceforge.net/packages/make.htm), [DASM](https://dasm-assembler.github.io/) and [makedisk.exe, benton64.exe, pucrunch.exe, prg2bin.exe](https://cadaver.github.io/tools/c64tools.zip) from Covert Bitops site.

Once all the programs have been installed (place the individual EXE files inside a folder listed in your PATH system variable), decide which folder will contain the sources, with the right mouse button select "Git Bash here" for that folder from the contextual menu and in the DOS/BASH style prompt that appears write: 
```
git clone https://github.com/crystalct/BOFH
```
and then
```
cd BOFH
make
```

