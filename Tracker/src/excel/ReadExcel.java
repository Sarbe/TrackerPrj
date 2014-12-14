package excel;

import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.sql.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

public class ReadExcel {

	public static void main(String[] args) {
		try {
		
			InputStream input = new BufferedInputStream(new FileInputStream(
					"D:\\Testing\\TEST.xls"));
			POIFSFileSystem fs = new POIFSFileSystem(input);
			HSSFWorkbook wb = new HSSFWorkbook(fs);
			HSSFSheet sheet = wb.getSheetAt(0);

			int count = 0;
			Iterator rows = sheet.rowIterator();
			List<ExcelBean> ticketList = new ArrayList<ExcelBean>();
			while (rows.hasNext()) {
				HSSFRow row = (HSSFRow) rows.next();
				if (count != 0) { // Reading from 2nd row data
					ExcelBean b = new ExcelBean();
					b.setTkt_Number(readValue(row.getCell(0)).trim());
					b.setStatus(readValue(row.getCell(1)).trim());
					b.setSeverity(readValue(row.getCell(2)).trim());
					b.setEnd_User(readValue(row.getCell(3)).trim());
					b.setLong_Description(readValue(row.getCell(4)).trim());

					b.setAssignment_group(readValue(row.getCell(6)).trim());

					b.setOpened_by(readValue(row.getCell(7)).trim());

					String startDate = readValue(row.getCell(8)).trim();
					SimpleDateFormat sdf1 = new SimpleDateFormat(
							"E MMM dd HH:mm:ss Z yyyy");
					java.util.Date date = sdf1.parse(startDate);
					java.sql.Timestamp sqlStartDate = new java.sql.Timestamp(
							date.getTime());
					b.setOpened_Dt(sqlStartDate);

					b.setWorkDoneBy(readValue(row.getCell(9)).trim());
					ticketList.add(b);
				}

				count++;
				
			}

			
			DBManager db =   new DBManager();
			db.insertToDataBase(ticketList);
		} catch (IOException ex) {
			
			ex.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static String readValue(HSSFCell cell) {
		String value = "";
		if (HSSFCell.CELL_TYPE_NUMERIC == cell.getCellType()) {
			value = cell.getDateCellValue().toString();
		} else if (HSSFCell.CELL_TYPE_STRING == cell.getCellType()) {
			value = cell.getStringCellValue();
		} else if (HSSFCell.CELL_TYPE_BOOLEAN == cell.getCellType()) {
			value = Boolean.toString(cell.getBooleanCellValue());
		}
		return value;

	}

}
