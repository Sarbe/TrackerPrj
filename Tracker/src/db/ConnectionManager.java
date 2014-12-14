package db;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionManager {

	static Connection connection = null;

	public static Connection getConnection() {

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");

			connection = DriverManager.getConnection(
					"jdbc:oracle:thin:@localhost:1521:xe", "tracker",
					"tracker");

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		return connection;

	}
}
