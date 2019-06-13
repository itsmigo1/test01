package com.project.mmic;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/member_add_S")
@MultipartConfig(maxFileSize = 1024*1024*5)
public class member_add_S extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public member_add_S() {
		super();
	}
	
	private String url_mysql = "jdbc:mysql://106.10.33.249:3306/mmic_db?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Seoul";
	private String id_mysql = "mmic";
	private String pw_mysql = "mmic!@21";

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("직원 등록 서블렛");

		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();

		Part filePart = request.getPart("file");
		String name = request.getParameter("name");
		String id = request.getParameter("id");
		String dep = request.getParameter("dep");
		String job = request.getParameter("job");
		String year = request.getParameter("year");

		InputStream inputStream = null;
		
		int filesize = (int)(long)filePart.getSize();
		System.out.println("파일크기 : " +filesize);
		
    	// prints out some information for debugging
    	System.out.println(filePart.getName());
    	System.out.println(filePart.getSize());
    	System.out.println(filePart.getContentType());
    	
    	// obtains input stream of the upload file
    	inputStream = filePart.getInputStream();
    
	
		// picture 등록
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
			String A = "INSERT INTO t_usr_picture (recognition_rate, picture_file";
			String B = ") values (?,?)";
			int rec = 15;

			PreparedStatement ps = conn_mysql.prepareStatement(A + B);
			ps.setInt(1, rec);
			
			if (inputStream != null) {
                // fetches input stream of the upload file for the blob column
				ps.setBlob(2, inputStream);
            }

			ps.executeUpdate();
			conn_mysql.close();
			
		} catch (SQLException | ClassNotFoundException e) {
			System.out.println("SQL FACE ID 등록 실패 오류 Exception : " + e.getMessage());
			e.printStackTrace();
		}
		
		// picture code 불러오기
		String picture_code = "";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
			Statement stmt_mysql = conn_mysql.createStatement();
			String whereDefault = "SELECT picture_code FROM t_usr_picture WHERE picture_code=(SELECT MAX(picture_code) FROM t_usr_picture);";
			ResultSet rs = stmt_mysql.executeQuery(whereDefault);
	
			while (rs.next()) {
				picture_code = rs.getString(1);
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		// user 저장하기
		int orga_code = (Integer)session.getAttribute("orga_code");
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
			String A = "INSERT INTO t_usr_user (user_id, user_name, user_pw, department_code, job_code, effective_start_date, orga_code, picture_code";
			String B = ") values (?,?,?,?,?,?,?,?)";
			
			PreparedStatement ps = conn_mysql.prepareStatement(A + B);
			ps.setString(1, id);
			ps.setString(2, name);
			ps.setString(3, "1234");
			ps.setString(4, dep);
			ps.setString(5, job);
			ps.setString(6, year);
			ps.setInt(7, orga_code);
			ps.setString(8, picture_code);
			ps.executeUpdate();
			
			conn_mysql.close();
			
			out.println("<script>alert('동록되었습니다.'); document.location.href='main_members.jsp' </script>");

		} catch (SQLException | ClassNotFoundException e) {
			System.out.println("SQL FACE ID 등록 실패 오류 Exception : " + e.getMessage());
			e.printStackTrace();
			out.println("<script>alert('등록 실패하였습니다. 유지보수팀에게 문의하세요.'); document.location.href='main_members_add.jsp' </script>");
		}
		
		
	} // DoPost

}
