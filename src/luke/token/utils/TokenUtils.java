package luke.token.utils;


import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.json.JSONException;
import org.json.JSONObject;

import luke.app.controller.AppConfig;
import luke.database.helper.DBHelper;


public class TokenUtils {
	
	/* Il token viene utilizzato per le chiamate alle servlet che non sono
	 * la servlet centrale (controller), e che quindi non condividono la sessione.
	 * Per evitare che chiunque possa accedere a queste chiamate, nella request
	 * viene passato un token contenente delle informazioni crittate con la chiave 
	 * privata dell'applicazione, in modo che la servlet secondaria possa decrittare 
	 * il token con la stessa chiave e verificare i dati
	 * 
	 * Il token contiene un json strutturato come segue:
	 * 
	 * { timestamp : ... ,
	 *   user: ... ,
	 *   data: ...
	 * }
	 * 
	 * il campo data contiene l'id o il nome dell'oggetto su cui si vuole effettuare 
	 * l'operazione.
	 * 
	 * */
	
	/*
	 * Json example:
	 * 
	 * 	JSONObject auth=new JSONObject();
		auth.put("username","adm");
		auth.put("password", "pwd");
		String message = auth.toString();
		os.write(message.getBytes("UTF-8"));

		Parsing JSON:

		JSONObject jObj = new JSONObject(jString);
		String totalItems= jObj.getString("totalItems");
	 * 
	 * 
	 * */
	
	private static final long tokenValidTime = AppConfig.tokenValidity;
	
	/* return the shared key of the user 
	 * 
	 * You can modify the way the key is created here:
	 * */
	public static String getUserKey(String hash) {
		if(hash.length()<32)
			return null;
		return hash.substring(5, 21);
	}
	
	/* Create token 
	 * 
	 * Every request should then contain user id and token as parameters
	 * 
	 * */
	public static String createToken(String email, String data, String key) throws JSONException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		long timestamp = System.currentTimeMillis();
		JSONObject token = new JSONObject();
		token.put("timestamp", timestamp);
		token.put("email", email);
		token.put("data", data);		
		return AESutils.encrypt(token.toString(), key);
	}
	
	/* return token data after checking token validity (time validity and user email matching)
	 * 
	 * email and key are retrieved with DBHelper.getUserToken(int id)
	 * and DBHelper.getUserEmail(int id)
	 * */
	
	public static String checkToken(String email, String token, String key) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, JSONException {
		String jsonStr = AESutils.decrypt(token, key);
		JSONObject jObj = new JSONObject(jsonStr);
		long time_now = System.currentTimeMillis();
		long time_before = jObj.getLong("timestamp");
		if(email.equalsIgnoreCase(jObj.getString("email")) && (time_now-time_before) < tokenValidTime)
			return jObj.getString("data");
		return null;
	}
	
	public static String getTokenData(String token, String key) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, JSONException {
		String jsonStr = AESutils.decrypt(token, key);
		JSONObject jObj = new JSONObject(jsonStr);
		long time_now = System.currentTimeMillis();
		long time_before = jObj.getLong("timestamp");
		if((time_now-time_before) < tokenValidTime)
			return jObj.getString("data");
		return null;
	}
	public static String getTokenEmail(String token, String key) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, JSONException {
		String jsonStr = AESutils.decrypt(token, key);
		JSONObject jObj = new JSONObject(jsonStr);
		long time_now = System.currentTimeMillis();
		long time_before = jObj.getLong("timestamp");
		if((time_now-time_before) < tokenValidTime)
			return jObj.getString("email");
		return null;
	}

}
