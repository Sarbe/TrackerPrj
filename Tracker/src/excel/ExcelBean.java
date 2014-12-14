package excel;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class ExcelBean implements Serializable{
	
	/**
	 * 
	 */
	//TKTNO,DESCRIPTION,SEVERITY,ASSIGNMENT_GRP,END_USER,OPENED_BY,OPENED_DT,WORKEDONBY,STATUS,TIMETAKEN
	private String Tkt_Number;
	private String Long_Description;
	private String Severity;
	private String Assignment_group;
	private String End_User;
	private String Opened_by;
	private Timestamp Opened_Dt;
	private String WorkDoneBy;
	private String Status;
	private String CauseOf_Incident;
	public String getTkt_Number() {
		return Tkt_Number;
	}
	public void setTkt_Number(String tkt_Number) {
		Tkt_Number = tkt_Number;
	}
	public String getLong_Description() {
		return Long_Description;
	}
	public void setLong_Description(String long_Description) {
		Long_Description = long_Description;
	}
	public String getSeverity() {
		return Severity;
	}
	public void setSeverity(String severity) {
		Severity = severity;
	}
	public String getAssignment_group() {
		return Assignment_group;
	}
	public void setAssignment_group(String assignment_group) {
		Assignment_group = assignment_group;
	}
	public String getEnd_User() {
		return End_User;
	}
	public void setEnd_User(String end_User) {
		End_User = end_User;
	}
	public String getOpened_by() {
		return Opened_by;
	}
	public void setOpened_by(String opened_by) {
		Opened_by = opened_by;
	}
	public Timestamp getOpened_Dt() {
		return Opened_Dt;
	}
	public void setOpened_Dt(Timestamp opened_Dt) {
		Opened_Dt = opened_Dt;
	}
	public String getWorkDoneBy() {
		return WorkDoneBy;
	}
	public void setWorkDoneBy(String workDoneBy) {
		WorkDoneBy = workDoneBy;
	}
	public String getStatus() {
		return Status;
	}
	public void setStatus(String status) {
		Status = status;
	}
	public String getCauseOf_Incident() {
		return CauseOf_Incident;
	}
	public void setCauseOf_Incident(String causeOf_Incident) {
		CauseOf_Incident = causeOf_Incident;
	}

	
	
	
}
