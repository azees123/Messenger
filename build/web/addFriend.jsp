<%@ page session="true" %>
<%@ page import="java.util.List, models.User" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Add Friend</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #eef2f3;
                padding: 20px;
            }

            h2 {
                color: #34495e;
            }

            .user-list {
                list-style-type: none;
                padding: 0;
            }

            .user-list li {
                background-color: #fff;
                padding: 15px;
                margin: 10px 0;
                border-radius: 5px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
            }

            .user-list form {
                display: inline;
            }

            button {
                background-color: #3498db;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 5px;
                cursor: pointer;
            }

            button:hover {
                background-color: #2980b9;
            }

            .search-container {
                margin-bottom: 20px;
            }

            .search-container input {
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            .search-container button {
                padding: 10px;
                border: none;
                background-color: #27ae60;
                color: white;
                border-radius: 5px;
                cursor: pointer;
            }

            .search-container button:hover {
                background-color: #219653;
            }

            .btn {
                display: inline-block;
                padding: 10px 20px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 5px;
                text-align: center;
                font-size: 14px;
                margin: 20px auto;
                display: block;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            .btn:hover {
                background-color: #45a049;
            }
        </style>
    </head>
    <body>
        <h2>Add Friend</h2>

        <div class="search-container">
            <form action="searchUserServlet" method="post">
                <input type="text" name="searchQuery" placeholder="Search by name or email" required>
                <button type="submit">Search</button>
            </form>
        </div>

        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
        <p style="color:red;"><%= errorMessage%></p>
        <%
            }

            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                out.println("You must be logged in to add friends.");
                return;
            }

            List<User> users = (List<User>) request.getAttribute("users");
            if (users == null || users.isEmpty()) {
                out.println("<p>No users found.</p>");
            } else {
        %>
        <ul class="user-list">
            <%
                for (User user : users) {
                    int friendId = user.getUserId();
                    String fullName = user.getFullName();
                    String email = user.getEmail();
                    if (friendId != userId) { // Ensure the logged-in user is not displayed
            %>
            <li>
                <span><%= fullName%> (<%= email%>)</span>
                <form action="AddFriendServlet" method="post">
                    <input type="hidden" name="receiverId" value="<%= friendId%>">
                    <button type="submit">Add Friend</button>
                </form>
            </li>
            <%
                    }
                }
            %>
        </ul>
        <%
            }
        %>
        <a href="dashboard.jsp" class="btn">Dashboard</a>
    </body>
</html>
