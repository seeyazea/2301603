<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="dbconn.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
// 1) 전달된 productUuid 파라미터
String productUuid = request.getParameter("productUuid");
// 2) DB에서 기존 상품 정보 조회
String categoryCd = "";
String productName = "";
String drinkTemp = "";
String productPrice = "";
String productQuantity = "";
String productDesc = "";
String productSort = "";
if (productUuid != null && !"".equals(productUuid)) {
	String sql = ""
	+ "SELECT CATEGORY_CD, PRODUCT_NAME, DRINK_TEMP, PRODUCT_PRICE, PRODUCT_QUANTITY, PRODUCT_DESC, PRODUCT_SORT "
	+ "  FROM PRODUCT " + " WHERE PRODUCT_UUID = ?";
	java.sql.PreparedStatement ps = conn.prepareStatement(sql);
	ps.setString(1, productUuid);
	java.sql.ResultSet rs = ps.executeQuery();
	if (rs.next()) {
		categoryCd = rs.getString("CATEGORY_CD");
		productName = rs.getString("PRODUCT_NAME");
		drinkTemp = rs.getString("DRINK_TEMP");
		productPrice = rs.getString("PRODUCT_PRICE");
		productQuantity = rs.getString("PRODUCT_QUANTITY"); // 여기 추가
		productDesc = rs.getString("PRODUCT_DESC");
		productSort = rs.getString("PRODUCT_SORT");	
	}
	rs.close();
	ps.close();
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품수정</title>
<style>
body {
	font-size: 12px;
	align: center;
}

.page-title {
	text-align: center;
	font-weight: bold;
	font-size: 18px;
	margin: 20px 0;
}

.form-table {
	width: 360px;
	margin: 0 auto;
	border-collapse: collapse;
	border: 1px solid #333;
	table-layout: fixed;
}

.form-table th, .form-table td {
	border: 1px solid #333;
	padding: 5px 4px;
	text-align: left;
	word-wrap: break-word;
}

.form-table th {
	width: 35%;
	background: #f5f5f5;
	font-weight: bold;
	font-size: 12px;
}

.form-table td input, .form-table td select, .form-table td textarea {
	width: 90%;
	font-size: 12px;
	box-sizing: border-box;
}

.form-table td textarea {
	height: 160px;
	resize: vertical;
}

.form-table .btn-row td {
	align: center;
	justify-content: center;
}
</style>
<script>
	function save() {
		var f = document.getElementById("frmProductSave");
		if (frmChk()) {
			f.action = "productSaveMag.jsp";
			f.submit();
		}
	}
	function frmChk() {
		var f = document.getElementById("frmProductSave");
		if (f.categoryCd.value == "") {
			alert("카테고리를 선택해주세요.");
			return f.categoryCd.focus(), false;
		}
		if (f.productName.value == "") {
			alert("상품명을 입력해주세요.");
			return f.productName.focus(), false;
		}
		if (f.drinkTemp.value == "") {
			alert("음료온도를 선택해주세요.");
			return f.drinkTemp.focus(), false;
		}
		if (f.productPrice.value == "") {
			alert("가격을 입력해주세요.");
			return f.productPrice.focus(), false;
		}
		if (f.productQuantity.value == "") {
			alert("수량을 입력해주세요.");
			return f.productQuantity.focus(), false;
		}
		return true;
	}
	function goList() {
		location.href = "productMag.jsp";
	}
	function cancel() {
		history.back();
	}
</script>
</head>
<body>
	<jsp:include page="menuMag.jsp" flush="true" />
	<h1 class="page-title">상품수정</h1>
	<form id="frmProductSave" name="frmProductSave" method="post"
		onsubmit="return false;">
		<input type="hidden" name="actionMothod" value="U"> <input
			type="hidden" name="productUuid" value="<%=productUuid%>">
		<table class="form-table">
			<tr>
				<th>카테고리</th>
				<td><select id="categoryCd" name="categoryCd">
						<option value="">-선택-</option>
						<option value="01" <%="01".equals(categoryCd) ? "selected" : ""%>>Coffee</option>
						<option value="02" <%="02".equals(categoryCd) ? "selected" : ""%>>NonCoffee</option>
						<option value="03" <%="03".equals(categoryCd) ? "selected" : ""%>>Ade</option>
						<option value="04" <%="04".equals(categoryCd) ? "selected" : ""%>>Smoothie</option>
				</select></td>
			</tr>
			<tr>
				<th>상품명</th>
				<td><input type="text" id="productName" name="productName"
					value="<%=productName%>"></td>
			</tr>
			<tr>
				<th>음료온도</th>
				<td><select id="drinkTemp" name="drinkTemp">
						<option value="">-선택-</option>
						<option value="H" <%="H".equals(drinkTemp) ? "selected" : ""%>>HOT</option>
						<option value="I" <%="I".equals(drinkTemp) ? "selected" : ""%>>ICE</option>
				</select></td>
			</tr>
			<tr>
				<th>가격</th>
				<td><input type="number" id="productPrice" name="productPrice"
					value="<%=productPrice%>"></td>
			</tr>
			<tr>
				<th>수량</th>
				<td><input type="number" id="productQuantity"
					name="productQuantity" value="<%=productQuantity%>"></td>
			</tr>
			<tr>
				<th>설명</th>
				<td><textarea id="productDesc" name="productDesc"><%=productDesc%></textarea></td>
			</tr>
			<tr>
				<th>정렬순서</th>
				<td><input type="number" id="productSort" name="productSort"
					value="<%=productSort%>"></td>
			</tr>
			<tr class="btn-row">
				<td colspan="2"><input type="button" onclick="save();"
					value="저장"> <input type="button" onclick="cancel();"
					value="취소"> <input type="button" onclick="goList();"
					value="목록"></td>
			</tr>
		</table>
	</form>
</body>
<%
  conn.close();
%>
</html>
