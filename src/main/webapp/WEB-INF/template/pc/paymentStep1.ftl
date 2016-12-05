<!DOCTYPE html>
<html>
		
<#include "userCenter-base.ftl">

<@htmlHead title="提交订单">
</@htmlHead>
<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/index.css" />
	
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
					<li><a href="#" class="circle">2</a><a href="#" class="text">微信支付</a></li>
					<li><a href="#" class="circle">3</a><a href="#" class="text">购买成功</a></li>

				</ul>
			</div>
			
			<div class="stepOne">
				<div class="info">
					<p>
						<span id="topicName">券名称：</span>
						<span>数量：</span>${number}
					</p>
					
					<p>
						应付金额：<span class="price"></span>元
					</p>
				</div>
				<ul class="method">
					<li>
						<input type="radio" name="payment" checked />
						<img src="${buyer_portal_static_resources_domain}/img/pc/weixinPay.png" />
					</li>
				</ul>
			</div>
			
			<div class="topay">
				<p>
					支付：<span class="price"></span>元
				</p>
				<input class="topaybtn" id="topaybtn" type="button" name="topay" value="提交订单"/>
				<input type="hidden" id="order_token" value="">
				<input type="hidden" id="order_topicid" value="">
			</div>
			 
		</section>
		
		<!--领取成功弹出框 开始-->
		<section id="member_popbox" class="popbox">
			<div class="popboxin">
				<header>提示信息<a class="close"></a></header>
				<div class="content green">
					<img src="${buyer_portal_static_resources_domain}/img/pc/smile.png" />
					<div class="text">
						<p>恭喜您，</p>
						<p>优惠券领取成功！</p>
					</div>
					<a href="${buyer_portal_domain}/view/web/usercenter/ticket">查看我领的券</a>
				</div>
			</div>
		</section>
		<!--领取成功弹出框 结束-->
		
		<!--会员才能领取的弹出框 开始--> 
		<section id="member_login_popbox" class="popbox">
			<div class="popboxin">
				<header>提示信息<a class="close"></a></header>
				<div class="content orange">
					<img src="${buyer_portal_static_resources_domain}/img/pc/cry.png" />
					<div class="text">
						<p>抱歉，</p>
						<p>此优惠券需要橙e网注册用户才可领取，</p>
						<p><a href="#">请登录/注册橙e网！</a></p>
					</div> 
				</div>
			</div>
		</section>
		<!--会员才能领取的弹出框 结束--> 
		
		<!--领卷失败的弹出框 开始--> 
		<section id="error_popbox" class="popbox">
			<div class="popboxin">
				<header>提示信息<a class="close"></a></header>
				<div class="content orange">
					<img src="${buyer_portal_static_resources_domain}/img/pc/cry.png" />
					<div id="error_text" class="text">
					</div> 
				</div>
			</div>
		</section>
		<!--领卷失败的弹出框 结束--> 
		
		<!--游客领取成功的弹出框 开始--> 
		<section id="guest_popbox" class="popbox">
			<div class="popboxin">
				<header>提示信息<a class="close"></a></header>
				<div class="content visitor">
					<img src="${buyer_portal_static_resources_domain}/img/pc/naugthty.png" />
					<div class="text">
						<p>恭喜您，领取成功！</p>
						<p>请记录券码或下载二维码！</p>
						<p>券号：<span id="couponCode"></span></p>
					</div>
					<div class="QCcode">
						<img src="#" id="qrcodeImage"/>
					 	<p><a href="#" id="download" >下载</a></p>
					</div>
					
				</div>
			</div>
		</section>
		<!--游客领取成功的弹出框 结束--> 
		
			<script type="text/javascript">
				//生成二维码
				function createQRCode(code){
					var imageUrl = "${buyer_portal_domain}/view/user/qrcode.htm?content="+code;
					var downloadUrl = "${buyer_portal_domain}/view/user/qrcode.htm?download=yes&content="+code;
					$("#qrcodeImage").attr("src",imageUrl);
					$("#download").attr("href",downloadUrl);
				}
				
				$(function(){
					getPaymentInfo();
					$(".popbox .close").click(function(){
			    		$(".popbox").hide();
			    		location.href = "${buyer_portal_domain}/view/cpnweb/cpnDetail?topicId=${topicId}";
			    	})
					$("#topaybtn").click(function(){
						$("#topaybtn").attr("disabled", true);
						var order_topicid = $("#order_topicid").val();
						var order_token = $("#order_token").val();
						$.get("${buyer_portal_domain}/view/order/create",{topicid:order_topicid,token:order_token,ts:new Date()},
							function(data){
								$("#topaybtn").removeAttr("disabled");
								var ret = $.parseJSON(data);
								if(ret.needPay){
									if(ret.resultCode == "success"){//购卷成功
										location.href = "${buyer_portal_domain}/view/web/payment_step2.htm?orderid="+ret.orderid+"&codeUrl="+ret.codeUrl;
									}else{//验卷未通过
										$("#error_text").html(ret.errorMsg);
										$("#error_popbox").show();
									}
								}else{
									if(ret.resultCode == "success" && ret.orderid != ""){//会员领卷成功
										$("#member_popbox").show();
										setTimeout(function(){
											location.href = "${buyer_portal_domain}/view/web/usercenter/ticket";
										}, 3000);
									}else if(ret.resultCode == "success" && ret.orderid == ""){//游客领卷成功
										$("#couponCode").html(ret.couponCode.replace(/(\d{4})/g,'$1 ').replace(/\s*$/,''));
										createQRCode(ret.couponCode);
										$("#guest_popbox").show();
									}else{//免费卷领取失败
										$("#error_text").html(ret.errorMsg);
										$("#error_popbox").show();
									}
								}
						   	}
						);
					});
				});
				
				function getPaymentInfo(){
					$.get("${buyer_portal_domain}/view/user/paymentinfo.htm",{topicId:${topicId},ts:new Date()},
						function(data){
							var ret = $.parseJSON(data);
							if(ret.number == 1){
								$("#topicName").text("券名称：" + ret.topicName);
								$(".price").text(ret.price);
								$("#order_token").val(ret.token);
								$("#order_topicid").val(ret.topicId);
							}
					   	}
					);
				}
			</script>
		 
</#escape>		
</@htmlBody>

</html>
