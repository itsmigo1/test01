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

@WebServlet("/login_chk_S")
public class login_chk_S extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public login_chk_S() {
        super();
        // TODO Auto-generated constructor stub
    }
    
	private String url_mysql = "jdbc:mysql://106.10.33.249:3306/mmic_db?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Seoul";
	private String id_mysql = "mmic";
	private String pw_mysql = "mmic!@21";

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		
		String id = request.getParameter("id");
		session.setAttribute("sessionID", id);
		String pw = request.getParameter("pw");
		session.setAttribute("sessionPW", pw);
		
		String sql_pw = "";
		int orga_code;
		String orga_name = "";
		
		System.out.println("ID:"+(String)session.getAttribute("sessionID")+" / PW :"+(String)session.getAttribute("sessionPW"));
		
			
		try {
			System.out.println("mysql 접속");
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
			Statement stmt_mysql = conn_mysql.createStatement();
			String A = "select adm.admin_pw, adm.orga_code, org.orga_name";
			String B = " from t_usr_admin adm, t_usr_organization org";
			String C = " where adm.orga_code = org.orga_code";
			String D = " and adm.admin_id = '"+id+"'";
			String whereDefault = A+B+C+D;
			
			ResultSet rs = stmt_mysql.executeQuery(whereDefault);
			
			if (rs.next()) {
				sql_pw = rs.getString(1);
				orga_code = rs.getInt(2);
				orga_name = rs.getString(3);
				
				if (pw.equals(sql_pw)&&sql_pw.equals("1234")){
					System.out.println("비밀번호초기화");
					session.setAttribute("orga_code", orga_code);
					session.setAttribute("orga_name", orga_name);
					out.println("<script>alert('비밀번호 변경 페이지로 이동합니다.');document.location.href='login_changePW.jsp';</script>");
					
				} else if (pw.equals(sql_pw)){
					System.out.println("인증성공");
					session.setAttribute("orga_code", orga_code);
					session.setAttribute("orga_name", orga_name);
					out.println("<script>document.location.href='main.jsp';</script>");
				} else {
					session.invalidate();
					System.out.println("else");
					out.println("<script>alert('비밀번호가 틀렸습니다.'); document.location.href='index.jsp';</script>");
				}
				
			} else {
				session.invalidate();
				out.println("<script>alert('존재하지 않는 아이디 입니다.'); document.location.href='index.jsp';</script>");
					
			}//else 종료
			conn_mysql.close();
			
		} catch(SQLException | ClassNotFoundException e) {
			System.out.println("SQL Exception : " + e.getMessage());
		    e.printStackTrace();
			if(session!=null) {
				session.invalidate();
			}
			out.println("<script>alert('페이지 접속 오류입니다. 유지보수팀에 문의하세요.'); document.location.href='index.jsp';</script>");
		}
			
	}

}
