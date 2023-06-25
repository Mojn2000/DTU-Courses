import java.io.*;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;

public class ApplicationServerRoleBased {
	//public static String pswdFile = "C:\\Users\\remil\\Documents\\Repo\\lab2-02239\\lab2\\tmp\\.pswd02239";
	private static String tmpDir = "/tmp/";
	public static String pswdFile = tmpDir + ".pswd02239";
	public static String roleFile = tmpDir + "role02239";
	public static String roleAccessFile = tmpDir + "roleAccess02239";
	
	static String listToString(List <String> ls) {
		if (ls.size()>1) return ls.get(0)+","+listToString(ls.subList(1, ls.size()));
		return ls.get(0);
	}
	
	private static void generateRoles() {
		HashMap<String, String> map = new HashMap<String, String>();
    	
		// alice
    	LinkedList<String> alice = new LinkedList<String>();
    	alice.add("admin");
    	map.put("Alice", listToString(alice));
    	
    	// bob
    	LinkedList<String> bob = new LinkedList<String>();
    	bob.add("technician");
    	bob.add("janitor");
    	map.put("Bob", listToString(bob));
    	
    	// cecilia
    	LinkedList<String> cecilia = new LinkedList<String>();
    	cecilia.add("power");
    	map.put("Cecilia", listToString(cecilia));
    	
    	// david
    	LinkedList<String> david = new LinkedList<String>();
    	david.add("ordinary");
    	map.put("David", listToString(david));
    	
    	// erica
    	LinkedList<String> erica = new LinkedList<String>();
    	erica.add("ordinary");
    	map.put("Erica", listToString(erica));
    	
    	// fred
    	LinkedList<String> fred = new LinkedList<String>();
    	fred.add("ordinary");
    	map.put("Fred", listToString(fred));
    	
    	// george
    	LinkedList<String> george = new LinkedList<String>();
    	george.add("ordinary");
    	map.put("George", listToString(george));
    	
    	// save file
    	textFileFromMap(map,roleFile);
	}
	
    /**
     * This method is used to generate the password file.
     */
	private static void generatePswdFile() {
		// https://www.geeksforgeeks.org/write-hashmap-to-a-text-file-in-java/
		HashMap<String, String> map = new HashMap<String, String>();

		map.put("Alice", hash("Alice","pswd0"));
		map.put("Bob", hash("Bob","pswd1"));
		map.put("Cecilia", hash("Cecilia","pswd0"));
		map.put("David", hash("David","pswd4"));
		map.put("Erica", hash("Erica","pswd2"));
		map.put("Fred", hash("Erica","pswd42"));
		map.put("George", hash("George","pswd3"));
		
        textFileFromMap(map, pswdFile);
	}
	
	/**
     * This method is used to generate the password file.
     */
	private static void generateRolesAccess() {
		HashMap<String, String> map = new HashMap<String, String>();
		// print
		map.put("print", listToString(Arrays.asList("admin","power","ordinary")));
		
    	// status
		map.put("status", listToString(Arrays.asList("admin","technician")));
		
		// queue
		map.put("queue", listToString(Arrays.asList("admin","power","ordinary")));
		
	    // topQueue
		map.put("topQueue", listToString(Arrays.asList("admin","power","ordinary")));
		
	    // start
		map.put("start", listToString(Arrays.asList("admin","technician")));
		
	    // stop
		map.put("stop", listToString(Arrays.asList("admin","technician")));
		
	    // restart
		map.put("restart", listToString(Arrays.asList("admin","technician","power")));
		
	    // setConfig
		map.put("setConfig", listToString(Arrays.asList("admin","technician")));
		
		// readConfig
		map.put("readConfig", listToString(Arrays.asList("admin","technician")));
		
	    // addRole
		map.put("addRole", listToString(Arrays.asList("admin")));
		
	    // removeRole
		map.put("removeRole", listToString(Arrays.asList("admin")));
		
	    // addUser
		map.put("addUser", listToString(Arrays.asList("admin")));
		
	    // removeUser
		map.put("removeUser", listToString(Arrays.asList("admin")));
		
		// authenticate
		map.put("authenticate", listToString(Arrays.asList("admin","power","ordinary", "technician")));
		
    	// save file
    	textFileFromMap(map,roleAccessFile);
	}
    /**
     * This method is used to hash the password.
     *
     * @param pswd The password to be hashed.
     * @return The hashed password.
     */
	public static String hash(String usr, String pswd) {
		MessageDigest md;
	   	try {
	   		md = MessageDigest.getInstance("SHA3-256");
	    } catch (NoSuchAlgorithmException e) {
	        throw new IllegalArgumentException(e);
	    }
	   	String aux = usr+pswd;
	   	byte[] hashVal = md.digest((byte[]) aux.getBytes());
	   	StringBuilder sb = new StringBuilder();
	    for (byte b : hashVal) {
	        sb.append(String.format("%02x", b));
	    }
	    return sb.toString();
	}
	
	static void textFileFromMap(Map<String, String> map, String FileName) {
		// https://www.geeksforgeeks.org/write-hashmap-to-a-text-file-in-java/
        File file = new File(FileName);
        BufferedWriter bf = null;
        try {
            bf = new BufferedWriter(new FileWriter(file));
            for (Map.Entry<String, String> entry : map.entrySet()) {
                bf.write(entry.getKey() + ":" + entry.getValue());
                bf.newLine();
            }
            bf.flush();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        finally {
            try {
                bf.close();
            }
            catch (Exception e) {
            }
        }
	}

    /**
     * This method is used to read to convert a text file to a HashMap.
     * @param fileName The name of the file to be read.
     * @return The HashMap containing the username and password.
     */
	public static Map<String, String> hashMapFromTextFile(String fileName){
		// https://www.geeksforgeeks.org/reading-text-file-into-java-hashmap/
	    Map<String, String> map = new HashMap<String, String>();
	    BufferedReader br = null;
	    try {  
            File file = new File(fileName);
            br = new BufferedReader(new FileReader(file));
            String line = null;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(":");
                String name = parts[0].trim();
                String number = parts[1].trim();
                if (!name.equals("") && !number.equals(""))
                    map.put(name, number);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            if (br != null) {
                try {
                    br.close();
                }
                catch (Exception e) {
                };
            }
        } 
	    return map;
	}
	
    public static void main(String[] args) throws RemoteException {
    	generatePswdFile();
    	generateRoles();
    	generateRolesAccess();
    	
    	try {
        	LocateRegistry.createRegistry(1099);
            // Create a reference to the remote object
            HelloServiceRBAC service = new HelloServantRoleBased();
            //Add two printers to the server
            service.addPrinter("printer0");
            service.addPrinter("printer1");
            // Bind the remote object's stub in the registry
            Naming.rebind("rmi://localhost:1099/HelloService", service);
            //System.out.println("Server ready!");
        } catch (Exception e) {
        	System.out.println("Print server not on!");
            //System.out.println("HelloServer exception: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("System init");
    } 
}
