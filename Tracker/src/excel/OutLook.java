package excel;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;

import com.pff.PSTAttachment;
import com.pff.PSTException;
import com.pff.PSTFile;
import com.pff.PSTFolder;
import com.pff.PSTMessage;

public class OutLook {

	public static void main(String[] args) {
		//String filename = "D:\\Mail_Archive\\mail_arc_2014.pst";
		String filename = "Z:\\incident.pst";
		
		try {
			PSTFile pstFile = new PSTFile(filename);
			System.out.println(pstFile.getMessageStore().getDisplayName());
			processFolder(pstFile.getRootFolder());
		} catch (Exception err) {
			err.printStackTrace();
		}
	}

	public OutLook(String filename) {

	}

	static int depth = -1;

	public static void processFolder(PSTFolder folder) throws PSTException, java.io.IOException {
		// the root folder doesn't have a display name
		if (depth > 0) {
			System.out.println(folder.getDisplayName());
		}

		// go through the folders...
		if (folder.hasSubfolders()) {
			Vector<PSTFolder> childFolders = folder.getSubFolders();
			for (PSTFolder childFolder : childFolders) {
				processFolder(childFolder);
			}
		}

		// and now the emails for this folder
		if (folder.getDisplayName().equalsIgnoreCase("Tkt")) {
			if (folder.getContentCount() > 0) {
				PSTMessage email = (PSTMessage) folder.getNextChild();
				folder.getUnreadCount();
				
				Calendar c = Calendar.getInstance();
				c.add(Calendar.HOUR, -2);
				Date d = c.getTime();
				
				while (email != null) {
					//if(!email.isRead()){
					if(email.getSenderEmailAddress().equalsIgnoreCase("nolitsp@service-now.com")&& email.getSubject().equalsIgnoreCase("Open Incidents")){
						
						if(email.getNumberOfAttachments()>0){
							if(email.getCreationTime().after(c.getTime())){
							
								System.out.println("Email: " + email.getSenderEmailAddress()+"time: "+email.getCreationTime());
								System.out.println("creation time: "+email.getCreationTime());
								checkForattachment(email);
							}
						}
						
					}
						//checkForattachment(email);
				//	}
					email = (PSTMessage) folder.getNextChild();
					
				}
			}
		}
	}


	
public static void checkForattachment(PSTMessage email) throws PSTException, IOException{
	int numberOfAttachments = email.getNumberOfAttachments();
	for (int x = 0; x < numberOfAttachments; x++) {
	        PSTAttachment attach = email.getAttachment(x);
	        InputStream attachmentStream = attach.getFileInputStream();
	        // both long and short filenames can be used for attachments
	        String filename = attach.getLongFilename();
	        if (filename.isEmpty()) {
	                filename = attach.getFilename();
	        }
	        FileOutputStream out = new FileOutputStream("D:/Testing/"+filename,true);
	        // 8176 is the block size used internally and should give the best performance
	        int bufferSize = 8176;
	        byte[] buffer = new byte[bufferSize];
	        int count = attachmentStream.read(buffer);
	        while (count == bufferSize) {
	                out.write(buffer);
	                count = attachmentStream.read(buffer);
	        }
	        byte[] endBuffer = new byte[count];
	        System.arraycopy(buffer, 0, endBuffer, 0, count);
	        out.write(endBuffer);
	        out.close();
	        attachmentStream.close();
	}
}

}
