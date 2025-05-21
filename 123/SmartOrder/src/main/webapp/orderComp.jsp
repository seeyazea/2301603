<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>
<!DOCTYPE html>
<html>
<body onload="document.redirectForm.submit();">
	<%
	java.sql.PreparedStatement pstmt = null;
	try {
		String orderUuid = request.getParameter("orderUuid");
		String orderStatus = request.getParameter("orderStatus");

		StringBuffer sql = new StringBuffer();
		sql.append("UPDATE ORDER_MASTER SET\n");
		sql.append("    ORDER_STATUS = ?\n");
		sql.append("WHERE ORDER_UUID = ?");

		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, orderStatus);
		pstmt.setString(2, orderUuid);
		int updateCount = pstmt.executeUpdate();

		if (updateCount > 0) {
			out.println("<script>alert('주문 상태가 정상적으로 변경되었습니다.');</script>");
		} else {
			out.println("<script>alert('주문 상태 변경에 실패했습니다.');</script>");
		}
	} catch (Exception e) {
		out.println("<script>alert('오류 발생: " + e.getMessage() + "');</script>");
		e.printStackTrace();
	} finally {
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
	%>

	<form id="redirectForm" name="redirectForm" action="orderMag.jsp"
		method="post">
	</form>
</body>
</html>
