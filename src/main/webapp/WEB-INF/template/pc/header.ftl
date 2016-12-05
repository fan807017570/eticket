<!-- 说明：门户首页top部分 -->


<#escape x as x?html>
<#include "header-sub.ftl">

		<section class="navAndbanner">
			<!--导航部分 开始-->
			<div class="nav">
				<ul class="width1000">
					<li id="showAllGoodsClassify">
						<a href="#">全部商品分类</a>
						<ul class="allnav" style="display:none;">
						
						
						<!-- 类商品加载  -->
						
				        </ul>

					</li>
					<li id="column">
						<a href="${buyer_portal_domain}/">首页</a>
					</li>
					
				</ul>
			</div>
			<!--导航部分 结束-->

			<!--幻灯片轮播部分 开始-->
			<div class="swiper-container swiper-container-banner">
				<div class="swiper-wrapper">
				
			<#if (bannerList?? && bannerList?size>0)!>
			   <#list bannerList as adv  >
			  	 <#if adv.picRealPath?? &&adv.picRealPath!="" >
				 	<div class="swiper-slide" style="background: url(${adv.picRealPath!}) center center no-repeat;"><a href="${adv.advPicUrl!}" target="_blank"></a></div>
				 </#if>
			   </#list>
			   
			 </#if>
				</div>
				<!-- Add Pagination -->
				<div class="pagination">
				</div>
				
				<!-- Add Arrows -->
				<!--<div class="swiper-button-next"></div>
		        <div class="swiper-button-prev"></div>-->
			</div>
			<!--幻灯片轮播部分 结束-->
		</section>
</#escape>

	
		