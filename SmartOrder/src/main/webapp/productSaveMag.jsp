<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
// 1) 요청 파라미터 수신
String sActionMothod = request.getParameter("actionMothod") == null ? "" : request.getParameter("actionMothod");
String sCategoryCd = request.getParameter("categoryCd") == null ? "" : request.getParameter("categoryCd");
String sProductName = request.getParameter("productName") == null ? "" : request.getParameter("productName");
String sDrinkTemp = request.getParameter("drinkTemp") == null ? "" : request.getParameter("drinkTemp");
String sProductPrice = request.getParameter("productPrice") == null ? "" : request.getParameter("productPrice");
String sProductQuantity = request.getParameter("productQuantity") == null ? ""
		: request.getParameter("productQuantity");
String sProductDesc = request.getParameter("productDesc") == null ? "" : request.getParameter("productDesc");
String sProductSort = request.getParameter("productSort") == null ? "" : request.getParameter("productSort");
String sProductUuid = request.getParameter("productUuid") == null ? "" : request.getParameter("productUuid");

java.sql.PreparedStatement pstmt = null;
try {
	StringBuffer sql = new StringBuffer();
	if ("I".equals(sActionMothod)) {
		// INSERT
		sql.append("INSERT INTO PRODUCT (\n");
		sql.append("  SHOP_UUID, PRODUCT_UUID, CATEGORY_CD, PRODUCT_NAME, DRINK_TEMP,\n");
		sql.append("  PRODUCT_PRICE, PRODUCT_QUANTITY, PRODUCT_DESC, PRODUCT_SORT, REG_DT, UPT_DT\n");
		sql.append(") VALUES (\n");
		sql.append("  ?, SYS_GUID(), ?, ?, ?,\n");
		sql.append("  ?, ?, ?, ?, SYSDATE, SYSDATE\n");
		sql.append(")\n");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, sShopUuid);
		pstmt.setString(2, sCategoryCd);
		pstmt.setString(3, sProductName);
		pstmt.setString(4, sDrinkTemp);
		pstmt.setString(5, sProductPrice);
		pstmt.setString(6, sProductQuantity);
		pstmt.setString(7, sProductDesc);
		pstmt.setString(8, sProductSort);
	} else if ("U".equals(sActionMothod)) {
		// UPDATE
		sql.append("UPDATE PRODUCT SET\n");
		sql.append("  CATEGORY_CD      = ?,\n");
		sql.append("  PRODUCT_NAME     = ?,\n");
		sql.append("  DRINK_TEMP       = ?,\n");
		sql.append("  PRODUCT_PRICE    = ?,\n");
		sql.append("  PRODUCT_QUANTITY = ?,\n");
		sql.append("  PRODUCT_DESC     = ?,\n");
		sql.append("  PRODUCT_SORT     = ?,\n");
		sql.append("  UPT_DT           = SYSDATE\n");
		sql.append("WHERE SHOP_UUID    = ?\n");
		sql.append("  AND PRODUCT_UUID = ?\n");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, sCategoryCd);
		pstmt.setString(2, sProductName);
		pstmt.setString(3, sDrinkTemp);
		pstmt.setString(4, sProductPrice);
		pstmt.setString(5, sProductQuantity);
		pstmt.setString(6, sProductDesc);
		pstmt.setString(7, sProductSort);
		pstmt.setString(8, sShopUuid);
		pstmt.setString(9, sProductUuid);
	}
	// 2) 실행
	pstmt.executeUpdate();
} catch (Exception e) {
	e.printStackTrace();
} finally {
	// 3) 자원 해제
	if (pstmt != null)
		try {
	pstmt.close();
		} catch (Exception ignore) {
		}
	if (conn != null)
		try {
	conn.close();
		} catch (Exception ignore) {
		}
}
// 4) 완료 즉시 목록으로 이동
response.sendRedirect("productMag.jsp");
%>
