<%@ page session="true" %>
<%
    Integer loggedInUserId = (Integer) session.getAttribute("userId");
    String chatUserId = request.getParameter("chatUserId");

    if (loggedInUserId == null || chatUserId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Chat</title>
    <script type="text/javascript">
        var ws;

        function connect() {
            try {
                ws = new WebSocket("ws://192.168.1.55:8089/Messenger/chat?loggedInUserId=<%= loggedInUserId %>&chatUserId=<%= chatUserId %>");


                ws.onopen = function() {
                    console.log("WebSocket connection established.");
                };

                ws.onmessage = function(event) {
                    displayMessage(event.data);
                };

                ws.onerror = function(event) {
                    console.error("WebSocket error: ", event);
                    alert("Error connecting to WebSocket server. Please check your network connection or the server status.");
                };

                ws.onclose = function() {
                    console.log("WebSocket connection closed");
                    alert("Connection to the server has been closed. Please try reconnecting.");
                };

            } catch (e) {
                console.error("WebSocket connection failed: ", e);
                alert("Failed to connect to WebSocket server: " + e.message);
            }
        }

        function displayMessage(message) {
            var log = document.getElementById("log");
            var messageDiv = document.createElement("div");
            messageDiv.innerHTML = message; // Display message content
            log.appendChild(messageDiv);
            log.scrollTop = log.scrollHeight; // Scroll to the bottom
        }

        function sendMessage() {
            var message = document.getElementById("message").value;
            if (message.trim() !== '') {
                ws.send(message);
                document.getElementById("message").value = ''; // Clear input
            }
        }
    </script>
</head>
<body onload="connect()">
    <div id="log" style="height: 300px; overflow-y: auto; border: 1px solid #ccc;"></div>
    <input type="text" id="message" placeholder="Type your message here..." />
    <button onclick="sendMessage()">Send</button>
</body>
</html>
