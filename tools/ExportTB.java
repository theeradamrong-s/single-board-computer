import de.neemann.digital.draw.elements.Circuit;
import de.neemann.digital.draw.library.ElementLibrary;
import de.neemann.digital.draw.shapes.ShapeFactory;
import de.neemann.digital.hdl.verilog2.*;
import de.neemann.digital.hdl.printer.CodePrinter;
import java.io.File;
public class ExportTB {
  public static void main(String[] a) throws Exception {
    File dir = new File(a[0]); File out = new File(a[2]);
    ElementLibrary lib = new ElementLibrary(); ShapeFactory sf = new ShapeFactory(lib);
    lib.setShapeFactory(sf); lib.setRootFilePath(dir);
    Circuit c = Circuit.loadCircuit(new File(dir, a[1]), sf);
    VerilogGenerator g = new VerilogGenerator(lib, new CodePrinter(out));
    g.export(c); g.close();
    VerilogTestBenchCreator tb = new VerilogTestBenchCreator(c, g.getModel(), "sbc").write(out);
    for (File f : tb.getTestFileWritten()) System.out.println("testbench " + f.getName());
  }
}
