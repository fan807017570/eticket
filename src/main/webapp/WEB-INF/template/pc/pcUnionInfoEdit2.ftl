<!DOCTYPE html>
<html>
<#include "userCenter-base.ftl">

<@htmlHead title="联盟方信息完善">
</@htmlHead>
<link rel="stylesheet" href="${buyer_portal_static_resources_domain}/css/pc/union_style.css" />
<!--校验-->
<script type="text/javascript" src="${buyer_portal_static_resources_domain}/lib/Validform_v5.3.2_min.js"></script>
<script type="text/javascript">  
 	$(function(){ 
 		$("#unionAddForm").Validform({
			tiptype:3,
		});
 	});  
 </script>
<@htmlBody>
<#escape x as x?html>
	<section class="navAndbanner">
		<!--导航部分 开始-->
		<div class="nav">
			<ul class="width1000">
				<li>
					<a href="${buyer_portal_domain}/">橙e券首页</a> 
				</li>

			</ul>
		</div>
		<!--导航部分 结束-->
	</section>
	<section class="payment width1000">
		<ul class="tabList"> 
			<li><a href="#" onclick="chekAddMethod('tab0')">&nbsp;&nbsp;&nbsp;   批量导入    </a></li>
			<li><a href="#" onclick="chekAddMethod('tab1')">  单个新增   </a></li>
		</ul>
		<div class="content nopadding">
			<div class="createTicket" id="tab1" style="display:none;">
				<div class="createTicketFormSection">
					<div class="formbox selectarea">
						<form id="unionAddForm" name="createTicket" method="post" action="${buyer_portal_domain}/view/sinceManage/save">
							<input type="hidden" id='sysOrgId' name='sysOrgId' value='${orgInfoId}'>
							 <div class="item">
								<label class="font18">线下自提点</label>
							</div>
							<div class="item">
								<label><span>*</span>自提点名称：</label>
								<div class="inputs">
									<input type="text" name="sysOrgSinceName"  nullmsg="不能为空！"/>
								</div>
							</div>
							<div class="item">
								<label><span>*</span>地址：</label>
								<div class="inputs">
								<input type="text" name="sysOrgSinceAddr"  nullmsg="不能为空！"/>
								</div>
							</div>
							<div class="item">
								<label><span>*</span>联系人：</label>
								<div class="inputs">
									<input type="text" name="sysOrgSinceContact" datatype="name" nullmsg="请填写联系人姓名！" errormsg="请填联系人姓名！"/>
								</div>
							</div>
							<div class="item">
								<label><span>*</span>手机：</label>
								<div class="inputs">
									<input type="text" name="sysOrgSinceContactPhone" datatype="m" errormsg="请填写手机号码！如：18800000000" nullmsg="不能为空!"/>
								</div>
							</div>
							<div class="item">
								<label><span>*</span>营业时间：</label>
								<div class="inputs">
									<input type="text" name="sysOrgSinceBusinessHours" datatype="timeSlot" errormsg="请填营业时间!如:08:00-18:00" nullmsg="不能为空!"/>
								</div>
							</div>
						</form>
						<div class="btngroup">
								<input id="btn_save"  type="button" class="btn btn_orange" value="保存" />
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="content nopadding" id="tab0"  style="display:inline;">
				<div class="createTicket">
					 <form  id="importForm" enctype="multipart/form-data" method="post" action="${buyer_portal_domain}/view/cpnweb/importSinceSaveList">
						<div class="createTicketFormSection">
						  <table border="0" >
							<tr>
							   <td>选择文件：</td>
							   <td colspan="2">
							       <input name="file" id="file"  type="file" value="$!file" />  
							    </td>
								
								<td align="left">
									<input type="hidden" id='orgInfoId' name='orgInfoId' value='${orgInfoId}'>
								   	<input name="batchInput" id="batchInput" class="btn btn_orange" type="button" value="导入" onclick="importExcel()" style="cursor:pointer;"/>
								    <input name="download" id="download" class="btn btn_orange"  type="button" value="下载模版" onclick="downSinceTemplate()" style="cursor:pointer;"/>
								</td>
							</tr>
							<tr id="importTr">
							   <td>导入结果：</td>
							   <td colspan="3">
							       <span class="texttable">
								       <textarea rows="20" cols="62" >
								      	<#if (importMsg?? && importMsg.resutlMsg??)!>
								      		${importMsg.resutlMsg}
								      	</#if>
								      	<#if (importMsg?? && importMsg.sysOrgSinceDtoList??)!>
								      		
								      	</#if>
								       </textarea>
							       </span>
							   </td>
							</tr>
							</table>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
	</#escape>
</@htmlBody>
	
</html>

<script>
function downSinceTemplate(){
	window.location.href='${buyer_portal_domain}/view/cpnweb/downSinceTemplate';
}

function chekAddMethod(val){
	if(val=='tab0'){
		$("#tab1").css('display','none'); 
		$("#tab0").css('display','inline'); 
	}else{
		$("#tab0").css('display','none'); 
		$("#tab1").css('display','inline'); 
	}
}

function importExcel(){
	var path1 = jQuery("#file").val();
	if(path1==""){
		alert('请选择要导入的excel');
		return;
	}
	if(path1.substr(path1.lastIndexOf('.'))!=".xls" ){
		alert('请选择后缀xls的Excel文件导入');
		return;
	}
	jQuery('#importForm').submit();
} 

$(document).ready(function(){
	//保存按钮绑定提交表单
	$("#btn_save").click(function(){
		$("#unionAddForm").submit();	
	});
	$("#unionAddForm").Validform({
		btnSubmit:"#btn_save", 
		btnReset:"#btn_cancel",
		tiptype:3,
		datatype:{
		"tel":/(\(\d{3,4}\)|\d{3,4}-|\s)?\d{7}/,
		"mail":/[_a-z\d\-\./]+@[_a-z\d\-]+(\.[_a-z\d\-]+)*(\.(info|biz|com|edu|gov|net|am|bz|cn|cx|hk|jp|tw|vc|vn))$/,
		"not0":/^[1-9]\d*$/,
		"comname":/^[\u4E00-\u9FA5A-Za-z0-9]+$/,
		"name":/^[\u4E00-\u9FA5A-Za-z]+$/,
		"timeSlot":/([01]\d|2[0-3])\:([0-5]\d)-([01]\d|2[0-3])\:([0-5]\d)$/
		}
	});
})

</script>


