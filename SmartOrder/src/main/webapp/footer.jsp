<%@ page import="java.text.DecimalFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp" %>
<%@ include file="dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script>
        function delCart(cartUuid) {
            var frm = document.getElementById("frmCartDel"); 
            frm.processType.value = "P";
            frm.cartUuid.value = cartUuid; 
            frm.submit();
        }

        function delCartAll() {
            var frm = document.getElementById("frmCartDel");
            frm.processType.value = "A";
            frm.submit();
        }

        function processPayment() {
            if(confirm("결제 하시겠습니까?")) {
                var frm = document.getElementById("frmPay");
                frm.submit();
            }
        }

        function updateQuantity(cartUuid, action) {
            var frm = document.getElementById("frmCartDel");
            frm.processType.value = "U"; // 수량 업데이트 처리
            frm.cartUuid.value = cartUuid;
            frm.action = "updateCartQty.jsp"; // 수량 업데이트 처리를 위한 JSP로 전송
            if(action === 'increment') {
                frm.quantity.value = parseInt(frm.quantity.value) + 1; // 수량 1 증가
            } else if(action === 'decrement' && frm.quantity.value > 1) {
                frm.quantity.value = parseInt(frm.quantity.value) - 1; // 수량 1 감소
            }
            frm.submit();
        }
    </script>
    <style>
        /* 레이아웃 스타일 */
        .cartProduct {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 20px;
            text-align: center;
        }
        .cartProductImg {
            width: 100px;
            height: 100px;
            margin-bottom: 10px;
        }
        .cartProductImg img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .cartProductDetails {
            width: 100%;
        }
        .cartProductName {
            font-weight: bold;
            font-size: 14px; /* 글자 크기 줄임 */
            margin-bottom: 5px;
        }
        .cartProductPrice {
            font-size: 12px; /* 글자 크기 줄임 */
            margin-bottom: 5px;
        }
        .cartProductQuantity {
            font-size: 12px; /* 글자 크기 줄임 */
            margin-bottom: 5px;
        }
        .quantityButtons {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 5px;
        }
        .quantityButtons button {
            width: 30px;
            height: 30px;
            margin: 0 5px;
            font-size: 16px;
            cursor: pointer;
        }
        .cartProductDel {
            cursor: pointer;
            color: red;
            font-size: 16px; /* X 버튼 크기 */
            font-weight: bold;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <%
        DecimalFormat df = new DecimalFormat("###,###");
        String sCategoryCd = request.getParameter("categoryCd");
    %>
    <form id="frmCartDel" name="frmCartDel" method="post" action="cartDel.jsp">
        <input type="hidden" id="shopDeviceId" name="shopDeviceId" value="<%=sShopDeviceId%>">
        <input type="hidden" id="categoryCd" name="categoryCd" value="<%=sCategoryCd%>">
        <input type="hidden" id="cartUuid" name="cartUuid" value="">
        <input type="hidden" id="processType" name="processType" value="">
        <input type="hidden" id="quantity" name="quantity" value="">
    </form>
    <form id="frmPay" name="frmPay" method="post" action="paySave.jsp">
    </form>
    <div class="footer">
        <div class="cartList">
            <ul>
                <%
                    long lTotPrice = 0;
                    ResultSet rs = null;
                    PreparedStatement pstmt = null;
                    try {
                        StringBuffer sql = new StringBuffer();
                        sql.append("SELECT A.CART_UUID, A.SHOP_DEVICE_ID, A.SHOP_UUID, A.PRODUCT_UUID\n");
                        sql.append(" , A.QUANTITY, A.DRINK_TEMP\n");
                        sql.append(" , B.CATEGORY_CD, B.PRODUCT_NAME, B.PRODUCT_PRICE\n");
                        sql.append(" FROM cart A\n");
                        sql.append(" INNER JOIN product B\n");
                        sql.append(" ON A.PRODUCT_UUID = B.PRODUCT_UUID\n");
                        sql.append(" WHERE A.shop_uuid = ?\n");
                        sql.append(" AND A.shop_device_id = ?\n");
                        sql.append(" ORDER by A.reg_dt ASC");
                        System.out.println(sql.toString());
                        pstmt = conn.prepareStatement(sql.toString());
                        pstmt.setString(1, sShopUuid);
                        pstmt.setString(2, sShopDeviceId);
                        rs = pstmt.executeQuery();
                        int iResult = 0;
                        while (rs.next()) {
                            long productPrice = rs.getLong("PRODUCT_PRICE");
                            long quantity = rs.getLong("QUANTITY");
                            lTotPrice += productPrice * quantity;
                            String sCartUuid = rs.getString("CART_UUID");
                            String productName = rs.getString("PRODUCT_NAME");
                            String productPriceFormatted = df.format(productPrice);
                %>
                <li>
                    <div class="cartProduct">
                        <div class="cartProductImg">
                            <img src="./image/coffee1.png">
                        </div>
                        <div class="cartProductDetails">
                            <div class="cartProductName"><%= productName %></div>
                            <div class="cartProductPrice">가격: &#8361; <%= productPriceFormatted %></div>
                            <div class="cartProductQuantity">수량: <%= quantity %></div>
                            <div class="quantityButtons">
                                <button type="button" onclick="updateQuantity('<%= sCartUuid %>', 'decrement')">-</button>
                                <button type="button" onclick="updateQuantity('<%= sCartUuid %>', 'increment')">+</button>
                            </div>
                        </div>
                        <div class="cartProductDel" onclick="delCart('<%=sCartUuid%>');">
                            X
                        </div>
                    </div>
                </li>
                <%
                            iResult++;
                        } // end While
                        if (iResult == 0) {
                %>
                <li>
                    <div class="cartProduct">
                        <div class="cartProductImg">
                            <img src="./image/coffee1.png">
                        </div>
                        <div class="cartProductDetails">
                            <div class="productName">장바구니가 비어 있습니다.</div>
                        </div>
                    </div>
                </li>
                <%
                        }
                    } catch (SQLException ex) {
                        out.println("Product 테이블 호출이 실패했습니다.<br>");
                        out.println("SQLException: " + ex.getMessage());
                    } finally {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </ul>
        </div>

        <!-- 하단 결제 버튼 -->
        <div class="amount">
            <div class="lblPayTxt">
                <label style="width: 100%; color: #FFF200">총결제금액</label>
            </div>
            <div class="lblPayAmountTxt">
                <label id="amountLbl">&#8361; <%= df.format(lTotPrice) %></label>
            </div>
            <div class="lblPayCancel">
                <label style="width: 100%; color: #FFFA99; cursor: pointer;" onclick="delCartAll();">전체취소</label>
            </div>
        </div>
        <!-- 하단 결제 버튼 -->
        <div class="pay" onclick="processPayment()">
            <label>결제</label>
        </div>
    </div>
</body>
</html>
