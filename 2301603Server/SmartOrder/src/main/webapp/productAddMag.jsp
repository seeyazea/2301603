<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<form id="frmProductSave" name="frmProductSave" action=""
method="post" onsubmit="return false;">
<input type="hidden" id="actionMothod" name="actionMothod" value="I">
…
<input type="submit" onclick="save();" value="저장">
<input type="reset" value="취소">
…
</form>

function save() {
var frm = document.getElementById("frmProductSave");
if(frmChk()) {
frm.action = "productSaveMag.jsp";
frm.submit();
}
}

function frmChk() {
var frm = document.getElementById("frmProductSave");
if(frm.categoryCd.value == "") {
alert("카테고리를[을] 선택해주세요.");
frm.categoryCd.focus();
return false;
}
if(frm.productName.value == "") {
alert("상품명를[을] 입력해주세요.");
frm.productName.focus();
return false;
}
if(frm.drinkTemp.value == "") {
alert("음료온도를[을] 선택해주세요.");
frm.drinkTemp.focus();
return false;
}
if(frm.productPrice.value == "") {
alert("가격를[을] 입력해주세요.");
frm.productPrice.focus();
return false;
}
if(frm.productQuantity.value == "") {
alert("수량를[을] 입력해주세요.");
frm.productQuantity.focus();
return false;
}
return true;
}

</body>
</html>