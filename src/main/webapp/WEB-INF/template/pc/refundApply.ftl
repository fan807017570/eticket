<!DOCTYPE html>
<html>

<#include "userCenter-base.ftl">

<@htmlHead title="退款申请">
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
				<li class="active">
					<a href="${buyer_portal_domain}/view/web/usercenter/ticket">我领的券</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/hongbao">我的红包</a>
				</li>
				<li>
					<a href="${buyer_portal_domain}/view/web/usercenter/notice">我的通知</a>
				</li> 
			</ul>
		</div>
		<!--导航部分 结束-->
	</section>

		<section class="userCenter width1000">
			<div class="left navleft">
				<header>我的橙e券</header>
				<ul>
					<li class="active">
						<a href="${buyer_portal_domain}/view/web/usercenter/ticket">我领的券（<span class="v_coupon">0</span>）</a>
					</li>
					<li>
						<a href="${buyer_portal_domain}/view/web/usercenter/hongbao">我的红包（<span class="v_hongbao">0</span>）</a>
					</li>
					<li>
						<a href="${buyer_portal_domain}/view/web/usercenter/notice">我的通知（<span class="v_notice">0</span>）</a>
					</li>
				</ul>
			</div>
			<div class="right refund">
				<div class="title">申请退款</div>
				<div class="content">
					<form name="" action="">
						<div class="items">
							<label>退款金额：</label>
							<div class="inputs">
								￥${couponPrice}元
							</div>
						</div>
						<div class="items">
							<label><span>*</span>退款原因：</label>
							<div class="inputs">
								<p>为了帮我们做的更好，请提交您的退款原因</p>
								<div class="radios">
									<#if dicts?exists>
										<#list dicts?keys as k> 
											<div class="item">
												<input type="radio" name="reason" value="${k}"> ${dicts[k]}
											</div>
										</#list>
									</#if>
								</div>
								<p class="opps">请选择退款原因</p>
							</div>
						</div>
						<div class="items">
							<label>退款方式：</label>
							<div class="inputs">
								原路退回（3-10个工作日完成，暂不收手续费）
							</div>
						</div>

						<div class="items">
							<label>&nbsp;</label>
							<div class="inputs">
								<input class="topaybtn" id="applyRefund" type="button" name="topay" value="申请退款" />
							</div>
						</div>
					</form>
				</div>

			</div>
		</section>

	<script type="text/javascript">
		$(function() {
			queryStatistics();
			$(".opps").hide();
			$('#applyRefund').click(function(event) {
				$(".opps").hide();
				if($('input:radio:checked').length > 0) {
					var reasonKey = $('input:radio:checked').val();
					window.location = "${buyer_portal_domain}/view/web/refund_apply_save.htm?couponId=${couponId}&reasonKey=" + reasonKey;
				}else{
					$(".opps").show();
				}
			});
		});
		
		function queryStatistics() {
			var loadDataUrl = "${buyer_portal_domain}/view/user/statistics?ts="+new Date();
		  	$.get(loadDataUrl, function(result){
				var data = $.parseJSON(result);
			   	if(data.statistics) { 

			   		$('.v_coupon').html(data.statistics.unused+data.statistics.used+data.statistics.expired+data.statistics.refund);
			   		$('.v_hongbao').html(data.statistics.received+data.statistics.sended);
			   		$('.v_notice').html(data.statistics.notice);

			   	}
		  	});
	  	};
	</script>
	</#escape>
</@htmlBody>

</html>