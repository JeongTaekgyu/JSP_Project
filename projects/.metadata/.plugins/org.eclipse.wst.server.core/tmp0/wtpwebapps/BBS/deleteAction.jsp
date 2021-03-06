<%--실질적으로 사용자의 로그인 시도를 처리하는 페이지 이다. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.io.PrintWriter" %>	<%--자바스크립트 문장을 작성하기 위해 라이브러리를 불러온다. --%>
<% request.setCharacterEncoding("UTF-8"); %><%--건너오는 모든 데이터를 UTF-8로 받을 수 있게 한다. --%>
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
		} 
		
		int bbsID = 0;
		// 매개변수로 넘어온 bbsID가 존재한다면
		if(request.getParameter("bbsID") != null){
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		// 현재 수정하고자 하는 글번호(bbsID)가 존재하지 않으면
		if(bbsID == 0){
			PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");	// 이전의 페이지로 돌려보낸다.
			script.println("</script>");
		}
		
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		// 현재 넘어온 bbsID값을 가지고 해당글을 가져온다(bbs객체에 담아 인스턴스화 시킨다.)  
		// session에 잇는 값(userID)와 이 글을 작성한 사람의 값(getUserID)이 같지 않다면
		if(!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
			script.println("<script>");
			script.println("alert('권한이 업습니다.')");
			script.println("location.href = 'bbs.jsp'");	// 이전의 페이지로 돌려보낸다.
			script.println("</script>");
		} 
		else { // 권한이 있는 사람이라면
			BbsDAO bbsDAO = new BbsDAO(); // db에 접근할 수 있는 객체를 만든다.
			int result = bbsDAO.delete(bbsID);	// 각각의 변수들을 받아서 만들어진 bbs라는 인스턴스가 write함수를 수행하도록 매개변수로 들어간다.
			
			if(result == -1){	// 이미 존재하는 아이디일 떄
				PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
				script.println("<script>");
				script.println("alert('글 삭제에 실패했습니다.')");
				script.println("history.back()");	// 이전의 페이지로 돌려보낸다.
				script.println("</script>");
			} else {	// 회원가입이 완료된 경우					
				PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
				script.println("<script>");
				script.println("location.href = 'bbs.jsp'");
				script.println("</script>");
			}
		}
	%>
</body>
</html>