package luke.email.smtp;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import luke.app.controller.AppConfig;

public class Mailer {
	public static void send(String to,String subject,String msg){

		/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		 * @@@@@@@@ DISABILITARE ANTIVIRUS @@@@@@@@
		 * @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		 * */
		
		/* https://www.journaldev.com/2532/javamail-example-send-mail-in-java-smtp 
		 * https://www.tutorialspoint.com/java/java_sending_email.htm
		 * https://stackoverflow.com/questions/14803761/how-to-send-mail-in-java-using-same-mechanism-like-in-php-mail
		 * */
		/* Cambiare credenziali */
		/* disabilitare antivirus per attivarlo da locale */
		final String user = AppConfig.smtpUser;//change accordingly
		final String pass = AppConfig.smtpPwd;

		//1st step) Get the session object	
		Properties props = new Properties();
		props.put("mail.smtp.host", AppConfig.smtpHost);//change accordingly
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.ssl.trust", AppConfig.smtpHost);
		props.put("mail.smtp.starttls.enable","true");
		// Use the following if you need SSL
		props.put("mail.smtp.socketFactory.port", AppConfig.sslPort);
		props.put("mail.smtp.port", AppConfig.sslPort+"");
		props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		//props.put("mail.smtp.socketFactory.fallback", "false");
		//props.setProperty("mail.user", user);                   
		//props.setProperty("mail.password", pass);  


		// Session session = Session.getDefaultInstance(props);  

		Session session = Session.getDefaultInstance(props,
				new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(user,pass);
			}
		}); 
		//2nd step)compose message
		try {
			MimeMessage message = new MimeMessage(session);
			
			message.setFrom(new InternetAddress(user, AppConfig.mailerLabel));
			message.addRecipient(Message.RecipientType.TO,new InternetAddress(to));
			message.setSubject(subject);
			message.setText(msg);  // plain text message
			message.setContent(msg, "text/html; charset=utf-8");  // html message

			//3rd step)send message
			Transport.send(message);

			// System.out.println("Done");

		} catch (UnsupportedEncodingException e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
			throw new RuntimeException(e);
		
		} catch (MessagingException e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
			throw new RuntimeException(e);
		}

	}
}
