import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.List;

public class FinalTaskTest {

    static HelloServiceListBased service;

    static {
        try {
            service = (HelloServiceListBased) Naming.lookup("rmi://localhost:1099/HelloService");
        } catch (Exception e) {
        }
    }

    @Test
    public void testFinalTest() throws IOException {
        service.start("Alice","pwd");
        service.changeUser("Alice","pwd", "Bob","George");
        service.addUsers("Alice","pwd", "print", new ArrayList<>(List.of("Henry")));
        service.addUsers("Alice","pwd", "queue", new ArrayList<>(List.of("Henry")));

        service.addUsers("Alice","pwd", "print", new ArrayList<>(List.of("Ida")));
        service.addUsers("Alice","pwd", "queue", new ArrayList<>(List.of("Ida")));
        service.addUsers("Alice","pwd", "topQueue", new ArrayList<>(List.of("Ida")));
        service.addUsers("Alice","pwd", "restart", new ArrayList<>(List.of("Ida")));

        service.stop("Alice","pwd");
    }

}
