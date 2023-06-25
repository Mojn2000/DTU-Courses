import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.*;

public class HelloServantRoleBased extends UnicastRemoteObject implements HelloServiceRBAC {
    private HashMap<String, String> parameters = new HashMap<String, String>();
    private HashMap<String, List<String>> printers = new HashMap<String, List<String>>();
    private Boolean isOn = false;
    private HashMap<String, String> whitelist = new HashMap<>();
	public static String logFile = "C:\\Users\\remil\\Documents\\Repo\\lab2-02239\\lab2\\tmp\\.log";
	private static final SecureRandom secureRandom = new SecureRandom(); //threadsafe
	private static final Base64.Encoder base64Encoder = Base64.getUrlEncoder(); //threadsafe
	private HashMap<String, List<String>> roleAccess = new HashMap<String, List<String>>();

    public HelloServantRoleBased() throws RemoteException {
        super();
        var database = (HashMap<String, String>) ApplicationServerRoleBased.hashMapFromTextFile(ApplicationServerRoleBased.roleAccessFile);
        for	(String method : database.keySet()) {
        	roleAccess.put(method, Arrays.asList(  (database.get(method)).split(",",0)  ) );
        }
    }

    
	/**
	 * This method is used to test the connection to the server.
	 *
	 * @param s String to be echoed
	 * @return String echoed
	 * @throws RemoteException
	 */
    public String echo(String s) throws RemoteException {
    	return "From server: " + s;
    }

    
	/**
	 * This method is used to print a file on a printer.
	 * @param filename Name of the file to be printed
	 * @param printer Name of the printer to use
	 * @param sessionId Session ID of the user
	 * @throws RemoteException
	 */
	public String print(String filename, String printer, String sessionId) throws RemoteException {
		if (hasAccess(sessionId,roleAccess.get("print") )) {
			return print(filename, printer);
		} 	return "Access Denied.";
    }
	public String print(String filename, String printer, String usr, String pswd) throws RemoteException {
		if (hasAccess(usr, pswd, roleAccess.get("print") )) {
			return print(filename, printer);
		}   return "Access Denied.";
    }
	private String print(String filename, String printer) {
		if(!isOn) return "Print Server is Offline.";
		if (printers.containsKey(printer)){
    		printers.get(printer).add(filename);
			return String.format("File : %s Added to the queue of printer %s", filename, printer);
    	} 	return String.format("There is no printer on the server with name : %s.", printer);
	}
	
	/**
	 * This method list the queue of a printer.
	 *
	 * @param printer Name of the printer to queue
	 * @param sessionId	 *
	 * @throws RemoteException
	 */
	public String queue(String printer, String sessionId) throws RemoteException {
		if (hasAccess(sessionId, roleAccess.get("queue") )) {
			return queue(printer);
		} 	return "Access Denied.";
	}
	public String queue(String printer, String usr, String pswd) throws RemoteException {
		if (hasAccess(usr, pswd, roleAccess.get("queue") )) {
			return queue(printer);
		} 	return "Access Denied.";
	}
	private String queue(String printer) {
		if(!isOn) return "Print Server is Offline.";
		if (printers.containsKey(printer)){
			String s = String.format("Queue For Printer : %s \n \n", printer);
			if(printers.get(printer).size() > 0){
				for (int i = 0; i < printers.get(printer).size(); i++) {
					s += String.format("< %d >  < %s > \n", i, printers.get(printer).get(i));
			  	}
				return s;
			}	return String.format("There are no files in the queue for printer : %s", printer);
		} return String.format("There is no printer on the server with name : %s.", printer);
	}

	
	/**
	 *  This method is used to move a file to the top of the queue of a printer with authentication using Session ID.
	 *
	 * @param printer Name of the printer where the file is located
	 * @param file Name of the file to move to the top of the queue
	 * @param sessionId Session ID of the user
	 * @throws RemoteException
	 */
	public String topQueue(String printer, String file, String sessionId) throws RemoteException {
		if (hasAccess(sessionId, roleAccess.get("topQueue") )) {
			return topQueue(printer, file);
		} return "Access Denied.";
	}
	public String topQueue(String printer, String file, String usr, String pswd) throws RemoteException {
		if (hasAccess(usr, pswd, roleAccess.get("topQueue") )) {
			return topQueue(printer, file);
		} return "Access Denied.";
	}
	private String topQueue(String printer, String file) {
		if(!isOn) return "Print Server is Offline.";
		if(printers.containsKey(printer)){
			if(printers.get(printer).contains(file)){
				printers.get(printer).remove(file);
				printers.get(printer).add(0,file);
				return String.format("File : %s has been put on top of the queue for printer %s", file, printer);
			} else {
				return String.format("There is no file : %s in the queue of printer %s", file, printer);
			}
		} return "There is no printer with name %s on the server. Please Try again.";
	}
	

	/**
	 * This method is used to start the server with authentication using Session ID.
	 *
	 * @param sessionId Session ID of the user
	 * @throws RemoteException
	 */
	public String start(String sessionId) throws RemoteException {
		if (hasAccess(sessionId,roleAccess.get("start") )) {
			return start();
		} else return "Access Denied.";
	}
	public String start(String usr, String pswd) throws RemoteException {
		if (hasAccess(usr, pswd, roleAccess.get("start") )) {
			return start();
		} return "Access Denied.";
	}
	private String start() {
		if(isOn) return "Server is Online";
		isOn = true;
		return "Print Server Started";
	}
	
	
	/**
	 *  This method is used to stop the server with authentication using Session ID.
	 *
	 * @param sessionId Session ID of the user
	 * @throws RemoteException
	 */
	public String stop(String sessionId) throws RemoteException {
		if (hasAccess(sessionId, roleAccess.get("stop") )) {
			return stop();
		}	return "Access Denied.";
	}
	public String stop(String usr, String pswd) throws RemoteException {
		if (hasAccess(usr, pswd, roleAccess.get("stop") )) {
			return stop();
		}	return "Access Denied.";
	}
	private String stop() {
		if(!isOn) return "Print Server is Offline.";
		parameters.clear();
		printers.forEach((key, value) -> {
			value.clear();
		});
		whitelist.clear();
		isOn = false;
		return "Print Server Stopped.";
	}

	
	/**
	 * This method is used to restart the server with authentication using Session ID.
	 *
	 * @param sessionId Session ID of the user
	 * @throws RemoteException
	 */
	public String restart(String sessionId) throws RemoteException {
		if (hasAccess(sessionId, roleAccess.get("restart") )) {
			return restart();
    	}  return "Access Denied.";
	}
	public String restart(String usr, String pswd) throws RemoteException {
		if (hasAccess(usr, pswd, roleAccess.get("restart") )) {
			return restart();
    	}  return "Access Denied.";
	}
	private String restart() {
		if(!isOn) return "Print Server is Offline.";
		stop();
		start();
		return "Server Successfully Restarted.";
	}


	/**
	 * This method is used to add a new configuration with authentication using Session ID.
	 *
	 * @param parameter Parameter of the configuration
	 * @param value Value of the configuration
	 * @param sessionId Session ID of the user
	 * @throws RemoteException
	 */
	public String setConfig(String parameter, String value, String sessionId) throws RemoteException {
		if (hasAccess(sessionId, roleAccess.get("setConfig") )) {
			return setConfig(parameter, value);
    	} 	return "Access Denied.";
    }
	public String setConfig(String parameter, String value, String usr, String pswd) throws RemoteException {
		if (hasAccess(usr, pswd, roleAccess.get("setConfig") )) {
			return setConfig(parameter, value);
    	} 	return "Access Denied.";
    }
	private String setConfig(String parameter, String value) {
    	if(!isOn) return "Print Server is Offline.";
    	parameters.put(parameter, value);
		return "Config File Successfully Updated";
    }

	
	/**
	 * This method is used to read the configuration with authentication using Session ID.
	 *
	 * @param parameter Parameter of the configuration
	 * @param sessionId Session ID of the user
	 * @return Value of the configuration
	 * @throws RemoteException
	 */
	public String readConfig(String parameter, String sessionId) throws RemoteException {
		if (hasAccess(sessionId, roleAccess.get("readConfig") )) {
    		return readConfig(parameter);
    	} 	return "Access Denied.";
    }
	public String readConfig(String parameter, String usr, String pswd) throws RemoteException {
		if (hasAccess(usr, pswd, roleAccess.get("readConfig") )) {
    		return readConfig(parameter);
    	} 	return "Access Denied.";
    }
	private String readConfig(String parameter) {
    	if(!isOn) return "Print Server is Offline.";
    	return parameters.get(parameter);
    }
	
	/**
	 * This method is used to get the status of a specific printer.
	 *
	 * @param printer The printer to get status of

	 * @return Status of the printer
	 * @throws RemoteException
	 */
	public String status(String printer, String sessionId) throws RemoteException {
		if(hasAccess(sessionId, roleAccess.get("status") )){
			return status(printer);
		} 	return  "Access Denied.";
	}
	public String status(String printer, String usr, String pswd) throws RemoteException {
		if(hasAccess(usr, pswd, roleAccess.get("status") )){
			return status(printer);
		} 	return  "Access Denied.";
	}
	private String status(String printer) {
		if(!isOn) return "Print Server is Off. Turn it on to see the status of the printer.";
		if (printers.containsKey(printer)){
			return  String.format("%s is available. The number of files in the queue is: %d", printer, printers.get(printer).size());
		}   return String.format("There is no printer with name : %s running on the server.", printer);
	}
	
	/**
	 * This method is used to add role to existing user
	 *
	 * @param newUsr Username of the user
	 * @param role Role of the user
	 * @return Returns Integer with termination status (0 if successful) 
	 * @throws RemoteException
	 */
	public int addRole(String newUsr, String role, String sessionId) {
		if(hasAccess(sessionId, roleAccess.get("addRole") )){
			return addRole(newUsr, role);
		}   return -1;
	}
	public int addRole(String newUsr, String role, String usr, String pswd) {
		if(hasAccess(usr, pswd, roleAccess.get("addRole") )){
			return addRole(newUsr, role);
		}   return -1;
	}
	private int addRole(String newUsr, String role) {
		var map = (HashMap<String, String>) ApplicationServerRoleBased.hashMapFromTextFile(ApplicationServerRoleBased.roleFile);
		if (map.containsKey(newUsr)) map.put(newUsr, map.get(newUsr)+","+role);
		else map.put(newUsr, role);
		ApplicationServerRoleBased.textFileFromMap(map,ApplicationServerRoleBased.roleFile);
		return 0;
	}
	
	
	/**
	 * This method is used to remove role to existing user
	 *
	 * @param newUsr Username of the user
	 * @param role Role of the user
	 * @return Returns Integer with termination status (0 if successful) 
	 * @throws RemoteException
	 */
	public int removeRole(String newUsr, String role, String sessionId) {
		if(hasAccess(sessionId, roleAccess.get("removeRole") )){
			return removeRole(newUsr, role);
		}	return -1;
	}
	public int removeRole(String newUsr, String role, String usr, String pswd) {
		if(hasAccess(usr, pswd, roleAccess.get("removeRole") )){
			return removeRole(newUsr, role);
		}	return -1;
	}
	private int removeRole(String newUsr, String role) {
		var map = (HashMap<String, String>) ApplicationServerRoleBased.hashMapFromTextFile(ApplicationServerRoleBased.roleFile);
		if (map.containsKey(newUsr)) {
			List<String> usrRoles = new LinkedList<String>(); 
			List<String> usrAL = Arrays.asList((map.get(newUsr)).split(",",0));
			for(int i=0; i<usrAL.size(); i++) usrRoles.add(usrAL.get(i));
			usrRoles.remove(role); 
			map.put(newUsr, ApplicationServerRoleBased.listToString(usrRoles));
			ApplicationServerRoleBased.textFileFromMap(map,ApplicationServerRoleBased.roleFile);
			return 0;
		}   return -2;
	}
	
		
	/**
	 * This method is used to add a user to the printer system
	 *
	 * @param newUsr Username of the new user
	 * @param newPswd Password of the new user
	 * @return Returns Integer with termination status (0 if successful) 
	 * @throws RemoteException
	 */
	public int addUser(String newUsr, String newPswd, String sessionId) {
		if(hasAccess(sessionId, roleAccess.get("addUser") )){
			return addUser(newUsr, newPswd);
		}	return -1;
	}
	public int addUser(String newUsr, String newPswd, String usr, String pswd) {
		if(hasAccess(usr, pswd, roleAccess.get("addUser") )){
			return addUser(newUsr, newPswd);
		}	return -1;
	}
	private int addUser(String newUsr, String newPswd) {
		var map = (HashMap<String, String>) ApplicationServerRoleBased.hashMapFromTextFile(ApplicationServerRoleBased.pswdFile);
		map.put(newUsr, ApplicationServerRoleBased.hash(newUsr, newPswd));
		ApplicationServerRoleBased.textFileFromMap(map, ApplicationServerRoleBased.pswdFile);
		return 0;
	}
	
	
	/**
	 * This method is used to remove a user from the printer system
	 *
	 * @param oldUsr Username of the old user
	 * @return Returns Integer with termination status (0 if successful) 
	 * @throws RemoteException
	 */
	public int removeUser(String oldUsr, String sessionId) {
		if(hasAccess(sessionId, roleAccess.get("removeUser") )){
			return removeUser(oldUsr);
		}   return -1;
	}
	public int removeUser(String oldUsr, String usr, String pswd) {
		if(hasAccess(usr, pswd, roleAccess.get("removeUser") )){
			return removeUser(oldUsr);
		}   return -1;
	}
	private int removeUser(String oldUsr) {
		var map = (HashMap<String, String>) ApplicationServerRoleBased.hashMapFromTextFile(ApplicationServerRoleBased.pswdFile);
		map.remove(oldUsr);
		ApplicationServerRoleBased.textFileFromMap(map, ApplicationServerRoleBased.pswdFile);
		var map1 = (HashMap<String, String>) ApplicationServerRoleBased.hashMapFromTextFile(ApplicationServerRoleBased.roleFile);
		map1.remove(oldUsr);
		ApplicationServerRoleBased.textFileFromMap(map1, ApplicationServerRoleBased.roleFile);		
		return 0;
	}

	/**
	 * This method is used to authenticate the user.
	 *
	 * @param usr Username of the user
	 * @param pswd Password of the user
	 * @return Returns Login successful if the user is authenticated else returns Login failed.
	 * @throws RemoteException
	 */
	public String authenticate(String usr, String pswd) throws RemoteException {
		if (hasAccess(usr, pswd, roleAccess.get("authenticate"))) {
			String sessionId = generateNewToken();
			whitelist.put(sessionId, usr);
			return sessionId;
		} 	return "Login failed!";
	}

	/**
	 * This method is used add a printer to the printer database
	 *
	 * @param printer: The name of the new printer
	 * @throws RemoteException
	 */
	public void addPrinter(String printer) throws Exception {
		if (!printers.containsKey(printer)){
			printers.put(printer,new LinkedList<String>());
		}
	}

	
	private Boolean hasAccess(String sessionId, List<String> roles){
		return whitelist.containsKey(sessionId) && hasRoleAccess(whitelist.get(sessionId), roles);
	}
	private Boolean hasAccess(String usr, String pswd, List<String> roles){
		var database = (HashMap<String, String>) ApplicationServerRoleBased.hashMapFromTextFile(ApplicationServerRoleBased.pswdFile);
		return (database.containsKey(usr) && database.get(usr).equals(ApplicationServerRoleBased.hash(usr,pswd)) && hasRoleAccess(usr, roles));
	}	
	
	private boolean hasRoleAccess(String usr, List<String> roles) {
		if (roles.isEmpty()) return false;
		return hasRole(usr, roles.get(0)) || hasRoleAccess(usr, roles.subList(1,roles.size()) ); 
	}
	
	private boolean hasRole(String usr, String role) {
		var database = (HashMap<String, String>) ApplicationServerRoleBased.hashMapFromTextFile(ApplicationServerRoleBased.roleFile);
		return (Arrays.asList(  (database.get(usr)).split(",",0)  ).contains(role)); 
	}

	private static void writeToLogFile(String record){
		try{
			FileWriter fileWriter = new FileWriter(logFile, true);
			PrintWriter printWriter = new PrintWriter(fileWriter);
			printWriter.println(record);
			printWriter.close();
		}catch (IOException ex){
			ex.printStackTrace();
		}
	}

	/**
	 * This method is used to generate a new token.
	 *
	 * @return Returns a new token.
	 */
	private static String generateNewToken() {
		byte[] randomBytes = new byte[24];
		secureRandom.nextBytes(randomBytes);
		return base64Encoder.encodeToString(randomBytes);
	}
}