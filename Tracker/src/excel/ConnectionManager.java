package excel;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionManager {

	private  Connection connect = null;

	public ConnectionManager() {
		try {
//			Class.forName("com.mysql.jdbc.Driver");
//			connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/INC_TRACKER","root", "root");
			Class.forName("oracle.jdbc.driver.OracleDriver");

			connect = DriverManager.getConnection(
					"jdbc:oracle:thin:@localhost:1521:xe", "tracker",
					"tracker");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	public  Connection getConnection() {
		return connect;

	}
	
	public  void closeConnection() {
		try {
			connect.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}


}
