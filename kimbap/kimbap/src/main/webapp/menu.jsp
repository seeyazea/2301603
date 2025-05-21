<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴 선택</title>
<style>
	#menuArea {
		text-align: center;
		margin: 20px 0;
	}
	#menuArea ul {
		list-style: none;
		padding: 0;
		display: flex;
		justify-content: center;
		gap: 15px;
	}
	#menuArea li {
		display: inline-block;
	}
	#menuArea a {
		text-decoration: none;
		padding: 10px 20px;
		background-color: #f4a460;
		color: #fff;
		border-radius: 8px;
		font-weight: bold;
	}
	#menuArea a:hover {
		background-color: #d2691e;
	}
</style>
<script>
	function goMenu(categoryCd) {
		var frm = document.getElementById("frmMenu");
		frm.categoryCd.value = categoryCd;
		frm.submit();
	}
</script>
</head>
<body>
	<form id="frmMenu" name="frmMenu" method="get" action="product.jsp">
		<input type="hidden" id="categoryCd" name="categoryCd">
	</form>

	<nav id="menuArea">
		<ul>
			<li><a href="#" onclick="goMenu('01');">김밥류</a></li>
			<li><a href="#" onclick="goMenu('02');">분식류</a></li>
			<li><a href="#" onclick="goMenu('03');">식사류</a></li>
			<li><a href="#" onclick="goMenu('04');">돈까스류</a></li>
		</ul>
	</nav>
</body>
</html>
