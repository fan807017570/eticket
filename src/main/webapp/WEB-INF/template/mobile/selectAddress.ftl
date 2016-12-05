<!DOCTYPE html>
<html>

<#include "base.ftl">

<@htmlHead title="我的橙e券">
<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/plugin/font-awesome-4.4.0/css/font-awesome.min.css" />
<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style-vesion1.0.css" />
</@htmlHead>
<@htmlBody>
<#escape x as x?html>
	<div class="addressPage">
<!-- 			<div class="add"> -->
<!-- 			 	<a href="#" onclick="manageOrAdd();"><span id="manageOrAdd">添加</span></a> -->
<!-- 			</div> -->
			<div class="notFound">
			<img src="${buyer_portal_static_resources_domain}/img/pic_crying2.png">
			<p>暂无此类搜索信息</p>
		</div>
			<div class="list">
			</div>
<!-- 			<a title="返回顶部" class="goto-top" style="display: block; position: fixed;" href="#"></a> -->
			 <input type="button" name="delivery" value="新增地址" class="btn100" onclick="toAddPage('add');" style="width:40%;float:left;margin:5%"/>
			 <input type="button" name="delivery2" value="地址管理" class="btn100" onclick="toAddPage('manage');" style="width:40%;float:right;margin:5%;"/>
		</div>

	</body>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery.qrcode.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script id="listtemplate" type="text/html">
			{{each ownerAddressList as ownerAddress}}
			  <div class="item bgF" onclick="selctComplete();">
			 		<div class="select">
			 			<div class="radio4">
							<input type="radio" {{if ownerAddress.addStatus == '1' }}checked="checked"{{/if}} id="select" name="select" value="{{ownerAddress.ownerAddressId}}-{{ownerAddress.name}}-{{ownerAddress.tel}}-{{ownerAddress.pro}}-{{ownerAddress.city}}-{{ownerAddress.borough}}-{{ownerAddress.detailAddress}}">
							<label for="select"></label>
						</div>
			 		</div>
			 		<div class="addDetail">
			 			
			 			<p>收货人：{{ownerAddress.name}}<span class="tel">{{ownerAddress.tel}}</span>
							{{if ownerAddress.addStatus == '1' }}
								<span class="default">默认</span></p>
							{{/if}}
			 			<p>收货地址：{{ownerAddress.pro}}{{ownerAddress.city}}{{ownerAddress.borough}}{{ownerAddress.detailAddress}}</p>
			 		</div>
			  </div>
	      {{/each}}
	</script>
	<script type="text/javascript">
		var page = 1;
		var loadmore = false;
		var manageUrl="${buyer_weixin_domain}/view/weixin/addAddress?topicId=${topicId}&couponId=${couponId}";
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
					manageUrl="${buyer_weixin_domain}/view/weixin/manageAddress?topicId=${topicId}&couponId=${couponId}";
					$("#manageOrAdd").html("管理");
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
		function selctComplete(){
			var logistInfo = $("input[name='select']:checked").val();
			if(logistInfo=='undefined'){
				alert("请选择收货地址");
				return;
			}
			var url = '${buyer_weixin_domain}/view/weixin/logistOrderInfo?topicId=${topicId}&couponId=${couponId}&type=1&logistInfo='+logistInfo;
			url = encodeURI(url);
			window.location.href=url;
		}
		function manageOrAdd(){
			window.location=manageUrl;
		}
		
		function toAddPage(type){
			var url="";
			if(type=='add'){
				url = "${buyer_weixin_domain}/view/weixin/addAddress?topicId=${topicId}&couponId=${couponId}";
			}else if(type=='manage'){
				url="${buyer_weixin_domain}/view/weixin/manageAddress?topicId=${topicId}&couponId=${couponId}";
			}
			url = encodeURI(url);
			window.location.href=url;
		}
	</script>
	</#escape>
</@htmlBody>

</html>