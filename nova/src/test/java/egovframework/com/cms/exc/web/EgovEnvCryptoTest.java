package egovframework.com.cms.exc.web;

import org.egovframe.rte.fdl.cryptography.EgovEnvCryptoService;
import org.egovframe.rte.fdl.cryptography.impl.EgovEnvCryptoServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class EgovEnvCryptoTest {
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovEnvCryptoTest.class);
	public static void main(String[] args) {
		String[] arrCryptoString = {
				"userId",         //데이터베이스 접속 계정 설정
				"userPassword",   //데이터베이스 접속 패드워드 설정
				"url",            //데이터베이스 접속 주소 설정
				"databaseDriver"  //데이터베이스 드라이버
				,"rhdxhd12"
				,"hanmaDEV"
				,"hanma@7256"
				,"hanma7256"
				,"lgcap"
				,"hanma!@1234"
		              };

		        String classPath = System.getProperty("java.class.path");
		        System.out.println("Current ClassPath: " + classPath);
				LOGGER.info("------------------------------------------------------");
				@SuppressWarnings("resource")
				ApplicationContext context = new ClassPathXmlApplicationContext(new String[]{"classpath:/context-crypto-test.xml"});
				EgovEnvCryptoService cryptoService = context.getBean(EgovEnvCryptoServiceImpl.class);
				LOGGER.info("------------------------------------------------------");

				String label = "";
				try {
					for(int i=0; i < arrCryptoString.length; i++) {
						if(i==0)label = "사용자 아이디";
						if(i==1)label = "사용자 비밀번호";
						if(i==2)label = "접속 주소";
						if(i==3)label = "데이터 베이스 드라이버";
						LOGGER.info(label+" 원본(orignal):" + arrCryptoString[i]);
						LOGGER.info(label+" 인코딩(encrypted):" + cryptoService.encrypt(arrCryptoString[i]));
						LOGGER.info("------------------------------------------------------");
					}
				} catch (IllegalArgumentException e) {
					LOGGER.error("["+e.getClass()+"] IllegalArgumentException : " + e.getMessage());
				} catch (Exception e) {
					LOGGER.error("["+e.getClass()+"] Exception : " + e.getMessage());
				}
	}
}
