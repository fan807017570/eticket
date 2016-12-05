<!DOCTYPE html>
<html>

<#include "base.ftl">

<@htmlHead title="我的橙e券">
	<style>
		.zyq{
			padding: 10px 2px;
			border-radius: 5px;
		}
	</style>
</@htmlHead>
<@htmlBody>
<#escape x as x?html>
	<a class="popCE"></a>
	<div class="delivery">
			<div class="top">
				<div class="img">
					<img src="${picturePath}" />
				</div>
				<div class="info">
					<p class="title">
						${couponName}
					</p>
					<#if price=='免费' >
					<p>免费</p>
					<#else>
					<p>￥<span>${price}元</span></p>
					<p>原价：${amount}元</p>
					</#if>
				</div>
			</div>
			<div class="address">
				<header>快递地址
					<a class="right" onclick="selectAddress('add');"><span class="icon icon-pencil"></span>新增</a>
					&nbsp;&nbsp;&nbsp;<a class="right" onclick="selectAddress('manage');"><span class="icon icon-pencil"></span>编辑</a>
				</header>
				<div id="addressListDiv" class='content'></div>
			</div>
			
		</div>
		<input id="logistId" type="hidden" value="0"/>
		<input type="button" name="delivery" value="确认快递" class="btn100 fixed" onclick="confirmOrder();"/>
	</body>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery.qrcode.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script type="text/javascript">
		var url = null;
		
		jQuery(document).ready(function($) {
			$('.back').click(function(event) {
				window.history.go(-1);
			});
			$('.popCE').click(function(event) {
				if(url) {
					window.location = url;
				}
			});
			
			//获取快递地址列表
			queryDatas();
			
		});
		
		//获取三条地址
		function queryDatas(){
			$.get("${buyer_weixin_domain}/view/weixin/getAddressList?showCount=3&ts="+new Date(), 
		  	function(result){
			   	var data = $.parseJSON(result);
			   	var listHtml="";
				if(data.addressList && data.addressList.length > 0){
					for(var i=0;i<data.addressList.length;i++){
						var list = data.addressList[i];
						listHtml +="<p class='zyq' onclick='selectThisAddress("+list.ownerAddressId+")'";
						if(list.addStatus == "1"){
							$("#logistId").val(list.ownerAddressId);
							listHtml += " style='background-color: #FF8C3C; color: white;'";
						} 
						listHtml += " id='p_"+list.ownerAddressId+"'>";
						listHtml +="<span style='float:left;'>收货人："+list.name+"</span>";
						listHtml +="<span style='float:right;'>手机："+list.tel+"</span>";
						listHtml +="<br/>";
						listHtml +="<span>地址："+(list.pro+list.city+list.borough+list.detailAddress)+"</span>";
						listHtml +="</p>";
					}
				}else{
					listHtml += "<p style='font-size:0.2rem;text-align:center;'>暂无可选地址，请点击新增！</p>";
				}
				$("#addressListDiv").append(listHtml);
		  	});
		}
		
		function confirmOrder(){
			var logistId = $("#logistId").val();
			if(logistId=='0' || logistId==''){
				alert("请选择收货地址！");
				return;
			}
			$.post("${buyer_weixin_domain}/view/member/confirmOrder?logistId="+logistId+"&topicId=${topicId}&couponId=${couponId}&ts="+new Date(), 
			  	function(result){
				var data = $.parseJSON(result);				
				if(data.status=="1"){
					$(".popCE").html("<span>下单成功！</span><img src='${buyer_portal_static_resources_domain}/img/arrow-bold.png' />");
					$('.popCE').slideDown('normal').delay(2000).slideUp('slow', function(){
						url = "${buyer_weixin_domain}/view/weixin/usedcoupon"
						window.location=url;
					});
				}
				else if(data.status=="-1"){
					$(".popCE").html("<span>请勿重复下单！</span>");
					$('.popCE').slideDown('normal').delay(2000).slideUp('slow', function(){
						url = "${buyer_weixin_domain}/view/weixin/usedcoupon"
						window.location=url;
					});
				}
				else{
					$(".popCE").html("<span>下单失败，请重新下单！</span><img src='${buyer_portal_static_resources_domain}/img/arrow-bold.png' />");
					$('.popCE').slideDown('normal').delay(2000).slideUp('slow', function(){
						url = "${buyer_weixin_domain}/view/weixin/mycoupon";
						window.location=url;
					});
				}
			});
		}
		
		function selectAddress(type){
		    var url = '${buyer_weixin_domain}/view/weixin/addAddress?topicId=${topicId}&couponId=${couponId}&fromPage=logistOrderInfo';
			if(type=='manage'){
			   url = '${buyer_weixin_domain}/view/weixin/manageAddress?topicId=${topicId}&couponId=${couponId}';
			}
			window.location=url;
		}
		
		function selectThisAddress(id){
			$("#logistId").val(id);
			$(".zyq").css("background-color","");
			$(".zyq").css("color","");
			$("#p_"+id).css("background-color","#FF8C3C");
			$("#p_"+id).css("color","white");
		}
	</script>
	</#escape>
</@htmlBody>

</html>