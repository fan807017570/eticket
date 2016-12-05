<#escape x as x?html>			  		
			  		
			  				
								<!-- 根据不同的商品类别显示不同背景色 -->
									
								<#if (cpn.parentClassId)?? >
									  <#if cpn.parentClassId == 1 >
									  <li class="blue" onclick="gotoDetailPage(${cpn.topicId!})" style="cursor:pointer">
										<div class="ticket_base ticket_blue"> 
										<#elseif cpn.parentClassId == 2 >
										  <li class="green" onclick="gotoDetailPage(${cpn.topicId!})" style="cursor:pointer">
										<div class="ticket_base ticket_green">
										<#elseif cpn.parentClassId == 3 >
										<li class="orange" onclick="gotoDetailPage(${cpn.topicId!})" style="cursor:pointer">
										<div class="ticket_base ticket_orange">
										<#elseif cpn.parentClassId == 4 >
										<li class="darkblue" onclick="gotoDetailPage(${cpn.topicId!})" style="cursor:pointer">
										<div class="ticket_base ticket_darkblue">
										<#elseif cpn.parentClassId == 5 >
										<li class="yellow" onclick="gotoDetailPage(${cpn.topicId!})" style="cursor:pointer">
										<div class="ticket_base ticket_yellow">
										<#elseif cpn.parentClassId == 6 >
										<li class="purple" onclick="gotoDetailPage(${cpn.topicId!})" style="cursor:pointer">
										<div class="ticket_base ticket_purple">
										<#else>
										<li class="orange" onclick="gotoDetailPage(${cpn.topicId!})" style="cursor:pointer">
										<div class="ticket_base ticket_orange"> 
									</#if>
							  </#if>
										<#if cpn.topicClass=="CLASS-1" >
										     <div class="price left">
										     <#if cpn.oriPrice?length gt 2 >
										    	 <div class="bigNum">￥<span>${cpn.oriPrice!}</span></div>
										     <#else >
												 <div>￥<span>${cpn.oriPrice!}</span></div>
											</#if>
												<div class="text">元现金券</div>
											</div>
										<#elseif cpn.topicClass=="CLASS-2" > 
											<div class="price left">
												<div class="reach">满<b>${cpn.fullPrice!}</b></div> 
												<div class="discount">减<b>${cpn.offPrice!}</b></div>
												
  										     </div>

										<#elseif cpn.topicClass=="CLASS-3" >
										<div class="price left">
											
											<div class="onSale">
												 <span>${cpn.percentPrice!}</span>
												 <span>折</span>
											</div>
											
											<div class="name">${cpn.couponName!}</div>
												
										</div>
											<#else> 
										<div class="diy left">
											<span>${cpn.couponName!}</span>
												
										</div>
										</#if>	
											<div class="getTicket right">
										<#if cpn.pcWebPicUrl?? && cpn.pcWebPicUrl!="" >
											<a href="${buyer_portal_domain}/view/cpnweb/cpnDetail?topicId=${cpn.topicId!}"><img src="${cpn.pcWebPicUrl!}"/></a>
										<#else>
											<a href="${buyer_portal_domain}/view/cpnweb/cpnDetail?topicId=${cpn.topicId!}"><img src="${buyer_portal_static_resources_domain}/img/pc/ningmeng.png"/></a>
										</#if>
											
											<a href='${buyer_portal_domain}/view/cpnweb/cpnDetail?topicId=${cpn.topicId!}' class="f-getTicketBtn">立即领取</a>
											</div>				
									</div>

									<div class="timeAndNumber">
									<#if cpn.started == true >
										<div class="left first-child">剩余:<span>${cpn.days!}</span>天</div>
									<#else >
										<div class="left">距开始:<span>${cpn.days!}</span>天</div>
									</#if>
										<div class="last-child">已领数量:<span>${cpn.takenCount!}</span></div>
										
									</div>
									
						</li>
</#escape>