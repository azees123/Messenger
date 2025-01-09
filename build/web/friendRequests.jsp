<%@ page import="java.util.List" %>
<%@ page import="dao.FriendDAO" %>
<%@ page import="models.User" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Friend Requests</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 20px;
        }
        h2 {
            color: #333;
        }
        .request {
            background: #fff;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        button.decline {
            background-color: #f44336;
        }
        button:hover {
            opacity: 0.8;
        }
        .back-link {
            display: block; /* Make the link a block element for centering */
            margin: 0 auto 20px; /* Center and add bottom margin */
            text-decoration: none;
            color: #3498db;
            text-align: center; /* Center text */
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .link-container {
            display: flex; /* Use flexbox to center the link */
            justify-content: center; /* Center horizontally */
        }
    </style>
</head>
<body>
    <h2>Friend Requests</h2>
    <%
        FriendDAO friendDAO = new FriendDAO();
        int userId = (Integer) session.getAttribute("userId"); // Assuming userId is stored in session

        // Fetch pending friend requests
        List<User> friendRequests = friendDAO.getFriendRequests(userId);
        if (friendRequests.isEmpty()) {
    %>
        <p>No friend requests.</p>
    <%
        } else {
            for (User user : friendRequests) {
    %>
                <div class="request">
                    <p><strong><%= user.getFullName() %></strong> wants to be your friend.</p>
                    <form method="post" action="acceptFriendRequest.jsp">
                        <input type="hidden" name="requestId" value="<%= user.getUserId() %>">
                        <button type="submit">Accept</button>
                    </form>
                    <form method="post" action="declineFriendRequest.jsp">
                        <input type="hidden" name="requestId" value="<%= user.getUserId() %>">
                        <button type="submit" class="decline">Decline</button>
                    </form>
                </div>
    <%
            }
        }
    %>
    <div class="link-container">
        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>
