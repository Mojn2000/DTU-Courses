import java.rmi.Naming;
import java.rmi.RemoteException;

public class Client {
	static HelloServiceRBAC service;

    static void sessionWide() throws RemoteException {
        System.out.println(service.start("usr0","pswd0"));
        System.out.println(service.authenticate("usr123","pswd123"));
        System.out.println(service.authenticate("usr0","pswd1"));
        //System.out.println(service.authenticate("alice","pswd0"));

        String sessionId = service.authenticate("alice","pswd0");
        
        System.out.println(sessionId);
        
        System.out.println(service.start(sessionId));
        
        // test print
        int pn = 2;
        for (int i = 0; i < pn; i++) {
            for (int j = 0; j < 5; j++) {
                System.out.println(service.print("file"+j,"printer"+i, sessionId));
            }
        }
        for (int i = 0; i < pn; i++) {
            System.out.println(service.queue("printer"+i, sessionId));
        }

        System.out.println(service.topQueue("printer0", "file3", sessionId));
        System.out.println(service.topQueue("printer1", "file2", sessionId));
        for (int i = 0; i < pn; i++) {
            System.out.println(service.queue("printer"+i, sessionId));
        }
        System.out.println(service.stop(sessionId));

	}

	static void individualRequest(String usr, String pswd) {
		try {
	        System.out.println(service.start(usr, pswd));
	        
	        // test print
	        int pn = 2;
	        for (int i = 0; i < pn; i++) {
	        	for (int j = 0; j < 5; j++) {
	            	System.out.println(service.print("file"+j,"printer"+i, usr,pswd));
	            }
	        }
	        for (int i = 0; i < pn; i++) {
	        	System.out.println(service.queue("printer"+i, usr,pswd));
	        }           
	        
	        System.out.println(service.topQueue("printer0", "file4", usr,pswd));
	        System.out.println(service.topQueue("printer1", "file2", usr,pswd));
	        for (int i = 0; i < pn; i++) {
	        	System.out.println(service.queue("printer"+i, usr,pswd));
	        }
	        System.out.println(service.stop(usr,pswd));
		} catch (RemoteException e) {
			e.printStackTrace();
		}
	}

    public static void main(String[] args) {
        try {        	
            // Create a reference to the remote object
        	service = (HelloServiceRBAC) Naming.lookup("rmi://localhost:1099/HelloService");
        	// Call the remote method
            //String s = service.echo("Hello, world!");
            // Print the result
            //System.out.println(s);
   
        	String usrName = "Alice";
        	String usrPswd = "pswd0";
        	
        	String sessionId = service.authenticate(usrName, usrPswd);
        	System.out.println(sessionId);
        	
        	service.start(sessionId);
        	
        	service.print("file0", "printer0", sessionId);
        	System.out.println( service.queue("printer0", sessionId) );
        	
        	System.out.println( service.queue("printer0", "Bob", "pswd0") );
        	System.out.println( service.queue("printer0", "Bob", "pswd1") );
        	
        	service.addRole("Bob", "power", sessionId);
        	System.out.println( service.queue("printer0", "Bob", "pswd0") );
        	System.out.println( service.queue("printer0", "Bob", "pswd1") );
        	
        	service.removeRole("Bob", "power", sessionId);
        	System.out.println( service.queue("printer0", "Bob", "pswd1") );
        	
        	// Remove bob as user
        	service.removeUser("Bob", sessionId);
        	
        	// Add ida
        	service.addUser("Ida", "IdaPswd", sessionId);
        	service.addRole("Ida", "power", sessionId);
        	
        	// Add role to george
        	service.addRole("George", "technician", sessionId);
        	
        	// Add henry
        	service.addUser("Henry", "HenryPswd", sessionId);
        	service.addRole("Henry", "ordinary", sessionId);
        	
        	
            //individualRequest("alice","pswd0");
            //sessionWide();

            //Wrong password
			// individualRequest("usr00", "pswd00");
        	
        	service.restart("alice","pswd0");
        } catch (Exception e) {
            System.out.println("HelloClient exception: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
