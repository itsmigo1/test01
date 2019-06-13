<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="shortcut icon" href="favicon.ico">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
<link rel="stylesheet" href="css_menu_style.css">
<link rel="stylesheet" href="css_contents.css">
<link rel="stylesheet" href="css_members_table.css">

<title>직원 조회</title>

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
%>

<!-- SQL 정보 영역 -->
<%
	String url_mysql = "jdbc:mysql://106.10.33.249:3306/mmic_db?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Seoul";
	String id_mysql = "mmic";
	String pw_mysql = "mmic!@21";
	%>
	
<!-- 팝업창 모양 영역 -->
<script type="text/javascript">

	var popupX = (window.screen.width/2) - 300;
	var popupY = (window.screen.height/2) - 200;
	var name = "직원 정보 수정";
	var option = "width=600, height=330, left="+popupX+", top="+popupY;
	
</script>

<!-- SQL 호출 영역 -->
<%
String A = "select ifnull(usr.picture_code, 'NO IMAGE'), usr.user_id, usr.user_name, dep.department_name,";
String AA = " job.job_description, usr.effective_start_date, ifnull(usr.effective_end_date, '재직중')";
String B = " from t_usr_user usr, t_usr_department dep, t_usr_job job";
String C = " where usr.job_code = job.job_code";
String D = " and usr.department_code = dep.department_code";
String E = " and usr.orga_code = ";
String F = " order by usr.effective_end_date, usr.job_code, usr.user_name";
String whereDefault = (A+AA+B+C+D+E+orga_code+F);

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
	Statement stmt_mysql = conn_mysql.createStatement();
	
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
		<li class='active'><a href='main_members.jsp'><span><i class="fas fa-users"></i>&nbsp;&nbsp;&nbsp;직원 조회</span></a></li>
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
		<font style="font-size: 14px;">사원 이름을 클릭하면 정보를 수정할 수 있습니다.</font>
	</p>
	<table class='table-member'>
		<tr class='table-header'>
			<!-- 
 			<td style="width: 10px;">선택</td>
 			-->
			<td>프로필 이미지</td>
			<td class="td-header">사원명</td>
			<td class="td-header">사원 ID</td>
			<td class="td-header">부서</td>
			<td class="td-header">직급</td>
			<td>입사일자</td>
			<td>퇴사여부</td>
		</tr>
		<%
			while(rs.next()){
		%>
		<tr class='table-content'>
		
			<td class='table-content-img'>
				<a href='main_edit_user.jsp?id=<%=rs.getString(2)%>' onclick='window.open(this.href, name, option); return false'>
				<%
					if (rs.getString(1).equals("NO IMAGE")) {
				%> <font style="color: #1f7ca2;"><%=rs.getString(1)%></font>
				<%
				 	} else {
				%> <img id="photoImage" src="picture_load.jsp?picture=<%=rs.getString(1)%>"> 
				<%
				 	}
				%>
				</a>
			</td>
			<td style="width:15%;">
			<a href='main_edit_user.jsp?id=<%=rs.getString(2)%>' onclick='window.open(this.href, name, option); return false'><%=rs.getString(3) %></a>
			</td>
			<td><%=rs.getString(2)%></td>
			<td><%=rs.getString(4)%></td>
			<td><%=rs.getString(5)%></td>
			<td><%=rs.getString(6)%></td>
			<td>
				<%
					String chk = rs.getString(7);
					if (chk.equals("재직중")) {
						%> <%=chk%> <%
				 	} else {
					 %> <font style="color: red;"><%=chk%>&nbsp;&nbsp;퇴사</font> <%
				 	}
					 %>
			</td>
		</tr>
		<%
			} /* while문 종료 */
		%>
	</table>
	<%
		conn_mysql.close();

		} catch (SQLException e) {
			System.out.println("SQL Exception : " + e.getMessage());
			e.printStackTrace();
		}
	%>
</div>

</main>
	
<!-- 하단 푸터부분 -->
<footer>
푸터입니다. 
</footer>
</body>
</html>