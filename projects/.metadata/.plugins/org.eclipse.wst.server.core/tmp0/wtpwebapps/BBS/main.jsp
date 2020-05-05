<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>	<%--자바스크립트 문장을 작성하기 위해 라이브러리를 불러온다. --%>
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
		// 로그인이된 사람들은 로그인 정보를 담을 수 있도록 만들어준다.
		String userID = null;	// 로그인을 안하면 아래 if문 안들어가니까 null 값만 들어있다
		if(session.getAttribute("userID") != null)
		{	// 세션이 있는 사용자는 자신(userID)에게 할당된 세션값이 담긴다.
			userID = (String) session.getAttribute("userID");
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
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹사이트</a>
		</div>
		<div class ="collapse navbar-collapse" id ="#bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="main.jsp">메인</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
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
		<div class="jumbotron">
			<div class="container">
				<h1>웹 사이트 소개</h1>
				<p>이 웹사이트는 부트스트랩으로 만든 JSP웹 사이트 입니다. 최소한의 간단한 로직만을 이용해서 개발했습니다. 디자인 템플릿으로는 부트스트랩을 이용했습니다.</p>
				<p><a class="btn btn-primary btn-pull" href="https://github.com/JeongTaekgyu/JSP_Project" role="button">자세히 알아보기</a></p>
			</div>
		</div>
	</div>
	
	<%-- carousel은 사진첩 같은 개념이다. --%>
	<div class="container">
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
			<ol class="carousel-indicators">
				<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
				<li data-target="#myCarousel" data-slide-to="1"></li>
				<li data-target="#myCarousel" data-slide-to="2"></li>
			</ol>
			<div class="carousel-inner">
				<div class="item active">
					<img src="images/1_aurora.jpg">
				</div>
				<div class="item">
					<img src="images/2_beach.jpg">
				</div>
				<div class="item">
					<img src="images/3_ship.jpg">
				</div>
			</div>
			<a class="left carousel-control" href="#myCarousel" data-slide="prev">
				<span class="glyphicon glyphicon-chevron-left"></span>
			</a>
			<a class="right carousel-control" href="#myCarousel" data-slide="next">
				<span class="glyphicon glyphicon-chevron-right"></span>
			</a>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>