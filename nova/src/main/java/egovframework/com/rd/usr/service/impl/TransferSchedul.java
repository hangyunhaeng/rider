package egovframework.com.rd.usr.service.impl;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.vo.BalanceVO;
import egovframework.com.rd.usr.service.vo.DoszResultVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.DoznHistoryVO;
import egovframework.com.rd.usr.service.vo.Sch;
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
@Service("transferSchedul")
public class TransferSchedul extends EgovAbstractServiceImpl {

	@Resource(name = "PayDAO")
	private PayDAO payDAO;
	@Resource(name = "DtyDAO")
	private DtyDAO dtyDAO;

	@Resource(name = "transactionManager")
    private DataSourceTransactionManager transactionManager;

	private static final Logger LOGGER = LoggerFactory.getLogger(TransferSchedul.class);


	/**
	 * Scheduler 등을 통해 호출되는 처리를 담당한다.
	 * Spring(Quartz)에서 제공하는 MethodInvokingJobDetailFactoryBean 사용으로 호출된다.
	 * 관련 설정은 context-schedule.xml 참조
	 */
	@Transactional
	public void execute() {

		DefaultTransactionDefinition transaction = new DefaultTransactionDefinition();
		transaction.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus transactionStatus = transactionManager.getTransaction(transaction);

		try {
			LOGGER.debug("Transfer ..........start");

			//0. 사용자 select for update 로 rock
			Sch sch = new Sch();
			sch.setCooperatorMberId(EgovProperties.getProperty("Globals.cooperatorId"));
			List<BalanceVO> forUpadteList = payDAO.selectForUpdateBalanceTranster(sch);

			List<DoszResultVO> list = payDAO.selectTransterProsseceResult();



			for(int i = 0; i< list.size() ; i++) {
				DoszResultVO one = list.get(i);
				one.setApi_key(EgovProperties.getProperty("Globals.apiKey"));
				one.setOrg_code(EgovProperties.getProperty("Globals.orgCode"));
				one.setRes_all_yn("y");


				ObjectMapper mapper = new ObjectMapper();
				String jsonStr = mapper.writeValueAsString(one);

		        String tURL = EgovProperties.getProperty("Globals.doznDevUrl")+"/crypto/rt/v1/transfer/check";

		        LOGGER.debug("json : "+jsonStr);
		        String responseData = doznHttpRequest(tURL, jsonStr, one.getTr_dt(), one.getOrg_telegram_no());
		        LOGGER.debug("responseData1 : "+responseData);



		        if(!Util.isEmpty(responseData)) {
			        JSONParser jsonParse = new JSONParser();
			        JSONObject jsonObj = (JSONObject) jsonParse.parse(responseData);

			        DoszResultVO doszResultVO = new DoszResultVO();
		        	doszResultVO.setStatus(jsonObj.get("status").toString());
		        	doszResultVO.setLastUpdusrId("batch");
		        	doszResultVO.setTranDay(one.getTr_dt());
		        	doszResultVO.setTelegramNo(one.getOrg_telegram_no());
			        if("200".equals(doszResultVO.getStatus()) ) {
			        	doszResultVO.setStatusCd(jsonObj.get("status_cd").toString());
			        	doszResultVO.setSendDt(jsonObj.get("tr_dt").toString());		//은행 실 거래 날짜
			        	doszResultVO.setSendTm(jsonObj.get("tr_tm").toString());		//은행 실 거래 시간
			        	doszResultVO.setNatvTrNo(jsonObj.get("natv_tr_no").toString());
			        } else {
			        	doszResultVO.setErrorCode(jsonObj.get("error_code").toString());
			        	doszResultVO.setErrorMessage(jsonObj.get("error_message").toString());
			        }

			        payDAO.updateTransterProsseceResult(doszResultVO);



			        DoszTransferVO tranResult = new DoszTransferVO();
			        tranResult.setStatus(doszResultVO.getStatus());
			        tranResult.setErrorCode(doszResultVO.getErrorCode());
			        tranResult.setStatusCd(doszResultVO.getStatusCd());
			        tranResult.setTranDay(one.getTr_dt());
			        tranResult.setTelegram_no(one.getOrg_telegram_no());
            		tranResult.setLastUpdusrId("batch");

		            if(Util.isEmpty(tranResult.getStatus())){	//응답없음
//		            	dtyDAO.updateDayPayByTransfer(tranResult);
//	            		dtyDAO.updateWeekPayByTransfer(tranResult);
		            }
		            else {
		            	if("400".equals(tranResult.getStatus()) && "VTIM".equals(tranResult.getErrorCode())) {	//은행timeout
		            		// 배치에서 재처리
		            	} else if("400".equals(tranResult.getStatus()) && "0011".equals(tranResult.getErrorCode())) {	//처리중
		            		// 배치에서 재처리
		            	} else if("999".equals(tranResult.getStatus())) {	//커넥센실패
		            		// 배치에서 재처리
		            	} else if("200".equals(tranResult.getStatus()) ){	//성공


		    		        //선입금 완료시 협력사 잔액 조정
		            		tranResult.setCooperatorMberId(EgovProperties.getProperty("Globals.cooperatorId"));
		    		        dtyDAO.updateBalanceDayTran(tranResult);
		    		        //선입금 완료시 영업사원 잔액 조정
		    		        dtyDAO.updateBalanceSalesDayTran(tranResult);


		            	} else {
		            		// 라이더 잔액 조정
		            		dtyDAO.updateBalanceDayPayByTransfer(tranResult);
		            		// 거래내역 삭제(DAY)
		            		dtyDAO.updateDayPayByTransfer(tranResult);	//실패 확정시 거래내역 삭제
		            		dtyDAO.deleteProfit(tranResult);
		            		dtyDAO.deleteCooperatorProfit(tranResult);
		            		dtyDAO.deleteSalesProfit(tranResult);

		            		// 라이더 잔액 조정
		            		dtyDAO.updateBalanceWeekPayByTransfer(tranResult);
		            		// 거래내역 삭제(WEEK)
		            		dtyDAO.updateWeekPayByTransfer(tranResult);	//실패 확정시 거래내역 삭제


		            		// 협력사 잔액 조정
		            		// 거래내역 삭제(협력사)
		            		tranResult.setCooperatorMberId(EgovProperties.getProperty("Globals.cooperatorId"));
		            		payDAO.updateBalanceCooperatorPayByTransfer(tranResult);
		            		payDAO.updateCooperatorPayByTransfer(tranResult);
		            		dtyDAO.deleteSalesProfitByCoop(tranResult);
		            		dtyDAO.deleteProfitByCoop(tranResult);

		            		//영업사원
		            		payDAO.updateBalanceSalesPayByTransfer(tranResult);
		            		payDAO.updateSalesPayByTransfer(tranResult);
		            	}
		            }

		        }


			}
			LOGGER.debug("Transfer ..........end");

			transactionManager.commit(transactionStatus);
		}catch (Exception e) {
			e.printStackTrace();
			LOGGER.error(e.toString());
			transactionManager.rollback(transactionStatus);
		}
	}


    //http 통신을 위한 함수
    private String doznHttpRequest(String targetURL, String jsonParameters, String tranDay, String telegramNo) {
    	HttpURLConnection connection = null;
    	DoznHistoryVO doznHistoryVO = new DoznHistoryVO();

        try {
            CryptoUtil cryptoUtil = CryptoUtil.getInstance(EgovProperties.getProperty("Globals.doznKey"), EgovProperties.getProperty("Globals.doznIv"));
            LOGGER.debug("jsonParameters : "+jsonParameters);
            String encJsonParameters = cryptoUtil.encrypt(jsonParameters);
            LOGGER.debug("encJsonParameters : "+encJsonParameters);


            URL url = new URL(targetURL);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type","application/json");
            connection.setConnectTimeout(19000); // 연결 타임아웃 (15초)
            connection.setReadTimeout(19000);    // 읽기 타임아웃 (15초)
            connection.setDoOutput(true);

            DataOutputStream wr = new DataOutputStream (connection.getOutputStream());


            //거래 이력 history
            doznHistoryVO.setTranDay(tranDay);
            doznHistoryVO.setTelegramNo(telegramNo);
            doznHistoryVO.setUrl(targetURL);
            doznHistoryVO.setSendLongtxt(jsonParameters);
            payDAO.insertDoznHistory(doznHistoryVO);




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

	            //거래 이력 history
	            doznHistoryVO.setRecvLongtxt(returnStr);
	            payDAO.updateDoznHistory(doznHistoryVO);

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

	            //거래 이력 history
	            doznHistoryVO.setRecvLongtxt(response.toString());
	            payDAO.updateDoznHistory(doznHistoryVO);
	            return response.toString();
            }
        } catch (Exception e) {
            e.printStackTrace();
        	return "{\n"
	        + "    \"status\": \"999\",\n"
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
