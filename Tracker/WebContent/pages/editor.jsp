<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<jsp:include page="headerInfo.jsp"></jsp:include>
<style type="text/css">
h1 {
	text-align: center;
	text-transform: uppercase;
	letter-spacing: -2px;
	font-size: 2.5em;
	margin: 20px 0;
}

.container {
	width: 90%;
	margin: auto;
}

table {
	border-collapse: collapse;
	width: 100%;
}

.blue {
	border: 2px solid #1ABC9C;
}

.blue thead {
	background: #1ABC9C;
}

.purple {
	border: 2px solid #9B59B6;
}

.purple thead {
	background: #9B59B6;
}

thead {
	color: white;
}

th,td {
	text-align: left;
	padding: 5px 0;
}

tbody tr:nth-child(even) {
	background: #ECF0F1;
}

tbody tr:hover {
	background: #BDC3C7;
	color: #FFFFFF;
}

.fixed {
	top: 0;
	position: fixed;
	width: auto;
	display: none;
	border: none;
}

.scrollMore {
	margin-top: 600px;
}

.up {
	cursor: pointer;
}

.des {
	text-overflow: ellipsis;
	overflow: hidden;
	white-space: nowrap;
	width: 15em;
}
</style>

<script type="text/javascript">

(function($) {
	   $.fn.fixMe = function() {
	      return this.each(function() {
	         var $this = $(this),
	            $t_fixed;
	         function init() {
	            $this.wrap('<div class="container" />');
	            $t_fixed = $this.clone();
	            $t_fixed.find("tbody").remove().end().addClass("fixed").insertBefore($this);
	            resizeFixed();
	         }
	         function resizeFixed() {
	            $t_fixed.find("th").each(function(index) {
	               $(this).css("width",$this.find("th").eq(index).outerWidth()+"px");
	            });
	         }
	         function scrollFixed() {
	            var offset = $(this).scrollTop(),
	            tableOffsetTop = $this.offset().top,
	            tableOffsetBottom = tableOffsetTop + $this.height() - $this.find("thead").height();
	            if(offset < tableOffsetTop || offset > tableOffsetBottom)
	               $t_fixed.hide();
	            else if(offset >= tableOffsetTop && offset <= tableOffsetBottom && $t_fixed.is(":hidden"))
	               $t_fixed.show();
	         }
	         $(window).resize(resizeFixed);
	         $(window).scroll(scrollFixed);
	         init();
	      });
	   };
	})(jQuery);

	$(document).ready(function(){
	   $("table").fixMe();
	   $(".up").click(function() {
	      $('html, body').animate({
	      scrollTop: 0
	   }, 2000);
	 });
	   
	   $("#exe").click(function(){
		   if($("#qry").text()!=""){
				document.frm.action="SetUp";
				$("#method").val("editor");
				document.frm.submit();
		   }else{
			   alertX("Enter Query");
		   }
		});
	   $("#dwnldData").click(function(){
		   if($("#qry").text()!=""){
				document.frm.action="SetUp";
				$("#method").val("dwnldData");
				document.frm.submit();
		   }else{
			   alertX("Enter Query");
		   }
		});
	   $("#queries").change(function(){
		   
		   $("#qry").text($(this).val());
	   })
	   
	   
	   //request.setAttribute("MSG",msg);
	   <%if(request.getAttribute("MSG") != null &&!request.getAttribute("MSG").equals("")){%>
  		alert('<%=request .getAttribute("MSG")%>');
  		<%}%>
	});
</script>
</head>
<body>
	<form action="" name="frm">
		<input type="hidden" name="method" id="method">
		<div align="center" style="table-layout: auto; width: 100%;"
			id="content">
			<jsp:include page="header.jsp"></jsp:include>
			<div
				style=" width: 1350px; height: 500px; background-color: white; padding-top: 15px;"
				class="parent">

				<div style="width: 1200px; height: 150px;">
				<select style="width: 1000px;" id="queries">
				<%List queries = (List)request.getAttribute("queries");
				if(queries!=null){
				for(int z=0;z<queries.size();z++){
				%>
				<option><%=queries.get(z) %></option>
				<%}} %>
				</select>
					<textarea name="qry" style="width: 1100px; height: 110px;" id="qry"> <%=request.getAttribute("qry") != null ? request .getAttribute("qry") : ""%></textarea>
				</div>
				<div style="height: 50px;"><input type="button" value="RUN" id="exe" ></div>
				<div><button id="dwnldData">Download</button> </div>
				<div
					style="width: 1200px; height: 350px; border: 0px solid green; overflow: auto;">
					<%
						List<List<String>> table = (List<List<String>>) session.getAttribute("TBL");
						if (null != table) {
							List<String> header = table.get(0);
					%>
					<table class="blue" >
						<thead>
							<tr>
								<%
									for (int i = 0; i < header.size(); i++) {
								%>
								<td><%=header.get(i)%></td>
								<%
									}
								%>
							</tr>
						</thead>
						<tbody>
							<%
								for (int i = 1; i < table.size(); i++) {
										List<String> data = table.get(i);
							%>
							<tr>

								<%
									for (int j = 0; j < data.size(); j++) {
								%>
								<td><div class="des"><%=data.get(j)%></div></td>
								<%
									}
								%>
							</tr>
							<%
								}
							%>

						</tbody>
					</table>
					<%
						}
					%>
				</div>
			</div>
		</div>

	</form>
</body>
</html>