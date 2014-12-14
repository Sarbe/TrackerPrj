package db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import util.FileManager;
import util.Util;

import bean.Ticket;
import bean.User;

public class DBManager {
	private Connection connect = null;
	private Statement statement = null;
	private PreparedStatement preparedStatement = null;
	private ResultSet resultSet = null;

	public DBManager() {
		// connect = ConnectionManager.getConnection();
	}

	public ArrayList<Ticket> extractData(User usr) throws Exception {
		ArrayList<Ticket> arrb = new ArrayList<Ticket>();
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			
			String qry = "SELECT TKTNO, DESCRIPTION, SEVERITY, ASSIGNMENT_GRP, END_USER, OPENED_BY, OPENED_DT, WORKED_BY, STATUS, NVL(TIME_TAKEN,0) TIME_TAKEN, ATTENDED, "
					+ "CAUSE_OF_INCIDENT, REOPEN_CNT FROM ( SELECT A.TKTNO, A.DESCRIPTION, A.SEVERITY, A.ASSIGNMENT_GRP, A.END_USER, A.OPENED_BY, A.OPENED_DT, B.WORKED_BY, "
					+ "A.STATUS, NVL(B.TIME_TAKEN,0) TIME_TAKEN, A.ATTENDED, A.CAUSE_OF_INCIDENT, A.REOPEN_CNT FROM INCIDENT_TKT A, INCIDENT_STATUS B WHERE A.TKTNO  = B.TKTNO(+) AND"
					+ " A.REOPEN_CNT = B.REOPEN_CNT(+) ";

			if (!usr.getUserType().equals("S")){
				qry += " AND ASSIGNMENT_GRP IN("+ Util.listToCommaSeparatedValue(usr.getAppList()) + ")";
				qry += " UNION SELECT A.TKTNO, A.DESCRIPTION, A.SEVERITY, A.ASSIGNMENT_GRP, A.END_USER, A.OPENED_BY, A.OPENED_DT, B.WORKED_BY, " +
					"A.STATUS, NVL(B.TIME_TAKEN,0) TIME_TAKEN, A.ATTENDED, A.CAUSE_OF_INCIDENT, A.REOPEN_CNT FROM INCIDENT_TKT A, INCIDENT_STATUS B WHERE A.TKTNO = B.TKTNO(+) AND " +
					"A.REOPEN_CNT = B.REOPEN_CNT(+) AND B.WORKED_BY = '"+usr.getName()+"' )";

			}else{
				qry += ")";
			}

			qry += " ORDER BY OPENED_DT DESC";
			//System.out.println(qry);
			resultSet = statement.executeQuery(qry);

			while (resultSet.next()) {
				Ticket b = new Ticket();
				b.setTkt_Number(resultSet.getString("TKTNO"));
				String dsec = resultSet.getString("DESCRIPTION");
				b.setShort_Description(resultSet.getString("DESCRIPTION")
						.substring(0, dsec.length() > 20 ? 20 : dsec.length()));
				b.setLong_Description(resultSet.getString("DESCRIPTION"));
				b.setSeverity(resultSet.getString("SEVERITY"));
				b.setAssignment_group(resultSet.getString("ASSIGNMENT_GRP"));
				b.setEnd_User(resultSet.getString("END_USER"));
				b.setOpened_by(resultSet.getString("OPENED_BY"));
				SimpleDateFormat df = new SimpleDateFormat(
						"dd-MMM-yyyy HH:mm:ss");
				// /String text = df.format(date);
				b.setOpened_Dt(df.format(resultSet.getTimestamp("OPENED_DT")));
				b.setWorkDoneBy(resultSet.getString("WORKED_BY") == null ? ""
						: resultSet.getString("WORKED_BY"));
				b.setStatus(resultSet.getString("STATUS"));
				b.setTimeTaken(resultSet.getString("TIME_TAKEN"));
				b.setReopenCount(resultSet.getInt("REOPEN_CNT"));

				String qry2 = "SELECT RSR_NAME FROM APPLICATION_ALLOCATION WHERE APPLICATION_NM='"
						+ b.getAssignment_group() + "'";
				Statement st1 = connect.createStatement();
				ResultSet rs2 = st1.executeQuery(qry2);
				List rsrA = new ArrayList();
				while (rs2.next()) {
					rsrA.add(rs2.getString("RSR_NAME"));
				}
				
				st1.close();
				rs2.close();

				String qry3 = "SELECT B.WORKED_BY FROM INCIDENT_TKT A,  INCIDENT_STATUS B WHERE A.TKTNO = B.TKTNO AND A.TKTNO='"
						+ b.getTkt_Number()
						+ "' AND B.REOPEN_CNT="
						+ b.getReopenCount();
				Statement st2 = connect.createStatement();

				ResultSet rs3 = st2.executeQuery(qry3);
				
				List rsrW = new ArrayList();
				while (rs3.next()) {
					rsrW.add(rs3.getString("WORKED_BY"));
					
					//Added if the ticket is reassigned and some one out of the assigned group has worked
					if(!rsrA.contains(rs3.getString("WORKED_BY")))
						rsrA.add(rs3.getString("WORKED_BY"));
				}
				
				//
				b.setResGrpsAssigned(rsrA);
				
				b.setResGrpsWorking(rsrW);
				
				st2.close();
				rs3.close();


				b.setIsAttended(rsrW.size() == 0 ? "N" : "Y");

				arrb.add(b);
			}

		} catch (Exception e) {
			throw e;
		} finally {
			close();
		}
		return arrb;
	}

	public ArrayList<String> getAssignmentGroup() throws Exception {
		ArrayList<String> arrb = new ArrayList<String>();
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			resultSet = statement
					.executeQuery("SELECT DISTINCT ASSIGNMENT_GRP FROM INCIDENT_TKT ");

			while (resultSet.next()) {
				String grp = resultSet.getString("ASSIGNMENT_GRP");
				arrb.add(grp);
			}

		} catch (Exception e) {
			throw e;
		} finally {
			close();
		}
		return arrb;
	}

	public ArrayList<String> resorceByApplication(String appName)
			throws Exception {
		ArrayList<String> details = new ArrayList<String>();
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "SELECT AA.APPLICATION_NM, AA.RSR_NAME,DECODE(UT.USR_TYPE,'S','SUPER ADMIN','A','ADMIN','N','NORMAL',UT.USR_TYPE) TYPEDETAILS "
					+ " FROM APPLICATION_ALLOCATION AA,USER_TBL UT WHERE AA.RSR_NAME=UT.RSR_NAME AND APPLICATION_NM LIKE '%"
					+ appName + "%' ORDER BY AA.APPLICATION_NM";
			resultSet = statement.executeQuery(qry);

			while (resultSet.next()) {
				details.add("[" + resultSet.getString("APPLICATION_NM") + "] -"
						+ resultSet.getString("RSR_NAME") + "-"
						+ resultSet.getString("TYPEDETAILS"));
			}

		} catch (Exception e) {
			throw e;
		} finally {
			close();
		}
		return details;
	}

	public User getUserDetails(String name) throws Exception {
		User usr = null;
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "SELECT * FROM USER_TBL WHERE RSR_NAME='"
					+ name.toUpperCase() + "' AND ACTV_FLG='Y' ";
			resultSet = statement.executeQuery(qry);

			while (resultSet.next()) {
				usr = new User();
				usr.setName(resultSet.getString("RSR_NAME"));
				usr.setUserType(resultSet.getString("USR_TYPE"));
				usr.setFirstname(resultSet.getString("FIRSTNAME"));
			}
			//Application Group Details
			if (null != usr) {
				List<String> appgrp = new ArrayList<String>();
				
				if (!usr.getUserType().equals("S")){
					qry = "SELECT DISTINCT A.APPLICATION_NM APPLICATION_NM FROM APPLICATION_ALLOCATION A,INCIDENT_TKT B WHERE  A.APPLICATION_NM = B.ASSIGNMENT_GRP " +
							" AND RSR_NAME='" + name.toUpperCase() + "'";
				
				}else{
					qry = "SELECT DISTINCT ASSIGNMENT_GRP APPLICATION_NM FROM INCIDENT_TKT ";
				}
				
				resultSet = statement.executeQuery(qry);
				while (resultSet.next()) {
					appgrp.add(resultSet.getString("APPLICATION_NM"));
				}

				usr.setAppList(appgrp);
				
				// Status Groups
				List<String> statusgrp = new ArrayList<String>();

				if (!usr.getUserType().equals("S")) {
					qry = "SELECT DISTINCT B.STATUS FROM APPLICATION_ALLOCATION A,INCIDENT_TKT B WHERE  A.APPLICATION_NM = B.ASSIGNMENT_GRP "
							+ " AND RSR_NAME='" + name.toUpperCase() + "'";

				} else {
					qry = "SELECT DISTINCT STATUS FROM INCIDENT_TKT ";
				}
				resultSet = statement.executeQuery(qry);
				while (resultSet.next()) {
					statusgrp.add(resultSet.getString("STATUS"));
				}

				usr.setStatusList(statusgrp);
				
			}

		} catch (Exception e) {
			throw e;
		} finally {
			close();
		}
		return usr;
	}

	public User getUserDetails(String name, String password) throws Exception {
		User usr = null;
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "SELECT * FROM USER_TBL WHERE RSR_NAME='"
					+ name.toUpperCase() + "' AND PASSWORD='" + password + "'";
			resultSet = statement.executeQuery(qry);

			while (resultSet.next()) {
				usr = new User();
				usr.setName(resultSet.getString("RSR_NAME"));
				usr.setUserType(resultSet.getString("USR_TYPE"));
			}
			if (null != usr) {
				List appgrp = new ArrayList();
				qry = "SELECT APPLICATION_NM FROM APPLICATION_ALLOCATION WHERE 1=1 ";
				if (usr.getUserType().equals("S"))
					qry = "SELECT DISTINCT APPLICATION_NM FROM APPLICATION_TBL";
				else
					qry += " AND RSR_NAME='" + name.toUpperCase() + "'";
				resultSet = statement.executeQuery(qry);
				while (resultSet.next()) {
					appgrp.add(resultSet.getString("APPLICATION_NM"));
				}

				usr.setAppList(appgrp);
			}

		} catch (Exception e) {
			throw e;
		} finally {
			close();
		}
		return usr;
	}

	public Map<String, List> getResourcesByApplication() throws Exception {
		Map<String, List> rbaList = new HashMap<String, List>();
		ResultSet rs2 = null ;
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "SELECT APPLICATION_NM FROM APPLICATION_TBL";
			resultSet = statement.executeQuery(qry);

			while (resultSet.next()) {

				String qry2 = "SELECT RSR_NAME FROM APPLICATION_ALLOCATION WHERE APPLICATION_NM='"
						+ resultSet.getString("APPLICATION_NM") + "'";
				rs2 = statement.executeQuery(qry2);
				List rsrNm = new ArrayList();
				while (rs2.next()) {
					rsrNm.add(rs2.getString("RSR_NAME"));
				}
				rbaList.put(resultSet.getString("APPLICATION_NM"), rsrNm);
				rs2.close();
			}

		} catch (Exception e) {
			throw e;
		} finally {
			close();
			rs2.close();
		}
		return rbaList;
	}

	public List getResources(User usr) throws Exception {
		List resourceList = new ArrayList();
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "";
			if (usr.getUserType().equals("S"))
				qry = "SELECT RSR_NAME FROM USER_TBL";
			else if (usr.getUserType().equals("A"))
				qry = "SELECT RSR_NAME FROM USER_TBL WHERE MNGR='"
						+ usr.getName() + "'";
			resultSet = statement.executeQuery(qry);

			while (resultSet.next()) {
				resourceList.add(resultSet.getString("RSR_NAME"));
			}

		} catch (Exception e) {
			throw e;
		} finally {
			close();
		}
		return resourceList;
	}

	public List getAppGroupDetails(String name) throws Exception {
		List appList = new ArrayList();
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "";
			qry = "SELECT APPLICATION_NM FROM APPLICATION_ALLOCATION WHERE RSR_NAME='"
					+ name + "'";
			resultSet = statement.executeQuery(qry);

			while (resultSet.next()) {
				appList.add(resultSet.getString("APPLICATION_NM"));
			}

		} catch (Exception e) {
			throw e;
		} finally {
			close();
		}
		return appList;
	}

	// ///////////////////////

	public int saveAssignedGroups(String rsrName, String userType,
			String[] appsList, User usr) throws Exception {
		ArrayList<Ticket> arrb = new ArrayList<Ticket>();
		int result = 0;
		try {
			connect = ConnectionManager.getConnection();
			checkAndCreateUser(connect, rsrName, userType, appsList, usr);
			statement = connect.createStatement();
			String qry = "DELETE APPLICATION_ALLOCATION  WHERE RSR_NAME='"
					+ rsrName + "'";
			int count = statement.executeUpdate(qry);
			preparedStatement = connect
					.prepareStatement("INSERT INTO APPLICATION_ALLOCATION(RSR_NAME, APPLICATION_NM) VALUES( ?, ?)");
			for (int i = 0; i < appsList.length; i++) {
				// parameters start with 1
				preparedStatement.setString(1, rsrName);
				preparedStatement.setString(2, appsList[i]);
				result = preparedStatement.executeUpdate();
			}
			connect.commit();
		} catch (Exception e) {
			connect.rollback();
			throw e;
		} finally {
			close();
		}
		return result;
	}

	public void checkAndCreateUser(Connection connect, String rsrName,
			String userType, String[] appsList, User usr) throws Exception {
		try {
			statement = connect.createStatement();
			String qry = "SELECT COUNT(1) CNT FROM USER_TBL  WHERE RSR_NAME='"
					+ rsrName + "'";
			resultSet = statement.executeQuery(qry);
			int result = 0;
			while (resultSet.next()) {
				result = Integer.valueOf(resultSet.getString("CNT")).intValue();
			}

			if (result == 0) {
				qry = "INSERT INTO USER_TBL (RSR_NAME,USR_TYPE,ACTV_FLG,MNGR) VALUES ('"
						+ rsrName
						+ "','"
						+ userType
						+ "','Y','"
						+ usr.getName() + "')";
				statement.executeUpdate(qry);

			}else{
				qry = "UPDATE USER_TBL SET USR_TYPE='"+userType+"',ACTV_FLG='Y',MNGR='"+usr.getName()+"' WHERE RSR_NAME='"+rsrName+"'";
				statement.executeUpdate(qry);
			}
			// connect.commit();
		} catch (Exception e) {
			connect.rollback();

		}
	}

	public void saveTktDetails(String tktNo, String workedBy, int timeTkn,
			int reOpenedCnt) throws Exception {
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "";
			int result = 0;
			int count = 0;
			// CHK IF RECORD PRESENT
			qry = "SELECT COUNT(1) CNT FROM INCIDENT_STATUS WHERE TKTNO='"
					+ tktNo + "' AND WORKED_BY='" + workedBy
					+ "' AND REOPEN_CNT=" + reOpenedCnt;
			resultSet = statement.executeQuery(qry);

			while (resultSet.next()) {
				result = Integer.valueOf(resultSet.getString("CNT")).intValue();
			}

			// NOT PRESENT THEN INSERT
			if (result == 0) {

				qry = "INSERT INTO INCIDENT_STATUS(TKTNO,WORKED_BY,TIME_TAKEN,REOPEN_CNT) VALUES('"
						+ tktNo
						+ "','"
						+ workedBy
						+ "',"
						+ timeTkn
						+ ","
						+ reOpenedCnt + ")";
				count = statement.executeUpdate(qry);
				// System.out.println(count);
			}

			// ALWAYS UPDATE TIME Taken
			qry = "UPDATE INCIDENT_STATUS SET TIME_TAKEN=" + timeTkn
					+ "  WHERE TKTNO = '" + tktNo + "' AND WORKED_BY='"
					+ workedBy + "'";
			count = statement.executeUpdate(qry);

			if (timeTkn != 0) {
				// CHK IF ANY OTHER PERSON IS WORKING (IF TASK IS SPLITTED)
				qry = "SELECT COUNT(1) CNT FROM INCIDENT_STATUS WHERE TKTNO='"
						+ tktNo + "' AND REOPEN_CNT=" + reOpenedCnt
						+ " AND WORKED_BY<>'" + workedBy
						+ "' AND TIME_TAKEN =0";
				resultSet = statement.executeQuery(qry);
				result = 0;
				while (resultSet.next()) {
					result = Integer.valueOf(resultSet.getString("CNT"))
							.intValue();
				}

				if (result == 0) {
					// UPDATE STATUS IF OTHER RECORD NOT PRESENT
					qry = "UPDATE INCIDENT_TKT SET STATUS='Resolved' WHERE TKTNO = '"
							+ tktNo + "' AND REOPEN_CNT=" + reOpenedCnt;
					count = statement.executeUpdate(qry);
				}

			}

			// System.out.println(count);
			connect.commit();
		} catch (Exception e) {
			connect.rollback();
			throw e;
		} finally {
			close();
		}
	}

	private void close() throws SQLException {
		if (resultSet != null)
			resultSet.close();
		if (statement != null)
			statement.close();
		if (connect != null)
			connect.close();
	}

	// //////////////////
	// Delete
	public void deleteAssigntDetails(String tktNo, String workedBy,
			int reOpenedCnt) throws Exception {
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "DELETE INCIDENT_STATUS WHERE TKTNO='" + tktNo
					+ "' AND WORKED_BY = '" + workedBy + "' AND REOPEN_CNT="
					+ reOpenedCnt;
			int count = statement.executeUpdate(qry);
			// System.out.println(count);
			connect.commit();
		} catch (Exception e) {
			connect.rollback();
			throw e;
		} finally {
			close();
		}
	}

	public void saveSplitData(String tktNo, String workedBy, int reOpenedCnt)
			throws Exception {
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "INSERT INTO INCIDENT_STATUS(TKTNO,WORKED_BY,TIME_TAKEN,REOPEN_CNT) VALUES('"
					+ tktNo + "','" + workedBy + "',0," + reOpenedCnt + ")";

			int count = statement.executeUpdate(qry);
			// System.out.println(count);
			connect.commit();
		} catch (Exception e) {
			connect.rollback();
			throw e;
		} finally {
			close();
		}
	}

	// ///////////////
	// Resource

	public int updateUserDetails(User prev, User nxt) throws SQLException {
		int count = 0;
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "UPDATE USER_TBL SET PASSWORD='" + nxt.getPassword()
					+ "',USR_TYPE='" + nxt.getUserType() + "',ACTV_FLG='"
					+ nxt.getIsActive() + "' WHERE RSR_NAME='" + prev.getName()
					+ "'";
			count = statement.executeUpdate(qry);
			connect.commit();
		} catch (Exception e) {
			connect.rollback();
			return count;
		} finally {
			close();
		}
		return count;
	}

	public int removeUserDetails(String usrNm) throws Exception {
		int count = 0;
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "DELETE USER_TBL  WHERE  RSR_NAME='" + usrNm + "' ";
			count = statement.executeUpdate(qry);
			if (count != 0) {
				qry = "DELETE APPLICATION_ALLOCATION  WHERE  RSR_NAME='"
						+ usrNm + "' ";
				count = statement.executeUpdate(qry);
			} else {
				return count;
			}

			connect.commit();
		} catch (Exception e) {
			connect.rollback();
			return count;
			// throw e;
		} finally {
			close();
		}
		return count;
	}

	public ArrayList<User> resouceDetails(User usr) throws SQLException {

		ArrayList<User> rsrs = new ArrayList<User>();

		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "SELECT RSR_NAME, USR_TYPE, ACTV_FLG, PASSWORD FROM USER_TBL WHERE RSR_NAME<> 'S'";
			resultSet = statement.executeQuery(qry);
			while (resultSet.next()) {
				User rsr = new User();
				rsr.setName(resultSet.getString("RSR_NAME"));
				rsr.setPassword(resultSet.getString("PASSWORD"));
				rsr.setUserType(resultSet.getString("USR_TYPE"));
				rsr.setIsActive(resultSet.getString("ACTV_FLG"));
				rsrs.add(rsr);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return rsrs;
	}

	public String getDataAsString() throws SQLException {
		String rstr = "";
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "SELECT RSR_NAME, USR_TYPE FROM USER_TBL";
			resultSet = statement.executeQuery(qry);
			FileManager fmgr = new FileManager();
			rstr = fmgr.writeToExcel(resultSet);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return rstr;

	}
	
	
	public List<String> oldQueries() throws SQLException {

		List<String> queries = new ArrayList<String>();

		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "SELECT DISTINCT TRIM(QUERIES) QUERIES FROM QUERY_TBL ";
			resultSet = statement.executeQuery(qry);
			while (resultSet.next()) {
				queries.add(resultSet.getString("QUERIES"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return queries;
	}
	

	public int getNewTicketDetails(User usr) throws SQLException {
		int noOfNewRcrd = 0;
		try {
			connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			String qry = "SELECT COUNT(1) CNT FROM (SELECT TKTNO,REOPEN_CNT FROM INCIDENT_TKT where 1=1 ";
			// String qry =
			// "SELECT  COUNT(1) CNT  FROM INCIDENT_TKT A   JOIN INCIDENT_STATUS B  ON A.TKTNO <> B.TKTNO AND A.REOPEN_CNT=B.REOPEN_CNT ";
			if (!usr.getUserType().equals("S"))
				qry += " AND ASSIGNMENT_GRP IN("
						+ Util.listToCommaSeparatedValue(usr.getAppList())
						+ ") ";
			qry += "MINUS SELECT TKTNO,REOPEN_CNT FROM INCIDENT_STATUS)";
			//System.out.println(qry);

			resultSet = statement.executeQuery(qry);

			while (resultSet.next()) {
				noOfNewRcrd = resultSet.getInt("CNT");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return noOfNewRcrd;

	}

	// Chart

	public HashMap<String, String> getTicketCountDetailsByApplication() {
		HashMap<String, String> tktMap = new HashMap<String, String>();
		connect = ConnectionManager.getConnection();
		try {
			statement = connect.createStatement();
			String qry = "SELECT ASSIGNMENT_GRP,COUNT(*) CNT FROM INCIDENT_TKT GROUP BY ASSIGNMENT_GRP ";

			resultSet = statement.executeQuery(qry);

			while (resultSet.next()) {
				tktMap.put(resultSet.getString("ASSIGNMENT_GRP").split("-")[resultSet.getString("ASSIGNMENT_GRP").split("-").length-1],
						resultSet.getString("CNT"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return tktMap;

	}

	public List<List<String>> SQLEditor(String qry) throws SQLException {
		List<List<String>> table = new ArrayList<List<String>>();
		String errorMsg ="";
		connect = ConnectionManager.getConnection();
			statement = connect.createStatement();
			

			resultSet = statement.executeQuery(qry);
			ResultSetMetaData rm = resultSet.getMetaData();
			int colCont = rm.getColumnCount();
			List<String> header = new ArrayList<String>();
			
			for (int i = 1; i <= colCont; i++) {
				header.add(rm.getColumnName(i));
			}

			table.add(header);
			
			while (resultSet.next()) {
				List<String> data = new ArrayList<String>();
				for (int j = 1; j <= colCont; j++) {
					data.add(resultSet.getString(rm.getColumnName(j)));
				}
				table.add(data);
			}

		
			 
			 preparedStatement = connect.prepareStatement("INSERT INTO QUERY_TBL VALUES(?)");
			 preparedStatement.setString(1, qry.trim());
			 preparedStatement.executeUpdate();
			 connect.commit();
			 
			return table;

	}
	
}