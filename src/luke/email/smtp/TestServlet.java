package luke.email.smtp;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class TestServlet
 */
@WebServlet("/test")
public class TestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TestServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String message = "Test: ";
		try {

			String emailTo = request.getParameter("email");
			System.out.println("email: "+request.getParameter("email"));
			System.out.println("password: "+request.getParameter("password"));
			String subject=request.getParameter("subject");
			String msg=request.getParameter("msg");
			if(emailTo==null)
				message += "Manca l'indirizzo email del destinatario!";
			else {
				// Mailer.send(emailTo, subject, msg);
				message += "L'email è stata inviata all'indirizzo "+emailTo;
			}
		}
		catch (Exception e) {
			message += "Errore invio email: "+e.getMessage();
		}
		
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.print(message);
		out.close();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
