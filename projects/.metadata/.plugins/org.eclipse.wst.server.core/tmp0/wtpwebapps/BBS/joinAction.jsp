<%--실질적으로 사용자의 로그인 시도를 처리하는 페이지 이다. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>	<%--UserDAO 클래스를 가져온다. --%>
<%@ page import="java.io.PrintWriter" %>	<%--자바스크립트 문장을 작성하기 위해 라이브러리를 불러온다. --%>
<% request.setCharacterEncoding("UTF-8"); %><%--건너오는 모든 데이터를 UTF-8로 받을 수 있게 한다. --%>
<jsp:useBean id="user" class="user.User" scope="page" /> <%--현재 페이지에서만 Bean이 사용될 수 있도록 한다. --%>
<jsp:setProperty name="user" property="userID" />	<%--login.jsp 페이지에서 넘겨준 userID를 받는다  --%>
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />
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
		if(userID != null){ // 이미 로그인 되있는 경우  회원가입 페이지에 접속할 수 없도록 한다.
			PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
			script.println("<script>");
			script.println("alert('이미 로그인 되어 있습니다.')");
			script.println("location.href = 'main.jsp'");	// 이전의 페이지로 돌려보낸다.
			script.println("</script>");
		}
	
		// 참고로 user는 UserDAO클래스의 join(User user) 메서드에서 에 있는 매개변수와
		// 위에서 user.UserDAO를 import 했는데  이렇게 이름이 같아야한다.
		if(user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null 
		|| user.getUserGender() == null || user.getUserEmail() == null)	{
			PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
			script.println("<script>");
			script.println("alert('입력이 안된 사항이 있습니다.')");
			script.println("history.back()");	// 이전의 페이지로 돌려보낸다.
			script.println("</script>");
		} else{	// 모두다 입력이 됐을 떄는
			UserDAO userDAO = new UserDAO(); // db에 접근할 수 있는 객체를 만든다.
			int result = userDAO.join(user);	// 각각의 변수들을 받아서 만들어진 user라는 인스턴스가 join함수를 수행하도록 매개변수로 들어간다.
			
			if(result == -1){	// 이미 존재하는 아이디일 떄
				PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()");	// 이전의 페이지로 돌려보낸다.
				script.println("</script>");
			} else {	// 회원가입이 완료된 경우
				session.setAttribute("userID", user.getUserID()); // 회원가입에 성공했을 떄 각 사용자마다 세션값을 부여한다.
				
				PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
				script.println("<script>");
				script.println("location.href = 'main.jsp'");
				script.println("</script>");
			}
		}
	%>
</body>
</html>