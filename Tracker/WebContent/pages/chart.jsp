<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<jsp:include page="headerInfo.jsp"></jsp:include>
<script type="text/javascript">
	$(function() {
		$('#source').tableBarChart('#target', '', false);
	});
</script>
</head>
<body>
	<div id="target" style="width:3000px; height: 1000px"></div>
	<table id="source" style="visibility: hidden;">
		<caption>Ticket Count Analysis</caption>
		<thead>
			<tr>
				<th></th>
				<%
					Map map = (Map) request.getAttribute("TKTMAP");
					Iterator iterator = map.entrySet().iterator();
					while (iterator.hasNext()) {
						Map.Entry mapEntry = (Map.Entry) iterator.next();
				%>
				<th><%=mapEntry.getKey()%></th>
				<%
					}
				%>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>Ticket Count</th>
				<%
					iterator = map.entrySet().iterator();
					while (iterator.hasNext()) {
						Map.Entry mapEntry = (Map.Entry) iterator.next();
				%>
				<td><%=mapEntry.getValue()%></td>
				<%
					}
				%>
			</tr>
		</tbody>
	</table>
</body>
</html>