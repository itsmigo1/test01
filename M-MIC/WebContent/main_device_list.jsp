<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, java.sql.*, javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="shortcut icon" href="favicon.ico">
<link rel="stylesheet" href="css_menu_style.css">
<link rel="stylesheet" href="css_contents.css">
<link rel="stylesheet" href="css_device_table.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
<title>기기 정보</title>
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
	int orga_code = (Integer)session.getAttribute("orga_code");
	String orga_name = (String)session.getAttribute("orga_name");
%>

<!-- SQL 정보 영역 -->
<%
	String url_mysql = "jdbc:mysql://106.10.33.249:3306/mmic_db?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Seoul";
	String id_mysql = "mmic";
	String pw_mysql = "mmic!@21";
	%>

<!-- SQL 호출 영역 -->
<%
String A = "select meeting_id, ifnull(meeting_topic, ' '), meeting_location, ifnull(record_start, ' '), ifnull(record_end, ' ')";
String B = " from t_mic_meeting where orga_code = "+orga_code;
String whereDefault = (A+B);
/*
try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
	Statement stmt_mysql = conn_mysql.createStatement();
	
	ResultSet rs = stmt_mysql.executeQuery(whereDefault);*/
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
		<li><a href='main.jsp'><span><i class="fas fa-file-alt"></i>&nbsp;&nbsp;&nbsp;회의록 조회·생성</span></a></li>
		<li><a href='main_members.jsp'><span><i class="fas fa-users"></i>&nbsp;&nbsp;&nbsp;직원 조회</span></a></li>
		<li><a href='main_members_add.jsp'><span><i class="fas fa-user-plus"></i>&nbsp;&nbsp;&nbsp;직원 등록</span></a></li>
		<li class='active'><a href='main_device_list.jsp'><span><i class="fas fa-laptop"></i>&nbsp;&nbsp;&nbsp;기기 정보</span></a></li>
		<li><a href='main_edit_admin.jsp'><span><i class="fas fa-user-cog"></i>&nbsp;&nbsp;&nbsp;관리자 정보</span></a></li>
		<li><a href='main_request.jsp'><span><i class="fas fa-question-circle"></i>&nbsp;&nbsp;&nbsp;유지·보수 문의</span></a></li>
		<li><a href='logout.jsp'><span><i class="fas fa-sign-out-alt"></i>&nbsp;&nbsp;&nbsp;로그아웃</span></a></li>
	</ul>
</div>


<!-- 본문 부분 -->
<div class='content'>
<table id="device-table">
<tr>
	<th class="no">기기일련번호</th>
	<th class="id">기기 ID</th>
	<th class="cost">구매 단가</th>
	<th class="date">구매일자</th>
</tr>
<tr>
	<td>2019-0701-3360-5487</td>
	<td>mmic-vol1-001</td>
	<td>100,000 원</td>
	<td>2019-07-01</td>
</table>

</div>
</main>

<!-- 하단 푸터부분 -->
<footer> 푸터입니다. </footer>
</body>
</html>