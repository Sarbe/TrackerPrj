package excel;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

public class DBManager {
	private Connection connect = null;
	private Statement statement = null;
	private PreparedStatement preparedStatement = null;
	private ResultSet resultSet = null;

	public void insertToDataBase(List<ExcelBean> ticketList) throws Exception {
		try {
			ConnectionManager con = new ConnectionManager();
			connect = con.getConnection();
			
			
			if (connect != null) {
				for (int i = 0; i < ticketList.size(); i++) {
					ExcelBean b = ticketList.get(i);
					System.out.println(b.getTkt_Number());
					//Check and insert Application Name if not exist
					checkAndInsertApplicationName(connect, b.getAssignment_group());
					
					statement = connect.createStatement();
					String qry = "SELECT COUNT(*) CNT  FROM INCIDENT_TKT WHERE TKTNO='"+b.getTkt_Number()+"'";
					resultSet = statement.executeQuery(qry);
					int recordCnt=0;
					while (resultSet.next()) {
						recordCnt = resultSet.getInt("CNT");
					}
					
					if(recordCnt==0){
						preparedStatement = connect.prepareStatement(// "insert into  FEEDBACK.COMMENTS values (default, ?, ?, ?, ? , ?, ?)");
	
								"INSERT INTO INCIDENT_TKT (TKTNO,DESCRIPTION,SEVERITY,ASSIGNMENT_GRP,END_USER,OPENED_BY,OPENED_DT," +
								"STATUS,ATTENDED,CAUSE_OF_INCIDENT,REOPEN_CNT) " +
								"VALUES( ?, ?, ?, ? , ?, ? , ?,  ?, ?, ?, ? )");
						
						preparedStatement.setString(1, b.getTkt_Number());
						preparedStatement.setString(2, b.getLong_Description());
						preparedStatement.setString(3, b.getSeverity().substring(0,1));
						preparedStatement.setString(4, b.getAssignment_group());
						preparedStatement.setString(5, b.getEnd_User());
						preparedStatement.setString(6, b.getOpened_by());
						preparedStatement.setTimestamp(7, b.getOpened_Dt());
						preparedStatement.setString(8, b.getStatus());
						preparedStatement.setString(9, "N");
						preparedStatement.setString(10, b.getCauseOf_Incident());
						preparedStatement.setInt(11, 0);
						preparedStatement.executeUpdate();
					}
					else {
						System.out.println("Present: "+b.getTkt_Number());
					}
				}
				connect.commit();
				
			} else {
				System.out.println("Error in connection");
			}

			System.out.println("Finished Insertion");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			connect.rollback();
		} finally {
			close();
		}

	}
	
	public void checkAndInsertApplicationName(Connection connect,String application) throws Exception {
		try {
			Statement st = connect.createStatement();
			String qry = "SELECT COUNT(1) CNT FROM APPLICATION_TBL WHERE APPLICATION_NM='" + application + "'";
			ResultSet rs = st.executeQuery(qry);
			int result = 0;
			while (resultSet.next()) {
				result = Integer.valueOf(resultSet.getString("CNT")).intValue();
			}

			if (result == 0) {
				qry = "INSERT INTO APPLICATION_TBL (APPLICATION_NM) VALUES ('"
						+ application + "')";
				 statement.executeUpdate(qry);

			}
			//connect.commit();
		} catch (Exception e) {
			connect.rollback();
			
		} 
	}

	private void close() {
		try {
			if(resultSet!=null)
			resultSet.close();
			if(statement!=null)
			statement.close();
			if(connect!=null)
			connect.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

}
