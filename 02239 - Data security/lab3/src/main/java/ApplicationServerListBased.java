import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

public class ApplicationServerListBased {
	public static String pswdFile = "C:\\Users\\remil\\Documents\\Repo\\lab2-02239\\lab2\\tmp\\.pswd02239";

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

    /**
     * This method is used to generate the password file.
     */
	private static void generatePswdFile() {
		// https://www.geeksforgeeks.org/write-hashmap-to-a-text-file-in-java/
		HashMap<String, String> map = new HashMap<String, String>();

		map.put("usr0", hash("usr0","pswd0"));
		map.put("usr1", hash("usr1","pswd1"));
		map.put("usr2", hash("usr2","pswd0"));
		map.put("Bob", hash("Bob","pwd"));
		map.put("Alice", hash("Alice","pwd"));

        //usr0,pswd0
        //usr1,pswd1
        //usr2,pswd0
        //Bob,pwd
        File file = new File(pswdFile);
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
    	try {
        	LocateRegistry.createRegistry(1099);
            // Create a reference to the remote object
            HelloServiceListBased service = new HelloServantListBasedListBased();
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
