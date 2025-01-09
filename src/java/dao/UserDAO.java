package dao;

import java.sql.*;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import models.User;

public class UserDAO {

    private Connection conn;
    private final String DB_URL = "jdbc:mysql://localhost:3306/messenger";
    private final String USER = "root";
    private final String PASS = "";

    public UserDAO() {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the connection
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (ClassNotFoundException e) {
            e.printStackTrace(); // Driver not found
        } catch (SQLException e) {
            e.printStackTrace(); // Connection error
        }
    }

    public boolean registerUser(String fullName, String email, String password, InputStream profilePicture) {
        String sql = "INSERT INTO users (full_name, email, password, profile_picture) VALUES (?, ?, ?, ?)";
        try {
            if (conn == null) {
                throw new IllegalStateException("Database connection is not established.");
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setBlob(4, profilePicture);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public User validateUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try {
            if (conn == null) {
                throw new IllegalStateException("Database connection is not established.");
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setProfilePicture(rs.getBlob("profile_picture"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getUserIdByEmail(String email) {
        String sql = "SELECT user_id FROM users WHERE email = ?";
        try {
            if (conn == null) {
                throw new IllegalStateException("Database connection is not established.");
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Return -1 if user is not found
    }

    public List<User> searchUsers(String searchQuery, Integer loggedInUserId) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE (full_name LIKE ? OR email LIKE ?) AND user_id != ?";

        try {
            if (conn == null) {
                throw new IllegalStateException("Database connection is not established.");
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + searchQuery + "%");
            stmt.setString(2, "%" + searchQuery + "%");
            stmt.setInt(3, loggedInUserId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                // Set other fields as needed
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    // Close the connection when no longer needed
    public void close() {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
