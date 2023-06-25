import java.io.IOException;
import java.rmi.Remote;
import java.util.List;

public interface HelloServiceListBased extends Remote {

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

    public String editUsers(String usr, String pwd, String method, List<String> newUsers) throws java.rmi.RemoteException, IOException;

    public String editUsers(String sessionId, String method, List<String> newUsers) throws java.rmi.RemoteException, IOException;

    public String removeAllUsers(String sessionId, String methodToEdit) throws IOException;

    public String removeAllUsers(String usr, String pwd, String methodToEdit) throws IOException;

    public String addUsers(String sessionId, String methodToEdit, List<String> usersToAdd) throws IOException;

    public String addUsers(String usr, String pwd, String methodToEdit, List<String> usersToAdd) throws IOException;

    public String removeUsers(String sessionId, String methodToEdit, List<String> usersToRemove) throws IOException;

    public String removeUsers(String usr, String pwd, String methodToEdit, List<String> usersToRemove) throws IOException;

    public String changeUser(String sessionId, String userOld, String userNew) throws IOException;

    public String changeUser(String usr, String pwd, String userOld, String userNew) throws IOException;
}