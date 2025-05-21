<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="globalVar.jsp"%>
<%@ include file="dbconn.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 추가</title>
    <link href="style.css" rel="stylesheet" type="text/css">
    <script>
        // 폼 제출 전에 입력값 체크
        function save() {
            var frm = document.getElementById("frmProductSave");
            if (frmChk()) {
                frm.action = "productSaveMag.jsp";  // 상품 저장 처리 페이지로 POST 요청
                frm.submit();
            }
        }

        // 입력값 체크 함수
        function frmChk() {
            var frm = document.getElementById("frmProductSave");

            if (frm.categoryCd.value == "") {
                alert("카테고리를[을] 선택해주세요.");
                frm.categoryCd.focus();
                return false;
            }
            if (frm.productName.value == "") {
                alert("상품명를[을] 입력해주세요.");
                frm.productName.focus();
                return false;
            }
            if (frm.drinkTemp.value == "") {
                alert("음료온도를[을] 선택해주세요.");
                frm.drinkTemp.focus();
                return false;
            }
            if (frm.productPrice.value == "") {
                alert("가격를[을] 입력해주세요.");
                frm.productPrice.focus();
                return false;
            }
            if (frm.productQuantity.value == "") {
                alert("수량를[을] 입력해주세요.");
                frm.productQuantity.focus();
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <jsp:include page="header.jsp" flush="true" />
    <section>
        <jsp:include page="menuMag.jsp" flush="true" />
    </section>

    <h2 class="order_mg" style="text-align: center; margin: 20px 0; font-size: 1.5rem; font-weight: bold;">
        상품 추가
    </h2>

    <!-- 상품 추가 폼 -->
    <form id="frmProductSave" name="frmProductSave" action="" method="post" onsubmit="return false;">
        <input type="hidden" id="actionMothod" name="actionMothod" value="I">
        
        <table class="product-table" border="1" style="width: 40%; margin: 0 auto;">
            <tr>
                <td>카테고리</td>
                <td>
                    <select id="categoryCd" name="categoryCd">
                        <option value="">선택</option>
                        <option value="01">Coffee</option>
                        <option value="02">NonCoffee</option>
                        <option value="03">Ade</option>
                        <option value="04">Smoothie</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>상품명</td>
                <td><input type="text" id="productName" name="productName" maxlength="50" style="width: 50%;" required></td>
            </tr>
            <tr>
                <td>음료온도</td>
                <td>
                    <select id="drinkTemp" name="drinkTemp">
                        <option value="">선택</option>
                        <option value="H">HOT</option>
                        <option value="I">ICE</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>가격</td>
                <td><input type="text" id="productPrice" name="productPrice" maxlength="10" style="width: 50%;" required></td>
            </tr>
            <tr>
                <td>수량</td>
                <td><input type="text" id="productQuantity" name="productQuantity" maxlength="5" style="width: 50%;" required></td>
            </tr>
            <tr>
                <td>설명</td>
                <td><textarea id="productDesc" name="productDesc" style="width: 100%; height: 100px;"></textarea></td>
            </tr>
            <tr>
                <td>정렬순서</td>
                <td><input type="text" id="productSort" name="productSort" maxlength="3" style="width: 50%;"></td>
            </tr>
        </table>
        
        <div style="text-align: center; margin-top: 20px;">
            <input type="submit" onclick="save();" value="저장" style="background: #0000ff; color: #fff; border: 2px solid #0000ff; padding: 10px 20px;">
            <input type="reset" value="취소" style="background: #ff0000; color: #fff; border: 2px solid #ff0000; padding: 10px 20px;">
        </div>
    </form>
</body>
</html>
