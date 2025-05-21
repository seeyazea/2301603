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
sql.append("/* productSaveMag - DELETE */ \n");
sql.append("DELETE FROM PRODUCT \n");
sql.append(" WHERE 1=1\n");
sql.append(" AND SHOP_UUID = ?\n");
sql.append(" AND PRODUCT_UUID = ?\n");
System.out.println(sql.toString());
pstmt = conn.prepareStatement(sql.toString());
pstmt.setString(1, sShopUuid);
pstmt.setString(2, sProductUuid);
pstmt.executeUpdate();
</body>
</html>