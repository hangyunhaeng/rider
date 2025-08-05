package egovframework.com.rd.usr.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.rd.usr.service.vo.BalanceVO;
import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.DeliveryErrorVO;
import egovframework.com.rd.usr.service.vo.DeliveryInfoVO;
import egovframework.com.rd.usr.service.vo.DoszSchAccoutVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.EtcVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
import egovframework.com.rd.usr.service.vo.ProfitVO;
import egovframework.com.rd.usr.service.vo.SearchKeyVO;
import egovframework.com.rd.usr.service.vo.UploadStateVO;
import egovframework.com.rd.usr.service.vo.WeekInfoVO;
import egovframework.com.rd.usr.service.vo.WeekPayVO;
import egovframework.com.rd.usr.service.vo.WeekRiderInfoVO;
import egovframework.com.uat.uia.web.EgoRDLoginController;


/**
 * @Class Name : DelivertyInfoDao.java
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
@Repository("DtyDAO")
public class DtyDAO extends EgovComAbstractDAO {


	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgoRDLoginController.class);

	/**
	 * 배달 처리비 insert
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertDeliveryInfo(DeliveryInfoVO vo) throws Exception {
		return insert("dtyDAO.insertDeliveryInfo", vo);
	}

	public List<DeliveryInfoVO> selectDeliveryInfoByAtchFileId(DeliveryInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectDeliveryInfoByAtchFileId", vo);
	}

	public List<DeliveryInfoVO> selectDeliveryInfoByParam(DeliveryInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectDeliveryInfoByParam", vo);
	}

	/**
	 * 확정일자 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateFixDay(DayPayVO vo) throws Exception {
		return update("dtyDAO.updateFixDay", vo);
	}
	/**
	 * 확정일자 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateFixWeek(WeekInfoVO vo) throws Exception {
		return update("dtyDAO.updateFixWeek", vo);
	}

	/**
	 * 확정일자 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateFixWeekInfo(WeekInfoVO vo) throws Exception {
		return update("dtyDAO.updateFixWeekInfo", vo);
	}
	/**
	 * 오류건 insert
	 */
	public int insertDeliveryError(DeliveryErrorVO vo) throws Exception {
		return insert("dtyDAO.insertDeliveryError", vo);
	}

	/**
	 * 오류건 조회
	 */
	public List<DeliveryErrorVO> selectDeliveryErrorByAtchFileId(DeliveryInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectDeliveryErrorByAtchFileId", vo);
	}
	/**
	 * 협력사 전체 정산 확인 데이터 insert
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertWeekInfo(WeekInfoVO vo) throws Exception {
		return insert("dtyDAO.insertWeekInfo", vo);
	}
	/**
	 * 라이더별 전체 정산 확인 데이터 insert
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertWeekRiderInfo(WeekRiderInfoVO vo) throws Exception {
		return insert("dtyDAO.insertWeekRiderInfo", vo);
	}

	public List<WeekInfoVO> selectWeekInfoByAtchFileId(WeekInfoVO vo)  throws Exception {
		return selectList("dtyDAO.selectWeekInfoByAtchFileId", vo);
	}

	public List<WeekRiderInfoVO> selectWeekRiderInfoByAtchFileId(WeekInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectWeekRiderInfoByAtchFileId", vo);
	}

	public List<WeekInfoVO> selectWeekInfoByParam(WeekInfoVO vo)  throws Exception {
		return selectList("dtyDAO.selectWeekInfoByParam", vo);
	}

	public List<WeekRiderInfoVO> selectWeekRiderInfoByParam(WeekInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectWeekRiderInfoByParam", vo);
	}
	/**
	 *  파일 업로드 현황 조회 / 주정산 파일
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<UploadStateVO> selectUploadStateInWeek(WeekInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectUploadStateInWeek", vo);
	}
	/**
	 *  파일 업로드 현황 조회 / 일정산 파일
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<UploadStateVO> selectUploadStateInDay(WeekInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectUploadStateInDay", vo);
	}

	/**
	 * 협력사 리스트 가져오기 (selectBox용도)
	 * @return
	 * @throws Exception
	 */
	public List<SearchKeyVO> selectCooperatorList(WeekInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectCooperatorList", vo);
	}
	/**
	 * 주정산 가능금액 계산
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<WeekPayVO> selectWeekPay(WeekInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectWeekPay", vo);
	}
	/**
	 * 주정산 가능금액 계산
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<WeekPayVO> selectPixWeek(WeekInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectPixWeek", vo);
	}

	/**
	 * 주정산 확정시 입출금 잔액을 기록하기 위한 select for update
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<BalanceVO> selectForUPdateBalanceWeekByParam(BalanceVO vo) throws Exception {
		return selectList("dtyDAO.selectForUPdateBalanceWeekByParam", vo);
	}

	/**
	 * 주정산 입출금 insert
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertWeekPay(WeekPayVO vo) throws Exception {
		return insert("dtyDAO.insertWeekPay", vo);
	}
	/**
	 * 일정산 입금내역 수수료 계산 후 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DayPayVO> selectDayPay(DayPayVO vo)throws Exception {
		return selectList("dtyDAO.selectDayPay", vo);
	}
	/**
	 * 일정산 입금내역 수수료 계산 후 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DayPayVO> selectFixDay(DayPayVO vo)throws Exception {
		return selectList("dtyDAO.selectFixDay", vo);
	}
	/**
	 * 일정산 입금내역 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertDayPay(DayPayVO vo)throws Exception {
		return insert("dtyDAO.insertDayPay", vo);
	}
	/**
	 * 주정산 파일이 정산시작일 정산종료일 중복 여부
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public boolean getAbleDateWeek(WeekInfoVO vo)throws Exception {
		return selectOne("dtyDAO.getAbleDateWeek", vo);
	}
	/**
	 * 라이더의 배달정보 조회(일별 입금 이력을 조회한다)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DayPayVO> selectRiderDayPayList(DayPayVO vo)throws Exception {
		return selectList("dtyDAO.selectRiderDayPayList", vo);
	}
	/**
	 * 일정산 입금이력을 정산완료로 정정
	 * 협력사아이디, 기간
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateDayPayWeekConfirm(WeekInfoVO vo)throws Exception {
		return update("dtyDAO.updateDayPayWeekConfirm", vo);
	}
	/**
	 * 일정산 입금이력을 정산완료로 정정
	 * 협력사아이디, 기간
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateFixDayPayWeekConfirm(WeekInfoVO vo)throws Exception {
		return update("dtyDAO.updateFixDayPayWeekConfirm", vo);
	}
	/**
	 * 일정산 입금이력을 정산완료로 정정시 라이더 잔액 조정
	 * 협력사아이디, 기간
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateFixDayBalance(WeekInfoVO vo)throws Exception {
		return update("dtyDAO.updateFixDayBalance", vo);
	}
	/**
	 * 일정산 출금이력을 정산완료로 정정
	 * 협력사아이디
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateDayPayWeekConfirm2(WeekInfoVO vo)throws Exception {
		return update("dtyDAO.updateDayPayWeekConfirm2", vo);
	}
	/**
	 * 일정산 출금이력을 정산완료로 정정
	 * 협력사아이디
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateFixDayPayWeekConfirm2(WeekInfoVO vo)throws Exception {
		return update("dtyDAO.updateFixDayPayWeekConfirm2", vo);
	}

	/**
	 * 일정산 출금이력을 정산완료로 정정시 라이더 잔액 조정
	 * 협력사아이디
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateFixDayBalance2(WeekInfoVO vo)throws Exception {
		return update("dtyDAO.updateFixDayBalance2", vo);
	}
	/**
	 * 미정산 선출금 출금이력조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<WeekPayVO> selectDayPayIoGubn2List(WeekInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectDayPayIoGubn2List", vo);
	}
	/**
	 * 미정산 선출금 출금이력조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<WeekPayVO> selectFixDayPayIoGubn2List(WeekInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectFixDayPayIoGubn2List", vo);
	}
	/**
	 * 이체 테이블 insert
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertTransfer(DoszTransferVO vo)throws Exception {
		return insert("dtyDAO.insertTransfer", vo);
	}
	/**
	 * dozn 거래고유번호 조회
	 * @return
	 * @throws Exception
	 */
	public String selectTelegranNo() throws Exception {
		return selectOne("dtyDAO.selectTelegranNo");
	}

	/**
	 * 이체 결과 업데이트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateTransfer(DoszTransferVO vo)throws Exception {
		return update("dtyDAO.updateTransfer", vo);
	}
	/**
	 * 선출금 성공시 협력사 잔액을 기록하기 위한 select for update
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public BalanceVO selectForUpdateBalanceDayTran(DoszTransferVO vo)throws Exception {
		return selectOne("dtyDAO.selectForUpdateBalanceDayTran", vo);
	}
	/**
	 * 선출금 성공시 협력사 잔액 +
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateBalanceDayTran(DoszTransferVO vo)throws Exception {
		return update("dtyDAO.updateBalanceDayTran", vo);
	}

	/**
	 * 예금주 조회 insert
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertSchAccout(DoszSchAccoutVO vo)throws Exception {
		return insert("dtyDAO.insertSchAccout", vo);
	}
	/**
	 * 예금주 조회 결과 업데이트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateSchAccout(DoszSchAccoutVO vo)throws Exception {
		return update("dtyDAO.updateSchAccout", vo);
	}
	/**
	 * 출금 내역 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<HistoryVO> selectHistory(HistoryVO vo)throws Exception {
		return selectList("dtyDAO.selectHistory", vo);
	}

	/**
	 * 출금 가능 내역 조회 (by mberId)
	 * @param mberId
	 * @return
	 * @throws Exception
	 */
	public List<DeliveryInfoVO> selectTakeDeliveryInfoListByMberId(DeliveryInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectTakeDeliveryInfoListByMberId", vo);
	}
	/**
	 * 출금 실행된 일정산 입출금 출금건 use_at n로 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateDayPayByTransfer(DoszTransferVO vo) throws Exception {
		return update("dtyDAO.updateDayPayByTransfer", vo);
	}
	/**
	 * 출금 실행된 주정산 입출금 출금건 use_at n로 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateWeekPayByTransfer(DoszTransferVO vo) throws Exception {
		return update("dtyDAO.updateWeekPayByTransfer", vo);
	}

	/**
	 * 확정금액 이체실패시 입출금 잔액을 기록하기 위한 select for update
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public BalanceVO selectForUPdateBalanceByWeekTran(DoszTransferVO vo) throws Exception {
		return selectOne("dtyDAO.selectForUPdateBalanceByWeekTran", vo);
	}

	/**
	 * 선정산 이체실패시 입출금 잔액을 기록하기 위한 select for update
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public BalanceVO selectForUPdateBalanceByDayTran(DoszTransferVO vo) throws Exception {
		return selectOne("dtyDAO.selectForUPdateBalanceByDayTran", vo);
	}
	/**
	 * 확정금액 이체 실패시 잔액 조정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateBalanceWeekPayByTransfer(DoszTransferVO vo) throws Exception {
		return update("dtyDAO.updateBalanceWeekPayByTransfer", vo);
	}

	/**
	 * 선정산 이체실패시 잔액 조정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateBalanceDayPayByTransfer(DoszTransferVO vo) throws Exception {
		return update("dtyDAO.updateBalanceDayPayByTransfer", vo);
	}

	/**
	 * 대출 입금 대상 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<EtcVO> selectEtcList(DayPayVO vo) throws Exception {
		return selectList("dtyDAO.selectEtcList", vo);
	}
	/**
	 * 대출 총액이 모두 입금 되면 대출 종료 처리
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int finishEtc(EtcVO vo) throws Exception {
		return update("dtyDAO.finishEtc", vo);
	}
	/**
	 * 수익 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertProfit(ProfitVO vo) throws Exception {
		return insert("dtyDAO.insertProfit", vo);
	}

	/**
	 * 협력사 수익 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertCooperatorProfit(ProfitVO vo) throws Exception {
		return update("dtyDAO.insertCooperatorProfit", vo);
	}

	/**
	 * 라이더 입금 실패서 선지급 수수료 삭제(운영사)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int deleteProfit(DoszTransferVO vo) throws Exception {
		return update("dtyDAO.deleteProfit", vo);
	}
	/**
	 * 라이더 입금 실패서 선지급 수수료 삭제(협력사)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int deleteCooperatorProfit(DoszTransferVO vo) throws Exception {
		return update("dtyDAO.deleteCooperatorProfit", vo);
	}
	/**
	 * 확정시 입출금 잔액을 기록하기 위한 select for update
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<BalanceVO> selectForUPdateBalanceByParam(BalanceVO vo) throws Exception {
		return selectList("dtyDAO.selectForUPdateBalanceByParam", vo);
	}
	/**
	 * 확정시 입출금 잔액을 기록하기 위한 select for update
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<BalanceVO> selectForUPdateBalanceByMberId(BalanceVO vo) throws Exception {
		return selectList("dtyDAO.selectForUPdateBalanceByMberId", vo);
	}
	/**
	 * 특정 대상 잔액 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public BalanceVO selectBalanceById(BalanceVO vo) throws Exception {
		return selectOne("dtyDAO.selectBalanceById", vo);
	}
	/**
	 * 잔액 생성
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertBalance(BalanceVO vo) throws Exception {
		return insert("dtyDAO.insertBalance", vo);
	}
	/**
	 * 잔액 보정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateBalance(BalanceVO vo) throws Exception {
		return update("dtyDAO.updateBalance", vo);
	}
	/**
	 * 엑셀 파일 업로드 에러메세지
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateFileUploadErrMsg(FileVO vo) throws Exception {
		return update("dtyDAO.updateFileUploadErrMsg", vo);
	}
	/**
	 * 주정산 파일 삭제
	 * @param weekInfoVO
	 * @return
	 * @throws Exception
	 */
	public int deleteAtchFile(WeekInfoVO weekInfoVO) throws Exception {
		return update("dtyDAO.deleteAtchFile", weekInfoVO);
	}
	/**
	 * 확정된 주정산 조회(by file)
	 * @param weekInfoVO
	 * @return
	 * @throws Exception
	 */
	public WeekInfoVO selectFixWeekInfo(WeekInfoVO weekInfoVO) throws Exception {
		return selectOne("dtyDAO.selectFixWeekInfo", weekInfoVO);
	}

	/**
	 * 확정된 일정산 조회(by file)
	 * @param weekInfoVO
	 * @return
	 * @throws Exception
	 */
	public WeekInfoVO selectFixDeleveryInfo(WeekInfoVO weekInfoVO) throws Exception {
		return selectOne("dtyDAO.selectFixDeleveryInfo", weekInfoVO);
	}
	/**
	 * 일정산 파일 삭제
	 * @param weekInfoVO
	 * @return
	 * @throws Exception
	 */
	public int deleteDayAtchFile(WeekInfoVO weekInfoVO) throws Exception {
		return update("dtyDAO.deleteDayAtchFile", weekInfoVO);
	}

	public int deleteDeliveryInfo(WeekInfoVO weekInfoVO) throws Exception {
		return delete("dtyDAO.deleteDeliveryInfo", weekInfoVO);
	}
}

