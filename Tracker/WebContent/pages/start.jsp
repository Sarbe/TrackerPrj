<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Production Tracker</title>
<jsp:include page="headerInfo.jsp"></jsp:include>
<script type="text/javascript">
	$(document).ready(function() {
		$("#userName").focus();
		
		$("#next").click(function() {
			if ($("#userName").val() == "")
				alert("Please Enter your NT ID");
			else
				document.frm.submit();
		});
		
		
	});
</script>
<style type="text/css">
.bigStyle{
height: 40px;
}
</style>
</head>
<body onload="">
	<form action="TKT" name="frm" method="post">
	<input type="hidden" value="next" name="method">
		<div align="center"
			style="border: 0px solid red; height: 80px; width: 400px; background-color: transparent;" class="centerDiv">
			<table border=0 style="border:0px;">
				<tr>
					<td colspan="3" ><span
						style="color: #CCF; text-shadow: black 0.2em 0.2em 0.1em;font-stretch: wider;"><span style="font-size: 40px;">Production
							Tracker</span></span></td>
				</tr>
				<tr>
					<td align="left" width="20px;"><input type="text" name="userName" id="userName" placeholder="Enter Your NT ID" autocomplete="off" style="height: 40px;width: 270px;font-size: 25px;">
					</td>
					<td align="left"><input type="button" value="Next" id="next" style="height: 44px;width:65px;font-size: 20px; "></td>
				</tr>
				
			</table>
		</div>



	</form>
</body>
</html>