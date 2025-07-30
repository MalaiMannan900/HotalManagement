<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String roomno = request.getParameter("roomno");
    String type = "", price = "", status = "";
    boolean isEdit = false;

    if (roomno != null && !roomno.trim().isEmpty()) {
        // Edit mode
        isEdit = true;
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/BookingApplications", "postgres", "malai900");
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM room WHERE roomno = ?");
            ps.setString(1, roomno);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                type = rs.getString("type");
                price = rs.getString("price");
                status = rs.getString("status");
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        // Add mode — auto-generate new room number
        try {
            Class.forName("org.postgresql.Driver");
            Connection con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/BookingApplications", "postgres", "malai900");
            String query = "SELECT CASE WHEN MAX(roomno) IS NULL THEN 'R0001' " +
                           "ELSE 'R' || LPAD((CAST(SUBSTRING(MAX(roomno), 2) AS INTEGER) + 1)::TEXT, 4, '0') END AS next_roomno FROM room";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                roomno = rs.getString("next_roomno");
            } else {
                roomno = "R0001";
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            roomno = "R0001";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title><%= isEdit ? "Update" : "Add" %> Hotel Room</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
      margin: 0;
      background: linear-gradient(to right, #e0eafc, #cfdef3);
    }

    h2 {
      color: #2c3e50;
      text-align: center;
      margin-bottom: 30px;
    }

    .form-container {
      background: #fff;
      padding: 30px 40px;
      border-radius: 12px;
      box-shadow: 0 8px 20px rgba(0,0,0,0.1);
      max-width: 500px;
      margin: 0 auto;
    }

    .form-group {
      display: flex;
      flex-direction: column;
      margin-bottom: 20px;
    }

    .form-group label {
      font-weight: bold;
      margin-bottom: 6px;
      color: #2c3e50;
    }

    .form-group input,
    .form-group select {
      padding: 10px;
      border-radius: 6px;
      border: 1px solid #ccc;
      font-size: 15px;
    }

    .form-actions {
      text-align: center;
      margin-top: 25px;
    }

    button {
      background-color: #3498db;
      color: white;
      padding: 12px 25px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 16px;
      transition: background-color 0.3s ease;
    }

    button:hover {
      background-color: #2980b9;
    }

    .back-link {
      display: inline-block;
      margin-top: 15px;
      text-align: center;
      text-decoration: none;
      color: #555;
      font-size: 14px;
    }

    .back-link:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

  <h2><%= isEdit ? "Update" : "Add" %> Hotel Room</h2>

  <div class="form-container">
    <form action="HotalRoomBooking" method="post">
      <div class="form-group">
        <label for="roomno">Room Number:</label>
        <input type="text" id="roomno" name="roomno" value="<%= roomno %>" readonly>
      </div>

      <div class="form-group">
        <label for="type">Room Type:</label>
        <select name="type" id="type" required>
          <option value="Single" <%= "Single".equals(type) ? "selected" : "" %>>Single</option>
          <option value="Double" <%= "Double".equals(type) ? "selected" : "" %>>Double</option>
          <option value="Suite" <%= "Suite".equals(type) ? "selected" : "" %>>Suite</option>
        </select>
      </div>

      <div class="form-group">
        <label for="price">Price:</label>
        <input type="number" id="price" name="price" value="<%= price %>" required>
      </div>

      <div class="form-group">
        <label for="status">Status:</label>
        <select name="status" id="status" required>
          <option value="Available" <%= "Available".equals(status) ? "selected" : "" %>>Available</option>
          <option value="Booked" <%= "Booked".equals(status) ? "selected" : "" %>>Booked</option>
          <option value="Maintenance" <%= "Maintenance".equals(status) ? "selected" : "" %>>Maintenance</option>
        </select>
      </div>

      <input type="hidden" name="action" value="<%= isEdit ? "update" : "save" %>">

      <div class="form-actions">
        <button type="submit"><%= isEdit ? "Update Room" : "Save Room" %></button>
        <br><br>
        <a href="hotalroombooking.jsp" class="back-link">← Back to Room List</a>
      </div>
    </form>
  </div>

</body>
</html>
