<%@page import="bean.User"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>	
<jsp:include page="headerInfo.jsp"></jsp:include>

<style type="text/css">
html {
	font-family: arial;
	font-size: 9px;
}

.head {
	background-color: #6199df;
	color: white;
	font-weight: bold;
	text-align: center;
}
.txt{
border-color:transparent;
background-color: transparent;
text-align: center;
width: 100px;
}
.txt:hover{
border: 1px solid #4d90fe;

}

.delete-icon{
background-image: url(../images/trash.png);
cursor: pointer;
height: 24px;
width: 24px;

}
.save-icon{
background-image: url(../images/save.png);
cursor: pointer;
height: 24px;
width: 24px;

}

</style>


<%
	User usr = (User) session.getAttribute("USER");
	//List rsrList = (List) session.getAttribute("RSRLIST");
%>

<script type="text/javascript">
	$(document).ready(function() {
	
	<%if (request.getAttribute("MSG") != null) {%>
		alertX('<%=request.getAttribute("MSG")%>');
	<%}%>
		
		$(document.body).on("click",'.appgroups',function(e) {
			if($("#rsrNm").val()=="" && $(".appgroups:checked").length > 0){
				alertX("Please enter name first");	
				return false;			
			}
		});
	
		$("#save").click(function(){
			
		var flag = true;
		var groups = "";
		
		if($("#rsrNm").val()==""){
			flag = false;
			alertX("Enter Name");
		}
	
		if($(".appgroups:checked").length==0){
			flag = false;
			alertX("Choose Some application");
		}else{
			$(".appgroups:checked").each(function(n) {
				if (n == 0)
					groups += $(this).val();
				else
					groups += ","+ $(this).val();
			});
		}
		if(flag)
			
			document.frm.submit();
			
			/* $.ajax({
				type : "POST",
				url : "TKT",
				data : {
					method :'assign',
					rsrNm : $("#rsrNm").val(),
					appgrps : groups,
					usertype : $("#usertype").val()
				},
				success : function(data) {
					var data = jQuery.parseJSON(data);
					$("#rsrNm").val("");
					if(data=="SUCCESS")
						alertrX("Data Saved Successfully");
					else
						alertrX("Error. Please Try again...");
				}
			}); */
		
		});
		
		$("#rsrNm").blur(function(){
			$.ajax({
				type : "POST",
				url : "TKT",
				data : {
					method :'extractGrpDetails',
					nameKey:$(this).val()
				},
				success : function(data) {
					var data = jQuery.parseJSON(data);
					
					 $(".appgroups:checked").each(function(n){
						$(this).prop('checked', false);
					 });
					 
					 $("#usertype").val(data.userType);
					
					 var appgrp = data.appList;
					for(var i=0;i<appgrp.length;i++){
						$("#chk_"+appgrp[i]).prop('checked', true);
						
					}
				}
			});
		});
			
			// Application By Resource
			$("#resourceNm").blur(function(){
				$(this).val($(this).val().toUpperCase());
				$.ajax({
					type : "POST",
					url : "TKT",
					data : {
						method :'extractGrpDetails',
						nameKey:$(this).val()
					},
					success : function(data) {
						var data = jQuery.parseJSON(data);
						$("#appGrp li").remove();
						var utype = data.userType=='N'?"Normal":data.userType=='A'?"Admin":"Super Admin";
						$("#rsrUsertype").val(utype);
						var str = "";
						var appgrp = data.appList;
						for(var i=0;i<appgrp.length;i++){
							str = '<li style="display: list-item;" ><label>'+
							'<span>'+appgrp[i]+'</span>'+'</label></li>';
							$("#appGrp").append(str);
							
						}
					}
				});
				
			});
		
			// Resource By Application
			$("#appNm").blur(function(){
				$(this).val($(this).val().toUpperCase());
				$.ajax({
					type : "POST",
					url : "TKT",
					data : {
						method :'rsrByApplication',
						appNm:$(this).val()
					},
					success : function(data) {
						var data = jQuery.parseJSON(data);
						$("#rsrDetails li").remove();
						$.each(data,function(i) {
							str = '<li style="display: list-item;" ><label>'+
							'<span>'+data[i]+'</span>'+'</label></li>';
							$("#rsrDetails").append(str);
						});
					}
				});
				
			});
			
			
		
			
			
		
		/////////////////////
			<%String appString = new Gson().toJson(usr.getAppList());%>
		
			var data = jQuery.parseJSON(<%="'" + appString + "'"%>);
			var str = "";
			if (data.length > 0) {
				$.each(data,function(i) {
					str = '<li style="display: list-item;" class="liItems" id="li_'+data[i]+'"><label>'+
					'<input type="checkbox" class="appgroups" name="appsListgrp" id="chk_'+data[i]+'" value="'+data[i]+'"><span>'+data[i]+'</span>'+'</label></li>';
					$("#grpTbl").append(str);
				});
			}
		
		$("#srchgrp").on("click blur keyup ",function(e) {
			var skey = $(this).val().toUpperCase();
			var data = jQuery.parseJSON(<%="'" + appString + "'"%>);
			
			 if (data.length > 0) {
				 	$.each(data,function(i) {
					$("#li_"+data[i]).css("display","list-item");
				}); 

				 $.each(data,function(i) {
				if(data[i].lastIndexOf(skey)==-1){
					$("#li_"+data[i]).css("display","none");
					}
				}); 
			}
		});
		
		////////////////
		//Resource Details
		
		$.ajax({
			type : "POST",
			url : "SetUp",
			data : {
				method :'extract'
			},
			success : function(data) {
				displayData(data);

			}
		});
		
		
		///// - For populating the table data -  - Change it carefully
		var usrType = ["A", "N"];
			var aFlag = ["Y","N"];
		function displayData(dataList){
			
			$("#maintable tbody tr").remove();
				var data = jQuery.parseJSON(dataList);
				var str = "";
				if (data.length > 0) {
					$.each(data,function(row) {
						str = '<tr align="center"><td>'
						+ (row + 1) 
						+ '</td><td> <span>'+ this.name+'</span>'
						+ '</td><td> <input type=text class="txt" value="'+ this.password+'" id="pwd_'+this.name+'">'
						+ '</td><td><select id="actFlg_'+this.name+'">';
						for(var t=0;t<aFlag.length;t++){
							var iaS = (aFlag[t]==this.isActive)?'selected':'';
							var ia = (aFlag[t]=="Y")?'YES':'NO';
							str +='<option '+iaS+' value="'+aFlag[t]+'" >'+ia+'</option>';
						}
						str += '</select>'
						+ '</td><td><select id="uType_'+this.name+'">';
						
						for(var t=0;t<usrType.length;t++){
							var utS = (usrType[t]==this.userType)?'selected':'';
							var ut = (usrType[t]=="N")?'NORMAL':'ADMIN';
							str +='<option '+utS+' value="'+usrType[t]+'" >'+ut+'</option>';
						}
						str += '</select>'
						+'</td><td>'
						+'<div class="tbl"><div class="tbl-row"><div class="save-icon tbl-cell"  id="'+row+'_Savebtn_'+this.name+'"></div>'
						+'<div class="delete-icon tbl-cell" id="Dltbtn_'+this.name+'">'
						+'</div></div></div>';
						str += '</td></tr>';
						
						$("#maintable tbody").append(str);
		
					});
				} else {
					str = '<tr><td colspan="13" align="center">No records Found</td></tr>';
					$("#maintable tbody").append(str);
				}
			}
		
		
		$(document.body).on("click",'.save-icon',function(e) {
			
			var idval = this.id;
			
			var indx = idval.split("_")[0];
			var rsrNm = idval.split("_")[2];
			var pwd = $("#pwd_"+rsrNm).val();
			var uType = $("#uType_"+rsrNm).val();
			var actFlg = $("#actFlg_"+rsrNm).val();
			$.ajax({
				type : "POST",
				url : "SetUp",
				data : {
					method :'updateUser',
					INDX:indx,
					password:pwd,
					userType:uType,
					activeFlg:actFlg
				},
				success : function(data) {
					if(data!=""){
						displayData(data);
						alertX("User Updated Successfully");
					}else{
						alertX("There is a error. Contact Suuport Team.");
					}
				}
			});
		});
		
		//Remove User
		$(document.body).on("click",'.delete-icon',function(e) {
			//$(".delete-icon").click(function(){
				var idval = this.id;
				var rsrname = idval.split("_")[1];
				$.ajax({
					type : "POST",
					url : "SetUp",
					data : {
						method :'removeUser',
						usrNm:rsrname
					},
					success : function(data) {
						if(data!=""){
							displayData(data);
							alertX("User Removed Successfully");
						}else{
							alertX("There is a error. Contact Suuport Team.");
						}
					}
				});
				
			});
		
		$("#fdwnld").click(function(){
			document.frm.action="SetUp";
			$("#method").val("fileDwnld");
			document.frm.submit();
		});
		
		$("#editor").click(function(){
			document.frm.action="SetUp";
			$("#method").val("editor");
			document.frm.submit();
		});
		
	});
</script>
</head>
<body>
	<form action="SetUp" name="frm" method="post">
		<input type="hidden" name="method" id="method" value="assign">
		<a href="SetUp?method=chart">chart</a>
		<div align="center"
			style="table-layout: auto; width: 100%; height: 600px; vertical-align: top;"
			id="content">
			<jsp:include page="header.jsp"></jsp:include>
			<input type="button" value="Download" id="fdwnld">
			<input type="button" value="sqlEditor" id="editor">
			<table style="width: 100%; height: 100%; vertical-align: top;"
				cellspacing="20px;" cellpadding="20px;" border="0">
				<tr valign="top">
					<td><div
							style="border: 0px solid green; width: 250px; height: 250px;">
							<table style="width: 250px; height: 200px;" border="0">
								<tr>
									<td>
										<div class="head">Application Allocation</div>
										<div align="center">

											<table border="0">
												<tr>
													<td>Name:</td>
													<td><input type="text" name="rsrNm" id="rsrNm"
														placeholder="Existing/New Name" autocomplete="off"></td>
												</tr>
												<tr>
													<td>User Type:</td>
													<td><select name="usertype" id="usertype">
															<%
																if (usr.getUserType().equals("S")) {
															%>
															<option value="A">ADMIN</option>
															<%
																}
															%>
															<option value="N">NORMAL</option>
													</select></td>
												</tr>
											</table>
											<br>

										</div>
									</td>
								</tr>
								<tr>
									<td>
										<div class="" style="display: block; border: 1px solid gray;">
											<div class="">
												<div class="head">
													Filter:<input placeholder="Enter keywords" type="text"
														id="srchgrp">
												</div>
												<ul class="">
												</ul>
											</div>
											<div
												style="height: 150px; overflow-y: auto; text-align: left;">
												<ul id="grpTbl">
												</ul>
											</div>
											<div></div>
										</div>
									</td>
								</tr>
								<tr>
									<td align="center"><input type="button" value="Save"
										id="save"></td>
								</tr>
							</table>

						</div></td>
					<td><div
							style="border: 0px solid green; width: 250px; height: 300px;">
							<table style="width: 250px; height: 250px;" border="0">
								<tr>
									<td>
										<div class="head">Application By Resource</div>
										<div align="center">
											<table border="0">
												<tr>
													<td>Name:</td>
													<td><input type="text" name="resourceNm"
														id="resourceNm" placeholder="Enter Name"></td>
												</tr>
												<tr>
													<td>User Type:</td>
													<td><input type="text" id="rsrUsertype"
														disabled="disabled"></td>
												</tr>
											</table>

										</div>
									</td>
								</tr>
								<tr>
									<td>
										<div class="" style="display: block; border: 1px solid gray;">
											<div
												style="height: 200px; overflow-y: auto; text-align: left;">
												<ul id="appGrp">
												</ul>
											</div>
										</div>
									</td>
								</tr>
							</table>

						</div></td>

					<td><div
							style="border: 0px solid green; width: 250px; height: 300px;">
							<table style="width: 250px; height: 250px;" border="0">
								<tr>
									<td>
										<div class="head">Resource By Application</div>
										<div align="center">
											Name:<input type="text" name="appNm" id="appNm"
												placeholder="Enter Application name"><br>
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<div class="" style="display: block; border: 1px solid gray;">
											<div
												style="height: 200px; overflow-y: auto; text-align: left;">
												<ul id="rsrDetails">
												</ul>
											</div>
										</div>
									</td>
								</tr>
							</table>

						</div></td>
				</tr>
				<tr>
					<td colspan="3" align="center">

						<table style="border-collapse: collapse;" align="center">
							<tr>
								<td style="padding: 0px; border-spacing: 0px; margin: 0px;">
									<table border="1"
										style="table-layout: fixed; border-collapse: collapse; white-space: normal;">

										<thead>
											<tr>
												<td colspan="7" align="center"
													style="background-color: transparent;">
												<td>
											</tr>
											<tr style="vertical-align: top; text-align: center;">

												<td width="30px">Sl No</td>
												<td width="150px">Resource Name</td>
												<td width="100px">Password</td>
												<td width="80px">Active Flg</td>
												<td width="120px">User Type</td>
												<td width="80px">Action</td>
												<td width="20px"></td>

											</tr>
										</thead>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<div style="height: 200px; overflow-y: auto; text-align: left;">
										<table width="" border="1"
											style="table-layout: fixed; fixed; border-collapse: collapse;"
											id="maintable">
											<thead>
												<tr>
													<td width="30px"></td>
													<td width="150px"></td>
													<td width="100px"></td>
													<td width="80px"></td>
													<td width="120px"></td>
													<td width="80px"></td>
												</tr>
											</thead>
											<tbody>
												<!-- Data will be displayed here -->
											</tbody>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>