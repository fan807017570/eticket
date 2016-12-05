
<!DOCTYPE html>
<html style="font-size: 36px;">

<#include "base.ftl"/>

<@htmlHead title="橙e券">
	<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/plugin/font-awesome-4.4.0/css/font-awesome.min.css" />
	<style type="text/css">
		.tipbar{
    		 display: none;
    		 text-align: center;
		}
	</style>
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<div class="fakeloader">
		<div class="spinner3">
			<div class="dot1"></div>
			<div class="dot2"></div>
		</div>
	</div>
	
	 <div class="indexPage">
		 <div class="shuaixuan bgF6">
			<ul class="classify">
					<li class="active">
						<img src="${buyer_portal_static_resources_domain}/img/icon_cate_all.png">
						<span id='catalog_name'>员工福利</span>
					</li>
					<li class="subgroup">
						<img src="${buyer_portal_static_resources_domain}/img/icon_group_all.png">
						<span id='group_name'>限量抢购</span>
						<ul class="coupon_groups" >
							<li><a href='#' data_value='' style="background: #F8F8F8">限量抢购</a></li>
						</ul>
					</li>
					<li class="subgroup">
						<img src="${buyer_portal_static_resources_domain}/img/icon_paixu.png">
						<span id='order_name'>综合排序</span>
						<ul class="ordertypes">
							<li><a href="#" data_value="CLICKRATE" class="active1">人气最高</a></li>
							<li><a href="#" data_value="SCORE">评价最好</a></li>
							<li><a href="#" data_value="NEWCREATE">最新发布</a></li>
							<li><a href="#" data_value="REBATE">价格最惠</a></li>
						</ul>
					</li>
				</ul>
			<div class="classifyListbox">
				<div class="classifyListboxInner">
					<div class="classifyList">
						<ul></ul>
					</div>
					<div class="classifyList2">
						<ul></ul>
					</div>
					<div class="classifyList3">
						<ul></ul>
					</div>
				</div>
			</div>
			
		</div>
		<div id="topic-list-cantainer" class="ticketBoxList">
			
		</div>
		<div class="tipbar">
			<div class="notFound">
				<img src="${buyer_portal_static_resources_domain}/img/pic_crying2.png">
				<p>暂无此类搜索信息，请看看别的吧</p>
			</div>
		</div>
		<a class="toTop" href="#top"></a>
	</div>
	<script id="listtemplate" type="text/html">
		{{each topics as topic}}
				<div class="ticketBox">
					<div class="time-start"><div class="rotate-text">
						{{if topic.started}}
							距结束
						{{else}}
							距开始
						{{/if}}{{topic.days}} 天
					</div></div>
					<div class="show-base">
						<div class="img">
							<img src="{{topic.wxListImage}}" class="pic" onClick="javaScript:window.location='{{topic.wxDetailHtmlUrl}}'" />
						</div>
						<div class="title">
							{{if topic.topicClass == 'USER_DEFINE'}}
									{{topic.topicContent}}
							{{else}}
									{{topic.couponName}}
							{{/if}}
						</div>
						<div class="info-line">
							<div class="evaluate" title="{{topic.evaluation/20}}">
								<span class="fa fa-star"></span>
								<span class="fa fa-star"></span>
								<span class="fa fa-star"></span>
								<span class="fa fa-star"></span>
								<span class="fa fa-star"></span>
							</div>
							<div class="ticket-leave">已抢{{topic.takenCount}}张 还剩{{topic.remainCount}}张</div>
						</div>
						<div class="price_link">
							<a href="{{topic.wxDetailHtmlUrl}}" class="get-ticket" >
								{{if topic.started}}
									去看看
								{{else}}
									去看看
								{{/if}}
								<img src="${buyer_portal_static_resources_domain}/img/icon_double_arrow.png">
							</a>

							{{if topic.topicClass == 'FOR_CASH'}}
								<div class="current_price">
									{{if topic.price == '免费' || topic.price == '' || topic.price == null}}
										0
									{{else}}
										{{topic.price}}
									{{/if}}
									元 <em>员工价</em>
								</div>
                            {{/if}}
							{{if topic.topicClass == 'OFF_PRICE'}}
								<div class="current_price">
									满{{topic.fullPrice}}<em>减{{topic.offPrice}}</em>
								</div>
							{{/if}}

							{{if topic.topicClass == 'PERCENT_PRICE'}}
									
								<div class="current_price">
									<em>{{topic.percentPrice}}折</em>
								</div>
							{{/if}}
							{{if topic.topicClass == 'USER_DEFINE'}}
									<div class="current_price">
									<em>免费</em>
								</div>
							{{/if}}

						</div> 
							
					</div>
				</div>
	  {{/each}}
	  	<div style="display: none; z-index: 999; position: fixed; left: 0;bottom: 0;  right: 0;  width: 100%;  background: #f5f5f5;" id="bottomLoad">
			<div class="spinner3">
				<div class="dot1"></div>
				<div class="dot2"></div>
			</div>
		</div>
	</script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/template.js" ></script>
	<script>

		var page = 1;
		var checkedCatalog="";
		var checkedGroup="";
		var checkedOrder="";
		var loadmore = false;
	
		$(function(){
			//用于测试的json数据
			var catalogDatas = null;
			var groupDatas = null;
		    $.getJSON("${upload_weixin_file_domain}/json/catalog_column.json", function(data){
				groupDatas = data;
				//初始化券的分组
				for(var i=0;i<groupDatas.length;i++){
					var group = groupDatas[i];
					$(".coupon_groups").append("<li><a href='#' data_value='"+group.id+"'>"+group.name+"</a></li>");
				}
			});
			
			$.getJSON("${upload_weixin_file_domain}/json/catalog_goods.json", function(data){
				catalogDatas = data;
				//初始化分类菜单
				$shwoMenu("ROOT", "classifyList"); 
			});
			
			/**
			 * 根据父节点ID 查询出所有的子节点
			 * 需要递归
			 * @param {Object} parentId
			 */
			var $getSubData = function(parentId, data){
				data = data || catalogDatas;
				if(parentId === "ROOT"){
					return data;
				}
				// 这里是写死的 就做了两级循环，一级不存在，就去二级去数据
				for(var i=0; i<data.length; i++){
					if(data[i].id === parentId){
						return data[i].children;
					}else{
						if(data[i].children){
							var subData = data[i].children;
							for(var j=0; j<subData.length; j++){
								if(subData[j].id === parentId){
									return subData[j].children;
								}
							}
						}
					}
				}
			}
			
			/**
			 * 取出节点数据 添加到对应的区域
			 * @param {Object} parentId 父节点id
			 * @param {Object} areaName 添加数据目标区域class名称
			 */
			var $shwoMenu = function (parentId, areaName) {
				$("."+areaName+" li").show();
				if(parentId && areaName){
					var tempData = $getSubData(parentId);
					if(tempData!=null && tempData.length >0){
						//删除添加区域中内容 和 所有后面区域的内容 
						$("."+areaName+" ul").empty();
						var _c = $("."+areaName).next().attr("class");
						if(_c){
							$("."+_c+" ul").empty();
						}
						var lv = 1;
						if(areaName=="classifyList2"){
							lv=2;
						}else if(areaName=="classifyList3"){
							lv=3;
						}
						//添加各个类别的查询全部的链接
						$("."+areaName+" ul").append("<li class='active'><a id='all_"+lv+"_"+parentId+"'>员工福利</a></li>");
						//循环添加内容到区域中
						for(var i=0; i<tempData.length; i++){
							var temp = tempData[i];
							$("."+areaName+" ul").append("<li><a id='"+temp.id+"'>"+temp.name+"</a></li>");
						}
					}else{
						changeCatalog(parentId,areaName);
					}
				}
			}
			 
			    /*
				 * 员工福利点击事件
				 */
				$(".classify li:first").click(function(){ 
					$(this).siblings("li").removeClass("active").find("ul").hide();
					// 删除或添加class
					if($(this).hasClass("active")) 
						$(this).removeClass("active") 
					else {
						$(this).addClass("active");
					}
					// 隐藏或显示菜单目录
					//$(".classifyListbox").toggle().height($("body").height());
					$(".classifyListbox").toggle();
				})
				
				/*
				 * 菜单点击事件  
				 */
				$(".classifyListbox").delegate("ul li", "click", function(){
					// 获取本节点的下一节点，判断是否存在，不存在就不需要去数据了
					// 存在就是要把数据取出来显示在指定的区域
					var areaName = $(this).parent("ul").parent("div").next().attr("class");
					var id = $(this).children("a").attr("id");
					var name = $(this).children("a").html();
					if(name === '员工福利') {
						var parentName = $(this).parent("ul").parent("div").prev().children('ul').children('.active').children('a').html();
						if(parentName) {
							sessionStorage.setItem('catalog_name', parentName);
						}else{
							sessionStorage.setItem('catalog_name', name);
						}
					} else {
						sessionStorage.setItem('catalog_name', name);
					}
					if(areaName && id!=''){
						// 先删除同级节点上所有的class
						$(this).parent("ul").find("li").removeClass("active");
						// 再在本节点上添加class
						$(this).addClass("active");
						$shwoMenu(id, areaName);
					}else{
						changeCatalog(id,areaName);
					}
				})
				
				/*
				 * 限量抢购和综合排序点击事件点击事件
				 */
				$(".classify li:not(:first)").click(function(){
					$(this).siblings("li").removeClass("active").find("ul").hide();
					$(".classifyListbox").hide();
					if($(this).hasClass("active")) {
						$(this).removeClass("active").find("ul").hide();
					}else{
						$(this).addClass("active").find("ul").show();
					}
				})
				
				//选择排序方式的事件处理
				$(".ordertypes a").click(function(){
					$(this).parent().parent().find("li a").removeAttr("style");
					$(this).css("background","#F8F8F8");
					checkedOrder = $(this).attr("data_value");
					sessionStorage.setItem("order_id", checkedOrder);
					var orderName = $(this).html();
					$('#order_name').html(orderName);
					sessionStorage.setItem("order_name", orderName);
					reloadData();
				})
				
				//选择分组的事件处理
				$(".coupon_groups").delegate("li a", "click", function(){
					$(this).parent().parent().find("li a").removeAttr("style");
					$(this).css("background","#F8F8F8");
					checkedGroup = $(this).attr("data_value");
					sessionStorage.setItem("group_id", checkedGroup);
					var groupName = $(this).html();
					$('#group_name').html(groupName);
					sessionStorage.setItem("group_name", groupName);
					reloadData();
				});
			    
			    
				//选择分组的事件处理
				$(".coupon_groups").delegate("li a", "click", function(){
					$(this).parent().parent().find("li a").removeAttr("style");
					$(this).css("background","#F8F8F8");
					checkedGroup = $(this).attr("data_value");
					sessionStorage.setItem("group_id", checkedGroup);
					var groupName = $(this).html();
					$('#group_name').html(groupName);
					sessionStorage.setItem("group_name", groupName);
					reloadData();
				});
				
				/*
				 * 菜单点击隐藏事件
				 */
				$(".ticketBoxList").click(function()
				{
					$(".classifyListbox").hide();
					$(".subgroup").removeClass("active");
					$(".subgroup ul").hide();
				})
			    
				//在界面上显示用户选择的查询条件
				if(sessionStorage.getItem("catalog_name")) {
					$('#catalog_name').html(sessionStorage.getItem("catalog_name"));
				}
				if(sessionStorage.getItem("group_name")) {
					$('#group_name').html(sessionStorage.getItem("group_name"));
				}
				if(sessionStorage.getItem("order_id")) {
					$('#order_name').html(sessionStorage.getItem("order_name"));
				}

		       	queryDatas(page);

		       	// 窗口滚动事件
		       	$(window).scroll(function(){
		       		//alert(($(document).height()+" "+ $(this).scrollTop()+" "+$(this).height());
		       		
		       		if(($(document).height()-$(this).scrollTop()-$(this).height()) < 50) {
		       			if(loadmore) {
		       				page++;
		       				$("#bottomLoad").show();
							queryDatas(page);
		       			}
		       			else
		       			{
		       				var thereisnomore = $("#topic-list-cantainer").find(".thereisnomore").size();
		       				if(thereisnomore == 0 ){
		       					$("#topic-list-cantainer").append("<div class='thereisnomore'><p>到底了，没有别的了！</p></div>");
		       				}
		       			}
		       		}
		       		
		       		var t = document.documentElement.scrollTop || document.body.scrollTop; 
					if(t>0){
						$(".toTop").show();
					}else{
						$(".toTop").hide();
					}
		       	});
		       	
		       //隐藏	
		      $(".fakeloader").hide();   	
		});

		String.prototype.startWith=function(str){
			if(str==null||str==""||this.length==0||str.length>this.length)
			  return false;
			if(this.substr(0,str.length)==str)
			  return true;
			else
			  return false;
			return true;
		}
		
		function changeCatalog(id,areaName){
			//查询员工福利的情况
	    	if(id==="all_1_ROOT"){
				checkedCatalog="";
			}else{
				checkedCatalog = id;
			}
			sessionStorage.setItem("catalog_id", checkedCatalog);
			if(sessionStorage.getItem("catalog_name")) {
				$('#catalog_name').html(sessionStorage.getItem("catalog_name"));
			}
			reloadData();
			$(".classifyListbox").hide();
			if(areaName=="classifyList2"){
				$(".classifyList2 li").hide();
				$(".classifyList3 li").hide();
			}else if(areaName=="classifyList3"){
				$(".classifyList3 li").hide();
			}
		}
		
		function reloadData(){
			page = 1;
			$("#topic-list-cantainer").html("");
			queryDatas(page);
		}
		
		function queryDatas(currentPage){
			
			$(".tipbar").hide();
			loadmore = false;
			//恢复用户选择的查询条件
			if(sessionStorage.getItem("catalog_id")) {
				checkedCatalog = sessionStorage.getItem("catalog_id");
			}
			if(sessionStorage.getItem("group_id")) {
				checkedGroup = sessionStorage.getItem("group_id");
			}
			if(sessionStorage.getItem("order_id")) {
				checkedOrder = sessionStorage.getItem("order_id");
			}
			var loadDataUrl = "${buyer_weixin_domain}/view/topic/list?page="+currentPage+"&catalog="+checkedCatalog+"&group="+checkedGroup+"&order="+checkedOrder+"&ts="+new Date();
			$.ajax({
				  url: loadDataUrl,
				  cache: false,
				  async:false,
				  success: function(result){
						var data = $.parseJSON(result);
						if(data.topics && data.topics.length > 0){
							var listhtml = template('listtemplate',data);
							$("#topic-list-cantainer").append(listhtml); 
							
							/*五星评价*/
							for(var i = 0;i<$(".evaluate").length;i++){
								var $this = $(".evaluate").eq(i);
								var starcount = parseInt($this.attr("title"));
									$this.find("span:nth-child("+(starcount)+")").css("color","#ffce11").prevAll().css("color","#ffce11");
							}
							
						}else{
							if(currentPage==1) {
								$(".tipbar").show();
							}
						}
						if(!data.hasmore){
							loadmore = false;
						}else{
							loadmore = true;
						}
						setTimeout(function(){
							$("#bottomLoad").hide();  
						},800)
				  }
				});
			
			
			
		  }
		
		function doWxMethod() {
        	if(wx) {
        		wx.hideMenuItems({
        			// 要隐藏的菜单项，只能隐藏“传播类”和“保护类”按钮，所有menu项见附录3
    				menuList: [
    					"menuItem:share:qq",
    					"menuItem:share:weiboApp",
    					"menuItem:favorite",
    					"menuItem:share:facebook",
    					"menuItem:share:QZone",
    					"menuItem:delete",
    					"menuItem:originPage",
    					"menuItem:readMode",
    					"menuItem:openWithQQBrowser",
    					"menuItem:openWithSafari",
    					"menuItem:share:email",
    					"menuItem:share:brand"
    				]
				});

				//调用微信分享到朋友圈接口
        		wx.onMenuShareTimeline({
					title: '平安银行橙e券', // 分享标题
					link: '${buyer_weixin_domain}/view/weixin/index', // 分享链接
					imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
				    success: function () {
				    },
				    cancel: function () { 
				    }
				});

				//调用微信分享给朋友接口
				wx.onMenuShareAppMessage({
				    title: '平安银行橙e券，员工专享折扣平台', // 分享标题
				    desc: '各种折扣券、代金券，还有0元购！关注平安银行橙e券，立即享用！', // 分享描述
				    link: '${buyer_weixin_domain}/view/weixin/index', // 分享链接
				    imgUrl: '${buyer_weixin_domain}/resources/img/circle_logo.png', // 分享图标
				    type: 'link', // 分享类型,music、video或link，不填默认为link
				    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
				    success: function () { 
				    },
				    cancel: function () { 
				    }
				});
        	}
        }
	</script>
	</#escape>
</@htmlBody>
</html>