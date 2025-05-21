<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<form id="frmProductSave" name="frmProductSave" action="" method="post"
onsubmit="return false;">
<input type="hidden" id="actionMothod" name="actionMothod" value=“U”>
…
<input type="submit" onclick="save();" value="저장">
<input type="reset" value="취소">
<input type="button" onclick="goList();" value="목록">
…
</form>

function save() {
var frm = document.getElementById("frmProductSave");
if(frmChk()) {
frm.action = "productSaveMag.jsp";
frm.submit();
}
}

function goList() {
location.href = "productMag.jsp";
}

StringBuffer sqlSelect = new StringBuffer();
sqlSelect.append("/* productEditMag - selectProduct */\n");
sqlSelect.append("SELECT SHOP_UUID, PRODUCT_UUID, CATEGORY_CD,
PRODUCT_NAME, DRINK_TEMP\n");
sqlSelect.append(" , PRODUCT_PRICE, PRODUCT_QUANTITY, PRODUCT_DESC,
PRODUCT_SORT, REG_DT, UPT_DT \n");
sqlSelect.append(" FROM PRODUCT\n");
sqlSelect.append(" WHERE shop_uuid = ?\n");
sqlSelect.append(" AND product_uuid = ?\n");
System.out.println(sqlSelect.toString());
pstmt = conn.prepareStatement(sqlSelect.toString());
pstmt.setString(1, sShopUuid);
pstmt.setString(2, sProductUuid);
</body>
</html>