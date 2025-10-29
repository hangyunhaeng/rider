package egovframework.com.rd.usr.service.impl;


import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.rd.usr.service.vo.BalanceVO;
import egovframework.com.rd.usr.service.vo.CooperatorPayVO;
import egovframework.com.rd.usr.service.vo.DoszDSResultVO;
import egovframework.com.rd.usr.service.vo.DoszResultVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.DoznHistoryVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
import egovframework.com.rd.usr.service.vo.KkoVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;
import egovframework.com.rd.usr.service.vo.ProfitVO;
import egovframework.com.rd.usr.service.vo.Sch;
import egovframework.com.rd.usr.service.vo.WeekPayVO;
import egovframework.com.rd.usr.service.vo.WeekRiderInfoVO;
import egovframework.com.uat.uia.web.EgoRDLoginController;


/**
 * @Class Name :
 * @Description :
 * @Modification Information
 *
 *    수정일       수정자         수정내용
 *    -------        -------     -------------------
 *
 * @author
 * @since
 * @version
 * @see
 *
 */
@Repository("PayDAO")
public class PayDAO extends EgovComAbstractDAO {


	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgoRDLoginController.class);

	/**
	 * 공지사항 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<HistoryVO> selectPayList(HistoryVO vo) throws Exception {
		return selectList("payDAO.selectPayList", vo);
	}

	/**
	 * 이체처리결과 조회 대상 조회
	 * @return
	 * @throws Exception
	 */
	public List<DoszResultVO> selectTransterProsseceResult() throws Exception {
		return selectList("payDAO.selectTransterProsseceResult");
	}

	/**
	 * 이체처리결과 조회 대상 잔액을 기록하기 위한 select for update
	 * @return
	 * @throws Exception
	 */
	public List<BalanceVO> selectForUpdateBalanceTranster(Sch vo) throws Exception {
		return selectList("payDAO.selectForUpdateBalanceTranster", vo);
	}

	/**
	 * 이체처리결과 update
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateTransterProsseceResult(DoszResultVO vo) throws Exception {
		return update("payDAO.updateTransterProsseceResult", vo);
	}
	/**
	 * DOZN 거래이력 insert
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertDoznHistory(DoznHistoryVO vo)  throws Exception {
		return insert("payDAO.insertDoznHistory", vo);
	}
	public int updateDoznHistory(DoznHistoryVO vo)  throws Exception {
		return update("payDAO.updateDoznHistory", vo);
	}
	/**
	 * 24. [중계, 재판매] 더즌 내부 거래집계  isnert
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertDoznDs(DoszDSResultVO vo)  throws Exception {
		return insert("payDAO.insertDoznDs", vo);
	}

	/**
	 * 다온플랜 거래집계 udpate
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateDoznDs(DoszDSResultVO vo)  throws Exception {
		return update("payDAO.updateDoznDs", vo);
	}
	/**
	 * 대사 이력 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DoszDSResultVO> selectDoznDs(DoszDSResultVO vo) throws Exception {
		return selectList("payDAO.selectDoznDs", vo);
	}
	/**
	 * 운영사 수익 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<ProfitVO> selectProfitList(ProfitVO vo) throws Exception {
		return selectList("payDAO.selectProfitList", vo);
	}
	/**
	 * 협력사 수익 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<ProfitVO> selectCooperatorProfitList(ProfitVO vo) throws Exception {
		return selectList("payDAO.selectCooperatorProfitList", vo);
	}
	/**
	 * 영업사원 수익 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<ProfitVO> selectSalesProfitList(ProfitVO vo) throws Exception {
		return selectList("payDAO.selectSalesProfitList", vo);
	}
	/**
	 * 협력사별 출금 가능금액 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<MyInfoVO> cooperatorAblePrice(MyInfoVO vo) throws Exception {
		return selectList("payDAO.cooperatorAblePrice", vo);
	}
	/**
	 * 영업사원 출금 가능금액
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO salesAblePrice(MyInfoVO vo) throws Exception {
		return selectOne("payDAO.salesAblePrice", vo);
	}

	/**
	 * 협력사별 출금 가능금액 one
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO cooperatorAblePriceByCoopId(MyInfoVO vo) throws Exception {
		return selectOne("payDAO.cooperatorAblePrice", vo);
	}
	/**
	 * 협력사 출금 이력생성
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int isnertCooperatorPay(CooperatorPayVO vo) throws Exception {
		return insert("payDAO.isnertCooperatorPay", vo);
	}
	/**
	 * 영업사원 출금 이력생성
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int isnertSalesPay(CooperatorPayVO vo) throws Exception {
		return insert("payDAO.isnertSalesPay", vo);
	}

	/**
	 * 출금 실행된 협력사 출금건 use_at n로 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateCooperatorPayByTransfer(DoszTransferVO vo) throws Exception {
		return update("payDAO.updateCooperatorPayByTransfer", vo);
	}

	/**
	 * 출금 실행된 영업사원 출금건 use_at n로 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateSalesPayByTransfer(DoszTransferVO vo) throws Exception {
		return update("payDAO.updateSalesPayByTransfer", vo);
	}
	/**
	 * 협력사 거래 성공 실패시 잔액을 기록하기 위한 select for update
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public BalanceVO selectForUPdateBalanceByTran(DoszTransferVO vo) throws Exception {
		return selectOne("payDAO.selectForUPdateBalanceByTran", vo);
	}
	/**
	 * 영업사원 거래 성공 실패시 잔액을 기록하기 위한 select for update
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public BalanceVO selectForUPdateSalesBalanceByTran(DoszTransferVO vo) throws Exception {
		return selectOne("payDAO.selectForUPdateSalesBalanceByTran", vo);
	}


	/**
	 * 협력사 잔액 보정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateBalanceCooperatorPayByTransfer(DoszTransferVO vo) throws Exception {
		return update("payDAO.updateBalanceCooperatorPayByTransfer", vo);
	}

	/**
	 * 영업사원 잔액 보정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateBalanceSalesPayByTransfer(DoszTransferVO vo) throws Exception {
		return update("payDAO.updateBalanceSalesPayByTransfer", vo);
	}
	/**
	 * 협력사 출금 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectCooperatorPayList(CooperatorPayVO vo) throws Exception {
		return selectList("payDAO.selectCooperatorPayList", vo);
	}

	/**
	 * 영업사원 출금 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectSalesPayList(CooperatorPayVO vo) throws Exception  {
		return selectList("payDAO.selectSalesPayList", vo);
	}

	/**
	 * 운영사 수익 계산근거 조회(협력사)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectProfitFeeCoop(ProfitVO vo) throws Exception {
		return selectList("payDAO.selectProfitFeeCoop", vo);
	}
	/**
	 * 운영사 수익 계산근거 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectProfitFeeRider(ProfitVO vo) throws Exception {
		return selectList("payDAO.selectProfitFeeRider", vo);
	}
	/**
	 * 운영사 수익 계산근거
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public ProfitVO selectProfitBase(ProfitVO vo) throws Exception {
		return selectOne("payDAO.selectProfitBase", vo);
	}
	/**
	 * 협력사 수익 계산근거 조회(협력사)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectCoopProfitFeeCoop(ProfitVO vo) throws Exception {
		return selectList("payDAO.selectCoopProfitFeeCoop", vo);
	}
	/**
	 * 협력사 수익 계산근거 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectCoopProfitFeeRider(ProfitVO vo) throws Exception {
		return selectList("payDAO.selectCoopProfitFeeRider", vo);
	}
	/**
	 * 협력사 수익 계산근거
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public ProfitVO selectCoopProfitBase(ProfitVO vo) throws Exception {
		return selectOne("payDAO.selectCoopProfitBase", vo);
	}

	/**
	 * 영업사원 수익 계산근거 조회(영업사원)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectSalesProfitFeeCoop(ProfitVO vo) throws Exception {
		return selectList("payDAO.selectSalesProfitFeeCoop", vo);
	}
	/**
	 * 영업사원 수익 계산근거 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorPayVO> selectSalesProfitFeeRider(ProfitVO vo) throws Exception {
		return selectList("payDAO.selectSalesProfitFeeRider", vo);
	}
	/**
	 * 영업사원 수익 계산근거
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public ProfitVO selectSalesProfitBase(ProfitVO vo) throws Exception {
		return selectOne("payDAO.selectSalesProfitBase", vo);
	}
	/**
	 * 카톡 발송 이력 insert
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertKko(KkoVO vo) throws Exception {
		return insert("payDAO.insertKko", vo);
	}

	/**
	 * 카톡 수신 이력 udpate
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateKko(KkoVO vo) throws Exception {
		return update("payDAO.updateKko", vo);
	}

	/**
	 * 카톡 수신 이력 실패 udpate
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateFailKko(KkoVO vo) throws Exception {
		return update("payDAO.updateFailKko", vo);
	}

	/**
	 * 카톡 수신 사용자별 이력 udpate
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateKkoUsr(KkoVO vo) throws Exception {
		return update("payDAO.updateKkoUsr", vo);
	}
	/**
	 * 카톡 발송 확인 대상
	 * @return
	 * @throws Exception
	 */
	public List<KkoVO> selectKkoProsseceResult() throws Exception {
		return selectList("payDAO.selectKkoProsseceResult");
	}
	/**
	 * 카톡 발송 확인 후 업데이트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateKkoReport(KkoVO vo) throws Exception {
		return update("payDAO.updateKkoReport", vo);
	}

	/**
	 * 알림톡 발송 리스트 가져오기
	 * @param kkoVO
	 * @return
	 * @throws Exception
	 */
	public List<KkoVO> selectKkoList(KkoVO vo) throws Exception {
		return selectList("payDAO.selectKkoList", vo);
	}

	/**
	 * 알림톡 발송 리스트 cnt
	 * @param kkoVO
	 * @return
	 * @throws Exception
	 */
	public int selectKkoListCnt(KkoVO vo) throws Exception {
		KkoVO reVo = selectOne("payDAO.selectKkoListCnt", vo);
		return reVo.getTotalCnt();
	}
	/**
	 * 잔액 체크 할 대상 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<BalanceVO> selectBalanceConfirmTarget(Sch vo) throws Exception {
		return selectList("payDAO.selectBalanceConfirmTarget", vo);
	}
	public int insertBalanceConfirm(BalanceVO vo) throws Exception {
		return insert("payDAO.insertBalanceConfirm", vo);
	}

	/**
	 * 확정 정보 조회
	 * @param kkoVO
	 * @return
	 * @throws Exception
	 */
	public List<WeekRiderInfoVO> selectWeekPayByMberId(WeekPayVO vo) throws Exception {
		return selectList("payDAO.selectWeekPayByMberId", vo);
	}

	/**
	 * 모든 출금 내역 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<HistoryVO> selectAllPayList(HistoryVO vo) throws Exception {
		return selectList("payDAO.selectAllPayList", vo);
	}
}


