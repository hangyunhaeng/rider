package egovframework.com.rd.usr.service;

import java.util.List;
import java.util.Map;

import egovframework.com.rd.usr.service.vo.CooperatorPayVO;
import egovframework.com.rd.usr.service.vo.DoszDSResultVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
import egovframework.com.rd.usr.service.vo.KkoVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;
import egovframework.com.rd.usr.service.vo.ProfitVO;
import egovframework.com.rd.usr.service.vo.WeekPayVO;
import egovframework.com.rd.usr.service.vo.WeekRiderInfoVO;

public interface PayService {

	/**
	 * 입출금내역 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<HistoryVO> selectPayList(HistoryVO vo) throws Exception ;

	/**
	 * 대사 이력 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DoszDSResultVO> selectDoznDs(DoszDSResultVO vo) throws Exception;

	/**
	 * 운영사 수익 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<ProfitVO> selectProfitList(ProfitVO vo) throws Exception ;
	/**
	 * 협력사 수익 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<ProfitVO> selectCooperatorProfitList(ProfitVO vo) throws Exception ;
	/**
	 * 영업사원 수익 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<ProfitVO> selectSalesProfitList(ProfitVO vo) throws Exception ;
	/**
	 * 협력사 출금 가능
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> cooperatorAblePrice(MyInfoVO vo) throws Exception ;
	/**
	 * 영업사원 출금 가능
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> salesAblePrice(MyInfoVO vo) throws Exception ;
	/**
	 * 영업사원 출금 가능
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO salesAblePriceOne(MyInfoVO vo) throws Exception ;
	/**
	 * 협력사 출금 실행
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DoszTransferVO cooperatorPay(CooperatorPayVO vo) throws Exception ;
	/**
	 * 영업사원 출금 실행
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DoszTransferVO salesPay(CooperatorPayVO vo) throws Exception ;
	/**
	 * 출금 실행된 협력사 출금건 use_at n로 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public void updateCooperatorPayByTransfer(DoszTransferVO vo) throws Exception ;
	/**
	 * 출금 실행된 영업사원 출금건 use_at n로 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public void updateSalesPayByTransfer(DoszTransferVO vo) throws Exception ;

	/**
	 * 협력사별 출금 가능금액 one
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO cooperatorAblePriceByCoopId(MyInfoVO vo) throws Exception ;

	/**
	 * 협력사 출금 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectCooperatorPayList(CooperatorPayVO vo) throws Exception ;

	/**
	 * 영업사원 출금 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectSalesPayList(CooperatorPayVO vo) throws Exception ;


	/**
	 * 운영사 수익 계산근거 조회(협력사)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectProfitFeeCoop(ProfitVO vo) throws Exception ;
	/**
	 * 운영사 수익 계산근거 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectProfitFeeRider(ProfitVO vo) throws Exception;
	/**
	 * 운영사 수익 계산근거
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public ProfitVO selectProfitBase(ProfitVO vo) throws Exception;

	/**
	 * 협력사 수익 계산근거 조회(협력사)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectCoopProfitFeeCoop(ProfitVO vo) throws Exception ;
	/**
	 * 협력사 수익 계산근거 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectCoopProfitFeeRider(ProfitVO vo) throws Exception ;
	/**
	 * 협력사 수익 계산근거
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public ProfitVO selectCoopProfitBase(ProfitVO vo) throws Exception ;


	/**
	 * 영업사원 수익 계산근거 조회(영업사원)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectSalesProfitFeeCoop(ProfitVO vo) throws Exception ;
	/**
	 * 영업사원 수익 계산근거 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectSalesProfitFeeRider(ProfitVO vo) throws Exception ;
	/**
	 * 영업사원 수익 계산근거
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public ProfitVO selectSalesProfitBase(ProfitVO vo) throws Exception ;
	/**
	 * 알림톡 발송 리스트 가져오기
	 * @param kkoVO
	 * @return
	 * @throws Exception
	 */
	public List<KkoVO> selectKkoList(KkoVO vo) throws Exception ;

	/**
	 * 알림톡 발송 리스트 cnt
	 * @param kkoVO
	 * @return
	 * @throws Exception
	 */
	public int selectKkoListCnt(KkoVO vo) throws Exception ;
	/**
	 * 확정 정보 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<WeekRiderInfoVO> selectWeekPayByMberId(WeekPayVO vo) throws Exception ;
}
