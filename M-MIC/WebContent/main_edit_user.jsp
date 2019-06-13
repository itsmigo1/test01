<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>직원 정보 수정</title>
<link rel="stylesheet" href="css_edit_user.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
</head>
<%

	request.setCharacterEncoding("utf-8");

	String user_id = request.getParameter("id");

	String img = "";
	String name = "";
	String start = "";
	String end = "";
	
	String job_name = "";
	int job_code = 0;

	String dep_name = "";
	int dep_code = 0;
	


	String A = "SELECT ifnull(usr.picture_code, 'NO IMAGE'), usr.user_name,"; // img, name
	String A2 = " usr.department_code, dep.department_name,"; // dep_code, dep_name
	String A3 = " usr.job_code, job.job_description,"; // job_code, job_name
	String A4 = " usr.effective_start_date, ifnull(usr.effective_end_date, 'attending')"; // start, end
	String B = " FROM t_usr_user usr";
	String C = " left JOIN t_usr_department dep ON dep.department_code = usr.department_code";
	String C2 = " left JOIN t_usr_job job ON job.job_code = usr.job_code";
	String D = " WHERE usr.user_id = '" + user_id + "'";
	String whereDefault = (A+A2+A3+A4+B+C+C2+D);

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
		Statement stmt_mysql = conn_mysql.createStatement();

		ResultSet rs = stmt_mysql.executeQuery(whereDefault);

		while (rs.next()) {
			img = rs.getString(1);
			name = rs.getString(2);
			dep_code = rs.getInt(3);
			dep_name = rs.getString(4);
			job_code = rs.getInt(5);
			job_name = rs.getString(6);
			start = rs.getString(7);
			end = rs.getString(8);
		}
		conn_mysql.close();

	} catch (SQLException e) {
		System.out.println("SQL 직원정보수정 팝업 Exception : " + e.getMessage());
		e.printStackTrace();
	}
	
%>

<body>
	<form action="edit_members_S" method="post" enctype="multipart/form-data">
	
	<!-- 파라미터를 위한 user id 영역 -->
	<input type="hidden" name="id" value="<%=user_id %>">
	
	<table>
		<tr>
			<td class='table-content-img' rowspan="5">
				
				<!-- 이미지 없을 경우 이미지 업로드 -->
				<% if (img.equals("NO IMAGE")) { %>
				
				<font style="color: #1f7ca2;">사진을 등록하세요!</font><br><br><br>
				<input type="file" name="file" accept="image/*" size="10">
				
				<% } else { %>
				
				<img id="photoImage" src="picture_load.jsp?picture=<%=img%>" width="200px"><br>
					보안 문제로 사진을<br>삭제할 수 없습니다.
					
				<% } %>
				
				
			</td>
			
			<!-- --------재직자 영역-------- -->
				
				<% if (end.equals("attending")) { %>


			<td class="td-header">이름</td><td class="border"><input type="text" name="name" class="sel" value="<%=name%>"></td>
		</tr>
		<tr>
			<td class="td-header">부서</td>
			<td class="border">
			<%
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
				Statement stmt_mysql = conn_mysql.createStatement();

				A = "SELECT a.department_code, a.department_name";
				B = " FROM t_usr_department a";
				C = " WHERE not exists (SELECT department_code FROM t_usr_user b WHERE b.department_code = a.department_code AND b.user_id = '"+user_id+"')";
				whereDefault = (A + B + C);
				ResultSet rs = stmt_mysql.executeQuery(whereDefault);
				%>
			<select name="dep" class="sel">
			<option value=<%=dep_code%>><%=dep_name%></option>
				<%
				while (rs.next()) {
				%>
				<option value='<%=rs.getString(1) %>'><%=rs.getString(2) %></option>
				<%
				}
				%>
			</select>
				<%
					conn_mysql.close();

				} catch (SQLException e) {
					System.out.println("SQL 부서리스트 Exception : " + e.getMessage());
					e.printStackTrace();
				}
				%>
			</td>
		</tr>
		<tr>
			<td class="td-header">직급</td><td class="border">
			<%
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
				Statement stmt_mysql = conn_mysql.createStatement();

				A = "SELECT a.job_code, a.job_description";
				B = " FROM t_usr_job a";
				C = " WHERE not exists (SELECT job_code FROM t_usr_user b WHERE b.job_code = a.job_code AND b.user_id = '"+user_id+"')";
				whereDefault = (A + B + C);
				ResultSet rs = stmt_mysql.executeQuery(whereDefault);
				%>
			<select name="job" class="sel">
			<option value=<%=job_code%>><%=job_name%></option>
				<%
				while (rs.next()) {
				%>
				<option value='<%=rs.getString(1) %>'><%=rs.getString(2) %></option>
				<%
				}
				%>
			</select>
				<%
					conn_mysql.close();

				} catch (SQLException e) {
					System.out.println("SQL 직급리스트 Exception : " + e.getMessage());
					e.printStackTrace();
				}
				%>
		</tr>
		<tr>
			<td class="td-header">입사일자</td><td class="border"><input type="text" name="start" value="<%=start%>" class="sel"> <br>
				&nbsp;&nbsp;(0000-00-00 형식으로 기재해주세요)</td>
		</tr>
		<tr>
			<td colspan="2"><input type="checkbox" name="end" value="resign"> 퇴사자는 체크해주세요.</td>
		</tr>
		<tr>
			<td colspan="3" style="text-align: right;">
			<button class="closebtn" type="submit"><i class="fas fa-check-circle"></i>&nbsp;저장&nbsp;&nbsp;</button>
			
			
			<!-- --------퇴사자 영역-------- -->	
				
				<% } else { %>
				
			<td class="td-header">이름</td><td class="border"><input type="text" name="name" disabled="disabled" value="<%=name%>" class="sel"></td>
		</tr>
		<tr>
			<td class="td-header">부서</td><td class="border"><input type="text" name="dep" disabled="disabled"  value="<%=dep_name%>" class="sel"></td>
		</tr>
		<tr>
			<td class="td-header">직급</td><td class="border"><input type="text" name="job" disabled="disabled"  value="<%=job_name%>" class="sel"></td>
		</tr>
		<tr>
			<td class="td-header">입사일자</td><td class="border"><input type="text" name="start" disabled="disabled"  value="<%=start%>" class="sel"></td>
		</tr>
		<tr>
			<td class="td-header">퇴사일자</td><td class="border"><input type="text" name="end" disabled="disabled"  value="<%=end%>" class="sel"></td>
		</tr>
		<tr>
			<td colspan="3" style="text-align: right;">

			<% } %>
		
			<button class="closebtn" onclick='window.close();'><i class="fas fa-times-circle"></i>&nbsp;닫기&nbsp;&nbsp;</button>
			</td>
		</tr>
		</table>
	</form>
</body>
</html>
