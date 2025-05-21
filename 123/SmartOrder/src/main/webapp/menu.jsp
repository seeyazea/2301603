<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
</style>
<title>Insert title here</title>
<script>
	function goMenu(categoryCd) {
		var frm = document.getElementById("frmMenu");
		frm.categoryCd.value = categoryCd;
		frm.submit();
	}
</script>
</head>
<body>
	<form id="frmMenu" name="frmMenu" method="post" action="product.jsp">
		<input type="hidden" id="categoryCd" name="categoryCd">
		<nav id="menuArea">
			<ul>
				<li><a href="#" onClick="goMenu('01');">COFFEE</a></li>
				<li><a href="#" onClick="goMenu('02');">NON COFFEE</a></li>
				<li><a href="#" onClick="goMenu('03');">ADE</a></li>
				<li><a href="#" onClick="goMenu('04');">SMOOTHIE</a></li>
			</ul>
		</nav>
	</form>
</body>

</html>