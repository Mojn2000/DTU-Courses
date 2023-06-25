import java.rmi.Remote;

public interface HelloServiceRBAC extends Remote {

    public String echo(String s) throws java.rmi.RemoteException;

    public void addPrinter(String printer) throws Exception;

    public String print(String filename, String printer, String sessionId) throws java.rmi.RemoteException;
    public String print(String filename, String printer, String usr, String pswd) throws java.rmi.RemoteException;
    
    public String status(String printer, String usr, String pswd) throws java.rmi.RemoteException;
    public String status(String printer, String sessionId) throws java.rmi.RemoteException;

    public String queue(String printer, String sessionId) throws java.rmi.RemoteException;
    public String queue(String printer, String usr, String pswd) throws java.rmi.RemoteException;
    
    public String topQueue(String printer, String e, String sessionId) throws java.rmi.RemoteException;
    public String topQueue(String printer, String e, String usr, String pswd) throws java.rmi.RemoteException;
    
    public String start(String sessionId) throws java.rmi.RemoteException;
    public String start(String usr, String pswd) throws java.rmi.RemoteException;
    
    public String stop(String sessionId) throws java.rmi.RemoteException;
    public String stop(String usr, String pswd) throws java.rmi.RemoteException;
    
    public String restart(String sessionId) throws java.rmi.RemoteException;
    public String restart(String usr, String pswd) throws java.rmi.RemoteException;
    
    public String readConfig(String key, String sessionId) throws java.rmi.RemoteException;
    public String readConfig(String key, String usr, String pswd) throws java.rmi.RemoteException;
    
    public String setConfig(String key, String value, String sessionId) throws java.rmi.RemoteException;
    public String setConfig(String key, String value, String usr, String pswd) throws java.rmi.RemoteException;
    
    public String authenticate(String usr, String pswd) throws java.rmi.RemoteException;
    
    public int addRole(String newUsr, String role, String sessionId) throws java.rmi.RemoteException;
    public int addRole(String newUsr, String role, String usr, String pswd) throws java.rmi.RemoteException;
    
    public int removeRole(String newUsr, String role, String sessionId) throws java.rmi.RemoteException;
    public int removeRole(String newUsr, String role, String usr, String pswd) throws java.rmi.RemoteException;
    
    public int addUser(String newUsr, String newPswd, String sessionId) throws java.rmi.RemoteException;
    public int addUser(String newUsr, String newPswd, String usr, String pswd) throws java.rmi.RemoteException;
    
    public int removeUser(String newUsr, String sessionId) throws java.rmi.RemoteException;
    public int removeUser(String newUsr, String usr, String pswd) throws java.rmi.RemoteException;
}
