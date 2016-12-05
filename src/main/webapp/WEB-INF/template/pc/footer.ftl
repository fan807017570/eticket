<#escape x as x?html>
		<footer>
			<section>
				<div class="left">
					<ul>
						<li>
							<a href="http://www.orangebank.com.cn/cejs-newlife.html"  target="_blank">关于橙e网</a>
						</li>
						<span class="cut-line"></span>
						<li>
							<a href="http://www.orangebank.com.cn/join.html"  target="_blank">如何加入</a>
						</li>
						<span class="cut-line"></span>
						<li>
							<a href="http://www.orangebank.com.cn/succeecase.html" target="_blank">成功案例</a>
						</li>
						<span class="cut-line"></span>
						<li>
							<a href="http://www.orangebank.com.cn/help.html" target="_blank">帮助中心</a>
						</li>
						<span class="cut-line"></span>
						<li>
							<a href="http://www.orangebank.com.cn/statement.html" target="_blank">网站申明</a>
						</li>
						<span class="cut-line"></span>
						<li>
							<a href="http://www.orangebank.com.cn/sitemaps.html" target="_blank">网站地图</a>
						</li>
					</ul>
					<p>版权所有©平安银行股份有限公司 未经许可不得复制、转载或者摘编，违者必究</p>
					<p>Copyright © PingAn Bank CO., Ltd. All Rights Reserved</p>
					<p><img src="${buyer_portal_static_resources_domain}/img/pc/icp_police.gif" />备案/许可证编号：粤ICP备11018345号-2</p>
				</div>
				<div class="right">
					<img src="${buyer_portal_static_resources_domain}/img/pc/weix2.gif" />
					<p>扫一扫，橙e网手机版</p>
				</div>
			</section>
		</footer> 
		
		
			    
	    <script type="text/javascript">
			
			function logout(){
				var myDate = new Date();
				var sysTime = myDate.getTime();
				var targetUrl ="${buyer_portal_outer_url}/logout";				
				var logOutUrl = "${buyer_pc_logout_url}?t="+sysTime+"&targeturl="+targetUrl;
				window.location=logOutUrl;
			}
		</script>
		</#escape>