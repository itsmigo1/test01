<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, java.sql.*, javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="shortcut icon" href="favicon.ico">
<link rel="stylesheet" href="css_menu_style.css">
<link rel="stylesheet" href="css_contents.css">
<link rel="stylesheet" href="css_meeting_table.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
<title>회의록 조회·생성</title>


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
<!-- 팝업창 모양 영역 -->
<script type="text/javascript">
	var popupX1 = (window.screen.width / 2) - 300;
	var popupY1 = (window.screen.height / 2) - 200;
	var name1 = "회의록 등록하기";
	var option1 = "width=600, height=330, left=" + popupX1 + ", top=" + popupY1;
</script>

<script type="text/javascript">
	var popupX = (window.screen.width / 2) - 400;
	var popupY = (window.screen.height / 2) -300;
	var name = "회의록 조회하기";
	var option = "width=800, height=600, left=" + popupX + ", top=" + popupY;
</script>

<!-- SQL 정보 영역 -->
<%
	
	%>

<!-- SQL 호출 영역 -->
<%
	String A = "select meeting_id, ifnull(meeting_topic, ' '), meeting_location, ifnull(record_start, ' '), ifnull(record_end, ' ')";
	String B = " from t_mic_meeting where orga_code = "+orga_code;
	String whereDefault = (A+B);
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
		Statement stmt_mysql = conn_mysql.createStatement();
		
		ResultSet rs = stmt_mysql.executeQuery(whereDefault);
	%>


</head>

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
	<p>
		<font style="font-size: 14px;">회의 제목 혹은 장소를 클릭하면 회의록을 조회할 수 있습니다.</font>
	</p>

<table class='table-meeting'>
	<tr class='table-header'>
		<td class="th-topic">회의 주제</td>
		<td class="th-location">회의 장소</td>
		<td class="th-start">회의 시작 날짜</td>
		<td class="th-end">회의 종료 날짜</td>
	</tr>
	<%
		while(rs.next()){
	%>
	<tr class='table-content'>
		<td><a href="main_meeting_read.jsp?meeting_id=<%=rs.getString(1)%>" onclick='window.open(this.href, name, option); return false'>
	<%
		String title = rs.getString(2);
		if (title.equals(" ")) {
			title = "제목 없음";
		}
	%>
		<%=title%></a></td>
		<td><a href="main_meeting_read.jsp?meeting_id=<%=rs.getString(1)%>" onclick='window.open(this.href, name, option); return false'>
		<%=rs.getString(3)%></a></td>
		<td><%=rs.getString(4)%></td>
		<td><%=rs.getString(5)%></td>
	</tr>
	<%
		}
	%>
	<tr><td colspan="5" class="td-submit">
	<button onclick='location.href="main_create.jsp";' class="btn"><i class="fas fa-pen-fancy"></i>&nbsp;&nbsp;&nbsp;회의 생성하기</button>
	</td></tr>
</table>
	<%
		conn_mysql.close();

	} catch (SQLException e) {
		System.out.println("회의록 조회실패 : " + e.getMessage());
		e.printStackTrace();
	}
	%>
</div>
</main>

<!-- 하단 푸터부분 -->
<footer> 푸터입니다. </footer>
</body>
</html>
