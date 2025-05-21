<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.DecimalFormat" %>
<%@ include file="globalVar.jsp" %>
<%@ include file="dbconn.jsp" %>

<%
DecimalFormat df = new DecimalFormat("###,###");
String sCategoryCd = request.getParameter("categoryCd");
long lTotPrice = 0;
%>

<form id="frmCartDel" method="post" action="cartDel.jsp">
	<input type="hidden" name="shopDeviceId" value="<%=sShopDeviceId%>">
	<input type="hidden" name="categoryCd" value="<%=sCategoryCd%>">
	<input type="hidden" name="cartUuid" value="">
	<input type="hidden" name="processType" value="">
</form>

<form id="frmPay" method="post" action="paySave.jsp">
	<input type="hidden" name="shopDeviceId" value="<%=sShopDeviceId%>">
	<input type="hidden" name="categoryCd" value="<%=sCategoryCd%>">
</form>

<script>
	function delCart(cartUuid) {
		const frm = document.getElementById("frmCartDel");
		frm.processType.value = "P";
		frm.cartUuid.value = cartUuid;
		frm.submit();
	}
	function delCartAll() {
		const frm = document.getElementById("frmCartDel");
		frm.processType.value = "A";
		frm.submit();
	}
	function processPayment() {
		if (confirm("결제 하시겠습니까?")) {
			document.getElementById("frmPay").submit();
		}
	}
</script>

<div class="cart-section">
	<ul class="cart-list">
	<%
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	try {
		String sql = "SELECT A.CART_UUID, B.PRODUCT_NAME, B.PRODUCT_PRICE " +
					 "FROM KB_Cart A " +
					 "JOIN KB_Product B ON A.PRODUCT_UUID = B.PRODUCT_UUID " +
					 "WHERE A.SHOP_UUID = ? AND A.SHOP_DEVICE_ID = ? " +
					 "ORDER BY A.REG_DT ASC";

		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, sShopUuid);
		pstmt.setString(2, sShopDeviceId);
		rs = pstmt.executeQuery();

		int itemCount = 0;
		while (rs.next()) {
			String sCartUuid = rs.getString("CART_UUID");
			String sProductName = rs.getString("PRODUCT_NAME");
			long lPrice = rs.getLong("PRODUCT_PRICE");
			lTotPrice += lPrice;
	%>
		<li class="cart-item">
			<span><%=sProductName%></span>
			<span>&#8361; <%=df.format(lPrice)%></span>
			<button type="button" onclick="delCart('<%=sCartUuid%>')">삭제</button>
		</li>
	<%
			itemCount++;
		}
		if (itemCount == 0) {
	%>
		<li class="cart-item">장바구니에 담긴 상품이 없습니다.</li>
	<%
		}
	} catch (SQLException e) {
		out.println("장바구니 조회 오류: " + e.getMessage());
	} finally {
		if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
		if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
		if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
	}
	%>
	</ul>

	<div class="cart-total">
		<p>총 결제 금액: <strong>&#8361; <%=df.format(lTotPrice)%></strong></p>
	</div>

	<div class="cart-actions">
		<button type="button" onclick="delCartAll()">전체 취소</button>
		<button type="button" onclick="processPayment()">결제</button>
	</div>
</div>
