<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>	<%--자바스크립트 문장을 작성하기 위해 라이브러리를 불러온다. --%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewprot" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		// 로그인이된 사람들은 로그인 정보를 담을 수 있도록 만들어준다.
		String userID = null;	// 로그인을 안하면 아래 if문 안들어가니까 null 값만 들어있다
		if(session.getAttribute("userID") != null)
		{	// 세션이 있는 사용자는 자신(userID)에게 할당된 세션값이 담긴다.
			userID = (String) session.getAttribute("userID");
		}
		
		if(userID == null) // 로그인을 안했다면
		{
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
	%>
	<nav class ="navbar navbar-default">
		<div class ="navbar-header">
			<button type ="button" class ="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-exmaple-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class ="collapse navbar-collapse" id ="#bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class ="dropdown">
					<a href="#" class ="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class ="caret"></span></a>
					<ul class ="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	
	<div class="container">
		<div class="row">
			<form method ="post" action="updateAction.jsp?bbsID=<%= bbsID %>">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>	<%-- 테이블의 헤더 --%>
						<tr>
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" value="<%= bbs.getBbsTitle() %>"></td>
						</tr>
						<tr>
							<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"><%= bbs.getBbsContent() %></textarea></td>
						</tr>
					</tbody>
				</table>
				<input type="submit" class="btn btn-primary pull-right" value ="글수정">
			</form>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>