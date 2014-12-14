<%@page import="bean.User"%>
<%
	User usr = (User) session.getAttribute("USER");
%>
<div style="width: 100%; background-color: #4c66a4;">
	<div style="width: 1360px; height: 40px; background-color: #4c66a4;">
		<table style="width: 100%; height: 100%; margin: 0; border: 0px solid black;">
			<tr style="">
				<td width="10%"></td>
				<td width="40%"><span
					style="color: white; font-weight: bold; font-size: 30px; font-style: italic;">
					<a href="TKT" style="color: white; text-decoration: none;">
					Production
						Tracker</a></span></td>
				<td width="20%"></td>
				<td width="15%"><span style="color: white; font-weight: bold;">
				Hi <%=(usr.getFirstname()==null)?usr.getName():usr.getFirstname()%></span></td>
				<td width="15%">
					<ul class="ulInaRow">
						<li><a href="TKT" style="color: white;text-decoration: none;">Home</a></li>
						<li><a href="TKT?method=setup" style="color: white;text-decoration: none;">Setup</a></li>
						<li><a href="start.jsp" style="color: white;text-decoration: none;">Log Out</a></li>
					</ul>
				</td>
			</tr>
		</table>
	</div>

</div>
<!-- Footer -->
<div
	style="position: fixed; height: 20px; width: 150px; background-color: #000; color: #fff; font-weight: bold; bottom: 0px; right: 0px;">
	<a style="text-decoration: none; color: white; font-style: italic;"
		href="mailto:sarbeswar_sethi@infosys.com?Subject=Feedbcak/Suggestion for Production Tracker.&body=Hi,%0D%0ABelow are some few suggestion(s). %0D%0A">FeedBack/Suggestion</a>
</div>