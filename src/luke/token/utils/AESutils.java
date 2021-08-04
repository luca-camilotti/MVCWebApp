package luke.token.utils;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
/* https://www.includehelp.com/java-programs/encrypt-decrypt-string-using-aes-128-bits-encryption-algorithm.aspx
https://www.baeldung.com/java-aes-encryption-decryption

AES Variations:
	ECB (Electronic Code Book)
	CBC (Cipher Block Chaining)
	CFB (Cipher FeedBack)
	OFB (Output FeedBack)
	CTR (Counter)
	GCM (Galois/Counter Mode)
*/
import java.util.Base64;
import java.util.Scanner;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import luke.app.controller.AppConfig;

/**
 * Program to Encrypt/Decrypt String Using AES 128 bit Encryption Algorithm
 */
public class AESutils {
    
    private static final String encryptionKey           = AppConfig.AESencryptionKey;  // 16 char long
    private static final String characterEncoding       = "UTF-8";
    private static final String cipherTransformation    = "AES/CBC/PKCS5PADDING";
    private static final String aesEncryptionAlgorithem = "AES";
    
    
    /**
     * Method for Encrypt Plain String Data
     * @param plainText
     * @return encryptedText
     * @throws BadPaddingException 
     * @throws IllegalBlockSizeException 
     * @throws InvalidAlgorithmParameterException 
     * @throws UnsupportedEncodingException 
     * @throws NoSuchPaddingException 
     * @throws NoSuchAlgorithmException 
     * @throws InvalidKeyException 
     */
    public static String encrypt(String plainText) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
    	return encrypt(plainText, encryptionKey);
    }
    
    public static String decrypt(String encryptedText) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
    	return decrypt(encryptedText, encryptionKey);
    }
    
    public static String encrypt(String plainText, String sharedkey) throws NoSuchAlgorithmException, NoSuchPaddingException, UnsupportedEncodingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
    	String encryptedText = "";

    	Cipher cipher   = Cipher.getInstance(cipherTransformation);
    	byte[] key      = sharedkey.getBytes(characterEncoding);
    	SecretKeySpec secretKey = new SecretKeySpec(key, aesEncryptionAlgorithem);
    	IvParameterSpec ivparameterspec = new IvParameterSpec(key);
    	cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivparameterspec);
    	byte[] cipherText = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8/* "UTF8" */));
    	/* Use Base64.getUrlEncoder() instead of Base64.getEncoder() to get a URL-safe string */
    	Base64.Encoder encoder = Base64.getUrlEncoder(); // Base64.getEncoder(); // Base64.getMimeEncoder();
    	encryptedText = encoder.encodeToString(cipherText);


    	return encryptedText;
    }

    /**
     * Method For Get encryptedText and Decrypted provided String
     * @param encryptedText
     * @return decryptedText
     * @throws NoSuchPaddingException 
     * @throws NoSuchAlgorithmException 
     * @throws UnsupportedEncodingException 
     * @throws InvalidAlgorithmParameterException 
     * @throws InvalidKeyException 
     * @throws BadPaddingException 
     * @throws IllegalBlockSizeException 
     */
    public static String decrypt(String encryptedText, String sharedkey) throws NoSuchAlgorithmException, NoSuchPaddingException, UnsupportedEncodingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
    	String decryptedText = "";

    	Cipher cipher = Cipher.getInstance(cipherTransformation);
    	byte[] key = sharedkey.getBytes(characterEncoding);
    	SecretKeySpec secretKey = new SecretKeySpec(key, aesEncryptionAlgorithem);
    	IvParameterSpec ivparameterspec = new IvParameterSpec(key);
    	cipher.init(Cipher.DECRYPT_MODE, secretKey, ivparameterspec);
    	/* Use Base64.getUrlDecoder() instead of Base64.getDecoder() to get a URL-safe string */
    	Base64.Decoder decoder = Base64.getUrlDecoder();  // Base64.getDecoder(); // Base64.getMimeDecoder(); 
    	byte[] cipherText = decoder.decode(encryptedText.getBytes(StandardCharsets.UTF_8 /* "UTF8" */));
    	decryptedText = new String(cipher.doFinal(cipherText), StandardCharsets.UTF_8 /* "UTF8" */);


    	return decryptedText;
    }
    
    /*
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter String : ");
        String plainString = sc.nextLine();
        
        String encyptStr   = encrypt(plainString);
        String decryptStr  = decrypt(encyptStr);
        
        System.out.println("Plain   String  : "+plainString);
        System.out.println("Encrypt String  : "+encyptStr);
        System.out.println("Decrypt String  : "+decryptStr);
        
    }   */
}
