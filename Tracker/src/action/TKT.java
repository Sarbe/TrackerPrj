package action;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Ticket;
import bean.User;

import com.google.gson.Gson;

import db.DBManager;

/**
 * Servlet implementation class TKT
 */
@WebServlet("/pages/TKT")
public class TKT extends HttpServlet {
	private static final long serialVersionUID = 1L;
	HttpSession session = null;
	DBManager db = null;
	
	
	
	public TKT() {
		super();
		// TODO Auto-generated constructor stub
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
			HttpServletResponse response) throws IOException {
		try {
			session = request.getSession(false);
			if (session == null) {
				request.getRequestDispatcher("start.jsp").forward(request,response);
			} else {

				db = new DBManager();
				String method = request.getParameter("method") == null ? "": request.getParameter("method");
				if(null!=method){
				
					if (method.equals("extract")) {
						extract(request, response);
					} else if (method.equals("setup")) {
						setup(request, response);
					} else if (method.equals("saveTkt")) {
						saveTicketDetails(request, response);
					} else if (method.equals("next")) {
						next(request, response);
					} else if (method.equals("tktAjax")) {
						tktAjax(request, response);
					} else if (method.equals("splitTkt")) {
						splitTkt(request, response);
					} else if (method.equals("deleteTask")) {
						deleteTask(request, response);
					}
					// setup page
					else if (method.equals("extractGrpDetails")) {
						extractGrpDetails(request, response);
					} else if (method.equals("rsrByApplication")) {
						rsrByApplication(request, response);
					} //Default Page 
					else if (method.equals("manage")) {
						request.getRequestDispatcher("manageResource.jsp").forward(request, response);
					}
					
					else if (method.equals("refresh")) {
						refresh(request, response);
						//response.getWriter().write("Testing");
					}
					
					else{
						showIncidents(request, response);
					}
				}else{
					request.getRequestDispatcher("start.jsp").forward(request,response);
				}
			}
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	private void refresh(HttpServletRequest request, HttpServletResponse response) {
		try {
			User usr = (User) session.getAttribute("USER");
//			ArrayList<Ticket> b = db.extractData(usr);
			int noOfNew = db.getNewTicketDetails(usr);
			String str = new Gson().toJson(noOfNew);
			response.getWriter().write(str);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	private void deleteTask(HttpServletRequest request, HttpServletResponse response) {
		//DBManager db = new DBManager();
		//HttpSession session = request.getSession();
		String tktNo = request.getParameter("tktNo");
		String workedby = request.getParameter("workBy").toUpperCase();
		int reOpened =request.getParameter("reOpened").equals("")?0:Integer.valueOf(request.getParameter("reOpened")).intValue();
		try {
			User usr = (User) session.getAttribute("USER");
			db.deleteAssigntDetails(tktNo, workedby, reOpened);
			
			ArrayList<Ticket> b = db.extractData(usr);
			session.setAttribute("TKT",b);
			String str = new Gson().toJson(b);
			//System.out.println(str);
			response.getWriter().write(str);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void splitTkt(HttpServletRequest request, HttpServletResponse response) {
		//DBManager db = new DBManager();
		//HttpSession session = request.getSession();
		String tktNo = request.getParameter("tktNo");
		String workedby = request.getParameter("workBy").toUpperCase();
		int reOpened =request.getParameter("reOpened").equals("")?0:Integer.valueOf(request.getParameter("reOpened")).intValue();
		try {
			User usr = (User) session.getAttribute("USER");
			db.saveSplitData(tktNo, workedby,reOpened);
			ArrayList<Ticket> b = db.extractData(usr);
			
			session.setAttribute("TKT",b);
			String str = new Gson().toJson(b);
			//System.out.println(str);
			response.getWriter().write(str);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	private void rsrByApplication(HttpServletRequest request, HttpServletResponse response) {
		//DBManager db = new DBManager();
		String appName = request.getParameter("appNm").toUpperCase();
		try {
			List<String> details = db.resorceByApplication(appName);
			String str = new Gson().toJson(details);
			response.getWriter().write(str);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	

	
	
	private void extractGrpDetails(HttpServletRequest request, HttpServletResponse response) {
		//DBManager db = new DBManager();
		String name = request.getParameter("nameKey").toUpperCase();
		try {
			User grpList = db.getUserDetails(name);
			String str = new Gson().toJson(grpList);
			//System.out.println(str);
			response.getWriter().write(str);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void tktAjax(HttpServletRequest request,
			HttpServletResponse response) {
		try {

			ArrayList<Ticket> b = (ArrayList<Ticket>) session.getAttribute("TKT");
			ArrayList<Ticket> ajaxData = new ArrayList<Ticket>();
			
			String filterType = request.getParameter("filterType");
			
			if(filterType.equals("tktNo")){
				String tktNo = request.getParameter("key");
				for (int i = 0; i < b.size(); i++) {
					//Thread.sleep(20);
					if (b.get(i).getTkt_Number().lastIndexOf(tktNo) != -1) {
						ajaxData.add(b.get(i));
					}
				}
			} else if (filterType.equals("appgrp")) {
				String groups = request.getParameter("grp");
				if (!groups.equals("")) {
					String[] groupsArr = groups.split(",");
					for (int i = 0; i < groupsArr.length; i++) {
						for (int j = 0; j < b.size(); j++) {
							//Thread.sleep(20);
							if (b.get(j).getAssignment_group().equalsIgnoreCase(groupsArr[i])) {
								ajaxData.add(b.get(j));
							}
						}
					}
				}else{
					ajaxData = b;
				}
			}else if (filterType.equals("statusgrp")) {
				String groups = request.getParameter("grp");
				if (!groups.equals("")) {
					String[] groupsArr = groups.split(",");
					for (int i = 0; i < groupsArr.length; i++) {
						for (int j = 0; j < b.size(); j++) {
							//Thread.sleep(20);
							if (b.get(j).getStatus().equalsIgnoreCase(groupsArr[i])) {
								ajaxData.add(b.get(j));
							}
						}
					}
				}else{
					ajaxData = b;
				}
			}
			
			String str = new Gson().toJson(ajaxData);
			//System.out.println(str);
			response.getWriter().write(str);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void saveTicketDetails(HttpServletRequest request,
			HttpServletResponse response) {
		//HttpSession session = request.getSession();
		try {
			String tktNo = request.getParameter("tktNo");
			String workedBy = request.getParameter("workBy");
			int timeTkn = request.getParameter("timeTkn").equals("")?0:Integer.valueOf(request.getParameter("timeTkn")).intValue();
			int reOpened = request.getParameter("reOpened").equals("")?0:Integer.valueOf(request.getParameter("reOpened")).intValue();
			
			
			//DBManager db = new DBManager();
			db.saveTktDetails(tktNo, workedBy, timeTkn,reOpened);
			
			User usr = (User) session.getAttribute("USER");
			ArrayList<Ticket> b = db.extractData(usr);
			session.setAttribute("TKT", b);
			String str = new Gson().toJson(b);
			response.getWriter().write(str);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	

	private void setup(HttpServletRequest request, HttpServletResponse response) {
		try {
			//HttpSession session = request.getSession();
			User usr = (User) session.getAttribute("USER");
			//DBManager db = new DBManager();
			if(!usr.getUserType().equals("N")){
				List<User> rsrList =  db.getResources(usr);
				session.setAttribute("RSRLIST", rsrList);
			request.getRequestDispatcher("setup.jsp").forward(request,response);
			}else{
				request.setAttribute("MSG", "Invalid Request");
				request.getRequestDispatcher("error.jsp").forward(request, response);
			}
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	private void extract(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		try {
			//HttpSession session = request.getSession();
			User usr = (User) session.getAttribute("USER");
			ArrayList<Ticket> tktDetails = db.extractData(usr);
			session.setAttribute("TKT", tktDetails);
			//Thread.sleep(2000);
			String str = new Gson().toJson(tktDetails);
			response.getWriter().write(str);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	
	
	private void showIncidents(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		User usr = (User) session.getAttribute("USER");
		if(usr!=null)
		request.getRequestDispatcher("Incident.jsp").forward(request, response);
		else
			request.getRequestDispatcher("start.jsp").forward(request, response);
	}

	private void next(HttpServletRequest request, HttpServletResponse response) {
		try {
			String userNm = request.getParameter("userName").toUpperCase();
			String password = request.getParameter("password");
			session.setAttribute("USERNAME", userNm);
			User usr = db.getUserDetails(userNm);
			if (null != usr) {
				if (usr.getAppList().size() > 0) {
					session.setAttribute("USER", usr);
					if(!usr.getUserType().equals("S"))
						request.getRequestDispatcher("Incident.jsp").forward(request, response);
					else
						request.getRequestDispatcher("setup.jsp").forward(request, response);
				} else {
					request.setAttribute("MSG",
							"You are not assigned to any group");
					request.getRequestDispatcher("error.jsp").forward(request,
							response);
				}
			} else {
				request.setAttribute("MSG", userNm + " - You are a new User");
				request.getRequestDispatcher("error.jsp").forward(request,
						response);
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
