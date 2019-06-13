package com.project.mmic;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login_changePW_S")
public class login_changePW_S extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public login_changePW_S() {
        super();
        // TODO Auto-generated constructor stub
    }


	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();

		String newpw1 = request.getParameter("newpw1");
		String id = String.valueOf(session.getAttribute("sessionID"));
		session.removeAttribute("sessionPW");
		session.setAttribute("sessionPW", newpw1);
		
		PreparedStatement ps = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
			
			String A = "update t_usr_admin set admin_pw=?";
			String B = " where admin_id = ?";
			
			ps = conn_mysql.prepareStatement(A + B);
			ps.setString(1, newpw1);
			ps.setString(2, id);
			ps.executeUpdate();
			
			conn_mysql.close();
			out.println("<script>alert('비밀번호가 성공적으로 변경되었습니다.');document.location.href='main.jsp';</script>");

		} catch(SQLException | ClassNotFoundException e) {
			System.out.println("SQL Exception : " + e.getMessage());
		    e.printStackTrace();
		    out.println("<script>alert('비밀번호 변경에 실패하였습니다. 유지보수팀에게 문의하세요.');document.location.href='login.jsp';</script>");
			session.invalidate();
		}
		
	}// DoPost 끝

}
