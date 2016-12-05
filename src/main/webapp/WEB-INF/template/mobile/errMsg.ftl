<!DOCTYPE html>
<html style="font-size: 36px;">
<#include "base.ftl">
<@htmlHead title="我的橙e券">
</@htmlHead>
<@htmlBody >
<#escape x as x?html>
	<div class="useTicket">
		<div class="bgF6 content">
			<p><span>${errMsg}</span></p> 
		</div> 
	</div>
	</#escape>
</@htmlBody>
</html>