package egovframework.com.utl.enc;

import java.util.Base64;

public class SeedUtil {
	private static byte pbUserKey[] = "bananastrawberry".getBytes(); // 16
	private static byte bszIV[] = "0123456789abcdef".getBytes(); // 16

	public static String encrypt(String str) {

		byte[] userBytes = str.getBytes();
		byte[] pbData = new byte[userBytes.length];
		byte Cipher[];
		for(int i=0; i<pbData.length; i++) {
			if(i < userBytes.length)
				pbData[i] = userBytes[i];
			else
				pbData[i] = 0x00;
		}

		//암호화 함수 호출
		Cipher = KISA_SEED_CBC.SEED_CBC_Encrypt(pbUserKey, bszIV, pbData ,0, pbData.length);

		String enArray = Base64.getEncoder().encodeToString(Cipher);

		//String a = new String(enArray);
		return enArray;
	}

	public static String decrypt(String encrptedData) {

		byte[] decodedBytes = Base64.getDecoder().decode(encrptedData);
		byte[] Cipher = decodedBytes;
		String result = "";
		//복호화 함수 호출
		byte Plain1[] = KISA_SEED_CBC.SEED_CBC_Decrypt(pbUserKey, bszIV, Cipher, 0, Cipher.length);
		result = new String(Plain1);

		return result;
	}
}
