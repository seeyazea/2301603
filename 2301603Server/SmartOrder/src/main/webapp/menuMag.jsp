<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<ul>
<li><a href="index.jsp">주문페이지</a></li>
<li><a href="orderMag.jsp">주문관리</a></li>
<li><a href="productMag.jsp">상품관리</a></li>
<li><a href="salesStatus.jsp">매출현황</a></li>
</ul>

<section>
<jsp:include page="menu.jsp" flush="true" />
</section>
위와 같이 되어 있는 부분을 아래와 같이 변경
<section>
<jsp:include page="menuMag.jsp" flush="true" />
</section>

</body>
</html>