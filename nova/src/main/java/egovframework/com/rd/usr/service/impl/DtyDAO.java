package egovframework.com.rd.usr.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.DeliveryErrorVO;
import egovframework.com.rd.usr.service.vo.DeliveryInfoVO;
import egovframework.com.rd.usr.service.vo.DoszSchAccoutVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
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
	 * 미정산 선출금 출금이력조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<WeekPayVO> selectDayPayIoGubn2List(WeekInfoVO vo) throws Exception {
		return selectList("dtyDAO.selectDayPayIoGubn2List", vo);
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

}

