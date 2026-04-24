package com.inventory.servlet;

import java.io.*;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.inventory.DBConnection;

@WebServlet("/GetProductsByCategoryServlet")
public class GetProductsByCategoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String catId = request.getParameter("category_id");
        if (catId == null || catId.isEmpty()) {
            out.print("[]");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "SELECT p.product_id, p.product_name, p.price, p.unit, " +
                "       COALESCE(s.quantity, 0) AS stock_qty " +
                "FROM PRODUCTS p " +
                "LEFT JOIN STOCK s ON p.product_id = s.product_id " +
                "WHERE p.category_id = ? " +
                "ORDER BY p.product_name"
            );
            ps.setInt(1, Integer.parseInt(catId));
            ResultSet rs = ps.executeQuery();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;

            while (rs.next()) {
                if (!first) json.append(",");
                first = false;

                int    pid      = rs.getInt("product_id");
                String name     = rs.getString("product_name");
                double price    = rs.getDouble("price");
                int    stockQty = rs.getInt("stock_qty");
                String unit     = rs.getString("unit");

                String safeName = name
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");

                json.append("{")
                    .append("\"pid\":"    ).append(pid      ).append(",")
                    .append("\"name\":\"" ).append(safeName ).append("\",")
                    .append("\"price\":") .append(price     ).append(",")
                    .append("\"stock\":") .append(stockQty  ).append(",")
                    .append("\"unit\":\"").append(unit != null ? unit : "pcs").append("\"")
                    .append("}");
            }

            json.append("]");
            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]");
        }
    }
}