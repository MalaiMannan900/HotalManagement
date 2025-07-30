package hotalsignup;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * Servlet implementation class HotalSignup
 */
@WebServlet("/HotalSignup")
public class HotalSignup extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			Class.forName("org.postgresql.Driver");
		}
		catch(ClassNotFoundException c) {
			System.out.println(c);
		}
		try {
			
	
			Connection con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/BookingApplications","postgres","malai900");
			PreparedStatement ps= con.prepareStatement("INSERT INTO register (name, mobileno, email, password, username) VALUES (?, ?, ?, ?, ?)");
			String a=request.getParameter("name");
            String b=request.getParameter("mobileno");
			String c=request.getParameter("email");
			String d=request.getParameter("password");
			String e=request.getParameter("username");
			
			ps.setString(1, a);
			ps.setString(2, b);
			ps.setString(3, c);
			ps.setString(4, d);
			ps.setString(5, e);
			int x=ps.executeUpdate();
			if(x>0)
			{
				response.sendRedirect("index.html");
			}
			else
			{
				response.sendRedirect("signup error.jsp");
			}
			con.close();
			

		}
		catch(Exception e) {
			System.out.println(e);
	}
}
}
