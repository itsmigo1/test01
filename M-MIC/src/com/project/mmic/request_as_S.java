package com.project.mmic;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/request_as_S")
public class request_as_S extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	public request_as_S() {
        super();
    }

    private String url_mysql = "jdbc:mysql://106.10.33.249:3306/mmic_db?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Seoul";
	private String id_mysql = "mmic";
	private String pw_mysql = "mmic!@21";
	
	SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
	Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	String now = format.format(timestamp);
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		System.out.println("request as S 접속");
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		
		String admin_id = (String)session.getAttribute("sessionID");
		int orga_code = (Integer)session.getAttribute("orga_code");
		
		String as_code= request.getParameter("as_code");
		String title= request.getParameter("title");
		String content= request.getParameter("content");
		content = content.replace("\r\n", "<br>");
		
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);

			String A = "insert into t_usr_as_question (as_code, question_title, question_content, question_date, admin_id, orga_code)";
			String B = " values (?, ?, ?, ?, ?, ?)";

			PreparedStatement ps = conn_mysql.prepareStatement(A + B);
			ps.setString(1, as_code);
			ps.setString(2, title);
			ps.setString(3, content);
			ps.setString(4, now);
			ps.setString(5, admin_id);
			ps.setInt(6, orga_code);
			ps.executeUpdate();

			out.println("<script>alert('성공적으로 등록되었습니다.');opener.location.reload();window.close();</script>");
			conn_mysql.close();
			
		} catch (SQLException | ClassNotFoundException e) {
			System.out.println("SQL AS 등록 실패 오류 Exception : " + e.getMessage());
			out.println("<script>alert('등록 실패하였습니다. 유지보수팀에게 유선 문의 부탁드립니다.');opener.location.reload();window.close();</script>");
			e.printStackTrace();
		}
		
	}

}
