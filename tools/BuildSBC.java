import de.neemann.digital.draw.elements.*;
import de.neemann.digital.draw.library.ElementLibrary;
import de.neemann.digital.draw.shapes.ShapeFactory;
import de.neemann.digital.draw.graphics.Vector;
import de.neemann.digital.core.element.*;
import de.neemann.digital.core.io.InValue;
import de.neemann.digital.testing.TestCaseDescription;
import java.io.File;
import java.nio.file.*;
import java.util.*;

/**
 * Builds the single-board-computer circuits for Digital.
 * Every wire is computed from the pin positions Digital itself reports,
 * so nothing can be "20 units off".
 */
public class BuildSBC {
    static File dir;
    Circuit c = new Circuit();
    ShapeFactory sf;

    BuildSBC() throws Exception {
        ElementLibrary lib = new ElementLibrary();
        sf = new ShapeFactory(lib);
        lib.setShapeFactory(sf);
        lib.setRootFilePath(dir);
    }

    // ---------- placing ----------
    VisualElement put(String name, int x, int y, Object... kv) {
        VisualElement ve = new VisualElement(name).setShapeFactory(sf).setPos(new Vector(x, y));
        for (int i = 0; i < kv.length; i += 2) setAttr(ve, (Key) kv[i], kv[i + 1]);
        c.add(ve);
        return ve;
    }
    @SuppressWarnings("unchecked")
    static void setAttr(VisualElement ve, Key k, Object v) { ve.setAttribute(k, v); }

    Pin pin(VisualElement ve, String name) {
        for (Pin p : ve.getPins()) if (p.getName().equals(name)) return p;
        StringBuilder sb = new StringBuilder();
        for (Pin p : ve.getPins()) sb.append(p.getName()).append(' ');
        throw new RuntimeException("no pin '" + name + "' on " + ve.getElementName() + " (has: " + sb + ")");
    }
    Pin pin(VisualElement ve, int idx) { return ve.getPins().get(idx); }

    /** direction (dx,dy) pointing away from the element for this pin */
    int[] dir(VisualElement ve, Pin p) {
        int minX = Integer.MAX_VALUE, maxX = Integer.MIN_VALUE, maxY = Integer.MIN_VALUE;
        for (Pin q : ve.getPins()) {
            minX = Math.min(minX, q.getPos().x); maxX = Math.max(maxX, q.getPos().x); maxY = Math.max(maxY, q.getPos().y);
        }
        Vector v = p.getPos();
        if (v.x == minX) return new int[]{-1, 0};
        if (v.x == maxX) return new int[]{1, 0};
        if (v.y == maxY) return new int[]{0, 1};
        return new int[]{0, -1};
    }

    /** connect a pin to a named net: short wire + tunnel */
    void net(VisualElement ve, Object pinRef, String netName) {
        Pin p = pinRef instanceof Integer ? pin(ve, (Integer) pinRef) : pin(ve, (String) pinRef);
        int[] d = dir(ve, p);
        Vector a = p.getPos();
        Vector b = new Vector(a.x + 20 * d[0], a.y + 20 * d[1]);
        c.add(new Wire(a, b));
        int rot = d[0] == 1 ? 0 : d[0] == -1 ? 2 : d[1] == 1 ? 3 : 1;
        put("Tunnel", b.x, b.y, Keys.NETNAME, netName, Keys.ROTATE, new Rotation(rot));
    }
    /** connect a pin to a constant */
    void konst(VisualElement ve, Object pinRef, long value, int bits) {
        Pin p = pinRef instanceof Integer ? pin(ve, (Integer) pinRef) : pin(ve, (String) pinRef);
        int[] d = dir(ve, p);
        Vector a = p.getPos();
        Vector b = new Vector(a.x + 20 * d[0], a.y + 20 * d[1]);
        c.add(new Wire(a, b));
        int rot = d[0] == -1 ? 0 : d[0] == 1 ? 2 : d[1] == 1 ? 1 : 3;
        put("Const", b.x, b.y, Keys.VALUE, value, Keys.BITS, bits, Keys.ROTATE, new Rotation(rot));
    }
    /** hook all pins of a part at once: "pin=net" or "pin=#value/bits" */
    void hook(VisualElement ve, String... spec) {
        for (String s : spec) {
            String[] kv = s.startsWith("==") ? new String[]{"=", s.substring(2)} : s.split("=", 2);
            Object ref = kv[0].matches("\\d+") ? (Object) Integer.parseInt(kv[0]) : kv[0];
            if (kv[1].startsWith("#")) {
                String[] vb = kv[1].substring(1).split("/");
                konst(ve, ref, Long.parseLong(vb[0]), Integer.parseInt(vb[1]));
            } else net(ve, ref, kv[1]);
        }
    }

    // ---------- I/O ----------
    void input(int x, int y, String label, int bits, long def, String desc) {
        VisualElement ve = put("In", x, y, Keys.LABEL, label, Keys.BITS, bits, Keys.INPUT_DEFAULT, new InValue(def),
                Keys.DESCRIPTION, desc);
        c.add(new Wire(new Vector(x, y), new Vector(x + 20, y)));
        put("Tunnel", x + 20, y, Keys.NETNAME, label);
    }
    void clockIn(int x, int y, String label, boolean realTime) {
        put("Clock", x, y, Keys.LABEL, label, Keys.FREQUENCY, 100, Keys.RUN_AT_REAL_TIME, realTime);
        c.add(new Wire(new Vector(x, y), new Vector(x + 20, y)));
        put("Tunnel", x + 20, y, Keys.NETNAME, label);
    }
    void output(int x, int y, String label, int bits, String desc) {
        put("Out", x, y, Keys.LABEL, label, Keys.BITS, bits, Keys.DESCRIPTION, desc);
        c.add(new Wire(new Vector(x - 20, y), new Vector(x, y)));
        put("Tunnel", x - 20, y, Keys.NETNAME, label, Keys.ROTATE, new Rotation(2));
    }
    void text(int x, int y, String s) { put("Text", x, y, Keys.DESCRIPTION, s); }
    void test(int x, int y, String label, String data) throws Exception {
        put("Testcase", x, y, Keys.LABEL, label, Keys.TESTDATA, new TestCaseDescription(data));
    }
    void save(String name) throws Exception { c.save(new File(dir, name)); System.out.println("wrote " + name); }

    // shorthands
    VisualElement gate(String type, int x, int y, int n) { return put(type, x, y, Keys.INPUT_COUNT, n); }
    VisualElement not(int x, int y, int bits) { return put("Not", x, y, Keys.BITS, bits); }
    VisualElement mux(int x, int y, int bits, int selBits) { return put("Multiplexer", x, y, Keys.BITS, bits, Keys.SELECTOR_BITS, selBits); }
    VisualElement split(int x, int y, String in, String out) { return put("Splitter", x, y, Keys.INPUT_SPLIT, in, Keys.OUTPUT_SPLIT, out); }

    // =====================================================================
    static void edgeDetector() throws Exception {
        BuildSBC g = new BuildSBC();
        g.text(40, -40, "Edge detector (Section 4.2): one press = exactly one clock cycle of 1\npress = prev AND (NOT now)");
        g.input(40, 40, "clk", 1, 0, "system clock");
        g.input(40, 100, "btn_n", 1, 1, "raw button, 0 = pressed");
        g.output(640, 160, "press", 1, "1 for exactly one clock after the button goes down");
        VisualElement now = g.put("D_FF", 180, 40, Keys.LABEL, "now");
        g.hook(now, "D=btn_n", "C=clk", "Q=now", "~Q=now_n");
        VisualElement prev = g.put("D_FF", 180, 160, Keys.LABEL, "prev");
        g.hook(prev, "D=now", "C=clk", "Q=prev");
        VisualElement and = g.gate("And", 420, 140, 2);
        g.hook(and, "In_1=prev", "In_2=now_n", "out=press");
        g.test(40, 300, "press_once", "clk btn_n press\nC 1 0\nC 1 0\nC 0 1\nC 0 0\nC 0 0\nC 1 0\nC 1 0\nC 0 1\nC 1 0");
        g.save("EdgeDetector.dig");
    }

    // =====================================================================
    static void frontPanel() throws Exception {
        BuildSBC g = new BuildSBC();
        g.c.getAttributes().set(Keys.WIDTH, 8);
        g.text(40, -60, "Front-panel control (Section 4.4)\nmode: 0 = program, 1 = run    lo: 1 = waiting for the low part");
        int y = 40;
        for (String[] s : new String[][]{{"clk", "1"}, {"reset", "1"}, {"s1_press", "1"}, {"enter_press", "1"},
                {"back_press", "1"}, {"run_press", "1"}, {"instr", "14"}, {"pc", "6"}}) {
            g.input(40, y, s[0], Integer.parseInt(s[1]), 0, ""); y += 60;
        }
        y = 40;
        for (String[] s : new String[][]{{"mode", "1"}, {"lo", "1"}, {"entry_addr", "6"}, {"write_H", "1"},
                {"write_L", "1"}, {"pc_clr", "1"}, {"running", "1"}, {"step", "1"}}) {
            g.output(1900, y, s[0], Integer.parseInt(s[1]), ""); y += 60;
        }
        // helpers: pm = program mode, nreset
        g.hook(g.not(240, 40, 1), "in=mode", "out=pm");
        g.hook(g.not(240, 120, 1), "in=reset", "out=nreset");
        g.hook(g.not(240, 200, 1), "in=lo", "out=nlo");
        g.hook(g.gate("And", 240, 280, 2), "In_1=pm", "In_2=enter_press", "out=pe");
        g.hook(g.gate("And", 240, 400, 2), "In_1=pm", "In_2=back_press", "out=pb");

        // mode: reset -> 0, program mode + S1 -> 1, else hold
        g.text(480, -20, "mode");
        g.hook(g.gate("Or", 480, 40, 2), "In_1=mode", "In_2=s1_press", "out=mode_or");
        g.hook(g.gate("And", 660, 40, 2), "In_1=mode_or", "In_2=nreset", "out=mode_d");
        g.hook(g.put("D_FF", 840, 40, Keys.LABEL, "mode"), "D=mode_d", "C=clk", "Q=mode");

        // lo: reset -> 0, BACK -> 0, ENTER -> toggle
        g.text(480, 160, "lo");
        g.hook(g.put("XOr", 480, 220, Keys.INPUT_COUNT, 2), "In_1=lo", "In_2=pe", "out=lo_t");
        g.hook(g.not(480, 340, 1), "in=pb", "out=npb");
        g.hook(g.gate("And", 660, 220, 3), "In_1=lo_t", "In_2=npb", "In_3=nreset", "out=lo_d");
        g.hook(g.put("D_FF", 840, 220, Keys.LABEL, "lo"), "D=lo_d", "C=clk", "Q=lo");

        // write strobes and pc_clr
        g.text(480, 420, "write H / write L / pc_clr");
        g.hook(g.gate("And", 480, 480, 2), "In_1=pe", "In_2=nlo", "out=write_H");
        g.hook(g.gate("And", 480, 580, 2), "In_1=pe", "In_2=lo", "out=write_L");
        g.hook(g.gate("And", 480, 680, 2), "In_1=pm", "In_2=s1_press", "out=pc_clr");

        // entry address: ENTER on low part -> +1, BACK -> -1, reset -> 0
        g.text(1060, -20, "entry address");
        g.hook(g.put("Add", 1060, 40, Keys.BITS, 6), "a=entry_addr", "b=#1/6", "c_i=#0/1", "s=ea_inc");
        g.hook(g.put("Sub", 1060, 160, Keys.BITS, 6), "a=entry_addr", "b=#1/6", "c_i=#0/1", "s=ea_dec");
        g.hook(g.mux(1260, 40, 6, 1), "sel=write_L", "in_0=entry_addr", "in_1=ea_inc", "out=ea_m1");
        g.hook(g.mux(1260, 160, 6, 1), "sel=pb", "in_0=ea_m1", "in_1=ea_dec", "out=ea_m2");
        g.hook(g.mux(1260, 280, 6, 1), "sel=reset", "in_0=ea_m2", "in_1=#0/6", "out=ea_d");
        g.hook(g.put("Register", 1460, 40, Keys.BITS, 6, Keys.LABEL, "entry_addr"), "D=ea_d", "C=clk", "en=#1/1", "Q=entry_addr");

        // tick: 5-bit counter, ovf once every 32 clocks
        g.text(1060, 400, "tick (every 32 clocks = 0.32 s)");
        g.hook(g.put("Counter", 1060, 460, Keys.BITS, 5, Keys.LABEL, "tick"), "en=#1/1", "C=clk", "clr=#0/1", "ovf=tick");

        // halt: BR (opcode 100) whose address field equals the PC (PC bits 5-4 = 0)
        g.text(1060, 580, "halt = BR to its own address");
        g.hook(g.split(1060, 640, "14", "4,7,3"), "0=instr", "1=i_addr", "3=i_op");
        g.hook(g.split(1060, 760, "6", "4,2"), "0=pc", "1=pc_lo", "2=pc_hi");
        g.hook(g.put("Comparator", 1260, 640, Keys.BITS, 3), "a=i_op", "b=#4/3", "==is_br");
        g.hook(g.put("Comparator", 1260, 740, Keys.BITS, 4), "a=pc_lo", "b=i_addr", "==same_addr");
        g.hook(g.put("Comparator", 1260, 840, Keys.BITS, 2), "a=pc_hi", "b=#0/2", "==pc_hi0");
        g.hook(g.gate("And", 1460, 740, 3), "In_1=is_br", "In_2=same_addr", "In_3=pc_hi0", "out=halt");

        // running: run mode + RUN -> 1; ENTER, halt, reset or program mode -> 0
        g.text(480, 800, "running");
        g.hook(g.gate("Or", 480, 860, 2), "In_1=running", "In_2=run_press", "out=run_or");
        g.hook(g.not(480, 960, 1), "in=enter_press", "out=nenter");
        g.hook(g.not(480, 1020, 1), "in=halt", "out=nhalt");
        g.hook(g.gate("And", 660, 860, 5), "In_1=run_or", "In_2=nenter", "In_3=nhalt", "In_4=mode", "In_5=nreset", "out=run_d");
        g.hook(g.put("D_FF", 840, 860, Keys.LABEL, "running"), "D=run_d", "C=clk", "Q=running");

        // step = run mode AND (ENTER press OR (running AND tick))
        g.text(1060, 960, "step");
        g.hook(g.gate("And", 1060, 1020, 2), "In_1=running", "In_2=tick", "out=run_tick");
        g.hook(g.gate("Or", 1240, 1020, 2), "In_1=enter_press", "In_2=run_tick", "out=step_or");
        g.hook(g.gate("And", 1420, 1020, 2), "In_1=mode", "In_2=step_or", "out=step");

        g.test(40, 1200, "program_mode",
            "clk reset s1_press enter_press back_press run_press instr pc mode lo entry_addr write_H write_L pc_clr running step\n" +
            "C 1 0 0 0 0 0 0 0 0 0 X X X X X\n" +
            "0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0\n" +   // ENTER, high part -> write_H
            "C 0 0 1 0 0 0 0 0 1 0 X X X X X\n" +
            "0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 0\n" +   // ENTER, low part -> write_L
            "C 0 0 1 0 0 0 0 0 0 1 X X X X X\n" +   // address +1, lo back to 0
            "C 0 0 0 1 0 0 0 0 0 0 X X X X X\n" +   // BACK -> address 0
            "C 0 0 0 1 0 0 0 0 0 0x3F X X X X X\n" + // BACK again wraps to 3F
            "0 0 1 0 0 0 0 0 0 0 0x3F 0 0 1 0 0\n" + // S1 -> pc_clr
            "C 0 1 0 0 0 0 0 1 0 X X X X X X\n" +
            "0 0 0 1 0 0 0 0 1 0 X 0 0 0 0 1\n" +   // run mode: ENTER = step
            "C 0 0 0 0 1 0 0 1 0 X X X X 1 X\n" +   // RUN -> running
            "C 0 0 0 0 0 0x2003 3 1 0 X X X X 0 X\n" + // BR 3 at PC 3 -> halt -> stop
            "C 1 0 0 0 0 0 0 0 0 0 X X X 0 0\n");    // reset -> program mode, address 0
        g.save("FrontPanel.dig");
    }

    // =====================================================================
    static void cpu() throws Exception {
        BuildSBC g = new BuildSBC();
        g.c.getAttributes().set(Keys.WIDTH, 6);
        g.text(40, -60, "CPU for the single-board computer: your Lab 12 parts (controlUnit, registerFile, miniALU, dataRAM, programCounter)\n" +
                "Changes (Section 4.5): instruction comes from outside, every write is ANDed with step, PC holds unless step or pc_clr.");
        int y = 40;
        for (String[] s : new String[][]{{"clk", "1"}, {"step", "1"}, {"pc_clr", "1"}, {"instr", "14"},
                {"SW0", "1"}, {"SW1", "1"}, {"SW2", "1"}, {"SW3", "1"}}) {
            g.input(40, y, s[0], Integer.parseInt(s[1]), 0, ""); y += 60;
        }
        g.output(2000, 40, "pc", 6, "program counter");
        g.output(2000, 100, "out", 4, "output port Mem[14]");

        // decode: opcode 13-11, type 10, reg1 9-7, reg2 6-4, address 3-0
        g.text(240, -20, "instruction fields");
        g.hook(g.split(240, 40, "14", "4,3,3,1,3"), "0=instr", "1=addr_f", "2=reg2", "3=reg1", "4=type", "5=opcode");
        g.hook(g.split(240, 240, "4,2", "6"), "0=addr_f", "1=#0/2", "2=addr6");        // {00, address field}
        g.hook(g.split(240, 360, "1,1,1,1", "4"), "0=SW0", "1=SW1", "2=SW2", "3=SW3", "4=sw");

        // your control unit
        g.text(480, -20, "your controlUnit (Lab 12)");
        g.hook(g.put("controlUnit.dig", 480, 40), "Opcode=opcode", "Type=type", "Zero_Flag=zf",
                "RegWrite=cu_regwrite", "FlagWrite=cu_flagwrite", "PCSource=pcsrc", "RegWriteSource=wsrc",
                "ALUSub=alusub", "MemWrite=cu_memwrite");
        // hold the CPU when step = 0
        g.text(480, 380, "hold: AND every write with step");
        g.hook(g.gate("And", 480, 440, 2), "In_1=cu_regwrite", "In_2=step", "out=regwrite");
        g.hook(g.gate("And", 480, 540, 2), "In_1=cu_flagwrite", "In_2=step", "out=flagwrite");
        g.hook(g.gate("And", 480, 640, 2), "In_1=cu_memwrite", "In_2=step", "out=memwrite");

        // register file: write reg1, read reg1 (A) and reg2 (B)
        g.text(780, -20, "your registerFile");
        g.hook(g.put("registerFile.dig", 780, 40), "Din=wdata", "we=regwrite", "Rw=reg1", "C=clk", "Ra=reg1", "Rb=reg2",
                "Da=r1", "Db=r2");
        // ALU with zero flag register
        g.text(780, 260, "your miniALU (zero flag inside)");
        g.hook(g.put("miniALU.dig", 780, 320), "A=r1", "B=r2", "FlagWrite=flagwrite", "Clock=clk", "SUB=alusub",
                "Zero_Flag=zf", "RESULT=alu");
        // data memory + switch port
        g.text(780, 500, "your dataRAM; Mem[15] = switches");
        g.hook(g.put("dataRAM.dig", 780, 560), "A=addr6", "Din=r1", "str=memwrite", "C=clk", "ld=#1/1", "D=ram_d");
        g.hook(g.put("Comparator", 1060, 560, Keys.BITS, 4), "a=addr_f", "b=#15/4", "==is15");
        g.hook(g.mux(1260, 560, 4, 1), "sel=is15", "in_0=ram_d", "in_1=sw", "out=mem_d");
        // register write source: 0 ALU, 1 memory, 2 register (LOAD Rd,Rs), 3 immediate (LDI)
        g.text(1060, 220, "register write data (RegWriteSource)");
        g.hook(g.mux(1060, 280, 4, 2), "sel=wsrc", "in_0=alu", "in_1=mem_d", "in_2=r2", "in_3=addr_f", "out=wdata");
        // output port Mem[14]
        g.text(1060, 700, "output port Mem[14]");
        g.hook(g.put("Comparator", 1060, 760, Keys.BITS, 4), "a=addr_f", "b=#14/4", "==is14");
        g.hook(g.gate("And", 1260, 760, 2), "In_1=memwrite", "In_2=is14", "out=outwrite");
        g.hook(g.put("Register", 1460, 760, Keys.BITS, 4, Keys.LABEL, "out_port"), "D=r1", "C=clk", "en=outwrite", "Q=out");

        // program counter: next = PCSource (0: PC+1, 1: branch target), hold when step = 0, 0 on pc_clr
        g.text(1460, -20, "program counter (your programCounter, ld = 1, clr = pc_clr)");
        g.hook(g.put("Add", 1460, 40, Keys.BITS, 6), "a=pc", "b=#1/6", "c_i=#0/1", "s=pc1");
        g.hook(g.mux(1460, 160, 6, 2), "sel=pcsrc", "in_0=pc1", "in_1=addr6", "in_2=pc1", "in_3=pc1", "out=next_pc");
        g.hook(g.mux(1460, 360, 6, 1), "sel=step", "in_0=pc", "in_1=next_pc", "out=pc_in");
        g.hook(g.put("programCounter.dig", 1660, 360), "C=clk", "in=pc_in", "ld=#1/1", "clr=pc_clr", "out=pc");

        g.test(40, 900, "countdown_by_step",
            "clk step pc_clr instr SW0 SW1 SW2 SW3 pc out\n" +
            "C 0 1 0 0 0 0 0 0 X\n" +
            "C 0 0 0x2883 0 0 0 0 0 X\n" +     // step = 0: nothing happens
            "C 1 0 0x2883 0 0 0 0 1 X\n" +     // LDI R1,3
            "C 1 0 0x2901 0 0 0 0 2 X\n" +     // LDI R2,1
            "C 1 0 0x088E 0 0 0 0 3 3\n" +     // STORE R1,Mem[14] -> out 3
            "C 1 0 0x14A0 0 0 0 0 4 3\n" +     // SUB R1,R2 (R1=2)
            "C 1 0 0x1C02 0 0 0 0 2 3\n" +     // BNZ 2 taken
            "C 0 0 0x088E 0 0 0 0 2 3\n" +     // step = 0: STORE must NOT happen
            "C 1 0 0x088E 0 0 0 0 3 2\n" +     // STORE -> out 2
            "C 1 0 0x14A0 0 0 0 0 4 2\n" +     // R1 = 1
            "C 1 0 0x1C02 0 0 0 0 2 2\n" +
            "C 1 0 0x088E 0 0 0 0 3 1\n" +
            "C 1 0 0x14A0 0 0 0 0 4 1\n" +     // R1 = 0, Z = 1
            "C 1 0 0x1C02 0 0 0 0 5 1\n" +     // BNZ not taken
            "C 1 0 0x088E 0 0 0 0 6 0\n" +     // out 0
            "C 1 0 0x2006 0 0 0 0 6 0\n" +     // BR 6
            "C 1 0 0x048F 1 0 1 0 7 0\n" +     // LOAD R1,Mem[15] (switches = 5)
            "C 1 0 0x088E 0 0 0 0 8 5\n" +     // STORE -> out 5
            "C 0 1 0 0 0 0 0 0 5\n");          // pc_clr -> PC 0
        g.save("CPU_sbc.dig");
    }

    // =====================================================================
    static void sbc(String tests) throws Exception {
        BuildSBC g = new BuildSBC();
        g.text(40, -80, "Single-board computer (sbc.dig) - Mini Project, Tang Nano 9K\n" +
                "Pin names and widths must stay exactly as in Section 4.1 (top.v connects to them).");
        g.clockIn(40, 40, "clk", true);
        g.input(40, 100, "s1_n", 1, 1, "S1, 0 when pressed: go to run mode");
        g.input(40, 160, "s2_n", 1, 1, "S2, 0 when pressed: reset");
        g.input(40, 220, "enter_n", 1, 1, "ENTER / STEP, 0 when pressed");
        g.input(40, 280, "back_n", 1, 1, "BACK, 0 when pressed");
        g.input(40, 340, "run_n", 1, 1, "RUN, 0 when pressed");
        g.input(40, 400, "dip_n", 8, 255, "DIP switch, ON = 0");
        g.output(1900, 40, "addr", 6, "entry address (program mode) or PC (run mode)");
        g.output(1900, 100, "instr", 14, "instruction at addr");
        g.output(1900, 160, "out", 4, "output port Mem[14]");
        g.output(1900, 220, "led_n", 3, "LED0-2, 0 = on");

        // edge detectors + reset
        g.text(240, -20, "edge detectors (4.2)");
        String[][] btn = {{"s1_n", "s1_press"}, {"enter_n", "enter_press"}, {"back_n", "back_press"}, {"run_n", "run_press"}};
        int y = 40;
        for (String[] b : btn) { g.hook(g.put("EdgeDetector.dig", 240, y), "clk=clk", "btn_n=" + b[0], "press=" + b[1]); y += 100; }
        g.text(240, 420, "reset = NOT (sampled s2_n)");
        g.hook(g.put("D_FF", 240, 480, Keys.LABEL, "s2_sample"), "D=s2_n", "C=clk", "~Q=reset");

        // DIP switch: active low -> NOT, then split
        g.text(240, 600, "DIP switch (ON = 0, so invert)");
        g.hook(g.not(240, 660, 8), "in=dip_n", "out=dip");
        g.hook(g.split(240, 740, "8", "6,2"), "0=dip", "1=dip_H");
        g.hook(g.split(240, 840, "8", "1,1,1,1,4"), "0=dip", "1=SW0", "2=SW1", "3=SW2", "4=SW3");

        // front panel
        g.text(560, -20, "front-panel control (4.4)");
        g.hook(g.put("FrontPanel.dig", 560, 40), "clk=clk", "reset=reset", "s1_press=s1_press", "enter_press=enter_press",
                "back_press=back_press", "run_press=run_press", "instr=instr", "pc=pc",
                "mode=mode", "lo=lo", "entry_addr=entry_addr", "write_H=write_H", "write_L=write_L",
                "pc_clr=pc_clr", "running=running", "step=step");

        // program RAM
        g.text(560, 420, "program RAM (4.3): H = bits 13-8, L = bits 7-0");
        g.hook(g.mux(560, 480, 6, 1), "sel=mode", "in_0=entry_addr", "in_1=pc", "out=addr");
        g.hook(g.put("RAMDualPort", 760, 480, Keys.BITS, 6, Keys.ADDR_BITS, 6, Keys.LABEL, "RAM_H"),
                "A=addr", "Din=dip_H", "str=write_H", "C=clk", "ld=#1/1", "D=instr_H");
        g.hook(g.put("RAMDualPort", 760, 680, Keys.BITS, 8, Keys.ADDR_BITS, 6, Keys.LABEL, "RAM_L"),
                "A=addr", "Din=dip", "str=write_L", "C=clk", "ld=#1/1", "D=instr_L");
        g.hook(g.split(1000, 580, "8,6", "14"), "0=instr_L", "1=instr_H", "2=instr");

        // CPU
        g.text(1200, -20, "CPU (4.5)");
        g.hook(g.put("CPU_sbc.dig", 1200, 40), "clk=clk", "step=step", "pc_clr=pc_clr", "instr=instr",
                "SW0=SW0", "SW1=SW1", "SW2=SW2", "SW3=SW3", "pc=pc", "out=out");

        // LEDs: led_n = NOT {running, lo AND NOT mode, mode}
        g.text(1200, 420, "LEDs (4.6): LED0 run mode, LED1 waiting for low part, LED2 running");
        g.hook(g.not(1200, 480, 1), "in=mode", "out=prog_mode");
        g.hook(g.gate("And", 1200, 560, 2), "In_1=lo", "In_2=prog_mode", "out=led_lo");
        g.hook(g.split(1400, 480, "1,1,1", "3"), "0=mode", "1=led_lo", "2=running", "3=led");
        g.hook(g.not(1560, 480, 3), "in=led", "out=led_n");

        // tests
        int ty = 1000;
        for (String block : tests.split("\n===\n")) {
            String label = block.substring(0, block.indexOf('\n'));
            g.test(40 + (ty - 1000) * 3, ty, label, block.substring(block.indexOf('\n') + 1));
            ty += 60;
        }
        g.save("sbc.dig");
    }

    public static void main(String[] a) throws Exception {
        dir = new File(a[0]);
        String which = a[1];
        if (which.equals("edge")) edgeDetector();
        if (which.equals("fp")) frontPanel();
        if (which.equals("cpu")) cpu();
        if (which.equals("sbc")) sbc(new String(Files.readAllBytes(Paths.get(a[2]))));
    }
}
