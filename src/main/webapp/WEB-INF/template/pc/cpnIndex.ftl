<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>首页</title>
		<!--幻灯片 css引入 -->
		<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/idangerous.swiper.css"/>
		<!--首页样式 css引入 -->
		<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/public.css" />
		<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/index.css" />
			
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-1.9.1.min.js" ></script>
		<!-- 首页和栏目页 js引入 -->
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/cpnweb.js" ></script>
		<!--控制幻灯片 js引入 -->
		
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/idangerous.swiper.js"></script>
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/public.js" ></script>
		<!--[if lt IE 9]>
         <script src="${buyer_portal_static_resources_domain}/lib/html5shiv.js"></script>
         <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/iehack.css" />
      	<![endif]--> 
	</head>
	
	
	<body>
	<#escape x as x?html>
  <#include "header.ftl">
		
		<div class="main"> 

			<!--  -->
			
			
			
			<#if (allList?? && allList?size>0)!>
			   <#list allList as gcd  >
			
		
			<section class="width1000 ticket">
				<header>
					<div class="title">
						<img src="${buyer_portal_static_resources_domain}/img/pc/${gcd.imageSrc!}"/> <!--商品种类小图  -->
						${gcd.className!}
						 
					</div>
					<div class="tags">
						<span>	${gcd.className!}</span>
					</div>
				</header>
				<article>
					<div class="left">
					
						<!-- 商品侧边广告图 -->
						
							<div class="${gcd.adClassCss!}">
							<div class="swiper-wrapper" id="${gcd.swiperId!}">
							 <input type="hidden" id="${gcd.cpnAdv.hiddenName!}" value="${gcd.cpnAdv.advClass!}">
							
							<#if (gcd.cpnAdv?? && gcd.cpnAdv.listAdvParams?? && gcd.cpnAdv.listAdvParams?size>0)!>
								 <#list gcd.cpnAdv.listAdvParams as gdAdv  >
								 	<#if gdAdv.picRealPath?? && gdAdv.picRealPath!="" >
								   	   <div class="swiper-slide" style="background: url(${gdAdv.picRealPath!}) center center no-repeat;"><a href="${gdAdv.advPicUrl!}"></a></div>
								   </#if >
							     </#list>
							</#if>
							
							</div>
						</div>						
					</div>
					
						
					<div class="right">
								
							      <ul class="ticket-list">  
						          
						           
						
						
					<#if (gcd.listCoupon?? && gcd.listCoupon?size>0)!>
						<#list gcd.listCoupon as cpn >
				
				<!-- 循环开始 -->
	       <#include "middleEntity.ftl">
								
		     	<!-- 循环结束 -->
					

				</#list>
	      </#if>
							
						</ul>
					</div>
				</article>
			</section>
			<!--新鲜水果 结束-->
			
			</#list>
	</#if>	
		
			
			
			</section>
			<!--餐料调料 结束-->
		</div>
		
<#include "footer.ftl">
		 
		  
		  <script type="text/javascript">

			$(document).ready(function(){
		  		swiper();  //首页图片滑动
		  		getColumns();//获取栏目
		  		getGoodsClass(); //获取商品类别
		  		toggleAllGoodsClassify();//全部商品分类样式切换
		  	});
		  	
	  		function toggleAllGoodsClassify(){
	  			$("#showAllGoodsClassify").hover(
		  			function(){
		  				$(".allnav").css("display","block");
		  			},
		  			function(){
		  				$(".allnav").css("display","none");
		  			}
		  		);
	  		}
		  	
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
		  
		  	
			function gotoDetailPage(topicId){
				  window.location="${buyer_portal_domain}/view/cpnweb/cpnDetail?topicId="+topicId;
			}
			
		  </script>
	    
	  
		<script>
	
			 //侧边商品广告轮播 开始
			 if($("#swiperWrapper1")!=null && $("#hidden1")!=null && $("#hidden1").val()==2){
				var swiper2 = new Swiper('.swiper-container-ad.ad1', {
					centeredSlides: true,
					autoplay: 3000,
					speed: 1000,
					loop: true,
					autoplayDisableOnInteraction: false
				});
			}
			 
			 if($("#swiperWrapper2")!=null && $("#hidden2")!=null && $("#hidden2").val()==2){
				var swiper3 = new Swiper('.swiper-container-ad.ad2', {
					centeredSlides: true,
					autoplay: 3000,
					speed: 1000,
					loop: true,
					autoplayDisableOnInteraction: false
				});
			}
			
			 if($("#swiperWrapper3")!=null  && $("#hidden3")!=null && $("#hidden3").val()==2){
				var swiper4 = new Swiper('.swiper-container-ad.ad3', {
					centeredSlides: true,
					autoplay: 3000,
					speed: 1000,
					loop: true,
					autoplayDisableOnInteraction: false
				});
			}
			
			 if($("#swiperWrapper4")!=null && $("#hidden4")!=null && $("#hidden4").val()==2){
				var swiper5 = new Swiper('.swiper-container-ad.ad4', {
					centeredSlides: true,
					autoplay: 3000,
					speed: 1000,
					loop: true,
					autoplayDisableOnInteraction: false
				});
			}	
			
			 if($("#swiperWrapper5")!=null  && $("#hidden5")!=null && $("#hidden5").val()==2){
				var swiper6 = new Swiper('.swiper-container-ad.ad5', {
					centeredSlides: true,
					autoplay: 3000,
					speed: 1000,
					loop: true,
					autoplayDisableOnInteraction: false
				});
			}
			
			 if($("#swiperWrapper6")!=null && $("#hidden6")!=null && $("#hidden6").val()==2){
				var swiper7 = new Swiper('.swiper-container-ad.ad6', {
					centeredSlides: true,
					autoplay: 3000,
					speed: 1000,
					loop: true,
					autoplayDisableOnInteraction: false
				});
			
			}
			 //侧边商品广告轮播 结束

		</script>
	</#escape>	    
	</body>
</html>
