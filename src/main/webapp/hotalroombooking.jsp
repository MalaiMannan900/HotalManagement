<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Hotel Room Management (Admin Panel)</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 40px;
      background: #f4f4f4;
    }

    h2 {
      text-align: center;
    }

    #addRoomBtn {
      background-color: #27ae60;
      color: white;
      padding: 10px 18px;
      border: none;
      border-radius: 6px;
      font-size: 15px;
      cursor: pointer;
      margin-bottom: 20px;
      transition: background-color 0.3s ease;
    }

    #addRoomBtn:hover {
      background-color: #219150;
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

    .edit-btn {
      background-color: #3498db;
      color: white;
    }

    .delete-btn {
      background-color: #e74c3c;
      color: white;
    }

    .edit-btn:hover {
      background-color: #2980b9;
    }

    .delete-btn:hover {
      background-color: #c0392b;
    }
  </style>
</head>
<body>

  <h2>Hotel Room Management (Admin Panel)</h2>

<button id="addRoomBtn" onclick="window.location.href='HotalRoomBooking?action=add'">Add Room</button>

  <h3>All Rooms</h3>

  <table>
    <thead>
      <tr>
        <th>Room No</th>
        <th>Type</th>
        <th>Price</th>
        <th>Status</th>
        <th>Action</th>
      </tr>
    </thead>
    <tbody>
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
        <td>
          <a class="edit-btn" href="addhotalroombooking.jsp?roomno=<%= rs.getString("roomno") %>">Edit</a>
          <a class="delete-btn" href="HotalRoomBooking?action=delete&roomno=<%= rs.getString("roomno") %>" onclick="return confirm('Are you sure you want to delete this room?');">Delete</a>
        </td>
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
    </tbody>
  </table>

</body>
</html>
