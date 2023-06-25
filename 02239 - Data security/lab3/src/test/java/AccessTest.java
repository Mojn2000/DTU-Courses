import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.rmi.Naming;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

public class AccessTest {


    static HelloServiceListBased service;

    static {
        try {
            service = (HelloServiceListBased) Naming.lookup("rmi://localhost:1099/HelloService");
        } catch (Exception e) {
        }
    }


    @Test
    public void testEditUsersPwdSuccess() throws IOException {
        service.start("usr0", "pswd0");
        assertNotEquals(service.editUsers("usr0", "pswd0", "test", new ArrayList<>(List.of("usr1", "usr2"))), "Access Denied.");
        service.stop("usr0", "pswd0");


    }

    @Test
    public void testEditUsersPwdFail() throws IOException {
        service.start("usr0", "pswd0");
        assertEquals(service.editUsers("usr0", "wrong", "test", new ArrayList<>(List.of("usr1", "usr2"))), "Access Denied.");
        service.stop("usr0", "pswd0");

    }

    @Test
    public void testEditUsersSessionSuccess() throws IOException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertNotEquals(service.editUsers(sessionId, "test", new ArrayList<>(List.of("usr1", "usr2"))), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testEditUserSessionFail() throws IOException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertEquals(service.editUsers("wrong", "test", new ArrayList<>(List.of("usr1", "urs2"))), "Access Denied.");
        service.stop("usr0", "pswd0");
    }


    @Test
    public void testAddUsersPwdSuccess() throws IOException {
        service.start("usr0", "pswd0");
        assertNotEquals(service.addUsers("usr0", "pswd0", "test", new ArrayList<>(List.of("usr3", "usr4"))), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testAddUsersPwdFail() throws IOException {
        service.start("usr0", "pswd0");
        assertEquals(service.addUsers("usr0", "wrong", "test", new ArrayList<>(List.of("usr3", "usr4"))), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testAddUsersSessionSuccess() throws IOException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertNotEquals(service.addUsers(sessionId, "test", new ArrayList<>(List.of("usr3", "usr4"))), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testAddUsersSessionFail() throws IOException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        assertEquals(service.addUsers("wrong", "test", new ArrayList<>(List.of("usr3", "usr4"))), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testRemoveAllUsersPwdSuccess() throws IOException {
        service.start("usr0", "pswd0");
        service.addUsers("usr0", "pswd0", "test2", new ArrayList<>(List.of("usr1", "usr2")));
        assertNotEquals(service.removeAllUsers("usr0", "pswd0", "test2"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testRemoveAllUsersPwdFail() throws IOException {
        service.start("usr0", "pswd0");
        service.addUsers("usr0", "pswd0", "test2", new ArrayList<>(List.of("usr1", "usr2")));
        assertEquals(service.removeAllUsers("usr0", "wrong", "test2"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testRemoveAllUsersSessionSuccess() throws IOException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        service.addUsers(sessionId, "test2", new ArrayList<>(List.of("usr1", "usr2")));
        assertNotEquals(service.removeAllUsers(sessionId, "test2"), "Access Denied.");
        service.stop("usr0", "pswd0");

    }

    @Test
    public void testRemoveAllUsersSessionFail() throws IOException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        service.addUsers(sessionId, "test2", new ArrayList<>(List.of("usr1", "usr2")));
        assertEquals(service.removeAllUsers("wrong", "test2"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testRemoveUsersPwdSuccess() throws IOException {
        service.start("usr0", "pswd0");
        service.addUsers("usr0", "pswd0", "test3", new ArrayList<>(List.of("usr3", "usr4", "usr5")));
        assertNotEquals(service.removeUsers("usr0", "pswd0", "test3", new ArrayList<>(List.of("usr3", "usr4"))), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testRemoveUsersPwdFail() throws IOException {
        service.start("usr0", "pswd0");
        service.addUsers("usr0", "pswd0", "test3", new ArrayList<>(List.of("usr3", "usr4", "usr5")));
        assertEquals(service.removeUsers("usr0", "wrong", "test3", new ArrayList<>(List.of("usr3", "usr4"))), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testRemoveUsersSessionSuccess() throws IOException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        service.addUsers(sessionId, "test3", new ArrayList<>(List.of("usr3", "usr4", "usr5")));
        assertNotEquals(service.removeUsers(sessionId, "test3", new ArrayList<>(List.of("usr3", "usr4"))), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testRemoveUsersSessionFail() throws IOException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        service.addUsers(sessionId, "test3", new ArrayList<>(List.of("usr3", "usr4", "usr5")));
        assertEquals(service.removeUsers("wrong", "test3", new ArrayList<>(List.of("usr3", "usr4", "usr5"))), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testChangeUserPwdSuccess() throws IOException {
        service.start("usr0", "pswd0");
        service.addUsers("usr0", "pswd0", "test4", new ArrayList<>(List.of("usr3")));
        service.addUsers("usr0", "pswd0", "test5", new ArrayList<>(List.of("usr3")));
        assertNotEquals(service.changeUser("usr0", "pswd0", "usr3", "usr4"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testChangeUserPwdFail() throws IOException {
        service.start("usr0", "pswd0");
        service.addUsers("usr0", "pswd0", "test4", new ArrayList<>(List.of("usr3")));
        service.addUsers("usr0", "pswd0", "test5", new ArrayList<>(List.of("usr3")));
        assertEquals(service.changeUser("usr0", "wrong", "usr3", "usr4"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testChangeUserSessionSuccess() throws IOException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        service.addUsers(sessionId, "qqq", new ArrayList<>(List.of("usr5")));
        service.addUsers(sessionId, "qcewc3", new ArrayList<>(List.of("usr5")));
        assertNotEquals(service.changeUser(sessionId, "usr5", "usr6"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }

    @Test
    public void testChangeUserSessionFail() throws IOException {
        service.start("usr0", "pswd0");
        String sessionId = service.authenticate("usr0", "pswd0").split(" ")[4];
        service.addUsers(sessionId, "test6", new ArrayList<>(List.of("usr5")));
        service.addUsers(sessionId, "test7", new ArrayList<>(List.of("usr5")));
        assertNotEquals(service.changeUser(sessionId, "usr5", "usr6"), "Access Denied.");
        service.stop("usr0", "pswd0");
    }
}
