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

@WebServlet("/edit_admin_S")
public class edit_admin_S extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public edit_admin_S() {
        super();
    }
    
	private String url_mysql = "jdbc:mysql://106.10.33.249:3306/mmic_db?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Seoul";
	private String id_mysql = "mmic";
	private String pw_mysql = "mmic!@21";

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		
		String admin_id = (String)session.getAttribute("sessionID");
		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String mail = request.getParameter("mail");
		
		PreparedStatement ps = null;
		
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
			
			String A = "update t_usr_admin set admin_id=?, admin_name=?, admin_phone_number=?, admin_email=?";
			String B = " where admin_id = ?";
			
			ps = conn_mysql.prepareStatement(A + B);
			ps.setString(1, admin_id);
			ps.setString(2, name);
			ps.setString(3, phone);
			ps.setString(4, mail);
			ps.setString(5, admin_id);
			ps.executeUpdate();
			
			conn_mysql.close();
			out.println("<script>alert('정상적으로 수정되었습니다.'); document.location.href='main_edit_admin.jsp' </script>");
			
		} catch(SQLException | ClassNotFoundException e) {
			System.out.println("SQL 관리자 정보 수정 실패 오류 Exception : " + e.getMessage());
		    e.printStackTrace();
		    out.println("<script>alert('수정에 실패하였습니다. 유지보수팀에게 문의하세요.'); document.location.href='main_edit_admin.jsp'; </script>");
		    
		}
	}

}
