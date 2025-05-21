<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<nav id="menuArea">
		<form id="frmMenu" name="frmMenu" method="post" action="product.jsp">
			<input type="hidden" id="categoryCd" name="categoryCd">
			<ul>
				<li><a href="#" onclick="goMenu('01');">COFFEE</a></li>
				<li><a href="#" onclick="goMenu('02');">NON COFFEE</a></li>
				<li><a href="#" onclick="goMenu('03');">ADE</a></li>
				<li><a href="#" onclick="goMenu('04');">SMOOTHIE</a></li>
			</ul>
			
	</form>
	</nav>

	<script>
		function goMenu(categoryCd) {
			var frm = document.getElementById("frmMenu");
			frm.categoryCd.value = categoryCd;
			frm.submit();
		}
	</script>
</body>
</html>