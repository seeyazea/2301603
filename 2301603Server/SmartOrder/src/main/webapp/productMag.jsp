<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
StringBuffer sql = new StringBuffer();
sql.append("/* productMag - LIST */\n");
sql.append("SELECT SHOP_UUID, PRODUCT_UUID\n");
sql.append(" , CATEGORY_CD\n");
sql.append(" , DECODE(CATEGORY_CD, '01', 'Coffee', '02', 'NonCoffee', '03', 'Ade', '04',
'Smoothie') CATEGORY_NM\n");
sql.append(" , PRODUCT_NAME\n");
sql.append(" , CASE WHEN DRINK_TEMP = 'H' THEN 'HOT' WHEN DRINK_TEMP = 'I'
THEN 'ICE' END DRINK_TEMP\n");
sql.append(" , PRODUCT_PRICE, PRODUCT_QUANTITY\n");
sql.append(" , PRODUCT_DESC, PRODUCT_SORT, REG_DT, UPT_DT\n");
sql.append(" FROM PRODUCT\n");
sql.append(" WHERE 1=1\n");
if(sCategoryCd != null && !"".equals(sCategoryCd)) {
sql.append(" AND CATEGORY_CD = ?\n");
}
if(sProductName != null && !"".equals(sProductName)) {
sql.append(" AND PRODUCT_NAME LIKE '%' || ? || '%'\n");
}
sql.append(" ORDER BY CATEGORY_CD ASC, PRODUCT_SORT ASC\n");

int iSetNum = 1;
pstmt = conn.prepareStatement(sql.toString());
if(sCategoryCd != null && !"".equals(sCategoryCd)) {
pstmt.setString(iSetNum, sCategoryCd);
iSetNum++;
}
if(sProductName != null && !"".equals(sProductName)) {
pstmt.setString(iSetNum, sProductName);
iSetNum++;
}
rs = pstmt.executeQuery();

<button style="background: #ff0000; color:#fff; border:2px solid #ff0000;"
onclick="productEdit('<%=productUuid%>');">수정</button>
<button style="background: #ff00ff; color:#fff; border:2px solid #ff00ff;"
onclick="productDel('<%=productUuid%>');">삭제</button>


function productEdit(productUuid) {
location.href = "./productEditMag.jsp?productUuid="+productUuid;
}
function productDel(productUuid) {
location.href = "./productDelMag.jsp?productUuid="+productUuid;
}

<form id="frmProductSearch" name="frmProductSearch" action="productMag.jsp"
method="post" onsubmit="return false;">
<div style="width: 90%; margin-left:auto; margin-right:auto; ">
<label>카테고리</label>
<select id="sCategoryCd" name="sCategoryCd">
<option value="">전체</option>
<option value="01" <%="01".equals(sCategoryCd)? " selected " : ""%>>Coffee</option>
<option value="02" <%="02".equals(sCategoryCd)? " selected " : ""%>>NonCoffee</option>
<option value="03" <%="03".equals(sCategoryCd)? " selected " : ""%>>Ade</option>
<option value="04" <%="04".equals(sCategoryCd)? " selected " : ""%>>Smoothie</option>
</select>
<label>상품명</label>
<input type="search" id="sProductName" name="sProductName" maxlength="100"
style="width:150px;" value="<%=sProductName%>">
<input type="submit" onclick="search();" value="검색">
<button onclick="addProduct();" style="background:#0000ff; color:#fff; border:2px solid
#0000ff;" >상품 추가</button>
</div>
</form>
</body>
</html>