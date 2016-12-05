<!DOCTYPE html>
<html style="font-size: 36px;">

<#include "base.ftl">

<@htmlHead title="申请退款">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<div class="refund">
		
		<div class="title bgF6border">${couponName}</div>
		<div class="fund bgF6">
			<span>退款金额</span>
			<span>￥${couponPrice}元</span>
		</div>
		<div class="head">
			退款方式
		</div>
		<div class="content bgF6border">
			<p>原数退回</p>
			<p>3-10个工作日完成，暂不收手续费</p>
		</div>
		<div class="head">
			退款原因
		</div>
		<div class="content bgF6border">
			<ul>
				<#list refundReason?keys as reasonKey>
				<li>
					<span>
						${refundReason[reasonKey]}
					</span>
					<div class="radio2">
						<input type="radio" id="${reasonKey}" value="${reasonKey}" name="reason">
						<label for="${reasonKey}"></label>
					</div>
				</li>
				</#list>
			</ul>
		</div>
		<input type="button" id="applyRefund" name="applyRefund" value="申请退款" class="btn100 btngray"/>
	</div>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script type="text/javascript">
		jQuery(document).ready(function($) {
			$(".back").click(function(){
				var url = "${buyer_weixin_domain}/view/weixin/mycoupon";
				window.location.replace(url);
			});
			$('input:radio').click(function(event) {
				$('#applyRefund').removeClass('btngray');
			});
			$('#applyRefund').click(function(event) {
				if($('input:radio:checked').length > 0) {
					$('#applyRefund').unbind("click");
					var reasonKey = $('input:radio:checked').val();
					var url = "${buyer_weixin_domain}/view/weixin/refundapply?couponId=${couponId}&reasonKey=" + reasonKey;
					window.location = url;
				}
			});
		});
	</script>
	</#escape>
</@htmlBody>
</html>
