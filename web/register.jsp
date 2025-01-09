<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
    <style>
        body {
            background-color: #f4f4f4; /* Light grey background */
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh; /* Full viewport height */
            margin: 0;
        }

        .container {
            background: white; /* White background for the form */
            padding: 40px;
            border-radius: 8px; /* Rounded corners */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2); /* Shadow for depth */
            width: 400px; /* Fixed width for form */
        }

        h2 {
            text-align: center;
            color: #2c3e50; /* Dark color for headings */
            margin-bottom: 20px; /* Space below heading */
        }

        label {
            display: block; /* Block display for labels */
            margin-bottom: 5px; /* Space below labels */
            color: #333; /* Dark color for text */
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="file"] {
            width: 100%; /* Full width for inputs */
            padding: 10px; /* Padding inside inputs */
            border: 1px solid #ccc; /* Light grey border */
            border-radius: 4px; /* Rounded corners */
            margin-bottom: 20px; /* Space below inputs */
        }

        button {
            background-color: #3498db; /* Bright blue button color */
            color: #fff; /* White text color */
            padding: 10px; /* Button padding */
            border: none; /* Remove default border */
            border-radius: 5px; /* Rounded corners for button */
            width: 100%; /* Full width for button */
            font-size: 16px; /* Font size for button text */
            cursor: pointer; /* Pointer cursor on hover */
            transition: background-color 0.3s ease; /* Smooth transition for hover effect */
        }

        button:hover {
            background-color: #2980b9; /* Darker blue on hover */
        }

        .login-link {
            text-align: center; /* Center the link */
            margin-top: 15px; /* Space above link */
        }

        .login-link a {
            color: #3498db; /* Link color */
            text-decoration: none; /* Remove underline */
            font-size: 14px; /* Font size for link */
        }

        .login-link a:hover {
            text-decoration: underline; /* Underline on hover */
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Register</h2>
        <form action="RegisterServlet" method="post" enctype="multipart/form-data">
            <label for="fullName">Full Name:</label>
            <input type="text" id="fullName" name="fullName" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <label for="profilePicture">Profile Picture:</label>
            <input type="file" id="profilePicture" name="profilePicture" accept="image/*" required>

            <button type="submit">Register</button>
        </form>
        <div class="login-link">
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
        </div>
    </div>
</body>
</html>
