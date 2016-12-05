
		//============控制幻灯片 开始============
	    
	    function swiper(){
		    var swiper = new Swiper('.swiper-container', {
		        pagination: '.pagination',
		        paginationClickable: true, 
		        centeredSlides: true,
		        autoplay: 5000,
		        speed:800,
		        loop:true,
		        autoplayDisableOnInteraction: false
		    });
		  
		    
		    $(function(){
		    	var bulletnum = $(".swiper-container .swiper-pagination-switch").length;
		    	for(var i = 0;i < bulletnum;i++){
		    		$($(".swiper-container .swiper-pagination-switch")[i]).text(i+1)
		    	}	
		    });
	    }

	    //============控制幻灯片 结束============
	    

	  	
	    function getColumns(){
		  $.getJSON("${upload_weixin_file_domain}/json/catalog_column.json",function(data){
			      var allStr = "";
			    	$.each(data,function(i,item){
			    	var tmpStr = '<li> <a href="${buyer_portal_domain}/view/cpnweb/cpnListByColumn?columnIds='+item.id+'">' + item.name + '</a></li>';
			    		allStr = allStr + tmpStr;
			    	});
			    		$("#column").after(allStr);	
			    });
	    }
	    	
	    	
	    	
	    function getGoodsClass(){
		   $.getJSON("${upload_weixin_file_domain}/json/catalog_goods.json",function(data){
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
	    
	    
	    
	    function initMenu(){
	    	$(document).ready(function(){
		  		swiper();  //首页图片滑动
		  		getColumns();//获取栏目
		  		getGoodsClass(); //获取商品类别
		  	
		  	});
	    }
