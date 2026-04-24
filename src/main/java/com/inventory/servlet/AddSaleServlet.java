package com.inventory.servlet;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.inventory.DBConnection;

@WebServlet("/AddSaleServlet")
public class AddSaleServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Connection con = null;

        try {
            // Session check
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int userId = (int) session.getAttribute("user_id");

            // Cart arrays from hidden inputs
            String[] productIds = request.getParameterValues("product_id");
            String[] quantities = request.getParameterValues("quantity");
            String[] unitPrices = request.getParameterValues("unit_price");
            String[] lineTotals = request.getParameterValues("line_total");

            if (productIds == null || productIds.length == 0) {
                response.sendRedirect("addSale.jsp?error=Cart+is+empty");
                return;
            }

            // Payment and discount
            String paymentMode = request.getParameter("payment_mode");
            if (paymentMode == null || paymentMode.isEmpty()) paymentMode = "Cash";

            double discount = 0;
            try { discount = Double.parseDouble(request.getParameter("discount")); }
            catch (Exception ignored) {}

            double grandTotal = 0;
            try { grandTotal = Double.parseDouble(request.getParameter("grand_total")); }
            catch (Exception ignored) {}

            double discountAmount = grandTotal * discount / 100.0;
            double finalTotal     = grandTotal - discountAmount;

            con = DBConnection.getConnection();
            con.setAutoCommit(false); // BEGIN TRANSACTION

            // Customer handling
            String  customerType = request.getParameter("customerType");
            Integer customerId   = null;

            if ("new".equals(customerType)) {
                String newName    = request.getParameter("new_name");
                String newPhone   = request.getParameter("new_phone");
                String newGender  = request.getParameter("new_gender");
                String newAgeStr  = request.getParameter("new_age");
                String newEmail   = request.getParameter("new_email");
                String newAddress = request.getParameter("new_address");

                if (newName != null && !newName.trim().isEmpty()
                        && newPhone != null && !newPhone.trim().isEmpty()) {

                    PreparedStatement psNewCust = con.prepareStatement(
                        "INSERT INTO CUSTOMERS (name, gender, age, email, phone, address) " +
                        "VALUES (?, ?, ?, ?, ?, ?)",
                        Statement.RETURN_GENERATED_KEYS
                    );
                    psNewCust.setString(1, newName.trim());
                    psNewCust.setString(2, (newGender != null && !newGender.isEmpty()) ? newGender : null);
                    if (newAgeStr != null && !newAgeStr.isEmpty())
                        psNewCust.setInt(3, Integer.parseInt(newAgeStr));
                    else
                        psNewCust.setNull(3, Types.INTEGER);
                    psNewCust.setString(4, (newEmail != null && !newEmail.isEmpty()) ? newEmail : null);
                    psNewCust.setString(5, newPhone.trim());
                    psNewCust.setString(6, (newAddress != null && !newAddress.isEmpty()) ? newAddress : null);
                    psNewCust.executeUpdate();

                    ResultSet newCustKey = psNewCust.getGeneratedKeys();
                    if (newCustKey.next()) customerId = newCustKey.getInt(1);
                    psNewCust.close();
                }

            } else {
                String custIdStr = request.getParameter("customer_id");
                if (custIdStr != null && !custIdStr.isEmpty()) {
                    try { customerId = Integer.parseInt(custIdStr); }
                    catch (Exception ignored) {}
                }
            }

            // INSERT header row into SALES
            PreparedStatement psSale = con.prepareStatement(
                "INSERT INTO SALES (customer_id, user_id, sale_date, total_amount, discount, payment_mode) " +
                "VALUES (?, ?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            if (customerId != null)
                psSale.setInt(1, customerId);
            else
                psSale.setNull(1, Types.INTEGER);

            psSale.setInt(2, userId);
            psSale.setString(3, LocalDate.now().toString()); // Auto date
            psSale.setDouble(4, finalTotal);
            psSale.setDouble(5, discount);
            psSale.setString(6, paymentMode);
            psSale.executeUpdate();

            ResultSet saleKey = psSale.getGeneratedKeys();
            if (!saleKey.next()) throw new Exception("Failed to get sale_id");
            int saleId = saleKey.getInt(1);
            psSale.close();

            // INSERT each product into SALE_ITEMS
            // Triggers fire here: stock check → deduct → audit
            PreparedStatement psItem = con.prepareStatement(
                "INSERT INTO SALE_ITEMS (sale_id, product_id, quantity, unit_price, line_total) " +
                "VALUES (?, ?, ?, ?, ?)"
            );

            for (int i = 0; i < productIds.length; i++) {
                if (productIds[i] == null || productIds[i].trim().isEmpty()) continue;
                if (quantities  == null || i >= quantities.length)           continue;
                if (quantities[i].trim().isEmpty())                          continue;

                int    pid       = Integer.parseInt(productIds[i].trim());
                int    qty       = Integer.parseInt(quantities[i].trim());
                double unitPrice = (unitPrices != null && i < unitPrices.length
                                    && !unitPrices[i].trim().isEmpty())
                                   ? Double.parseDouble(unitPrices[i].trim()) : 0.0;
                double lineTotal = (lineTotals != null && i < lineTotals.length
                                    && !lineTotals[i].trim().isEmpty())
                                   ? Double.parseDouble(lineTotals[i].trim()) : unitPrice * qty;

                psItem.setInt(1, saleId);
                psItem.setInt(2, pid);
                psItem.setInt(3, qty);
                psItem.setDouble(4, unitPrice);
                psItem.setDouble(5, lineTotal);
                psItem.addBatch();
            }

            psItem.executeBatch();
            psItem.close();

            con.commit(); // COMMIT
            response.sendRedirect("addSale.jsp?success=1");

        } catch (SQLIntegrityConstraintViolationException e) {
            rollback(con);
            e.printStackTrace();
            response.sendRedirect("addSale.jsp?error=Duplicate+or+invalid+data");

        } catch (SQLException e) {
            rollback(con);
            e.printStackTrace();
            String msg = e.getMessage();
            if (msg != null && msg.contains("ERROR:"))
                msg = msg.substring(msg.indexOf("ERROR:") + 6).trim();
            else
                msg = "Database error. Check stock and try again.";
            response.sendRedirect("addSale.jsp?error=" +
                java.net.URLEncoder.encode(msg, "UTF-8"));

        } catch (Exception e) {
            rollback(con);
            e.printStackTrace();
            String errMsg = e.getMessage() != null ? e.getMessage() : "Unknown error";
            response.sendRedirect("addSale.jsp?error=" +
                java.net.URLEncoder.encode(errMsg, "UTF-8"));

        } finally {
            if (con != null) try {
                con.setAutoCommit(true);
                con.close();
            } catch (Exception ignored) {}
        }
    }

    private void rollback(Connection con) {
        if (con != null) try { con.rollback(); } catch (Exception ignored) {}
    }
}