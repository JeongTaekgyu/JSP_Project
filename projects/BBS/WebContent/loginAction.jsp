<%--실질적으로 사용자의 로그인 시도를 처리하는 페이지 이다. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>	<%--UserDAO 클래스를 가져온다. --%>
<%@ page import="java.io.PrintWriter" %>	<%--자바스크립트 문장을 작성하기 위해 라이브러리를 불러온다. --%>
<% request.setCharacterEncoding("UTF-8"); %><%--건너오는 모든 데이터를 UTF-8로 받을 수 있게 한다. --%>
<jsp:useBean id="user" class="user.User" scope="page" /> <%--현재 페이지에서만 Bean이 사용될 수 있도록 한다. --%>
<jsp:setProperty name="user" property="userID" />	<%--login.jsp 페이지에서 넘겨준 userID를 받는다  --%>
<jsp:setProperty name="user" property="userPassword" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null)	// 세션이 존재하는 회원들은
		{
			userID = (String) session.getAttribute("userID");// userID에 해당 세션 값을 넣어 준다.
			// userID라는 변수가 자신에게 할당된 세션ID를 담을 수 있도록한다.
		}	
		if(userID != null){	// 이미 로그인 되있는 경우  로그인 페이지에 접속할 수 없도록 한다?
			PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
			script.println("<script>");
			script.println("alert('이미 로그인 되어 있습니다.')");
			script.println("location.href = 'main.jsp'");	// 이전의 페이지로 돌려보낸다.
			script.println("</script>");
		}
		
		UserDAO userDAO = new UserDAO(); // db에 접근할 수 있는 객체를 만든다.
		int result = userDAO.login(user.getUserID(), user.getUserPassword());
		
		if(result == 1){	// 로그인 성공
			session.setAttribute("userID", user.getUserID()); // 로그인에 성공했을 떄 각 사용자마다 세션값을 부여한다.
			
			PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
			script.println("<script>");
			script.println("location.href = 'main.jsp'");	// 로그인이 성공했을 떄 해당 페이지로 넘어간다.
			script.println("</script>");
		} else if(result == 0){	// 비밀번호 틀림
			PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
			script.println("<script>");
			script.println("alert('비밀번호가 틀렸습니다.')");
			script.println("history.back()");	// 이전의 페이지로 돌려보낸다.
			script.println("</script>");
		} else if(result == -1){	// 아이디 틀림
			PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디 입니다.')");
			script.println("history.back()");	// 이전의 페이지로 돌려보낸다.
			script.println("</script>");
		} else if(result == -2){
			PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()");	// 이전의 페이지로 돌려보낸다.
			script.println("</script>");
		}
	%>
</body>
</html>