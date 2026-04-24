<%@ page import="java.sql.*,com.inventory.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
if(session.getAttribute("user_id")==null){
    response.sendRedirect("login.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>

<style>
body {
    margin:0;
    font-family: 'Segoe UI';
    background:#f4f6f9;
}

.navbar {
    background:#1e3a8a;
    color:white;
    padding:15px;
    display:flex;
    justify-content:space-between;
}

.sidebar {
    width:200px;
    background:#111827;
    height:100vh;
    position:fixed;
    padding-top:20px;
}

.sidebar a {
    display:block;
    color:white;
    padding:12px;
    text-decoration:none;
}

.sidebar a:hover {
    background:#2563eb;
}

.main {
    margin-left:200px;
    padding:20px;
}

.card-container {
    display:flex;
    gap:20px;
    flex-wrap:wrap;
}

.card {
    flex:1;
    min-width:200px;
    background:white;
    padding:20px;
    border-radius:10px;
    box-shadow:0 2px 8px rgba(0,0,0,0.2);
    text-align:center;
}

.card h3 {
    margin:0;
    color:#555;
}

.card p {
    font-size:22px;
    font-weight:bold;
}
</style>
</head>

<body>

<div class="navbar">
<div>Inventory System</div>
<div><a href="logout.jsp" style="color:white;">Logout</a></div>
</div>

<div class="sidebar">
<a href="index.jsp">Dashboard</a>
<a href="TestServlet">Products</a>
<a href="addSale.jsp">Add Sale</a>
<a href="report.jsp">Reports</a>
<a href="lowStock.jsp">Low Stock</a>
</div>

<div class="main">

<h2>Dashboard</h2>

<%
int totalBills = 0;
int totalCustomers = 0;
int totalItemsSold = 0;
double revenue = 0;

try{
    Connection con = DBConnection.getConnection();
    Statement st = con.createStatement();

    // ✅ Total bills (sales entries)
    ResultSet r1 = st.executeQuery("SELECT COUNT(*) FROM SALES");
    if(r1.next()) totalBills = r1.getInt(1);

    // ✅ Total customers
    ResultSet r2 = st.executeQuery("SELECT COUNT(*) FROM CUSTOMERS");
    if(r2.next()) totalCustomers = r2.getInt(1);

    // ✅ Revenue
    ResultSet r3 = st.executeQuery("SELECT IFNULL(SUM(total_amount),0) FROM SALES");
    if(r3.next()) revenue = r3.getDouble(1);

    // ✅ Total items sold (from SALE_ITEMS)
    ResultSet r4 = st.executeQuery("SELECT IFNULL(SUM(quantity),0) FROM SALE_ITEMS");
    if(r4.next()) totalItemsSold = r4.getInt(1);

}catch(Exception e){
    e.printStackTrace();
}
%>

<div class="card-container">

    <div class="card">
        <h3>Total Bills</h3>
        <p><%=totalBills%></p>
    </div>

    <div class="card">
        <h3>Total Items Sold</h3>
        <p><%=totalItemsSold%></p>
    </div>

    <div class="card">
        <h3>Total Customers</h3>
        <p><%=totalCustomers%></p>
    </div>

    <div class="card">
        <h3>Total Revenue</h3>
        <p>₹ <%=revenue%></p>
    </div>

</div>

</div>

</body>
</html>