<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

if("I".equals(sActionMothod)) { // 입력 처리일경우
sql.append("/* productSaveMag - INSERT */ \n");
sql.append("INSERT INTO PRODUCT ( \n");
sql.append(" SHOP_UUID, PRODUCT_UUID, CATEGORY_CD, PRODUCT_NAME, DRINK_TEMP\n");
sql.append(" , PRODUCT_PRICE, PRODUCT_QUANTITY, PRODUCT_DESC, PRODUCT_SORT, REG_DT,
UPT_DT\n");
sql.append(" ) VALUES (\n");
sql.append(" ?, SYS_GUID(), ?, ?, ?\n");
sql.append(" , ?, ?, ?, ?, SYSDATE, SYSDATE)\n");
System.out.println(sql.toString());
pstmt = conn.prepareStatement(sql.toString());
pstmt.setString(1, sShopUuid);
pstmt.setString(2, sCategoryCd);
pstmt.setString(3, sProductName);
pstmt.setString(4, sDrinkTemp);
pstmt.setString(5, sProductPrice);
pstmt.setString(6, sProductQuantity);
pstmt.setString(7, sProductDesc);
pstmt.setString(8, sProductSort);
} else if("U".equals(sActionMothod)) { // 수정시 처리
sql.append("/* productSaveMag - UPDATE */ \n");
sql.append("UPDATE PRODUCT SET \n");
sql.append(" CATEGORY_CD = ?\n");
sql.append(" , PRODUCT_NAME = ?\n");
sql.append(" , DRINK_TEMP = ?\n");
sql.append(" , PRODUCT_PRICE = ?\n");
sql.append(" , PRODUCT_QUANTITY = ?\n");
sql.append(" , PRODUCT_DESC = ?\n");
sql.append(" , PRODUCT_SORT = ?\n");
sql.append(" , UPT_DT = SYSDATE\n");
sql.append(" WHERE 1=1\n");
sql.append(" AND SHOP_UUID = ?\n");
sql.append(" AND PRODUCT_UUID = ?\n");
System.out.println(sql.toString());
pstmt = conn.prepareStatement(sql.toString());
pstmt.setString(1, sCategoryCd);
pstmt.setString(2, sProductName);
pstmt.setString(3, sDrinkTemp);
pstmt.setString(4, sProductPrice);
pstmt.setString(5, sProductQuantity);
pstmt.setString(6, sProductDesc);
pstmt.setString(7, sProductSort);
pstmt.setString(8, sShopUuid);
pstmt.setString(9, sProductUuid);

</body>
</html>