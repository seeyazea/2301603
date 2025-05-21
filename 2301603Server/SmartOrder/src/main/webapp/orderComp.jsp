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
sql.append("UPDATE ORDER_MASTER SET \n");
sql.append(" ORDER_STATUS = ?\n");
sql.append(" WHERE ORDER_UUID = ?");

</body>
</html>