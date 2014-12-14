
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

</style>


<script type="text/javascript">
	$(document).ready(function() {

	});
</script>
</head>
<body>
	<form action="">

		<div align="center" style="table-layout: auto; width: 100%;">
			

			<div style="height: 20px; font-size: 30px;">
				<h1><%=request.getAttribute("MSG") %></h1>

			</div>
			
<div style="padding-top: 50px;font-size: 15px; color: green;"><span>For access contact your immediate supervisor or mail to 
<a href="mailto:sarbeswar_sethi@infosys.com?Subject=Need access to Tracker.&body=Hi,%0D%0APlease add me to the group. %0D%0ARegards, %0D%0A<%=session.getAttribute("USERNAME")%>">
Super Admin</a> </span> </div>
		</div>
	</form>
</body>
</html>