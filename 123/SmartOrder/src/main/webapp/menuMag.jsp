<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="//fonts.googleapis.com/earlyaccess/nanumgothic.css"
	rel="stylesheet" type="text/css">
<link href="./style.css" rel="stylesheet" type="text/css">
</head>
<body>
	<jsp:include page="header.jsp" flush="true" />
	<nav id="menuArea">
		<ul>
			<li><a href="index.jsp">주문페이지</a></li>
			<li><a href="orderMag.jsp">주문관리</a></li>
			<li><a href="productMag.jsp">상품관리</a></li>
			<li><a href="salesStatus.jsp">매출현황</a></li>
		</ul>
	</nav>
</body>
</html>