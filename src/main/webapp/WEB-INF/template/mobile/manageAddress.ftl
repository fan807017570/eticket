<!DOCTYPE html>
<html>

<#include "base.ftl">

<@htmlHead title="我的橙e券">
<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/plugin/font-awesome-4.4.0/css/font-awesome.min.css" />
<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style-vesion1.0.css" />
</@htmlHead>
<@htmlBody>
<#escape x as x?html>
	<a class="popCE">设置默认收货地址成功</a>
	<div class="addressPage">
<!-- 		 <div class="add"> -->
<!-- 		 	<a href="#" onclick="addAddress();">添加</a> -->
<!-- 		 </div> -->
		 <div class="notFound">
			<img src="${buyer_portal_static_resources_domain}/img/pic_crying2.png">
			<p>暂无此类搜索信息</p>
		</div>
		 <div class="list">
		 </div>
		 <a title="返回顶部" class="goto-top" style="display: block; position: fixed;" href="#"></a>
		 <input type="button" name="delivery" value="完成" class="btn100 fixed" onclick="manageComplete();"/>
	</div>

	</body>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery.qrcode.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/js/init.js" ></script>
	<script id="listtemplate" type="text/html">
			{{each ownerAddressList as ownerAddress}}
			  <div class="item">
			 		<div class="del">
			 			<a href="#" onclick="deleteAddress('{{ownerAddress.ownerAddressId}}');" class="icon icon-close3"></a>
			 		</div>
			 		<div class="addDetail" onclick = "setDefault(this, '{{ownerAddress.ownerAddressId}}');">
			 			<p>收货人：{{ownerAddress.name}}<span class="tel">{{ownerAddress.tel}}</span>
						{{if ownerAddress.addStatus == '1' }}
								<span class="default">默认</span>
								<input type="hidden" id="defaultAddressId" value="{{ownerAddress.ownerAddressId}}">
						{{/if}}
						</p>
			 			<p>收货地址：{{ownerAddress.pro}}{{ownerAddress.city}}{{ownerAddress.borough}}{{ownerAddress.detailAddress}}</p>
			 		</div>
			 </div>
	      {{/each}}
	</script>
	<script type="text/javascript">
		var defaultAddressId = ''; 
		var page = 1;
		var loadmore = false;
		jQuery(document).ready(function($) {
			$('.back').click(function(event) {
				window.history.go(-1);
			});
			$(".notFound").hide();
			queryDatas(page);
		});
		// 窗口滚动事件
       	$(window).scroll(function(){
       		if(($(document).height()-$(this).scrollTop()-$(this).height()) < 50) {
       			if(loadmore) {
       				page++;
					queryDatas(page);
       			}
       		}
       		if(($(document).height()-$(this).scrollTop()) > 200) {
       			$('.goto-top').show();
       		} else {
       			$('.goto-top').hide();
       		}
       	});
		function queryDatas(page){
			$.get("${buyer_weixin_domain}/view/member/getOwnedAddress?page="+page+"&ts="+new Date(), 
		  	function(result){
			   	var data = $.parseJSON(result);
				if(data.ownerAddressList && data.ownerAddressList.length > 0){
					var listhtml = template('listtemplate',data);
					$(".list").append(listhtml);
				}else{
					if(page==1) {
						$('.list').hide();
						$(".notFound").show();
					}
				}
				if(!data.hasmore){
					loadmore = false;
			    }else{
					loadmore = true;
			    }
		  	});
		}
		function deleteAddress(ownerAddressId){
			if(confirm("确定删除？")){
			$.post("${buyer_weixin_domain}/view/member/deleteAddress?ownerAddressId="+ownerAddressId+"&ts="+new Date(), 
				  	function(result){
					   	var data = $.parseJSON(result);
					   	if(data.status=='success'){
					   		alert('删除成功！');
					   		window.location.reload();
					   	}else{
					   		alert('删除失败！');
					   	}
				  	});
			}
		}
		function addAddress(){
			var url = '${buyer_weixin_domain}/view/weixin/addAddress?topicId=${topicId}&couponId=${couponId}';
			window.location=url;
		}
		function manageComplete(){
// 			var url = '${buyer_weixin_domain}/view/weixin/ownedAddress?topicId=${topicId}&couponId=${couponId}';
			var url = '${buyer_weixin_domain}/view/weixin/logistOrderInfo?topicId=${topicId}&couponId=${couponId}&type=0&logistInfo=0';
			window.location=url;
		}
		
// 		{{else}}
// 		<span class="setDefault" onclick="setDefault('{{ownerAddress.ownerAddressId}}');">设为默认</span>
//      设为默认地址
		function setDefault(obj, ownerAddressId){
			defaultAddressId = $("#defaultAddressId").val();
			//如果点击的是默认地址 或者 默认地址为空 则返回    
			if(ownerAddressId == defaultAddressId || defaultAddressId == null || defaultAddressId == undefined){
				return ;
			}
			else{
				$.post("${buyer_weixin_domain}/view/member/setDefaultAddress?ownerAddressId="+ownerAddressId+"&defaultAddressId="+defaultAddressId+"&ts="+new Date(), 
				function(result){
					var data = $.parseJSON(result);
					var oPopCE = $(".popCE");
					if(data.status=='1'){
						$("#defaultAddressId").val(ownerAddressId);
						$(oPopCE).html("设置默认收货地址成功");
						$(".default").remove();
						$(obj).find(".tel").after("<span class='default'>默认</span>");
					}
					else{
						$(oPopCE).html('设置失败，请重新操作！');
					}
					if(oPopCE != null && oPopCE != undefined){
						$('.popCE').slideDown('normal').delay(3000).slideUp('slow', function(){
						});
					}
				});
			}
		}
	</script>
	</#escape>
</@htmlBody>

</html>