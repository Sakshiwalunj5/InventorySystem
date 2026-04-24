<%@ page import="java.sql.*,com.inventory.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    HttpSession sess = request.getSession(false);
    if(sess == null || sess.getAttribute("user_id") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // Fetch categories for dropdowns
    Connection con = DBConnection.getConnection();
    ResultSet catRs = con.createStatement().executeQuery(
        "SELECT category_id, category_name FROM CATEGORIES ORDER BY category_name"
    );
%>
<!DOCTYPE html>
<html>
<head>
<title>Reports – Inventory System</title>
<style>
    *{ box-sizing:border-box; margin:0; padding:0; }
    body{ font-family:'Segoe UI',sans-serif; background:#f4f6f9; }

    .navbar{
        background:#1e3a8a; color:white; padding:15px 25px;
        display:flex; justify-content:space-between; align-items:center;
        position:fixed; top:0; width:100%; z-index:100;
    }
    .navbar a{ color:white; text-decoration:none; font-size:14px; }

    .sidebar{
        width:180px; background:#111827; height:100vh;
        position:fixed; top:56px; padding-top:10px;
    }
    .sidebar a{
        display:block; color:#d1d5db; padding:12px 20px;
        text-decoration:none; font-size:14px; border-left:3px solid transparent;
    }
    .sidebar a:hover, .sidebar a.active{
        background:#1f2937; color:white; border-left:3px solid #2563eb;
    }

    .main{ margin-left:180px; padding:80px 30px 30px 30px; }

    /* Tab buttons */
    .tab-bar{
        display:flex; gap:10px; margin-bottom:24px; flex-wrap:wrap;
    }
    .tab-btn{
        padding:11px 24px; border:2px solid #d1d5db; border-radius:8px;
        background:white; cursor:pointer; font-size:14px; font-weight:600;
        color:#6b7280; transition:all 0.2s;
    }
    .tab-btn.active{
        background:#1e3a8a; color:white; border-color:#1e3a8a;
    }
    .tab-btn:hover:not(.active){ border-color:#2563eb; color:#2563eb; }

    /* Tab panels */
    .tab-panel{ display:none; }
    .tab-panel.active{ display:block; }

    /* Filter card */
    .filter-card{
        background:white; border-radius:12px;
        box-shadow:0 2px 10px rgba(0,0,0,0.1);
        padding:24px 26px; margin-bottom:22px;
        max-width:860px;
    }
    .filter-card h3{
        color:#1e3a8a; font-size:16px; margin-bottom:18px;
        border-bottom:2px solid #e5e7eb; padding-bottom:10px;
    }
    .filter-row{ display:flex; gap:14px; flex-wrap:wrap; align-items:flex-end; }
    .filter-group{ flex:1; min-width:160px; }
    .filter-group label{
        display:block; font-size:12px; font-weight:700;
        color:#374151; margin-bottom:5px; text-transform:uppercase; letter-spacing:0.5px;
    }
    .filter-group select, .filter-group input{
        width:100%; padding:10px 12px; border:1.5px solid #d1d5db;
        border-radius:7px; font-size:14px; color:#111; outline:none;
        background:white;
    }
    .filter-group select:focus, .filter-group input:focus{
        border-color:#2563eb; box-shadow:0 0 0 3px rgba(37,99,235,0.1);
    }
    .btn-generate{
        padding:10px 26px; background:#1e3a8a; color:white;
        border:none; border-radius:7px; cursor:pointer;
        font-size:14px; font-weight:600; white-space:nowrap;
    }
    .btn-generate:hover{ background:#2563eb; }
    .btn-reset{
        padding:10px 18px; background:#f3f4f6; color:#374151;
        border:1.5px solid #d1d5db; border-radius:7px;
        cursor:pointer; font-size:14px; text-decoration:none;
        display:inline-block; white-space:nowrap;
    }

    /* Summary boxes */
    .stat-row{ display:flex; gap:14px; margin-bottom:22px; flex-wrap:wrap; max-width:860px; }
    .stat-box{
        flex:1; min-width:140px; background:white; padding:18px 20px;
        border-radius:10px; box-shadow:0 2px 8px rgba(0,0,0,0.08);
        text-align:center;
    }
    .stat-box.blue   { border-top:4px solid #2563eb; }
    .stat-box.green  { border-top:4px solid #16a34a; }
    .stat-box.orange { border-top:4px solid #ea580c; }
    .stat-box h4{ margin:0 0 6px; font-size:11px; color:#6b7280; text-transform:uppercase; font-weight:700; }
    .stat-box p { margin:0; font-size:24px; font-weight:800; color:#1e3a8a; }

    /* Result table */
    .result-card{
        background:white; border-radius:12px;
        box-shadow:0 2px 10px rgba(0,0,0,0.1);
        overflow:hidden; margin-bottom:24px; max-width:1000px;
    }
    .result-card-header{
        background:#1e3a8a; color:white;
        padding:13px 18px; font-size:15px; font-weight:700;
    }
    table{ width:100%; border-collapse:collapse; }
    th{ background:#1e3a8a; color:white; padding:11px 14px; text-align:left; font-size:13px; }
    td{ padding:10px 14px; border-bottom:1px solid #f0f0f0; font-size:13px; color:#374151; }
    tr:last-child td{ border-bottom:none; }
    tr:hover td{ background:#f8f9ff; }
    .no-data{ text-align:center; color:#9ca3af; padding:30px; font-style:italic; }

    .badge{ display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; }
    .b-cash   { background:#dcfce7; color:#166534; }
    .b-upi    { background:#dbeafe; color:#1e40af; }
    .b-card   { background:#f3e8ff; color:#6b21a8; }
    .b-credit { background:#fff7ed; color:#9a3412; }

    /* Top 5 podium style */
    .top5-grid{
        display:flex; gap:14px; flex-wrap:wrap;
        margin-bottom:20px; max-width:1000px;
    }
    .top5-card{
        flex:1; min-width:170px; background:white;
        border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.1);
        padding:18px 16px; text-align:center; position:relative;
        border-top:5px solid #d1d5db;
    }
    .top5-card.rank1{ border-top-color:#f59e0b; }
    .top5-card.rank2{ border-top-color:#9ca3af; }
    .top5-card.rank3{ border-top-color:#b45309; }
    .top5-card.rank4{ border-top-color:#2563eb; }
    .top5-card.rank5{ border-top-color:#16a34a; }
    .rank-badge{
        position:absolute; top:-14px; left:50%; transform:translateX(-50%);
        width:28px; height:28px; border-radius:50%;
        display:flex; align-items:center; justify-content:center;
        font-size:13px; font-weight:800; color:white;
    }
    .rank-badge.r1{ background:#f59e0b; }
    .rank-badge.r2{ background:#9ca3af; }
    .rank-badge.r3{ background:#b45309; }
    .rank-badge.r4{ background:#2563eb; }
    .rank-badge.r5{ background:#16a34a; }
    .top5-name{ font-size:13px; font-weight:700; color:#1e3a8a; margin:10px 0 4px; }
    .top5-cat { font-size:11px; color:#6b7280; margin-bottom:8px; }
    .top5-qty { font-size:22px; font-weight:800; color:#1e3a8a; }
    .top5-rev { font-size:12px; color:#16a34a; font-weight:600; margin-top:4px; }
    .top5-label{ font-size:10px; color:#9ca3af; text-transform:uppercase; }
</style>

<script>
// Load products for selected category in product-wise tab
function loadProductsForReport(catId) {
    var sel = document.getElementById("prod-select");
    sel.innerHTML = "<option value=''>Loading...</option>";
    if (!catId) { sel.innerHTML = "<option value=''>-- Select Category First --</option>"; return; }

    fetch("GetProductsByCategoryServlet?category_id=" + catId)
        .then(function(r){ return r.json(); })
        .then(function(products){
            sel.innerHTML = "<option value=''>-- All Products in Category --</option>";
            products.forEach(function(p){
                var opt = document.createElement("option");
                opt.value = p.pid;
                opt.text  = p.name;
                sel.appendChild(opt);
            });
        });
}

// Switch tabs
function showTab(tabId) {
    document.querySelectorAll(".tab-panel").forEach(function(p){ p.classList.remove("active"); });
    document.querySelectorAll(".tab-btn").forEach(function(b){ b.classList.remove("active"); });
    document.getElementById(tabId).classList.add("active");
    document.getElementById("btn-" + tabId).classList.add("active");
}
</script>
</head>
<body>

<div class="navbar">
    <div style="font-weight:700;font-size:16px;">&#128230; Inventory System</div>
    <a href="logout.jsp">Logout</a>
</div>

<div class="sidebar">
    <a href="index.jsp">&#127968; Dashboard</a>
    <a href="ProductsServlet">&#128230; Products</a>
    <a href="addSale.jsp">&#128722; Add Sale</a>
    <a href="report.jsp" class="active">&#128202; Reports</a>
    <a href="lowStock.jsp">&#9888; Low Stock</a>
</div>

<div class="main">
<h2 style="color:#1e3a8a;margin-bottom:20px;">&#128202; Sales Reports</h2>

<!-- TAB BAR -->
<div class="tab-bar">
    <button class="tab-btn active" id="btn-tab-product" onclick="showTab('tab-product')">
        &#128269; Product-wise Report
    </button>
    <button class="tab-btn" id="btn-tab-all" onclick="showTab('tab-all')">
        &#128203; All Products Report
    </button>
    <button class="tab-btn" id="btn-tab-top5" onclick="showTab('tab-top5')">
        &#127942; Top 5 This Month
    </button>
</div>

<!-- ═══════════════════════════════════════════════════════ -->
<!-- TAB 1: PRODUCT-WISE REPORT                             -->
<!-- ═══════════════════════════════════════════════════════ -->
<div class="tab-panel active" id="tab-product">

<%
    // Read filter params for product-wise
    String pw_catId  = request.getParameter("pw_cat")   != null ? request.getParameter("pw_cat")   : "";
    String pw_prodId = request.getParameter("pw_prod")  != null ? request.getParameter("pw_prod")  : "";
    String pw_from   = request.getParameter("pw_from")  != null ? request.getParameter("pw_from")  : "";
    String pw_to     = request.getParameter("pw_to")    != null ? request.getParameter("pw_to")    : "";
    boolean pw_submitted = !pw_from.isEmpty() && !pw_to.isEmpty();
%>

    <div class="filter-card">
        <h3>&#128269; Filter by Product &amp; Date Range</h3>
        <form method="get" action="report.jsp">
            <input type="hidden" name="tab" value="product">
            <div class="filter-row">
                <div class="filter-group">
                    <label>Category</label>
                    <select name="pw_cat" id="pw-cat-select"
                            onchange="loadProductsForReport(this.value);this.form.submit();">
                        <option value="">-- All Categories --</option>
                        <%
                        // Re-query categories for this dropdown
                        ResultSet catRs1 = con.createStatement().executeQuery(
                            "SELECT category_id, category_name FROM CATEGORIES ORDER BY category_name");
                        while(catRs1.next()){
                            String sel = pw_catId.equals(String.valueOf(catRs1.getInt("category_id"))) ? "selected" : "";
                        %>
                            <option value="<%= catRs1.getInt("category_id") %>" <%= sel %>>
                                <%= catRs1.getString("category_name") %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <% if(!pw_catId.isEmpty()){ %>
                <div class="filter-group">
                    <label>Product</label>
                    <select name="pw_prod" id="prod-select">
                        <option value="">-- All in Category --</option>
                        <%
                        PreparedStatement psProd = con.prepareStatement(
                            "SELECT product_id, product_name FROM PRODUCTS WHERE category_id=? ORDER BY product_name");
                        psProd.setInt(1, Integer.parseInt(pw_catId));
                        ResultSet prodRs = psProd.executeQuery();
                        while(prodRs.next()){
                            String sel = pw_prodId.equals(String.valueOf(prodRs.getInt("product_id"))) ? "selected" : "";
                        %>
                            <option value="<%= prodRs.getInt("product_id") %>" <%= sel %>>
                                <%= prodRs.getString("product_name") %>
                            </option>
                        <% } %>
                    </select>
                </div>
                <% } else { %>
                <div class="filter-group">
                    <label>Product</label>
                    <select id="prod-select" name="pw_prod" disabled>
                        <option>-- Select Category First --</option>
                    </select>
                </div>
                <% } %>

                <div class="filter-group">
                    <label>From Date</label>
                    <input type="date" name="pw_from" value="<%= pw_from %>">
                </div>
                <div class="filter-group">
                    <label>To Date</label>
                    <input type="date" name="pw_to" value="<%= pw_to %>">
                </div>
                <div style="display:flex;gap:8px;align-items:flex-end;">
                    <button type="submit" class="btn-generate">Generate</button>
                    <a href="report.jsp" class="btn-reset">Reset</a>
                </div>
            </div>
        </form>
    </div>

    <% if(pw_submitted){ %>
    <%
    // Build query
    String pw_where = "WHERE s.sale_date BETWEEN ? AND ?";
    if(!pw_catId.isEmpty())  pw_where += " AND p.category_id = ?";
    if(!pw_prodId.isEmpty()) pw_where += " AND si.product_id = ?";

    // Summary stats
    int    pw_orders=0; double pw_rev=0; int pw_qty=0;
    try{
        String statSql =
            "SELECT COUNT(DISTINCT s.sale_id) AS orders, " +
            "COALESCE(SUM(si.line_total),0) AS rev, " +
            "COALESCE(SUM(si.quantity),0) AS qty " +
            "FROM SALES s " +
            "JOIN SALE_ITEMS si ON s.sale_id = si.sale_id " +
            "JOIN PRODUCTS p   ON si.product_id = p.product_id " +
            pw_where;
        PreparedStatement psStat = con.prepareStatement(statSql);
        int pi=1;
        psStat.setString(pi++, pw_from); psStat.setString(pi++, pw_to);
        if(!pw_catId.isEmpty())  psStat.setInt(pi++, Integer.parseInt(pw_catId));
        if(!pw_prodId.isEmpty()) psStat.setInt(pi++, Integer.parseInt(pw_prodId));
        ResultSet rsStat = psStat.executeQuery();
        if(rsStat.next()){ pw_orders=rsStat.getInt("orders"); pw_rev=rsStat.getDouble("rev"); pw_qty=rsStat.getInt("qty"); }
    }catch(Exception e){ e.printStackTrace(); }
    %>

    <div class="stat-row">
        <div class="stat-box blue">
            <h4>Total Orders</h4>
            <p><%= pw_orders %></p>
        </div>
        <div class="stat-box green">
            <h4>Revenue</h4>
            <p>&#8377;<%= String.format("%.0f",pw_rev) %></p>
        </div>
        <div class="stat-box orange">
            <h4>Units Sold</h4>
            <p><%= pw_qty %></p>
        </div>
    </div>

    <div class="result-card">
        <div class="result-card-header">&#128203; Sale Transactions
            (<%= pw_from %> to <%= pw_to %>)
        </div>
        <table>
            <tr>
                <th>Sale ID</th><th>Date</th><th>Product</th><th>Category</th>
                <th>Customer</th><th>Qty</th><th>Unit Price</th><th>Line Total</th><th>Payment</th>
            </tr>
            <%
            try{
                String detailSql =
                    "SELECT s.sale_id, s.sale_date, p.product_name, c2.category_name, " +
                    "c.name AS cust_name, si.quantity, si.unit_price, si.line_total, s.payment_mode " +
                    "FROM SALES s " +
                    "JOIN SALE_ITEMS si ON s.sale_id = si.sale_id " +
                    "JOIN PRODUCTS p    ON si.product_id = p.product_id " +
                    "JOIN CATEGORIES c2 ON p.category_id = c2.category_id " +
                    "LEFT JOIN CUSTOMERS c ON s.customer_id = c.customer_id " +
                    pw_where + " ORDER BY s.sale_date DESC, s.sale_id DESC";

                PreparedStatement psDetail = con.prepareStatement(detailSql);
                int pi=1;
                psDetail.setString(pi++, pw_from); psDetail.setString(pi++, pw_to);
                if(!pw_catId.isEmpty())  psDetail.setInt(pi++, Integer.parseInt(pw_catId));
                if(!pw_prodId.isEmpty()) psDetail.setInt(pi++, Integer.parseInt(pw_prodId));
                ResultSet rs = psDetail.executeQuery();
                int cnt=0;
                while(rs.next()){
                    cnt++;
                    String pm = rs.getString("payment_mode");
                    String pmClass = "b-cash";
                    if("UPI".equals(pm))    pmClass="b-upi";
                    else if("Card".equals(pm))   pmClass="b-card";
                    else if("Credit".equals(pm)) pmClass="b-credit";
            %>
            <tr>
                <td><b><%= rs.getInt("sale_id") %></b></td>
                <td><%= rs.getDate("sale_date") %></td>
                <td><%= rs.getString("product_name") %></td>
                <td><%= rs.getString("category_name") %></td>
                <td><%= rs.getString("cust_name")!=null ? rs.getString("cust_name") : "Walk-in" %></td>
                <td><%= rs.getInt("quantity") %></td>
                <td>&#8377;<%= String.format("%.2f",rs.getDouble("unit_price")) %></td>
                <td><b>&#8377;<%= String.format("%.2f",rs.getDouble("line_total")) %></b></td>
                <td><span class="badge <%= pmClass %>"><%= pm %></span></td>
            </tr>
            <%  }
                if(cnt==0){ %>
            <tr><td colspan="9" class="no-data">No sales found for selected filters.</td></tr>
            <%  }
            }catch(Exception e){ e.printStackTrace(); } %>
        </table>
    </div>
    <% } %>
</div>


<!-- ═══════════════════════════════════════════════════════ -->
<!-- TAB 2: ALL PRODUCTS REPORT                             -->
<!-- ═══════════════════════════════════════════════════════ -->
<div class="tab-panel" id="tab-all">

<%
    String all_from = request.getParameter("all_from") != null ? request.getParameter("all_from") : "";
    String all_to   = request.getParameter("all_to")   != null ? request.getParameter("all_to")   : "";
    boolean all_submitted = !all_from.isEmpty() && !all_to.isEmpty();
%>

    <div class="filter-card">
        <h3>&#128203; All Products — Choose Date Range</h3>
        <form method="get" action="report.jsp">
            <input type="hidden" name="tab" value="all">
            <div class="filter-row">
                <div class="filter-group">
                    <label>From Date</label>
                    <input type="date" name="all_from" value="<%= all_from %>">
                </div>
                <div class="filter-group">
                    <label>To Date</label>
                    <input type="date" name="all_to" value="<%= all_to %>">
                </div>
                <div style="display:flex;gap:8px;align-items:flex-end;">
                    <button type="submit" class="btn-generate">Generate</button>
                    <a href="report.jsp" class="btn-reset">Reset</a>
                </div>
            </div>
        </form>
    </div>

    <% if(all_submitted){ %>
    <%
    int    all_orders=0; double all_rev=0; int all_qty=0;
    try{
        PreparedStatement psStat = con.prepareStatement(
            "SELECT COUNT(DISTINCT s.sale_id) AS orders, " +
            "COALESCE(SUM(si.line_total),0) AS rev, COALESCE(SUM(si.quantity),0) AS qty " +
            "FROM SALES s JOIN SALE_ITEMS si ON s.sale_id=si.sale_id " +
            "WHERE s.sale_date BETWEEN ? AND ?");
        psStat.setString(1, all_from); psStat.setString(2, all_to);
        ResultSet rsStat = psStat.executeQuery();
        if(rsStat.next()){ all_orders=rsStat.getInt("orders"); all_rev=rsStat.getDouble("rev"); all_qty=rsStat.getInt("qty"); }
    }catch(Exception e){ e.printStackTrace(); }
    %>

    <div class="stat-row">
        <div class="stat-box blue">
            <h4>Total Orders</h4>
            <p><%= all_orders %></p>
        </div>
        <div class="stat-box green">
            <h4>Total Revenue</h4>
            <p>&#8377;<%= String.format("%.0f",all_rev) %></p>
        </div>
        <div class="stat-box orange">
            <h4>Units Sold</h4>
            <p><%= all_qty %></p>
        </div>
    </div>

    <!-- Category-wise summary -->
    <div class="result-card">
        <div class="result-card-header">&#128202; Category-wise Summary</div>
        <table>
            <tr><th>Category</th><th>Orders</th><th>Units Sold</th><th>Revenue</th></tr>
            <%
            try{
                PreparedStatement psCat = con.prepareStatement(
                    "SELECT c.category_name, COUNT(DISTINCT s.sale_id) AS orders, " +
                    "SUM(si.quantity) AS qty, SUM(si.line_total) AS rev " +
                    "FROM SALES s " +
                    "JOIN SALE_ITEMS si ON s.sale_id=si.sale_id " +
                    "JOIN PRODUCTS p    ON si.product_id=p.product_id " +
                    "JOIN CATEGORIES c  ON p.category_id=c.category_id " +
                    "WHERE s.sale_date BETWEEN ? AND ? " +
                    "GROUP BY c.category_id, c.category_name ORDER BY rev DESC");
                psCat.setString(1, all_from); psCat.setString(2, all_to);
                ResultSet rsCat = psCat.executeQuery();
                int cnt=0;
                while(rsCat.next()){ cnt++;
            %>
            <tr>
                <td><b><%= rsCat.getString("category_name") %></b></td>
                <td><%= rsCat.getInt("orders") %></td>
                <td><%= rsCat.getInt("qty") %></td>
                <td><b>&#8377;<%= String.format("%.2f",rsCat.getDouble("rev")) %></b></td>
            </tr>
            <%  }
                if(cnt==0){ %>
            <tr><td colspan="4" class="no-data">No data found for this date range.</td></tr>
            <%  } }catch(Exception e){ e.printStackTrace(); } %>
        </table>
    </div>

    <!-- All transactions -->
    <div class="result-card">
        <div class="result-card-header">&#128203; All Transactions
            (<%= all_from %> to <%= all_to %>)
        </div>
        <table>
            <tr>
                <th>Sale ID</th><th>Date</th><th>Product</th><th>Category</th>
                <th>Customer</th><th>Qty</th><th>Amount</th><th>Payment</th>
            </tr>
            <%
            try{
                PreparedStatement psAll = con.prepareStatement(
                    "SELECT s.sale_id, s.sale_date, p.product_name, c2.category_name, " +
                    "c.name AS cust_name, si.quantity, si.line_total, s.payment_mode " +
                    "FROM SALES s " +
                    "JOIN SALE_ITEMS si ON s.sale_id=si.sale_id " +
                    "JOIN PRODUCTS p    ON si.product_id=p.product_id " +
                    "JOIN CATEGORIES c2 ON p.category_id=c2.category_id " +
                    "LEFT JOIN CUSTOMERS c ON s.customer_id=c.customer_id " +
                    "WHERE s.sale_date BETWEEN ? AND ? " +
                    "ORDER BY s.sale_date DESC, s.sale_id DESC");
                psAll.setString(1, all_from); psAll.setString(2, all_to);
                ResultSet rsAll = psAll.executeQuery();
                int cnt=0;
                while(rsAll.next()){
                    cnt++;
                    String pm=rsAll.getString("payment_mode");
                    String pmClass="b-cash";
                    if("UPI".equals(pm)) pmClass="b-upi";
                    else if("Card".equals(pm)) pmClass="b-card";
                    else if("Credit".equals(pm)) pmClass="b-credit";
            %>
            <tr>
                <td><b><%= rsAll.getInt("sale_id") %></b></td>
                <td><%= rsAll.getDate("sale_date") %></td>
                <td><%= rsAll.getString("product_name") %></td>
                <td><%= rsAll.getString("category_name") %></td>
                <td><%= rsAll.getString("cust_name")!=null ? rsAll.getString("cust_name") : "Walk-in" %></td>
                <td><%= rsAll.getInt("quantity") %></td>
                <td><b>&#8377;<%= String.format("%.2f",rsAll.getDouble("line_total")) %></b></td>
                <td><span class="badge <%= pmClass %>"><%= pm %></span></td>
            </tr>
            <%  }
                if(cnt==0){ %>
            <tr><td colspan="8" class="no-data">No transactions found for this date range.</td></tr>
            <%  } }catch(Exception e){ e.printStackTrace(); } %>
        </table>
    </div>
    <% } %>
</div>


<!-- ═══════════════════════════════════════════════════════ -->
<!-- TAB 3: TOP 5 THIS MONTH                               -->
<!-- ═══════════════════════════════════════════════════════ -->
<div class="tab-panel" id="tab-top5">

<%
    // Default: current year-month
    java.time.LocalDate today = java.time.LocalDate.now();
    String top5_month = request.getParameter("top5_month") != null
                        ? request.getParameter("top5_month")
                        : today.getYear() + "-" + String.format("%02d", today.getMonthValue());
    boolean top5_submitted = request.getParameter("top5_month") != null;
%>

    <div class="filter-card">
        <h3>&#127942; Top 5 Best Selling Products</h3>
        <form method="get" action="report.jsp">
            <input type="hidden" name="tab" value="top5">
            <div class="filter-row">
                <div class="filter-group" style="max-width:220px;">
                    <label>Select Month</label>
                    <input type="month" name="top5_month" value="<%= top5_month %>"
                           style="font-size:15px;padding:10px 12px;">
                </div>
                <div style="display:flex;gap:8px;align-items:flex-end;">
                    <button type="submit" class="btn-generate">&#127942; Show Top 5</button>
                </div>
            </div>
        </form>
    </div>

    <%
    // Always show (default to current month)
    String[] top5_monthParts = top5_month.split("-");
    String top5_year  = top5_monthParts[0];
    String top5_mon   = top5_monthParts[1];
    String top5_from2 = top5_year + "-" + top5_mon + "-01";
    // Last day of month
    java.time.YearMonth ym = java.time.YearMonth.of(Integer.parseInt(top5_year), Integer.parseInt(top5_mon));
    String top5_to2 = top5_year + "-" + top5_mon + "-" + ym.lengthOfMonth();

    // Month name for display
    String[] monthNames = {"","January","February","March","April","May","June",
                           "July","August","September","October","November","December"};
    String monthDisplay = monthNames[Integer.parseInt(top5_mon)] + " " + top5_year;

    // Fetch top 5
    java.util.List<String[]> top5List = new java.util.ArrayList<>();
    try{
        PreparedStatement psTop = con.prepareStatement(
            "SELECT p.product_name, c.category_name, " +
            "SUM(si.quantity) AS total_qty, SUM(si.line_total) AS total_rev " +
            "FROM SALE_ITEMS si " +
            "JOIN SALES s      ON si.sale_id = s.sale_id " +
            "JOIN PRODUCTS p   ON si.product_id = p.product_id " +
            "JOIN CATEGORIES c ON p.category_id = c.category_id " +
            "WHERE s.sale_date BETWEEN ? AND ? " +
            "GROUP BY si.product_id, p.product_name, c.category_name " +
            "ORDER BY total_qty DESC LIMIT 5"
        );
        psTop.setString(1, top5_from2);
        psTop.setString(2, top5_to2);
        ResultSet rsTop = psTop.executeQuery();
        while(rsTop.next()){
            top5List.add(new String[]{
                rsTop.getString("product_name"),
                rsTop.getString("category_name"),
                String.valueOf(rsTop.getInt("total_qty")),
                String.format("%.2f", rsTop.getDouble("total_rev"))
            });
        }
    }catch(Exception e){ e.printStackTrace(); }
    %>

    <h3 style="color:#1e3a8a;margin-bottom:16px;font-size:16px;">
        &#127942; Top 5 for <span style="color:#ea580c;"><%= monthDisplay %></span>
    </h3>

    <% if(top5List.isEmpty()){ %>
        <div style="background:white;border-radius:12px;padding:40px;text-align:center;
                    color:#9ca3af;font-style:italic;max-width:860px;
                    box-shadow:0 2px 10px rgba(0,0,0,0.08);">
            No sales data found for <%= monthDisplay %>.
        </div>
    <% } else { %>

    <!-- Podium cards -->
    <div class="top5-grid">
        <% String[] rankClasses = {"rank1","rank2","rank3","rank4","rank5"};
           String[] rClasses    = {"r1","r2","r3","r4","r5"};
           String[] medals      = {"&#129351;","&#129352;","&#129353;","4","5"};
           for(int i=0; i<top5List.size(); i++){
               String[] item = top5List.get(i);
        %>
        <div class="top5-card <%= rankClasses[i] %>">
            <div class="rank-badge <%= rClasses[i] %>"><%= i+1 %></div>
            <div class="top5-name"><%= item[0] %></div>
            <div class="top5-cat"><%= item[1] %></div>
            <div class="top5-label">Units Sold</div>
            <div class="top5-qty"><%= item[2] %></div>
            <div class="top5-rev">&#8377; <%= item[3] %></div>
        </div>
        <% } %>
    </div>

    <!-- Top 5 detailed table -->
    <div class="result-card">
        <div class="result-card-header">&#128203; Detailed Breakdown — <%= monthDisplay %></div>
        <table>
            <tr>
                <th>Rank</th><th>Product</th><th>Category</th>
                <th>Units Sold</th><th>Revenue</th>
            </tr>
            <% for(int i=0; i<top5List.size(); i++){
                   String[] item = top5List.get(i); %>
            <tr>
                <td><b style="font-size:16px;">#<%= i+1 %></b></td>
                <td><b><%= item[0] %></b></td>
                <td><%= item[1] %></td>
                <td><b style="color:#1e3a8a;font-size:15px;"><%= item[2] %></b></td>
                <td><b style="color:#16a34a;">&#8377; <%= item[3] %></b></td>
            </tr>
            <% } %>
        </table>
    </div>
    <% } %>
</div>

</div><!-- end .main -->

<%-- Keep correct tab active after form submit --%>
<script>
(function(){
    var tab = "<%= request.getParameter("tab") != null ? request.getParameter("tab") : "" %>";
    if(tab === "all")     showTab("tab-all");
    else if(tab === "top5") showTab("tab-top5");
    else                  showTab("tab-product");
})();
</script>

<% if(con!=null) try{ con.close(); }catch(Exception ignored){} %>
</body>
</html>
