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
	String sCategoryCd = request.getParameter("categoryCd");
	String sProductUuid = request.getParameter("productUuid");
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	try {
		StringBuffer sqlSelect = new StringBuffer();
		sqlSelect.append("SELECT PRODUCT_QUANTITY, DRINK_TEMP \n");
		sqlSelect.append(" FROM product\n");
		sqlSelect.append(" WHERE shop_uuid = ?\n");
		sqlSelect.append(" AND product_uuid = ?\n");
		System.out.println(sqlSelect.toString());
		pstmt = conn.prepareStatement(sqlSelect.toString());
		pstmt.setString(1, sShopUuid);
		pstmt.setString(2, sProductUuid);
		rs = pstmt.executeQuery();
		int iProductQuantity = 0; // 변수 초기화
		String sDrinkTemp = ""; // 변수 초기화
		while (rs.next()) {
			iProductQuantity = rs.getInt("PRODUCT_QUANTITY");
			sDrinkTemp = rs.getString("DRINK_TEMP");
		}
		System.out.println("iProductQuantity:" + iProductQuantity);
		System.out.println("sDrinkTemp:" + sDrinkTemp);
		if (iProductQuantity > 0) { // 수량 체크
			StringBuffer sql = new StringBuffer();
			sql.append("INSERT INTO CART ( \n");
			sql.append(" CART_UUID\n");
			sql.append(" , SHOP_DEVICE_ID, SHOP_UUID, PRODUCT_UUID, QUANTITY, DRINK_TEMP \n");
			sql.append(" , REG_DT\n");
			sql.append(" ) VALUES (\n");
			sql.append(" SYS_GUID()\n");
			sql.append(" , ?, ?, ?, ?, ?\n");
			sql.append(" , SYSDATE)\n");
			System.out.println(sql.toString());
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, sShopDeviceId);
			pstmt.setString(2, sShopUuid);
			pstmt.setString(3, sProductUuid);
			pstmt.setString(4, "1");
			pstmt.setString(5, sDrinkTemp);
			pstmt.executeUpdate();
		}
	} catch (SQLException ex) {
		out.println("SQLException: " + ex.getMessage());
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