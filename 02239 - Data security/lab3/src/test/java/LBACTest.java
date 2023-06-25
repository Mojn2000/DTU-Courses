import org.junit.jupiter.api.Test;

import java.rmi.Naming;
import java.rmi.RemoteException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

public class LBACTest {

    static HelloServiceListBased service;

    static {
        try {
            service = (HelloServiceListBased) Naming.lookup("rmi://localhost:1099/HelloService");
        } catch (Exception e) {
        }
    }


    @Test
    public void testAlice() throws RemoteException {
        service.start("usr0", "pswd0");
        assertNotEquals(service.print("File","Printer","Alice", "pwd"), "Access Denied.");
        service.stop("usr0", "pswd0");

    }

    @Test
    public void testBob() throws RemoteException {
        service.start("usr0", "pswd0");
        assertEquals(service.print("File","Printer","Bob", "pwd"), "Access Denied.");
        service.stop("usr0", "pswd0");

    }

}
