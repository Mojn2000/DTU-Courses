import org.junit.jupiter.api.Test;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;

public class RBACTest {
	static HelloServiceRBAC service;
    static {
        try {
            service = (HelloServiceRBAC) Naming.lookup("rmi://localhost:1099/HelloService");
        } catch (Exception e) {
        }
    }

    @Test
    public void accessControl() throws RemoteException {
    	String sessionIdAlice = service.authenticate("Alice", "pswd0");
    	String sessionIdBob = service.authenticate("Bob", "pswd1");
    	
    	// both loged in
    	assertFalse(sessionIdAlice.equals("Login failed!"));
    	assertFalse(sessionIdBob.equals("Login failed!"));
    	
    	// alice can check queue bob cannot
    	assertFalse(service.queue("printer0", sessionIdAlice).equals("Access Denied."));
    	assertTrue(service.queue("printer0", sessionIdBob).equals("Access Denied."));
    }
    
    @Test
    public void addRole() throws RemoteException {
    	String usrName = "Alice";
    	String usrPswd = "pswd0";
    	String sessionId = service.authenticate(usrName, usrPswd);
    	assertFalse(sessionId.equals("Login failed!"));
    	assertTrue(service.queue("printer0", "Bob", "pswd1").equals("Access Denied."));
    	assertTrue(service.queue("printer0", "Bob", "pswd1").equals("Access Denied."));
    	service.addRole("Bob", "power", sessionId);
    	assertFalse(service.queue("printer0", "Bob", "pswd1").equals("Access Denied."));
    	service.removeRole("Bob", "power", sessionId);
    }    
    
    
}
