<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script>
	function addCart(productUuid) {
		var frm = document.getElementById("frmProduct");
		frm.productUuid.value = productUuid;
		frm.submit();
	}
</script>

</head>
<%
DecimalFormat df = new DecimalFormat("###,###");
String sCategoryCd = request.getParameter("categoryCd");
System.out.println("categoryCd=" + sCategoryCd);
%>

<body>
	<jsp:include page="header.jsp" flush="true" />
	<section>
		<jsp:include page="menu.jsp" flush="true" />
	</section>
	<section>
		<div>
			<form id="frmProduct" name="frmProduct" action="cartSave.jsp"
				method="post">
				<input type="hidden" id="categoryCd" name="categoryCd"
					value="<%=sCategoryCd%>"> <input type="hidden"
					id="productUuid" name="productUuid">
			</form>
			<ul class="productList">
				<%
				ResultSet rs = null;
				PreparedStatement pstmt = null;
				try {
					StringBuffer sql = new StringBuffer();
					sql.append("SELECT PRODUCT_UUID, PRODUCT_NAME, PRODUCT_PRICE, DRINK_TEMP\n");
					sql.append(" FROM product\n");
					sql.append(" WHERE category_cd = ?\n");
					sql.append(" AND shop_uuid = ?\n");
					sql.append(" ORDER by product_sort ASC");
					System.out.println(sql.toString());
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, sCategoryCd);
					pstmt.setString(2, sShopUuid);
					rs = pstmt.executeQuery();
					int iResult = 0;
					while (rs.next()) {
						String productUuid = rs.getString("product_uuid");
						String producName = rs.getString("product_name");
						String producPrice = df.format(rs.getInt("product_price"));
						String drinkTemp = rs.getString("drink_temp");
				%>
				<li>
					<div class="item-container" onclick="addCart('<%=productUuid%>');">
						<div class="productImg">
							<img src="./images/coffee_png1.png" alt="제품이미지">
						</div>
						<div class="productName">
							<label><%=producName%> <%
 if ("H".equals(drinkTemp)) {
 	out.println("HOT");
 } else if ("I".equals(drinkTemp)) {
 	out.println("ICE");
 }
 %> </label>
						</div>
						<div class="price">
							<label>&#8361; <%=producPrice%></label>
						</div>
					</div>
				</li>
				<%
				iResult++; // 결과수 체크
				} // end while
				if (iResult == 0) {
				%>
				<li><label>조회된 상품이 없습니다.</label></li>
				<%
				}
				} catch (SQLException ex) {
				out.println("Product 테이블 호출이 실패했습니다.");
				ex.printStackTrace();
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
	</section>
	<section>
		<jsp:include page="footer.jsp" flush="true" />
	</section>
</body>
</html>