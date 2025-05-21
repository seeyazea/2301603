<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="globalVar.jsp" %>
<%@ include file="dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>장바구니 항목 삭제</title>
</head>
<body onload="document.redirectForm.submit();">
<%
	String sProcessType = request.getParameter("processType");  // "P" = 특정 상품, "A" = 전체 삭제
	String sCartUuid = request.getParameter("cartUuid");
	String sCategoryCd = request.getParameter("categoryCd");

	PreparedStatement pstmt = null;

	try {
		StringBuilder sql = new StringBuilder("DELETE FROM KB_Cart WHERE SHOP_UUID = ? AND SHOP_DEVICE_ID = ?");

		if ("P".equals(sProcessType)) {
			sql.append(" AND CART_UUID = ?");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, sShopUuid);
			pstmt.setString(2, sShopDeviceId);
			pstmt.setString(3, sCartUuid);
		} else if ("A".equals(sProcessType)) {
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, sShopUuid);
			pstmt.setString(2, sShopDeviceId);
		}

		pstmt.executeUpdate();
	} catch (SQLException ex) {
		out.println("장바구니 삭제 중 오류 발생: " + ex.getMessage());
		ex.printStackTrace();
	} finally {
		if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
		if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
	}
%>

<form id="redirectForm" name="redirectForm" action="product.jsp" method="post">
	<input type="hidden" name="categoryCd" value="<%=sCategoryCd%>" />
</form>
</body>
</html>
