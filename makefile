all: bofh.d64

bofh.d64: bofh.pak instr.pak hiscore.bin
	makedisk bofh.d64 bofh.seq BOFHC64

instr.pak: instr.s bofh1.1.lbm bofhinst.chr
	benton64 -s2000 -r -b0 bofh1.1.lbm bofh.raw
	dasm instr.s -oinstr.bin -v3 -p3
	pucrunch -x0x1960 instr.bin instr.pak

bofh.pak: bofh.s define.s screen.s raster.s sprite.s weapon.s actor.s player.s enemy.s control.s math.s bofh.spr sound.s level.s data.s common.spr bofhmus.raw level0.chr level0.blk level0.map floor0.pak floor1.pak floor2.pak floor3.pak floor4.pak floor5.pak state.pak
	dasm bofh.s -obofh.bin -v3 -p3
	pucrunch -x0x1960 bofh.bin bofh.pak

floor0.pak: level0.m0 floor0.s
	dasm floor0.s -ofloor0.bin -v3 -p3
	pucrunch -c0 floor0.bin floor0.pak
	prg2bin floor0.pak floor0.pak 2

floor1.pak: level0.m1 floor1.s
	dasm floor1.s -ofloor1.bin -v3 -p3
	pucrunch -c0 floor1.bin floor1.pak
	prg2bin floor1.pak floor1.pak 2

floor2.pak: level0.m2 floor2.s
	dasm floor2.s -ofloor2.bin -v3 -p3
	pucrunch -c0 floor2.bin floor2.pak
	prg2bin floor2.pak floor2.pak 2

floor3.pak: level0.m3 floor3.s
	dasm floor3.s -ofloor3.bin -v3 -p3
	pucrunch -c0 floor3.bin floor3.pak
	prg2bin floor3.pak floor3.pak 2

floor4.pak: level0.m4 floor4.s
	dasm floor4.s -ofloor4.bin -v3 -p3
	pucrunch -c0 floor4.bin floor4.pak
	prg2bin floor4.pak floor4.pak 2

floor5.pak: level0.m5 floor5.s
	dasm floor5.s -ofloor5.bin -v3 -p3
	pucrunch -c0 floor5.bin floor5.pak
	prg2bin floor5.pak floor5.pak 2

state.pak: level0.a0 level0.a1 level0.a2 level0.a3 level0.a4 level0.a5 state.s
	dasm state.s -ostate.bin -v3 -p3
	pucrunch -c0 state.bin state.pak
	prg2bin state.pak state.pak 2

hiscore.bin: hiscore.s
	dasm hiscore.s -ohiscore.bin -v3 -p3

clean:
	rm -f *.bin; rm -f *.pak; rm -f *.d64
