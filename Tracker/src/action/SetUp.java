package action;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.FileManager;

import bean.User;

import com.google.gson.Gson;

import db.DBManager;

@WebServlet("/pages/SetUp")
public class SetUp extends HttpServlet {
	private static final long serialVersionUID = 1L;

	HttpSession session = null;
	DBManager db = null;

	public SetUp() {
		super();
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		execute(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		execute(request, response);
	}

	private void execute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException {
		try {

			String method = request.getParameter("method");
			if(null!=method){
			
				if (method.equals("extract")) {
					exract(request, response);
				} else if (method.equals("removeUser")) {
					removeUser(request, response);
				} else if (method.equals("assign")) {
					assignGroups(request, response);
				}else if (method.equals("updateUser")) {
					updateUser(request, response);
				} else if (method.equals("chart")) {
					chart(request, response);
				}else if (method.equals("editor")) {
					editor(request, response);
				} else if (method.equals("dwnldData")) {
					dwnldData(request, response);
				} 
				
				else {
					fileDownload(request, response);
				}
			}else{
				request.getRequestDispatcher("start.jsp").forward(request,response);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}



	private void dwnldData(HttpServletRequest request,
			HttpServletResponse response) {
		

		try {
			
			List<List<String>> table = (List<List<String>>) session.getAttribute("TBL");
			if(table!=null){
				final int BYTES_DOWNLOAD = 1024;
				InputStream is = null;
				db = new DBManager();
				String fileName = String.valueOf(System.currentTimeMillis());
				response.setContentType("text/plain");
				response.setHeader("Content-Disposition","attachment;filename="+fileName+".xls");
				is = new ByteArrayInputStream(FileManager.writeToExcel(table).getBytes());
				int read = 0;
				byte[] bytes = new byte[BYTES_DOWNLOAD];
				OutputStream os = response.getOutputStream();
	
				while ((read = is.read(bytes)) != -1) {
					os.write(bytes, 0, read);
				}
				os.flush();
				os.close();
			}else{
				String msg = "Dataset Not found. Run the query First.";
				request.setAttribute("MSG",msg);
				request.getRequestDispatcher("editor.jsp").forward(request, response);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void editor(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		db = new DBManager();
		List<List<String>> table = null;
		try {
			List<String> queries = db.oldQueries();
			request.setAttribute("queries",queries);
			String qry = request.getParameter("qry");
			if(qry!=null){
				table = db.SQLEditor(qry);
				
				session.setAttribute("TBL",table);
			}else{
				session.setAttribute("TBL",null);
			}
			request.setAttribute("TBL",table);
			request.setAttribute("qry",qry);
			request.getRequestDispatcher("editor.jsp").forward(request, response);
		} catch (Exception e) {
			String msg = e.getMessage();
			request.setAttribute("MSG",msg);
			request.getRequestDispatcher("editor.jsp").forward(request, response);
			//e.printStackTrace();
			
		}
		
	}

	private void exract(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		session = request.getSession(false);
		try {
			if (session == null) {
				request.getRequestDispatcher("start.jsp").forward(request,
						response);
			} else {
				db = new DBManager();
				User usr = (User) session.getAttribute("USER");
				List<User> rsrs = db.resouceDetails(usr);
				session.setAttribute("RSRS", rsrs);

				String str = new Gson().toJson(rsrs);
				response.getWriter().write(str);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// TODO Auto-generated method stub

	}

	private void fileDownload(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		try {
			final int BYTES_DOWNLOAD = 1024;
			InputStream is = null;
			db = new DBManager();
			response.setContentType("text/plain");
			response.setHeader("Content-Disposition",
					"attachment;filename=downloadname.xls");
			is = new ByteArrayInputStream(db.getDataAsString().getBytes());
			int read = 0;
			byte[] bytes = new byte[BYTES_DOWNLOAD];
			OutputStream os = response.getOutputStream();

			while ((read = is.read(bytes)) != -1) {
				os.write(bytes, 0, read);
			}
			os.flush();
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void updateUser(HttpServletRequest request, HttpServletResponse response) {
		db = new DBManager();
		int index = Integer.parseInt(request.getParameter("INDX"));
		try {
			User usr = (User) session.getAttribute("USER");
			List<User> rsrs= (List<User>) session.getAttribute("RSRS");
			User prevUser =rsrs.get(index);
			
			User nextUser = new User();
			nextUser.setPassword(request.getParameter("password"));
			nextUser.setUserType(request.getParameter("userType"));
			nextUser.setIsActive(request.getParameter("activeFlg"));
			
			int status = db.updateUserDetails(prevUser,nextUser);
			String str = "";
			if(status!=0){			
				rsrs = db.resouceDetails(usr);
				session.setAttribute("RSRS", rsrs);
				str = new Gson().toJson(rsrs);
			}
			response.getWriter().write(str);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	private void removeUser(HttpServletRequest request, HttpServletResponse response) {
		db = new DBManager();
		String usrNm = request.getParameter("usrNm").toUpperCase();
		try {
			int status = db.removeUserDetails(usrNm);
			String str ="";
			if(status!=0){			
				User usr = (User) session.getAttribute("USER");
				List<User> rsrs = db.resouceDetails(usr);
				session.setAttribute("RSRS", rsrs);
				str = new Gson().toJson(rsrs);
			}

			response.getWriter().write(str);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	
	
	private void assignGroups(HttpServletRequest request, HttpServletResponse response) {
		try {
			//HttpSession session = request.getSession();
			User usr = (User) session.getAttribute("USER");
			User newUser = new User();
			String rsrName = request.getParameter("rsrNm").toUpperCase();
			String userType = request.getParameter("usertype");

			//String[] selectedAppList = request.getParameter("appgrps").split(",");
			String[] selectedAppList = request.getParameterValues("appsListgrp");
			
			int status = db.saveAssignedGroups(rsrName, userType, selectedAppList,usr);
			
			String msg="";
			if(status>0)
				msg = "Succefully Saved";
			else
				msg = "Some Error Occured.Contact Support Team.";
			request.setAttribute("MSG",msg);
			request.getRequestDispatcher("setup.jsp").forward(request, response);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	private void chart(HttpServletRequest request, HttpServletResponse response) {
		try {

			HashMap<String, String> map = db.getTicketCountDetailsByApplication();
			
		
			request.setAttribute("TKTMAP",map);
			request.getRequestDispatcher("chart.jsp").forward(request, response);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}
}
