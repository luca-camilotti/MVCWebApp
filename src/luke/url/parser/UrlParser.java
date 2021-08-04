package luke.url.parser;

import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

public class UrlParser {

	/* Parsing Url Example:
	 * 	   
		String[] url;
		try {
			url = UrlParser.parseFullUrl(request);
			System.out.println("URL PARSER: "+url[0]);  // prints the first piece of url after the servlet name
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		// Suppose the url is /myProject/myServlet/pippo/paperino?pluto=2
		// Then this piece of code would print "pippo".   
	 */
	
	public static String[] parseFullUrl(HttpServletRequest req) throws Exception {
		ArrayList<String> res = new ArrayList<String>();
		if(req.getRequestURI().length() <= (req.getContextPath().length() + req.getServletPath().length())) {
			res.add("");
			return res.toArray(new String[0]);	    	
		}
		
		String pathAfterContext = req.getRequestURI().substring(
	        req.getContextPath().length() + req.getServletPath().length() + 1);
	    
	    for (String val : pathAfterContext.split("/")) {
	        res.add(URLDecoder.decode(val, "UTF-8"));
	    }
	    String query = req.getQueryString();
	    if (query!=null) {
	        for (String val : query.split("&")) {
	            res.add(URLDecoder.decode(val, "UTF-8"));
	        }
	    }
	    return res.toArray(new String[0]);    // return an array of type String (new String[0] stands for the array type, and of course it does not mean that the array length will be zero)
	}
}
