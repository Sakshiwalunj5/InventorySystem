package com.inventory.servlet;

import java.io.*;
import java.sql.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.inventory.DBConnection;

@WebServlet("/TestServlet")
public class TestServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><head><title>Products</title>");

        // STYLE
        out.println("<style>");
        out.println("body{margin:0;font-family:Segoe UI;background:#f4f6f9;}");
        out.println(".navbar{background:#1e3a8a;color:white;padding:15px;display:flex;justify-content:space-between;}");
        out.println(".sidebar{width:200px;background:#111827;height:100vh;position:fixed;padding-top:20px;}");
        out.println(".sidebar a{display:block;color:white;padding:12px;text-decoration:none;}");
        out.println(".sidebar a:hover{background:#2563eb;}");
        out.println(".main{margin-left:200px;padding:40px;}");
        out.println("table{width:80%;margin:auto;background:white;border-collapse:collapse;box-shadow:0 2px 8px rgba(0,0,0,0.2);}");
        out.println("th{background:#1e3a8a;color:white;padding:10px;}");
        out.println("td{padding:10px;border-bottom:1px solid #ddd;text-align:center;}");
        out.println("</style></head><body>");

        // NAVBAR
        out.println("<div class='navbar'><div>Inventory System</div><div><a href='logout.jsp' style='color:white;'>Logout</a></div></div>");

        // SIDEBAR
        out.println("<div class='sidebar'>");
        out.println("<a href='index.jsp'>Dashboard</a>");
        out.println("<a href='TestServlet'>Products</a>");
        out.println("<a href='addSale.jsp'>Add Sale</a>");
        out.println("<a href='report.jsp'>Reports</a>");
        out.println("<a href='lowStock.jsp'>Low Stock</a>");
        out.println("</div>");

        // MAIN
        out.println("<div class='main'>");
        out.println("<h2>Products</h2>");
        out.println("<table>");
        out.println("<tr><th>ID</th><th>Name</th><th>Category</th><th>Supplier</th><th>Price</th><th>Stock</th></tr>");

        String query = """
            SELECT p.product_id, p.product_name, p.price,
                   c.category_name,
                   s.supplier_name,
                   st.quantity
            FROM PRODUCTS p
            LEFT JOIN CATEGORIES c ON p.category_id = c.category_id
            LEFT JOIN SUPPLIERS s ON p.supplier_id = s.supplier_id
            LEFT JOIN STOCK st ON p.product_id = st.product_id
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("product_id") + "</td>");
                out.println("<td>" + rs.getString("product_name") + "</td>");
                out.println("<td>" + (rs.getString("category_name") != null ? rs.getString("category_name") : "-") + "</td>");
                out.println("<td>" + (rs.getString("supplier_name") != null ? rs.getString("supplier_name") : "-") + "</td>");
                out.println("<td>₹ " + rs.getDouble("price") + "</td>");
                out.println("<td>" + rs.getInt("quantity") + "</td>");
                out.println("</tr>");
            }

        } catch (Exception e) {
            out.println("<p style='color:red;text-align:center;'>Error loading products</p>");
            e.printStackTrace();
        }

        out.println("</table>");
        out.println("</div></body></html>");
    }
}