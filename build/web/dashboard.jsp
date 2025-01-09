<%@ page session="true" %>
<%@ page import="java.sql.Connection,java.sql.DriverManager,java.sql.ResultSet,java.sql.PreparedStatement,java.sql.Blob,java.util.Base64,java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard</title>
    <style>
        body {
            display: flex; /* Use flexbox for layout */
            font-family: 'Arial', sans-serif;
            margin: 0;
            background-color: #eef2f3; /* Light background */
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px; /* Fixed width for sidebar */
            background-color: #34495e; /* Darker blue background */
            padding: 20px; /* Padding inside sidebar */
            color: #ecf0f1; /* Light text color */
            display: flex;
            flex-direction: column; /* Stack sidebar links vertically */
            height: 100vh; /* Full height */
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1); /* Subtle shadow */
        }

        .sidebar h2 {
            font-size: 1.75em; /* Larger font size for heading */
            margin-bottom: 20px; /* Space below heading */
            text-align: center; /* Centered heading */
        }

        .sidebar a {
            display: block; /* Block display for links */
            color: #ecf0f1; /* Light link color */
            text-decoration: none; /* Remove underline */
            padding: 10px; /* Padding for links */
            border-radius: 5px; /* Rounded corners */
            transition: background-color 0.3s ease; /* Smooth transition for hover */
            margin-bottom: 10px; /* Space between links */
            font-weight: 500; /* Semi-bold text */
        }

        .sidebar a:hover {
            background-color: #2980b9; /* Bright blue on hover */
        }

        /* Main Content Styles */
        .main-content {
            flex: 1; /* Allow main content to take available space */
            padding: 40px; /* Increased padding for content */
            display: flex;
            flex-direction: column; /* Stack content vertically */
            align-items: center; /* Center content horizontally */
            background-color: #ffffff; /* White background for content */
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1); /* Shadow for depth */
            border-radius: 8px; /* Rounded corners */
            margin: 20px; /* Margin for spacing */
        }

        .profile-container {
            background: #ffffff; /* White background for profile section */
            padding: 20px; /* Padding inside container */
            border-radius: 8px; /* Rounded corners */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2); /* Shadow for depth */
            width: 100%; /* Full width */
            max-width: 600px; /* Maximum width for profile section */
            display: flex; /* Use flexbox for profile container */
            align-items: center; /* Center items vertically */
            justify-content: space-between; /* Space items evenly */
            margin-bottom: 20px; /* Space below profile container */
        }

        .profile-header {
            display: flex; /* Flexbox for profile layout */
            align-items: center; /* Center items vertically */
        }

        .profile-header img {
            border-radius: 50%; /* Circular profile picture */
            width: 80px; /* Width of profile picture */
            height: 80px; /* Height of profile picture */
            margin-right: 15px; /* Space between image and name */
            border: 2px solid #3498db; /* Blue border around profile picture */
        }

        .profile-header h1 {
            font-size: 1.8em; /* Larger font size for user's name */
            margin: 0; /* Remove default margin */
            color: #34495e; /* Darker color for the name */
        }

        .profile-header p {
            font-size: 0.9em; /* Smaller font size for user ID */
            color: #7f8c8d; /* Grey color for user ID */
            margin-top: 5px; /* Space above user ID */
            font-weight: 500; /* Semi-bold for user ID */
            text-align: center; /* Center the user ID text */
            background-color: rgba(255, 255, 255, 0.7); /* Light background for contrast */
            padding: 5px; /* Padding for a better look */
            border-radius: 4px; /* Rounded corners */
            box-shadow: 0 1px 5px rgba(0, 0, 0, 0.2); /* Subtle shadow for depth */
        }

        .action-links {
            display: flex; /* Use flexbox for action links */
            justify-content: space-around; /* Space action links evenly */
            align-items: center; /* Center action links vertically */
            margin-top: 20px; /* Space above action links */
        }

        .action-links a {
            display: inline-block; /* Inline block for spacing */
            background-color: #3498db; /* Bright blue button color */
            color: #fff; /* White text color */
            padding: 10px 15px; /* Button padding */
            border-radius: 5px; /* Rounded corners for buttons */
            text-decoration: none; /* Remove underline */
            transition: background-color 0.3s ease; /* Smooth transition for hover */
            font-weight: bold; /* Bold text */
            margin: 0 5px; /* Space between buttons */
        }

        .action-links a:hover {
            background-color: #2980b9; /* Darker blue on hover */
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>User Dashboard</h2>
        <a href="friendRequests.jsp">View Friend Requests</a>
        <a href="addFriend.jsp">Add Friend</a>
        <a href="chatsOne.jsp">Chat</a>
        <a href="viewfollowers.jsp">View Followers</a>
        <a href="logout.jsp">Logout</a> <!-- Logout link -->
    </div>

    <div class="main-content">
        <div class="profile-container">
            <div class="profile-header">
                <%
                    int userId = (int) session.getAttribute("userId");
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        // Database connection
                        String url = "jdbc:mysql://localhost:3306/messenger";
                        String username = "root";
                        String password = "";
                        conn = DriverManager.getConnection(url, username, password);

                        String sql = "SELECT full_name, profile_picture FROM users WHERE user_id=?";
                        stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, userId);

                        rs = stmt.executeQuery();

                        if (rs.next()) {
                            String fullName = rs.getString("full_name");
                            Blob blob = rs.getBlob("profile_picture");
                            byte[] imageData = blob.getBytes(1, (int) blob.length());
                            String base64Image = Base64.getEncoder().encodeToString(imageData);
                %>
                <img src="data:image/jpg;base64,<%= base64Image %>" alt="Profile Picture">
                <div>
                    <h1><%= fullName %></h1>
                    <p>User ID: <%= userId %></p> <!-- Displaying the user ID below the username -->
                </div>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) {
                            try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                        if (stmt != null) {
                            try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                        if (conn != null) {
                            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    }
                %>
            </div>
            <div class="action-links">
                <a href="friendRequests.jsp">View Friend Requests</a>
                <a href="addFriend.jsp">Add Friend</a>
                <a href="chatsOne.jsp">Chat</a>
            </div>
        </div>
    </div>
</body>
</html>
