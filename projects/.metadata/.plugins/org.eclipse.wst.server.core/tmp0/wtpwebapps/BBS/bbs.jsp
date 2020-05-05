<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>	<%--자바스크립트 문장을 작성하기 위해 라이브러리를 불러온다. --%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>	<%--게시판의 목록을 출력하기 위해서 --%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewprot" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
<%--텍스트를 검정색으로 하고 텍스트 데코레이션은 없다. --%>
<style type ="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
	}
</style>
</head>
<body>
	<%
		// 로그인이된 사람들은 로그인 정보를 담을 수 있도록 만들어준다.
		String userID = null;	// 로그인을 안하면 아래 if문 안들어가니까 null 값만 들어있다
		if(session.getAttribute("userID") != null)
		{	// 세션이 있는 사용자는 자신(userID)에게 할당된 세션값이 담긴다.
			userID = (String) session.getAttribute("userID");
		}
		
		int pageNumber = 1;	// 현재 게시판의 페이지넘버
		// pageNumber가 있으면 넣어준다.
		if(request.getParameter("pageNumber") != null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));	
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
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
						BbsDAO bbsDAO = new BbsDAO();
						ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
						
						// 현재 게시글에 대한 정보를 보여준다.
						for(int i = 0; i < list.size(); i++){
							
						
					%>
						<tr>
							<td><%= list.get(i).getBbsID() %></td>
							<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
							<td><%= list.get(i).getUserID() %></td>
							<td><%= list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11,13) + "시" 
							+ list.get(i).getBbsDate().substring(14,16) + "분"%></td>
						</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
				// pageNumber가 1이 아니면(2이상 이면)이전 페이지로 돌아갈 수 있다.
				if(pageNumber != 1){
			%>		
				<a href="bbs.jsp?pageNumber=<%=pageNumber - 1%>" class="btn btn-success btn-arraw-left">이전</a>
			<% 
				} 
				// 다음 페이지가 존재하면
				if(bbsDAO.nextPage(pageNumber + 1)){
			%>	
				<a href="bbs.jsp?pageNumber=<%=pageNumber + 1%>" class="btn btn-success btn-arraw-left">다음</a>
			<%
				}
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>