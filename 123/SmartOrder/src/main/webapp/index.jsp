<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문</title>
<style>
</style>
</head>
<body>
	<jsp:include page="product.jsp" flush="true" />
	<%
	DecimalFormat df = new DecimalFormat("###,###");
	String sCategoryCd = request.getParameter("categoryCd");
	String sShopUuid = request.getParameter("shopUuid"); // shop_uuid 값을 request에서 가져오는 방식 확인 필요

	// 로그 출력 (Console 확인용)
	System.out.println("categoryCd 값: " + sCategoryCd);
	System.out.println("shopUuid 값: " + sShopUuid);
	%>

</body>
</html>