<%--실질적으로 사용자의 로그인 시도를 처리하는 페이지 이다. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>	<%-- 게시글을 작성할 수 있는 데이터베이스는 BbsDAO 객체를 이용해서 다룰 수 있기 때문에 BbsDAO클래스를 가져온다. --%>
<%@ page import="java.io.PrintWriter" %>	<%--자바스크립트 문장을 작성하기 위해 라이브러리를 불러온다. --%>
<% request.setCharacterEncoding("UTF-8"); %><%--건너오는 모든 데이터를 UTF-8로 받을 수 있게 한다. --%>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" /> <%--id와 class 확실히 알자.. class는 패키지.클래스 인가? --%>
<jsp:setProperty name="bbs" property="bbsTitle" />	<%--login.jsp 페이지에서 넘겨준 userID를 받는다  --%>
<jsp:setProperty name="bbs" property="bbsContent" />
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
		if(userID == null){ // 로그인이 안돼있는 경우는 게시글을 작성할 수 없기 때문에 로그인 페이지로 이동하게 한다.
			PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");	// 이전의 페이지로 돌려보낸다.
			script.println("</script>");
		} else{
			// 참고로 user는 UserDAO클래스의 join(User user) 메서드에서 에 있는 매개변수와
			// 위에서 user.UserDAO를 import 했는데  이렇게 이름이 같아야한다.
			if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null)
			{
				PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다.')");
				script.println("history.back()");	// 이전의 페이지로 돌려보낸다.
				script.println("</script>");
			} else{	// 모두다 입력이 됐을 떄는
				BbsDAO bbsDAO = new BbsDAO(); // db에 접근할 수 있는 객체를 만든다.
				int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());	// 각각의 변수들을 받아서 만들어진 bbs라는 인스턴스가 write함수를 수행하도록 매개변수로 들어간다.
				
				if(result == -1){	// 이미 존재하는 아이디일 떄
					PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다.')");
					script.println("history.back()");	// 이전의 페이지로 돌려보낸다.
					script.println("</script>");
				} else {	// 회원가입이 완료된 경우					
					PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
			}
		}
	
	%>
</body>
</html>