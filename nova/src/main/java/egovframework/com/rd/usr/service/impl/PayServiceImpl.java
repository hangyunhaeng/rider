package egovframework.com.rd.usr.service.impl;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.PayService;
import egovframework.com.rd.usr.service.RotService;
import egovframework.com.rd.usr.service.vo.CooperatorPayVO;
import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.DoszDSResultVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;
import egovframework.com.rd.usr.service.vo.ProfitVO;

/**
 * @Class Name : DtyServiceImpl.java
 * @Description :
 * @Modification
 *
 *    수정일       수정자         수정내용
 *    -------        -------     -------------------
 *
 *
 * @author
 * @since
 * @version
 * @see
 *
 */
@Service("PayService")
public class PayServiceImpl extends EgovAbstractServiceImpl implements PayService {


	@Resource(name = "PayDAO")
	private PayDAO payDAO;
	@Resource(name = "DtyDAO")
	private DtyDAO dtyDAO;
	@Resource(name = "RotService")
	private RotService rotService;




    /** ID Generation */
	@Resource(name="egovCopIdGnrService")
	private EgovIdGnrService egovCopIdGnrService;

	private static final Logger LOGGER = LoggerFactory.getLogger(PayServiceImpl.class);


	/**
	 * 입출금내역 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<HistoryVO> selectPayList(HistoryVO vo) throws Exception {
		return payDAO.selectPayList(vo);
	}

	/**
	 * 대사 이력 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DoszDSResultVO> selectDoznDs(DoszDSResultVO vo) throws Exception {
		return payDAO.selectDoznDs(vo);
	}


	/**
	 * 운영사 수익 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<ProfitVO> selectProfitList(ProfitVO vo) throws Exception {
		return payDAO.selectProfitList(vo);
	}

	/**
	 * 협력사 수익 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<ProfitVO> selectCooperatorProfitList(ProfitVO vo) throws Exception {
		return payDAO.selectCooperatorProfitList(vo);
	}
	/**
	 * 협력사 출금 가능
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> cooperatorAblePrice(MyInfoVO vo) throws Exception {

		List<MyInfoVO> result = payDAO.cooperatorAblePrice(vo);
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("resultList", result);
    	return map;
	}


	/**
	 * 협력사 출금 실행
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DoszTransferVO cooperatorPay(CooperatorPayVO vo) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		int sendFee = Integer.parseInt(EgovProperties.getProperty("Globals.sendFee"));

		int inputPrice = vo.getInputPrice();		//사용자가 입력한 출금 요청 금액
		String tranDay = Util.getDay();
		String telegramNo = dtyDAO.selectTelegranNo();

		//1.출금 가능금액 내의 금액인지 확인
		MyInfoVO myInfoVO = new MyInfoVO();
		myInfoVO.setMberId(user.getId());
		myInfoVO.setSearchCooperatorId(vo.getCooperatorId());
		myInfoVO.setSchUserSe(user.getUserSe());
		myInfoVO.setSchIhidNum(user.getIhidNum());
		myInfoVO.setSchAuthorCode(user.getAuthorCode());
		MyInfoVO ablePrice = payDAO.cooperatorAblePriceByCoopId(myInfoVO);

		if(inputPrice+sendFee > ablePrice.getCoopAblePrice() ) {
			throw new IllegalArgumentException("출금 가능 금액 초과") ;
		}

		vo.setCopId(egovCopIdGnrService.getNextStringId());
		vo.setSendFee(sendFee);			//이체수수료
		vo.setSendPrice(inputPrice);
		vo.setTranDay(tranDay);
		vo.setTelegramNo(telegramNo);
		vo.setUseAt("Y");
		vo.setCreatId(user.getId());
		payDAO.isnertCooperatorPay(vo);



		MyInfoVO bankInfo = rotService.selectMyInfo(myInfoVO);
		DoszTransferVO doszTransferVO = new DoszTransferVO();
		doszTransferVO.setTranDay(tranDay);
		doszTransferVO.setTelegram_no(telegramNo);
		doszTransferVO.setDrw_account_cntn(bankInfo.getAccountNm());		//출금계좌적요
		doszTransferVO.setRv_bank_code(bankInfo.getBnkCd());				//입금은행 코드
		doszTransferVO.setRv_account(bankInfo.getAccountNum());				//입금은행 계좌
		doszTransferVO.setRv_account_cntn("주식회사 다온플랜");					//입금은행 적요
		doszTransferVO.setAmount(Integer.toString(vo.getSendPrice()));
		doszTransferVO.setRes_all_yn("y");
		doszTransferVO.setCreatId(user.getId());
		dtyDAO.insertTransfer(doszTransferVO);

		return doszTransferVO;
	}
	/**
	 * 출금 실행된 협력사 출금건 use_at n로 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public void updateCooperatorPayByTransfer(DoszTransferVO vo) throws Exception {
		payDAO.updateCooperatorPayByTransfer(vo);
	}

	/**
	 * 협력사별 출금 가능금액 one
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO cooperatorAblePriceByCoopId(MyInfoVO vo) throws Exception {
		return payDAO.cooperatorAblePriceByCoopId(vo);
	}

	/**
	 * 협력사 출금 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectCooperatorPayList(CooperatorPayVO vo) throws Exception {
		return payDAO.selectCooperatorPayList(vo);
	}

	/**
	 * 협력사 수익 계산근거 조회(협력사)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectProfitFeeCoop(ProfitVO vo) throws Exception {
		return payDAO.selectProfitFeeCoop(vo);
	}
	/**
	 * 협력사 수익 계산근거 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectProfitFeeRider(ProfitVO vo) throws Exception {
		return payDAO.selectProfitFeeRider(vo);
	}
	/**
	 * 협력사 수익 계산근거
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public ProfitVO selectProfitBase(ProfitVO vo) throws Exception {
		return payDAO.selectProfitBase(vo);
	}
}
