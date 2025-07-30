package hotallogin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet implementation class HotalLogin
 */
@WebServlet("/HotalLogin")
public class HotalLogin extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();

        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException c) {
            System.out.println("PostgreSQL JDBC Driver not found.");
            c.printStackTrace();
            response.sendRedirect("loginerror.jsp");
            return;
        }

        try (Connection con = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/BookingApplications", "postgres", "malai900")) {

            HttpSession session = request.getSession();

            // ✅ Admin Login Condition
            if ("admin".equalsIgnoreCase(username) && "A0001".equals(password)) {
                session.setAttribute("role", "admin");
                session.setAttribute("username", "admin");
                session.setAttribute("message", "Admin login successful!");
                response.sendRedirect("HotalRoomBooking?action=list"); 
                return;
            }

            // ✅ Regular User Login from DB
            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM register WHERE username = ? AND password = ?");
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("role", "user");
                session.setAttribute("username", rs.getString("username")); // DB Username
                session.setAttribute("message", "User login successful!");
                response.sendRedirect("userhotalroombookinglist.jsp");
            } else {
                session.setAttribute("error", "Invalid username or password.");
                response.sendRedirect("loginerror.jsp");
            }

        } catch (Exception e) {
            System.out.println("Database connection or query failed.");
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Internal server error.");
            response.sendRedirect("loginerror.jsp");
        }
    }
}