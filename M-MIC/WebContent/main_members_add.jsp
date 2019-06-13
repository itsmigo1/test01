<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*, java.text.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="shortcut icon" href="favicon.ico">
<link rel="stylesheet" href="css_menu_style.css">
<link rel="stylesheet" href="css_members_add.css">
<link rel="stylesheet" href="css_contents.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
<title>직원 등록</title>
</head>

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
String orga_name = (String)session.getAttribute("orga_name");

SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd"); 
Timestamp timestamp = new Timestamp(System.currentTimeMillis());
String now = format.format(timestamp);
%>

<!-- submit 전 유효성 검사 -->
<script type="text/javascript">
function submit() {
	if (document.form.name.value=="") {
		
		alert('이름을 입력해주세요.');
		document.form.name.focus();
		
	} else if (document.form.id.value=="") {
		
		alert('아이디를 입력해주세요.');
		document.form.id.focus();
		
	} else {
		
		document.form.submit();
		
	}
}
</script>

<!-- SQL 정보 영역 -->
<%

%>

<!-- SQL 호출 영역 -->
<%
try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
	Statement stmt_mysql = conn_mysql.createStatement();
	String whereDefault = "SELECT * FROM t_usr_department;";
	ResultSet rs = stmt_mysql.executeQuery(whereDefault);
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
		<li class='active'><a href='main_members_add.jsp'><span><i class="fas fa-user-plus"></i>&nbsp;&nbsp;&nbsp;직원 등록</span></a></li>
		<li><a href='main_device_list.jsp'><span><i class="fas fa-laptop"></i>&nbsp;&nbsp;&nbsp;기기 정보</span></a></li>
		<li><a href='main_edit_admin.jsp'><span><i class="fas fa-user-cog"></i>&nbsp;&nbsp;&nbsp;관리자 정보</span></a></li>
		<li><a href='main_request.jsp'><span><i class="fas fa-question-circle"></i>&nbsp;&nbsp;&nbsp;유지·보수 문의</span></a></li>
		<li><a href='logout.jsp'><span><i class="fas fa-sign-out-alt"></i>&nbsp;&nbsp;&nbsp;로그아웃</span></a></li>
	</ul>
</div>

<!-- 본문 부분 -->
<div class='content'>
	<form action="member_add_S" method="post" enctype="multipart/form-data" name="form">
		<table class="table-member">
		
			<tr>
				<td rowspan="5" class="td-img">
				<input type="file" name="file" accept="image/*" id="file">
				</td>

				<td class="td-header">이름</td><td class="td-content"><input type="text" name="name" class="sel" id="name"></td>
			</tr>
			<tr>
				<td class="td-header">ID</td><td class="td-content"><input type="text" name="id" class="sel" id="id"><br>
				<font>비밀번호 초기값은 1234 입니다.</font>
				</td>
			</tr>
			<tr>
				<td class="td-header">부서</td>
				<td class="td-content">
				<select name='dep' class="sel">
				<%
					while (rs.next()) {
				%>
					<option value='<%=rs.getString(1) %>'><%=rs.getString(2) %></option>
				<%
				}
				%>
				</select>
				</td>
				<%
				conn_mysql.close();

				} catch (SQLException e) {
					System.out.println("SQL DEPARTMENT 부분 Exception : " + e.getMessage());
					e.printStackTrace();
				}
				%>
			</tr>
			<tr>
				<td class="td-header">직급</td>
				<td class="td-content">
				<select name='job' class="sel">
				<%
				try {
					Class.forName("com.mysql.cj.jdbc.Driver");
					Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
					Statement stmt_mysql = conn_mysql.createStatement();
					String whereDefault = "SELECT * FROM t_usr_job;";
					ResultSet rs = stmt_mysql.executeQuery(whereDefault);
			
					while (rs.next()) {
						%>
							<option value='<%=rs.getString(1) %>'><%=rs.getString(2) %></option>
						<%
						}
						%>
						</select>
						</td>
						<%
						conn_mysql.close();

						} catch (SQLException e) {
							System.out.println("SQL JOB 부분 Exception : " + e.getMessage());
							e.printStackTrace();
						}
				%>
			</tr>
			<tr>
				<td class="td-header">입사일자</td>
				<td class="td-content">
					<input type="text" class="sel" name="year" value="<%=now%>"><br>
					<font>YYYY-MM-DD 형식으로 넣어주세요.</font>
				</td>
			</tr>
			<tr>
				<td colspan="3" class="td-submit">
				<button onclick="submit();" class="btn"><i class="fas fa-plus-circle"></i>&nbsp;&nbsp;추가하기</button>
				</td>
			</tr>
		</table>
		</form>
	</div>
</main>
<footer>
	푸터입니다.
</footer>
</body>
</html>
