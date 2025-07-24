package egovframework.com.rd.usr.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.LoginVO;
import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.DeliveryErrorVO;
import egovframework.com.rd.usr.service.vo.DeliveryInfoVO;
import egovframework.com.rd.usr.service.vo.DoszSchAccoutCostVO;
import egovframework.com.rd.usr.service.vo.DoszSchAccoutVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;
import egovframework.com.rd.usr.service.vo.NiceVO;
import egovframework.com.rd.usr.service.vo.SearchKeyVO;
import egovframework.com.rd.usr.service.vo.UploadStateVO;
import egovframework.com.rd.usr.service.vo.WeekInfoVO;
import egovframework.com.rd.usr.service.vo.WeekPayVO;
import egovframework.com.rd.usr.service.vo.WeekRiderInfoVO;

public interface DtyService {
	public boolean insertDeliveryInfo(DeliveryInfoVO vo) throws Exception ;
	/**
	 * 일정산 데이터 insert
	 * @param excelDataBySheet
	 * @param atchFileId
	 * @param loginVO
	 * @throws Exception
	 */
	public void insertExcelData(List<ExcelSheetHandler> excelDataBySheet, String atchFileId, LoginVO user) throws Exception ;
	/**
	 * 주정산 데이터 insert
	 * @param excelDataBySheet
	 * @param atchFileId
	 * @param loginVO
	 * @throws Exception
	 */
	public String insertExcelDataWeek(List<ExcelSheetHandler> excelDataBySheet, String atchFileId, LoginVO loginVO) throws Exception ;


	/**
	 * 주정산 엑셀파일 저장
	 * @param excelDataBySheet
	 * @param atchFileId
	 * @param loginVO
	 * @throws Exception
	 */
	public String saveExcelDataWeek(Map<String, MultipartFile> files) throws Exception ;
	/**
	 * 주정산 데이터 insert
	 *
	 * sheet0
	 * (갑지_협력사 전체 정산 확인용)
	 * @param excelDataBySheet
	 * @param atchFileId
	 * @param loginVO
	 * @throws Exception
	 */
	public List<WeekInfoVO> insertExcelDataWeekByWorkbook(Workbook excelDataBySheet, String atchFileId, LoginVO loginVO) throws Exception ;
	/**
	 * 주정산 데이터(라이더별) insert
	 * @param excelDataBySheet
	 * @param atchFileId
	 * @param loginVO
	 * @throws Exception
	 */
	public void insertExcelDataWeekRider(List<ExcelSheetHandler> excelDataBySheet, String atchFileId, LoginVO loginVO, String weekId) throws Exception ;
	/**
	 * 주정산 데이터(라이더별) insert
	 *
	 * sheet1
	 * (을지_협력사 소속 라이더 정산 확인용)
	 * @param excelDataBySheet
	 * @param atchFileId
	 * @param loginVO
	 * @throws Exception
	 */
	public void insertExcelDataWeekRiderByWorkbook(Workbook excelDataBySheet, List<WeekInfoVO> weekGapji) throws Exception ;
	/**
	 * 파일별 업로드 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DeliveryInfoVO> selectDeliveryInfoByAtchFileId(DeliveryInfoVO vo) throws Exception ;


	/**
	 * 파일별 업로드 오류 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DeliveryErrorVO> selectDeliveryErrorByAtchFileId(DeliveryInfoVO vo) throws Exception ;
	/**
	 * 파일별 업로드 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<WeekInfoVO> selectWeekInfoByAtchFileId(WeekInfoVO vo) throws Exception ;
	/**
	 * 파일별 업로드 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<WeekRiderInfoVO> selectWeekRiderInfoByAtchFileId(WeekInfoVO vo) throws Exception ;
	/**
	 *  파일 업로드 현황 조회 / 주정산 파일
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<UploadStateVO> selectUploadStateInWeek(WeekInfoVO vo) throws Exception;
	/**
	 *  파일 업로드 현황 조회 / 일정산 파일
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<UploadStateVO> selectUploadStateInDay(WeekInfoVO vo) throws Exception;
	/**
	 * 협력사 리스트 가져오기 (selectBox용도)
	 * @return
	 * @throws Exception
	 */
	public List<SearchKeyVO> selectCooperatorList(WeekInfoVO vo) throws Exception ;
	/**
	 * 선출금 실행
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DoszTransferVO actDayPay(DayPayVO vo) throws Exception ;
	/**
	 * 정산완료출금 실행
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DoszTransferVO actWekPay(WeekPayVO vo) throws Exception ;

	/**
	 * 라이더의 배달정보 조회(일별 입금 이력을 조회한다)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DayPayVO> selectRiderDayPayList(DayPayVO vo)throws Exception ;

	/**
	 * 나이스 토큰 생성, enc_data생성
	 * @return
	 * @throws Exception
	 */
	public NiceVO makeNiceEncData(HttpServletRequest request) throws Exception ;
	/**
	 * 나이스 최종 결과
	 * @return
	 * @throws Exception
	 */
	public NiceVO returnNiceData(NiceVO niceVO, HttpServletRequest request) throws Exception ;

	/**
	 * 라이더 등록
	 * @param id
	 * @param nm
	 * @param cooperatorId
	 * @throws Exception
	 */
	public void insertMber(String id, String nm, String cooperatorId, LoginVO user) throws Exception ;
	/**
	 * 이체 처리
	 * @param vo
	 * @throws Exception
	 */
	public DoszTransferVO transfer(DoszTransferVO vo) throws Exception ;
	/**
	 * 예금주조회
	 * @param vo
	 * @throws Exception
	 */
	public DoszSchAccoutVO schAcc(MyInfoVO vo) throws Exception ;
	/**
	 * 모계좌잔액조회
	 * @param vo
	 * @throws Exception
	 */
	public DoszSchAccoutCostVO schAccCost(MyInfoVO vo) throws Exception ;
	/**
	 * 알림톡 토큰조회
	 * @param vo
	 * @throws Exception
	 */
	public String getMsgTocken() throws Exception ;
	/**
	 * DOZN 알림톡 발송
	 * @param jsonParameters
	 * @param sendAccessToken
	 * @param sendRefreshToken
	 * @return
	 */
	public String doznHttpRequestMsg(String jsonParameters, String sendAccessToken, String sendRefreshToken) throws Exception ;
	/**
	 * DOZN 알림톡 레포트
	 * @param jsonParameters
	 * @param sendAccessToken
	 * @param sendRefreshToken
	 * @return
	 */
	public String doznHttpRequestReport(String jsonParameters, String sendAccessToken, String sendRefreshToken, String referenceKey) throws Exception ;
	/**
	 * 출금 내역 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<HistoryVO> selectHistory(HistoryVO vo)throws Exception ;
	/**
	 * 출금 가능 내역 조회 (by mberId)
	 * @param mberId
	 * @return
	 * @throws Exception
	 */
	public List<DeliveryInfoVO> selectTakeDeliveryInfoListByMberId(DeliveryInfoVO vo) throws Exception;

	/**
	 * 출금 실행된 일정산 입출금 출금건 use_at n로 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public void updateDayPayByTransfer(DoszTransferVO vo) throws Exception ;

	/**
	 * 출금 실행된 주정산 입출금 출금건 use_at n로 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateWeekPayByTransfer(DoszTransferVO vo) throws Exception ;
}
