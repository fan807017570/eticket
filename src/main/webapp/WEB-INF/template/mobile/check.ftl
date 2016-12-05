<!DOCTYPE html>
<html style="font-size: 36px;">
	<head>
		<meta charset="utf-8" />
		<title>身份验证</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
               <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style-vesion1.0.css" />
       
         <script src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	</head>
	<body>
	<#escape x as x?html>
		<div class="CEbanding">
			<header class="public_header">
				平安员工身份验证
			</header>
			<form name="login" action="${buyer_weixin_domain}/view/weixin/sendMail" onsubmit="return check_form(this)"  method="get">
				<div class="CE-form">
					<div class="item"> 
						<label class="icon icon-user"></label>
						<input type="text" name="umAccount"  value="" id="umAccount" placeholder="UM帐号"/>
						<div class="close"></div>
					</div> 
				</div> 
				<div class="buttons">
					<input type="submit" id="sub" value="去验证" class="orange"/>
				</div>
			 
			</form>
		</div>
		
		
		<script type="text/javascript">
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
				if(validate_required(umAccount,"请输入UM帐号")==false){
					umAccount.focus;
					return false;
				}
			}
		}
		
		
		$(function(){
			$(".close").click(function(){
				$(this).siblings("input").val(""); 
			})
		});
		
		
		
		//验证是否已绑定
		
		$(document).ready(function(){
			var isCheck = "${isCheck!}"
			if(isCheck!=null && isCheck=="Y") {
				var umAccount = "${umAccount!}";
				alert("您的帐号已通过UM验证，请勿重复验证!UM号为："+umAccount);
				$("#sub").attr("class","grayCenter");
				$("#sub").attr("disabled","disabled");
			}

			//未获取到微信用户信息
				var userError = "${userError!}";
				if(userError!=null && userError!=""){
					alert(userError);
					$("#sub").attr("class","grayCenter");
					$("#sub").attr("disabled","disabled");
				}
	
		});
		
		
		//验证发送状态
		$(document).ready(function(){
			var sendResult = "${result!}";
			if(sendResult!=null && sendResult=="FAIL"){
				var errorMsg =  "${errorMsg!}";
				alert(errorMsg);
			}else if(sendResult!=null && sendResult=="SUCC"){
				var succMsg = "${succMsg!}";
				alert(succMsg);
				}			
		});
		
		
		</script>

	</#escape>
	</body>
</html>
