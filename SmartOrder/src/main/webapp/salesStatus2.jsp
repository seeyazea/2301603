<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,java.util.*" %>
<%@ include file="dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>매출현황2 - 상품별목록</title>
  <link rel="stylesheet" href="style.css">
  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
</head>
<body>
  <jsp:include page="menuMag.jsp" flush="true" />

  <div style="
    display: inline-block;
    margin: 10px 0 40px 5%;
    font-size: 12px;
    white-space: nowrap;
">
  <a href="salesStatus.jsp">월별 일 판매량 및 판매금액</a> |
  <a href="salesStatus2.jsp">월별 제품별 판매량 및 판매금액</a>
</div>


<%
  String sCategoryCd = request.getParameter("sCategoryCd");
  String sRegDt      = request.getParameter("sRegDt");

  StringBuffer sql = new StringBuffer();
  sql.append("SELECT C.PRODUCT_NAME, COUNT(B.PRODUCT_UUID) QUANTITY, SUM(B.PRICE) PRICE ");
  sql.append("FROM ORDER_MASTER A ");
  sql.append(" INNER JOIN ORDER_ITEM B ON A.ORDER_UUID = B.ORDER_UUID ");
  sql.append(" INNER JOIN PRODUCT C    ON B.PRODUCT_UUID = C.PRODUCT_UUID ");
  sql.append("WHERE A.ORDER_STATUS = 'DC' ");
  if (sCategoryCd != null && !"".equals(sCategoryCd)) {
    sql.append("AND C.CATEGORY_CD = ? ");
  }
  if (sRegDt != null && !"".equals(sRegDt)) {
    sql.append("AND TO_CHAR(B.REG_DT,'YYYY-MM') = ? ");
  }
  sql.append("GROUP BY C.PRODUCT_NAME, B.DRINK_TEMP, C.PRODUCT_SORT ");
  sql.append("ORDER BY C.PRODUCT_SORT ASC");

  PreparedStatement pstmt = conn.prepareStatement(sql.toString());
  int idx = 1;
  if (sCategoryCd != null && !"".equals(sCategoryCd)) pstmt.setString(idx++, sCategoryCd);
  if (sRegDt      != null && !"".equals(sRegDt))      pstmt.setString(idx++, sRegDt);

  ResultSet rs = pstmt.executeQuery();
  List<String[]> dataRows = new ArrayList<>();
  int totalQty   = 0;
  int totalPrice = 0;
  while (rs.next()) {
    String name  = rs.getString("PRODUCT_NAME");
    int qty      = rs.getInt("QUANTITY");
    int price    = rs.getInt("PRICE");
    totalQty   += qty;
    totalPrice += price;
    dataRows.add(new String[]{ name, String.valueOf(qty), String.valueOf(price) });
  }
  rs.close();
  pstmt.close();
%>
<section style="width:90%; margin:20px auto;">
    <h2 style="text-align:center; margin-bottom:20px;">월별 제품별 판매량 및 판매금액</h2>
  <!-- 검색 폼 -->
  <form id="frmSearch" name="frmSearch" action="salesStatus2.jsp" method="post" onsubmit="return false;"
        style="text-align:center; margin:20px 0;">
    <label>카테고리</label>
    <select name="sCategoryCd">
      <option value="" <%= (sCategoryCd==null||"".equals(sCategoryCd))?"selected":"" %>>전체</option>
      <option value="01" <%= "01".equals(sCategoryCd)?"selected":"" %>>Coffee</option>
      <option value="02" <%= "02".equals(sCategoryCd)?"selected":"" %>>NonCoffee</option>
      <option value="03" <%= "03".equals(sCategoryCd)?"selected":"" %>>Ade</option>
      <option value="04" <%= "04".equals(sCategoryCd)?"selected":"" %>>Smoothie</option>
    </select>
    <label style="margin-left:20px;">년월</label>
    <input type="month" name="sRegDt" style="width:120px;"
           value="<%= sRegDt==null?"":sRegDt %>">
    <input type="submit" onclick="document.frmSearch.submit();" value="검색" style="margin-left:10px;">
  </form>

  <!-- 테이블 & 차트 -->
  <div style="display:flex; width:90%; margin:0 auto; align-items:flex-start; gap:20px;">
    <!-- 테이블 -->
    <table border="1" style="width:48%; border-collapse:collapse; text-align:center;">
      <tr>
        <th>제품</th>
        <th>수량</th>
        <th>금액</th>
      </tr>
      <%
        for (String[] r : dataRows) {
      %>
      <tr>
        <td><%= r[0] %></td>
        <td><%= r[1] %></td>
        <td><%= r[2] %></td>
      </tr>
      <%
        }
      %>
      <tr style="font-weight:bold;">
        <td>합계</td>
        <td><%= totalQty   %></td>
        <td><%= totalPrice %></td>
      </tr>
    </table>

    <!-- 차트 -->
    <div style="width:70%; display:flex; gap:20px;">
      <div id="piechart_3d"   style="width:50%; height:350px;"></div>
      <div id="piechart_3d2"  style="width:50%; height:350px;"></div>
    </div>
  </div>

  <script>
    google.charts.load('current',{packages:['corechart']});
    google.charts.setOnLoadCallback(function() {
      // 금액 차트
      var data1 = new google.visualization.DataTable();
      data1.addColumn('string','제품');
      data1.addColumn('number','금액');
      data1.addRows([
  <% for (int i = 0; i < dataRows.size(); i++) {
       String[] r = dataRows.get(i);
       out.print("['"+r[0]+"', "+r[2]+"]");
       if (i < dataRows.size()-1) out.print(",");
       out.println();
     }
  %>
      ]);
      var options1 = { title:'월별 제품 판매금액', is3D:true };
      new google.visualization.PieChart(
        document.getElementById('piechart_3d')
      ).draw(data1, options1);

      // 수량 차트
      var data2 = new google.visualization.DataTable();
      data2.addColumn('string','제품');
      data2.addColumn('number','수량');
      data2.addRows([
  <% for (int i = 0; i < dataRows.size(); i++) {
       String[] r = dataRows.get(i);
       out.print("['"+r[0]+"', "+r[1]+"]");
       if (i < dataRows.size()-1) out.print(",");
       out.println();
     }
  %>
      ]);
      var options2 = { title:'월별 제품 판매량', pieHole:0.4 };
      new google.visualization.PieChart(
        document.getElementById('piechart_3d2')
      ).draw(data2, options2);
    });
  </script>

<%
  conn.close();
%>
</body>
</html>