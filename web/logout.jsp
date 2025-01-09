<%@ page session="true" %>
<%
    // Invalidate the session to log out the user
    session.invalidate();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
        }
        .message {
            padding: 20px;
            background-color: #2ecc71;
            color: #fff;
            font-size: 1.2em;
            border-radius: 8px;
        }
    </style>
    <script>
        // Redirect to login.jsp after 1 second
        setTimeout(function() {
            window.location.href = 'login.jsp';
        }, 1000); // 1000 milliseconds = 1 second
    </script>
</head>
<body>
    <div class="message">
        Logout successful! Redirecting to login page...
    </div>
</body>
</html>
