package egovframework.com.rd.usr.service.impl;


import java.math.BigDecimal;
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
import egovframework.com.rd.usr.service.vo.BalanceVO;
import egovframework.com.rd.usr.service.vo.CooperatorPayVO;
import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.DoszDSResultVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
import egovframework.com.rd.usr.service.vo.KkoVO;
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
    /** ID Generation */
	@Resource(name="egovFitIdGnrService")
	private EgovIdGnrService egovFitIdGnrService;

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

        //0. 사용자용 select for update 로 rock
		BalanceVO forUpdateVo = new BalanceVO();
		forUpdateVo.setCooperatorId(vo.getCooperatorId());
		forUpdateVo.setMberId(EgovProperties.getProperty("Globals.cooperatorId"));
		dtyDAO.selectForUPdateBalanceByMberId(forUpdateVo);

		int sendFee = Integer.parseInt(EgovProperties.getProperty("Globals.sendFee"));
		int dayFee = 0;

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

		if("DAY".equals(vo.getSearchGubun()) ) {
			if(inputPrice+sendFee > ablePrice.getDayAblePrice() ) {
				throw new IllegalArgumentException("출금 가능 금액 초과") ;
			}
			dayFee = (int)(Math.ceil(inputPrice*ablePrice.getFeeAdminstrator()*0.01));
			vo.setDayFee( dayFee );
		} else if("WEEK".equals(vo.getSearchGubun()) ) {
			if(inputPrice+sendFee > ablePrice.getWeekAblePrice() ) {
				throw new IllegalArgumentException("출금 가능 금액 초과") ;
			}
			vo.setDayFee(0);
		}


		vo.setCopId(egovCopIdGnrService.getNextStringId());
		vo.setSendFee(sendFee);			//이체수수료
		vo.setSendPrice(inputPrice);
		vo.setTranDay(tranDay);
		vo.setTelegramNo(telegramNo);
		vo.setUseAt("Y");
		vo.setCreatId(user.getId());
		payDAO.isnertCooperatorPay(vo);


		//수익 등록(선지급)
		ProfitVO fitVo = new ProfitVO();
		if(dayFee > 0) {
			fitVo.setProfitId(egovFitIdGnrService.getNextStringId());
			fitVo.setCooperatorId(vo.getCooperatorId());//협력사
			fitVo.setMberId(user.getId());				//라이더ID
			fitVo.setGubun("D");						//선지급수수료
			fitVo.setCost(dayFee); //금액
			fitVo.setDeliveryDay(tranDay); 				//이체일
			fitVo.setCopId(vo.getCopId());				//COP_ID
			fitVo.setFeeId(ablePrice.getFeeId());		//FEE_ID
			fitVo.setCreatId(user.getId());
			dtyDAO.insertProfit(fitVo);
		}

		if("DAY".equals(vo.getSearchGubun()) ) {
			//협력사 잔액 조정
			setBalance(vo.getCooperatorId(), EgovProperties.getProperty("Globals.cooperatorId"), user.getId(), new BigDecimal((inputPrice+sendFee+dayFee)*-1), new BigDecimal(0));
		} else {
			//협력사 잔액 조정
			setBalance(vo.getCooperatorId(), EgovProperties.getProperty("Globals.cooperatorId"), user.getId(), new BigDecimal(0), new BigDecimal((inputPrice+sendFee)*-1));
		}

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

		//0. 사용자 select for update 로 rock
		vo.setCooperatorMberId(EgovProperties.getProperty("Globals.cooperatorId"));
		payDAO.selectForUPdateBalanceByTran(vo);

		// 잔액 조정
		payDAO.updateBalanceCooperatorPayByTransfer(vo);

		payDAO.updateCooperatorPayByTransfer(vo);
		dtyDAO.deleteProfitByCoop(vo);
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
	 * 운영사 수익 계산근거 조회(협력사)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectProfitFeeCoop(ProfitVO vo) throws Exception {
		return payDAO.selectProfitFeeCoop(vo);
	}
	/**
	 * 운영사 수익 계산근거 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectProfitFeeRider(ProfitVO vo) throws Exception {
		return payDAO.selectProfitFeeRider(vo);
	}
	/**
	 * 운영사 수익 계산근거
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public ProfitVO selectProfitBase(ProfitVO vo) throws Exception {
		return payDAO.selectProfitBase(vo);
	}

	/**
	 * 협력사 수익 계산근거 조회(협력사)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectCoopProfitFeeCoop(ProfitVO vo) throws Exception {
		return payDAO.selectCoopProfitFeeCoop(vo);
	}
	/**
	 * 협력사 수익 계산근거 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectCoopProfitFeeRider(ProfitVO vo) throws Exception {
		return payDAO.selectCoopProfitFeeRider(vo);
	}
	/**
	 * 협력사 수익 계산근거
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public ProfitVO selectCoopProfitBase(ProfitVO vo) throws Exception {
		return payDAO.selectCoopProfitBase(vo);
	}


	private void setBalance(String CoopId, String mberId, String mdfId, BigDecimal balance0, BigDecimal balance1) throws Exception {
		//라이더 잔액 조정
		BalanceVO mberBalance = new BalanceVO();
		mberBalance.setMberId(mberId);
		mberBalance.setCooperatorId(CoopId);
		if(dtyDAO.selectBalanceById(mberBalance) == null) {
			//insert 잔액


			if(EgovProperties.getProperty("Globals.cooperatorId").equals(mberId) ) {
				//협력사
	    		MyInfoVO ableVo = new MyInfoVO();
	    		ableVo.setSearchCooperatorId(CoopId);
	    		List<MyInfoVO> ablePriceForBal = payDAO.cooperatorAblePrice(ableVo);//리스트가 나오면 안됨.
	    		mberBalance.setBalance0(new BigDecimal(ablePriceForBal.get(0).getDayAblePrice()) );
	    		mberBalance.setBalance1(new BigDecimal(ablePriceForBal.get(0).getWeekAblePrice()) );

			} else {
				//라이더
	    		//1.출금 가능금액 내의 금액인지 확인
	    		MyInfoVO ableVo = new MyInfoVO();
	    		ableVo.setMberId(mberId);
	    		ableVo.setSearchCooperatorId(CoopId);
	    		MyInfoVO ablePriceForBal = rotService.selectAblePrice(ableVo);
	    		mberBalance.setBalance0(new BigDecimal(ablePriceForBal.getDayAblePrice()) );
	    		mberBalance.setBalance1(new BigDecimal(ablePriceForBal.getWeekAblePrice()) );
			}
    		dtyDAO.insertBalance(mberBalance);
		} else {
			//+잔액
			mberBalance.setCooperatorId(CoopId);
			mberBalance.setLastUpdusrId(mdfId);
			mberBalance.setBalance0(balance0);
			mberBalance.setBalance1(balance1);
			dtyDAO.updateBalance(mberBalance);
		}
	}


	/**
	 * 알림톡 발송 리스트 가져오기
	 * @param kkoVO
	 * @return
	 * @throws Exception
	 */
	public List<KkoVO> selectKkoList(KkoVO vo) throws Exception {
		return payDAO.selectKkoList(vo);
	}

	/**
	 * 알림톡 발송 리스트 cnt
	 * @param kkoVO
	 * @return
	 * @throws Exception
	 */
	public int selectKkoListCnt(KkoVO vo) throws Exception {
		return payDAO.selectKkoListCnt(vo);
	}
}
