package egovframework.com.rd.usr.service.impl;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.vo.KkoVO;
import twitter4j.JSONArray;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

/**
 *
 * @author
 * @since
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 * </pre>
 */
@Service("kko")
public class Kko extends EgovAbstractServiceImpl {

	@Resource(name = "PayDAO")
	private PayDAO payDAO;

	private static final Logger LOGGER = LoggerFactory.getLogger(Kko.class);


	/**
	 * Scheduler 등을 통해 호출되는 처리를 담당한다.
	 * Spring(Quartz)에서 제공하는 MethodInvokingJobDetailFactoryBean 사용으로 호출된다.
	 * 관련 설정은 context-schedule.xml 참조
	 */
	@Transactional
	public void execute() {

		try {
			LOGGER.debug("kko ..........start");
			List<KkoVO> list = payDAO.selectKkoProsseceResult();

			for(int i = 0; i< list.size() ; i++) {
				KkoVO one = list.get(i);

				doznHttpRequestReport(one.getSendAccessToken(), one.getSendRefreshToken(), one.getReferenceKey(), one.getUserKey());
			}


			LOGGER.debug("kko ..........end");
		}catch (Exception e) {
			e.printStackTrace();
			LOGGER.error(e.toString());
		}
	}



	/**
	 * DOZN 알림톡 레포트
	 * @param sendAccessToken
	 * @param sendRefreshToken
	 * @return
	 */
	public String doznHttpRequestReport(String sendAccessToken, String sendRefreshToken, String referenceKey, String userKey) throws Exception {
    	HttpURLConnection connection = null;
        try {

            URL url = new URL(EgovProperties.getProperty("Globals.msgUrl")+"/api/v1/send/report/"+userKey);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Content-Type","application/json");
            connection.setRequestProperty("memberId", EgovProperties.getProperty("Globals.msgId"));
            connection.setRequestProperty("sendAccessToken", sendAccessToken);
            connection.setRequestProperty("sendRefreshToken", sendRefreshToken);
            connection.setConnectTimeout(15000); // 연결 타임아웃 (15초)
            connection.setReadTimeout(15000);    // 읽기 타임아웃 (15초)
            connection.setDoInput(true);

            connection.connect();


            StringBuilder response = new StringBuilder();
            // 6. 응답 처리
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {

            	InputStreamReader inReader = new InputStreamReader(connection.getInputStream());
                BufferedReader reader = new BufferedReader(inReader);
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                inReader.close();
                reader.close();
                LOGGER.debug("Response: " + response.toString());


                //{"code":"200","message":"success"
                //,"data":{"MSGTYPE":"KAT","STATUS":"3","PHONE":"01027428889","RESDATE":"20250801152522","SENTDATE":"20250801152524","RSLTDATE":"20250801152527","NETRSLT":"57204"
                //	,"KAORSLTCODE":"K204","KAOSENTDATE":"20250801152524","KAODONEDATE":"20250801152525","KAORSLTDATE":"20250801152527"}}
    	        if(!Util.isEmpty(response.toString())) {
    		        JSONParser jsonParse = new JSONParser();
    		        JSONObject jsonObj = (JSONObject) jsonParse.parse(response.toString());
    		        if("200".equals(jsonObj.get("code")) ) {

    		        	//거래이력 결과 수정
        		        JSONObject data = (JSONObject) jsonObj.get("data");
        		        KkoVO kkoVo = new KkoVO();
        		        kkoVo.setReferenceKey(referenceKey);
        		        kkoVo.setUserKey(userKey);
        		        kkoVo.setStatus(data.get("STATUS").toString());
        		        kkoVo.setMbtlnum(data.get("PHONE").toString());
        		        kkoVo.setKaorsltcode(data.get("KAORSLTCODE").toString());
        		        kkoVo.setRecvLongtxt(response.toString());
			        	kkoVo.setBigo("패스워드 알림 발송완료");
			            payDAO.updateKkoReport(kkoVo);

    		        }
    	        }

            } else {
            	LOGGER.debug("Error: " + responseCode);
            }
            if (connection != null) {
            	connection.disconnect();
            }
            return response.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }


}
