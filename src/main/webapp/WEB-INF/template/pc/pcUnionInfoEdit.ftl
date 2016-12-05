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
		<div class="content nopadding">
			<div class="createTicket">
				<div class="createTicketFormSection">
					<div class="formbox selectarea">
						<header>
							联盟方信息完善
						</header>
						<form id="unionAddForm" name="createTicket" method="post" action="${buyer_portal_domain}/view/cpnweb/pcUnionInfoSave">
							<!--橙e网字段信息开始-->
							<input type="hidden" name="sysOrgId" value="${orgInfo.sysOrgId!}"><!-- id -->
							<input type="hidden" name="sysOrgCode"  value="${orgInfo.sysOrgCode!}" /><!-- 编码sysOrgCode -->
							<input type="hidden" name="sysOrgFullCode"  value="${orgInfo.sysOrgFullCode!}" /><!-- 全编码sysOrgFullCode -->
							<input type="hidden" name="sysOrgEpType"  value="${orgInfo.sysOrgEpType!}" /><!--企业类型:0:运营方,1:联盟方,2:推广方 sysOrgEpType-->
							<input type="hidden" name="sysOrgKind"  value="${orgInfo.sysOrgKind!}" /><!-- 可用类型（org:机构,dpt:部门;）sysOrgKind -->
							<input type="hidden" name="sysOrgLevel"  value="${orgInfo.sysOrgLevel!}" /><!-- 级别 sysOrgLevel-->
							<input type="hidden" name="sysOrgName" value="${orgInfo.sysOrgName}"/><!--联盟方名称-->
							<input type="hidden" name="sysOrgPersonDto.sysOrgPersonTrueName value="1"/><!--管理员姓名-->
							<input type="hidden" name="sysOrgPersonDto.sysOrgPersonLoginName" value="1"/><!--管理员登录帐号-->
							<input type="hidden" name="sysOrgPersonDto.sysOrgPersonPhone" value="1"/><!--管理员手机-->
							<input type="hidden" name="sysOrgMobile" value="${orgInfo.sysOrgMobile}"/><!--管理员座机-->
							<input type="hidden" name="sysOrgPersonDto.sysOrgPersonEmail" value="1"/><!--管理员邮箱-->
							<!--橙e券完善信息-->
							<div class="item">
								<label><span>*</span>所属省市区：</label>
								<div class="inputs">
									<select id="pro"  class="city" >
										<option selected="selected" value="0">请选择省</option>
										<#list pros as pro >
											<option  value="${pro.sysAreaId}">${pro.sysAreaName}</option>
										</#list>
									</select>
									<select id="city"  class="city" >
										<option selected="selected" value="0">请选择市</option>
									</select>
									<select id="area" class="city" name="sysOrgAreaId" datatype="not0" nullmsg="请选择省市区！" errormsg="请选择省市区！">
										<option selected="selected" value="0">请选择区</option>
									</select>
								</div>
							</div>
							<div class="item">
								<label><span>*</span>详细地址：</label>
								<div class="inputs">
									<input type="text" name="sysOrgAddr" datatype="s4-100" nullmsg="请填写地址！" errormsg="请填写地址！"/>
								</div>
							</div>
							<div class="item">
								<label><span>*</span>公司规模：</label>
								<div class="inputs">
									<select name="sysOrgScale" datatype="not0" nullmsg="请选择规模！" errormsg="请选择规模！">
										<option selected="selected" value="0">请选择</option>
										<#list scales as scale>
											<option value="${scale.sysDataCodeId}">${scale.sysDataCodeName}</option>
										</#list>
									</select>
								</div>
							</div>
							<div class="item">
								<label><span>*</span>所属行业：</label>
								<div class="inputs">
									<select name="sysOrgIndustry" datatype="not0" nullmsg="请选择行业！" errormsg="请选择行业！"> 
										<option selected="selected" value="0">请选择</option>
										<#list industrys as industry>
											<option value="${industry.sysDataCodeId}">${industry.sysDataCodeName}</option>
										</#list>
										
									</select>
								</div>
							</div>
						</form>
						<div class="btngroup">
							<input id="btn_save"  type="button" class="btn btn_save" value="下一步" />
							<input id="btn_cancel" type="reset" class="btn btn_gray" value="取消" onclick="javascript:history.back()"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
</#escape>

</@htmlBody>
	
</html>

<script>
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
		//为省级菜单选项,添加change 事件
		$("#pro").change(function(){
			var areaId=$(this).val();
			if(areaId>0){
				$.getJSON("${buyer_portal_domain}/view/cpnweb/ajaxAreas?areaId="+areaId,function(result){
					//var areaobjs = result.sysAreaDtoList;
					var areaobjs = result;
					var sltop = '<option selected="selected" value="0">请选择市</option>';
					for(var i=0;i<areaobjs.length;i++){
		    			sltop += '<option value="'+ areaobjs[i].sysAreaId +'">'+ areaobjs[i].sysAreaName +'</option>';				
					}
					$("select[id='city']").html(sltop);
					$("select[id='area']").html('<option selected="selected" value="0">请选择区</option>');
		    	});
			}
		});
		$("#city").change(function(){
			var areaId=$(this).val();
			if(areaId>0){
				$.getJSON("${buyer_portal_domain}/view/cpnweb/ajaxAreas?areaId="+areaId,function(result){
					//var areaobjs = result.sysAreaDtoList;
					var areaobjs = result;
					var sltop = '<option selected="selected" value="0">请选择区</option>';
					for(var i=0;i<areaobjs.length;i++){
		    			sltop += '<option value="'+ areaobjs[i].sysAreaId +'">'+ areaobjs[i].sysAreaName +'</option>';				
					}
					$("select[id='area']").html(sltop);
		    	});
			}
		});
	});
</script>




