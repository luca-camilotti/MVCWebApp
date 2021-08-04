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
	private DBHelper dbh;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Controller() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    /* Utility: get the filename to upload */
    private static String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1); // MSIE fix.
            }
        }
        return null;
    }
    
    /* get the session message and store (append) it into request as attribute,
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
    /* store a message in session */
    private void setSessionMessage(HttpSession sessione, String message) {
    	if (sessione != null) {
			sessione.setAttribute("message", message);			
			
    	}
    }
    
    
    /* append a message to request "message" attribute,
     */
    private void ToastMessage(String message, HttpServletRequest request) {
    	if(request.getAttribute("message")!= null) {
				message = (String) request.getAttribute("message")+ "<br>" + message;
				//System.out.println("request.getAttribute(\"message\") : "+(String) request.getAttribute("message"));
				//System.out.println("message : "+message);		    	
    	}
    	request.setAttribute("message", message);    
    }
    
    /* Check if user is logged */
    private boolean isLogged(HttpSession sessione) {
    	boolean logged = false;
		if (sessione!= null && sessione.getAttribute("user") != null)
			logged = true;		
		return logged;
    }
    
    /* logon user - DEPRECATED */
    /*
    private void logon(HttpSession sessione, String username, String surname, String email) {
    	if(sessione != null) {
    		sessione.setAttribute("user", username);
    		sessione.setAttribute("surname", surname);
    		sessione.setAttribute("email", email);
    		sessione.setAttribute("logged", true);
    	}
    } */
    /* logoff user */
    private void logff(HttpSession sessione, HttpServletRequest request) {
    	if(sessione != null) 
    		sessione.invalidate();
    	
    	// sessione = request.getSession();
    }
    /* forward to a specific jsp file */
    private void gotoJsp(String jsp, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException  {
    	//RequestDispatcher disp = request.getRequestDispatcher("WEB-INF/"+jsp);
    	RequestDispatcher disp = request.getRequestDispatcher("/WEB-INF/"+jsp);  // original
		// forward request to jsp file (view)
		disp.forward(request, response);
    }
    
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
        
    
	/**
	 * @see Servlet#init(ServletConfig)
	 */
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
			
			case "template": // template page
				request.setAttribute("title", "template");  // page title
				ToastMessage("Template Page", request);
				
				dbh.connect();
				ArrayList<luke.models.classes.Dipendente> list = dbh.getDipendenti();
				request.setAttribute("list", list);
				dbh.disconnect();			
				
				
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
			// TODO Auto-generated catch block
			e.printStackTrace();
			//request.setAttribute("message", "URL PARSING: "+e.getMessage());
			ToastMessage("Number Format Exception: "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			//request.setAttribute("message", "URL PARSING: "+e.getMessage());
			ToastMessage("Parse Exception: "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			//request.setAttribute("message", "URL PARSING: "+e.getMessage());
			ToastMessage("SQL Exception: "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);
		} catch (InvalidKeyException e) {
			e.printStackTrace();
			//request.setAttribute("message", "URL PARSING: "+e.getMessage());
			ToastMessage("Encryption Exception: invalid key; "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);		
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			//request.setAttribute("message", "URL PARSING: "+e.getMessage());
			ToastMessage("ClassNotFound Exception: "+e.getMessage(), request);
			gotoJsp("error.jsp", request, response);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			//request.setAttribute("message", "URL PARSING: "+e.getMessage());
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
