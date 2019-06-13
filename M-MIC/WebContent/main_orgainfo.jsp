<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css_orgainfo.css">
</head>
<%
request.setCharacterEncoding("utf-8");



int orga_code = (Integer)session.getAttribute("orga_code");
String orga_name = (String)session.getAttribute("orga_name");
String address = "";
String phone = "";

String whereDefault = "select * from t_usr_organization where orga_code = "+orga_code; // img, name

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
	Statement stmt_mysql = conn_mysql.createStatement();

	ResultSet rs = stmt_mysql.executeQuery(whereDefault);

	while (rs.next()) {
		address = rs.getString(3);
		phone = rs.getString(4);
	}
	conn_mysql.close();

} catch (SQLException e) {
	System.out.println("SQL 회사 조회 Exception : " + e.getMessage());
	e.printStackTrace();
}
%>
<body>
<p>회사 정보 수정을 원하신다면 유지보수팀에게 문의하세요.</p>
<table>
<tr><th>회사명</th><td><%=orga_name %></td></tr>
<tr><th>주소</th><td><%=address %></td></tr>
<tr><th>전화번호</th><td><%=phone %></td></tr>
<tr><td colspan="2" class="btn"><button onclick="window.close();">닫기</button></td></tr>
</table>
</body>
</html>
