package luke.app.controller;

import java.io.IOException;
import java.io.InputStream;
import java.security.InvalidKeyException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.apache.tomcat.util.http.fileupload.FileItem;

import luke.date.converter.DateConverter;
import luke.models.classes.AccessoSportello;
import luke.models.classes.ReportItem;
import luke.models.classes.SimpleRecord;
import luke.models.classes.UploadItem;
import luke.models.classes.User;
import luke.token.utils.TokenUtils;
import luke.url.parser.*;
import luke.database.helper.DBHelper;

/**
 * Servlet implementation class Demo
 * @MultipartConfig: for file upload
 * 
 * This Servlet is the appkication controller
 */
@WebServlet("/App/*")
// @MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class Controller extends HttpServlet {
	private static final long serialVersionUID = 1L;
	//private String template;
	private DBHelper dbh;  // db helper to perform database operations
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Controller() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    /* TOAST AND SESSION MESSAGES */
    
    /* Store a message in session: sometimes the session must be deleted
     * and you want to redirect to another web page showing a toast message;
     * since the request object does not survive when you redirect, the only
     * way to store a message is to put it in the new session and then move
     * it to the request of the redirected page */
    private void setSessionMessage(HttpSession sessione, String message) {
    	if (sessione != null) {
			sessione.setAttribute("message", message);			
			
    	}
    }
    
    /* Get the session message and store (or append) it to the request as attribute,
     * then delete it from session */
    private void appendSessionMessage(HttpSession sessione, HttpServletRequest request) {
    	if (sessione.getAttribute("message") != null) {
			String message = (String) sessione.getAttribute("message");			
			sessione.removeAttribute("message");
			if(request.getAttribute("message")!= null)
				message = (String) request.getAttribute("message") +"<br>"+ message;
			request.setAttribute("message", message);
    	}
    }    
    
    
    /* Append a message to a request as "message" attribute,
     * and show it as a toast in the web page
     */
    private void ToastMessage(String message, HttpServletRequest request) {
    	if(request.getAttribute("message")!= null) {
				message = (String) request.getAttribute("message")+ "<br>" + message;
				//System.out.println("request.getAttribute(\"message\") : "+(String) request.getAttribute("message"));
				//System.out.println("message : "+message);		    	
    	}
    	request.setAttribute("message", message);    
    }
    
    /* USER AUTHENTICATION */
    
    /* Check if user is logged */
    private boolean isLogged(HttpSession sessione) {
    	boolean logged = false;
		if (sessione!= null && sessione.getAttribute("user") != null)
			logged = true;		
		return logged;
    }
    
    /* User Login */
    /* Effettua l'autenticazione e salva le informazioni dell'utente in sessione */
    private void logon(HttpSession sessione, HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, Exception  {
    	/* Lettura Parametri */
		String email = request.getParameter("email");
		String pwd = request.getParameter("password");	
		
		if(email != null) {
			User user = null;
			
			dbh.connect();
			user = dbh.authUser(email, pwd);			
			dbh.disconnect();
			
			if(user != null) 
				sessione.setAttribute("user", user);  // salva informazioni utente in sessione
			
		}
    }
    
    /* User Logout */
    private void logff(HttpSession sessione, HttpServletRequest request) {
    	if(sessione != null) 
    		sessione.invalidate();    	
    	// sessione = request.getSession();  // not necessary here
    }
    
    /* REQUEST DISPATCHER */
    
    /* Forward the http request to a specific jsp file */
    private void gotoJsp(String jsp, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException  {
    	//RequestDispatcher disp = request.getRequestDispatcher("WEB-INF/"+jsp);
    	RequestDispatcher disp = request.getRequestDispatcher("/WEB-INF/"+jsp);  // original
		// forward request to jsp file (view)
		disp.forward(request, response);
    }        
    
	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		super.init(config);
		try {
			dbh = new DBHelper();  // db helper to perform database operations
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
				
		/* Session */
		HttpSession sessione = request.getSession();
		sessione.setMaxInactiveInterval(AppConfig.sessionTime);  // sec, session life time 
		appendSessionMessage(sessione, request); // copia i messaggi salvati in sessione nella request
		
		/* Application path */
		String context = getServletContext().getContextPath();
		request.setAttribute("context", context); // il path va inviato alla jsp per ottenere gli url corretti
		
		/* Extract resource url */
		String[] url;
		try {
			url = UrlParser.parseFullUrl(request);
			System.out.println("URL PARSER: "+url[0]);
			
			if(url[0]==null) {
				ToastMessage("problema di lettura url", request);
				gotoJsp("template.jsp", request, response);
			}
			
			
			/* Routing */
			
			switch(url[0].trim()) {
			
			case "template": // template page test
				request.setAttribute("title", "template");  // page title
				ToastMessage("Template Page", request);
				
				dbh.connect();
				ArrayList<luke.models.classes.Dipendente> list = dbh.getDipendenti();
				request.setAttribute("list", list);
				dbh.disconnect();			
				
				
				gotoJsp(url[0].trim()+".jsp", request, response);
				break;
			case "error": // error page test
				request.setAttribute("title", "error");  // page title
				ToastMessage("Error Page", request);
				
								
				gotoJsp(url[0].trim()+".jsp", request, response);
				break;
			case "login":
				logon(sessione, request, response);
				if(!isLogged(sessione)) {
					ToastMessage("autenticazione non riuscita", request);
					gotoJsp("login.jsp", request, response);
				}
				else {
					//appendMessage("benvenuto "+(String) sessione.getAttribute("user"), request);
					//gotoJsp("dashboard.jsp", request, response);
					setSessionMessage(sessione, "Benvenuto "+((User) sessione.getAttribute("user")).getName() +" "+((User) sessione.getAttribute("user")).getSurname());
					response.sendRedirect("dashboard");
				}
				break;
			case "logout":
				logff(sessione, request);
				//appendMessage("logout effettuato", request);
				//gotoJsp("login.jsp", request, response);
				sessione = request.getSession();  // create a new session
				//sessione.setMaxInactiveInterval(AppConfig.sessionTime);  // sec, session life time 
				setSessionMessage(sessione, "Logout effettuato con successo");
				response.sendRedirect(getServletContext().getContextPath()+"/App");
				break;
			default:
				if(!isLogged(sessione))  {
					//appendMessage("Benvenuto!<br>", request);
					//appendMessage("effettuare il login", request);
					gotoJsp("template.jsp", request, response);
				}
				else {
					// response.sendRedirect(getServletContext().getContextPath()+"/App/template");
					gotoJsp("template.jsp", request, response);
				}
			}
			
		/* Exception Handling */	
		} catch (NumberFormatException e) {			
			e.printStackTrace();			
			ToastMessage("Number Format Exception: "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);
		} catch (ParseException e) {			
			e.printStackTrace();			
			ToastMessage("Parse Exception: "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);
		} catch (SQLException e) {			
			e.printStackTrace();			
			ToastMessage("SQL Exception: "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);
		} catch (InvalidKeyException e) {
			e.printStackTrace();			
			ToastMessage("Encryption Exception: invalid key; "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);		
		} catch (ClassNotFoundException e) {
			e.printStackTrace();			
			ToastMessage("Class Not Found Exception: "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);
		} catch (NullPointerException e) {
			e.printStackTrace();			
			ToastMessage("Null Pointer Exception: "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);
		} catch (Exception e) {			
			e.printStackTrace();			
			ToastMessage("Exception: "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);
		}		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
