import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@ServerEndpoint("/chat")
public class ChatServer {
    private static final List<Session> clients = new ArrayList<>();

    @OnOpen
    public void onOpen(Session session) {
        clients.add(session);
        System.out.println("New client connected: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        System.out.println("Message from client " + session.getId() + ": " + message);
        broadcast(message, session);
    }

    @OnClose
    public void onClose(Session session) {
        clients.remove(session);
        System.out.println("Client disconnected: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("Error on session " + session.getId() + ": " + throwable.getMessage());
    }

    private void broadcast(String message, Session senderSession) {
        for (Session client : clients) {
            if (client != senderSession) {
                try {
                    client.getBasicRemote().sendText(message);
                } catch (IOException e) {
                    System.err.println("Error sending message to client " + client.getId() + ": " + e.getMessage());
                }
            }
        }
    }
}
