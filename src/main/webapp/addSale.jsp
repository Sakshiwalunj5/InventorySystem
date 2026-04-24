<%@ page import="java.sql.*,com.inventory.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    HttpSession sess = request.getSession(false);
    if(sess == null || sess.getAttribute("user_id") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = DBConnection.getConnection();
    ResultSet cat    = con.createStatement().executeQuery(
        "SELECT category_id, category_name FROM CATEGORIES ORDER BY category_name");
    ResultSet custRs = con.createStatement().executeQuery(
        "SELECT customer_id, name, phone FROM CUSTOMERS ORDER BY name");
%>
<!DOCTYPE html>
<html>
<head>
<title>Add Sale</title>
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

    .card{
        max-width:960px; margin:auto; background:white;
        padding:30px; border-radius:12px;
        box-shadow:0 2px 12px rgba(0,0,0,0.15);
    }
    .card h2{ color:#1e3a8a; margin-bottom:20px; font-size:22px; }

    .form-row{ margin-bottom:15px; }
    .form-row label{
        display:block; font-weight:600; margin-bottom:5px;
        color:#374151; font-size:13px;
    }
    .form-row select, .form-row input{
        width:100%; padding:9px 12px; border:1px solid #d1d5db;
        border-radius:6px; font-size:14px; outline:none;
    }
    .form-row select:focus, .form-row input:focus{ border-color:#2563eb; }

    .form-row-inline{ display:flex; gap:15px; }
    .form-row-inline .form-row{ flex:1; }

    .section-title{
        font-size:16px; font-weight:700; color:#1e3a8a;
        margin:20px 0 10px 0; border-bottom:2px solid #e5e7eb; padding-bottom:6px;
    }

    /* Product table */
    #productDiv table{ width:100%; border-collapse:collapse; margin-top:10px; border-radius:8px; overflow:hidden; }
    #productDiv th{ background:#1e3a8a; color:white; padding:10px 12px; text-align:left; font-size:13px; }
    #productDiv td{ padding:9px 12px; border-bottom:1px solid #e5e7eb; font-size:13px; color:#374151; }
    #productDiv tr:hover td{ background:#f9fafb; }
    .qty-input{
        width:70px; padding:5px; text-align:center;
        border:1px solid #d1d5db; border-radius:4px; font-size:13px;
    }
    .btn-add{
        padding:6px 14px; background:#2563eb; color:white;
        border:none; border-radius:5px; cursor:pointer; font-size:13px;
    }
    .btn-add:hover{ background:#1d4ed8; }
    .btn-add:disabled{ background:#9ca3af; cursor:not-allowed; }

    /* Cart table */
    #cartTable{ width:100%; border-collapse:collapse; }
    #cartTable th{ background:#1e3a8a; color:white; padding:10px 12px; text-align:left; font-size:13px; }
    #cartTable td{ padding:9px 12px; border-bottom:1px solid #e5e7eb; font-size:13px; color:#374151; }

    .btn-remove{
        padding:4px 10px; background:#dc2626; color:white;
        border:none; border-radius:4px; cursor:pointer; font-size:12px;
    }
    .btn-remove:hover{ background:#b91c1c; }

    .total-row{
        text-align:right; margin-top:12px;
        font-size:20px; font-weight:700; color:#1e3a8a;
    }
    .btn-submit{
        margin-top:15px; width:100%; padding:12px; background:#16a34a;
        color:white; border:none; border-radius:8px;
        font-size:16px; font-weight:600; cursor:pointer;
    }
    .btn-submit:hover{ background:#15803d; }

    .alert-success{
        background:#dcfce7; color:#166534; border:1px solid #bbf7d0;
        padding:10px 15px; border-radius:6px; margin-bottom:15px; font-size:14px;
    }
    .alert-error{
        background:#fee2e2; color:#991b1b; border:1px solid #fecaca;
        padding:10px 15px; border-radius:6px; margin-bottom:15px; font-size:14px;
    }
    .empty-cart{
        text-align:center; color:#9ca3af; padding:20px;
        font-size:14px; font-style:italic;
    }

    .customer-section{
        background:#f8fafc; border:1px solid #e2e8f0;
        border-radius:8px; padding:15px; margin-bottom:15px;
    }
    .customer-toggle{ display:flex; gap:20px; margin-bottom:12px; }
    .customer-toggle label{ font-size:14px; cursor:pointer; display:flex; align-items:center; gap:6px; }
    #newCustomerFields{ display:none; margin-top:10px; }
</style>

<script>
    var cart       = [];   // [{pid, name, qty, price, unit}, ...]
    var productMap = {};   // {pid: {pid, name, price, stock, unit}}

    // Load products for selected category via AJAX
    function loadProducts(catId) {
        var div = document.getElementById("productDiv");
        if (!catId) { div.innerHTML = ""; productMap = {}; return; }

        div.innerHTML = "<p style='color:#6b7280;padding:10px;'>Loading products...</p>";

        fetch("GetProductsByCategoryServlet?category_id=" + catId)
            .then(function(res) { return res.json(); })
            .then(function(products) {
                productMap = {};
                if (!products || products.length === 0) {
                    div.innerHTML = "<p style='color:#9ca3af;padding:10px;font-style:italic;'>No products in this category.</p>";
                    return;
                }

                products.forEach(function(p) { productMap[p.pid] = p; });

                var html = "<table><thead><tr>"
                    + "<th>Product</th><th>Stock</th><th>Price (&#8377;)</th><th>Unit</th><th>Qty</th><th>Add</th>"
                    + "</tr></thead><tbody>";

                products.forEach(function(p) {
                    var stockLabel = p.stock;
                    var stockStyle = "";
                    if (p.stock === 0) {
                        stockLabel = "Out of Stock";
                        stockStyle = "color:#dc2626;font-weight:bold;";
                    } else if (p.stock < 20) {
                        stockLabel = p.stock + " (Low)";
                        stockStyle = "color:#d97706;font-weight:bold;";
                    }
                    var disabled = p.stock === 0 ? "disabled" : "";

                    html += "<tr>"
                        + "<td>" + p.name + "</td>"
                        + "<td style='" + stockStyle + "'>" + stockLabel + "</td>"
                        + "<td>&#8377;" + p.price.toFixed(2) + "</td>"
                        + "<td>" + (p.unit || "pcs") + "</td>"
                        + "<td><input type='number' class='qty-input' id='qty_" + p.pid + "' "
                        +     "min='1' max='" + p.stock + "' value='1' "
                        +     (p.stock === 0 ? "disabled" : "") + "></td>"
                        + "<td><button type='button' class='btn-add' " + disabled
                        +     " onclick='addToCart(" + p.pid + ")'>Add</button></td>"
                        + "</tr>";
                });
                html += "</tbody></table>";
                div.innerHTML = html;
            })
            .catch(function(err) {
                div.innerHTML = "<p style='color:red;padding:10px;'>Failed to load products. " + err + "</p>";
            });
    }

    // Add selected product+qty to cart
    function addToCart(pid) {
        var p = productMap[pid];
        if (!p) { alert("Product not found!"); return; }

        var qtyInput = document.getElementById("qty_" + pid);
        var qty = parseInt(qtyInput ? qtyInput.value : 1);

        if (!qty || qty < 1) { alert("Enter a valid quantity."); return; }
        if (qty > p.stock)   { alert("Only " + p.stock + " units available for: " + p.name); return; }

        // Already in cart? Increase qty
        var existing = null;
        for (var i = 0; i < cart.length; i++) {
            if (cart[i].pid == pid) { existing = cart[i]; break; }
        }
        if (existing) {
            var newQty = existing.qty + qty;
            if (newQty > p.stock) {
                alert("Total qty (" + newQty + ") exceeds available stock (" + p.stock + ") for: " + p.name);
                return;
            }
            existing.qty = newQty;
        } else {
            cart.push({ pid: p.pid, name: p.name, qty: qty, price: p.price, unit: (p.unit || "pcs") });
        }

        if (qtyInput) qtyInput.value = "1";
        renderCart();
    }

    // Render cart table and sync hidden inputs
    function renderCart() {
        var tbody     = document.getElementById("cartBody");
        var emptyMsg  = document.getElementById("cartEmpty");
        var hiddenDiv = document.getElementById("hiddenInputs");

        if (cart.length === 0) {
            tbody.innerHTML     = "";
            hiddenDiv.innerHTML = "";
            emptyMsg.style.display = "block";
            document.getElementById("totalAmount").innerText = "0.00";
            document.getElementById("grandTotal").value      = "0";
            return;
        }

        emptyMsg.style.display = "none";

        var rows       = "";
        var hiddenHtml = "";
        var grandTotal = 0;

        for (var i = 0; i < cart.length; i++) {
            var item      = cart[i];
            var lineTotal = item.qty * item.price;
            grandTotal   += lineTotal;

            rows += "<tr>"
                + "<td>" + item.name + "</td>"
                + "<td>" + item.qty + " " + item.unit + "</td>"
                + "<td>&#8377;" + item.price.toFixed(2) + "</td>"
                + "<td>&#8377;" + lineTotal.toFixed(2) + "</td>"
                + "<td><button type='button' class='btn-remove' onclick='removeItem(" + i + ")'>Remove</button></td>"
                + "</tr>";

            // These four hidden inputs repeat per item — servlet reads them as arrays
            hiddenHtml += "<input type='hidden' name='product_id' value='" + item.pid                 + "'>\n";
            hiddenHtml += "<input type='hidden' name='quantity'   value='" + item.qty                 + "'>\n";
            hiddenHtml += "<input type='hidden' name='unit_price' value='" + item.price.toFixed(2)    + "'>\n";
            hiddenHtml += "<input type='hidden' name='line_total' value='" + lineTotal.toFixed(2)     + "'>\n";
        }

        tbody.innerHTML     = rows;
        hiddenDiv.innerHTML = hiddenHtml;
        document.getElementById("totalAmount").innerText = grandTotal.toFixed(2);
        document.getElementById("grandTotal").value      = grandTotal.toFixed(2);
    }

    // Remove one item from cart
    function removeItem(index) {
        cart.splice(index, 1);
        renderCart();
    }

    // Toggle new / existing customer fields
    function toggleCustomer(type) {
        var newFields      = document.getElementById("newCustomerFields");
        var existingFields = document.getElementById("existingCustomerFields");
        if (type === "new") {
            newFields.style.display      = "block";
            existingFields.style.display = "none";
        } else {
            newFields.style.display      = "none";
            existingFields.style.display = "block";
        }
    }

    // Called on form submit — sync cart to hidden inputs then validate
    function validateSubmit() {
        renderCart(); // ensure hidden inputs are up to date
        if (cart.length === 0) {
            alert("Cart is empty! Please add at least one product.");
            return false;
        }
        return true;
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
    <a href="addSale.jsp" class="active">&#128722; Add Sale</a>
    <a href="report.jsp">&#128202; Reports</a>
    <a href="lowStock.jsp">&#9888; Low Stock</a>
</div>

<div class="main">
<div class="card">
    <h2>&#128722; Add Sale</h2>

    <% if("1".equals(request.getParameter("success"))){ %>
        <div class="alert-success">&#10003; Sale recorded successfully!</div>
    <% } %>
    <% if(request.getParameter("error") != null){ %>
        <div class="alert-error">&#10007; Error: <%= request.getParameter("error") %></div>
    <% } %>

    <form action="AddSaleServlet" method="post" onsubmit="return validateSubmit()">

        <!-- CUSTOMER SECTION -->
        <div class="customer-section">
            <div class="section-title" style="border:none;margin:0 0 12px;">Customer</div>
            <div class="customer-toggle">
                <label>
                    <input type="radio" name="customerType" value="existing" checked
                           onclick="toggleCustomer('existing')">
                    Existing Customer
                </label>
                <label>
                    <input type="radio" name="customerType" value="new"
                           onclick="toggleCustomer('new')">
                    New Customer
                </label>
            </div>

            <!-- Existing -->
            <div id="existingCustomerFields">
                <div class="form-row">
                    <label>Select Customer</label>
                    <select name="customer_id">
                        <option value="">-- Walk-in / No Customer --</option>
                        <% while(custRs.next()){ %>
                        <option value="<%= custRs.getInt("customer_id") %>">
                        <%= custRs.getInt("customer_id") %> —                            <%= custRs.getString("name") %>
                            (<%= custRs.getString("phone") != null ? custRs.getString("phone") : "no phone" %>)
                        </option>
                        <% } %>
                    </select>
                </div>
            </div>

            <!-- New -->
            <div id="newCustomerFields">
                <div class="form-row-inline">
                    <div class="form-row">
                        <label>Full Name *</label>
                        <input type="text" name="new_name" placeholder="Customer name">
                    </div>
                    <div class="form-row">
                        <label>Phone *</label>
                        <input type="text" name="new_phone" placeholder="10-digit mobile">
                    </div>
                </div>
                <div class="form-row-inline">
                    <div class="form-row">
                        <label>Gender</label>
                        <select name="new_gender">
                            <option value="">Select</option>
                            <option>Male</option>
                            <option>Female</option>
                            <option>Other</option>
                        </select>
                    </div>
                    <div class="form-row">
                        <label>Age</label>
                        <input type="number" name="new_age" placeholder="Age" min="1" max="120">
                    </div>
                    <div class="form-row">
                        <label>Email (@gmail.com)</label>
                        <input type="email" name="new_email" placeholder="name@gmail.com"
                               pattern=".*@gmail\.com$">
                    </div>
                </div>
                <div class="form-row">
                    <label>Address</label>
                    <input type="text" name="new_address" placeholder="City, State">
                </div>
            </div>
        </div>

        <!-- PAYMENT -->
        <div class="form-row-inline">
            <div class="form-row">
                <label>Payment Mode</label>
                <select name="payment_mode">
                    <option value="Cash">Cash</option>
                    <option value="Card">Card</option>
                    <option value="UPI">UPI</option>
                    <option value="Credit">Credit</option>
                </select>
            </div>
            <div class="form-row">
                <label>Discount (%)</label>
                <input type="number" name="discount" value="0" min="0" max="100" step="0.01">
            </div>
        </div>

        <!-- PRODUCT SELECTION -->
        <div class="section-title">Select Products by Category</div>
        <div class="form-row">
            <label>Category</label>
            <select onchange="loadProducts(this.value)">
                <option value="">-- Select Category --</option>
                <% while(cat.next()){ %>
                <option value="<%= cat.getInt("category_id") %>">
                    <%= cat.getString("category_name") %>
                </option>
                <% } %>
            </select>
        </div>

        <div id="productDiv"></div>

        <!-- CART -->
        <div class="section-title">Cart</div>
        <table id="cartTable">
            <thead>
                <tr>
                    <th>Product</th><th>Qty</th>
                    <th>Unit Price</th><th>Total</th><th>Action</th>
                </tr>
            </thead>
            <tbody id="cartBody"></tbody>
        </table>

        <div id="cartEmpty" class="empty-cart">
            No products added yet. Select a category above and click Add.
        </div>

        <!-- Hidden inputs — filled by renderCart() on every change -->
        <div id="hiddenInputs"></div>
        <input type="hidden" name="grand_total" id="grandTotal" value="0">

        <div class="total-row">
            Grand Total: &#8377; <span id="totalAmount">0.00</span>
        </di
        v>

        <button type="submit" class="btn-submit">&#10003; Submit Sale</button>

    </form>
</div>
</div>

<% if(con != null) try{ con.close(); }catch(Exception ignored){} %>
</body>
</html>