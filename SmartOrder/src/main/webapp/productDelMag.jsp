<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>
<%
// 1) POST 인코딩 설정 (한글 깨짐 방지)
request.setCharacterEncoding("UTF-8");

// 2) 삭제할 상품 UUID 파라미터 수신
String sProductUuid = request.getParameter("productUuid") == null ? "" : request.getParameter("productUuid");

java.sql.PreparedStatement pstmt = null;
try {
	// 3) DELETE SQL 준비
	StringBuffer sql = new StringBuffer();
	sql.append("/* productDeleteMag - DELETE */\n");
	sql.append("DELETE FROM PRODUCT\n");
	sql.append(" WHERE SHOP_UUID   = ?\n");
	sql.append("   AND PRODUCT_UUID = ?\n");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, sShopUuid);
	pstmt.setString(2, sProductUuid);

	// 4) 실행
	pstmt.executeUpdate();
} catch (Exception e) {
	e.printStackTrace();
} finally {
	// 5) 자원 해제
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

// 6) 삭제 완료 후 목록 페이지로 리다이렉트
response.sendRedirect("productMag.jsp");
%>
