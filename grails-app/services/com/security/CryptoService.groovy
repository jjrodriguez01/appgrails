package com.security


import grails.transaction.Transactional

import java.security.InvalidKeyException;
import java.security.KeyFactory
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey
import java.security.interfaces.RSAPrivateKey
import java.security.spec.RSAPrivateKeySpec
import java.security.spec.RSAPublicKeySpec
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;



@Transactional
class CryptoService {
	

	public String rsaDecrypt(String strData) {
		try {
			String[] bytes = strData.split("#;#")
			def data = new byte[bytes.length];
			for (int i=0;i<bytes.length;i++) {
				data[i]= new Byte(bytes[i]);
			}
			RSAPrivateKey privKey =  this.readPrivateKeyFromFile("private.key");
			Cipher cipher = Cipher.getInstance("RSA");
			cipher.init(Cipher.DECRYPT_MODE, privKey);
			def pivote = 0
			def nextCeil = 0
			String sb = ""


			if(data.size()>256){
				while(nextCeil<data.size()){
					nextCeil+=256
					nextCeil = nextCeil>data.size()?data.size():nextCeil
					byte[] currentData = new byte[nextCeil-pivote]
					for(def i=pivote; i<nextCeil;i++){
						currentData[i-pivote]=data[i]
					}
					byte[] cipherData = cipher.doFinal(currentData);
					
					sb+= new String(cipherData);
					pivote+=nextCeil-pivote
				}
			}
			else{
				byte[] cipherData = cipher.doFinal(data);
				sb+=new String(cipherData)
			}

			return sb
		
		} catch (NoSuchAlgorithmException ex) {
			Logger.getLogger(this.class.getName()).log(Level.SEVERE, null, ex);
		} catch (NoSuchPaddingException ex) {
			Logger.getLogger(this.class.getName()).log(Level.SEVERE, null, ex);
		} catch (InvalidKeyException ex) {
			Logger.getLogger(this.class.getName()).log(Level.SEVERE, null, ex);
		} catch (IllegalBlockSizeException ex) {
			Logger.getLogger(this.class.getName()).log(Level.SEVERE, null, ex);
		} catch (BadPaddingException ex) {
		println ex.getStackTrace()
		print ex
			//Logger.getLogger(this.class.getName()).log(Level.SEVERE, null, ex);
		}
		return null;
	}
	
	public static PublicKey readKeyFromFile(String keyFileName)  {
		InputStream input = null;
		try {
			input = new FileInputStream(keyFileName);
		} catch (FileNotFoundException ex) {
		ex.printStackTrace()
		}
		try  {
			ObjectInputStream oin = new ObjectInputStream(new BufferedInputStream(input))
			BigInteger m = (BigInteger) oin.readObject();
			BigInteger e = (BigInteger) oin.readObject();
			RSAPublicKeySpec keySpec = new RSAPublicKeySpec(m, e);
			KeyFactory fact = KeyFactory.getInstance("RSA");
			PublicKey pubKey = fact.generatePublic(keySpec);
			return pubKey;
		} catch (Exception e) {
			throw new RuntimeException("Spurious serialisation error", e);
		}
	}


	
	public static String rsaEncrypt(String strData) {
		try {
			//println "el strData es: "+strData
			def data = strData.getBytes()
			
			PublicKey pubKey = this.readKeyFromFile("public.key");
			Cipher cipher = Cipher.getInstance("RSA");
			cipher.init(Cipher.ENCRYPT_MODE, pubKey);
			def pivote = 0
			def nextCeil = 0
			StringBuilder sb = new StringBuilder();
			if(data.size()>245){
				while(nextCeil<data.size()){
					nextCeil+=245
					nextCeil = nextCeil>data.size()?data.size():nextCeil
					byte[] currentData = new byte[nextCeil-pivote]
					for(def i=pivote; i<nextCeil;i++){
						currentData[i-pivote]=data[i]
					}
					byte[] cipherData = cipher.doFinal(currentData);
					
					for (byte b : cipherData) {
						sb.append(b+"#;#");
					}
					pivote+=nextCeil-pivote
				}
			}
			else{
				byte[] cipherData = cipher.doFinal(data);
				for (byte b : cipherData) {
					sb.append(b+"#;#");
				}
			}
			sb.setLength(sb.length()-3);
			return sb.toString();
			
		} catch (NoSuchAlgorithmException ex) {
			Logger.getLogger(this.class.getName()).log(Level.SEVERE, null, ex);
		} catch (NoSuchPaddingException ex) {
			Logger.getLogger(this.class.getName()).log(Level.SEVERE, null, ex);
		} catch (InvalidKeyException ex) {
			Logger.getLogger(this.class.getName()).log(Level.SEVERE, null, ex);
		} catch (IllegalBlockSizeException ex) {
			Logger.getLogger(this.class.getName()).log(Level.SEVERE, null, ex);
		} catch (BadPaddingException ex) {
			Logger.getLogger(this.class.getName()).log(Level.SEVERE, null, ex);
		}
		return null;
	}
	


	RSAPrivateKey readPrivateKeyFromFile(String keyFileName)  {
		def InputStream inputStream = null;
		
		try {
			inputStream = new FileInputStream(keyFileName);
		} catch (FileNotFoundException ex) {
			Logger.getLogger(this.class.getName()).log(Level.SEVERE, null, ex);
		}
		try  {
			def ObjectInputStream oin = new ObjectInputStream(new BufferedInputStream(inputStream))
			BigInteger m = (BigInteger) oin.readObject();
			BigInteger e = (BigInteger) oin.readObject();

			KeyFactory fact = KeyFactory.getInstance("RSA");
			RSAPrivateKeySpec keySpec = new RSAPrivateKeySpec(m, e);
			
			RSAPrivateKey privKey = (RSAPrivateKey) fact.generatePrivate(keySpec);
			return privKey;
		} catch (Exception e) {
			throw new RuntimeException("Spurious serialisation error", e);
		}
	}
}