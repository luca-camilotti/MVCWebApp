package luke.email.smtp;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import luke.app.controller.AppConfig;
import luke.database.helper.DBHelper;
import luke.token.utils.TokenUtils;

@WebServlet("/mail")
public class SendMail extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private DBHelper dbh;
	
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		super.init(config);
		try {
			dbh = new DBHelper();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}


	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		
		String message = null;
		try {

			String emailTo = request.getParameter("email");
			//System.out.println("email: "+request.getParameter("email"));
			//System.out.println("password: "+request.getParameter("password"));
			//String subject=request.getParameter("subject");
			//String msg=request.getParameter("msg");
			
			String subject = AppConfig.emailChangePwdSubject;			
			String msg = AppConfig.emailChangePwdMsg;
			
			// TokenUtils.createToken(getUser(request).getEmail(), ""+(Integer) request.getAttribute("id"), (String) request.getAttribute("key")) 
			dbh.connect();
			if(emailTo==null)
				message = "Manca l'indirizzo email del destinatario!";
			else if(!dbh.checkUserEmail(emailTo))
				message = "Non esiste nessun account con l'indirizzo email "+emailTo;
			else {
				int id = dbh.getUserId(emailTo);				
				String userKey = dbh.getUserSharedKey(emailTo);
        		String token = TokenUtils.createToken(emailTo, ""+id, userKey);
        		
        		msg = String.format(AppConfig.emailChangePwdMsg,
        				    "<a href=\'http://"+AppConfig.appBaseUrl+getServletContext().getContextPath()+"/App/resetpwd/"+id+"/"+token+"\' >link</a>");
				
				Mailer.send(emailTo, subject, msg);
				message = "L'email è stata inviata all'indirizzo "+emailTo;
			}
			dbh.disconnect();
		}
		catch (Exception e) {
			message = "Errore invio email: "+e.getMessage();
		}
		
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.print(message);
		out.close();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
