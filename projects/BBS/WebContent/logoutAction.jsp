<%--실질적으로 사용자의 로그인 시도를 처리하는 페이지 이다. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		session.invalidate();	// 현재 이 페이지에 접속한 회원이 세션을 뺴았기도록 만들어서 로그아웃 시켜준다.
	%>
	<script>
		location.href = 'main.jsp';
	</script>
</body>
</html>