<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="css_login_style.css">
<link rel="shortcut icon" href="favicon.ico">

<meta charset="UTF-8">
<title>M-MIC 관리자 페이지</title>

<script type="text/javascript">
	<%
	if(session!=null) {
		session.invalidate();
	}
	%>
	
function loginclick() {
	
	var id = document.getElementById('id').value;
	var pw = document.getElementById('pw').value;
    
	if(document.form.id.value==""){
		
		document.getElementById('text').innerHTML='아이디를 입력해주세요.';
		document.getElementById('text').style.color='red';
		
	} else if(document.form.pw.value==''){
		
		document.getElementById('text').innerHTML='비밀번호를 입력해주세요.';
		document.getElementById('text').style.color='red';
	
	} else {
		document.form.submit();
	} 
}
</script>
</head>


<body>
<div class="box">
<form action="login_chk_S" method="POST" name="form">
	<table>
		<tr>
			<td><img src="https://i.imgur.com/IUa8fmU.jpg" width=400px></td>
		</tr>
		<tr>
			<td><h2>M-MIC ADMIN PAGE</h2></td>
		</tr>
		<tr>
			<td><input type="text" name="id" id="id" class="loginbox" placeholder="아이디"></td>
		</tr>
		<tr>
			<td><input type="password" name="pw" id="pw" class="loginbox" placeholder="비밀번호" onkeypress="if(event.keyCode == 13){loginclick();}">
			</td>
		</tr>
		<tr>
			<td><font size="2"><span id="text" class="checkarea"></span></font></td>
		</tr>
		<tr>
			<td><input type="button" value="로그인" class="loginbtn" onclick="loginclick();"></td>
		</tr>
	</table>
</form>

</div>
</body>
</html>