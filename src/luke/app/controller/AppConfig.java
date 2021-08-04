package luke.app.controller;

public class AppConfig {
	
	
	/* Creare un utente per il database e assegnargli i privilegi:
	 * 
	 * 	CREATE USER 'pippo'@'%' IDENTIFIED BY 'pippopippo1111';

		GRANT ALL PRIVILEGES ON azienda.* TO 'pippo'@'%';
	 * 
	 * 
	 * 
	 * */
	
	public static final String version = "1.2";
	
	/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	 * @@@@@@@@@@@@@@ Debug @@@@@@@@@@@@@ 
	 * @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
	
	public static final boolean debug = true; //false;
	
	/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	 * @@@@@@ Configurazione SMTP @@@@@@@ 
	 * @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
	
	public static final String emailChangePwdSubject = "Reset password";
	public static final String emailChangePwdMsg = "<h4>Per reimpostare la tua password, clicca su questo %s </h4>";
	public static final String mailerLabel = "Mailer";
	public static final String smtpHost = "smtp.gmail.com";
	public static final String smtpUser = "";
	public static final String smtpPwd = "";
	public static final int sslPort = 587;
	
	
	/* Parametri di configurazione dell'applicazione */
	
	/* Session duration time */
	public static final int sessionTime = 7200; // session lifetime in seconds (7200 s = 2 hours)
	
	/* Toast display time */
	public static final int toastTime = 4000; // toast lifetime in ms 

	
	/* Token duration time */
	public static final long tokenValidity = sessionTime*1000; // session time in ms
	
	/* maximum upload file size */
	public static final long maxFileSize = 16177215;    // upload file's size up to 16MB
	
	/* maximum download buffer size */
	public static final int BUFFER_SIZE = 4096;
	
	/* AES Encryption key 128 bit */
	public static final String AESencryptionKey = "8j3@Ki586#qdYL?=";  // 16 char long AES secret key
	
	/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	 * @@@@@@ Credenziali Database @@@@@@ 
	 * @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
	
	/* DB locale e Raspberry (DRIVER Connector/J 5.1.40 ) */
	
	public static final String DBDRIVER = "com.mysql.jdbc.Driver";  // old driver name
	public static final String DBurl = "jdbc:mysql://localhost:3306/azienda"; //?characterEncoding=utf8";
	public static final String DBuser = "root";
	public static final String DBpwd = ""; 
	
	public static final String appBaseUrl = "localhost:8080";
	
		
	
	/* Nomi tabelle del DB */
	public static final String tabDipendenti = "dipendente";
	public static final String tabAccount = "account";
	public static final String tabFile = "upload";
	
	
	/* Tiloli sezione head pagine */
	public static final String titleHead = "App";
	
	/* Tiloli pagine */
	
	
	/* Titolo finestra Toast */
	public static final String titleToast = "Toast";
	
	
	/* Titoli menu principale */
	
	
	/* Titoli menu azioni */
	

}
