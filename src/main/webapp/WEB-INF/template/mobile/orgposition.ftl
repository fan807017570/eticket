<!DOCTYPE html>
<html>
<#include "base.ftl">

<@htmlHead title="分店列表">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<div class="branch_store">			
	</div>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script id="positiontemplate" type="text/html">
		<ul>
		{{each positions as position}}
		<li>
			<div class="infos">
				<div class="address">{{position.address}}</div>
				<div class="time">营业时间：{{position.worktime}}</div>
				<div class="address">联系电话：{{position.phone}}</div>
			</div>
		</li>
		{{/each}}
		</ul>
	</script>
	<script type="text/javascript">
		jQuery(document).ready(function($) {
			queryOrgPosition();
		});

		function queryOrgPosition(){
			var loadDataUrl = "${buyer_weixin_domain}/view/coupon/orgposition?orgId="+${orgId}+"&ts="+new Date();
		  	$.get(loadDataUrl, function(result){
			   	var data = $.parseJSON(result);
			   	if(data.positions && data.positions.length > 0){
				   var listhtml = template('positiontemplate', data);
				   $(".branch_store").append(listhtml);
			   	}
		  	});
		}

	</script>
	</#escape>
</@htmlBody>
</html>