<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<script type="text/javascript" src="./../js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="./../js/jquery.highchartTable.js"></script>
<script type="text/javascript" src="./../js/highcharts.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	  $('table.highchart').highchartTable();
	});
</script>
<script language="javascript">
<%request.setAttribute("ABC", "Text Message"); %>
function openwindow()

{

window.open("target.jsp","_blank","height=200,width=400,status=yes,toolbar=no,menubar=no,location=no")

}

</script>
</head>
<body>
<input id=text1 type=text>

<input type=button onclick="javascript:openwindow()" value="Open window..">

	<table border=1>
		<tr style="background-color: blue;">
			<td>TKTNO</td>
			<td>DESCRIPTION</td>
			<td>SEVERITY</td>
			<td>ASSIGNMENT_GRP</td>
			<td>END_USER</td>
			<td>OPENED_BY</td>
			<td>OPENED_DT</td>
			<td>STATUS</td>
			<td>ATTENDED</td>
			<td>CAUSE_OF_INCIDENT</td>
			<td>REOPEN_CNT</td>
			<tr>
		<tr>
			<td>INC000383882</td>
			<td>Jumpstring 50.7.131 did not extract correct relay containers . 9 containers are missing in 50.7.131 file .</td>
			<td>4</td>
			<td>GIT-APP-ETC</td>
			<td>Wizard Wu</td>
			<td>anaha</td>
			<td>2014-4-22.0.0. 0. 0</td>
			<td>Work in Progress</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000395650</td>
			<td>CCO- Lines rejected</td>
			<td>3</td>
			<td>GIT-APP-VMS</td>
			<td>Michael Jiao</td>
			<td>skar1</td>
			<td>2014-5-14.0.0. 0. 0</td>
			<td>Work in Progress</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000395274</td>
			<td>RRW picking PQE as he recommended route when the recommended route is over SYU - request# 633455 which pulls different costs.</td>
			<td>3</td>
			<td>GIT-APP-SRS</td>
			<td>Don Daviner</td>
			<td>bpal</td>
			<td>2014-5-13.0.0. 0. 0</td>
			<td>Work in Progress</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000393778</td>
			<td>SEA: TMS Container Pre-mount - SEA Invalid Truck ID Still Showing</td>
			<td>3</td>
			<td>GIT-APP-TMS</td>
			<td>Sri Priya Pampana</td>
			<td>rsarkar</td>
			<td>2014-5-11.0.0. 0. 0</td>
			<td>Work in Progress</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000280249</td>
			<td>Incorrect Yard Position For Container</td>
			<td>3</td>
			<td>GIT-APP-GMS</td>
			<td>Trupti Navnath Khandare</td>
			<td>csingh1</td>
			<td>2013-9-26.0.0. 0. 0</td>
			<td>Work in Progress</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000364381</td>
			<td>Lowes 323 - rejected with the attached message - need to check</td>
			<td>3</td>
			<td>GIT-APP-AVS</td>
			<td>Seetharamudu Ande</td>
			<td>skar1</td>
			<td>2014-3-17.0.0. 0. 0</td>
			<td>Work in Progress</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000351223</td>
			<td>Incorrect Lacation  inactive in DBA for import full cntrs at YOK</td>
			<td>3</td>
			<td>GIT-APP-TMS</td>
			<td>Yosuke Negishi</td>
			<td>rsarkar</td>
			<td>2014-2-19.0.0. 0. 0</td>
			<td>Work in Progress</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000346766</td>
			<td>TMS Release 2.2.2.5 for KAO</td>
			<td>3</td>
			<td>GIT-APP-TMS</td>
			<td>Sri Priya Pampana</td>
			<td>rsarkar</td>
			<td>2014-2-10.0.0. 0. 0</td>
			<td>Work in Progress</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000074225</td>
			<td>plz help activate shpt#077276803</td>
			<td>3</td>
			<td>GIT-APP-EQEXP</td>
			<td>Amigo Wu</td>
			<td>anaha</td>
			<td>2020-8-14.12.0. 0. 0</td>
			<td>Work in Progress</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000351838</td>
			<td>RE: APL SEATTLE - Wrong Port Pair (SIN1-->KHI1), Correct Port Pair should be (SIN1-->SIN2)</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-20.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000344531</td>
			<td>Unable to see schedules frm APL website . There is a missing icon  " SHOW " which would have enable us to proceed with the next stage </td>
			<td>3</td>
			<td>GIT-APP-EP</td>
			<td>Julieana Amat Easan</td>
			<td>null</td>
			<td>2014-2-5.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000345650</td>
			<td>RE: APL NEW JERSEY - Wrong Port Pair (XIA1-->SHA1), Correct Port Pair should be (XIA1-->SHA2)</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-7.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000347877</td>
			<td>Re: APL MELBOURNE - Wrong Port Pair (FEL1-->NYH1), Correct Port Pair should be (FEL1-->F962)</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-12.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000345194</td>
			<td>Re: APL NINGBO : VVPC combination - NBO-026-VKT-1 not present in vessel schedule</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-6.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000395675</td>
			<td>URGENT - The entire team unable to access CCMS</td>
			<td>3</td>
			<td>GIT-APP-CCMS</td>
			<td>Sean Hay</td>
			<td>null</td>
			<td>2014-5-14.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000247065</td>
			<td>100-02-11324384 :APL:UINTETL4:UXMON: Filesystem /var/nas/.appvol diskspace utilization exceeds 90 threshold.</td>
			<td>3</td>
			<td>HP-UNIX-CHG</td>
			<td>P Sreeja</td>
			<td>null</td>
			<td>2013-7-23.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000352509</td>
			<td>Re: APL BRISBANE  : BSEAPL-SRX-161 Missing or Wrong Event</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-21.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000346485</td>
			<td>Re: APL OREGON  : ORGAPL - CMX - 027 Missing or Wrong Event</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-10.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000347225</td>
			<td>Re: APL BAHRAIN  : BAIAPL - KCS - 044 Missing or Wrong Event</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-11.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000351843</td>
			<td>RE: APL ILLINOIS - Wrong Port Pair (SIN2-->NTB2), Correct Port Pair should be (SIN2-->NGB2)</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-20.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000347388</td>
			<td>RE: Missing Lines - KCS Service (APL Bahrain)</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-11.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000347242</td>
			<td>RE: APL SPAIN  : SPAAPL - REX - 167 Missing or Wrong Event</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-11.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000274109</td>
			<td>HOLOS applications (EAM / EVA / CBART ) not working. Please look into this urgently. Server Details- D1DAL723 Wintel Server. </td>
			<td>3</td>
			<td>HP-WINTEL</td>
			<td>Alok Pratik</td>
			<td>null</td>
			<td>2013-9-16.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000186205</td>
			<td> Out-gated Chassis Being Pulled Back Into Yard During Integrity Check</td>
			<td>3</td>
			<td>GIT-APP-SPARCS</td>
			<td>Bhavana Neelagiri</td>
			<td>null</td>
			<td>2013-3-26.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000352500</td>
			<td>RE: APL MERLION : VVPC combination - MEX-001-MOK-1 not present in vessel schedule </td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-21.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000345654</td>
			<td>Re: APL ANTWERP - ATWAPL - CEC - 004 Missing or Wrong Line</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-7.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000342327</td>
			<td>RE: APL Savannah - Wrong Port Pair (KAO2-->YAT1), Correct Port Pair should be (KAO2-->YAT2)</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-1-30.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000342340</td>
			<td>RE: APL NEW JERSEY : NWJAPL - CMX - 027 Missing or Wrong Event</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-1-30.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000352508</td>
			<td>Re: APL BRISBANE : VVPC combination - BSE-161-JHE-1 not present in vessel schedule</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-21.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000345003</td>
			<td>RE APL SALALAH  VVPC combination - SLH-008-HAM-1 not present in vessel schedule </td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-6.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000374352</td>
			<td>Cutoffs cannot be edited on APL.com/India for NSICT/GTI/JNP</td>
			<td>3</td>
			<td>GIT-APP-EP</td>
			<td>Rajesh Kotian</td>
			<td>null</td>
			<td>2014-4-3.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000390111</td>
			<td>The root cause of the discrepancy of payment term between "OCF P/C" flag and BL description</td>
			<td>3</td>
			<td>GIT-APP-CCMS</td>
			<td>Nadia Chen</td>
			<td>null</td>
			<td>2014-5-4.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000384743</td>
			<td>Unable to upload Trade Notifications on Local India Site</td>
			<td>3</td>
			<td>GIT-APP-EP</td>
			<td>Nidhi Chandran</td>
			<td>null</td>
			<td>2014-4-23.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000347237</td>
			<td>RE: APL CHARLESTON  : ACSAPL - WAX - 003 Missing or Wrong Event</td>
			<td>3</td>
			<td>GIT-APP-VOMS</td>
			<td>Bee Tuck Tan</td>
			<td>null</td>
			<td>2014-2-11.0.0. 0. 0</td>
			<td>Re-assigned</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000321438</td>
			<td> Alert Message for Process COARRI from D1SIN401</td>
			<td>3</td>
			<td>GIT-APP-HELPDESK-LOP</td>
			<td>Sruthi Mallak</td>
			<td>smallak</td>
			<td>2013-12-16.0.0. 0. 0</td>
			<td>Pending</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000390630</td>
			<td>Please enable NOA by fax for city GNK</td>
			<td>3</td>
			<td>GIT-APP-CCMS</td>
			<td>Chui May Cheng</td>
			<td>mjena3</td>
			<td>2014-5-5.0.0. 0. 0</td>
			<td>Pending</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000379358</td>
			<td>Alert Message for Process IMF from E-Reporting from D1SIN401</td>
			<td>3</td>
			<td>GIT-APP-HELPDESK-LINER</td>
			<td>Sagar Prakash Tambe</td>
			<td>stambe</td>
			<td>2014-4-12.0.0. 0. 0</td>
			<td>Pending</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000393821</td>
			<td>Routing Points Aliases</td>
			<td>3</td>
			<td>GIT-APP-TERMINALS</td>
			<td>Shahul Hameed_Infosys AMS Farook</td>
			<td>rsarkar</td>
			<td>2014-5-11.0.0. 0. 0</td>
			<td>Pending</td>
			<td>null</td>
			<td>null</td>
			<td>0</td>
			<td>INC000380738</td>
			<td>TARGET - 323 error 4-12 report</td>
			<td>3</td>
			<td>GIT-APP-SRS</td>
			<td>Jodi Brooks</td>
			<td>bpal</td>
			<td>2014-4-15.0.0. 0. 0</td>
			<td>Pending</td>
			<td>null</td>
			<td>...
	
	
<div id="target" style="width: 600px; height: 400px"></div>
	

		</body>
</html>