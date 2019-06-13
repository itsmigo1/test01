<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="css_login_style.css">
<meta charset="UTF-8">
<title>비밀번호를 변경해주세요!</title>

<script type="text/javascript">

<%
	request.setCharacterEncoding("utf-8");
%>

function check(){
	
	var pw = <%=session.getAttribute("sessionPW")%>
	var enterpw = document.getElementById('enterpw').value;
	var newpw1 = document.getElementById('newpw1').value;
    var newpw2 = document.getElementById('newpw2').value;
    
	if(pw==""){
		
		document.getElementById('same').innerHTML='현재 비밀번호를 입력해주세요.';
		document.getElementById('same').style.color='black';
		
	}else if(newpw1==""){
		
		document.getElementById('same').innerHTML='변경할 비밀번호를 입력해주세요.';
		document.getElementById('same').style.color='black';
		
	}else if(newpw2==""){
		
		document.getElementById('same').innerHTML='비밀번호 확인을 위하여 한번 더 입력해주세요.';
		document.getElementById('same').style.color='black';
		
	}else if (newpw1.length > 20) {
		
	    	document.getElementById('same').innerHTML='비밀번호는 20자리 이하만 이용 가능합니다.';
	        document.getElementById('same').style.color='red';
	        
	}else if (newpw1=="1234") {
		
			document.getElementById('same').innerHTML='초기비밀번호는 사용하실 수 없습니다.';
	        document.getElementById('same').style.color='red';
	        
    }else if(newpw1!=newpw2||pw!=enterpw) {
    	
	    	document.getElementById('same').innerHTML='비밀번호가 일치하지 않습니다.';
	        document.getElementById('same').style.color='red';
			
    }else {
    	
    		document.form.submit();
    }
}

</script>

</head>
<body>

<div class="box">
<form action="login_changePW_S" method="POST" name="form">
	<table>
		<tr>
			<td><center><img src="https://i.imgur.com/IUa8fmU.jpg" width=200px></center></td>
		</tr>
		<tr>
			<td><h3><center>비밀번호를 변경해주세요!</center></h3></td>
		</tr>
		<tr>
			<td><input type="password" name="enterpw" id="enterpw" class="loginbox" placeholder="현재 비밀번호"></td>
		</tr>
		<tr>
			<td><input type="password" name="newpw1" id="newpw1" class="loginbox" placeholder="변경할 비밀번호"></td>
		</tr>
		<tr>
			<td><input type="password" name="newpw2" id="newpw2" class="loginbox" placeholder="변경할 비밀번호 확인" onkeypress="if(event.keyCode == 13){check();}"></td>
		</tr>
		<tr>
			<td><font size="2"><span id="same" class="checkarea"></span></font></td>
		</tr>
		<tr>
			<td><input type="button" value="변경하기" class="loginbtn" onclick="check()"></td>
		</tr>
	</table>
</form>

</div>

</body>
</html>