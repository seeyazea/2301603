<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script>
	function delCart(cartUuid) {
		var frm = document.getElementById("frmCartDel");
		frm.processType.value = "P";
		frm.cartUuid.value = cartUuid;
		frm.submit();
	}
	function delCartAll() {
		var frm = document.getElementById("frmCartDel");
		frm.processType.value = "A";
		frm.submit();
	}
	function processPayment() {
		if (confirm("결제 하시겠습니까?")) {
			var frm = document.getElementById("frmPay");
			frm.submit();
		}
	}
</script>
</head>
<body>
	<%
	DecimalFormat df = new DecimalFormat("###,###");
	String sCategoryCd = request.getParameter("categoryCd");
	%>
	<form id="frmCartDel" name="frmCartDel" method="post"
		action="cartDel.jsp">
		<input type="hidden" id="shopDeviceId" name="shopDeviceId"
			value="<%=sShopDeviceId%>"> <input type="hidden"
			id="categoryCd" name="categoryCd" value="<%=sCategoryCd%>"> <input
			type="hidden" id="cartUuid" name="cartUuid" value=""> <input
			type="hidden" id="processType" name="processType" value="">
	</form>
	<form id="frmPay" name="frmPay" method="post" action="paySave.jsp">
	</form>
	<div class="footer">
		<div class="cartList">
			<ul>
				<%
				long lTotPrice = 0;
				ResultSet rs = null;
				PreparedStatement pstmt = null;
				try {
					StringBuffer sql = new StringBuffer();
					sql.append("SELECT A.CART_UUID, A.SHOP_DEVICE_ID, A.SHOP_UUID, A.PRODUCT_UUID\n");
					sql.append(" , A.QUANTITY, A.DRINK_TEMP\n");
					sql.append(" , B.CATEGORY_CD, B.PRODUCT_NAME, B.PRODUCT_PRICE\n");
					sql.append(" FROM cart A\n");
					sql.append(" INNER JOIN product B\n");
					sql.append(" ON A.PRODUCT_UUID = B.PRODUCT_UUID\n");
					sql.append(" WHERE A.shop_uuid = ?\n");
					sql.append(" AND A.shop_device_id = ?\n");
					sql.append(" ORDER by A.reg_dt ASC");
					System.out.println(sql.toString());
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, sShopUuid);
					pstmt.setString(2, sShopDeviceId);
					rs = pstmt.executeQuery();
					int iResult = 0;
					while (rs.next()) {
						lTotPrice += rs.getLong("PRODUCT_PRICE");
						String sCartUuid = rs.getString("CART_UUID");
				%>
				<li>
					<div class="cartProduct">
						<div class="cartProductImg">
							<img src="./images/coffee_png1.png">
						</div>
						<div class="cartProductDel" onclick="delCart('<%=sCartUuid%>');">
							<label style="cursor: pointer;">X</label>
						</div>
					</div>
				</li>
				<%
				iResult++;
				} // end While
				if (iResult == 0) {
				%>
				<li>
					<div class="cartProduct">
						<div class="cartProductImg">
							<img src="./images/coffee_png1.png">
						</div>
					</div>
				</li>
				<%
				}
				} catch (SQLException ex) {
				out.println("Product 테이블 호출이 실패했습니다.<br>");
				out.println("SQLException: " + ex.getMessage());
				} finally {
				if (rs != null)
				rs.close();
				if (pstmt != null)
				pstmt.close();
				if (conn != null)
				conn.close();
				}
				%>
			</ul>
		</div>
		<!-- 하단 결제 버튼 -->
		<div class="amount">
			<div class="lblPayTxt" style="">
				<label style="width: 100%; color: #FFF200">총결제금액</label>
			</div>
			<div class="lblPayAmountTxt">
				<label id="amountLbl">&#8361; <%=df.format(lTotPrice)%></label>
			</div>
			<div class="lblPayCancel">
				<label style="width: 100%; color: #FFFA99; cursor: pointer;"
					onclick="delCartAll();"> 전체취소</label>
			</div>
		</div>
		<!-- 하단 결제 버튼 -->
		<div class="pay" onclick="processPayment()">
			<label>결제</label>
		</div>
	</div>
</body>
</html>