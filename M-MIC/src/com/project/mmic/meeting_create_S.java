package com.project.mmic;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/meeting_create_S")
public class meeting_create_S extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public meeting_create_S() {
        super();
        // TODO Auto-generated constructor stub
    }


	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		String user_id = (String)session.getAttribute("sessionID"); // 회의생성자 id
		long timestamp = System.currentTimeMillis()/1000; //timestamp
		int orga_code = (Integer)session.getAttribute("orga_code");
		
		// insert info
		
		String meeting_id = user_id+timestamp;
		String meeting_topic = request.getParameter("topic");
		String meeting_location = request.getParameter("location");
		String record_start = request.getParameter("date");
		String[] attendee = request.getParameterValues("attendee");
		
		// null check
		if (meeting_location.equals("")) {
			out.println("<script>alert('회의 장소를 입력해주세요.'); document.location.href='main_create.jsp'; </script>");
		}

		else if (meeting_topic.equals("")) {
			out.println("<script>alert('회의 주제를 입력해주세요.'); document.location.href='main_create.jsp'; </script>");
		}
		
		else if (attendee.length==0) {
			out.println("<script>alert('참석자를 선택해주세요.'); document.location.href='main_create.jsp'; </script>");
		}
		
		else{
		
			// 회의록 등록
			PreparedStatement ps = null;
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
				
				String A = "INSERT INTO t_mic_meeting (meeting_id, meeting_topic, meeting_location, record_start, orga_code";
				String B = ") values (?,?,?,?,?)";
				
				ps = conn_mysql.prepareStatement(A + B);
				ps.setString(1, meeting_id);
				ps.setString(2, meeting_topic);
				ps.setString(3, meeting_location);
				ps.setString(4, record_start);
				ps.setInt(5, orga_code);
				ps.executeUpdate();
				
				conn_mysql.close();
				//out.println("<script>alert('성공적으로 등록되었습니다.'); document.location.href='main.jsp'; </script>");
	
			} catch(SQLException | ClassNotFoundException e) {
				System.out.println("회의등록 실패오류 Exception : " + e.getMessage());
			    e.printStackTrace();
				out.println("<script>alert('회의등록에 실패하였습니다. 관리자에게 문의하세요.'); document.location.href='main.jsp'; close(); </script>");
			
			}
			
			// 참석자 등록
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
				
				String A = "INSERT INTO t_mic_attend (meeting_id, orga_code, user_id, auth_code";
				String B = ") values (?,?,?,?)";
				
				ps = conn_mysql.prepareStatement(A + B);
				ps.setString(1, meeting_id);
				ps.setInt(2, orga_code);
				ps.setString(3, user_id);
				ps.setInt(4, 1);
				ps.executeUpdate(); // 회의생성자 등록
				
				for (String id: attendee) {
					ps = conn_mysql.prepareStatement(A + B);
					ps.setString(1, meeting_id);
					ps.setInt(2, orga_code);
					ps.setString(3, id);
					ps.setInt(4, 2);
					ps.executeUpdate(); // 회의참여자 등록
				}
				
				conn_mysql.close();
				out.println("<script>alert('성공적으로 등록되었습니다.'); document.location.href='main.jsp'; </script>");
	
			} catch(SQLException | ClassNotFoundException e) {
				System.out.println("회의참여자 등록 실패오류 Exception : " + e.getMessage());
			    e.printStackTrace();
				out.println("<script>alert('회의등록에 실패하였습니다. 관리자에게 문의하세요.'); document.location.href='main.jsp'; close(); </script>");
			
			}
			
			
		
		
		
		}//else 끝

	}//DoPost 끝
}
