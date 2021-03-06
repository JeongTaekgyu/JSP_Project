<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>	<%--자바스크립트 문장을 작성하기 위해 라이브러리를 불러온다. --%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>	<%-- 데이터베이스 접근 객체를 가져온다 --%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewprot" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;	// 로그인을 안하면 아래 if문 안들어가니까 null 값만 들어있다
		
		// 로그인이된 사람들은 로그인 정보를 담을 수 있도록 만들어준다.
		if(session.getAttribute("userID") != null) 
		{	// 세션이 있는 사용자는 자신(userID)에게 할당된 세션값이 담긴다.
			userID = (String) session.getAttribute("userID");
		}

		int bbsID = 0;
		// 매개변수로 넘어온 bbsID가 존재한다면
		if(request.getParameter("bbsID") != null){
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		// 존재하지 않으면
		if(bbsID == 0){
			PrintWriter script = response.getWriter();	// 하나의 스크립트 문장을 넣어줄 수 있도록한다.
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");	// 이전의 페이지로 돌려보낸다.
			script.println("</script>");
		}
		
		// bbsID 0이 아니면 구체적인 정보를 bbs 인스턴스에 담는다.
		Bbs bbs = new BbsDAO().getBbs(bbsID);
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
			
			<%	// 로그인이 되어있지 않은 경우라면  로그인이나 회원가입을 할 수 있다.
				if(userID == null){
			%>
				<ul class="nav navbar-nav navbar-right">
					<li class ="dropdown">
						<a href="#" class ="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">회원관리<span class ="caret"></span></a>
						<ul class ="dropdown-menu">
							<li><a href="login.jsp">로그인</a></li>
							<li><a href="join.jsp">회원가입</a></li>
						</ul>
					</li>
				</ul>
			<%
				} else {
			%>
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
			<%
				}
			%>
			
		</div>
	</nav>
	
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>	<%-- 테이블의 헤더 --%>
					<tr>
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글보기  양식</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%;">글 제목</td>
						<%-- 크로스 사이트 스크립트 공격 을 방지해준다. --%>
						<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%= bbs.getUserID() %></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%= bbs.getBbsDate().substring(0,11) + bbs.getBbsDate().substring(11,13) + "시" 
								+ bbs.getBbsDate().substring(14,16) + "분" %></td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="2" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
					</tr>
				</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>	<%-- 목록으로 돌아갈 수 있게 만듦 --%>
			<%
			// 현재 사용자(userID)가 글의 작성자(getUserID())와 동일하다면 글을 수정할 수 있게 해줌
				if(userID != null && userID.equals(bbs.getUserID())){
			%>
				<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
				<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID%>" class="btn btn-primary">삭제</a>
			<%
				}
			%>
			<%-- <input type="submit" class="btn btn-primary pull-right" value ="글쓰기2"> --%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>