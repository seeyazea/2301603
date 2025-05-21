<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<form id="frmOrderSearch" name="frmOrderSearch" action="orderMag.jsp"
method="post" onsubmit="return false;">
<div style="width: 90%; margin-left:auto; margin-right:auto; ">
<label>주문일자</label>
<input type="date" id="sOrderDt" name="sOrderDt" maxlength="10"
style="width:100px;" value="<%=sOrderDt%>">
<label>주문상태</label>
<select id="sOrderStatus" name="sOrderStatus">
<option value="">전체</option>
<option value="PC" <%="PC".equals(sOrderStatus)? " selected " : ""%>>
결제완료</option>
<option value="DC" <%="DC".equals(sOrderStatus)? " selected " :
""%>>지급완료</option>
<option value="CC" <%="CC".equals(sOrderStatus)? " selected " :
""%>>취소완료</option>
</select>
<input type="submit" onclick="search();" value="검색">
</div>
</form>

String sOrderDt = request.getParameter("sOrderDt") == null ? "" :
request.getParameter("sOrderDt");
String sOrderStatus = request.getParameter("sOrderStatus") == null ? "" :
request.getParameter("sOrderStatus");
System.out.println("sOrderDt:"+ sOrderDt);
System.out.println("sOrderStatus:"+ sOrderStatus);

function search() {
var frm = document.getElementById("frmOrderSearch");
frm.submit();
}
StringBuffer sql = new StringBuffer();
sql.append("SELECT A.SHOP_UUID, A.ORDER_UUID\n");
sql.append(" , A.ORDER_STATUS\n");
sql.append(" , DECODE(A.ORDER_STATUS, 'PC', '결제완료', 'DC', '지급완료', 'CC', '취소완료')
ORDER_STATUS_NM\n");
sql.append(" , A.TOT_PRICE\n");
sql.append(" , B.PRODUCT_UUID, B.DRINK_TEMP, B.QUANTITY, B.PRICE\n");
sql.append(" , C.PRODUCT_NAME\n");
sql.append(" , (SELECT COUNT(*) FROM ORDER_ITEM WHERE ORDER_UUID = A.ORDER_UUID)
ORDER_ITEM_CNT\n");
sql.append(" , A.REG_DT\n");
sql.append(" FROM ORDER_MASTER A\n");
sql.append(" INNER JOIN ORDER_ITEM B\n");
sql.append(" ON A.ORDER_UUID = B.ORDER_UUID\n");
sql.append(" INNER JOIN PRODUCT C\n");
sql.append(" ON B.PRODUCT_UUID = C.PRODUCT_UUID\n");
sql.append(" WHERE 1=1\n");
if(sOrderStatus != null && !"".equals(sOrderStatus)) {
sql.append(" AND A.ORDER_STATUS = ?\n");
}
if(sOrderDt != null && !"".equals(sOrderDt)) {
sql.append(" AND TO_CHAR(A.REG_DT, 'YYYY-MM-DD') = ?\n");
}
sql.append(" ORDER BY A.REG_DT DESC, C.PRODUCT_SORT ASC\n");

int iSetNum = 1;
pstmt = conn.prepareStatement(sql.toString());
if(sOrderStatus != null && !"".equals(sOrderStatus)) {
pstmt.setString(iSetNum, sOrderStatus);
iSetNum++;
}
if(sOrderDt != null && !"".equals(sOrderDt)) {
pstmt.setString(iSetNum, sOrderDt);
iSetNum++;
}
rs = pstmt.executeQuery();

<button onclick="orderComp('<%=orderUuid%>');">지급처리</button>
<button onclick="orderCancel('<%=orderUuid%>');">취소처리</button>
<form id="frmOrder" name="frmOrder" action="orderComp.jsp" method="post">
<input type="hidden" id="orderUuid" name="orderUuid">
<input type="hidden" id="orderStatus" name="orderStatus">
</form>
function orderComp(orderUuid) {
var frm = document.getElementById("frmOrder");
frm.orderUuid.value = orderUuid;
frm.orderStatus.value = "DC";
frm.submit();
}
function orderCancel(orderUuid) {
var frm = document.getElementById("frmOrder");
frm.orderUuid.value = orderUuid;
frm.orderStatus.value = "CC";
frm.submit();
}

</body>
</html>