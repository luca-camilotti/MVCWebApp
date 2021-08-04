package luke.file.multipart;

import java.util.HashMap;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.*;
import org.apache.commons.fileupload.servlet.*;
import org.apache.commons.io.output.*;

import luke.app.controller.AppConfig;
import luke.models.classes.MyFileField;

/* This class is used for file upload in upload.jsp */

public class MultipartParse {
	
	private HttpServletRequest request;
	private ServletContext servletContext;
	
	private HashMap<String, String> parameters;  // normal form parameters
	private HashMap<String, MyFileField> files;  // file form parameters
	
	private boolean isMultipart(HttpServletRequest request) {
		// Check that we have a file upload request
		return ServletFileUpload.isMultipartContent(request);
	}
	
	private List<FileItem> getRequestItems(HttpServletRequest request, ServletContext servletContext) throws FileUploadException {
		// Create a factory for disk-based file items
		DiskFileItemFactory factory = new DiskFileItemFactory();

		// Configure a repository (to ensure a secure temp location is used)
		// ServletContext servletContext = this.getServletConfig().getServletContext();
		File repository = (File) servletContext.getAttribute("javax.servlet.context.tempdir");
		factory.setRepository(repository);
		
		// Set factory constraints
		// factory.setSizeThreshold(yourMaxMemorySize);
		// factory.setRepository(yourTempDirectory);

		// Create a new file upload handler
		ServletFileUpload upload = new ServletFileUpload(factory);

		// Set max size
		upload.setSizeMax(AppConfig.maxFileSize);
		
		// Parse the request
		List<FileItem> items = upload.parseRequest(request);
		
		return items;
	}
	
	// Constructor
	public MultipartParse(HttpServletRequest req, ServletContext ctx) {
		this.request = req;
		this.servletContext = ctx;
		this.parameters = new HashMap<String, String>();
		this.files = new HashMap<String, MyFileField>();
		
		List<FileItem> items = null;
		try {
			items = getRequestItems(this.request, this.servletContext);
		} catch (FileUploadException e) {			
			e.printStackTrace();
		}
		
		if(items!=null) {
			// Process the uploaded items
			Iterator<FileItem> iter = items.iterator();
			while (iter.hasNext()) {
			    FileItem item = iter.next();
			    if (item.isFormField()) {
			    	String name = item.getFieldName();
			        String value = item.getString();
			        this.parameters.put(name, value);
			    } else {
			    	String fieldName = item.getFieldName();
			        String fileName = item.getName();
			        String contentType = item.getContentType();
			        boolean isInMemory = item.isInMemory();
			        long sizeInBytes = item.getSize();
			        InputStream uploadedStream = null;
			        try {
						uploadedStream = item.getInputStream();
						if(AppConfig.debug)
							System.out.println("File InputStream: "+uploadedStream);
					} catch (IOException e) {						
						e.printStackTrace();
					}
			        /*
			         * File uploadedFile = new File(...);
			         * item.write(uploadedFile);
			         */
			        MyFileField file = new MyFileField(fileName, sizeInBytes, contentType, uploadedStream);
			        this.files.put(fieldName, file);
			    }
			}
		}		
		
	}
	
	public String getParameter(String name) {
		String value = null;
		
		value = this.parameters.get(name);
		
		return value;
	}
	
	public MyFileField getFile(String name) {
		MyFileField value = null;
		
		value = this.files.get(name);
		
		return value;
	}

}
