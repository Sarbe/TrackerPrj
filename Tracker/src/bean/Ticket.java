package bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Ticket implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	// TKTNO,DESCRIPTION,SEVERITY,ASSIGNMENT_GRP,END_USER,OPENED_BY,OPENED_DT,WORKEDONBY,STATUS,TIMETAKEN
	private String Tkt_Number;
	private String Short_Description;
	private String Long_Description;
	private String Severity;
	private String Assignment_group;
	private String End_User;
	private String Opened_by;
	private String Opened_Dt;
	private String WorkDoneBy;
	private String Status;
	private String timeTaken;
	private String IsAttended;
	private int reopenCount;
	private List resGrpsAssigned = new ArrayList();
	private List resGrpsWorking = new ArrayList();

	public String getTkt_Number() {
		return Tkt_Number;
	}

	public void setTkt_Number(String tkt_Number) {
		Tkt_Number = tkt_Number;
	}

	public String getShort_Description() {
		return Short_Description;
	}

	public void setShort_Description(String short_Description) {
		Short_Description = short_Description;
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

	public String getOpened_Dt() {
		return Opened_Dt;
	}

	public void setOpened_Dt(String opened_Dt) {
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

	public String getTimeTaken() {
		return timeTaken;
	}

	public void setTimeTaken(String timeTaken) {
		this.timeTaken = timeTaken;
	}

	public String getIsAttended() {
		return IsAttended;
	}

	public int getReopenCount() {
		return reopenCount;
	}

	public void setReopenCount(int reopenCount) {
		this.reopenCount = reopenCount;
	}

	public void setIsAttended(String isAttended) {
		IsAttended = isAttended;
	}

	public List getResGrpsAssigned() {
		return resGrpsAssigned;
	}

	public void setResGrpsAssigned(List resGrpsAssigned) {
		this.resGrpsAssigned = resGrpsAssigned;
	}

	public List getResGrpsWorking() {
		return resGrpsWorking;
	}

	public void setResGrpsWorking(List resGrpsWorking) {
		this.resGrpsWorking = resGrpsWorking;
	}

}
