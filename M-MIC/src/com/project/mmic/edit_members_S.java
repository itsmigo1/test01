package com.project.mmic;

import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/edit_members_S")
@MultipartConfig(maxFileSize = 1024*1024*5)
public class edit_members_S extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public edit_members_S() {
        super();
    }


	
	private SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd"); 
	private Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	private String now = format.format(timestamp);
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		InputStream inputStream = null;
		
		String user_id = request.getParameter("id");
		String name = request.getParameter("name"); // 이름
		String dep = request.getParameter("dep"); // 부서
		String job = request.getParameter("job"); // 직급
		String start = request.getParameter("start"); // 입사일자
		String end = request.getParameter("end"); // resign
		
		try {
			Part filePart = request.getPart("file"); // 업로드파일
            inputStream = filePart.getInputStream();
            System.out.println(filePart.getSize());
            System.out.println(filePart.getContentType());
            
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
    				ps.setBlob(2, inputStream);
                }

    			ps.executeUpdate();
    			conn_mysql.close();
    			
    		} catch (SQLException | ClassNotFoundException e) {
    			System.out.println("정보업데이트_SQL FACE ID 등록 실패 오류 Exception : " + e.getMessage());
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
    		
    		// 사진정보 포함 정보 업데이트
    		try {
    		Class.forName("com.mysql.cj.jdbc.Driver");
    		Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
    		PreparedStatement ps = null;
    		
    		String A = "update t_usr_user set user_name=?, department_code=?, job_code=?, effective_start_date=?, picture_code=?";
    		String B = " where user_id = ?";
    		
    		ps = conn_mysql.prepareStatement(A + B);
    		ps.setString(1, name);
    		ps.setString(2, dep);
    		ps.setString(3, job);
    		ps.setString(4, start);
    		ps.setString(5, picture_code);
    		ps.setString(6, user_id);
    		ps.executeUpdate();
    		
    		conn_mysql.close();

    		out.println("<script>alert('수정되었습니다.'); opener.parent.location.reload(); close(); </script>");
    		
    		} catch (Exception e) {
    			
    			System.out.println("사진포함 정보업데이트 Exception : " + e.getMessage());
    			e.printStackTrace();
    			out.println("<script>alert('정보업데이트에 실패하였습니다!'); opener.parent.location.reload(); close(); </script>");
    		}
            
		} catch (NullPointerException ee) {
			
			// 사진 없는 정보 업데이트
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
				PreparedStatement ps = null;
				
				String A = "update t_usr_user set user_name=?, department_code=?, job_code=?, effective_start_date=?";
				String B = " where user_id = ?";
				
				ps = conn_mysql.prepareStatement(A + B);
				ps.setString(1, name);
				ps.setString(2, dep);
				ps.setString(3, job);
				ps.setString(4, start);
				ps.setString(5, user_id);
				ps.executeUpdate();
				
				conn_mysql.close();
				
				out.println("<script>alert('수정되었습니다.'); opener.parent.location.reload(); close(); </script>");
				
			} catch (Exception e) {
				
				System.out.println("사진없는 정보업데이트 Exception : " + e.getMessage());
				e.printStackTrace();
				out.println("<script>alert('정보업데이트에 실패하였습니다!'); opener.parent.location.reload(); close(); </script>");
			}
		}
		
	
		
		// 퇴사자 처리
		if(end!=null) {
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
				String A = "UPDATE t_usr_user SET effective_end_date = '"+now+"' WHERE user_id = '"+user_id+"'";
				
				Statement stmt = conn_mysql.createStatement();
				
				stmt.executeUpdate(A);
				
				conn_mysql.close();
				out.println("<script>alert('퇴사처리 되었습니다!'); opener.parent.location.reload(); close(); </script>");
				
			} catch (Exception e) {
				System.out.println("퇴사자처리 Exception : " + e.getMessage());
				e.printStackTrace();
				out.println("<script>alert('퇴사처리에 실패하였습니다. 유지보수팀에게 문의하세요.'); opener.parent.location.reload(); close(); </script>");
			}
		}
		
	
	}// DoPost 끝

}
