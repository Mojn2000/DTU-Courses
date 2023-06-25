import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.*;

public class HelloServant extends UnicastRemoteObject implements HelloService {
    private HashMap<String, String> parameters = new HashMap<String, String>();
    private HashMap<String, List<String>> printers = new HashMap<String, List<String>>();
    private Boolean isOn = false;
    private TreeSet<String> whitelist = new TreeSet<>();
	public static String logFile = "C:/Users/SölviPálsson/Desktop/Other/Data Security/Lab 2/lab2-02239/lab2/tmp/.log";
	private static final SecureRandom secureRandom = new SecureRandom(); //threadsafe
	private static final Base64.Encoder base64Encoder = Base64.getUrlEncoder(); //threadsafe
    public HelloServant() throws java.rmi.RemoteException {
        super();
    }

	/**
	 * This method is used to test the connection to the server.
	 *
	 * @param s String to be echoed
	 * @return String echoed
	 * @throws java.rmi.RemoteException
	 */
    public String echo(String s) throws java.rmi.RemoteException {
    	return "From server: " + s;
    }

	/**
	 * This method is used to print a file on a printer.
	 * @param filename Name of the file to be printed
	 * @param printer Name of the printer to use
	 * @param sessionId Session ID of the user
	 * @throws java.rmi.RemoteException
	 */

	public String print(String filename, String printer, String sessionId) throws java.rmi.RemoteException {
		String s = " To Print file: " + filename + " on printer: " + printer;
    	if(!isOn){return "Print Server is Offline.";}
		if (hasAccess(sessionId)) {
			if (printers.containsKey(printer)){
        		printers.get(printer).add(filename);
				writeToLogFile(String.format("Access Granted;SessionId=%s;Method=print();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
				return String.format("File : %s Added to the queue of printer %s", filename, printer);
        	} else {
				return String.format("There is no printer on the server with name : %s.", printer);
			}
		} else {
			writeToLogFile(String.format("Access Denied;SessionId=%s;Method=print();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
    }

	/**
	 * This method is used to print a file on a printer with authentication.
	 * @param filename Name of the file to be printed
	 * @param printer Name of the printer to use
	 * @param usr Username of the user
	 * @param pswd Password of the user
	 * @throws java.rmi.RemoteException
	 */
	public String print(String filename, String printer, String usr, String pswd) throws java.rmi.RemoteException {
		String s = " To Print file: " + filename + " on printer: " + printer;
		if(!isOn){
//			writeToLogFile(String.format("Server Offline;UserId=%s;Method=print();TimeStamp=%s", usr, LocalDateTime.now().toString()));
			return "Print Server is Offline.";}
		if (hasAccess(usr, pswd)) {
			if (printers.containsKey(printer)){
        		printers.get(printer).add(filename);
				writeToLogFile(String.format("Access Granted;UserId=%s;Method=print();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
				return String.format("File : %s Added to the queue of printer %s", filename, printer);
        	} else {
				return String.format("There is no printer on the server with name : %s.", printer);
			}
		} else {
			writeToLogFile(String.format("Access Denied;UserId=%s;Method=print();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
    }

	/**
	 * This method list the queue of a printer.
	 *
	 * @param printer Name of the printer to queue
	 * @param sessionId	 *
	 * @throws java.rmi.RemoteException
	 */
	public String queue(String printer, String sessionId) throws java.rmi.RemoteException {
		String s = String.format("Queue For Printer : %s \n \n", printer);
		String s2 = String.format("Queue For Printer : %s", printer);
    	if(!isOn){return "Print Server is Offline.";}
		if (hasAccess(sessionId)) {
			writeToLogFile(String.format("Access Granted;SessionId=%s;Method=queue();TimeStamp=%s To " + s2, sessionId, LocalDateTime.now().toString()));
			if (printers.containsKey(printer)){
				if(printers.get(printer).size() > 0){
					for (int i = 0; i < printers.get(printer).size(); i++) {
						s += String.format("< %d >  < %s > \n", i, printers.get(printer).get(i));
				  	}
					return s;
				}else{
					return String.format("There are no files in the queue for printer : %s", printer);
				}
			} else {
				return String.format("There is no printer on the server with name : %s.", printer);
			}
		} else {
			writeToLogFile(String.format("Access Denied;SessionId=%s;Method=queue();TimeStamp=%s To " + s2, sessionId, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
    }

	/**
	 * This method is used queue a printer with authentication.
	 * @param printer Name of the printer to queue
	 * @param usr Username of the user
	 * @param pswd Password of the user
	 * @throws java.rmi.RemoteException
	 */
	public String queue(String printer, String usr, String pswd) throws java.rmi.RemoteException {
		String s = String.format("Queue For Printer : %s \n \n", printer);
		String s2 = String.format("Queue For Printer : %s", printer);
    	if(!isOn){
//			writeToLogFile(String.format("Server Offline;UserId=%s;Method=queue();TimeStamp=%s", usr, LocalDateTime.now().toString()));
			return "Print Server is Offline.";
		}
		if (hasAccess(usr, pswd)) {
			writeToLogFile(String.format("Access Granted;UserId=%s;Method=queue();TimeStamp=%s To " + s2, usr, LocalDateTime.now().toString()));
			if (printers.containsKey(printer)){
				if(printers.get(printer).size() > 0){
					for (int i = 0; i < printers.get(printer).size(); i++) {
						s += String.format("< %d >  < %s > \n", i, printers.get(printer).get(i));
				  	}
					return s;
				}else{
					return String.format("There are no files in the queue for printer : %s", printer);
				}
			} else {
				return String.format("There is no printer on the server with name : %s.", printer);
			}
		} else {
			writeToLogFile(String.format("Access Denied;UserId=%s;Method=queue();TimeStamp=%s To " + s2, usr, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
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
		String s = String.format(" To Move file: %s to the top of the queue of printer: %s", file, printer);
		if(!isOn){
//			writeToLogFile(String.format("Server Offline;SessionId=%s;Method=topQueue();TimeStamp=%s", sessionId, LocalDateTime.now().toString()));
			return "Print Server is Offline.";}
		if (hasAccess(sessionId)) {
			if(printers.containsKey(printer)){
				if(printers.get(printer).contains(file)){
					printers.get(printer).remove(file);
					printers.get(printer).add(0,file);
					writeToLogFile(String.format("Access Granted;SessionId=%s;Method=topQueue();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
					return String.format("File : %s has been put on top of the queue for printer %s", file, printer);
				} else {
					return String.format("There is no file : %s in the queue of printer %s", file, printer);
				}
			}else {
				return "There is no printer with name %s on the server. Please Try again.";
			}
		} else {
			writeToLogFile(String.format("Access Denied;SessionId=%s;Method=topQueue();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
	}

	/**
	 * This method is used to move a file to the top of the queue of a printer with authentication using username and password.
	 *
	 * @param printer Name of the printer where the file is located
	 * @param file Name of the file to move to the top of the queue
	 * @param usr Username of the user
	 * @param pswd Password of the user
	 * @throws RemoteException
	 */
	public String topQueue(String printer, String file, String usr, String pswd) throws RemoteException {
		String s = String.format(" To Move file: %s to the top of the queue of printer: %s", file, printer);
		if(!isOn){
//			writeToLogFile(String.format("Server Offline;UserId=%s;Method=topQueue();TimeStamp=%s", usr, LocalDateTime.now().toString()));
			return "Print Server is Offline.";}
		if (hasAccess(usr, pswd)) {
			if(printers.containsKey(printer)){
				if(printers.get(printer).contains(file)){
					printers.get(printer).remove(file);
					printers.get(printer).add(0,file);
					writeToLogFile(String.format("Access Granted;UserId=%s;Method=topQueue();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
					return String.format("File : %s has been put on top of the queue for printer %s", file, printer);
				} else {
					return String.format("There is no file : %s in the queue of printer %s", file, printer);
				}
			}else {
				return "There is no printer with name %s on the server. Please Try again.";
			}
		} else {
			writeToLogFile(String.format("Access Denied;UserId=%s;Method=topQueue();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
	}

	/**
	 * This method is used to start the server with authentication using Session ID.
	 *
	 * @param sessionId Session ID of the user
	 * @throws RemoteException
	 */

	public String start(String sessionId) throws RemoteException {
		String s = " To Start the server";
		if(isOn){
//			writeToLogFile(String.format("Server Already Online;SessionId=%s;Method=status();TimeStamp=%s", sessionId, LocalDateTime.now().toString()));
			return "Print Server is Online.";}
		if (hasAccess(sessionId)) {
			writeToLogFile(String.format("Access Granted;SessionId=%s;Method=start();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
			isOn = true;
			return "Print Server Started";
		} else {
			writeToLogFile(String.format("Access Denied;SessionId=%s;Method=start();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
	}

	/**
	 * This method is used to start the server with authentication using username and password.
	 *
	 * @param usr Username of the user
	 * @param pswd Password of the user
	 * @throws RemoteException
	 */
	public String start(String usr, String pswd) throws RemoteException {
		String s = " To Start the server";
		if(isOn){
//			writeToLogFile(String.format("Server Already Online;UserId=%s;Method=start();TimeStamp=%s", usr, LocalDateTime.now().toString()));
			return "Server is Online";}
		if (hasAccess(usr, pswd)) {
			writeToLogFile(String.format("Access Granted;UserId=%s;Method=start();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
			isOn = true;
			return "Print Server Started";
		} else {
			writeToLogFile(String.format("Access Denied;UserId=%s;Method=start();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
	}

	/**
	 *  This method is used to stop the server with authentication using Session ID.
	 *
	 * @param sessionId Session ID of the user
	 * @throws RemoteException
	 */
	public String stop(String sessionId) throws RemoteException {
		String s = " To Stop the server";
		if(!isOn){
//			writeToLogFile(String.format("Server Offline;SessionId=%s;Method=stop();TimeStamp=%s", sessionId, LocalDateTime.now().toString()));
			return "Print Server is Offline.";}
		if (hasAccess(sessionId)) {
			writeToLogFile(String.format("Access Granted;SessionId=%s;Method=stop();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
			parameters.clear();
			printers.forEach((key, value) -> {
				value.clear();
			});
			whitelist.clear();
			isOn = false;
			return "Print Server Stopped.";
		} else {
			writeToLogFile(String.format("Access Denied;SessionId=%s;Method=stop();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
	}

	/**
	 *  This method is used to stop the server with authentication using username and password.
	 *
	 * @param usr Username of the user
	 * @param pswd Password of the user
	 * @throws RemoteException
	 */
	public String stop(String usr, String pswd) throws RemoteException {
		String s = " To Stop the server";
		if(!isOn){
//			writeToLogFile(String.format("Server Offline;UserId=%s;Method=readConfig();TimeStamp=%s", usr, LocalDateTime.now().toString()));
			return "Print Server is Offline.";
		}
		if (hasAccess(usr, pswd)) {
			writeToLogFile(String.format("Access Granted;UserId=%s;Method=stop();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
			parameters.clear();
			printers.forEach((key, value) -> {
				value.clear();
			});
			whitelist.clear();
			isOn = false;
			return "Print Server Stopped.";
		} else {
			writeToLogFile(String.format("Access Denied;UserId=%s;Method=stop();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
	}

	/**
	 * This method is used to restart the server with authentication using Session ID.
	 *
	 * @param sessionId Session ID of the user
	 * @throws RemoteException
	 */
	public String restart(String sessionId) throws RemoteException {
		String s = " To Restart the server";
		if(!isOn){
//			writeToLogFile(String.format("Server Offline;SessionId=%s;Method=restart();TimeStamp=%s", sessionId, LocalDateTime.now().toString()));
			return "Print Server is Offline.";}
		if (hasAccess(sessionId)) {
			writeToLogFile(String.format("Access Granted;SessionId=%s;Method=restart();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
    		this.start(sessionId);
			this.stop(sessionId);
			return "Server Successfully Restarted.";
    	} else {
			writeToLogFile(String.format("Access Denied;SessionId=%s;Method=restart();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
	}

	/**
	 *  This method is used to restart the server with authentication using username and password.
	 *
	 * @param usr Username of the user
	 * @param pswd Password of the user
	 * @throws RemoteException
	 */
	public String restart(String usr, String pswd) throws RemoteException {
		String s = " To Restart the server";
		if(!isOn){
//			writeToLogFile(String.format("Server Offline;UserId=%s;Method=readConfig();TimeStamp=%s", usr, LocalDateTime.now().toString()));
			return "Print Server is Offline.";
		}
		if (hasAccess(usr, pswd)) {
			writeToLogFile(String.format("Access Granted;UserId=%s;Method=restart();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
    		this.start(usr, pswd);
			this.stop(usr, pswd);
			return "Server Successfully Restarted.";
    	} else {
			writeToLogFile(String.format("Access Denied;UserId=%s;Method=setConfig();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
	}


	/**
	 * This method is used to add a new configuration with authentication using Session ID.
	 *
	 * @param parameter Parameter of the configuration
	 * @param value Value of the configuration
	 * @param sessionId Session ID of the user
	 * @throws java.rmi.RemoteException
	 */
	public String setConfig(String parameter, String value, String sessionId) throws java.rmi.RemoteException {
		String s = " To Set Configuration for " + parameter + " with value " + value;
    	if(!isOn){
//			writeToLogFile(String.format("Server Offline;SessionId=%s;Method=setConfig();TimeStamp=%s", sessionId, LocalDateTime.now().toString()));
			return "Print Server is Offline.";}
		if (hasAccess(sessionId)) {
			writeToLogFile(String.format("Access Granted;SessionId=%s;Method=setConfig();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
    		parameters.put(parameter, value);
			return "Config File Successfully Updated.";
    	} else {
			writeToLogFile(String.format("Access Denied;SessionId=%s;Method=setConfig();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
    }

	/**
	 * This method is used to add a new configuration with authentication using username and password.
	 *
	 * @param parameter Parameter of the configuration
	 * @param value Value of the configuration
	 * @param usr Username of the user
	 * @param pswd Password of the user
	 * @throws java.rmi.RemoteException
	 */
	public String setConfig(String parameter, String value, String usr, String pswd) throws java.rmi.RemoteException {
		String s = " To Set Configuration for " + parameter + " with value " + value;
    	if(!isOn){
//			writeToLogFile(String.format("Server Offline;UserId=%s;Method=setConfig();TimeStamp=%s", usr, LocalDateTime.now().toString()));
			return "Print Server is Offline.";
		}
		if (hasAccess(usr, pswd)) {
			writeToLogFile(String.format("Access Granted;UserId=%s;Method=setConfig();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
    		parameters.put(parameter, value);
			return "Config File Successfully Updated";
    	} else {
			writeToLogFile(String.format("Access Denied;UserId=%s;Method=setConfig();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
    }

	/**
	 * This method is used to read the configuration with authentication using Session ID.
	 *
	 * @param parameter Parameter of the configuration
	 * @param sessionId Session ID of the user
	 * @return Value of the configuration
	 * @throws java.rmi.RemoteException
	 */
	public String readConfig(String parameter, String sessionId) throws java.rmi.RemoteException {
		String s = " To Read Configuration for " + parameter;
    	if(!isOn){
//			writeToLogFile(String.format("Server Offline;SessionId=%s;Method=readConfig();TimeStamp=%s", sessionId, LocalDateTime.now().toString()));
			return "Print Server is Offline.";}
		if (hasAccess(sessionId)) {
			writeToLogFile(String.format("Access Granted;SessionId=%s;Method=readConfig();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
    		return parameters.get(parameter);
    	} else {
			writeToLogFile(String.format("Access Denied;SessionId=%s;Method=readConfig();TimeStamp=%s" + s, sessionId, LocalDateTime.now().toString()));
			return "Access Denied.";
		}
    }

	/**
	 * This method is used to read the configuration with authentication using username and password.
	 *
	 * @param parameter Parameter of the configuration
	 * @param usr Username of the user
	 * @param pswd Password of the user
	 * @return Value of the configuration
	 * @throws java.rmi.RemoteException
	 */
	public String readConfig(String parameter, String usr, String pswd) throws java.rmi.RemoteException {
		String s = " To Read Configuration for " + parameter;
    	if(!isOn){
//			writeToLogFile(String.format("Server Offline;UserId=%s;Method=readConfig();TimeStamp=%s", usr, LocalDateTime.now().toString()));
			return "Print Server is Offline.";
		}

		if (hasAccess(usr, pswd)) {
			writeToLogFile(String.format("Access Granted;UserId=%s;Method=readConfig();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
    		return parameters.get(parameter);
    	} else {
			writeToLogFile(String.format("Access Denied;UserId=%s;Method=authenticate();TimeStamp=%s" + s, usr,LocalDateTime.now().toString()));
			return "Access Denied.";
		}
    }

	/**
	 * This method is used to authenticate the user.
	 *
	 * @param usr Username of the user
	 * @param pswd Password of the user
	 * @return Returns Login successful if the user is authenticated else returns Login failed.
	 * @throws java.rmi.RemoteException
	 */
	public String authenticate(String usr, String pswd) throws java.rmi.RemoteException {
		String s = " To Authenticate User " + usr;
		String sessionId = generateNewToken();
		if(!isOn){
//			writeToLogFile(String.format("Server Offline;UserId=%s;Method=authenticate();TimeStamp=%s", usr, LocalDateTime.now().toString()));
			return "Print Server is Offline.";}
		if (hasAccess(usr, pswd)) {
			writeToLogFile(String.format("Access Granted;UserId=%s;Method=authenticate();TimeStamp=%s" + s, usr, LocalDateTime.now().toString()));
			whitelist.add(sessionId);
			return "Login successful! Session ID: " + sessionId;
		} else {
			writeToLogFile(String.format("Access Denied;UserId=%s;Method=authenticate();TimeStamp=%s" + s, usr,LocalDateTime.now().toString()));
			return "Login failed!";
		}
	}

	public void addPrinter(String printer) throws Exception {
		if (!printers.containsKey(printer)){
			printers.put(printer,new LinkedList<String>());
		}
	}

	public String status(String printer, String usr, String pswd) throws RemoteException {
		String s = " To Get Status of Printer " + printer;
		if(!isOn)
		{
//			writeToLogFile(String.format("Server Offline;UserId=%s;Method=status();TimeStamp=%s", usr, LocalDateTime.now().toString()));
			return "Print Server is Off. Turn it on to see the status of the printer.";
		}
		if(hasAccess(usr, pswd)){
			if (printers.containsKey(printer)){
				writeToLogFile(String.format("Access Granted;UserId=%s;Method=status(printer);TimeStamp=%s" + s, usr, printer, LocalDateTime.now().toString()));
				return  String.format("%s is available. The number of files in the queue is: %d", printer, printers.get(printer).size());
			} else {
				return String.format("There is no printer with name : %s running on the server.", printer);
			}
		} else {
			writeToLogFile(String.format("Access Denied;UserId=%s;Method=status(printer);TimeStamp=%s" + s, usr,LocalDateTime.now().toString()));
			return  "Access Denied.";
		}
	}

	public String status(String printer, String sessionId) throws RemoteException {
		String s = "";
		if(!isOn)
		{	
			writeToLogFile(String.format("Server Offline;SessionId=%s;Method=status();TimeStamp=%s", sessionId, LocalDateTime.now().toString()));
			s = "Print Server is Off. Turn it on to see the status.";
		}

		if(hasAccess(sessionId)){
			writeToLogFile(String.format("Access Granted;SessionId=%s;Method=status();TimeStamp=%s", sessionId, LocalDateTime.now().toString()));
			if (printers.containsKey(printer)){
				s =  String.format("%s is available. The number of files in the queue is: %d", printer, printers.get(printer).size());
			} else {
				s = String.format("There is no printer with name : %s running on the server.", printer);
			}
		} else {
			writeToLogFile(String.format("Access Denied;SessionId=%s;Method=status();TimeStamp=%s", sessionId, LocalDateTime.now().toString()));
			s = "Access Denied.";
		}
		return s;
	}

	private Boolean hasAccess(String usr, String pswd){
		var database = (HashMap<String, String>) ApplicationServer.hashMapFromTextFile(ApplicationServer.pswdFile);
		if (database.containsKey(usr) && database.get(usr).equals(ApplicationServer.hash(usr,pswd))) {
			return true;
	   	} else {
			return false;
		}
	}

	private Boolean hasAccess(String sessionId){
		return whitelist.contains(sessionId);
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
	public static String generateNewToken() {
		byte[] randomBytes = new byte[24];
		secureRandom.nextBytes(randomBytes);
		return base64Encoder.encodeToString(randomBytes);
	}
}