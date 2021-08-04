package luke.database.helper;


import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Properties;

import luke.app.controller.AppConfig;
import luke.date.converter.DateConverter;
import luke.models.classes.AccessoSportello;
import luke.models.classes.ReportItem;
import luke.models.classes.SimpleRecord;
import luke.models.classes.UploadItem;
import luke.models.classes.User;
import luke.models.classes.Dipendente;
import luke.token.utils.TokenUtils;

/*
	Date format:
	https://www.dariawan.com/tutorials/java/java-util-date-vs-java-sql-date/
*/
public class DBHelper {
	
	private static final String DRIVER = AppConfig.DBDRIVER;
	private static final String DBurl = AppConfig.DBurl; //?characterEncoding=utf8";
	private static final String user = AppConfig.DBuser;
	private static final String pwd = AppConfig.DBpwd;
	
	private Connection con;
	
	public DBHelper() throws ClassNotFoundException {
		
		con = null;		
		Class.forName(DRIVER);  // Load JDBC Driver
		
		if(AppConfig.debug)
			System.out.println("Driver Connector/J trovato!");
	}
	
	/* DB DRIVER */
	public void loadDriver() throws ClassNotFoundException {
		Class.forName(DRIVER);
	}
	
	/* CONNESSIONE DB */
	
	public void connect() throws SQLException {
		

		con = DriverManager.getConnection(DBurl, user, pwd);
		/*
			Properties props = new Properties();
			props.setProperty("user", user);
			props.setProperty("password", pwd);
			props.setProperty("ssl","false");
			con = DriverManager.getConnection(DBurl, props); */		
			
	}
	
	public void disconnect() throws SQLException {
		if(con != null)
			con.close();
	}
	
	/* AUTENTICAZIONE */
	
	/* User Authentication returning user data */
	public User authUser(String email, String pwd) throws SQLException {

		String query = "SELECT id, name, surname, email, pwd FROM "+AppConfig.tabAccount+" WHERE email=\'"+email+"\' AND pwd = md5(\'"+pwd+"\')";

		ResultSet res = null;
		Statement sql = null;
			    	
		sql = con.createStatement();	    	
		res = sql.executeQuery(query);	    

		
		if(res.next()) {
			User user = new User(res.getInt(1), res.getString(2), res.getString(3), res.getString(4), TokenUtils.getUserKey(res.getString(5)));
			return user;
		}
		return null;

	}
	
	public int updateUserPassword(String email, String newPassword) throws SQLException {
		String sql = "UPDATE "+AppConfig.tabAccount+" SET pwd=md5(\'"+newPassword+"\') WHERE email=\'"+email+"\'";		
		
		Statement statement = con.createStatement();	    	    	  	
	    return statement.executeUpdate(sql);
	}
	
	public int updateUserPassword(int id, String newPassword) throws SQLException {
		String sql = "UPDATE "+AppConfig.tabAccount+" SET pwd=md5(\'"+newPassword+"\') WHERE id="+id;		
		
		Statement statement = con.createStatement();	    	    	  	
	    return statement.executeUpdate(sql);
	}
	
	// return the user private shared key corresponding to id
	public String getUserSharedKey(int id) throws SQLException {
		String query = "SELECT pwd FROM "+AppConfig.tabAccount+" WHERE id="+id;

		ResultSet res = null;
		Statement sql = null;
			    	
		sql = con.createStatement();	    	
		res = sql.executeQuery(query);	    

		
		if(res.next()) {
			return TokenUtils.getUserKey(res.getString(1));			
		}
		return null;
		
	}
	
	// return the user private shared key corresponding to email
	public String getUserSharedKey(String email) throws SQLException {
			String query = "SELECT pwd FROM "+AppConfig.tabAccount+" WHERE email=\'"+email+"\'";

			ResultSet res = null;
			Statement sql = null;
				    	
			sql = con.createStatement();	    	
			res = sql.executeQuery(query);	    

			
			if(res.next()) {
				return TokenUtils.getUserKey(res.getString(1));			
			}
			return null;
			
		}
	
	// return user email corresponding to id
	public String getUserEmail(int id) throws SQLException {
		String query = "SELECT email FROM "+AppConfig.tabAccount+" WHERE id="+id;

		ResultSet res = null;
		Statement sql = null;
			    	
		sql = con.createStatement();	    	
		res = sql.executeQuery(query);	    

		
		if(res.next()) {
			return res.getString(1);			
		}
		return null;
	}
	
	// return user email corresponding to id
		public int getUserId(String email) throws SQLException {
			String query = "SELECT id FROM "+AppConfig.tabAccount+" WHERE email=\'"+email+"\'";

			ResultSet res = null;
			Statement sql = null;
				    	
			sql = con.createStatement();	    	
			res = sql.executeQuery(query);	    

			
			if(res.next()) {
				return res.getInt(1);			
			}
			return -1;
		}
	
	// check matching between id and email account
	public boolean checkUserEmail(int id, int email) throws SQLException {
		String query = "SELECT pwd FROM "+AppConfig.tabAccount+" WHERE id="+id+" AND email=\'"+email+"\'" ;

		ResultSet res = null;
		Statement sql = null;
			    	
		sql = con.createStatement();	    	
		res = sql.executeQuery(query);	    

		
		if(res.next()) {
			return true;			
		}
		return false;
		
	}
	// check if email account exist
	public boolean checkUserEmail(String email) throws SQLException {
		String query = "SELECT pwd FROM "+AppConfig.tabAccount+" WHERE email=\'"+email+"\'" ;

		ResultSet res = null;
		Statement sql = null;

		sql = con.createStatement();	    	
		res = sql.executeQuery(query);	    


		if(res.next()) {
			return true;			
		}
		return false;

	}
	
	/* make user autentication returning username (DEPRECATED) */
	public String auth(String email, String pwd) throws SQLException {
		
		String query = "SELECT name FROM "+AppConfig.tabAccount+" WHERE email=\'"+email+"\' AND pwd = md5(\'"+pwd+"\')";

		ResultSet res = null;
		Statement sql = null;

		sql = con.createStatement();	    	
		res = sql.executeQuery(query);	

		if(res.next()) {
			String name = res.getString(1);
			return name;
		}
		return null;

	}	
	
	
	/* TABELLA DIPENDENTE */
	public ArrayList<Dipendente> getDipendenti() throws SQLException {
		String query = "SELECT * FROM "+AppConfig.tabDipendenti;

		ResultSet res = null;
		Statement sql = null;

		sql = con.createStatement();	    	
		res = sql.executeQuery(query);	    

		ArrayList<Dipendente> list = new ArrayList<Dipendente>();


		while(res.next())
		{
			Dipendente d = new Dipendente(res.getInt(1), res.getString(2), res.getString(3),
					res.getInt(4), res.getString(5), res.getString(6), res.getInt(7));
			list.add(d);
		}

		return list;

	}	
	
	/* delete a record from a table */
	public int deleteFromTabella(String table, int id) throws SQLException  {
		
		String sql = "DELETE FROM "+table+" WHERE id = "+id;		
		Statement statement = con.createStatement();
        return statement.executeUpdate(sql); 		
	}
	
	/* FILE */
	
	/* upload a file */
	public int uploadFile(java.sql.Date date, InputStream file, String description, String name, long size) throws SQLException {
		String sql = "INSERT INTO upload (date, file, description, name, size) values (?, ?, ?, ?, ?)";
        PreparedStatement statement = con.prepareStatement(sql);
        statement.setDate(1, date);
        statement.setString(3, description);
        statement.setString(4, name);
        statement.setLong(5, size);
         
        if (file != null) {
            // fetches input stream of the upload file for the blob column
            statement.setBlob(2, file);            
        }
        
        return statement.executeUpdate();
	}
	
	/* upload a file */
	public int uploadFile(java.sql.Date date, InputStream file, String description, String name, long size, int fkid) throws SQLException {
		String sql = "INSERT INTO upload (date, file, description, name, size, fkid) values (?, ?, ?, ?, ?, ?)";
        PreparedStatement statement = con.prepareStatement(sql);
        statement.setDate(1, date);
        statement.setString(3, description);
        statement.setString(4, name);
        statement.setLong(5, size);
        if(fkid < 0)
        	statement.setNull(6, java.sql.Types.NULL);
        else
        	statement.setLong(6, fkid);
         
        if (file != null) {
            // fetches input stream of the upload file for the blob column
            statement.setBlob(2, file);            
        }
        
        return statement.executeUpdate();
	}
	
	/* download a file */
	public UploadItem download(int id) throws SQLException {
		String sql = "SELECT * FROM upload WHERE id = ?";
        PreparedStatement statement = con.prepareStatement(sql);
        statement.setInt(1, id);

        ResultSet res = statement.executeQuery();
        if (res.next()) {
        	UploadItem t = new UploadItem(res.getInt(1), DateConverter.Sql2Date(res.getDate(2)), res.getString(4), res.getString(5), res.getLong(6), res.getBlob(3), res.getInt(7));
        	return t;
        }
        return null;
	}
	
	/* delete a file */
	
	// deleteFromTabella(String table, int id)
	
	/* get file list with specific foreign key */
	public ArrayList<UploadItem> getFileList(int id) throws SQLException {
		String query = "SELECT id, date, description, name, size, fkid FROM upload WHERE fkid="+id+" ORDER BY date DESC";
		
		ResultSet res = null;
		Statement sql = null;
	    	    	
	    	sql = con.createStatement();	    	
	    	res = sql.executeQuery(query);	    
	    
	    	//System.out.println("Errore di esecuzione comando SQL: "+ query);
	    	//e.printStackTrace();
	    	//System.exit(1);  //quit
	    	//return null;
	    
	    ArrayList<UploadItem> list = new ArrayList<UploadItem>();	    

	    while(res.next())
	    {
	    	UploadItem d = new UploadItem(res.getInt(1), DateConverter.Sql2Date(res.getDate(2)), res.getString(3), res.getString(4), res.getLong(5), res.getInt(6));
	    	list.add(d);
	    }

	    //System.out.println("Errore di lettura risultato query ");
	    //e.printStackTrace();
		
	    return list;
		
	}
	
	/* get complete file list */
	public ArrayList<UploadItem> getFileListNullFk() throws SQLException {
		String query = "SELECT id, date, description, name, size, fkid FROM upload WHERE fkid is null ORDER BY date DESC";
		
		ResultSet res = null;
		Statement sql = null;
	    	    	
	    	sql = con.createStatement();	    	
	    	res = sql.executeQuery(query);	    
	    
	    	//System.out.println("Errore di esecuzione comando SQL: "+ query);
	    	//e.printStackTrace();
	    	//System.exit(1);  //quit
	    	//return null;
	    
	    ArrayList<UploadItem> list = new ArrayList<UploadItem>();	    

	    while(res.next())
	    {
	    	UploadItem d = new UploadItem(res.getInt(1), DateConverter.Sql2Date(res.getDate(2)), res.getString(3), res.getString(4), res.getLong(5), res.getInt(6));
	    	list.add(d);
	    }

	    //System.out.println("Errore di lettura risultato query ");
	    //e.printStackTrace();
		
	    return list;
		
	}
	
	/* get complete file list */
	public ArrayList<UploadItem> getFileList() throws SQLException {
		String query = "SELECT id, date, description, name, size, fkid FROM upload ORDER BY date DESC";
		
		ResultSet res = null;
		Statement sql = null;
	    	    	
	    	sql = con.createStatement();	    	
	    	res = sql.executeQuery(query);	    
	    
	    	//System.out.println("Errore di esecuzione comando SQL: "+ query);
	    	//e.printStackTrace();
	    	//System.exit(1);  //quit
	    	//return null;
	    
	    ArrayList<UploadItem> list = new ArrayList<UploadItem>();	    

	    while(res.next())
	    {
	    	UploadItem d = new UploadItem(res.getInt(1), DateConverter.Sql2Date(res.getDate(2)), res.getString(3), res.getString(4), res.getLong(5), res.getInt(6));
	    	list.add(d);
	    }

	    //System.out.println("Errore di lettura risultato query ");
	    //e.printStackTrace();
		
	    return list;
		
	}

}
