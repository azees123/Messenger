import jakarta.websocket.*;
import java.io.IOException;
import java.net.URI;

@ClientEndpoint
public class ChatClient {
    private Session session;

    public void connect(String uri) throws Exception {
        WebSocketContainer container = ContainerProvider.getWebSocketContainer();
        container.connectToServer(this, new URI(uri));
    }

    @OnOpen
    public void onOpen(Session session) {
        this.session = session;
        System.out.println("Connected to server");
    }

    @OnMessage
    public void onMessage(String message) {
        System.out.println("Message from server: " + message);
    }

    @OnClose
    public void onClose(Session session) {
        System.out.println("Disconnected from server");
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("Error: " + throwable.getMessage());
    }

    public void sendMessage(String message) {
        try {
            session.getBasicRemote().sendText(message);
        } catch (IOException e) {
            System.err.println("Error sending message: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        ChatClient client = new ChatClient();
        try {
            client.connect("ws://192.168.1.17:8089/chat"); // Use the appropriate IP and port
            // Send a test message
            client.sendMessage("Hello, server!");
        } catch (Exception e) {
            System.err.println("Failed to connect: " + e.getMessage());
        }
    }
}
