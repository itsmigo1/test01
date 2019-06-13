<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.io.*, java.util.*, java.text.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="shortcut icon" href="favicon.ico">
<link rel="stylesheet" href="css_menu_style.css">
<link rel="stylesheet" href="css_admin.css">
<link rel="stylesheet" href="css_contents.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
<title>관리자 정보</title>
</head>
<script type="text/javascript">
	function pw() {
		location.href="login_changePW.jsp"
	}
</script>

<!-- 로그인 했는지 확인 -->
<%
if(session.getAttribute("sessionID")==null){
%>
	<script>
	alert('세션이 만료되었습니다. 로그인 페이지로 돌아갑니다.');
	location.href="index.jsp";
	</script>
<%
	return;
}
%>

<!-- 기타 정보 영역 -->
<%
request.setCharacterEncoding("utf-8");

String admin_id = (String)session.getAttribute("sessionID");
String name = "";
String phone = "";
String mail = "";
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
String A = "SELECT admin_name, admin_phone_number, admin_email"; // img, name
String B = " FROM t_usr_admin";
String D = " WHERE admin_id = '" + admin_id + "'";
String whereDefault = (A+B+D);

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
	Statement stmt_mysql = conn_mysql.createStatement();

	ResultSet rs = stmt_mysql.executeQuery(whereDefault);

	while (rs.next()) {
		name = rs.getString(1);
		phone = rs.getString(2);
		mail = rs.getString(3);
	}
	
	conn_mysql.close();

} catch (SQLException e) {
	System.out.println("SQL 관리자 정보수정 Exception : " + e.getMessage());
	e.printStackTrace();
}
%>

<!-- 회사정보 팝업 -->
<script type="text/javascript">
	var popupX = (window.screen.width/2) - 300;
	var popupY = (window.screen.height/2) - 200;
	var name = "회사 정보";
	var option = "width=600, height=330, left="+popupX+", top="+popupY;
</script>

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
		<li><a href='main_device_list.jsp'><span><i class="fas fa-laptop"></i>&nbsp;&nbsp;&nbsp;기기 정보</span></a></li>
		<li class='active'><a href='main_edit_admin.jsp'><span><i class="fas fa-user-cog"></i>&nbsp;&nbsp;&nbsp;관리자 정보</span></a></li>
		<li><a href='main_request.jsp'><span><i class="fas fa-question-circle"></i>&nbsp;&nbsp;&nbsp;유지·보수 문의</span></a></li>
		<li><a href='logout.jsp'><span><i class="fas fa-sign-out-alt"></i>&nbsp;&nbsp;&nbsp;로그아웃</span></a></li>
	</ul>
</div>

<!-- 본문 부분 -->
<div class='content'>
<form action="edit_admin_S" method="post" name="form" id="form">
<table class="table-member">
	<tr>
		<td class="td-header">회사정보</td><td class="td-content">
		<button onclick="window.open('main_orgainfo.jsp', name, option); return false;" class="td-btn">회사 정보 보기</button>
		</td>
	</tr>
	<tr>
		<td class="td-header">ADMIN ID</td><td class="td-content"><input type="text" name="id" class="sel" value="<%=admin_id%>"></td>
	</tr>
	<tr>
		<td class="td-header">이름</td><td class="td-content"><input type="text" name="name" class="sel" value="<%=name%>"></td>
	</tr>
	<tr>
		<td class="td-header">연락처</td><td class="td-content"><input type="text" name="phone" class="sel" value="<%=phone%>"></td>
	</tr>
	<tr>
		<td class="td-header">이메일</td><td class="td-content"><input type="text" name="mail" class="sel" value="<%=mail%>"></td>
	</tr>
	<tr>
		<td class="td-header">비밀번호 변경</td><td class="td-content">
		<button onclick="pw(); return false;" class="td-btn">비밀번호를 변경하려면 누르세요.<br>누르면 페이지를 이동합니다.</button>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="td-submit">
		<button type="submit" class="btn"><i class="fas fa-check-circle"></i>&nbsp;&nbsp;수정하기</button>
		</td>
	</tr>
	</table>
	</form>
</div>
</main>

<!-- 하단 푸터부분 -->
<footer>
	푸터입니다.
</footer>
</body>
</html>