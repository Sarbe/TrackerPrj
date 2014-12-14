<%@page import="bean.User"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>

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

.rTrue {
	background-color: rgb(248, 229, 253);
}

.rFalse {
	background: #FFF;
}

div.parent {
	position: relative;
}

/* this div is a descendent of the div above */
div.child {
	top: 0;
	right: 0;
	bottom: 0;
	left: 0;
	opacity: .5;
	background-image: url("../images/gwt.gif");
	background-size: 200px 200px;
	background-position: center;
	background-repeat: no-repeat;
	filter: alpha(opacity = 50);
	-moz-opacity: 0.5;
	position: absolute;
}

.selectedValue {
	color: red;
}

.splitTask {
	background-color: green;
	color: white;
}

.deleteTask {
	background-color: red;
	color: white;
}

.darrow {
	background-image: url(../images/save.png) no-repeat 0 1px;
	cursor: pointer;
	position: relative;
	display: inline-block;
	background-color: white;
}

#refreshMsg {
	border: 2px solid red;
	height: 20px;
	width: 350px;
	background-color: white;
	color: black;
	font-weight: bold;
	position: fixed;
	bottom: 10px;
	left: 0;
	right: 0;
	margin: auto;
}


#resultDataList tr:hover{
background-color: orange;
}

</style>
<%
	User usr = (User) session.getAttribute("USER");
	ArrayList appGrps = (ArrayList) usr.getAppList();
	ArrayList statusGrps = (ArrayList) usr.getStatusList();
%>

<script type="text/javascript">

$(document).ready(function(){
	  
	
		// For first time load
		showBusy();
		$.ajax({
			type : "POST",
			url : "TKT",
			data : {
				method :'extract'
			},
			success : function(data) {
				displayData(data);
				hideBusy();
			}
		});
		
		
		///// - For populating the table data - Heart of the page - Change it carefully
		function displayData(dataList){
			$("#resultDataList tbody tr").remove();
				//var wflg=true;
				var color = true;
				var data = jQuery.parseJSON(dataList);
				var str = "";
				
				if (data.length > 0) {
					$.each(data,function(row) {
						var toPrint = true;
						if( <%=usr.getUserType().equals("N")%>&& this.Status=="Resolved"){
							toPrint = false;
						}
						if(toPrint){
							//For coloring the rows - same number tkts will be colored in grops while
							// maintaing the alternative colors
							var tktCur = this.Tkt_Number;
							var reopenCntCur = this.reopenCount;
							if (row != 0) {
								var tktPre = data[row - 1].Tkt_Number;
								var reopenCntPre = data[row - 1].reopenCount;
								if (tktCur==tktPre && reopenCntCur==reopenCntPre) {
									//wflg = true;
								} else {
									//wflg = false;
									color=!color;
								}
							}
							
							var isBold = (this.IsAttended=="Y")?"":"font-weight:bold;font-style: italic;";
							//alert(this.IsAttended+isBold);
							
							if(color)
								str = '<tr style="'+isBold+'" class="rTrue">' ;
							else{	
								str = '<tr style="'+isBold+'" class="rFalse">' ;
							}
							///////
							
							str +=  '<td>';
							<%if (!usr.getUserType().equals("S")) {%>
								if(!contains(this.resGrpsWorking,<%="'" + usr.getName() + "'"%>) && this.Status!="Resolved")	{
									if(this.WorkDoneBy!="" ){
										str +='<input type="button" value="S" style="font-size:10px;" class="splitTask" title="'+row+'_'+this.Tkt_Number+'">';
									}
								}
							<%}%>
							if(contains(this.resGrpsWorking,<%="'" + usr.getName() + "'"%>)&& this.Status!="Resolved")	{
								if(this.WorkDoneBy==<%="'" + usr.getName() + "'"%>){
								str +='<input type="button" value="D" style="font-size:10px;" class="deleteTask" title="'+row+'_'+this.Tkt_Number+'">';
								
								}
							}
									
							str +='</td><td>'
							+ (row + 1) 
							+ '<input type="hidden" size=1 id="reopenCnt_'+row+'_'+this.Tkt_Number+'" value="'+this.reopenCount+'"></td><td>'
							+ this.Tkt_Number
							+ '</td>'
							+ '<td><div class="pan" title="'+this.Long_Description+'" style="text-overflow: ellipsis;overflow:hidden;white-space:nowrap;width:15em; ">'
							+ this.Long_Description
							+ '</div></td>'
							+ '<td align="center">'
							+ this.Severity
							+ '</td>'
							+ '<td><div class="pan"  style="text-overflow: ellipsis;overflow:hidden;white-space:nowrap;width:12em; ">'
							+ this.Assignment_group
							+ '</div></td><td><div title="'+this.Opened_by+'" style="text-overflow: ellipsis;overflow:hidden;white-space:nowrap;width:8em;">'
							+ this.Opened_by
							+ '</div></td><td>'
							+ this.Opened_Dt
							+ '</td><td><span class="wby">';
							<% if(usr.getUserType().equals("N")){%>
								if(this.WorkDoneBy==""){
																			
									str+='<input type="text" size="10" style="color: blue;" readonly=readonly id="workBy_'+row+'_'+this.Tkt_Number+'" value="'+'<%=usr.getName()%>'+'">';
								}else{
									str+='<input type="text" readonly=readonly size="10"  style="color: red;" id="workBy_'+row+'_'+this.Tkt_Number+'" value="'+this.WorkDoneBy+'">';
								}
								
								<%}else{%>
								if(this.resGrpsAssigned.length>0){
									str+='<select id="workBy_'+row+'_'+this.Tkt_Number+'" style="width:100px;">';
									for(var i=0;i<this.resGrpsAssigned.length;i++){
										var o = (this.resGrpsAssigned[i]==this.WorkDoneBy)?'selected':'';
										if(o=='')
											str+='<option value="'+this.resGrpsAssigned[i]+'" '+o+' >'+this.resGrpsAssigned[i]+'</option>';
										else
											str+='<option class="selectedValue" value="'+this.resGrpsAssigned[i]+'" '+o+' >'+this.resGrpsAssigned[i]+'</option>';
									}
									str+='</select>';
									
								}else{
									str+='No Resource';
								}
									//str+='<input type="text" size="15" style="color: gray;" id="workBy_'+this.Tkt_Number+'" value="'+this.WorkDoneBy+'">';
								<%}%>	
							
							str+= '</span></td><td><span class="statusCls">'+ this.Status+ '</span></td><td>';
						
							<%if (usr.getUserType().equals("N")) {%>
							if(this.WorkDoneBy==""){
								str+='<input type="text" size="3" maxlength="5" class="numeric" id="timeTkn_'+row+'_'+this.Tkt_Number+'" value="'+this.timeTaken+'">';
							}else{
								if("<%=usr.getName()%>"== this.WorkDoneBy){
									str+='<input type="text" size="3" maxlength="5" class="numeric" id="timeTkn_'+row+'_'+this.Tkt_Number+'" value="'+this.timeTaken+'">';
								}else{
									str+=this.timeTaken;
								}
							}
							<%} else {%>
							str+='<input type="text" size="3" maxlength="5" class="numeric" id="timeTkn_'+row+'_'+this.Tkt_Number+'" value="'+this.timeTaken+'">';
							<%}%>
							
							str+= '</td><td>';
							//ACTION BUTTON
							
							<%if (usr.getUserType().equals("N")) {%>
							
								if(this.Status!="Resolved"){
									if(this.WorkDoneBy==""){
										str+='<input type="button" value="Assign" title="'+row+'_'+this.Tkt_Number+'" class="SaveAction">';
									}else{
										if("<%=usr.getName()%>"== this.WorkDoneBy){
											str+='<input type="button" value="Save" title="'+row+'_'+this.Tkt_Number+'" class="SaveAction">';
										}else{
											//Donot Show
										}
									}
								}
							<%} else {%>
								str+='<input type="button" value="Save" title="'+row+'_'+this.Tkt_Number+'" class="SaveAction">';
							<%}%>
							str += '</td></tr>';
							$("#resultDataList tbody").append(str);
						}
					});
					if($("#resultDataList tbody tr").length==0){
						str = '<tr><td colspan="12" align="center">No more Tickets</td></tr>';
						$("#resultDataList tbody").append(str);
					}
				} else {
					str = '<tr><td colspan="12" align="center">No more Tickets</td></tr>';
					$("#resultDataList tbody").append(str);
				}
			}
		
		// Supporting function for main function
		function contains(grp, key) {
	
			var flg = false;
			for ( var i = 0; i < grp.length; i++) {
				if (grp[i] == key)
					flg = true;
			}
			//alert(grp+key+flg);
			return flg;
		}

		////////////////////

		// For filtering the table data
		// Filtering data by group selection
		var groups = "";
		$(document.body).on("click",'.popupClass',function(e) {
			var idKey = this.id.split("_")[0];
			groups = "";
			
			$("."+idKey+"_chkbxClass:checked").each(function(n) {
				if (n == 0)
					groups += $(this).val();
				else
					groups += ","+ $(this).val();
			});
			//  if(groups!=""){
			//reseting the ticket filter criteria
			$("#tkt").val("");
			showBusy();
			$.ajax({
				type : "POST",
				url : "TKT",
				data : {
					grp : groups,
					method : 'tktAjax',
					filterType:idKey
				},
				success : function(data) {
					displayData(data);
					hideBusy();
				}
			});
		});
		
		function showBusy(){
			if ($('div.parent >div.child').length == 0)
				$('div.parent').append('<div class="child" />');	
		}
		
		function hideBusy(){
			$('div.child').remove();
			
		}
		// Filtering data by tkt no selectin

		$("#tkt").keyup(function() {
				var val = $(this).val().toUpperCase();
				$(".appGrps:checked").each(function(n) {
					$(this).prop('checked', false);
				});

				//	if(val.length>3){
				showBusy();
				$.ajax({
					type : "POST",
					url : "TKT",
					data : {
						key : val,
						method : 'tktAjax',
						filterType:'tktNo'
					},
					success : function(data) {
						displayData(data);
						hideBusy();
					}
				});
				//}
			});

			$(document.body).on("click", '.SaveAction',function(e) {
				var key = $(this).attr("title");
				var tkt = key.split("_")[1];
				//alert(tkt);
				var tmtkn = $("#timeTkn_" + key).val();
				var workby = $("#workBy_" + key).val();
				var reOpndCnt = $("#reopenCnt_" + key).val();
				
				if ( typeof(workby)=='undefined') {
					alertX("Group not Assigned to Anybody.");
				} else if ( workby=="") {
					alertX("Enter AssignedTo Name");
				} else {

					$.ajax({
						type : "POST",
						url : "TKT",
						data : {
							tktNo : tkt,
							workBy : workby,
							timeTkn : tmtkn,
							reOpened: reOpndCnt,
							method : 'saveTkt'
						},
						success : function(data) {
							displayData(data);
							alertX("Data Saved for "+tkt);
						}
					});

				}
			});

		// For spliting the row
		$(document.body).on("click", '.splitTask', function(e) {
			
			var key = $(this).attr("title");
			var tkt = key.split("_")[1];
			var reOpndCnt = $("#reopenCnt_" + key).val();
			//alert(tkt);
			$.ajax({
				type : "POST",
				url : "TKT",
				data : {
					tktNo : tkt,
					workBy :<%="'" + usr.getName() + "'"%>,
					reOpened:reOpndCnt,
					method :'splitTkt'
				},
				success : function(data) {
					displayData(data);
					alertX(tkt+" - Task Splited for "+"<%=usr.getName() %>");
				}
			});
			
		});		
		
		// For deleting the row
		$(document.body).on("click",'.deleteTask',function(e) {
			var key = $(this).attr("title");
			var tkt = key.split("_")[1];
			var reOpndCnt = $("#reopenCnt_" + key).val();
			$.ajax({
				type : "POST",
				url : "TKT",
				data : {
					tktNo:tkt,
					workBy:<%="'" + usr.getName() + "'"%>,
					reOpened:reOpndCnt,
					method :'deleteTask'
				},
				success : function(data) {
					displayData(data);
					alertX(tkt+" - Task Deleted for "+"<%=usr.getName() %>");
				}
			});
			
		});		
		
		
		////////////////////////////
		// Assignment group  logic
		
		$("#appgrp_Select").hide(); // Hide selects
		$("#popupMain").hide(); // Hide Popup
		$("#statusgrp_Select").hide();
		
		
		//$("#appgrp_Link").on('click',function(e){
		$(".popupLink").on('click',function(e){
			var idKey = $(this).attr("id").split("_")[0];
			//Removelist item first
			 $("#listValues li").remove();
			
			// Create options on onload once
			var data = $("#"+idKey+"_Select > option");
			
			
			
			//alert(groups);
			if (data.length > 0) {
				$(".searchPopUp").attr("name",idKey+"_search");	
				$(".searchPopUp").val("");
				
		 		$.each(data,function(i) {
					var val = data[i].value;
					str = '<li style="display: list-item;" class="liItems" id="id_'+val.replace(/ /g,'-').toUpperCase()+'"><label>'+
					'<input type="checkbox" id="'+idKey+'_'+i+'" class="'+idKey+'_chkbxClass  popupClass"'+ ((groups.lastIndexOf(val)!=-1)?'checked=checked':'') + '  value="'+val+'"><span>'+val+'</span>'+'</label></li>';
					//$("#listValues tbody").append(str);
					$("#listValues").append(str);
				});
			} 
			
			$("#popupMain").show(); //Show Popup
			var ht= $( this ).position().top;
			$("#popupMain").offset({
				left : $( this ).offset().left ,
				top :$( this ).offset().top+ht
				
			});
			$(".searchPopUp").focus();
		});
		
	
	 	$("#okbtn").click(function(){
	 		$("#popupMain").hide();
	 	});
	
	 	// $("#chk_all").click(function(){
	 		//$(".appgrp_chkbxClass").prop("checked",$(this).prop("checked"));
	 	 //});
	 	
	 	$(document.body).on("keyup",'.searchPopUp',function(e) {	
	 		
	 	
		var skey = $(this).val().toUpperCase();
		var idKey =$(this).attr("name").split("_")[0];
		
		var data = $("#listValues ."+idKey+"_chkbxClass");
		if (data.length > 0) {
			
			$.each(data,function(i) {
				var val = data[i].value.replace(/ /g,'-').toUpperCase();;				
				$("#id_"+val).css("display","list-item");
			});


			$.each(data,function(i) {
				var val = data[i].value.replace(/ /g,'-').toUpperCase();
				if(val.lastIndexOf(skey)==-1){
					$("#id_"+val).css("display","none");
				}
			});
		}
	}); 
	/////////////////////////////////////////////////
	$("#refreshMsg").hide();
	/*setInterval(function(){
		$.ajax({ 
 	    	
 	    	type : "POST",
			url : "TKT",
			data : {
				method :'refresh'
			},
 	    	
 	    	success: function(data){
 	    		var data = jQuery.parseJSON(data);
 	    		$("#refreshMsg").show();
 	    		$("#refreshMsg").html('<span style="color:red;">'+data+'</span> New Ticket(s) in your Area. <a href="TKT">Refresh</a> to see the tickets').fadeOut(10000);
 	    		
 	    	}
		});
}, 200000);*/
	
/* 		var a = 1;
	 	(function poll(){
	 		 $.ajax({ 
		 	    	
	 	    	type : "POST",
				url : "TKT",
				data : {
					method :'refresh'
				},
	 	    	
	 	    	success: function(data){
	 	    		displayData(data);
	 	    		alertX(a+=34);
	 	    	},  
	 	    	complete: poll, 
	 	    	timeout: 15000 
	 	    });
	 	})(); */
	 	$(document.body).on("keyup",'.numeric',function(e) {	
	 	//$(".numeric").keyup(function(){
	 		$(this).val($(this).val().replace(/[^0-9]/g,''));
	 	});

});
</script>
</head>
<body>
	<form action="">
	
	<div align="center" style="table-layout: auto; width: 100%;" id="content">
		<jsp:include page="header.jsp"></jsp:include>
		
		<%
			if (usr.getAppList().size() < 1) {
		%>
		<h1>User is not assigned to any group</h1>
		<%
			} else {
		%>
		
		
		<div style="border: 0px solid green; width: 1350px;height: 500px;background-color: white;padding-top: 15px;" class="parent">

			<table style="border-collapse: collapse;" align="center">
				<tr>
					<td style="padding: 0px; border-spacing: 0px; margin: 0px;">
						<table border="0"
							style="table-layout: fixed; border-collapse: collapse; white-space:normal;">

							<thead>
								<tr style="vertical-align: top;text-align: left;">
									<td width="30px">Split/ Del</td>
									<td width="30px">Sl No</td>
									<td width="100px">Ticket No<br>
									<input type="text" name="tkt" id="tkt" size="12" maxlength="12" style="background-color: #e6e6e6;">
									</td>
									<td width="180px">Description</td>
									<td width="60px">Severity</td>
									<td width="160px">
									<span id="appgrp_Link" style="text-decoration: underline;cursor: pointer;" class="popupLink">Assignment Group</span>
									<select id="appgrp_Select" name="appgrp_Select" multiple="multiple" style="height: 10px;" class="appGrps">
											<%
												for (int i = 0; i < appGrps.size(); i++) {
											%>
											<option value="<%=appGrps.get(i)%>"><%=appGrps.get(i)%></option>
											<%
												}
											%>
									</select>
									
									</td>
									<td width="120px">End User</td>
									<td width="130px">Opened Date</td>
									<td width="110px">Worked By <br></td>
									<td width="120px">
									<span id="statusgrp_Link" style="text-decoration: underline;cursor: pointer;" class="popupLink">Status</span>
									<select id="statusgrp_Select" name="statusgrp_Select" multiple="multiple" style="" class="statusGrps">
											<%
												for (int i = 0; i < statusGrps.size(); i++) {
											%>
											<option value="<%=statusGrps.get(i)%>"><%=statusGrps.get(i)%></option>
											<%
												}
											%>
									</select>
									
									
									</td>
									<td width="60px">Time Taken (in Mins)</td>
									<td width="60px">Action</td>
									<td width="20px"></td>

								</tr>
							</thead>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<div style="height: 400px; overflow-y: auto; text-align: left;">
							<table width="" border="0"
								style="table-layout: fixed; fixed; border-collapse: collapse;" id="resultDataList">
								<thead>
									<tr style="visibility: hidden;">
										<td width="30px"></td>
										<td width="30px"></td>
										<td width="100px"></td>
										<td width="180px"></td>
										<td width="60px"></td>
										<td width="160px"></td>
										<td width="120px"></td>
										<td width="130px"></td>
										<td width="110px"></td>
										<td width="120px"></td>
										<td width="60px"></td>
										<td width="60px"></td>
									</tr>
								</thead>
								<tbody>
								
								</tbody>
							</table>
						</div>
					</td>
				</tr>
			</table>


				<div id="popupMain">
					<div class="searchHeader">
						<div class="head" style="padding: 10px 0px;">
							Filter:<input placeholder="Enter keywords" type="text"	id="srchgrp" class="searchPopUp">
							<!-- div style="" align="left"><input type="checkbox" id="chk_all"> check All</div-->
						</div>
						<ul class="">
						</ul>
					</div>
					<div style="height: 100px; overflow-y: auto; text-align: left;" class="resultClass">
						<ul id="listValues">
							
						</ul>
					</div>
					<div class="ftrClass" style=""><input type="button" value="OK" id="okbtn"> </div>
				</div>


			</div>
			
			<div id="refreshMsg">
			</div>
			
	
	<%
		}
	%>
	</div>
		
	</form>
</body>
</html>