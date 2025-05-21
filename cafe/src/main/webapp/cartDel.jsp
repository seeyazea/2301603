<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body onload="document.redirectForm.submit();">
	<%
	String sProcessType = request.getParameter("processType");
	String sCartUuid = request.getParameter("cartUuid");
	String sCategoryCd = request.getParameter("categoryCd"); // 목록으로 되돌아갈때 이전 카테고리 값 설정하기 위함
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	try {
		StringBuffer sql = new StringBuffer();
		sql.append("DELETE FROM CART \n");
		if ("P".equals(sProcessType)) {
			sql.append(" WHERE SHOP_UUID = ?\n");
			sql.append(" AND SHOP_DEVICE_ID = ?");
			sql.append(" AND CART_UUID = ?");
			System.out.println(sql.toString());
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, sShopUuid);
			pstmt.setString(2, sShopDeviceId);
			pstmt.setString(3, sCartUuid);
		} else if ("A".equals(sProcessType)) {
			sql.append(" WHERE SHOP_UUID = ?\n");
			sql.append(" AND SHOP_DEVICE_ID = ?");
			System.out.println(sql.toString());
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, sShopUuid);
			pstmt.setString(2, sShopDeviceId);
		}
		pstmt.executeUpdate();
	} catch (SQLException ex) {
		out.println("취소시 오류가 발생했습니다.");
		ex.printStackTrace();
	} finally {
		if (pstmt != null)
			pstmt.close();
		if (conn != null)
			conn.close();
	}
	%>
	<form id="redirectForm" name="redirectForm" action="product.jsp"
		method="post">
		<input type="hidden" id="categoryCd" name="categoryCd"
			value="<%=sCategoryCd%>">
	</form>
</body>
</html>