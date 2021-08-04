package luke.app.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import luke.database.helper.DBHelper;
import luke.models.classes.UploadItem;
import luke.token.utils.TokenUtils;
 
/**
 * A servlet that retrieves a file from MySQL database and lets the client
 * downloads the file.
 * @author www.codejava.net
 */
@WebServlet("/download")
public class FileDownloadToken extends HttpServlet {
 
    /**
	 * https://www.codejava.net/java-ee/servlet/java-servlet-to-download-file-from-database
	 * https://www.codejava.net/coding/upload-files-to-database-servlet-jsp-mysql
	 * 
	 * https://o7planning.org/10839/upload-and-download-files-from-database-using-java-servlet
	 * 
	 * CREATE TABLE `files_upload` (
  		`upload_id` int(11) NOT NULL AUTO_INCREMENT,
  		`file_name` varchar(128) DEFAULT NULL,
  		`file_data` longblob,
  		PRIMARY KEY (`upload_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1
	 */
	private static final long serialVersionUID = 1L;

	// size of byte buffer to send file
    private static final int BUFFER_SIZE = 4096;   
    
    private DBHelper dbh;
    /**
     * @see HttpServlet#HttpServlet()
     */
    
    /* forward to a specific jsp file */
    private void gotoJsp(String jsp, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException  {
    	RequestDispatcher disp = request.getRequestDispatcher("/WEB-INF/"+jsp);
		// forward request to jsp file (view)
		disp.forward(request, response);
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
     
    // database connection settings
    // private String dbURL = "jdbc:mysql://localhost:3306/azienda?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
    // private String dbUser = "root";
    // private String dbPass = "";
     
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        // get upload id from URL's parameters
        
         
        //Connection conn = null; // connection to the database
        String message = "";
         
        try {
            // connects to the database
        	/*
            DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
 
            // queries the database
            String sql = "SELECT * FROM upload WHERE id = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setInt(1, uploadId);
 
            ResultSet result = statement.executeQuery();
            */
        	/*
            if (result.next()) {
                // gets file name and file blob data
                String fileName = result.getString("name");
                Blob blob = result.getBlob("file");
                InputStream inputStream = blob.getBinaryStream();
                int fileLength = inputStream.available();
                */
        	String token = request.getParameter("token"); 
        	int uploadId = Integer.parseInt(request.getParameter("id"));
        	int uid = Integer.parseInt(request.getParameter("uid"));  // user id
        	
        	dbh.connect();	
        	
        	UploadItem t = dbh.download(uploadId);
        	String data = TokenUtils.checkToken(dbh.getUserEmail(uid), token, dbh.getUserSharedKey(uid));
        	dbh.disconnect();
        	if(t==null)  {
				message += "Download del file con id="+uploadId+" non riuscito! Il file non è stato trovato. ";
				request.setAttribute("message", message);
                gotoJsp("Error.jsp", request, response);
			}
        	if(data == null) {
				message += "Download del file "+t.getName()+" (id="+t.getId()+") non riuscito! Token non valido! ";
				request.setAttribute("message", message);
                gotoJsp("Error.jsp", request, response);
			}
			else if(!data.equalsIgnoreCase(t.getName())) {
				message += "Download del file "+t.getName()+" non riuscito! Il nome del file nel Token non corrisponde: "+data+" ";
				request.setAttribute("message", message);
                gotoJsp("Error.jsp", request, response);
			}  
			else {        	
        		// gets file name and file blob data
        		String fileName = t.getName();
        		Blob blob = t.getBlob();
        		InputStream inputStream = blob.getBinaryStream();
        		int fileLength = inputStream.available();

        		System.out.println("fileLength = " + fileLength);

        		ServletContext context = getServletContext();

        		// sets MIME type for the file download
        		String mimeType = context.getMimeType(fileName);
        		if (mimeType == null) {        
        			mimeType = "application/octet-stream";
        		}              

        		// set content properties and header attributes for the response
        		response.setContentType(mimeType);
        		response.setContentLength(fileLength);
        		String headerKey = "Content-Disposition";
                String headerValue = String.format("attachment; filename=\"%s\"", fileName);
                response.setHeader(headerKey, headerValue);
 
                // writes the file to the client
                OutputStream outStream = response.getOutputStream();
                 
                byte[] buffer = new byte[BUFFER_SIZE];
                int bytesRead = -1;
                 
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outStream.write(buffer, 0, bytesRead);
                }
                 
                inputStream.close();
                outStream.close();             
            
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            //response.getWriter().print("SQL Error: " + ex.getMessage());
            request.setAttribute("message", "SQL Error: " + ex.getMessage());
            gotoJsp("Error.jsp", request, response);
        } catch (IOException ex) {
            ex.printStackTrace();
            //response.getWriter().print("IO Error: " + ex.getMessage());
            request.setAttribute("message", "IO Error: " + ex.getMessage());
            gotoJsp("Error.jsp", request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            //response.getWriter().print("IO Error: " + ex.getMessage());
            request.setAttribute("message", "Error: " + ex.getMessage());
            gotoJsp("Error.jsp", request, response);
        }
        /* finally {
            if (conn != null) {
                // closes the database connection
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }          
        } */
        
        
    }
    
    /**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
}