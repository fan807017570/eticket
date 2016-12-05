<!DOCTYPE html>
<html>

<#include "userCenter-base.ftl">

<@htmlHead title="支付成功">
</@htmlHead>
	
<@htmlBody>
<#escape x as x?html>
	<section class="navAndbanner">
		<!--导航部分 开始-->
		<div class="nav">
			<ul class="width1000">
				<li>
					<a href="${buyer_portal_domain}/">橙e券首页</a> 
				</li>
				<!--<li class="active">
					<a href="${buyer_portal_domain}/view/web/ticket">我领的券</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/hongbao">我的红包</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/notice">我的通知</a>
				</li> -->
			</ul>
		</div>
		<!--导航部分 结束-->
	</section>

		<section class="payment width1000">
			<div class="steps">
				<ul>
					<li class="active"><a href="#" class="circle">1</a><a href="#" class="text">提交订单</a></li>
					<li class="active"><a href="#" class="circle">2</a><a href="#" class="text">微信支付</a></li>
					<li class="active"><a href="#" class="circle">3</a><a href="#" class="text">购买成功</a></li>

				</ul>
			</div>

			<div class="stepThree">
				<div class="paymentSuccess">
					<img src="${buyer_portal_static_resources_domain}/img/pc/success.png">
					<p>恭喜您，支付成功！</p>
					<a href="#" class="btn">3秒后，进入我领的券</a>
					<a href="#" class="return">返回</a>
				</div>
			</div>

		</section>
		
		<script type="text/javascript">
			//设置超时时间为3秒钟
		    var timeout = 3;
		    function show() {
	          	$(".btn").html(timeout + "秒后，进入我领的券");
	          	if (timeout == 0) {
	             	window.location.href = "${buyer_portal_domain}/view/web/usercenter/ticket";
		        }else {
		            setTimeout("show()", 1000);
		        }
		        timeout--;
		    }
		    $(function(){
		    	show();
		    });
    	</script>
</#escape>
</@htmlBody>

</html>