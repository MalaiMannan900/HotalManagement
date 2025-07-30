<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>Room List</title>
<style>
    body {
      font-family: Arial, sans-serif;
      margin: 40px;
      background: #f4f4f4;
    }

    h2 {
      text-align: center;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background: white;
    }

    th, td {
      padding: 10px;
      border: 1px solid #ddd;
      text-align: left;
    }

    th {
      background-color: #2ecc71;
      color: white;
    }

    a {
      text-decoration: none;
      padding: 5px 10px;
      border-radius: 4px;
      margin-right: 5px;
    }

   
  </style>
</head>
<body>
    <h2>Hotel Room List</h2>
    <table border="1">
        <tr>
            <th>Room No</th>
            <th>Type</th>
            <th>Price</th>
            <th>Status</th>
           
        </tr>
      <%
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/BookingApplications", "postgres", "malai900");
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT * FROM room");
            while (rs.next()) {
      %>
        <tr>
        <td><%= rs.getString("roomno") %></td>
        <td><%= rs.getString("type") %></td>
        <td><%= rs.getString("price") %></td>
        <td><%= rs.getString("status") %></td>
      </tr>
        <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        }
      %>
    </table>
</body>
</html>