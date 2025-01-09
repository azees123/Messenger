<%@ page session="true" %>
<%@page import="java.sql.*"%>
<%@page import="jakarta.servlet.http.*,jakarta.servlet.*"%>
<%
    Integer loggedInUserId = (Integer) session.getAttribute("userId");
    if (loggedInUserId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String dbURL = "jdbc:mysql://localhost:3306/messenger";
    String dbUser = "root";
    String dbPass = "";
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
        String sql = "SELECT u.user_id, u.full_name FROM friends f JOIN users u ON f.sender_id = u.user_id WHERE f.receiver_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, loggedInUserId);
        rs = ps.executeQuery();
%>
<html>
    <head>
        <title>Chat Users</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #eef2f3;
                margin: 0;
                padding: 20px;
                color: #333;
            }
            h2 {
                color: #4CAF50;
                text-align: center;
                margin-bottom: 20px;
                font-size: 28px;
                text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
                overflow: hidden;
                background-color: white;
            }
            th, td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #ddd;
                transition: background-color 0.3s;
            }
            th {
                background-color: #4CAF50;
                color: white;
            }
            tr:hover {
                background-color: #f9f9f9;
            }
            button {
                padding: 10px 15px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.2s;
                font-size: 14px;
            }
            button:hover {
                background-color: #45a049;
                transform: translateY(-2px);
            }
            .dashboard-link {
                display: block;
                text-align: center;
                margin-top: 20px;
                font-size: 16px;
                text-decoration: none;
                color: #4CAF50;
                font-weight: bold;
                transition: color 0.3s ease;
            }
            .dashboard-link:hover {
                color: #45a049;
            }
            .container {
                max-width: 800px;
                margin: 0 auto;
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                padding: 20px;
            }
            .no-friends {
                text-align: center;
                color: #777;
                font-size: 18px;
            }
        </style>
        <script>
            function startChat(userId) {
                window.location.href = 'chat.jsp?chatUserId=' + userId;
            }
        </script>
    </head>
    <body>
        <div class="container">
            <h2>Chat with Friends</h2>
            <table>
                <tr>
                    <th>Full Name</th>
                    <th>Action</th>
                </tr>
                <%
                    boolean hasFriends = false;
                    while (rs.next()) {
                        hasFriends = true;
                        String fullName = rs.getString("full_name");
                        int userId = rs.getInt("user_id");
                %>
                <tr>
                    <td><%= fullName %></td>
                    <td>
                        <button onclick="startChat(<%= userId %>)">Chat</button>
                    </td>
                </tr>
                <%
                    }
                    if (!hasFriends) {
                %>
                <tr>
                    <td colspan="2" class="no-friends">No friends to chat with.</td>
                </tr>
                <%
                    }
                %>
            </table>
            <a href="dashboard.jsp" class="dashboard-link">Go to Dashboard</a>
        </div>
    </body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) {
            rs.close();
        }
        if (ps != null) {
            ps.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>
