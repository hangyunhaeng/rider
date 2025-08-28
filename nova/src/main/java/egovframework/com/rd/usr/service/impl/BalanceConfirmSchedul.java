package egovframework.com.rd.usr.service.impl;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.vo.BalanceVO;
import egovframework.com.rd.usr.service.vo.DoszResultVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.DoznHistoryVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;
import egovframework.com.rd.usr.service.vo.Sch;
import kr.co.dozn.secure.base.CryptoUtil;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.math.RoundingMode;
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
@Service("balanceConfirmSchedul")
public class BalanceConfirmSchedul extends EgovAbstractServiceImpl {


	@Resource(name = "PayDAO")
	private PayDAO payDAO;
	@Resource(name = "RotDAO")
	private RotDAO rotDAO;
	@Resource(name = "DtyDAO")
	private DtyDAO dtyDAO;


	private static final Logger LOGGER = LoggerFactory.getLogger(BalanceConfirmSchedul.class);


	/**
	 * Scheduler 등을 통해 호출되는 처리를 담당한다.
	 * Spring(Quartz)에서 제공하는 MethodInvokingJobDetailFactoryBean 사용으로 호출된다.
	 * 관련 설정은 context-schedule.xml 참조
	 */
	@Transactional
	public void execute() {

		try {
			LOGGER.debug("BalanceConfirm ..........start");

			//1. 잔액 검증 대상 조회
			Sch sch = new Sch();
			sch.setCooperatorMberId(EgovProperties.getProperty("Globals.cooperatorId"));
			List<BalanceVO> list = payDAO.selectBalanceConfirmTarget(sch);

			for(int i = 0 ; i < list.size() ; i++) {
				BalanceVO one = list.get(i);
				if(!EgovProperties.getProperty("Globals.cooperatorId").equals(one.getEsntlId())) {

					//라이더 실시간 잔액 조회
					MyInfoVO myInfoVO = new MyInfoVO();
					myInfoVO.setSearchCooperatorId(one.getCooperatorId());
					myInfoVO.setMberId(one.getMberId());
					MyInfoVO balanceAble = rotDAO.selectAblePrice(myInfoVO);

					//라이더 잔액 DB조회
					BalanceVO balanceTable = dtyDAO.selectBalanceById(one);

					if(balanceTable != null) {
						//라이더 잔액 검증 테이블 insert
						BalanceVO BalanceConfirm = new BalanceVO();
						BalanceConfirm.setCooperatorId(one.getCooperatorId());
//						BalanceConfirm.setMberId(one.getMberId());
						BalanceConfirm.setEsntlId(one.getEsntlId());
						BalanceConfirm.setDay(Util.getDay());
						BalanceConfirm.setBalance0(balanceTable.getBalance0());
						BalanceConfirm.setBalance1(balanceTable.getBalance1());
						BalanceConfirm.setAbleBalance0(balanceAble.getBalanceDayAblePrice() );
						BalanceConfirm.setAbleBalance1(balanceAble.getBalanceWeekAblePrice() );
						payDAO.insertBalanceConfirm(BalanceConfirm);
					}

				} else {

					//협력사 실시간 잔액 조회
					MyInfoVO myInfoVO = new MyInfoVO();
					myInfoVO.setSearchCooperatorId(one.getCooperatorId());
					MyInfoVO balanceAble = payDAO.cooperatorAblePriceByCoopId(myInfoVO);

					//협력사 잔액 DB조회
					BalanceVO balanceTable = dtyDAO.selectBalanceById(one);
					BalanceVO balanceCoopr = dtyDAO.selectBalanceByCooprator(one);

					//협력사 잔액 검증 테이블 insert
					if(balanceTable != null) {
						BigDecimal b0 = balanceTable.getBalance0().subtract(new BigDecimal(balanceCoopr.getCost())).subtract(
								balanceTable.getBalance0().multiply(new BigDecimal(balanceCoopr.getFeeAdminstrator())).divide(new BigDecimal(100), 0, RoundingMode.UP)
						);
						BalanceVO BalanceConfirm = new BalanceVO();
						BalanceConfirm.setCooperatorId(one.getCooperatorId());
//						BalanceConfirm.setMberId(one.getMberId());
						BalanceConfirm.setEsntlId(one.getEsntlId());
						BalanceConfirm.setDay(Util.getDay());
						BalanceConfirm.setBalance0(b0);
						BalanceConfirm.setBalance1(balanceTable.getBalance1());
						BalanceConfirm.setAbleBalance0( new BigDecimal(balanceAble.getDayAblePrice()) );
						BalanceConfirm.setAbleBalance1( new BigDecimal(balanceAble.getWeekAblePrice()) );
						payDAO.insertBalanceConfirm(BalanceConfirm);
					}
				}
			}

			LOGGER.debug("BalanceConfirm ..........end");
		}catch (Exception e) {
			e.printStackTrace();
			LOGGER.error(e.toString());
		}
	}


}
