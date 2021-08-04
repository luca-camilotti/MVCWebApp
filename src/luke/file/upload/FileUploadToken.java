package luke.file.upload;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

import luke.app.controller.*;
import luke.database.helper.DBHelper;
import luke.date.converter.DateConverter;
import luke.token.utils.TokenUtils;

/**
 * Servlet implementation class FileUploadDBServlet
 * 
 * https://www.codejava.net/coding/upload-files-to-database-servlet-jsp-mysql
 * 
 * 
 * create database AppDB;

	use AppDB;

	CREATE TABLE `contacts` (
  	`contact_id` int(11) NOT NULL AUTO_INCREMENT,
  	`first_name` varchar(45) DEFAULT NULL,
  	`last_name` varchar(45) DEFAULT NULL,
  	`photo` mediumblob,
  	PRIMARY KEY (`contact_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1
 * 
 * 
 */
@WebServlet("/upload")
@MultipartConfig(maxFileSize = AppConfig.maxFileSize) 
// @MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB

public class FileUploadToken extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// database connection settings
	/*
    private String dbURL = "jdbc:mysql://localhost:3306/azienda";
    private String dbUser = "root";
    private String dbPass = "";
	 */  
	private DBHelper dbh;
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileUploadToken() {
		super();
		// TODO Auto-generated constructor stub
	}

	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		super.init(config);
		try {
			dbh = new DBHelper();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//template = HtmlUtils.getHtmlfromFile(this, "template.html");
		//template = template.replace("{action}", getServletContext().getContextPath()+"/Demo");
	}

	private static String getSubmittedFileName(Part part) {
		for (String cd : part.getHeader("content-disposition").split(";")) {
			if (cd.trim().startsWith("filename")) {
				String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
				return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1); // MSIE fix.
			}
		}
		return null;
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// gets values of text fields
		//String firstName = request.getParameter("firstName");
		//String lastName = request.getParameter("lastName");

		String message = "";  // message will be sent back to client
		InputStream inputStream = null; // input stream of the upload file
		int fkid;  // fkid field
		int uid;  // user id to retrieve the private key
		java.sql.Date date = null;  // date field

		/* File upload */
		String token = request.getParameter("token");    	
		String description = request.getParameter("desc");
		String datepar = request.getParameter("date");

		try {
			date = DateConverter.String2Sql(datepar);
			//System.out.println("Selected date: " + date);
			fkid = Integer.parseInt(request.getParameter("id"));
			uid = Integer.parseInt(request.getParameter("uid"));

			// obtains the upload file part in this multipart request
			Part filePart = request.getPart("file");
			if (filePart != null) {
				// prints out some information for debugging
				System.out.println(filePart.getName());
				System.out.println(getSubmittedFileName(filePart));
				System.out.println(filePart.getSize());
				System.out.println(filePart.getContentType());

				// obtains input stream of the upload file
				inputStream = filePart.getInputStream();
			}
			
			

			if (filePart != null && date != null) {

				int r = -1; // risposta dell'operazione di insert
				// connects to the database
				dbh.connect();
				String data = TokenUtils.checkToken(dbh.getUserEmail(uid), token, dbh.getUserSharedKey(uid));
				if(data == null) {
					message += "Caricamento del file "+getSubmittedFileName(filePart)+" non riuscito! Token non valido! ";
				}
				else if(!data.equalsIgnoreCase(fkid+"")) {
					message += "Caricamento del file "+getSubmittedFileName(filePart)+" non riuscito! L'id nel Token non corrisponde: "+data+" (dovrebbe essere "+fkid+") ";					
				}
				else 
					r = dbh.uploadFile(date, inputStream, description, getSubmittedFileName(filePart), filePart.getSize(), fkid);
				dbh.disconnect();

				if (r > 0) {
					message += "File "+getSubmittedFileName(filePart)+" caricato con successo: "+filePart.getSize()/1000+" KB";
				

					// sets the message in request scope
					//request.setAttribute("message", message);

					// forwards to the message page
					//getServletContext().getRequestDispatcher("/WEB-INF/login_bootstrap.jsp").forward(request, response);
				}
				else {
					message +="Spiacente.. mancano dei dati e il file non può essere caricato nel server. ";
					message += "date: "+date+", description: "+description+", file name: "+getSubmittedFileName(filePart)+", size: "+filePart.getSize()+", fkid: "+fkid;
				}
			}
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			message = "Upload Error: (java.sql.Date parsing error) " + e.getMessage();    			
			e.printStackTrace();
		} catch (NumberFormatException ex) {
			message = "Upload Error: (NumberFormatException) " + ex.getMessage();
			ex.printStackTrace();
		} catch (SQLException ex) {
			message = "Upload Error: (SQLException) " + ex.getMessage();
			ex.printStackTrace();
		} catch (NullPointerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			message =  "Upload Error: (NullPointerException) "+e.getMessage();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			message = "Upload Error: "+e.getMessage();
		}

		/*
		String datepar = request.getParameter("date");
		java.sql.Date date = null;
		try {
			if(datepar != null) {
				date = DateConverter.String2Sql(datepar);			
				System.out.println("Selected date: "+datepar+" converted to "+ date);
			}
		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			System.out.println("java.sql.Date parsing error! ");
			e1.printStackTrace();
		}

        InputStream inputStream = null; // input stream of the upload file

        // obtains the upload file part in this multipart request
        Part filePart = request.getPart("file");
        if (filePart != null) {
            // prints out some information for debugging
            System.out.println(filePart.getName());
            System.out.println(getSubmittedFileName(filePart));
            System.out.println(filePart.getSize());
            System.out.println(filePart.getContentType());

            // obtains input stream of the upload file
            inputStream = filePart.getInputStream();
        }

        Connection conn = null; // connection to the database
        String message = null;  // message will be sent back to client

        try {
            // connects to the database
            DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // constructs SQL statement
            String sql = "INSERT INTO upload (date, file, description, name) values (?, ?, ?, ?)";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setDate(1, date);
            statement.setString(3, "prova");
            statement.setString(4, getSubmittedFileName(filePart));

            if (inputStream != null) {
                // fetches input stream of the upload file for the blob column
                statement.setBlob(2, inputStream);
            }

            // sends the statement to the database server
            int row = statement.executeUpdate();
            if (row > 0) {
                message = "File uploaded and saved into database";
            }
        } catch (SQLException ex) {
            message = "ERROR: " + ex.getMessage();
            ex.printStackTrace();
        } finally {
            if (conn != null) {
                // closes the database connection
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }*/
		// sets the message in request scope
		// request.setAttribute("message", message);

		// Option 1: forwards to the message page
		//getServletContext().getRequestDispatcher("/WEB-INF/login_bootstrap.jsp").forward(request, response);

		// Option 2: write a message back for ajax request
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(message);
	}
}
