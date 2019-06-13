<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, java.sql.*, javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css_request_form.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
<title>AS 문의</title>
</head>
<%
request.setCharacterEncoding("utf-8");
SimpleDateFormat format = new SimpleDateFormat ("yyMMddHHmmss");
Timestamp timestamp = new Timestamp(System.currentTimeMillis());


int orga_code = (Integer)session.getAttribute("orga_code");
String orga_name = (String)session.getAttribute("orga_name");
String as_code = request.getParameter("as_code");

if(as_code==null||as_code.equals("")){
	as_code = format.format(timestamp);
}
%>
<body>
<p>AS 신청 접수 후 처리까지는 약 3일 정도 소요됩니다.<br>
특정 제품에 이상이 있을 경우, 일련번호를 함께 적어주시면 신속하게 처리할 수 있습니다.
</p>
<form action="request_as_S" method="post">
<input type="hidden" name="as_code" value="<%=as_code %>">
<table>
<tr>
	<th>제목</th>
	<td><input type="text" name="title" class="sel" maxlength="50"
	 value="제품 AS 문의"></td>
</tr>
<tr>
<th>내용</th>
<td><textarea name="content" class="sel2">
* 신청 기업 : <%=orga_name %>
* 제품 일련번호 : 
* 요청 내용 : 
</textarea></td>
</tr>
<tr>
	<td colspan="2" class="td-btn">
	<button class="btn" type="submit"><i class="fas fa-pencil-alt"></i>&nbsp;&nbsp;등록하기</button>
	</td>
</tr>
</table>
</form>
</body>
</html>