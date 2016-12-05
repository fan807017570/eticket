<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>UM验证结果</title>
		        <script src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" type="text/javascript"></script>
		        <script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	</head>
	<body>
	<#escape x as x?html>
	<script>
		$(document).ready(function(){
			var result = "${result}";
			$("#result").after(result);
			//alert(result);
		});
	</script>
		<p id="result"></p>
	</body>
	</#escape>
</html>
