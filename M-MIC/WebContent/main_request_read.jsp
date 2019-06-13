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
<link rel="stylesheet" href="css_request_read_table.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
<title>AS 요청 내역 조회</title>
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
	request.setCharacterEncoding("utf-8");
	
	int orga_code = (Integer)session.getAttribute("orga_code");
	String orga_name = (String)session.getAttribute("orga_name");
	
	String as_code = request.getParameter("code");
%>
<!-- 팝업창 스크립트 영역 -->
<script type="text/javascript">
	var popupX = (window.screen.width/2) - 400;
	var popupY = (window.screen.height/2) - 300;
	var option = "width=600, height=600, left="+popupX+", top="+popupY;
	
	function reply() {
		window.open("main_request_form.jsp?as_code=<%=as_code %>", "유지·보수 신청하기", option);
		return false;
	}
</script>
<!-- SQL 정보 영역 -->
<%

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
		<li><a href='main_device_list.jsp'><span><i class="fas fa-laptop"></i>&nbsp;&nbsp;&nbsp;기기 정보</span></a></li>
		<li><a href='main_edit_admin.jsp'><span><i class="fas fa-user-cog"></i>&nbsp;&nbsp;&nbsp;관리자 정보</span></a></li>
		<li class='active'><a href='main_request.jsp'><span><i class="fas fa-question-circle"></i>&nbsp;&nbsp;&nbsp;유지·보수 문의</span></a></li>
		<li><a href='logout.jsp'><span><i class="fas fa-sign-out-alt"></i>&nbsp;&nbsp;&nbsp;로그아웃</span></a></li>
	</ul>
</div>

<!-- 본문 부분 -->
<div class='content'>
<table class='as-table'>
<tr><td colspan="2" style="text-align:left;">
	<button onclick="history.back();" class="backbtn"><i class="fas fa-arrow-alt-circle-left"></i>&nbsp;&nbsp;돌아가기</button>
</td></tr>
<tr><td class="td-null" colspan="2"></td></tr>

<!-- SQL 호출 영역 -->
<%
// 질문+답변 모두 있는 경우
String A = "SELECT que.question_title, adm.admin_name, que.question_date, que.question_content";
String B = ", ifnull(mas.mason_name, 'null'), ans.answer_start_date, ans.answer_content, ifnull(ans.answer_end_date, 'no')";
String C = " FROM t_usr_as_question que, t_usr_as_answer ans, t_usr_admin adm, t_mason_admin mas";
String D = " WHERE ans.question_id = que.question_id AND que.admin_id = adm.admin_id";
String E = " AND mas.mason_id = ans.mason_id AND que.as_code="+as_code;

String whereDefault = (A+B+C+D+E);

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
	Statement stmt_mysql = conn_mysql.createStatement();
	
	ResultSet rs = stmt_mysql.executeQuery(whereDefault);
	
	int i = 1;
	String title = "";
	String writer = "";
	String date = "";
	String content_q = "";
	String content_a = "";
	String end = "";
	
	if (rs.next()){
		// 질문+답변 모두 있는 경우
		do {
			// 2번째 바퀴부터 질문 중복일 때 답변만 출력
			if (i>1 && title.equals(rs.getString(1)) && writer.equals(rs.getString(2))
					&& date.equals(rs.getString(3)) && content_q.equals(rs.getString(4))) {
				%>
				<tr><th class="th-a">답변자</th><td class="td-a"><%=rs.getString(5) %></td></tr>
				<tr><th class="th-a">답변 작성 일자</th><td class="td-a"><%=rs.getString(6) %></td></tr>
				<tr><th class="th-a">답변 내용</th><td class="td-a"><%=rs.getString(7)%></td></tr>
				<tr><td class="td-null" colspan="2"></td></tr>
				<%
			
			// 질문만 있을 때
			} else if(rs.getString(5).equals("null")) {
				%>
				<tr><th class="th-q">제목</th><td class="td-q"><%=rs.getString(1) %></td></tr>
				<tr><th class="th-q">작성자</th><td class="td-q"><%=rs.getString(2) %></td></tr>
				<tr><th class="th-q">작성 일자</th><td class="td-q"><%=rs.getString(3) %></td></tr>
				<tr><th class="th-q">요청 내용</th><td class="td-q"><%=rs.getString(4) %></td></tr>
				<tr><td class="td-null" colspan="2"></td></tr>
				<%
			// 질문 중복 아니지만 답변 있을 때 같이 출력
			} else { 
				%>
				<tr><th class="th-q">제목</th><td class="td-q"><%=rs.getString(1) %></td></tr>
				<tr><th class="th-q">작성자</th><td class="td-q"><%=rs.getString(2) %></td></tr>
				<tr><th class="th-q">작성 일자</th><td class="td-q"><%=rs.getString(3) %></td></tr>
				<tr><th class="th-q">요청 내용</th><td class="td-q"><%=rs.getString(4) %></td></tr>
				<tr><td class="td-null" colspan="2"></td></tr>
				<%
				
				%>
				<tr><th class="th-a">답변자</th><td class="td-a"><%=rs.getString(5) %></td></tr>
				<tr><th class="th-a">답변 작성 일자</th><td class="td-a"><%=rs.getString(6) %></td></tr>
				<tr><th class="th-a">답변 내용</th><td class="td-a"><%=rs.getString(7)%></td></tr>
				<tr><td class="td-null" colspan="2"></td></tr>
				<%
				
			}
			title = rs.getString(1);
			writer = rs.getString(2);
			date = rs.getString(3);
			content_q = rs.getString(4);
			end = rs.getString(8);
			i++;
		} while(rs.next());
		conn_mysql.close();
		
		// end date 없을 경우
		if (end.equals("no")) {%>
		<tr><td colspan="2" style="text-align:right;">
		<button type="button" class="re-btn" onclick='reply();'><i class="fas fa-reply"></i>&nbsp;&nbsp;이어서 질문하기</button>
		</td></tr>
		<%}
		
	} else {
		// 질문만 있는 경우
		C = " FROM t_usr_as_question que";
		D = " inner JOIN t_usr_admin adm ON adm.admin_id = que.admin_id";
		E = " WHERE que.as_code="+as_code;
		whereDefault = A+C+D+E;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
			stmt_mysql = conn_mysql.createStatement();
			rs = stmt_mysql.executeQuery(whereDefault);
			
			while (rs.next()) {%>
				<tr><th class="th-q">제목</th><td class="td-q"><%=rs.getString(1) %></td></tr>
				<tr><th class="th-q">작성자</th><td class="td-q"><%=rs.getString(2) %></td></tr>
				<tr><th class="th-q">작성 일자</th><td class="td-q"><%=rs.getString(3) %></td></tr>
				<tr><th class="th-q">요청 내용</th><td class="td-q"><%=rs.getString(4) %></td></tr>
				<tr><td class="td-null" colspan="2"></td></tr>
				<tr><td colspan="2" style="text-align:right;">
				<button type="button" class="re-btn" onclick='reply();'><i class="fas fa-reply"></i>&nbsp;&nbsp;이어서 질문하기</button>
				</td></tr>
			<%}
		} catch (SQLException e) {
			System.out.println("질문 조회실패 : " + e.getMessage());
			e.printStackTrace();
		}
	}
	
} catch (SQLException e) {
	System.out.println("질문+답변 조회실패 : " + e.getMessage());
	e.printStackTrace();
}
%>
</table>
</div>
</main>
<!-- 하단 푸터부분 -->
<footer> 푸터입니다. </footer>
</body>
</html>
