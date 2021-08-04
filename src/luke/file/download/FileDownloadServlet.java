package luke.file.download;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import luke.database.helper.DBHelper;
import luke.models.classes.UploadItem;
 
/**
 * A servlet that retrieves a file from MySQL database and lets the client
 * downloads the file.
 * @author www.codejava.net
 */
@WebServlet("/downloadFile")
public class FileDownloadServlet extends HttpServlet {
 
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
    private String dbURL = "jdbc:mysql://localhost:3306/azienda?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
    private String dbUser = "root";
    private String dbPass = "";
     
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        // get upload id from URL's parameters
        int uploadId = Integer.parseInt(request.getParameter("id"));
         
        Connection conn = null; // connection to the database
         
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
                
        	dbh.connect();
        	UploadItem t = dbh.download(uploadId);
        	try {
        		dbh.disconnect();
        	} catch (SQLException e) {
        		// TODO Auto-generated catch block
        		e.printStackTrace();
        	} 

        	if (t!=null) {
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
            } else {
                // no file found
                response.getWriter().print("File not found for the id: " + uploadId);  
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            response.getWriter().print("SQL Error: " + ex.getMessage());
        } catch (IOException ex) {
            ex.printStackTrace();
            response.getWriter().print("IO Error: " + ex.getMessage());
        } /* finally {
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
}