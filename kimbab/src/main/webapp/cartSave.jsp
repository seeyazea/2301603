<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>장바구니 추가</title>
</head>
<body onload="document.redirectForm.submit();">

<%
String sCategoryCd = request.getParameter("categoryCd");
String sProductUuid = request.getParameter("productUuid");

ResultSet rs = null;
PreparedStatement pstmt = null;

try {
	// 1. 상품 수량 확인
	String sqlSelect = "SELECT PRODUCT_QUANTITY FROM KB_Product WHERE SHOP_UUID = ? AND PRODUCT_UUID = ?";
	pstmt = conn.prepareStatement(sqlSelect);
	pstmt.setString(1, sShopUuid);
	pstmt.setString(2, sProductUuid);
	rs = pstmt.executeQuery();

	int iProductQuantity = 0;
	if (rs.next()) {
		iProductQuantity = rs.getInt("PRODUCT_QUANTITY");
	}

	rs.close();
	pstmt.close();

	// 2. 수량이 있을 경우 장바구니에 추가
	if (iProductQuantity > 0) {
		String sqlInsert = "INSERT INTO KB_Cart (CART_UUID, SHOP_DEVICE_ID, SHOP_UUID, PRODUCT_UUID, QUANTITY, REG_DT) " +
						   "VALUES (SYS_GUID(), ?, ?, ?, ?, SYSDATE)";
		pstmt = conn.prepareStatement(sqlInsert);
		pstmt.setString(1, sShopDeviceId);
		pstmt.setString(2, sShopUuid);
		pstmt.setString(3, sProductUuid);
		pstmt.setInt(4, 1);  // 수량은 기본 1개
		pstmt.executeUpdate();
	}
} catch (SQLException ex) {
	out.println("장바구니 추가 중 오류 발생: " + ex.getMessage());
	ex.printStackTrace();
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
	if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
}
%>

<form id="redirectForm" name="redirectForm" action="product.jsp" method="post">
	<input type="hidden" name="categoryCd" value="<%= sCategoryCd %>" />
</form>

</body>
</html>
