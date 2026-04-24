package com.inventory.servlet;

import java.io.*;
import java.sql.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.inventory.DBConnection;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Basic validation
        if (username == null || username.isEmpty() ||
            password == null || password.isEmpty()) {

            response.sendRedirect("registration.jsp?error=empty");
            return;
        }

        String checkQuery = "SELECT user_id FROM USERS WHERE username = ?";
        String insertQuery = "INSERT INTO USERS (username, password, role, email, phone) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement check = con.prepareStatement(checkQuery)) {

            check.setString(1, username);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                // username already exists
                response.sendRedirect("registration.jsp?error=exists");
                return;
            }

            try (PreparedStatement ps = con.prepareStatement(insertQuery)) {

                ps.setString(1, username);
                ps.setString(2, password); // ⚠️ plain text (see note below)
                ps.setString(3, role);
                ps.setString(4, email);
                ps.setString(5, phone);

                ps.executeUpdate();
            }

            response.sendRedirect("registration.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("registration.jsp?error=server");
        }
    }
}