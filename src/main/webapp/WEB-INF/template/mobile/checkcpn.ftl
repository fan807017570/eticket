<!DOCTYPE html>
<html style="font-size: 36px;">
<#include "base.ftl">
<@htmlHead title="验券">
    <meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
   <style>
   	.hide{display: none}
   	.color_gray{background:#eeeeee }
   </style>
    <script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/js/fakeloader.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script type="text/javascript">
	function doWxMethod(){
	// 	alert('初始化成功');
	}
	
	function scanQrcode(){
		wx.scanQRCode({
		    needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
		    scanType: ["qrCode","barCode"], // 可以指定扫二维码还是一维码，默认二者都有
		    success: function (res) {
		    var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
		    $("#serialNo").val(result);
		    checkCpn();
		}
		});
	}
	</script>
	<script>
		$(function(){
			$(".close").click(function(){
				$("#serialNo").val(""); 
			})
			/* $("#yanquan_btn").click(function()
			{
				checkCpn();
			})
			$("#useCouponBtn").click(function()
			{
				useCpn();
			}) */
		})
		
		function cancelDisableStatus()
		{
			$("#yanquan_btn").attr("href","javascript:checkCpn()");
			$("#yanquan_btn").css("background-color","#ff8c3c");
			$("#showPlane").html("");
		}
		//微信端验券操作
		function checkCpn(){
			var serialNo = $("#serialNo").val();
			var userid = $("#userid").val()
			if(serialNo==''||serialNo==null){
				alert('请输入券码!');
				return;
			}
			
			$(".fakeloader").show();
			$.ajax({  
		            url:"${buyer_weixin_domain}/view/coupon/submtCheckCpn",  
		            type:"POST",  
		            datatype:"json", 
		            async:false,
		            data:{"serialNo":serialNo,"userId":userid}, 
		            beforeSend:function(request){
		            	
			        },
		            success:function(data) {
		            	$(".fakeloader").hide();
		            	var obj = new Function("return" + data)();
		            	if(obj.code=='1'||obj.code=='2'){
		            		var dto =obj.dto;
		            		$("#imgplace").attr("src",dto.pic);
		            		$("#couponNameplace").html(dto.couponName);
		            		$("#serNum").html("券号： "+serialNo);
		            		$(".time").html("有效期： "+dto.time);
		            		
							$("#showPlane").addClass("hide");
							$(".ticketBox").removeClass("hide");

							//隐藏已对卷
							$("#yiduiquan").hide();
							$(".ticketBox").show();
		            		$("#showPlane").hide();
							$("#ischecked").val("true");
							$("#couponstatus").val(dto.status);
							$("#status").val(obj.code);
							$("#orgPersonId").val(obj.orgPersonId);
							$("#yanquan_btn").attr("href","#").css("background-color","#eeeeee");
		            	}
		            	else if(obj.code=='3'){
		            		alert("您无权限验此券！");
		            	}
		            	else if(obj.code=='-1'){
			        		alert("验券错误次数超过限制，请明日再试");
			        	} 
		            	else{
		            		//alert("此券无效！");
		            		var nocoupontip= "	<div class='notFound'> " +
		    				" <img src='${buyer_portal_static_resources_domain}/img/pic_crying.png'> "+ 
		    				"<p>亲，很抱歉，没有找到相关券信息</p></div> " ;
		            		$("#showPlane").html(nocoupontip);
		            		$(".ticketBox").hide();
		            		$("#showPlane").show();
		            	}  
		            },  
		            error:function(data){
		            	$(".fakeloader").hide();
		                alert("验券失败");
		            }  
		      });
			
		}

		//微信端兑券操作
		function useCpn()
		{
			if(confirm("确定兑券？")){
				var serialNo = $("#serialNo").val();
				var userid = $("#userid").val()
				if(serialNo==''||serialNo==null){
					alert('请输入券码!');
					return;
				}
				if($("#ischecked").val()!="true")
				{
					alert('请先验券码!');
					return;
				}
				
				$(".fakeloader").show();
				$.ajax({  
			            url:"${buyer_weixin_domain}/view/coupon/submtUuseCpn",  
			            type:"POST",  
			            async:false,
			            datatype:"json",  
			            data:{"serialNo":serialNo,"userId":$("#orgPersonId").val(),"status":$("#status").val()},
			            beforeSend:function(request){
				        	$(".btn").attr({"disabled":"disabled"});
				        },
			            success:function(data) {
			            	//取消等待效果
			            	$(".fakeloader").hide();
			            	var obj = new Function("return" + data)();
			            	if(obj.code=='1'||obj.code=='2'){
			            		alert("兑券成功！");
			            		$("#serialNo").val("");
			            		$("#yiduiquan").show();
			            		$("#ischecked").val("");
			            		$("#couponstatus").val("");
			            	}else if(obj.code=='3'){
			            		alert("您无权限兑此券！");
			            	}else if(obj.code=='4'){
			            		alert("验券员帐号已禁用，请联系管理员！");
			            	}
			            	else if(obj.code=='-1'){
				        		alert("兑券错误次数超过限制，请明日再试");
				        	} 
			            	else{
			            		alert("兑券失败");
			            		var nocoupontip= "	<div class='notFound'> " +
			    				" <img src='${buyer_portal_static_resources_domain}/img/pic_crying.png'> "+ 
			    				"<p>亲，很抱歉，兑券失败！</p></div> " ;
			            		$("#showPlane").html(nocoupontip);
			            	}  
			            	$(".btn").removeAttr("disabled");//将按钮可用
			            },  
			            error:function(data){
			            	$(".fakeloader").hide();
			            	//取消验券按钮禁用状态
			            	$("#yanquan_btn").attr("href","javascript:checkCpn();").css("background-color","#ff8c3c");
			                var nocoupontip= "	<div class='notFound'> " +
		    				" <img src='${buyer_portal_static_resources_domain}/img/pic_crying.png'> "+ 
		    				"<p>亲，很抱歉，兑券失败！</p></div> " ;
		            		$("#showPlane").html(nocoupontip);
			                $(".btn").removeAttr("disabled");//将按钮可用
			            }  
			        });
				//取消验券按钮禁用状态
		    	$("#yanquan_btn").attr("href","javascript:checkCpn();").css("background-color","#ff8c3c");
			}
		}
</script>
</@htmlHead>
<@htmlBody>
	<#escape x as x?html>
	<div class="fakeloader" style="display: none;">
		<div class="spinner3">
			<div class="dot1"></div>
			<div class="dot2"></div>
		</div>
	</div>
	
	<div class="yanquanPage">
		<header class="public_header" onclick="scanQrcode();"> 
				<span class="icon-scan" ></span>扫描二维码
		</header>
			
			<div class="CE-form">
					<div class="item nolabel"> 
						<input type="text" name="serialNo" id="serialNo" onchange="cancelDisableStatus()" placeholder="请输入券码"/>
						<input type="hidden" id="userid" value="${userid}"/>
						<input type="hidden" id="orgPersonId"/>
						<input type="hidden" id="ischecked" value=""/>
						<input type="hidden" id="couponstatus" value=""/>
						<input type="hidden" id="status" value=""/>
						<div class="close"></div>
					</div> 
				</div>  
				
			<div id ="showPlane">	
			</div>
			
			<div class="ticketBox hide">
				<div class="time-start"><div class="rotate-text"></div></div>
				<div class="show-base">
					<div class="img">
						<img id="imgplace" src="" />
					</div>
					 
					<p class="text" id="couponNameplace"></p>
					<p class="text" id="serNum"></p>
					<div class="time"></div>
					<div id="yiduiquan" class="hide"><img src="${buyer_portal_static_resources_domain}/img/pic-yiduiquan.png" class="used"></div>	
				</div>
			</div>
			
			<div class="fixedBottom">
				<div class="left">
					<a  id="yanquan_btn"  href="javascript:checkCpn()">验券</a>
				</div>
				<div class="right">
					<a id="useCouponBtn"  href="javascript:useCpn()">兑券</a>
				</div>
			</div>
		 
	</div>
	</#escape>
</@htmlBody>
</html>
