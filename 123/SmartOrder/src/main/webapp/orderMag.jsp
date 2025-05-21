<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet,java.sql.PreparedStatement"%>
<%@ page import="java.util.*"%>
<%@ include file="dbconn.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문관리</title>
<link href="./style.css" rel="stylesheet" type="text/css">
<style>
.page-title {
	text-align: center;
	font-weight: bold;
	font-size: 24px;
	margin: 30px 0;
}

.order-table {
	width: 90%;
	margin: 40px auto;
	border-collapse: collapse;
	border: 2px solid #333;
	font-family: Arial, sans-serif;
	font-size: 14px;
}
.order-table th:nth-child(8),
.order-table td:nth-child(8) {
  width: 160px;               	
}

.order-table th {
	border: 1px solid #333;
	padding: 12px;
	background-color: #ccc;
	font-weight: bold;
	text-align: center;
	word-wrap: break-word;  
}

.order-table td {
	border: 1px solid #333;
	padding: 12px;
	text-align: center;
	word-wrap: break-word;  
}

.order-table tbody tr:nth-child(odd) td {
	background-color: #fafafa;
}

.order-table tbody tr:hover td {
	background-color: #f1f1f1;
}

.action-btn {
	padding: 6px 12px;
	margin: 0 4px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 13px;
	background: transparent;
	color: inherit;
	border: 1px solid #333;
}

.order-table .total-row td {
	font-weight: bold;
	background-color: #fff;
	border-top: 2px solid #333;
}
</style>
<script>
	function search() {
		document.getElementById("frmOrderSearch").submit();
	}
	function orderComp(uuid) {
		var f = document.getElementById("frmOrder");
		f.orderUuid.value = uuid;
		f.orderStatus.value = "DC";
		f.submit();
	}
	function orderCancel(uuid) {
		var f = document.getElementById("frmOrder");
		f.orderUuid.value = uuid;
		f.orderStatus.value = "CC";
		f.submit();
	}
</script>
</head>
<body>
	<jsp:include page="menuMag.jsp" flush="true" />

	<%
	// 파라미터 처리 및 SQL 구성
	String sOrderDt = Optional.ofNullable(request.getParameter("sOrderDt")).orElse("");
	String sOrderStatus = Optional.ofNullable(request.getParameter("sOrderStatus")).orElse("");

	StringBuffer sql = new StringBuffer();
	sql.append("SELECT A.ORDER_UUID, B.PRODUCT_UUID, C.PRODUCT_NAME, B.DRINK_TEMP, B.PRICE, B.QUANTITY, ");
	sql.append("       A.REG_DT, DECODE(A.ORDER_STATUS,'PC','결제완료','DC','지급완료','CC','취소완료') ORDER_STATUS_NM ");
	sql.append("  FROM ORDER_MASTER A ");
	sql.append(" INNER JOIN ORDER_ITEM B ON A.ORDER_UUID=B.ORDER_UUID ");
	sql.append(" INNER JOIN PRODUCT C    ON B.PRODUCT_UUID=C.PRODUCT_UUID ");
	sql.append(" WHERE 1=1 ");
	if (!sOrderStatus.isEmpty())
		sql.append(" AND A.ORDER_STATUS=? ");
	if (!sOrderDt.isEmpty())
		sql.append(" AND TO_CHAR(A.REG_DT,'YYYY-MM-DD')=? ");
	sql.append(" ORDER BY A.REG_DT DESC, C.PRODUCT_SORT ASC");

	PreparedStatement pstmt = conn.prepareStatement(sql.toString());
	int idx = 1;
	if (!sOrderStatus.isEmpty())
		pstmt.setString(idx++, sOrderStatus);
	if (!sOrderDt.isEmpty())
		pstmt.setString(idx++, sOrderDt);
	ResultSet rs = pstmt.executeQuery();

	// 주문별 / 상품별 중복 합산
	Map<String, List<Map<String, Object>>> orderMap = new LinkedHashMap<>();
	while (rs.next()) {
		String uuid = rs.getString("ORDER_UUID");
		String pname = rs.getString("PRODUCT_NAME");
		String rawTemp = rs.getString("DRINK_TEMP");
		String temp    = "I".equals(rawTemp) ? "ICE" : "HOT";
		int price = rs.getInt("PRICE");
		int qty = rs.getInt("QUANTITY");
		String regDt = rs.getString("REG_DT");
		String status = rs.getString("ORDER_STATUS_NM");

		List<Map<String, Object>> list = orderMap.get(uuid);
		if (list == null) {
			list = new ArrayList<>();
			orderMap.put(uuid, list);
		}
		boolean merged = false;
		for (Map<String, Object> row : list) {
			if (pname.equals(row.get("PNAME")) && temp.equals(row.get("TEMP")) && price == (int) row.get("PRICE")) {
		row.put("QTY", (int) row.get("QTY") + qty);
		merged = true;
		break;
			}
		}
		if (!merged) {
			Map<String, Object> row = new HashMap<>();
			row.put("UUID", uuid);
			row.put("PNAME", pname);
			row.put("TEMP", temp);
			row.put("PRICE", price);
			row.put("QTY", qty);
			row.put("REGDT", regDt);
			row.put("STATUS", status);
			list.add(row);
		}
	}
	rs.close();
	pstmt.close();

	// 그룹별 row 수 계산 및 리스트 준비
	List<Map<String, Object>> items = new ArrayList<>();
	Map<String, Integer> groupCount = new LinkedHashMap<>();
	for (Map.Entry<String, List<Map<String, Object>>> e : orderMap.entrySet()) {
		String uuid = e.getKey();
		List<Map<String, Object>> list = e.getValue();
		groupCount.put(uuid, list.size());
		items.addAll(list);
	}

	// 합계 계산 (지급완료만)
	int totalQty = 0, totalAmt = 0;
	for (Map<String, Object> row : items) {
		if ("지급완료".equals(row.get("STATUS"))) {
			totalQty += (int) row.get("QTY");
			totalAmt += (int) row.get("PRICE") * (int) row.get("QTY");
		}
	}
	%>

	<!-- 페이지 타이틀 -->
	<h1 class="page-title">주문관리</h1>

	<!-- 검색 폼 -->
	<form id="frmOrderSearch" name="frmOrderSearch" action="orderMag.jsp"
		method="post" onsubmit="return false;">
		<div
			style="width: 90%; margin: 0 auto; text-align: center; padding: 10px 0;">
			주문일자 <input type="date" name="sOrderDt" value="<%=sOrderDt%>"
				style="width: 140px; padding: 4px;"> 주문상태 <select
				name="sOrderStatus" style="padding: 4px;">
				<option value="">전체</option>
				<option value="PC" <%="PC".equals(sOrderStatus) ? "selected" : ""%>>결제완료</option>
				<option value="DC" <%="DC".equals(sOrderStatus) ? "selected" : ""%>>지급완료</option>
				<option value="CC" <%="CC".equals(sOrderStatus) ? "selected" : ""%>>취소완료</option>
			</select>
			<button type="button" onclick="search()"
				style="padding: 6px 12px; margin-left: 8px;">검색</button>
		</div>
	</form>

	<!-- 처리 폼 -->
	<form id="frmOrder" name="frmOrder" action="orderComp.jsp"
		method="post">
		<input type="hidden" name="orderUuid"> <input type="hidden"
			name="orderStatus">
	</form>

	<!-- 주문 목록 테이블 -->
	<table class="order-table">
		<thead>
			<tr>
				<th>주문번호</th>
				<th>상품명</th>
				<th>음료온도</th>
				<th>가격</th>
				<th>수량</th>
				<th>주문일시</th>
				<th>주문상태</th>
				<th>기타</th>
			</tr>
		</thead>
		<tbody>
			<%
			String prev = "";
			for (Map<String, Object> row : items) {
				String uuid = (String) row.get("UUID");
				int span = groupCount.get(uuid);
			%>
			<tr>
				<%
				if (!uuid.equals(prev)) {
				%>
				<td rowspan="<%=span%>"><%=uuid%></td>
				<%
				}
				%>
				<td><%=row.get("PNAME")%></td>
				<td><%=row.get("TEMP")%></td>
				<td><%=String.format("%,d", row.get("PRICE"))%>원</td>
				<td><%=row.get("QTY")%></td>
				<%
				if (!uuid.equals(prev)) {
				%>
				<td rowspan="<%=span%>"><%=row.get("REGDT")%></td>
				<td rowspan="<%=span%>"><%=row.get("STATUS")%></td>
				<td rowspan="<%=span%>">
					<%
					if ("결제완료".equals(row.get("STATUS"))) {
					%>
					<button class="action-btn" onclick="orderComp('<%=uuid%>')">지급처리</button>
					<button class="action-btn" onclick="orderCancel('<%=uuid%>')">취소처리</button>
					<%
					}
					%>
				</td>
				<%
				}
				%>
			</tr>
			<%
			prev = uuid;
			}
			%>
			<!-- 합계 행 -->
			<tr class="total-row">
				<td colspan="3" style="text-align: right;">합계(지급완료)</td>
				<td><%=String.format("%,d", totalAmt)%>원</td>
				<td><%=totalQty%></td>
				<td colspan="3"></td>
			</tr>
		</tbody>
	</table>
</body>
</html>
