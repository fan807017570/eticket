<!DOCTYPE html>
<html>

<#include "base.ftl">

<@htmlHead title="我要评价">
</@htmlHead>

<@htmlBody>
<#escape x as x?html>
	<div class="evaluate">
		<div class="pop">
			  <span>请选择评价分数</span>
		</div>
		<ul class="evaluatelist">
			<li>
				<div class="img">
					<p>不给力</p>
					<div class="radio">
						<input type="radio" id="star1" name="evaluate" value="1">
						<label for="star1"></label>
					</div>
				</div>
				<div class="stars">
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='1' />
					<img src="${buyer_portal_static_resources_domain}/img/star.png" title='2' />
					<img src="${buyer_portal_static_resources_domain}/img/star.png" title='3' />
					<img src="${buyer_portal_static_resources_domain}/img/star.png" title='4' />
					<img src="${buyer_portal_static_resources_domain}/img/star.png" title='5' />
				</div>
			</li>
			<li>
				<div class="img">
					<p>再加油</p>
					<div class="radio">
						<input type="radio" id="star2" name="evaluate" value="2">
						<label for="star2"></label>
					</div>
				</div>
				<div class="stars">
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='1' />
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='2' />
					<img src="${buyer_portal_static_resources_domain}/img/star.png" title='3' />
					<img src="${buyer_portal_static_resources_domain}/img/star.png" title='4' />
					<img src="${buyer_portal_static_resources_domain}/img/star.png" title='5' />
				</div>
			</li>
			<li  class="active">
				<div class="img">
					<p>还不赖</p>
					<div class="radio">
						<input type="radio" id="star3" name="evaluate" value="3" checked="checked">
						<label for="star3"></label>
					</div>
				</div>
				<div class="stars">
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='1' />
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='2' />
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='3' />
					<img src="${buyer_portal_static_resources_domain}/img/star.png" title='4' />
					<img src="${buyer_portal_static_resources_domain}/img/star.png" title='5' />
				</div>
			</li>
			<li>
				<div class="img">
					<p>真不错</p>
					<div class="radio">
						<input type="radio" id="star4" name="evaluate" value="4">
						<label for="star4"></label>
					</div>
				</div>
				<div class="stars">
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='1' />
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='2' />
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='3' />
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='4' />
					<img src="${buyer_portal_static_resources_domain}/img/star.png" title='5' />
				</div>
			</li>
			<li>
				<div class="img">
					<p>狂点赞</p>
					<div class="radio">
						<input type="radio" id="star5" name="evaluate" value="5">
						<label for="star5"></label>
					</div>
				</div>
				<div class="stars">
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='1' />
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='2' />
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='3'/>
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='4' />
					<img src="${buyer_portal_static_resources_domain}/img/star_active.png" title='5' />
				</div>
			</li>
		</ul>
		<form action="${buyer_weixin_domain}/view/weixin/doevaluate" method="post">
			<input type="hidden" name="couponid" value="${couponid}">
		    <input type="hidden" name="point" id="evaluate_point" value="3">
			<input type="button" id="sendEvaluate" value="发布评价" class="btn100"/>
		</form>
	</div>
	
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/jquery-2.1.3.min.js" ></script>
	<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/init.js" ></script>
	<script>
		$(function(){
			$(".back").click(function(){
				window.history.go(-1);
				window.location.reload();
			});
			$("#sendEvaluate").click(function(){
				if($("#evaluate_point").val()==""){
					$(".pop").slideDown();
				}else{
					$(this).parents("form").submit();
				}
			});
			$(".radio input[type='radio']").click(function(){
				$("#evaluate_point").val($(this).val());
				$(this).parents("li").siblings("li").removeClass("active").end().addClass("active");
			});
			$('.stars img').click(function(){
				var selector = '.evaluatelist li:nth-child(' + $(this).attr('title') + ') input[type="radio"]';
				$(selector).click();
			});
		});
	</script>
	</#escape>
</@htmlBody>

</html>