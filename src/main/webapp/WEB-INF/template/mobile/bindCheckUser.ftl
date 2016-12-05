<!DOCTYPE html>
<html style="font-size: 36px;">
	<head>
		<meta charset="utf-8" />
		<title>验券员绑定</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style-vesion1.0.css" />

        <script src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" type="text/javascript"></script>
        <script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/rsa/Barrett.js"></script>
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/rsa/BigInt.js"></script>
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/rsa/RSA.js"></script>
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	</head>
	<body>
	<#escape x as x?html>
		<div class="CEbanding">
			<header class="public_header">
				验券员绑定
			</header>
			<form id="bingdForm" name="bingdForm" action="${buyer_weixin_domain}/view/weixin/checkcpn">
			</form>
			<div class="CE-form">
				<div class="item">
					<label class="icon icon-user"></label>
					<input type="text" name="username" id="username" placeholder="登录账户"/>
					<div class="close"></div>
				</div>
				<div class="item">
					<label class="icon icon-pass"></label>
					<input type="password" name="password" id="password" placeholder="密码"/>
					<div class="close"></div>
				</div>
			</div>
		 
			<div class="buttons">
				<input type="button" value="绑定" class="orange" onclick="submitBingd();"/>
				<input type="hidden" id="userid" value="${userid}"/>
			</div>
		</div>
		</#escape>
	</body>
	
	<!--  -->
	<script type="text/javascript">
		$(document).ready(function(){
			
		});
			
		function submitBingd(){
			var bool = false;
			var username = $("#username").val();
			var password = $("#password").val();
			var userid = $("#userid").val();
			if(username==""||username==null){
				alert("请输入验券员帐号");
				return false;
			}
			if(password==""||password==null){
				alert("请输入密码");
				return false;
			}
			password = encodePWD();
			$.ajax({  
	            url:"${buyer_weixin_domain}/view/coupon/bindCheckUser",  
	            type:"POST",  
	            datatype:"json",
	            async:true,
	            data:{"username":username,"password":password,"userid":userid}, 
	            beforeSend:function(request){
		        	$(".orange").attr({"disabled":"disabled"});
		        },
	            success:function(data) {
	            var obj = new Function("return" + data)();
	            	if(obj.result=='1'){
	            		alert("用户不存在！");
	            	}else if(obj.result=='2'){
	            		alert("用户被禁用！");
	            	}else if(obj.result=='3'){
	            		alert("该用户不是验券员！");
	            	}else if(obj.result=='4'){
	            		alert("密码错误！");
	            	}else if(obj.result=='5'){
	            		alert("该微信已绑定帐号！");
	            	}else if(obj.result=='0'){
	            		alert("绑定验券员成功！");
	            		bool = true;
	            		$("#bingdForm").submit();
	            	}else{
	            		alert("绑定失败！");
	            	}  
	            	$(".orange").removeAttr("disabled");//将按钮可用
	            },  
	            error:function(data){
	                alert("绑定失败");
	                $(".orange").removeAttr("disabled");//将按钮可用
	            }  
	        });
// 			if(bool == true){
// 				$("#bingdForm").submit();
// 			}
		}
		
		function validate_required(field,alerttxt){
			with(field){
				if(value=="" || value==null){
					alert(alerttxt);
					return false;
				}else {
					return true;
				}		
			}
		}
			
		function check_form(thisform){
			with(thisform){
				if(validate_required(username,"请输入登录账户")==false){
					username.focus;
					return false;
				}else if(validate_required(password,"请输入密码")==false){
					password.focus;
					return false;
				}
			}
		}

		
		
	$(function(){
				$(".close").click(function(){
					$(this).siblings("input").val(""); 
				})
			});
	
	var RSAPublicKey ="${eticket_rsa_public_key}"; 
	function bodyRSA(){
		setMaxDigits(130);
	  	return new RSAKeyPair("10001","",RSAPublicKey); 
	}
	function encodePWD(){
		var key = bodyRSA();
		var enpwd = $("#password").val();
		var raw = encryptedString(key,enpwd);
		return raw;
	}
	</script>
</html>
