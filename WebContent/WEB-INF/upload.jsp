<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "luke.date.converter.DateConverter,
java.sql.*,
java.text.ParseException,
luke.file.multipart.MultipartParse,
luke.models.classes.MyFileField,
luke.database.helper.DBHelper, 
luke.ads.martino.AppConfig,
java.io.*,java.util.*, 
javax.servlet.*" %>
<%@ page import = "javax.servlet.http.*" %>



<%!
// Reference: 
// https://www.tutorialspoint.com/jsp/jsp_file_uploading.htm

// attributes and methods declaration:
DBHelper dbh;

String getSubmittedFileName(Part part) {
    for (String cd : part.getHeader("content-disposition").split(";")) {
        if (cd.trim().startsWith("filename")) {
            String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1); // MSIE fix.
        }
    }
    return null;
}

%>
    
<%
    	

	dbh = new DBHelper();
	String message = null;  // message will be sent back to client



            /*
            String contentType = request.getContentType();
            if ((contentType.indexOf("multipart/form-data") < 0)) {
            	
            	message="Missing data, no multipart content found!";
            } */



            /* File upload test */
            /* File upload */
            // int fkid = Integer.parseInt(request.getParameter("fkid")); // foreign key id

            	MultipartParse map = new MultipartParse(request, getServletContext());
            	
            	MyFileField file = map.getFile("file");
            	String datepar = map.getParameter("date");
            	String description = map.getParameter("desc");
            	int fkid = -100;

            	java.sql.Date date = null;
            	try {
            		if (datepar != null) {
            			date = DateConverter.String2Sql(datepar);
            			System.out.println("Selected date: " + date);
            		}
            		fkid = Integer.parseInt(map.getParameter("id"));
            	} catch (ParseException e1) {
            		// TODO Auto-generated catch block
            		System.out.println("java.sql.Date parsing error! ");
            		e1.printStackTrace();
            	} catch (NumberFormatException e1) {
            		// TODO Auto-generated catch block
            		System.out.println("number parsing error! ");
            		e1.printStackTrace();
            	}

            	InputStream inputStream = null; // input stream of the upload file

            	// obtains the upload file part in this multipart request
            	// Part filePart = request.getPart("file");
     			if (file != null) {
    		// prints out some information for debugging

    		if (AppConfig.debug) {
    			System.out.println("File name: " + file.getName());
    			System.out.println("File size: " + file.getSize());
    			System.out.println("File content type: " + file.getContentType());
    			System.out.println("Date: " + datepar);
    			System.out.println("Description: " + description);
    			System.out.println("fkid: " + fkid);
    			// System.out.println(getSubmittedFileName(filePart));
    			// System.out.println(filePart.getSize());
    			// System.out.println(filePart.getContentType());
    		}

    		// obtains input stream of the upload file
    		//inputStream = filePart.getInputStream();
    		inputStream = file.getContent();

    	}

    	if (file != null && file.getSize() > AppConfig.maxFileSize) {

    		message = "File troppo grande! Dimendioni: " + file.getSize() + " bytes";
    	} else if (file != null && date != null /* && fkid >= 0 */) {
    		try {
    			// connects to the database
    			dbh.connect();
    			// int r = dbh.uploadFile(date, inputStream, "new prova", getSubmittedFileName(filePart), filePart.getSize());
    			int r = dbh.uploadFile(date, inputStream, description, file.getName(), file.getSize(), fkid);

    			dbh.disconnect();

    			if (r > 0) {
    				message = "File caricato e salvato con successo!";
    			}
    		} catch (SQLException ex) {
    			message = "DATABASE ERROR: " + ex.getMessage();
    			ex.printStackTrace();
    		} catch (NullPointerException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    			message = "DATABASE ERROR: " + e.getMessage();
    		} catch (Exception e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    			message = "DATABASE ERROR: " + e.getMessage();
    		}
    		// sets the message in request scope
    		//request.setAttribute("message", message);

    		// forwards to the message page
    		//getServletContext().getRequestDispatcher("/WEB-INF/login_bootstrap.jsp").forward(request, response);
    	} else {
    		message = "Impossibile caricare il file! Mancano dei dati..";
    	}

    	if (AppConfig.debug)
    		message += "\r\nNew Upload JSP\r\n fkid=" + fkid;
    	response.setContentType("text/html;charset=UTF-8");
    	response.getWriter().write(message);
    %>