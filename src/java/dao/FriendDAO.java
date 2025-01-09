package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.User;

public class FriendDAO {

    private Connection conn;

    public FriendDAO() {
        try {
            // Replace with your own database connection details
            String url = "jdbc:mysql://localhost:3306/messenger";
            String username = "root";
            String password = "";
            conn = DriverManager.getConnection(url, username, password);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Send a friend request
    public boolean sendFriendRequest(int senderId, int receiverId) {
        String checkSql = "SELECT COUNT(*) FROM friends WHERE sender_id = ? AND receiver_id = ?";
        String insertSql = "INSERT INTO friends (sender_id, receiver_id, status) VALUES (?, ?, 'pending')";

        try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            // Check if the friend request already exists
            checkStmt.setInt(1, senderId);
            checkStmt.setInt(2, receiverId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                // Friend request already exists
                return false;
            }

            // If no request exists, proceed with the insert
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setInt(1, senderId);
                insertStmt.setInt(2, receiverId);
                int rowsInserted = insertStmt.executeUpdate();
                return rowsInserted > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Accept a friend request
    public boolean acceptFriendRequest(int senderId, int receiverId) {
        String sql = "UPDATE friends SET status = 'accepted' WHERE sender_id = ? AND receiver_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, senderId);
            stmt.setInt(2, receiverId);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                // Add to friends table if request accepted
                String insertFriendSql = "INSERT INTO friend (user1_id, user2_id) VALUES (?, ?)";
                try (PreparedStatement friendStmt = conn.prepareStatement(insertFriendSql)) {
                    friendStmt.setInt(1, senderId);
                    friendStmt.setInt(2, receiverId);
                    friendStmt.executeUpdate();
                }
            }
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Decline a friend request
    public boolean declineFriendRequest(int senderId, int receiverId) {
        String sql = "UPDATE friends SET status = 'declined' WHERE sender_id = ? AND receiver_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, senderId);
            stmt.setInt(2, receiverId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get friend requests for a user
    public List<User> getFriendRequests(int userId) {
        List<User> friendRequests = new ArrayList<>();
        String sql = "SELECT u.user_id, u.full_name FROM friends fr JOIN users u ON fr.sender_id = u.user_id WHERE fr.receiver_id = ? AND fr.status = 'pending'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                friendRequests.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return friendRequests;
    }

    // Get friend requests by user ID
    public List<User> getFriendRequestsByUserId(int currentUserId, int searchUserId) {
        List<User> friendRequests = new ArrayList<>();
        String sql = "SELECT u.user_id, u.full_name FROM friends fr JOIN users u ON fr.sender_id = u.user_id WHERE fr.receiver_id = ? AND fr.sender_id = ? AND fr.status = 'pending'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, currentUserId);
            stmt.setInt(2, searchUserId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                friendRequests.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return friendRequests;
    }
}
