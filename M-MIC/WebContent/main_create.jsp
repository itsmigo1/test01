<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, java.sql.*, javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회의 생성하기</title>
<link rel="shortcut icon" href="favicon.ico">
<link rel="stylesheet" href="css_menu_style.css">
<link rel="stylesheet" href="css_contents.css">
<link rel="stylesheet" href="css_create.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
</head>
<!-- 로그인 했는지 확인 -->
<%
if(session.getAttribute("sessionID")==null){
%>
<script>
	alert('세션이 만료되었습니다. 로그인 페이지로 돌아갑니다.');
	location.href = "index.jsp";
</script>
<%
	return;
	}
%>

<%
SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss"); 
Timestamp timestamp = new Timestamp(System.currentTimeMillis()); //timestamp
String now = format.format(timestamp);

int orga_code = (Integer)session.getAttribute("orga_code");
String orga_name = (String)session.getAttribute("orga_name");
int count = 0;

%>

<!-- SQL 정보 영역 -->
<%
	String url_mysql = "jdbc:mysql://106.10.33.249:3306/mmic_db?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Seoul";
	String id_mysql = "mmic";
	String pw_mysql = "mmic!@21";
	%>

<!-- SQL 직원 수 호출 영역 -->
<%
try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
	Statement stmt_mysql = conn_mysql.createStatement();
	String whereDefault = "select count(*) from t_usr_user where orga_code="+orga_code;
	
	ResultSet rs = stmt_mysql.executeQuery(whereDefault);
	
	if (rs.next()) {
		count = rs.getInt(1);
	}
	
	conn_mysql.close();
} catch (Exception e) {
	System.out.println("SQL 직원수 카운트 Exception : " + e.getMessage());
	e.printStackTrace();
}
%>

<body>
<main class="container-fluid">

<!-- 상단 로고부분 -->
<table id="logotable">
	<tr><td rowspan="2" class="logo"><img src="https://i.imgur.com/Ozg7Neh.jpg" width="80px"></td>
	<td></td>
	<td></td>
	</tr>
	<tr>
	<td class="letter"><img src="https://i.imgur.com/4wmSEvb.jpg" width="280px"></td>
	<td class="organame">· 접속 기업 : <%=orga_name %></td>
	</tr>
</table>

<!-- 상단 메뉴부분 -->
<div id='cssmenu' align="center">
	<ul>
		<li class='active'><a href='main.jsp'><span><i class="fas fa-file-alt"></i>&nbsp;&nbsp;&nbsp;회의록 조회·생성</span></a></li>
		<li><a href='main_members.jsp'><span><i class="fas fa-users"></i>&nbsp;&nbsp;&nbsp;직원 조회</span></a></li>
		<li><a href='main_members_add.jsp'><span><i class="fas fa-user-plus"></i>&nbsp;&nbsp;&nbsp;직원 등록</span></a></li>
		<li><a href='main_device_list.jsp'><span><i class="fas fa-laptop"></i>&nbsp;&nbsp;&nbsp;기기 정보</span></a></li>
		<li><a href='main_edit_admin.jsp'><span><i class="fas fa-user-cog"></i>&nbsp;&nbsp;&nbsp;관리자 정보</span></a></li>
		<li><a href='main_request.jsp'><span><i class="fas fa-question-circle"></i>&nbsp;&nbsp;&nbsp;유지·보수 문의</span></a></li>
		<li><a href='logout.jsp'><span><i class="fas fa-sign-out-alt"></i>&nbsp;&nbsp;&nbsp;로그아웃</span></a></li>
	</ul>
</div>


<!-- 본문 부분 -->
<div class='content'>
<div class='div-backbtn'>
	<button onclick="history.back();" class="backbtn"><i class="fas fa-arrow-alt-circle-left"></i>&nbsp;&nbsp;돌아가기</button>
</div>
	<form action="meeting_create_S" method="post" name="form" id="form">
		<table class="table">
			<tr>
				<td class="td-header">회의 장소 :</td>
				<td class="border"><input type="text" id="location" name="location" class="sel"></td>
			</tr>
			<tr>
				<td class="td-header">회의 주제 :</td>
				<td class="border"><input type="text" id="topic" name="topic" class="sel"></td>
			</tr>
<!-- SQL 호출 영역 -->

<% try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
		Statement stmt_mysql = conn_mysql.createStatement();
		
		
		String A = "select usr.user_id, dep.department_name, job.job_description, usr.user_name from t_usr_user usr, t_usr_job job, t_usr_department dep";
		String B = " where usr.job_code = job.job_code and usr.department_code = dep.department_code";
		String C = " and orga_code ="+orga_code;
		
		ResultSet rs = stmt_mysql.executeQuery(A+B+C);
	%>
			<tr>
				<td class="td-header">회의 참여자 :</td>
				<td class="border">
				<table>
				<%
				while (rs.next()){
					%>
				<tr>
				<td class="chkbox"><input type="checkbox" name="attendee" value="<%=rs.getString(1) %>"></td>
				<td class="chkbox"><%=rs.getString(2) %></td>
				<td class="chkbox">|&nbsp;<%=rs.getString(3) %></td>
				<td class="chkbox">|&nbsp;<%=rs.getString(4) %></td>
				</tr>
				<% }
				%></table><%
				
				conn_mysql.close();
	} catch (Exception e) {
		
	}
				%>
				</td>
			</tr>
			<tr>
				<td class="td-header">회의 생성 날짜 : <br>
				</td>
				<td class="border">
				<input type="text" name="date" value="<%=now %>" class="sel" readonly="readonly" onclick="alert('생성날짜는 변경할 수 없습니다.');return false;">
				</td>
			</tr>
			<tr>
				<td colspan="2" class="border-btn">
				<button class="closebtn" type="submit"><i class="fas fa-calendar-check"></i>&nbsp;&nbsp;&nbsp;생성하기</button></td>
			</tr>
		</table>
	</form>
</div>
</main>
<!-- 하단 푸터부분 -->
<footer> 푸터입니다. </footer>
</body>
</html>