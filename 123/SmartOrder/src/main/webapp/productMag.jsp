<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>
<%
String sCategoryCd = request.getParameter("sCategoryCd") == null ? "" : request.getParameter("sCategoryCd");
String sProductName = request.getParameter("sProductName") == null ? "" : request.getParameter("sProductName");
java.sql.PreparedStatement pstmt = null;
java.sql.ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품관리</title>
<script>
	function productEdit(productUuid) {
		location.href = "./productEditMag.jsp?productUuid=" + productUuid;
	}
	function productDel(productUuid) {
		location.href = "./productDelMag.jsp?productUuid=" + productUuid;
	}
	function search() {
		document.getElementById("frmProductSearch").submit();
	}
	function addProduct() {
		location.href = "./productAddMag.jsp";
	}
</script>
</head>
<body>
	<jsp:include page="menuMag.jsp" flush="true" />

	<!-- 검색 폼 -->
	<div align="center">
		<h1>상품관리</h1>
		<form id="frmProductSearch" name="frmProductSearch"
			action="productMag.jsp" method="post" onsubmit="return false;">
			<div style="width: 90%; margin: 20px auto; text-align: center;">
				<label>카테고리</label> <select name="sCategoryCd">
					<option value="">전체</option>
					<option value="01" <%="01".equals(sCategoryCd) ? "selected" : ""%>>Coffee</option>
					<option value="02" <%="02".equals(sCategoryCd) ? "selected" : ""%>>NonCoffee</option>
					<option value="03" <%="03".equals(sCategoryCd) ? "selected" : ""%>>Ade</option>
					<option value="04" <%="04".equals(sCategoryCd) ? "selected" : ""%>>Smoothie</option>
				</select> <label style="margin-left: 20px;">상품명</label> <input type="search"
					name="sProductName" style="width: 150px; padding: 4px;"
					value="<%=sProductName%>">
				<button type="button" onclick="search()"
					style="padding: 6px 12px; margin-left: 8px;">검색</button>
				<button type="button" onclick="addProduct()"
					style="padding: 6px 12px; margin-left: 8px; background: #00f; color: #fff; border: 2px solid #00f;">상품
					추가</button>
			</div>
		</form>
	</div>
	<%
	// SQL 실행
	StringBuffer sql = new StringBuffer();
	sql.append("SELECT DECODE(CATEGORY_CD,'01','Coffee','02','NonCoffee','03','Ade','04','Smoothie') CATEGORY_NM, \n");
	sql.append("       PRODUCT_UUID, PRODUCT_NAME, \n");
	sql.append("       CASE WHEN DRINK_TEMP='H' THEN 'HOT' ELSE 'ICE' END DRINK_TEMP, \n");
	sql.append("       PRODUCT_PRICE, PRODUCT_QUANTITY, PRODUCT_DESC \n");
	sql.append("  FROM PRODUCT WHERE 1=1 \n");
	if (!sCategoryCd.isEmpty())
		sql.append(" AND CATEGORY_CD = ?\n");
	if (!sProductName.isEmpty())
		sql.append(" AND PRODUCT_NAME LIKE '%'||?||'%'\n");
	sql.append(" ORDER BY CATEGORY_CD, PRODUCT_SORT");

	pstmt = conn.prepareStatement(sql.toString());
	int idx = 1;
	if (!sCategoryCd.isEmpty())
		pstmt.setString(idx++, sCategoryCd);
	if (!sProductName.isEmpty())
		pstmt.setString(idx++, sProductName);
	rs = pstmt.executeQuery();
	%>

	<!-- 상품 목록 테이블 -->


	<table
		style="width: 90%; margin: 0 auto 40px; border-collapse: collapse; border: 2px solid #333;">
		<thead>
			<tr>
				<th style="border: 1px solid #333; background: #ccc; padding: 10px;">카테고리</th>
				<th style="border: 1px solid #333; background: #ccc; padding: 10px;">상품명</th>
				<th style="border: 1px solid #333; background: #ccc; padding: 10px;">음료온도</th>
				<th style="border: 1px solid #333; background: #ccc; padding: 10px;">가격</th>
				<th style="border: 1px solid #333; background: #ccc; padding: 10px;">수량</th>
				<th style="border: 1px solid #333; background: #ccc; padding: 10px;">설명</th>
				<th
					style="border: 1px solid #333; background: #ccc; padding: 10px; width: 160px;">기타</th>
			</tr>
		</thead>
		<tbody>
			<%
			while (rs.next()) {
				String categoryNm = rs.getString("CATEGORY_NM");
				String name = rs.getString("PRODUCT_NAME");
				String temp = rs.getString("DRINK_TEMP");
				int price = rs.getInt("PRODUCT_PRICE");
				int qty = rs.getInt("PRODUCT_QUANTITY");
				String desc = rs.getString("PRODUCT_DESC");
				String uuid = rs.getString("PRODUCT_UUID");
			%>
			<tr>
				<td style="border: 1px solid #333; padding: 8px;"><%=categoryNm%></td>
				<td style="border: 1px solid #333; padding: 8px;"><%=name%></td>
				<td style="border: 1px solid #333; padding: 8px;"><%=temp%></td>
				<td style="border: 1px solid #333; padding: 8px; text-align: right;"><%=String.format("%,d", price)%></td>
				<td style="border: 1px solid #333; padding: 8px;"><%=qty%></td>
				<td style="border: 1px solid #333; padding: 8px; text-align: left;"><%=desc%></td>
				<td
					style="border: 1px solid #333; padding: 8px; text-align: center;">
					<button
						style="background: #f00; color: #fff; border: 2px solid #f00; padding: 6px 12px; margin: 0 4px;"
						onclick="productEdit('<%=uuid%>');">수정</button>
					<button
						style="background: #f0f; color: #fff; border: 2px solid #f0f; padding: 6px 12px; margin: 0 4px;"
						onclick="productDel('<%=uuid%>');">삭제</button>
				</td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
<%
	if (rs != null)
		rs.close();
	if (pstmt != null)
		pstmt.close();
	if (conn != null)
		conn.close();
%>
</body>
</html>
