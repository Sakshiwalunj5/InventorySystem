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
<title>Low Stock</title>

<style>
body{margin:0;font-family:Segoe UI;background:#f4f6f9;}

.navbar{background:#1e3a8a;color:white;padding:15px;display:flex;justify-content:space-between;}
.sidebar{width:200px;background:#111827;height:100vh;position:fixed;padding-top:20px;}
.sidebar a{display:block;color:white;padding:12px;text-decoration:none;}
.sidebar a:hover{background:#2563eb;}
.main{margin-left:200px;padding:40px;}

table{
    width:80%;
    margin:auto;
    background:white;
    border-collapse:collapse;
    box-shadow:0 2px 8px rgba(0,0,0,0.2);
}

th{
    background:#dc3545;
    color:white;
    padding:10px;
}

td{
    padding:10px;
    border-bottom:1px solid #ddd;
    text-align:center;
}

/* highlight critical */
.low { background:#fff3cd; }   /* warning */
.critical { background:#f8d7da; } /* danger */

.msg{
    text-align:center;
    font-weight:bold;
    color:green;
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

<h2>Low Stock Products</h2>

<table>
<tr>
<th>Product</th>
<th>Category</th>
<th>Supplier</th>
<th>Quantity</th>
<th>Min Level</th>
</tr>

<%
boolean hasData = false;

try{
Connection con = DBConnection.getConnection();
Statement st = con.createStatement();

ResultSet rs = st.executeQuery(
"SELECT p.product_name, c.category_name, sp.supplier_name, s.quantity, s.min_level " +
"FROM STOCK s " +
"JOIN PRODUCTS p ON s.product_id = p.product_id " +
"LEFT JOIN CATEGORIES c ON p.category_id = c.category_id " +
"LEFT JOIN SUPPLIERS sp ON p.supplier_id = sp.supplier_id " +
"WHERE s.quantity <= s.min_level"
);

while(rs.next()){
    hasData = true;

    int qty = rs.getInt("quantity");
    int min = rs.getInt("min_level");

    String rowClass = (qty <= min/2) ? "critical" : "low";
%>

<tr class="<%=rowClass%>">
<td><%=rs.getString("product_name")%></td>
<td><%=rs.getString("category_name") != null ? rs.getString("category_name") : "-"%></td>
<td><%=rs.getString("supplier_name") != null ? rs.getString("supplier_name") : "-"%></td>
<td><%=qty%></td>
<td><%=min%></td>
</tr>

<%
}

if(!hasData){
%>
<tr>
<td colspan="5" class="msg">No low stock items 🎉</td>
</tr>
<%
}

}catch(Exception e){
    e.printStackTrace();
}
%>

</table>

</div>
</body>
</html>