<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>商品详情页</title>
		<!--样式 css引入 -->
		<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/public.css" />
		<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/index.css" />
		<!--下面两个js都是图片放大演示必须引入的文件-->
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery.1.4.2-min.js" ></script>
		
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/picShow.js" ></script>
		<!-- 首页和栏目页 js引入 -->
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/cpnweb.js" ></script>
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/public.js" ></script>
		<!--[if lt IE 9]>
         <script src="${buyer_portal_static_resources_domain}/lib/html5shiv.js"></script>
         <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/iehack.css" />
         
      	<![endif]--> 
	</head>
	
		    
	  <script type="text/javascript">
		  	$(document).ready(function(){
		  		getColumns();//获取栏目
		  		getGoodsClass(); //获取商品类别
		  	});

		  	
		    function getColumns(){
				  $.getJSON("${upload_file_domain}/json/catalog_column.json",function(data){
					      var allStr = "";
					    	$.each(data,function(i,item){
					    	var tmpStr = '<li> <a href="${buyer_portal_domain}/view/cpnweb/cpnListByColumn?columnIds='+item.id+'">' + item.name + '</a></li>';
					    		allStr = allStr + tmpStr;
					    	});
					    		$("#column").after(allStr);	
					    });
			    }
			    	
			    	
			    	
			    function getGoodsClass(){
				   $.getJSON("${upload_file_domain}/json/catalog_goods.json",function(data){
						 var allStr = "";
			    			$.each(data,function(key,item){
			    				var tmpLi = "<li>";
			    				var parStr= '<a href="${buyer_portal_domain}/view/cpnweb/cpnListByClass?classLevels=1&classIds='+item.id+'">' + item.name + '</a>' ;  //1
			    				
			    				tmpLi = tmpLi + parStr;
			    				
			    				if(item.children!=null) {
			    					tmpLi = tmpLi+"<ul>";
			    					$.each(item.children,function(key2,item2){
			    						tmpLi = tmpLi+"<li>";
			    						var childStr2 = '<a href="${buyer_portal_domain}/view/cpnweb/cpnListByClass?classLevels=2&classIds='+item2.id+'">' + item2.name + '</a> ';//2
			    							tmpLi = tmpLi + childStr2;
			    							if(item2.children!=null){
				    							tmpLi = tmpLi + "<ul>";
				    							$.each(item2.children,function(key3,item3){
						    						var childStr3 = '<li><a href="${buyer_portal_domain}/view/cpnweb/cpnListByClass?classLevels=3&classIds='+item3.id+'">' + item3.name + '</a></li> '; //2
						    							tmpLi = tmpLi + childStr3;
						    					});	
				    						 tmpLi = tmpLi+"</ul>";
			    							}
			    						 tmpLi = tmpLi+"</li>";	
			    					});	
			    					
									tmpLi = tmpLi+"</ul>";
			    				}
			    				tmpLi = tmpLi+"</li>";	
			    				allStr = allStr + tmpLi;
			    			});
			    			
			    		
			    			
			    			$(".allnav").html(allStr);	
			    			
					    });
			    } 
		  	
		  	
		  	
		  </script>

		  	
		 <script type="text/javascript">

		    $(function(){ 
		    	$(".allnav").hide();
		    	$(".hiddenNav").css("height",42).hover(function(){
		    		$(this).css("height","431px");
		    		$(".allnav").show();
		    	},function(){
		    		$(this).css("height","42px");
		    		$(".allnav").hide();
		    	})
		    	
		    	 /**
		    	$(".getTicketbtn").click(function(){
		    		$(".popbox").show();
		    	})
		    	 */
		    	$(".popbox .close").click(function(){
		    		$(".popbox").hide();
		    	})

		    })
	    </script>
			  
			  
			  
			  
		  <script>
		  
			$(function(){
				checkStatus();
			});
			
			//检查当前券是否可抢
			function checkStatus(){
				  var tip = "";
				  $.getJSON("${buyer_portal_domain}/view/cpnweb/topicStatus?topicid=${topic.topicId}", function(data){
					
					  if(data.result =="false" ){
						   tip = data.errorMsg;
						    $("#tip").html(tip);
					    	$(".popbox").show();
							$("#getNow").attr("disabled","disabled");
							$("#getNow").attr("class","getTicketbtnDisable"); 
					  }

				  });
			 }
		  
			//检查当前券是否可抢
			function takeTopic(){
				  var tip = "";
				  $.getJSON("${buyer_portal_domain}/view/cpnweb/topicStatus?topicid=${topic.topicId}", function(data){
					
					   if(data.result =="true"){
						   
						   window.location='${buyer_portal_domain}/view/web/payment_step1.htm?topicId=${topic.topicId!}';

					   }else{
						    var tip = data.errorMsg;
						    $("#tip").html(tip);
					    	$(".popbox").show();
							$("#getNow").attr("disabled","disabled");
							$("#getNow").attr("class","getTicketbtnDisable"); 
					   }

				  });
			 }

		</script>
	
	<body>
	<#escape x as x?html>
		
	<#include "header-sub.ftl">
		
		<section class="navAndbanner">
			<!--导航部分 开始-->
			<div class="nav">
				<ul class="width1000">
					<li class="hiddenNav">
						<a href="#">全部商品分类</a>
						<ul class="allnav">
						
						</ul>
					</li>

					<li id="column">
						<a href="${buyer_portal_domain}/">首页</a>
					</li>
					
					
				</ul>
			</div>
			<!--导航部分 结束-->
		</section>
		</#escape>
		<div class="product">
			<section class="width1000">
				<#escape x as x?html>
				<ul class="breadcrumb">
					
				 	<#if class1??>
				      <li><a href="${buyer_portal_domain}/view/cpnweb/cpnListByClass?classLevels=${class1.level!}&classIds=${class1.goodClassSid!}">${class1.className!}</a></li>
				    </#if>
				    <#if class2??>
				      <li><a href="${buyer_portal_domain}/view/cpnweb/cpnListByClass?classLevels=${class2.level!}&classIds=${class2.goodClassSid!}">${class2.className!}</a></li>
				   </#if>
				   
				     	<#if class3??>
				       <li class="active"><span>${class3.className!}</span></li>
				    </#if>
			
				    
				</ul>
				<section class="intro">
					<div class="left">
						<div class="preview">
							<div id="vertical" class="bigImg">
							
								<img src="${firstPic!}" alt="" id="midimg" />
								
								<div style="display:none;" id="winSelector"></div>
							</div><!--bigImg end-->
							
							<div class="smallImg">
								<div class="scrollbutton smallImgUp disabled"></div>
								<div id="imageMenu">
									<ul>
									
									<#if (smallPicPathList?? && smallPicPathList?size>0)!>
									 <#list smallPicPathList as pic >
										<li><img src="${pic.path!}"/></li>
										</#list> 
									</#if>
									
										 
									</ul>
								</div>
								<div class="scrollbutton smallImgDown"></div>
							</div><!--smallImg end-->
							
							<div id="bigView" style="display:none;"><img width="700" height="700" alt="" src="" /></div>
							
						</div><!--preview end-->
					</div>
					<div class="right productInfo">
						<div class="bigtitle">
							${topic.couponName!}
						</div>
						<ul>
						
						<#if topic.topicClass?exists && topic.topicClass=="CLASS-1" >
						
							<li class="price"> 
								价格：<div class="priceNow">￥<span>${topic.price!}</span></div>
								面值：<div class="priceNow">￥<span>${topic.oriPrice!}</span></div>元现金券
							</li>
							
						<#elseif topic.topicClass?exists && topic.topicClass=="CLASS-2" > 
							
							<li class="price"> 
								<div class="f-overCut">满<span class="font-orange">${topic.fullPrice!}</span>元</div> 
								<div class="f-overCut">减<span class="font-orange">${topic.offPrice!}</span>元</div>
							</li>
							
							<#elseif topic.topicClass?exists && topic.topicClass=="CLASS-3" > 
							
							<li class="price"> 
									折扣：<div class="priceNow"><span>${topic.percentPrice!}</span></div>折
							</li>
							
							<#else> 
								<li class="price"> 
									价格：<div class="priceNow">￥<span>${topic.price!}</span></div>
									说明：${topic.topicContent!}
								</li>
						 </#if>		
							
							<li class="detail">
								<div class="left"><span class="font-orange">券使用有效期:</span>${topic.startDate!}--${topic.endDate!}</div>
								<div class="left"><span class="font-orange">
								优惠券数：</span>已发放<span  class="font-orange takennums">${topic.takenCount!}</span>张，今日还剩<span class="font-orange remainnums">${topic.remainCount!}</span>张</div>
							</li>
							<li class="timeout">
								<div><span class="font-orange">抢券剩余时间:</span>${topic.days!}天</div>
							</li>
						</ul>
						<input class="getTicketbtn" id="getNow" type="button" 
							onclick="takeTopic()"
							name="getTicket" value="立即领取"/>
							<!-- 
								onclick='javascript:window.location.href="${buyer_portal_domain}/view/web/payment_step1.htm?topicId="+${topic.topicId!}'

							 -->
					</div>
				</section>
				</#escape>
				<article class="howtouse">		
					<div class="title">优惠券使用详情</div>
					<div class="detail">
						<#escape x as x?html>
						<div class="item">
							<header>商家信息</header>
							<p>商家名称：${topic.orgName!}</p>
							
							<div class="branch_store">
							<a href="javascript:;">查看全部${topic.orgPosCount!}家分店></a>
								<ul>
								
								<#if (branchList?? &&branchList?size>0)!>
									<#list branchList as branch >
									<li>
										<div class="header">${topic.orgName!}<div class="time">营业时间：${branch.bussinessHours!}</div></div>
										<div class="address">${branch.orgAddress!}</div>
										<div class="tel">${branch.orgPhone!}</div>
									</li>
									</#list>
								</#if>
								
								</ul>
							</div>
						
						
						
						</div>
						</#escape>
						<div class="item">
							<header>使用说明</header>
							<p>${topic.description!}</p>
							
						</div>
						<#escape x as x?html>
						<div class="item">
							<header>商品详情</header>
							
								<#if (bigPicPathList?? && bigPicPathList?size>0)!>
									 <#list bigPicPathList as pic >
										<img src="${pic.path!}"  />
										</#list> 
									</#if>
							
							
							<!--  
							<img src="${buyer_portal_static_resources_domain}/img/pc/detailpic1.png" />
							<img src="${buyer_portal_static_resources_domain}/img/pc/detailpic2.png" />
							-->
						</div>
						</#escape>
					</div> 
				</article> 
			</section>  
		</div>
		<#escape x as x?html>
		<#include "footer.ftl">
		
		<!--领取失败弹出框 开始-->
			<section class="popbox">
			<div class="popboxin">
				<header>提示信息<a class="close"></a></header>
				<div class="content orange">
					<img src="${buyer_portal_static_resources_domain}/img/pc/cry.png" />
					<div class="text" id="tip">
						
					</div> 
				</div>
			</div>
		</section>
		<!--领取成功弹出框 结束-->
		
		<script>

		    $(function(){
		    	$("#imageMenu ul>li:first").attr("id","onlickImg");
		    	if($("#imageMenu ul>li").length <= 5){
		    		$("#imageMenu").next().addClass("disabled");
		    	}
		    	
		    	
		    	$(".branch_store a").click(function(){
		    		$(this).next("ul").slideToggle(500)
		    	})
		    	
		    })
		</script>
	</#escape>    
	</body>
</html>
