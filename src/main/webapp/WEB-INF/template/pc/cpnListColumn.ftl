<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>首页</title>
		<!--幻灯片 css引入 -->
		<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/idangerous.swiper.css" />
		<!--首页样式 css引入 -->
		<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/public.css" />
		<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/index.css" />
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-1.9.1.min.js" ></script>
		
		<!--控制幻灯片 js引入 -->
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/cpnweb.js" ></script>
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/idangerous.swiper.js" ></script>
		<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/public.js" ></script>
		

		<!--[if lt IE 9]>
         <script src="${buyer_portal_static_resources_domain}/lib/html5shiv.js"></script>
         <link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/iehack.css" />
      	<![endif]--> 
	</head>
	<body>
	<#escape x as x?html>
		 <#include "header.ftl">


	<form id="listform" name="search" method="post" action="${buyer_portal_domain}/view/cpnweb/cpnListByColumn">
		<!--  --> 
		<input type="hidden" name="currentPage" id="currentPage" value="${currentPage!}" />
	    <input type="hidden" name="columnId" id="columnId" value="${columnId!}" />   
			<input type="hidden" name="totalPages" id="totalPages" value="${totalPages!}" />
		<div class="main hot">

			<section class="width1000 hotticket">
			
	
				
				<ul class="ticket-list blue">
				<#if (pagination?? && pagination.content?size>0)!>
					<#list pagination.content as cpn>
					
						<#include "middleEntity.ftl">
						
					</#list>
				</#if>
				</ul> 
			</section>
		</div>
		</#escape> 
		<!--分页区域  开始-->
					<!--  -->
		<div class="pagination">
		${pageHtml!}
		
		</div>
		
		<!--分页区域  结束-->
		
		</form>
		<#include "footer.ftl">
	</body>
	
		 <script type="text/javascript">
		 
		 $(document).ready(function(){
		  		swiper();  //首页图片滑动
		  		getColumns();//获取栏目
		  		getGoodsClass(); //获取商品类别
		  	});
		 
		 
		  	
		    function getColumns(){
			  $.getJSON("${upload_file_domain}/json/catalog_column.json",function(data){
				      var allStr = "";
				    	$.each(data,function(i,item){
				    		if("${columnId?c}" == item.id) {
				    			var tmpStr = '<li class="active"> <a href="${buyer_portal_domain}/view/cpnweb/cpnListByColumn?columnIds='+item.id+'">' + item.name + '</a></li>';
				    			allStr = allStr + tmpStr;
				    		} else {
				    			var tmpStr = '<li> <a href="${buyer_portal_domain}/view/cpnweb/cpnListByColumn?columnIds='+item.id+'">' + item.name + '</a></li>';
					    		allStr = allStr + tmpStr;
				    		}
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
	   
	   	<script  type="text/javascript">
			// 表单方式分页
			function gotoPage(n) {
				jQuery("#currentPage").val(n);
				jQuery("#listform").submit();
			}
			
			function jumpPages(){
				var pageNum = jQuery("#pageNumber").val();
				var totalPages =  jQuery("#totalPages").val();
				//如果为非数字的处理
				if($.isNumeric(pageNum)){
					if(pageNum<1){
						pageNum = 1;
					}else if(pageNum>totalPages){
						pageNum = totalPages;
					}
					
				}else {
					pageNum = 1;
				}
				$("#currentPage").val(pageNum);
				$("#listform").submit();

			}
						
		</script>
</html>
