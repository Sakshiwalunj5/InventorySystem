<%@ page contentType="text/html;charset=UTF-8" %>

<%
if(session.getAttribute("user_id") != null){
    response.sendRedirect("index.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Login</title>

<style>
body {
    margin:0;
    font-family:'Segoe UI';
    background: linear-gradient(135deg, #4facfe, #00f2fe);
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
}

.box {
    background:white;
    padding:30px;
    width:320px;
    border-radius:12px;
    box-shadow:0 4px 15px rgba(0,0,0,0.3);
    text-align:center;
}

h2 {
    margin-bottom:15px;
}

input {
    width:100%;
    padding:10px;
    margin:10px 0;
    border:1px solid #ccc;
    border-radius:6px;
}

button {
    width:100%;
    padding:10px;
    background:#007bff;
    color:white;
    border:none;
    border-radius:6px;
    cursor:pointer;
}

button:hover {
    background:#0056b3;
}

.error { 
    color:red; 
    margin-bottom:10px;
}

.success {
    color:green;
    margin-bottom:10px;
}
</style>
</head>

<body>

<div class="box">

<h2>Inventory Login</h2>

<%
String error = request.getParameter("error");
String success = request.getParameter("success");

if(error != null){
    if(error.equals("invalid")){
%>
        <p class="error">Invalid username or password</p>
<%
    } else if(error.equals("server")){
%>
        <p class="error">Server error. Try again.</p>
<%
    } else if(error.equals("inactive")){
%>
        <p class="error">Account is inactive</p>
<%
    }
}

if(success != null){
%>
    <p class="success">Account created successfully! Please login.</p>
<%
}
%>

<form action="LoginServlet" method="post">

<input type="text" name="username" placeholder="Username" required>

<input type="password" name="password" placeholder="Password" required>

<button type="submit">Login</button>

</form>

<br>
<a href="registration.jsp">Create Account</a>

</div>

</body>
</html>