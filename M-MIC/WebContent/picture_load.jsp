<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
// picture code를 parameter 전송하여 해당하는 blob파일을 호출
// main_members에서 img src로 load

	request.setCharacterEncoding("utf-8");

	Blob image = null;
	Connection con = null;
	byte[ ] imgData = null ;
	Statement stmt = null;
	ResultSet rs = null;
	String n = request.getParameter("picture");
	int id = Integer.parseInt(n);
	
	try {
	
		Class.forName("com.mysql.cj.jdbc.Driver");
		String url_mysql = "jdbc:mysql://106.10.33.249:3306/mmic_db?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Seoul";
		String id_mysql = "mmic";
		String pw_mysql = "mmic!@21";
		con = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
		
		
		stmt = con.createStatement();
		
		rs = stmt.executeQuery("select picture_file from t_usr_user, t_usr_picture where t_usr_picture.picture_code = "+id+" and t_usr_user.picture_code = t_usr_picture.picture_code;");
		
		
		out.clear();
		out=pageContext.pushBody();
		
		 
		if (rs.next()) {
			image = rs.getBlob(1);
			imgData = image.getBytes(1,(int)image.length());
		
		} else {
			out.println("Display Blob Example");
			out.println("image not found for given id");
		
			return;
		}
		
		
		// display the image
		
		response.setContentType("image/jpeg");
		OutputStream o = response.getOutputStream();
		o.write(imgData);
		o.flush();
		o.close();
		
	} catch (Exception e) {
	
		out.println("Unable To Display image");
		out.println("Image Display Error=" + e.getMessage());
		
		return;
	
	} finally {
	
		try {
		
			rs.close();
			stmt.close();
			con.close();
		
		} catch (SQLException e) {
		
			e.printStackTrace();
		
		}
	}

%>
</body>
</html>