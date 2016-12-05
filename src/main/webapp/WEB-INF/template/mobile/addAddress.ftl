<!DOCTYPE html>
<html>

<#include "base.ftl">

<@htmlHead title="添加收货地址">
<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/style-vesion1.0.css" />
</@htmlHead>
<@htmlBody>
<#escape x as x?html>
	<div class="addAddress">
				<div class="formSection">
					<div class="item">
						<input id="username" type="text" placeholder="添加收货人" maxlength="15"/>
					</div>

					<div class="item">
						<input id="tel" type="text" placeholder="添加联系电话" maxlength="11"/>
					</div>

					<div class="item">
						<select id="pro">
							<option selected="selected" value="0">选择省</option>
								
						</select>
					</div>

					<div class="item">
						<select id="city">
							<option selected="selected" value="0">选择市</option>
						</select>
					</div>

					<div class="item">
						<select id="area">
							<option selected="selected" value="0">选择区/县</option>
						</select>
					</div>

					<div class="item">
						<input id="detailAddress" type="text" placeholder="添加详细地址" maxlength="30"/>
					</div>
				</div>
				
				<input type="button" name="add" value="增加" onclick="sbmtAddress();" class="btn100"/>
		</div>

	</body>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery.qrcode.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/js/init.js" ></script>
	<script id="listtemplate" type="text/html">
			  		{{each pros as pro}}
						<option  value="{{pro.sysAreaId}}">{{pro.sysAreaName}}</option>
					{{/each}}
	    
	</script>
	<script type="text/javascript">
		jQuery(document).ready(function($) {
			$('.back').click(function(event) {
				window.history.go(-1);
			});
			queryDatas();
			//为省级菜单选项,添加change 事件
			$("#pro").change(function(){
				var areaId=$(this).val();
				if(areaId>0){
					$.getJSON("${buyer_weixin_domain}/view/member/ajaxAreas?areaId="+areaId,function(result){
						var areaobjs = result.sysAreas;
						var sltop = '<option selected="selected" value="0">选择市</option>';
						for(var i=0;i<areaobjs.length;i++){
			    			sltop += '<option value="'+ areaobjs[i].sysAreaId +'">'+ areaobjs[i].sysAreaName +'</option>';				
						}
						$("select[id='city']").html(sltop);
						$("select[id='area']").html('<option selected="selected" value="0">选择区/县</option>');
			    	});
				}
			});
			$("#city").change(function(){
				var areaId=$(this).val();
				if(areaId>0){
					$.getJSON("${buyer_weixin_domain}/view/member/ajaxAreas?areaId="+areaId,function(result){
						var areaobjs = result.sysAreas;
						var sltop = '<option selected="selected" value="0">选择区/县</option>';
						for(var i=0;i<areaobjs.length;i++){
			    			sltop += '<option value="'+ areaobjs[i].sysAreaId +'">'+ areaobjs[i].sysAreaName +'</option>';				
						}
						$("select[id='area']").html(sltop);
			    	});
				}
			});
		});
		
		function queryDatas(){
			$.get("${buyer_weixin_domain}/view/member/proList?ts="+new Date(), 
		  	function(result){
			   	var data = $.parseJSON(result);
				if(data.pros && data.pros.length > 0){
					var listhtml = template('listtemplate',data);
					$("#pro").append(listhtml);
				}

		  	});
		}
		
		function sbmtAddress(){
			var username = $("#username").val();
			var tel = $("#tel").val();
			var pro = $("#pro").val();
			var city = $("#city").val();
			var area = $("#area").val();
			var detailAddress = $("#detailAddress").val();
			if(username==''||username==null){
				alert("收货人为空！");
				return;
			}
			if(tel==''||tel==null){
				alert("联系电话为空！");
				return;
			}
			if(!(/^1[3|4|5|6|7|8|][0-9]\d{4,8}$/.test(tel))){
				alert("联系电话格式错误！");
				return;
			}
			if(pro==''||pro==null||pro=='0'){
				alert("请选择省！");
				return;
			}
			if(city==''||city==null||city=='0'){
				alert("请选择市！");
				return;
			}
			if(area==''||area==null||area=='0'){
				alert("请选择区/县！");
				return;
			}
			if(detailAddress==''||detailAddress==null){
				alert("详细地址为空！");
				return;
			}
//			var url = "${buyer_weixin_domain}/view/weixin/ownedAddress?topicId=${topicId}&couponId=${couponId}";
//			if('${fromPage}'){
//				url = '${buyer_weixin_domain}/view/weixin/logistOrderInfo?topicId=${topicId}&couponId=${couponId}&type=0&logistInfo=0';
//			}
			
			var url = '${buyer_weixin_domain}/view/weixin/logistOrderInfo?topicId=${topicId}&couponId=${couponId}&type=0&logistInfo=0';
					
			$.post("${buyer_weixin_domain}/view/member/saveAddress?username="+username+"&tel="+tel+"&pro="+pro+"&city="+city+"&area="+area+"&detailAddress="+detailAddress, 
			  	function(result){
				   	var data = $.parseJSON(result);
					window.location=url;
			  	});
		}
	</script>
	</#escape>
</@htmlBody>

</html>