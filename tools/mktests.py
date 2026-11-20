# Front-panel tests for sbc.dig. Every value is entered with the buttons, like on the board.
import sys
HDR = "clk s1_n s2_n enter_n back_n run_n dip_n addr instr out led_n"
P1 = [0x2883,0x2901,0x088E,0x14A0,0x1C02,0x088E,0x2006]
P2 = [0x048F,0x088E,0x2000]
P3 = [0x2880,0x2981,0x050F,0x088E,0x0220,0x1610,0x1809,0x10B0,0x1C03,0x2009]
LED_PROG, LED_PROG_LO, LED_RUN, LED_RUNNING = 0b111, 0b101, 0b110, 0b010   # led_n values

class T:
    def __init__(s): s.rows=[HDR]; s.dip=0xFF
    def r(s,c,s1=1,s2=1,en=1,bk=1,rn=1,addr='X',instr='X',out='X',led='X'):
        s.rows.append(f"{c} {s1} {s2} {en} {bk} {rn} {s.dip} {addr} {instr} {out} {led}")
    def press(s,btn):
        kw={btn:0}
        s.r('C',**kw); s.r('C',**kw); s.r('C'); s.r('C')
    def check(s,**kw): s.r(0,**kw)
    def reset(s):
        s.r('C',s2=0); s.r('C',s2=0); s.r('C'); s.r('C')
    def wait(s,n): s.rows.append(f"repeat({n}) C 1 1 1 1 1 {s.dip} X X X X")
    def enter(s,prog):
        for a,w in enumerate(prog):
            s.dip=(~(w>>8))&0xFF; s.press('en'); s.check(addr=a,led=LED_PROG_LO)
            s.dip=(~(w&0xFF))&0xFF; s.press('en'); s.check(addr=a+1,led=LED_PROG)
        s.dip=0xFF
    def text(s): return "\n".join(s.rows)

tests=[]
# ---- 1. program entry + BACK + reset keeps program ----
t=T(); t.reset(); t.check(addr=0,led=LED_PROG)
t.enter(P1)
for a in reversed(range(len(P1))):
    t.press('bk'); t.check(addr=a,instr=P1[a],led=LED_PROG)
t.dip=(~0x28)&0xFF; t.press('en'); t.check(addr=0,led=LED_PROG_LO)   # high part of address 0 again ...
t.press('bk'); t.check(addr=0x3F,led=LED_PROG)                         # ... BACK cancels it (lo -> 0)
t.dip=0xFF; t.reset(); t.check(addr=0,instr=P1[0],led=LED_PROG)       # S2 keeps the program
tests.append(("1_entry_back_reset",t.text()))

# ---- 2. Program 1 single step ----
t=T(); t.reset(); t.enter(P1); t.reset()
t.press('s1'); t.check(addr=0,instr=P1[0],led=LED_RUN)
seq=[(1,'X'),(2,'X'),(3,3),(4,3),(2,3),(3,2),(4,2),(2,2),(3,1),(4,1),(5,1),(6,0),(6,0)]
for pc,o in seq:
    t.press('en'); t.check(addr=pc,instr=P1[pc],out=o,led=LED_RUN)
t.press('rn'); t.check(addr=6, led=LED_RUN)          # RUN at BR 6: halts at once
t.reset(); t.check(addr=0,instr=P1[0],led=LED_PROG)
tests.append(("2_program1_single_step",t.text()))

# ---- 3. Program 1 continuous run: stops by itself; STEP pauses ----
t=T(); t.reset(); t.enter(P1); t.reset()
t.press('s1'); t.press('rn'); t.check(led=LED_RUNNING)
t.wait(32*20); t.check(addr=6,out=0,led=LED_RUN)     # halted at BR 6, LED2 off
t.reset(); t.press('s1'); t.press('rn'); t.wait(32*3)
t.press('en'); t.check(led=LED_RUN)                  # STEP pauses the run
t.r('C'); t.check(addr='X')
tests.append(("3_program1_run_halt_pause",t.text()))

# ---- 4. Program 2 switch echo ----
t=T(); t.reset(); t.enter(P2); t.reset()
t.press('s1'); t.press('rn')
for v in (5,0xA,0xF,3):
    t.dip=(~v)&0xFF; t.wait(32*4); t.check(out=v,led=LED_RUNNING)
t.press('en'); t.check(led=LED_RUN)                  # STEP pauses (program never halts)
tests.append(("4_program2_switch_echo",t.text()))

# ---- 5. Program 3 count up to switch value ----
for n in (5,0):
    t=T(); t.reset(); t.enter(P3); t.reset()
    t.dip=(~n)&0xFF
    t.press('s1'); t.press('rn'); t.wait(32*(6*n+12)); t.check(addr=9,out=n,led=LED_RUN)
    tests.append((f"5_program3_count_to_{n}",t.text()))

open(sys.argv[1],'w').write("\n===\n".join(f"{l}\n{x}" for l,x in tests))
print(len(tests),"tests,",sum(x.count('\n') for _,x in tests),"rows")
