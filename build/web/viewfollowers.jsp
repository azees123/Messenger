<%@page import="java.sql.*"%>
<%@page import="jakarta.servlet.http.*,jakarta.servlet.*"%>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        h2 {
            text-align: center;
            margin: 20px 0;
            color: #333;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        table th, table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        table th {
            background-color: #4CAF50;
            color: white;
            font-size: 16px;
        }
        table td {
            font-size: 14px;
            color: #555;
        }
        table tr:hover {
            background-color: #f1f1f1;
        }
        .profile-pic {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .center {
            text-align: center;
        }
        /* Button styling */
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
        /* Responsive Design */
        @media (max-width: 768px) {
            table {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <h2>Followers</h2>
    <table>
        <tr>
            <th class="center">Profile Picture</th>
            <th>Full Name</th>
            <th>User ID</th>
        </tr>
        <%
            // Assuming this part is the backend logic already implemented.
            Integer loggedInUserId = (Integer) session.getAttribute("userId");

            if (loggedInUserId == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            // Database connection details
            String dbURL = "jdbc:mysql://localhost:3306/messenger";
            String dbUser = "root";
            String dbPass = "";

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                String sql = "SELECT u.user_id, u.full_name "
                           + "FROM friends f "
                           + "JOIN users u ON f.sender_id = u.user_id "
                           + "WHERE f.receiver_id = ?";

                ps = conn.prepareStatement(sql);
                ps.setInt(1, loggedInUserId);
                rs = ps.executeQuery();

                while (rs.next()) {
                    String fullName = rs.getString("full_name");
                    int userId = rs.getInt("user_id");
        %>
        <tr>
            <td class="center">
                <img src="ProfilePictureServlet?userId=<%= userId %>" class="profile-pic" alt="Profile Picture">
            </td>
            <td><%= fullName %></td>
            <td><%= userId %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
    <a href="dashboard.jsp" class="btn">Go Back</a>
</body>
</html>
