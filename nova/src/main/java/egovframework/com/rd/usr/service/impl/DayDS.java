package egovframework.com.rd.usr.service.impl;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.vo.DoszDSResultVO;
import egovframework.com.rd.usr.service.vo.DoszResultVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.DoznHistoryVO;
import kr.co.dozn.secure.base.CryptoUtil;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
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
@Service("dayDS")
public class DayDS extends EgovAbstractServiceImpl {

	@Resource(name = "PayDAO")
	private PayDAO payDAO;
	@Resource(name = "DtyDAO")
	private DtyDAO dtyDAO;

	private static final Logger LOGGER = LoggerFactory.getLogger(DayDS.class);


	/**
	 * Scheduler 등을 통해 호출되는 처리를 담당한다.
	 * Spring(Quartz)에서 제공하는 MethodInvokingJobDetailFactoryBean 사용으로 호출된다.
	 * 관련 설정은 context-schedule.xml 참조
	 */
	public void execute() {

		try {
			LOGGER.debug("24. [중계, 재판매] 더즌 내부 거래집계 DayDS ..........start");

				DoszDSResultVO one = new DoszDSResultVO();
				one.setApi_key(EgovProperties.getProperty("Globals.apiKey"));
				one.setOrg_code(EgovProperties.getProperty("Globals.orgCode"));
				one.setTr_dt(Util.getDay("DAY", -1));
				one.setRes_all_yn("Y");


				ObjectMapper mapper = new ObjectMapper();
				String jsonStr = mapper.writeValueAsString(one);

		        String tURL = EgovProperties.getProperty("Globals.doznDevUrl")+"/crypto/rt/v1/internalAggregation";

		        LOGGER.debug("json : "+jsonStr);
		        String responseData = doznHttpRequest(tURL, jsonStr);
		        LOGGER.debug("responseData1 : "+responseData);



		        if(!Util.isEmpty(responseData)) {
			        JSONParser jsonParse = new JSONParser();
			        JSONObject jsonObj = (JSONObject) jsonParse.parse(responseData);

			        one.setStatus(jsonObj.get("status").toString());
			        if("200".equals(one.getStatus()) ) {
			        	one.setDsDt(jsonObj.get("tr_dt").toString());
			        	one.setDsTm(jsonObj.get("send_tm").toString());
			        	one.setPaymentSuccCnt(jsonObj.get("payment_succ_cnt").toString());
			        	one.setPaymentSuccAmount(jsonObj.get("payment_succ_amount").toString());
			        	one.setPaymentFailCnt(jsonObj.get("payment_fail_cnt").toString());
			        	one.setPaymentFailAmount(jsonObj.get("payment_fail_amount").toString());
			        	one.setDepositorSuccCnt(jsonObj.get("depositor_succ_cnt").toString());
			        	one.setDepositorTimeCnt(jsonObj.get("depositor_time_cnt").toString());
			        	one.setDepositorFailCnt(jsonObj.get("depositor_fail_cnt").toString());
			        	payDAO.insertDoznDs(one);
			        	payDAO.updateDoznDs(one);
			        }
		        }

			LOGGER.debug("24. [중계, 재판매] 더즌 내부 거래집계 DayDS ..........end");
		}catch (Exception e) {
			e.printStackTrace();
			LOGGER.error(e.toString());
		}
	}


    //http 통신을 위한 함수
    private String doznHttpRequest(String targetURL, String jsonParameters) {
    	HttpURLConnection connection = null;

        try {
            CryptoUtil cryptoUtil = CryptoUtil.getInstance(EgovProperties.getProperty("Globals.doznKey"), EgovProperties.getProperty("Globals.doznIv"));
            LOGGER.debug("jsonParameters : "+jsonParameters);
            String encJsonParameters = cryptoUtil.encrypt(jsonParameters);
            LOGGER.debug("encJsonParameters : "+encJsonParameters);


            URL url = new URL(targetURL);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type","application/json");
            connection.setConnectTimeout(15000); // 연결 타임아웃 (15초)
            connection.setReadTimeout(15000);    // 읽기 타임아웃 (15초)
            connection.setDoOutput(true);

            DataOutputStream wr = new DataOutputStream (connection.getOutputStream());





            wr.writeBytes(encJsonParameters);
            wr.close();

            if(connection.getResponseCode() < 400) {
	            InputStream is = connection.getInputStream();

	            BufferedReader rd = new BufferedReader(new InputStreamReader(is, "utf-8"));
	            StringBuffer response = new StringBuffer();
	            String line;
	            while ((line = rd.readLine()) != null) {
	                response.append(line);
	            }

	            LOGGER.debug("response : "+response.toString());
	            String returnStr = cryptoUtil.decrypt(response.toString());
	            LOGGER.debug("decResponse : "+returnStr);
	            rd.close();


	            return returnStr;
            } else {

            	BufferedReader rd = new BufferedReader(new InputStreamReader(connection.getErrorStream()));
            	StringBuffer response = new StringBuffer();
	            String line;
	            while ((line = rd.readLine()) != null) {
	                response.append(line);
	            }

	            LOGGER.debug("response : "+response.toString());
	            rd.close();

	            return response.toString();
            }
        } catch (Exception e) {
            e.printStackTrace();
        	return "{\n"
	        + "    \"status\": \"999 \",\n"
	        + "    \"error_code\": \"\",\n"
	        + "    \"error_message\": \"\",\n"

	        + "}";
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }


}
