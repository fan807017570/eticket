<!DOCTYPE html>
<html style="font-size: 36px;">
	<head>
		<meta charset="utf-8" />
		<title>橙e绑定</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style-vesion1.0.css" />
        <script src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" type="text/javascript"></script>
         <script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/rsa/Barrett.js"></script>
		 <script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/rsa/BigInt.js"></script>
		 <script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/rsa/RSA.js"></script>
		 <script type="text/javascript" src="${buyer_portal_static_resources_domain}/js/init.js" ></script>
	</head>
	<body>
	<#escape x as x?html>
		<div class="CEbanding">
			<header class="public_header">
				绑定平安银行橙e网账户
			</header>
			<form name="login" action="${buyer_weixin_domain}/view/weixin/bindUpdate"  onsubmit="return check_form(this)" method="GET">
			<div class="CE-form">
				<div class="item">
					<label class="icon icon-user"></label>
					<input type="text" name="username" value="" id="username" placeholder="橙e账户"/>
					<div class="close"></div>
				</div>
				<div class="item">
					<label class="icon icon-pass"></label>
					<input type="password" name="password" value="" id="password" placeholder="密码"/>
					<div class="close"></div>
				</div>
			</div>
		 
			<a class="forgotten" href="${bind_forget_pwd_url}" >忘记密码</a>
			<div class="buttons">
				<input type="button" value="注册" class="orange" onclick="reg()"/>
				<input type="submit" id="sub" value="提交" class="orange"/>
			</div>
			 
			</form>
			<div class="CE-tips">
				<span class="icon icon-tips"></span>
				<p>橙e绑定界面</p>
				<p>绑定橙e网，您可以尊享以下权利：</p>
				<p>1、获得平安员工可享受的更多更低优惠及折扣资格;</p>
				<p>2、获得优先购买平安银行限额发行的超值理财产品资格。</p>
			</div>
			<div class="bottom1" align="center">
				<img src="${buyer_portal_static_resources_domain}/img/pingan_logo.png" style="height:120px;width:auto;"/>
			</div>
		</div>
		</#escape>
	</body>
	
	<!--  -->
	<script type="text/javascript">
			//验证该用户是否已经绑定提示
			$(document).ready(function(){
			var isBind = "${isBind!}";
			
			if(isBind!=null && isBind=="Y"){
				var ceName = "${ceName!}";
				var wxImgUrl = "${wxImgUrl!}";
// 				alert("您已绑定，请勿重复绑定！橙E帐号为："+ceName);
				$("#sub").attr("class","gray");
				$("#sub").attr("disabled","disabled");
				window.location="${buyer_weixin_domain}/view/weixin/bindSucc?ceName="+ceName+"&wxImgUrl="+wxImgUrl;
			}
			
			
			//未获取到微信用户信息
			var userError = "${userError!}";
			if(userError!=null && userError!=""){
				alert(userError);
				$("#sub").attr("class","gray");
				$("#sub").attr("disabled","disabled");
			}
			
			
			//绑定结果
			var bindStatus = "${bindStatus!}";
			if(bindStatus!=null && bindStatus=="SUCC"){
				var ceName = "${ceName!}";
				var wxImgUrl = "${wxImgUrl!}";
				window.location="${buyer_weixin_domain}/view/weixin/bindSucc?ceName="+ceName+"&wxImgUrl="+wxImgUrl;
// 				alert("恭喜，绑定橙E账户成功！");	
			}else if(bindStatus!=null && bindStatus=="FAIL"){
					var errorMsg =  "${errorMsg!}";
					if(errorMsg!=null && errorMsg!=""){
						alert(errorMsg);
					}
			}
			
		});
	
	

	
		function reg(){
			window.location.href="${bind_register_url}";
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
				if(validate_required(username,"请输入橙E账户")==false){
					username.focus;
					return false;
				}else if(validate_required(password,"请输入密码")==false){
					password.focus;
					return false;
				}
				encodePWD();
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
		var enpwd = document.getElementById("password").value;
		var raw = encryptedString(key,enpwd);
		document.getElementById("password").value = raw;
	}
	</script>
</html>
