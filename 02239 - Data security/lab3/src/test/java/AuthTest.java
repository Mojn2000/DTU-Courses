import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;

public class AuthTest {

    static HelloServiceListBased service;

    static {
        try {
            service = (HelloServiceListBased) Naming.lookup("rmi://localhost:1099/HelloService");
        } catch (Exception e) {
        }
    }

    @Test
    public void testLoginSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        assertNotEquals(service.authenticate("usr0", "pswd0"), "Login failed!");
        service.stop("usr0", "pswd0");

    }

    @Test
    public void testLoginFailed() throws RemoteException {
        service.start("usr0", "pswd0");

        assertEquals(service.authenticate("usr0", "wrong"), "Login failed!");

        service.stop("usr0", "pswd0");
    }

    @Test
    public void testPrintPwdSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        assertNotEquals(service.print("file1", "printer1", "usr0", "pswd0"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testPrintPwdFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        assertEquals(service.print("file1", "printer1", "usr0", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testPrintSessionSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        service.authenticate("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertNotEquals(service.print("file1", "printer1", sessionId), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testPrintSessionFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        System.out.println(service.authenticate("usr0", "pswd0"));
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertEquals(service.print("file1", "printer1", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testQueuePwdSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        assertNotEquals(service.queue("printer1", "usr0", "pswd0"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testQueuePwdFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        assertEquals(service.queue("printer1", "usr0", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testQueueSessionSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertNotEquals(service.queue("printer1", sessionId), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testQueueSessionFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertEquals(service.queue("printer1", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testTopQueuePwdSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        service.print("file2", "printer1", "usr0", "pswd0");
        service.print("file1", "printer1", "usr0", "pswd0");
        assertNotEquals(service.topQueue("printer1", "file1", "usr0", "pswd0"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testTopQueuePwdFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        service.print("file2", "printer1", "usr0", "pswd0");
        service.print("file1", "printer1", "usr0", "pswd0");
        assertEquals(service.topQueue("printer1", "file1", "usr0", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testTopQueueSessionSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        service.print("file2", "printer1", sessionId);
        service.print("file1", "printer1", sessionId);
        assertNotEquals(service.topQueue("printer1", "file1", sessionId), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testTopQueueSessionFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        service.print("file2", "printer1", sessionId);
        service.print("file1", "printer1", sessionId);
        assertEquals(service.topQueue("printer1", "file1", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testRestartPwdSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        assertNotEquals(service.restart("usr0", "pswd0"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testRestartPwdFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        assertEquals(service.restart("usr0", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testRestartSessionSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertNotEquals(service.restart(sessionId), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testRestartSessionFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertEquals(service.restart("wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testSetConfigPwdSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        assertNotEquals(service.setConfig("config1", "black", "usr0", "pswd0"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testSetConfigPwdFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        assertEquals(service.setConfig("config1", "black", "usr0", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testSetConfigSessionSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertNotEquals(service.setConfig("config1", "black", sessionId), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testSetConfigSessionFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertEquals(service.setConfig("config1", "black", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testReadConfigPwdSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        service.setConfig("config1", "black", "usr0", "pswd0");
        assertNotEquals(service.readConfig("config1", "usr0", "pswd0"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testReadConfigPwdFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        service.setConfig("config1", "black", "usr0", "pswd0");
        assertEquals(service.readConfig("config1", "usr0", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testReadConfigSessionSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        service.setConfig("config1", "black", sessionId);
        assertNotEquals(service.readConfig("config1", sessionId), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testReadConfigSessionFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        service.setConfig("config1", "black", sessionId);
        assertEquals(service.readConfig("config1", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }


    @Test
    public void testSessionWide() throws RemoteException {


        service.start("usr0", "pswd0");

        assertEquals(service.authenticate("usr123","pswd123"), "Login failed!");
        assertEquals(service.authenticate("usr0","pswd1"), "Login failed!");
        assertNotEquals(service.authenticate("usr0","pswd0"), "Login failed!");

        String sessionId0 = service.authenticate("usr0", "pswd0").split(" ")[4];
//        service.start(sessionId0);
        assertNotEquals(service.start(sessionId0), "Access Denied.");

        // test print
        int pn = 2;
        for (int i = 0; i < pn; i++) {
            for (int j = 0; j < 5; j++) {
                assertNotEquals(service.print("file"+j,"printer"+i, sessionId0), "Access Denied.");
            }
        }
        for (int i = 0; i < pn; i++) {
            assertNotEquals(service.queue("printer"+i, sessionId0), "Access Denied.");
        }

        assertNotEquals(service.topQueue("printer0", "file3", sessionId0), "Access Denied.");
        assertNotEquals(service.topQueue("printer1", "file2", sessionId0), "Access Denied.");
        for (int i = 0; i < pn; i++) {
            assertNotEquals(service.queue("printer"+i, sessionId0), "Access Denied.");
        }
        assertNotEquals(service.stop(sessionId0), "Access Denied.");

    }

    @Test
    public void testIndividualRequestSuccess() throws RemoteException {

        String usr = "usr0";
        String pswd = "pswd0";

        assertNotEquals(service.start(usr, pswd), "Access Denied.");

        // test print
        int pn = 2;
        for (int i = 0; i < pn; i++) {
            for (int j = 0; j < 5; j++) {
                assertNotEquals(service.print("file"+j,"printer"+i, usr,pswd), "Access Denied.");
            }
        }
        for (int i = 0; i < pn; i++) {
            assertNotEquals(service.queue("printer"+i, usr,pswd), "Access Denied.");
        }

        assertNotEquals(service.topQueue("printer0", "file4", usr,pswd), "Access Denied.");
        assertNotEquals(service.topQueue("printer1", "file2", usr,pswd), "Access Denied.");
        for (int i = 0; i < pn; i++) {
            assertNotEquals(service.queue("printer"+i, usr,pswd), "Access Denied.");
        }
        assertNotEquals(service.stop(usr,pswd), "Access Denied.");

    }

    @Test
    public void testIndividualRequestFailed() throws RemoteException {

        String usr = "usr0";
        String pswd = "wrong";

        assertEquals(service.start(usr, pswd), "Access Denied.");
        service.start("usr0", "pswd0");

        // test print
        int pn = 2;
        for (int i = 0; i < pn; i++) {
            for (int j = 0; j < 5; j++) {
                assertEquals(service.print("file"+j,"printer"+i, usr,pswd), "Access Denied.");
            }
        }
        for (int i = 0; i < pn; i++) {
            assertEquals(service.queue("printer"+i, usr,pswd), "Access Denied.");
        }

        assertEquals(service.topQueue("printer0", "file4", usr,pswd), "Access Denied.");
        assertEquals(service.topQueue("printer1", "file2", usr,pswd), "Access Denied.");
        for (int i = 0; i < pn; i++) {
            assertEquals(service.queue("printer"+i, usr,pswd), "Access Denied.");
        }
        assertEquals(service.stop(usr,pswd), "Access Denied.");
        service.stop("usr0", "pswd0");

    }

    @Test
    public void testPrintRoleFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        assertEquals(service.print("file1", "printer1", "Bop", "pwd"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testStatusPwdFailed() throws RemoteException {
        service.start("usr0", "pswd0");
        service.print("printer1", "file1", "usr0", "pswd0");
        assertEquals(service.status("printer1", "usr0", "wrong"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testStatusPwdSuccess() throws RemoteException {
        service.start("usr0", "pswd0");
        service.print("printer1", "file1", "usr0", "pswd0");
        assertNotEquals(service.status("printer1", "usr0", "pswd0"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }
}
