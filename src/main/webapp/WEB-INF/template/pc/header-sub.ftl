
<!-- 说明：最顶部的公共部分 -->
<#escape x as x?html>
<!--顶部信息 开始-->
<section class="top">
			<div class="width1000">
				<div class="left">
					<ul>
						<li><a href="http://www.orangebank.com.cn/index.html" target="_blank">橙e网首页</a></li>
						<li class="cut-line"></li>
						<li><a href="${buyer_portal_domain}/">橙e券</a></li>
					</ul>
				</div>
				<div class="right">
					<ul class="shareLinks">
					
					<#if Session["portal_userinfo_session_key"]?exists  
							&& Session["portal_userinfo_session_key"].username?exists  
							&& Session["portal_userinfo_session_key"].username!="" >
							
								<li>欢迎您,${Session["portal_userinfo_session_key"].username!}</li>
								<li><a href="${buyer_portal_domain}/view/web/usercenter/ticket">个人中心</a></li>
								<li><a href="javascript:void(0);" onclick="return logout()" >退出</a></li>

					<#else>

													
						<li class="dropDown">
						<a href="#">登录<span class="icon_down"></span></a>
						<ul class="secondList">
						<li> <a href="${buyer_portal_domain}/login" >个人用户</a> </li>
						<li> <a href="${enterprise_login_url}" >企业用户</a> </li>
						</ul>
						</li>
						<li class="cut-line"></li>
						<li> <a href="https://f.orangebank.com.cn/scfpwp-web/user/registerIndex.action"  target="_blank">注册</a> </li>

							
						</#if>
						
					<!--   <li id="userInfo"></li>-->

						<li class="cut-line"></li>
						
						<li class="dropDown">
							<a href="${buyer_portal_domain}/">关注我们<span class="icon_down"></span></a>
							<div class="imgQCcode">
								<img src="${buyer_portal_static_resources_domain}/img/pc/QRcode.jpg" />
								<span>橙e券公众号</span>
							</div>
						</li>

					</ul>
				</div>
			</div>
		</section>
		<!--顶部信息 结束-->

		<!--logo部分 开始-->

			<section class="width1000 logos">
			<a class="pingan" href="http://www.pingan.com" target="_blank" title="中国平安">中国平安</a>
			<a class="pinganbank" href="http://bank.pingan.com/index.shtml" target="_blank" title="平安银行">平安银行</a>
			<a class="line"></a>
			<a class="e" title="橙e网" href="http://www.orangebank.com.cn/index.html" target="_blank">橙e网</a>
			
		</section>
		<!--logo部分 结束-->
</#escape>





	
		