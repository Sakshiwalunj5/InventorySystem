<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<title>Register</title>

<style>
body {
    margin:0;
    font-family:'Segoe UI';
    background: linear-gradient(135deg, #43e97b, #38f9d7);
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
}

.box {
    background:white;
    padding:30px;
    width:340px;
    border-radius:12px;
    box-shadow:0 4px 15px rgba(0,0,0,0.3);
    text-align:center;
}

input, select {
    width:100%;
    padding:10px;
    margin:10px 0;
    border:1px solid #ccc;
    border-radius:6px;
}

button {
    width:100%;
    padding:10px;
    background:#28a745;
    color:white;
    border:none;
    border-radius:6px;
    cursor:pointer;
}

button:hover {
    background:#218838;
}

.msg { color:green; font-size:14px; }
.error { color:red; font-size:14px; }
</style>

<script>
function validateForm(){
    let pass = document.getElementById("password").value;
    let confirm = document.getElementById("confirm").value;

    if(pass !== confirm){
        alert("Passwords do not match");
        return false;
    }
    return true;
}
</script>

</head>

<body>

<div class="box">

<h2>Create Account</h2>

<%
String error = request.getParameter("error");
String success = request.getParameter("success");

if(success != null){
%>
<p class="msg">Registration Successful! Login now</p>
<%
}

if(error != null){
    if(error.equals("exists")){
%>
<p class="error">Username already exists</p>
<%
    } else if(error.equals("server")){
%>
<p class="error">Something went wrong</p>
<%
    } else if(error.equals("invalid")){
%>
<p class="error">Invalid input data</p>
<%
    }
}
%>

<form action="RegisterServlet" method="post" onsubmit="return validateForm()">

<input type="text" name="username" placeholder="Username" required>

<input type="email" name="email" placeholder="Email" required>

<input type="text" name="phone" placeholder="Phone Number" required>

<input type="password" id="password" name="password" placeholder="Password" required>

<input type="password" id="confirm" placeholder="Confirm Password" required>

<select name="role">
<option value="staff">Staff</option>
<option value="admin">Admin</option>
</select>

<button type="submit">Register</button>

</form>

<br>
<a href="login.jsp">⬅ Back to Login</a>

</div>

</body>
</html>