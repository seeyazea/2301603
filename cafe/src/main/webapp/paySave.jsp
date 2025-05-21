<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>
<!DOCTYPE html>
<html>
<body onload="document.redirectForm.submit();">
	<%
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	try {
		String sOrderUuid = "";
		int iMasterResult = 0;
		int iItemResult = 0;
		int iCartDelResult = 0;
		// 고유 키값 구하기
		StringBuffer keySql = new StringBuffer();
		keySql.append("SELECT SYS_GUID() AS UUID FROM DUAL");
		System.out.println(keySql.toString());
		pstmt = conn.prepareStatement(keySql.toString());
		rs = pstmt.executeQuery();
		if (rs.next()) {
			sOrderUuid = rs.getString("UUID");
		}
		// 총합가격
		StringBuffer totPriceSelSql = new StringBuffer();
		totPriceSelSql.append("/* paySave -TotalPriceSql */\n");
		totPriceSelSql.append("SELECT SUM(B.PRODUCT_PRICE * A.QUANTITY) TOT_PRICE\n");
		totPriceSelSql.append(" FROM cart A\n");
		totPriceSelSql.append(" INNER JOIN product B\n");
		totPriceSelSql.append(" ON A.PRODUCT_UUID = B.PRODUCT_UUID\n");
		totPriceSelSql.append(" WHERE A.shop_uuid = ?\n");
		totPriceSelSql.append(" AND A.shop_device_id = ?\n");
		totPriceSelSql.append(" GROUP BY A.SHOP_UUID, A.SHOP_DEVICE_ID\n");
		System.out.println(totPriceSelSql.toString());
		pstmt = conn.prepareStatement(totPriceSelSql.toString());
		pstmt.setString(1, sShopUuid);
		pstmt.setString(2, sShopDeviceId);
		rs = pstmt.executeQuery();
		int iTotalPrice = 0;
		if (rs.next()) {
			iTotalPrice = rs.getInt("TOT_PRICE");
		}
		if (iTotalPrice > 0) { // 합계 금액이 0이상일때
			// 마스터 입력
			StringBuffer masterInsSql = new StringBuffer();
			masterInsSql.append("/* paySave - masterInsertSql */\n");
			masterInsSql.append("INSERT INTO ORDER_MASTER ( \n");
			masterInsSql.append(" SHOP_UUID, ORDER_UUID, ORDER_STATUS, TOT_PRICE,REG_DT\n");
			masterInsSql.append(" ) VALUES (\n");
			masterInsSql.append(" ?, ?, 'PC', ?, SYSDATE)\n"); // Pay Complete
			System.out.println(masterInsSql.toString());
			pstmt = conn.prepareStatement(masterInsSql.toString());
			pstmt.setString(1, sShopUuid);
			pstmt.setString(2, sOrderUuid);
			pstmt.setInt(3, iTotalPrice);
			iMasterResult = pstmt.executeUpdate();
		} else {
			out.println("<script>alert('선택된 상품이 없습니다.');history.go (-1);</script>");
		}
		if (iMasterResult > 0) {
			// item 입력
			StringBuffer itemInsSql = new StringBuffer();
			itemInsSql.append("/* paySave - itemInsertSql */\n");
			itemInsSql.append("INSERT INTO ORDER_ITEM ( \n");
			itemInsSql.append(" ORDER_ITEM_UUID, SHOP_UUID, ORDER_UUID, PRODUCT_UUID\n");
			itemInsSql.append(" , DRINK_TEMP, QUANTITY, PRICE, REG_DT)\n");
			itemInsSql.append("SELECT SYS_GUID(), A.SHOP_UUID, ?, A.PRODUCT_UUID\n");
			itemInsSql.append(" , A.DRINK_TEMP, A.QUANTITY, B.PRODUCT_PRICE, SYSDATE\n");
			itemInsSql.append(" FROM cart A\n");
			itemInsSql.append(" INNER JOIN product B\n");
			itemInsSql.append(" ON A.PRODUCT_UUID = B.PRODUCT_UUID\n");
			itemInsSql.append(" WHERE A.shop_uuid = ?\n");
			itemInsSql.append(" AND A.shop_device_id = ?\n");
			System.out.println(itemInsSql.toString());
			pstmt = conn.prepareStatement(itemInsSql.toString());
			pstmt.setString(1, sOrderUuid);
			pstmt.setString(2, sShopUuid);
			pstmt.setString(3, sShopDeviceId);
			iItemResult = pstmt.executeUpdate();
			// 물품의 수량을 빼준다.
			StringBuffer productUpdateSql = new StringBuffer();
			productUpdateSql.append("UPDATE PRODUCT A \n");
			productUpdateSql.append(" SET A.PRODUCT_QUANTITY = A.PRODUCT_QUANTITY - (\n");
			productUpdateSql.append(" SELECT B.QUANTITY\n");
			productUpdateSql.append(" FROM CART B\n");
			productUpdateSql.append(" WHERE B.SHOP_UUID = ?\n");
			productUpdateSql.append(" AND B.SHOP_DEVICE_ID = ?\n");
			productUpdateSql.append(" AND A.PRODUCT_UUID = B.PRODUCT_UUID\n");
			productUpdateSql.append(" )\n");
			productUpdateSql.append(" WHERE EXISTS (\n");
			productUpdateSql.append(" SELECT 1\n");
			productUpdateSql.append(" FROM CART B\n");
			productUpdateSql.append(" WHERE B.SHOP_UUID = ?\n");
			productUpdateSql.append(" AND B.SHOP_DEVICE_ID = ?\n");
			productUpdateSql.append(" AND A.PRODUCT_UUID = B.PRODUCT_UUID\n");
			productUpdateSql.append(" )\n");
			System.out.println(productUpdateSql.toString());
			pstmt = conn.prepareStatement(productUpdateSql.toString());
			pstmt.setString(1, sShopUuid);
			pstmt.setString(2, sShopDeviceId);
			pstmt.setString(3, sShopUuid);
			pstmt.setString(4, sShopDeviceId);
			pstmt.executeUpdate();
		} // end if iMasterResult
		if (iItemResult > 0) { // 입력된 Item 수가 0이상일 경우 카트 삭제
			StringBuffer cartDelSql = new StringBuffer();
			cartDelSql.append("/* paySave - cartDelSql */\n");
			cartDelSql.append("DELETE FROM cart \n");
			cartDelSql.append(" WHERE shop_uuid = ?\n");
			cartDelSql.append(" AND shop_device_id = ?\n");
			System.out.println(cartDelSql.toString());
			pstmt = conn.prepareStatement(cartDelSql.toString());
			pstmt.setString(1, sShopUuid);
			pstmt.setString(2, sShopDeviceId);
			iCartDelResult = pstmt.executeUpdate();
		}
		if (iItemResult > 0 && iCartDelResult > 0) {
			out.println("<script>alert('주문되었습니다.');</script>");
		}
	} catch (SQLException ex) {
		out.println("SQLException: " + ex.getMessage());
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
		<input type="hidden" id="categoryCd" name="categoryCd" value="01">
	</form>
</body>
</html>