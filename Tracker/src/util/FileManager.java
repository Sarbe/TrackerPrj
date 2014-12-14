package util;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class FileManager {
	public String writeToExcel(ResultSet rs) throws SQLException {
		StringBuilder sb = new StringBuilder();
		sb.append("<table border=1>");

		sb.append("<tr style=\"white;background-color:blue;\"><td>Name</td><td>Type</td></tr>");
		while (rs.next()) {
			sb.append("<tr>");
			sb.append("<td>" + rs.getString("RSR_NAME") + "</td>");
			sb.append("<td>" + rs.getString("USR_TYPE") + "</td>");
			sb.append("</tr>");
		}
		sb.append("<table>");

		return sb.toString();
	}

	public static String writeToExcel(List<List<String>> table) {
		StringBuilder sb = new StringBuilder();
		if (null != table) {
			List<String> header = table.get(0);
			sb.append("<table border=1>");

			sb.append("<tr >");
			for (int i = 0; i < header.size(); i++) {
				sb.append("<td style=\"background-color:rgb(31,78,120);color: white;font-weight: bold;text-align: center;\">"
						+ header.get(i) + "</td>");
			}
			sb.append("</tr>");

			
			for (int i = 1; i < table.size(); i++) {
				List<String> data = table.get(i);
				sb.append("<tr>");
				for (int j = 0; j < data.size(); j++) {
					sb.append("<td>" + data.get(j) + "</td>");
				}
				sb.append("</tr>");
			}
			
			sb.append("</table>");

		}
		return sb.toString();
	}

}
