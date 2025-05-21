<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>
<%
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int iSetNum = 1;
    String sCategoryCd  = request.getParameter("sCategoryCd") == null ? "" : request.getParameter("sCategoryCd");
    String sProductName = request.getParameter("sProductName") == null ? "" : request.getParameter("sProductName");

    // SQL 쿼리 조합
    StringBuffer sql = new StringBuffer();
    sql.append("/* productMag - LIST */\n");
    sql.append("SELECT SHOP_UUID, PRODUCT_UUID, \n");
    sql.append("       CATEGORY_CD, \n");
    sql.append("       DECODE(CATEGORY_CD, '01', 'Coffee', '02', 'NonCoffee', '03', 'Ade', '04', 'Smoothie') CATEGORY_NM, \n");
    sql.append("       PRODUCT_NAME, \n");
    sql.append("       CASE WHEN DRINK_TEMP = 'H' THEN 'HOT' WHEN DRINK_TEMP = 'I' THEN 'ICE' END DRINK_TEMP, \n");
    sql.append("       PRODUCT_PRICE, PRODUCT_QUANTITY, \n");
    sql.append("       PRODUCT_DESC, PRODUCT_SORT, REG_DT, UPT_DT \n");
    sql.append("  FROM PRODUCT \n");
    sql.append(" WHERE 1=1 \n");

    if (!"".equals(sCategoryCd)) {
        sql.append(" AND CATEGORY_CD = ? \n");
    }
    if (!"".equals(sProductName)) {
        sql.append(" AND PRODUCT_NAME LIKE '%' || ? || '%' \n");
    }
    sql.append(" ORDER BY CATEGORY_CD ASC, PRODUCT_SORT ASC \n");

    pstmt = conn.prepareStatement(sql.toString());

    // 파라미터 설정
    if (!"".equals(sCategoryCd)) {
        pstmt.setString(iSetNum++, sCategoryCd);
    }
    if (!"".equals(sProductName)) {
        pstmt.setString(iSetNum++, sProductName);
    }

    rs = pstmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 관리</title>
    <link href="style.css" rel="stylesheet" type="text/css">
    <script>
        function search() {
            var formData = new FormData(document.getElementById("frmProductSearch"));

            // AJAX로 검색 결과를 가져옵니다.
            fetch('productMagList.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                document.getElementById("productListContainer").innerHTML = data;
            });
        }

        function addProduct() {
            // 상품 추가 작업을 비동기적으로 처리할 수 있는 페이지로 리디렉션
            location.href = "./productAddMag.jsp";  // 상품 추가 페이지로 이동
        }

        function productEdit(productUuid) {
            // 상품 수정 페이지로 이동
            location.href = "./productEditMag.jsp?productUuid=" + productUuid;
        }

        function productDel(productUuid) {
            if (confirm("정말 삭제하시겠습니까?")) {
                // 삭제 요청을 AJAX로 보내기
                fetch('./productDelMag.jsp?productUuid=' + productUuid, {
                    method: 'GET'
                })
                .then(response => response.text())
                .then(data => {
                    // 삭제 후 결과 갱신
                    search(); // 삭제 후 다시 검색 실행
                });
            }
        }
    </script>
</head>
<body>
    <section>
        <jsp:include page="menuMag.jsp" flush="true" />
    </section>

    <!-- 상품 검색 폼 -->
    <form id="frmProductSearch" name="frmProductSearch" action="productMag.jsp" method="post" onsubmit="return false;">
       <div style="width: 40%; margin: 0 auto; padding: 10px;">
            <label>카테고리</label>
            <select id="sCategoryCd" name="sCategoryCd">
                <option value="">전체</option>
                <option value="01" <%="01".equals(sCategoryCd)? " selected " : ""%>>Coffee</option>
                <option value="02" <%="02".equals(sCategoryCd)? " selected " : ""%>>NonCoffee</option>
                <option value="03" <%="03".equals(sCategoryCd)? " selected " : ""%>>Ade</option>
                <option value="04" <%="04".equals(sCategoryCd)? " selected " : ""%>>Smoothie</option>
            </select>
            <label>상품명</label>
            <input type="search" id="sProductName" name="sProductName" maxlength="100" style="width:150px;" value="<%=sProductName%>">
            <input type="submit" onclick="search();" value="검색">
            <button onclick="addProduct();" style="background:#0000ff; color:#fff; border:2px solid #0000ff;">상품 추가</button>
        </div>
    </form>

    <!-- 상품 목록 테이블 -->
    <div id="productListContainer">
        <table class="order-table" border="1" style="width: 40%; margin: 0 auto;">
            <thead>
                <tr>
                    <th>상품명</th>
                    <th>카테고리</th>
                    <th>음료온도</th>
                    <th>가격</th>
                    <th>수량</th>
                    <th>수정/삭제</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                        String productUuid = rs.getString("PRODUCT_UUID");
                        String categoryNm = rs.getString("CATEGORY_NM");
                        String productName = rs.getString("PRODUCT_NAME");
                        String drinkTemp = rs.getString("DRINK_TEMP");
                        int price = rs.getInt("PRODUCT_PRICE");
                        int quantity = rs.getInt("PRODUCT_QUANTITY");
                %>
                <tr>
                    <td><%= productName %></td>
                    <td><%= categoryNm %></td>
                    <td><%= drinkTemp %></td>
                    <td><%= price %></td>
                    <td><%= quantity %></td>
                    <td>
                        <button style="background: #ff0000; color:#fff; border:2px solid #ff0000;" onclick="productEdit('<%= productUuid %>');">수정</button>
                        <button style="background: #ff00ff; color:#fff; border:2px solid #ff00ff;" onclick="productDel('<%= productUuid %>');">삭제</button>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>	
</body>
</html>

<%
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
%>