<!DOCTYPE html>
<html style="font-size: 36px;">

<#include "base.ftl">

<@htmlHead title="订单确认">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<div class="orderDetail">
		    <div class="popCE">
				  <span></span>
			</div>
			<div class="title bgF6">
				<p>商品名称：${order.topicName}</p>
				<p>商品数量：1</p>
				<p>订单总价：${order.price}元</p>
			</div>
			<div class="head">
				支付方式
			</div>
			<div class="content bgF6border">
				<ul>
					<li>
						<div class="radio3">
							<input type="radio" id="reason1" name="reason" checked="checked">
							<label for="reason1"></label>
						</div>
						<span>
							微信支付
						</span>
					</li>
				</ul>
				<div class="tips">
					<p>请在<span class="text-orange">15分钟</span>内完成<span class="text-orange">支付</span>！</p>
					<p>如需发票请自提时索取哦！</p>
				</div>
			</div>
			<input type="button" id="sendEvaluate" name="sendEvaluate" value="提交订单" class="btn100" />
			<input type="button" id="repaybtn" class="btn100" style="display: none;" />
		</div>
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
		<script>
			$(function(){
				
				$("#sendEvaluate").click(function(){
					$(this).attr("disabled","disabled");
					$(this).val("提交中");
					$.get("${buyer_weixin_domain}/view/order/create?token=${order.token}&topicid=${order.topicid}&ts="+new Date(), 
				  		function(result){
					   		var data = $.parseJSON(result);
					   		if(data.resultCode=='success'){
					   			//需要支付的情况
				   				if(data.needPay){
				   					callWeixinPay(data.jsparams,data.orderid);
				   					$("#repaybtn").click(function(){
				   						callWeixinPay(data.jsparams,data.orderid);
				   					});
				   				//免费券
				   				}else{
				   					redirectToResultPage(data.orderid);
				   				}	
					   		}else{
					   			$("#sendEvaluate").val("提交订单失败");
					   			createOrderFailed(data.errorMsg);
					   		}
				    });
				});
			});
			 
			function callWeixinPay(params,orderid){
				wx.chooseWXPay({
				    timestamp: params.timestamp, 
				    nonceStr: params.nonceStr, 
				    package: params.packageStr, 
				    signType: params.signType, 
				    paySign:  params.paySign, 
				    success: function (res) {
				    	redirectToResultPage(orderid);
				    },
   				    cancel:function(res){
   				    	payFailed();
   				    	redirectToResultFail(orderid);
   				    },
	   				fail:function(res){
	   					payFailed();
	   					redirectToResultFail(orderid);
	   				}
				});
			}
			
			
			//  			
			function redirectToResultFail(orderid){
				setTimeout(function(){
					window.location = "${buyer_weixin_domain}/view/weixin/orderquerynotice?orderid="+orderid;
				},500);
			}
			
			function redirectToResultPage(orderid){
				setTimeout(function(){
					window.location = "${buyer_weixin_domain}/view/weixin/orderquery?orderid="+orderid;
				},500);
			}
			
			function createOrderFailed(errorMsg){
				$(".popCE").slideDown();
				$(".popCE span").text(errorMsg);
			}
			
			function payFailed(){
				$("#sendEvaluate").hide();
				$("#repaybtn").val("支付失败,请点击重试");
				$("#repaybtn").show();
			}
	    </script>
	    </#escape>
</@htmlBody>
</html>