<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품추가</title>
<style>
body {
	font-size: 12px;
}

.page-title {
	text-align: center;
	font-weight: bold;
	font-size: 18px;
	margin: 20px 0;
}

.form-table {
	width: 420px;
	margin: 0 auto;
	border-collapse: collapse;
	border: 1px solid #333;
	table-layout: fixed;
}

.form-table th, .form-table td {
	border: 1px solid #333;
	padding: 6px 4px; /* 세로 패딩 약간 확대 */
	text-align: left;
	word-wrap: break-word;
}

.form-table th {
	width: 30%;
	background-color: #f5f5f5;
	font-weight: bold;
	font-size: 12px;
}

.form-table td input, .form-table td select {
	width: 100%;
	font-size: 12px;
	box-sizing: border-box;
}

.form-table td textarea {
	width: 100%;
	font-size: 12px;
	box-sizing: border-box;
	resize: vertical;
	height: 200px; /* 세로를 조금 더 길게 */
}

.form-table .btn-row td {
	text-align: center;
}

.form-table .btn-row input {
	padding: 4px 8px; /* 텍스트 길이에 맞는 폭, 세로 유지 */
	font-size: 12px;
}
</style>
<script>
	function save() {
		var frm = document.getElementById("frmProductSave");
		if (frmChk()) {
			frm.action = "productSaveMag.jsp";
			frm.submit();
		}
	}
	function frmChk() {
		var frm = document.getElementById("frmProductSave");
		if (frm.categoryCd.value == "") {
			alert("카테고리를 선택해주세요.");
			frm.categoryCd.focus();
			return false;
		}
		if (frm.productName.value == "") {
			alert("상품명을 입력해주세요.");
			frm.productName.focus();
			return false;
		}
		if (frm.drinkTemp.value == "") {
			alert("음료온도를 선택해주세요.");
			frm.drinkTemp.focus();
			return false;
		}
		if (frm.productPrice.value == "") {
			alert("가격을 입력해주세요.");
			frm.productPrice.focus();
			return false;
		}
		if (frm.productQuantity.value == "") {
			alert("수량을 입력해주세요.");
			frm.productQuantity.focus();
			return false;
		}
		return true;
	}
</script>
</head>
<body>
	<jsp:include page="menuMag.jsp" flush="true" />

	<h1 class="page-title">상품추가</h1>
	<form id="frmProductSave" name="frmProductSave" action="" method="post"
		onsubmit="return false;">
		<input type="hidden" id="actionMothod" name="actionMothod" value="I">

		<table class="form-table">
			<tr>
				<th>카테고리</th>
				<td><select id="categoryCd" name="categoryCd">
						<option value="">-선택-</option>
						<option value="01">Coffee</option>
						<option value="02">NonCoffee</option>
						<option value="03">Ade</option>
						<option value="04">Smoothie</option>
				</select></td>
			</tr>
			<tr>
				<th>상품명</th>
				<td><input type="text" id="productName" name="productName"></td>
			</tr>
			<tr>
				<th>음료온도</th>
				<td><select id="drinkTemp" name="drinkTemp">
						<option value="">-선택-</option>
						<option value="H">HOT</option>
						<option value="I">ICE</option>
				</select></td>
			</tr>
			<tr>
				<th>가격</th>
				<td><input type="number" id="productPrice" name="productPrice"></td>
			</tr>
			<tr>
				<th>수량</th>
				<td><input type="number" id="productQuantity"
					name="productQuantity"></td>
			</tr>
			<tr>
				<th>설명</th>
				<td><textarea id="productDesc" name="productDesc"></textarea></td>
			</tr>
			<tr>
				<th>정렬순서</th>
				<td><input type="number" id="productSort" name="productSort"></td>
			</tr>
			<tr class="btn-row">
				<td colspan="2"><input type="button" onclick="save();"
					value="저장"> <input type="reset" value="취소"></td>
			</tr>
		</table>
	</form>
</body>
</html>
