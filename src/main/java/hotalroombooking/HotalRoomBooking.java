package hotalroombooking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/HotalRoomBooking")
public class HotalRoomBooking extends HttpServlet {

	 private Connection getConnection() throws Exception {
	        Class.forName("org.postgresql.Driver");
	        return DriverManager.getConnection("jdbc:postgresql://localhost:5432/BookingApplications", "postgres", "malai900");
	    }

	    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        String action = request.getParameter("action") != null ? request.getParameter("action") : "list";

	        try {
	            switch (action) {
	                case "add":
	                    request.getRequestDispatcher("addhotalroombooking.jsp").forward(request, response);
	                    break;
	                case "edit":
	                    loadRoomForEdit(request, response);
	                    break;
	                case "delete":
	                    deleteRoom(request, response);
	                    break;
	                default:
	                    listRooms(request, response);
	            }
	        } catch (Exception e) {
	            throw new ServletException(e);
	        }
	    }

	    private void listRooms(HttpServletRequest request, HttpServletResponse response) throws Exception {
	        HttpSession session = request.getSession(false);
	        if (session == null || session.getAttribute("role") == null) {
	            response.sendRedirect("login.jsp");
	            return;
	        }

	        String role = session.getAttribute("role").toString();

	        List<Room> roomList = new ArrayList<>();
	        try (Connection con = getConnection();
	             PreparedStatement ps = con.prepareStatement("SELECT * FROM room");
	             ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Room room = new Room();
	                room.setRoomNo(rs.getString("roomno"));
	                room.setType(rs.getString("type"));
	                room.setPrice(rs.getDouble("price"));
	                room.setStatus(rs.getString("status"));
	                roomList.add(room);
	            }
	        }

	        request.setAttribute("roomList", roomList);

	        if ("admin".equals(role)) {
	            // Admin gets the full editable panel
	            request.getRequestDispatcher("hotalroombooking.jsp").forward(request, response);
	        } else if ("user".equals(role)) {
	            // User sees a readonly version
	            request.getRequestDispatcher("userhotalroombookinglist.jsp").forward(request, response);
	        } else {
	            response.sendRedirect("login.jsp"); // fallback
	        }
	    }

	    private void loadRoomForEdit(HttpServletRequest request, HttpServletResponse response) throws Exception {
	        String roomNo = request.getParameter("roomno");
	        Room room = new Room();

	        try (Connection con = getConnection();
	             PreparedStatement ps = con.prepareStatement("SELECT * FROM room WHERE roomno = ?")) {
	            ps.setString(1, roomNo);
	            ResultSet rs = ps.executeQuery();
	            if (rs.next()) {
	                room.setRoomNo(rs.getString("roomno"));
	                room.setType(rs.getString("type"));
	                room.setPrice(rs.getDouble("price"));
	                room.setStatus(rs.getString("status"));
	            }
	        }

	        request.setAttribute("room", room);
	        request.getRequestDispatcher("addhotalroombooking.jsp").forward(request, response);
	    }

	    private void deleteRoom(HttpServletRequest request, HttpServletResponse response) throws Exception {
	        String roomNo = request.getParameter("roomno");
	        try (Connection con = getConnection();
	             PreparedStatement ps = con.prepareStatement("DELETE FROM room WHERE roomno = ?")) {
	            ps.setString(1, roomNo);
	            ps.executeUpdate();
	        }
	        response.sendRedirect("hotalroombooking.jsp?deleted=success");

	    }

	    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        String action = request.getParameter("action");

	        String roomNo = request.getParameter("roomno");
	        String type = request.getParameter("type");
	        String price = request.getParameter("price");
	        String status = request.getParameter("status");

	        try (Connection con = getConnection()) {
	            if ("update".equals(action)) {
	                PreparedStatement ps = con.prepareStatement("UPDATE room SET type=?, price=?, status=? WHERE roomno=?");
	                ps.setString(1, type);
	                ps.setDouble(2, Double.parseDouble(price));
	                ps.setString(3, status);
	                ps.setString(4, roomNo);
	                ps.executeUpdate();
	            } else {
	                PreparedStatement ps = con.prepareStatement("INSERT INTO room (roomno, type, price, status) VALUES (?, ?, ?, ?)");
	                ps.setString(1, roomNo);
	                ps.setString(2, type);
	                ps.setDouble(3, Double.parseDouble(price));
	                ps.setString(4, status);
	                ps.executeUpdate();
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        response.sendRedirect("hotalroombooking.jsp");

	    }
	}