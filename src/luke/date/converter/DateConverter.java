package luke.date.converter;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

/*
 *  https://www.dariawan.com/tutorials/java/java-util-date-vs-java-sql-date/

*/

public class DateConverter {
	
	public static final String itFormat = "dd/MM/yyyy";  // italian date format
	
    public static void demo() {

        java.util.Date utilDate = new java.util.Date();
        System.out.println("java.util.Date time: " + utilDate);
        java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
        System.out.println("java.sql.Date time : " + sqlDate);     
        DateFormat df = new SimpleDateFormat("dd/MM/YYYY hh:mm:ss");
        System.out.println("Date formatted     : " + df.format(utilDate));
        
        /*
         * java.util.Date time: Thu Aug 01 01:49:48 SGT 2019
		   java.sql.Date time : 2019-08-01
		   Date formatted     : 01/08/2019 01:49:48
         * */
        java.sql.Date date = new java.sql.Date(new java.util.Date().getTime());
        System.out.println("Date SQL     : " + date.getDate());
    }
    
    /* Return a formatted date string */
    public static String formatDate(java.util.Date date, String format) {
    	DateFormat df = new SimpleDateFormat(format);
    	return df.format(date);
    }
    
    /* Use this method to convert datapicker date into sql date. The String format
     * must be "dd/MM/yyyy"!
     * */
    public static java.sql.Date String2Sql(String date) throws ParseException {
    	java.util.Date utilDate = new SimpleDateFormat("dd/MM/yyyy").parse(date);
    	return new java.sql.Date(utilDate.getTime());
    }
    
    /* Convert a sql date to a util.Date object */
    public static String Sql2String(java.sql.Date sqlDate) {
    	if(sqlDate != null)
    		return formatDate(Sql2Date(sqlDate), itFormat);
    	return "";
    }
    
    /* Convert a sql date to a util.Date object */
    public static java.util.Date Sql2Date(java.sql.Date sqlDate) {
    	
        //java.sql.Date sqlDate = java.sql.Date.valueOf("1980-04-09");
        //System.out.println("Sql2Date-> java.sql.Date time : " + sqlDate);
        java.util.Date utilDate = new java.util.Date(sqlDate.getTime());
        //System.out.println("Sql2Date-> java.util.Date time: " + utilDate);     
        //DateFormat df = new SimpleDateFormat("dd/MM/YYYY hh:mm:ss");
        //System.out.println("Date formatted     : " + df.format(utilDate));
        
        return utilDate;
        
        /*
         * java.sql.Date time : 1980-04-09
		   java.util.Date time: Wed Apr 09 00:00:00 SGT 1980
		   Date formatted     : 09/04/1980 12:00:00
         * */
    }
    
    public static void insertDate() throws Exception {

    	// (1) connect to postgresql database
    	String url = "jdbc:postgresql://localhost/coffeeshop";
    	Class.forName("org.postgresql.Driver");

    	try (Connection conn = DriverManager.getConnection(url, "barista", "espresso")) {
    		// (2) set java.sql.Date with current Date (and time)
    		java.util.Date utilDate = new java.util.Date();
    		java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
    		// (3) insert java.sql.Date to DB
    		String query = "INSERT INTO test_date(curr_date) VALUES (?)";
    		try (PreparedStatement pst = conn.prepareStatement(query)) {
    			pst.setDate(1, sqlDate);
    			// (4) execute update
    			pst.executeUpdate();
    		}
    	}
    }
    
    public static void readDate() throws Exception {

        // (1) connect to postgresql database
        String url = "jdbc:postgresql://localhost/coffeeshop";
        Class.forName("org.postgresql.Driver"); 

        try (Connection conn = DriverManager.getConnection(url, "barista", "espresso")) {
            // (2) create statement and query
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT curr_date FROM test_date");
            while ( rs.next() ) {
                java.sql.Date currSqlDate = rs.getDate("curr_date");
                java.util.Date currDate = new java.util.Date(currSqlDate.getTime());     
                // (3) print java.util.Date result
                System.out.println(currDate);
            }
        }
    }    

}
