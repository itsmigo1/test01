<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, java.sql.*, javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회의록 조회</title>
<link rel="stylesheet" href="css_meeting_read.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
</head>
<script>
	/*
	 * path : 전송 URL
	 * params : 전송 데이터 {'q':'a','s':'b','c':'d'...}으로 묶어서 배열 입력
	 * method : 전송 방식(생략가능)
	 */
	function download() {
		var meeting_id = document.getElementById('meeting_id').innerText;
		var topic = document.getElementById('topic').innerText;
		var location = document.getElementById('location').innerText;
		var start = document.getElementById('start').innerText;
		var end = document.getElementById('end').innerText;
		var attend = document.getElementById('attend').innerText;
		var txt = document.getElementById('export').innerText;
		
		var path = "meeting_download_S";
		var params = {'meeting_id':meeting_id, 'topic':topic, 'location':location, 'start':start, 'end':end, 'attend':attend, 'txt':txt};
	    var method = method || "post"; // Set method to post by default, if not specified.
	    // The rest of this code assumes you are not using a library.
	    // It can be made less wordy if you use one.
	    var form = document.createElement("form");
	    form.setAttribute("method", method);
	    form.setAttribute("action", path);
	    for(var key in params) {
	        var hiddenField = document.createElement("input");
	        hiddenField.setAttribute("type", "hidden");
	        hiddenField.setAttribute("name", key);
	        hiddenField.setAttribute("value", params[key]);
	        form.appendChild(hiddenField);
	    }
	    document.body.appendChild(form);
	    form.submit();
	}
</script>
<%
	request.setCharacterEncoding("utf-8");

	String meeting_id = request.getParameter("meeting_id");
	
	String url_mysql = "jdbc:mysql://106.10.33.249:3306/mmic_db?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Seoul";
	String id_mysql = "mmic";
	String pw_mysql = "mmic!@21";
	
%>
<body>
<table>
<!-- 버튼영역 -->
	<tr>
		<td class="td-btn">
		<button onclick='window.close();' class="closebtn"><i class="fas fa-times-circle"></i>&nbsp;&nbsp;&nbsp;닫기</button>
		</td>
		<td class="td-close-btn">
		<button onclick='download();' class="exportbtn">&nbsp;&nbsp;<i class="fas fa-share"></i>&nbsp;&nbsp;&nbsp;텍스트파일로 내보내기&nbsp;&nbsp;</button>
		</td>
	</tr>
	
<!-- meeting 영역 -->

	<% try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
		Statement stmt_mysql = conn_mysql.createStatement();
		String whereDefault = "SELECT * FROM t_mic_meeting where meeting_id='"+meeting_id+"'";
		ResultSet rs = stmt_mysql.executeQuery(whereDefault);

		while (rs.next()) {
		%>
	<tr>
		<th>회의 코드</th>
		<td id="meeting_id"><%=meeting_id%></td>
	</tr>
	<tr>
		<th>회의 주제</th>
		<td id="topic"><%=rs.getString(2)%></td>
	</tr>
	<tr>
		<th>회의 장소</th>
		<td id="location"><%=rs.getString(3)%></td>
	</tr>
	<tr>
		<th>회의 시작 시각</th>
		<td id="start"><%=rs.getString(4)%></td>
	</tr>
	<tr>
		<th>회의 종료 시각</th>
		<td id="end"><%=rs.getString(5)%></td>
	</tr>
			<%
		}
		conn_mysql.close();
		
	} catch (Exception e) {
		System.out.println("meeting load 실패 : " + e.getMessage());
		e.printStackTrace();
	} %>
	
<!-- attend 영역 -->
	<tr>
		<th>참여자</th>
		<td id="attend">
		<% try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
			Statement stmt_mysql = conn_mysql.createStatement();
			String A = "select usr.user_name, auth.auth_name, atd.meeting_id";
			String B = " from t_usr_user as usr, t_auth_authorization as auth, t_mic_attend as atd";
			String C = " where usr.user_id = atd.user_id and auth.auth_code = atd.auth_code";
			String D = " and meeting_id = '"+meeting_id+"' group by atd.user_id";
			ResultSet rs = stmt_mysql.executeQuery(A+B+C+D);
			
			while (rs.next()) {%>
				· <%=rs.getString(1)%>
				(<%=rs.getString(2) %>)<br>
				<%
			}
			conn_mysql.close();
		} catch (Exception e) {
			System.out.println("attend load 실패 : " + e.getMessage());
			e.printStackTrace();
		} %>
		</td>
	</tr>
<!-- 회의록 text 영역 -->
	<tr>
		<th colspan="2" class="th-text">회의록</th>
	</tr>
	<tr>
		<td colspan="2" id="export">
		<%
		// 출력형식 :·유저이름 (타임스탬프): 텍스트
		%>
		<% try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
			Statement stmt_mysql = conn_mysql.createStatement();
			String A = "select usr.user_name, wav.wave_start, txt.text_record";
			String B = " from t_usr_user as usr, t_mic_record_text as txt, t_mic_record_wave as wav, t_mic_attend as atd";
			String C = " where usr.user_id = atd.user_id and txt.wave_id = wav.wave_id and wav.attend_id = atd.attend_id";
			String D = " and atd.meeting_id = '"+meeting_id+"' order by wav.wave_id";
			ResultSet rs = stmt_mysql.executeQuery(A+B+C+D);
			
			while (rs.next()) {%>
				[<%=rs.getString(1) %>] 
				[<%=rs.getString(2) %>] 
				<%=rs.getString(3) %><br><br>
				<%
			}
			conn_mysql.close();
		} catch (Exception e) {
			System.out.println("attend load 실패 : " + e.getMessage());
			e.printStackTrace();
		} %>
		</td>
	</tr>

<!-- 버튼영역 -->
	<tr>
		<td class="td-btn">
		<button onclick='window.close();' class="closebtn"><i class="fas fa-times-circle"></i>&nbsp;&nbsp;&nbsp;닫기</button>
		</td>
		<td class="td-close-btn">
		<button onclick='download();' class="exportbtn">&nbsp;&nbsp;<i class="fas fa-share"></i>&nbsp;&nbsp;&nbsp;텍스트파일로 내보내기&nbsp;&nbsp;</button>
		</td>
	</tr>
</table>
</body>
</html>