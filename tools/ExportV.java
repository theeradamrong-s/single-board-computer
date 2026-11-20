import de.neemann.digital.draw.elements.Circuit;
import de.neemann.digital.draw.library.ElementLibrary;
import de.neemann.digital.draw.shapes.ShapeFactory;
import de.neemann.digital.hdl.verilog2.VerilogGenerator;
import de.neemann.digital.hdl.printer.CodePrinter;
import java.io.File;
public class ExportV {
  public static void main(String[] a) throws Exception {
    File dir = new File(a[0]);
    ElementLibrary lib = new ElementLibrary(); ShapeFactory sf = new ShapeFactory(lib);
    lib.setShapeFactory(sf); lib.setRootFilePath(dir);
    Circuit c = Circuit.loadCircuit(new File(dir, a[1]), sf);
    try (VerilogGenerator g = new VerilogGenerator(lib, new CodePrinter(new File(dir, a[2])))) { g.export(c); }
    System.out.println("exported " + a[2]);
  }
}
