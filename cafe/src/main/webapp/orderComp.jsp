<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>
<%
PreparedStatement pstmt = null;
String uuid = request.getParameter("orderUuid");
String status = request.getParameter("orderStatus");
String sql = "UPDATE ORDER_MASTER SET ORDER_STATUS=? WHERE ORDER_UUID=?";
try {
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, status);
	pstmt.setString(2, uuid);
	pstmt.executeUpdate();
} catch (Exception e) {
	e.printStackTrace();
} finally {
	if (pstmt != null)
		pstmt.close();
	if (conn != null)
		conn.close();
}
response.sendRedirect("orderMag.jsp");
%>
