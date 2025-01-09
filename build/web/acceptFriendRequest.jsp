<%@ page import="dao.FriendDAO" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Accept Friend Request</title>
</head>
<body>
<%
    // Retrieve the session from the request
    HttpSession currentSession = request.getSession(false); // Renamed from 'session' to 'currentSession'
    if (currentSession == null || currentSession.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp"); // Redirect if not logged in
        return;
    }

    int receiverId = (Integer) currentSession.getAttribute("userId"); // Current logged-in user
    int senderId = Integer.parseInt(request.getParameter("requestId")); // ID of the user who sent the request

    FriendDAO friendDAO = new FriendDAO();
    boolean isAccepted = friendDAO.acceptFriendRequest(senderId, receiverId);

    if (isAccepted) {
%>
        <p>Friend request accepted successfully!</p>
<%
    } else {
%>
        <p>Failed to accept the friend request.</p>
<%
    }
%>

<a href="friendRequests.jsp">Back to Friend Requests</a>
</body>
</html>
