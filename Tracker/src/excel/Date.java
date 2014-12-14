package excel;

import java.text.ParseException;
import java.text.SimpleDateFormat;

public class Date {
	public static void main(String[] args) throws ParseException {
		String startDate="01-02-2013";
		   SimpleDateFormat sdf1 = new SimpleDateFormat("MM-dd-yyyy");
		   java.util.Date date = sdf1.parse(startDate);
		   java.sql.Date sqlStartDate = new java.sql.Date(date.getTime()); 
		

	}
}
