<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "javax.servlet.http.*,
luke.database.helper.DBHelper, 
luke.models.classes.UploadItem,
luke.ads.martino.AppConfig,
java.sql.*,
java.io.*,java.util.*, 
javax.servlet.*" %><%!
	// attributes and methods declaration:
	DBHelper dbh;

	/* forward to a specific jsp file */
	private void gotoJsp(String jsp, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher disp = request.getRequestDispatcher("/WEB-INF/" + jsp);
		// forward request to jsp file (view)
		disp.forward(request, response);
	}
%><%
	String message = "";
	dbh = new DBHelper();
	
	// file id
	int uploadId = Integer.parseInt(request.getParameter("id"));

	dbh.connect();
	UploadItem t = dbh.download(uploadId);
	try {
		dbh.disconnect();
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	if (t == null) {
		message += "Download del file con id=" + uploadId + " non riuscito! Il file non è stato trovato. ";
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

		//java.io.FileInputStream fileInputStream = new java.io.FileInputStream(filepath + filename);

		byte[] buffer = new byte[AppConfig.BUFFER_SIZE];
		int bytesRead = -1;
		// int i;
		// while ((i = inputStream.read()) != -1) {
		while ((bytesRead = inputStream.read(buffer /*, 0, buffer.length */ )) != -1) {
			// out.write(i);
			response.getOutputStream().write(buffer, 0, bytesRead);
		}
		//fileInputStream.close();

		/*
		// writes the file to the client
		OutputStream outStream = response.getOutputStream();

		byte[] buffer = new byte[AppConfig.BUFFER_SIZE];
		int bytesRead = -1;

		while ((bytesRead = inputStream.read(buffer)) != -1) {
			outStream.write(buffer, 0, bytesRead);
		}
		outStream.close();
		*/
		
		inputStream.close();
		response.getOutputStream().close();
	}
%>