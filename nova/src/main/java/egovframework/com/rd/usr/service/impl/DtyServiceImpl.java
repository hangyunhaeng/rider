package egovframework.com.rd.usr.service.impl;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.Mac;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.DtyService;
import egovframework.com.rd.usr.service.ExcelSheetHandler;
import egovframework.com.rd.usr.service.RotService;
import egovframework.com.rd.usr.service.vo.CooperatorVO;
import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.DeliveryErrorVO;
import egovframework.com.rd.usr.service.vo.DeliveryInfoVO;
import egovframework.com.rd.usr.service.vo.DoszSchAccoutCostVO;
import egovframework.com.rd.usr.service.vo.DoszSchAccoutVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.DoznHistoryVO;
import egovframework.com.rd.usr.service.vo.EtcVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;
import egovframework.com.rd.usr.service.vo.NiceVO;
import egovframework.com.rd.usr.service.vo.ProfitVO;
import egovframework.com.rd.usr.service.vo.SearchKeyVO;
import egovframework.com.rd.usr.service.vo.UploadStateVO;
import egovframework.com.rd.usr.service.vo.WeekInfoVO;
import egovframework.com.rd.usr.service.vo.WeekPayVO;
import egovframework.com.rd.usr.service.vo.WeekRiderInfoVO;
import egovframework.com.sec.rgm.service.AuthorGroup;
import egovframework.com.sec.rgm.service.EgovAuthorGroupService;
import egovframework.com.uss.umt.service.EgovMberManageService;
import egovframework.com.uss.umt.service.MberManageVO;
import egovframework.com.uss.umt.service.UserDefaultVO;
import egovframework.com.uss.umt.service.impl.MberManageDAO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import kr.co.dozn.secure.base.CryptoUtil;

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
@Service("DtyService")
public class DtyServiceImpl extends EgovAbstractServiceImpl implements DtyService {

	@Resource(name = "DtyDAO")
	private DtyDAO dtyDAO;
	@Resource(name = "MemDAO")
	private MemDAO memDAO;
	@Resource(name="mberManageDAO")
	private MberManageDAO mberManageDAO;
	@Resource(name = "PayDAO")
	private PayDAO payDAO;
	@Resource(name = "RotDAO")
	private RotDAO rotDAO;

//	@Resource(name = "egovFileIdGnrService")
//	private EgovIdGnrService idgenService;

    @Resource(name = "mberManageService")
    private EgovMberManageService mberManageService;
    @Resource(name = "egovAuthorGroupService")
    private EgovAuthorGroupService egovAuthorGroupService;
	@Resource(name="EgovFileMngService")
	private EgovFileMngService fileMngService;
    @Resource(name = "RotService")
    private RotService rotService;

	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil fileUtil;

    /** ID Generation */
	@Resource(name="egovWeekIdGnrService")
	private EgovIdGnrService egovWeekIdGnrService;
    /** ID Generation */
	@Resource(name="egovConIdGnrService")
	private EgovIdGnrService egovConIdGnrService;
    /** ID Generation */
	@Resource(name="egovWkpIdGnrService")
	private EgovIdGnrService egovWkpIdGnrService;
    /** ID Generation */
	@Resource(name="egovDypIdGnrService")
	private EgovIdGnrService egovDypIdGnrService;
    /** ID Generation */
	@Resource(name="egovFitIdGnrService")
	private EgovIdGnrService egovFitIdGnrService;
    /** ID Generation */
	@Resource(name="egovCitIdGnrService")
	private EgovIdGnrService egovCitIdGnrService;

	private static final Logger LOGGER = LoggerFactory.getLogger(DtyServiceImpl.class);

	public boolean insertDeliveryInfo(DeliveryInfoVO vo) throws Exception {
		boolean bRe = true;
		try {
			dtyDAO.insertDeliveryInfo(vo);
		} catch(Exception e) {
			bRe = false;
			e.printStackTrace();
			LOGGER.error(e.toString());
		}
		return bRe;
	}
	/**
	 * 일정산 데이터 insert
	 * @param excelDataBySheet
	 * @param atchFileId
	 * @param loginVO
	 * @throws Exception
	 */
	public void insertExcelData(List<ExcelSheetHandler> excelDataBySheet, String atchFileId, LoginVO user) throws Exception {

		for(int i = 0 ; i < excelDataBySheet.size() ; i++ ) {
			ExcelSheetHandler sheet = excelDataBySheet.get(i);
			List<List<String>> rows = sheet.getRows();

			for(int j = 0; j < rows.size() ; j++) {
				List<String> row = rows.get(j);
				try {
	            	DeliveryInfoVO deliveryInfoVO = new DeliveryInfoVO();
	            	deliveryInfoVO.setCooperatorId(row.get(0));
	            	deliveryInfoVO.setCooperatorNm(row.get(1));
	            	deliveryInfoVO.setRegistrationSn(row.get(2));
	            	deliveryInfoVO.setRegistrationNm(row.get(3));
	            	deliveryInfoVO.setRunDe(row.get(4));
	            	deliveryInfoVO.setDeliverySn(row.get(5));
	            	deliveryInfoVO.setDeliveryState(row.get(6));
	            	deliveryInfoVO.setServiceType(row.get(7));
	            	deliveryInfoVO.setDeliveryType(row.get(8));
	            	deliveryInfoVO.setRiderId(row.get(9));
	            	deliveryInfoVO.setMberId(row.get(10));
	            	deliveryInfoVO.setRiderNm(row.get(11));
	            	deliveryInfoVO.setDeliveryMethod(row.get(12));
	            	deliveryInfoVO.setShopSn(row.get(13));
	            	deliveryInfoVO.setShopNm(row.get(14));
	            	deliveryInfoVO.setGoodsPrice(row.get(15));
	            	deliveryInfoVO.setPickupAddr(row.get(16));
	            	deliveryInfoVO.setDestinationAddr(row.get(17));
	            	deliveryInfoVO.setOrderDt(row.get(18));
	            	deliveryInfoVO.setOperateRiderDt(row.get(19));
	            	deliveryInfoVO.setShopComeinDt(row.get(20));
	            	deliveryInfoVO.setPickupFinistDt(row.get(21));
	            	deliveryInfoVO.setDeliveryFinistDt(row.get(22));
	            	deliveryInfoVO.setDistance(row.get(23));
	            	deliveryInfoVO.setAddDeliveryReason(row.get(24));
	            	deliveryInfoVO.setAddDeliveryDesc(row.get(25));
	            	deliveryInfoVO.setPickupLawDong(row.get(26));
	            	deliveryInfoVO.setBasicPrice(Integer.parseInt(row.get(27)) );
	            	deliveryInfoVO.setWeatherPrimage(Integer.parseInt(row.get(28)) );
	            	deliveryInfoVO.setAddPrimage(Integer.parseInt(row.get(29)) );
	            	deliveryInfoVO.setPeakPrimageEtc(Integer.parseInt(row.get(30)) );
	            	deliveryInfoVO.setDeliveryPrice(Integer.parseInt(row.get(31)) );
	            	deliveryInfoVO.setRiderCauseYn(row.get(32));
	            	deliveryInfoVO.setAddPrimageDesc(row.get(33));
	            	deliveryInfoVO.setNote("");
	            	deliveryInfoVO.setAtchFileId(atchFileId);
	            	deliveryInfoVO.setCreatId(user.getId());


	            	//권한
	            	deliveryInfoVO.setSchAuthorCode(user.getAuthorCode());
	            	deliveryInfoVO.setSchIhidNum(user.getIhidNum());

	            	if(dtyDAO.insertDeliveryInfo(deliveryInfoVO) <= 0) {
	            		throw new IllegalArgumentException("조건이 맞지 않아 등록 불가") ;
	            	}

	            	insertMber(deliveryInfoVO.getMberId(), deliveryInfoVO.getRiderNm(), deliveryInfoVO.getCooperatorId(), user);
				}catch(Exception e) {
					LOGGER.error(e.toString());
					e.printStackTrace();
					//insert 오류시 RD_DELIVERY_ERROR 테이블에 넣기
					DeliveryErrorVO eVo = new DeliveryErrorVO();
					eVo.setLongtxt(row.toString());
					eVo.setAtchFileId(atchFileId);
					eVo.setCreatId(user.getId());
					eVo.setUseAt("Y");
					dtyDAO.insertDeliveryError(eVo);
				}

			}
		}



    	//1. 라이더 입금 : 일정산 입금내역 수수료 계산 후 라이더의 입금이력 등록
		//2. 수익 등록
		DayPayVO inVo = new DayPayVO();
		inVo.setDayAtchFileId(atchFileId);
		inVo.setTimeInsuranceMaxFee(Integer.parseInt(EgovProperties.getProperty("Globals.timeInsuranceMaxFee")) );
    	List<DayPayVO> dayList = dtyDAO.selectDayPay(inVo);
    	for(int i = 0 ; i<dayList.size() ; i++) {
    		DayPayVO one = dayList.get(i);

    		//라이더 입금
    		one.setDypId(egovDypIdGnrService.getNextStringId());
    		one.setCreatId(user.getId());
    		dtyDAO.insertDayPay(one);

    		//수익 등록(콜수수료)
    		ProfitVO fitVo = new ProfitVO();
    		if(one.getFeeCallCost()-one.getFeeCooperatorCallCost() > 0) {
	    		fitVo.setProfitId(egovFitIdGnrService.getNextStringId());
	    		fitVo.setCooperatorId(one.getCooperatorId());//협력사
	    		fitVo.setMberId(one.getMberId());			//라이더ID
	    		fitVo.setGubun("C");						//콜수수료
	    		fitVo.setCost(one.getFeeCallCost()-one.getFeeCooperatorCallCost()); 		//금액
	    		fitVo.setDeliveryCost(one.getDeliveryPrice());	//배달비
	    		fitVo.setDeliveryCnt(one.getDeliveryCnt());	//배달건수
	    		fitVo.setDeliveryDay(one.getDay());			//배달일
	    		fitVo.setDypId(one.getDypId());				//DYP_ID
	    		fitVo.setFeeId(one.getFeeId());				//FEE_ID
	    		fitVo.setRiderFeeId(one.getRiderFeeId());	//RIDER_FEE_ID
	    		fitVo.setCreatId(user.getId());
	    		dtyDAO.insertProfit(fitVo);
    		}

    		//협력사 수익등록(콜수수료)
    		if(one.getFeeCooperatorCallCost() > 0) {
	    		ProfitVO citVo = new ProfitVO();
	    		citVo.setCoofitId(egovCitIdGnrService.getNextStringId());
	    		citVo.setProfitId(fitVo.getProfitId());
	    		citVo.setCooperatorId(one.getCooperatorId());//협력사
	    		citVo.setMberId(one.getMberId());			//라이더ID
	    		citVo.setGubun("C");						//콜수수료
	    		citVo.setCost(one.getFeeCooperatorCallCost());//금액
	    		citVo.setDeliveryCost(one.getDeliveryPrice());	//배달비
	    		citVo.setDeliveryCnt(one.getDeliveryCnt());	//배달건수
	    		citVo.setDeliveryDay(one.getDay());			//배달일
	    		citVo.setDypId(one.getDypId());				//DYP_ID
	    		citVo.setFeeId(one.getFeeId());				//FEE_ID
	    		citVo.setRiderFeeId(one.getRiderFeeId());	//RIDER_FEE_ID
	    		citVo.setCreatId(user.getId());
	    		dtyDAO.insertCooperatorProfit(citVo);
    		}

    	}



    	//대출 출금 : 대출 입금 대상 조회 후 출금이력 생성
    	List<EtcVO> etcList = dtyDAO.selectEtcList(inVo);
		String tranDay = Util.getDay();

		//		대출 출금 갚은 건수를 확인하기 위한 맵(etc_id를 키로 갯수를 관리한다)
		HashMap<String, Integer> etcSumCnt = new HashMap<String, Integer>();

    	for(int i = 0 ; i<etcList.size() ; i++) {
    		EtcVO one = etcList.get(i);
    		if("Y".equals(one.getAbleYn())) {

    			//대출 출금을 이미 갚은 건수를 설정한다
    			if(etcSumCnt.get(one.getEtcId()) == null) {
    				etcSumCnt.put(one.getEtcId(), one.getSumEtcCnt());
    			}

    			if(etcSumCnt.get(one.getEtcId()) < one.getPaybackDay()) {
    				//대출출금건수를 올린다
    				etcSumCnt.put(one.getEtcId(), etcSumCnt.get(one.getEtcId())+1);
		    		one.setLastUpdusrId(user.getId());

		    		//1.출금 가능금액 내의 금액인지 확인
		    		MyInfoVO myInfoVO = new MyInfoVO();
		    		myInfoVO.setMberId(one.getMberId());
		    		myInfoVO.setSearchCooperatorId(one.getCooperatorId());
		    		MyInfoVO ablePrice = rotService.selectAblePrice(myInfoVO);
		    		if(one.getPaybackCost() <= ablePrice.getWeekAblePrice()) {

		    			WeekPayVO insertVo = new WeekPayVO();
		    			insertVo.setWkpId(egovWkpIdGnrService.getNextStringId());
		    			insertVo.setMberId(one.getMberId());
		    			insertVo.setCooperatorId(one.getCooperatorId());
		    			insertVo.setDwGubun("WEK");
		    			insertVo.setIoGubun("2");
		    			insertVo.setFee(0);
		    			insertVo.setSendPrice(new BigDecimal(one.getPaybackCost()));
		    			insertVo.setEtcId(one.getEtcId());
		    			insertVo.setTranDay(one.getDay());
		//    			insertVo.setTelegramNo(telegramNo);
		    			insertVo.setUseAt("Y");
		    			insertVo.setCreatId(user.getId());

		    			dtyDAO.insertWeekPay(insertVo);
		    			dtyDAO.finishEtc(one);


		        		//수익 등록(기타수수료) 운영사는 기타수수료가 발생하지 않음
	//	        		ProfitVO fitVo = new ProfitVO();
	//	        		fitVo.setProfitId(egovFitIdGnrService.getNextStringId());
	//	        		fitVo.setCooperatorId(one.getCooperatorId());//협력사
	//	        		fitVo.setMberId(one.getMberId());			//라이더ID
	//	        		fitVo.setGubun("E");						//기타수수료
	//	        		fitVo.setCost(0); 		//금액
	//	        		fitVo.setWkpId(insertVo.getWkpId());		//WKP_ID
	//	        		fitVo.setCreatId(user.getId());
	//	        		dtyDAO.insertProfit(fitVo);

		        		//협력사 수익등록(기타수수료)
		        		ProfitVO citVo = new ProfitVO();
		        		citVo.setCoofitId(egovCitIdGnrService.getNextStringId());
		        		citVo.setProfitId(egovFitIdGnrService.getNextStringId());
		        		citVo.setCooperatorId(one.getCooperatorId());//협력사
		        		citVo.setMberId(one.getMberId());			//라이더ID
		        		citVo.setGubun("E");						//기타수수료
		        		citVo.setCost(one.getPaybackCost());		//금액
		        		citVo.setWkpId(insertVo.getWkpId());				//DYP_ID
		        		citVo.setCreatId(user.getId());
		        		dtyDAO.insertCooperatorProfit(citVo);


		    		} else if(one.getPaybackCost() <= ablePrice.getDayAblePrice() ) {	//출금 가능금액 체크


		    			//선지급 수수료 계산
		    			DayPayVO fee = new DayPayVO();
		    			fee.setMberId(one.getMberId());
		    			fee.setCooperatorId(one.getCooperatorId());
		    			fee.setInputPrice(one.getPaybackCost());
		    			DayPayVO resultFee = rotDAO.selectDayFee(fee);

		    			int dayFee = resultFee.getDayFee();
		    			int insurance = 0;

		    			DayPayVO insertVo = new DayPayVO();

		    			insertVo.setDypId(egovDypIdGnrService.getNextStringId());
		    			insertVo.setMberId(one.getMberId());
		    			insertVo.setCooperatorId(one.getCooperatorId());
		    			insertVo.setDay(one.getDay());
		    			insertVo.setIoGubun("2");			//출금
		    			insertVo.setDayFee(0);				//선출금수수료
		    			insertVo.setInsurance(insurance);	//보험료
		    			insertVo.setSendFee(0);		//이체수수료
		    			insertVo.setSendPrice(one.getPaybackCost());
		    			insertVo.setWeekYn("N");			//정산완료
		    			insertVo.setEtcId(one.getEtcId());
		    			insertVo.setTranDay(tranDay);
		//    			insertVo.setTelegramNo(telegramNo);
		    			insertVo.setUseAt("Y");
		    			insertVo.setCreatId(user.getId());
		    			dtyDAO.insertDayPay(insertVo);
		    			dtyDAO.finishEtc(one);



		        		//수익 등록(기타수수료) 운영사는 기타수수료가 발생하지 않음
	//	        		ProfitVO fitVo = new ProfitVO();
	//	        		fitVo.setProfitId(egovFitIdGnrService.getNextStringId());
	//	        		fitVo.setCooperatorId(one.getCooperatorId());//협력사
	//	        		fitVo.setMberId(one.getMberId());			//라이더ID
	//	        		fitVo.setGubun("E");						//기타수수료
	//	        		fitVo.setCost(0); 		//금액
	//	        		fitVo.setDypId(insertVo.getDypId());				//DYP_ID
	//	        		fitVo.setFeeId(resultFee.getFeeId());				//FEE_ID
	//	        		fitVo.setRiderFeeId(resultFee.getRiderFeeId());	//RIDER_FEE_ID
	//	        		fitVo.setCreatId(user.getId());
	//	        		dtyDAO.insertProfit(fitVo);

		        		//협력사 수익등록(기타수수료)
		        		ProfitVO citVo = new ProfitVO();
		        		citVo.setCoofitId(egovCitIdGnrService.getNextStringId());
		        		citVo.setProfitId(egovFitIdGnrService.getNextStringId());
		        		citVo.setCooperatorId(one.getCooperatorId());//협력사
		        		citVo.setMberId(one.getMberId());			//라이더ID
		        		citVo.setGubun("E");						//기타수수료
		        		citVo.setCost(one.getPaybackCost());//금액
		        		citVo.setDypId(insertVo.getDypId());				//DYP_ID
		        		citVo.setFeeId(resultFee.getFeeId());				//FEE_ID
		        		citVo.setRiderFeeId(resultFee.getRiderFeeId());	//RIDER_FEE_ID
		        		citVo.setCreatId(user.getId());
		        		dtyDAO.insertCooperatorProfit(citVo);

		    		}
    			}// end if(etcSumCnt.get(one.getEtcId()) < one.getPaybackDay())
    		}// end if("Y".equals(one.getAbleYn())) {

    	}


	}

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
	public String insertExcelDataWeek(List<ExcelSheetHandler> excelDataBySheet, String atchFileId, LoginVO loginVO) throws Exception {

		List<WeekInfoVO> insertData = new ArrayList<WeekInfoVO>();
		String weekId = egovWeekIdGnrService.getNextStringId();

		//협력사 정보 찾았는지 여부
		boolean bSeet0CooperatorInfo = false;
		//주차별 정산내역을 찾았는지 여부
		boolean bSeet0bWeekInfo = false;
		//세금계산서 내역을 찾았는지 여부
		boolean bSeet0bTaxInfo = false;
		String cooperatorId = "";

		for(int i = 0 ; i < 1 ; i++ ) {
			ExcelSheetHandler sheet = excelDataBySheet.get(i);
			List<List<String>> rows = sheet.getRows();


			//정산내역 행 index를 가리킨다.
			int acountIdx = 0;
			//세금계산서 행 index를 가리킨다.
			int taxIdx = 0;

			boolean bCooperatoHeader = false;
			boolean bWeekHeader = false;
			boolean bTaxHeader = false;
			for(int j = 0; j < rows.size() ; j++) {
				List<String> row = rows.get(j);

				// 1.협력사 정보
				// 1.1 협력사 정보는 윗줄에 있음을 감안하여 협력사 정보를 찾았으면 다음부터 찾지 않도록 설정하자
				if(!bSeet0CooperatorInfo) {
					if(row.size() > 2) {	//협력사 정보

						Iterator it = row.iterator();
						while(it.hasNext()) {
							String val = (String)it.next();
							if(val != null) {
								if(bCooperatoHeader) {		//헤더를 찾은 후 다음 글자는 협력사 아이디로 세팅한다
									cooperatorId = val;
									bSeet0CooperatorInfo = true;
									continue;
								}

								bCooperatoHeader = true;	//협력사아이디 헤더를 찾음을 인지
								continue;
							}
						}
					}
					//현재row에서 협력사 아이디를 찾으면 다음줄로 넘어가자
					if(bSeet0CooperatorInfo) {
						continue;
					}
				}

				// 협력사 정보를 못찾으면 다음을 넘어갈 필요가 없음
				if(!bSeet0CooperatorInfo) {
					continue;
				}


				Date nowDate = new Date();
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy년 MM월 dd일");

				// 2.주차별 정산내역
				if(row.size() == 19) {			//주차별 정산내역 시트가 계속 바뀜????
					if(!bWeekHeader) {	//헤더 제외하기
						bWeekHeader = true;
						continue;
					}
					WeekInfoVO weekInfoVO = new WeekInfoVO();
					weekInfoVO.setWeekId(weekId);
					weekInfoVO.setCooperatorId(cooperatorId);
					weekInfoVO.setAccountsStDt(Util.getOnlyNumber(row.get(1)));
					weekInfoVO.setAccountsEdDt(Util.getOnlyNumber(row.get(2)));
					DateUtil.isValidExcelDate(Double.parseDouble(row.get(2)));
//					HSSFDateUtil.isCellDateFormatted(row.get(2));
					weekInfoVO.setDeliveryCost(new BigDecimal( Util.getOnlyNumber(row.get(3))));
					weekInfoVO.setAddAccounts(new BigDecimal( Util.getOnlyNumber(row.get(4))));
					weekInfoVO.setOperatingCost(new BigDecimal( Util.getOnlyNumber(row.get(5))));
					weekInfoVO.setManagementCost(new BigDecimal( Util.getOnlyNumber(row.get(6))));
					weekInfoVO.setOperatingFee(new BigDecimal( Util.getOnlyNumber(row.get(7))));
					weekInfoVO.setEtcCost(new BigDecimal( Util.getOnlyNumber(row.get(8))));
					weekInfoVO.setTimeInsurance(new BigDecimal( Util.getOnlyNumber(row.get(9))));
					weekInfoVO.setOwnerEmploymentInsurance(new BigDecimal( Util.getOnlyNumber(row.get(10))));
					weekInfoVO.setRiderEmploymentInsurance(new BigDecimal( Util.getOnlyNumber(row.get(11))));
					weekInfoVO.setOwnerIndustrialInsurance(new BigDecimal( Util.getOnlyNumber(row.get(12))));
					weekInfoVO.setRiderIndustrialInsurance(new BigDecimal( Util.getOnlyNumber(row.get(13))));
					weekInfoVO.setWithholdingTaxInsuranceSum(new BigDecimal( Util.getOnlyNumber(row.get(14))));
					weekInfoVO.setEmploymentInsuranceAccounts(new BigDecimal( Util.getOnlyNumber(row.get(15))));
					weekInfoVO.setIndustrialInsuranceAccounts(new BigDecimal( Util.getOnlyNumber(row.get(16))));
					weekInfoVO.setG(new BigDecimal( Util.getOnlyNumber(row.get(17))));
					weekInfoVO.setAccountsScheduleCost(new BigDecimal( Util.getOnlyNumber(row.get(18))));

					weekInfoVO.setAtchFileId(atchFileId);
					weekInfoVO.setCreatId(loginVO.getId());
					insertData.add(acountIdx, weekInfoVO);
					acountIdx++;
					bSeet0bWeekInfo = true;
					continue;
				}

				if(row.size() == 16) {			//주차별 정산내역 시트가 계속 바뀜????
					if(!bWeekHeader) {	//헤더 제외하기
						bWeekHeader = true;
						continue;
					}
					WeekInfoVO weekInfoVO = new WeekInfoVO();
					weekInfoVO.setWeekId(weekId);
					weekInfoVO.setCooperatorId(cooperatorId);
					weekInfoVO.setAccountsStDt(Util.getOnlyNumber(row.get(1)));
					weekInfoVO.setAccountsEdDt(Util.getOnlyNumber(row.get(2)));
					weekInfoVO.setDeliveryCost(new BigDecimal( Util.getOnlyNumber(row.get(3))));
					weekInfoVO.setAddAccounts(new BigDecimal( Util.getOnlyNumber(row.get(4))));
					weekInfoVO.setOperatingCost(new BigDecimal( 0 ));
					weekInfoVO.setManagementCost(new BigDecimal( Util.getOnlyNumber(row.get(5))));
					weekInfoVO.setOperatingFee(new BigDecimal( 0 ));
					weekInfoVO.setEtcCost(new BigDecimal( Util.getOnlyNumber(row.get(6))));
					weekInfoVO.setTimeInsurance(new BigDecimal( Util.getOnlyNumber(row.get(7))));
					weekInfoVO.setOwnerEmploymentInsurance(new BigDecimal( Util.getOnlyNumber(row.get(8))));
					weekInfoVO.setRiderEmploymentInsurance(new BigDecimal( Util.getOnlyNumber(row.get(9))));
					weekInfoVO.setOwnerIndustrialInsurance(new BigDecimal( Util.getOnlyNumber(row.get(10))));
					weekInfoVO.setRiderIndustrialInsurance(new BigDecimal( Util.getOnlyNumber(row.get(11))));
					weekInfoVO.setWithholdingTaxInsuranceSum(new BigDecimal( Util.getOnlyNumber(row.get(12))));
					weekInfoVO.setEmploymentInsuranceAccounts(new BigDecimal( Util.getOnlyNumber(row.get(13))));
					weekInfoVO.setIndustrialInsuranceAccounts(new BigDecimal( Util.getOnlyNumber(row.get(14))));
					weekInfoVO.setG(new BigDecimal( 0 ));
					weekInfoVO.setAccountsScheduleCost(new BigDecimal( Util.getOnlyNumber(row.get(15))));

					weekInfoVO.setAtchFileId(atchFileId);
					weekInfoVO.setCreatId(loginVO.getId());
					insertData.add(acountIdx, weekInfoVO);
					acountIdx++;
					bSeet0bWeekInfo = true;
					continue;
				}

				// 주차별 정산내역을 못찾으면 세금계산서 내역을 찾을 필요가 없음
				if(!bSeet0bWeekInfo) {
					continue;
				}
				// 3.세금계산서 내역
				if(row.size() == 4) {
					if(!bTaxHeader) {	//헤더 제외하기
						bTaxHeader = true;
						continue;
					}
					WeekInfoVO addTaxWeekInfoVO = insertData.get(taxIdx);
					addTaxWeekInfoVO.setTaxBillSupply(new BigDecimal( Util.getOnlyNumber(row.get(1))) );
					addTaxWeekInfoVO.setTaxBillAdd(new BigDecimal(Util.getOnlyNumber(row.get(2))) );
					addTaxWeekInfoVO.setTaxBillSum(new BigDecimal(Util.getOnlyNumber(row.get(3))) );
					insertData.set(taxIdx, addTaxWeekInfoVO);
					taxIdx++;
				}
			}
		}
		//sheet를 모두 읽었는데 협력사 정보를 못찾으면 실패
		if(!bSeet0CooperatorInfo) {
			throw new IllegalArgumentException("협력사정보를 찾지 못했습니다.") ;
		}
		//sheet를 모두 읽었는데 주차별정산내역을 못찾으면 실패
		if(!bSeet0bWeekInfo) {
			throw new IllegalArgumentException("주차별정산내역을 찾지 못했습니다.") ;
		}

		//0번 sheet를 읽었으면 데이터를 DB에 isnert
		for(int i = 0 ; i < insertData.size() ; i++) {
			dtyDAO.insertWeekInfo(insertData.get(i));
		}
		return weekId;
	}

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
	public void insertExcelDataWeekRider(List<ExcelSheetHandler> excelDataBySheet, String atchFileId, LoginVO loginVO, String weekId) throws Exception {

		List<WeekRiderInfoVO> insertData = new ArrayList<WeekRiderInfoVO>();
		for(int i = 1 ; i < 2 ; i++ ) {
			ExcelSheetHandler sheet = excelDataBySheet.get(i);
			List<List<String>> rows = sheet.getRows();

			//라이더 행 index를 가리킨다.
			int riderIdx = 0;

			for(int j = 0; j < rows.size() ; j++) {
				List<String> row = rows.get(j);
				if(row.size() > 10) {
					LOGGER.debug("----------");
					if(riderIdx != 4) {
						riderIdx++;
						continue;
					}

					if(row.size() == 27) {
						WeekRiderInfoVO weekRiderInfoVO = new WeekRiderInfoVO();
						weekRiderInfoVO.setWeekId(weekId);
						weekRiderInfoVO.setNo(row.get(0));
						weekRiderInfoVO.setMberId(row.get(1));
						weekRiderInfoVO.setMberNm(row.get(2));
						weekRiderInfoVO.setCnt(Integer.parseInt(Util.getOnlyNumber(row.get(3))));
						weekRiderInfoVO.setDeliveryCost(new BigDecimal(Util.getOnlyNumber(row.get(4))));
						weekRiderInfoVO.setAddCost(new BigDecimal(Util.getOnlyNumber(row.get(5))));
						weekRiderInfoVO.setSumCost(new BigDecimal(Util.getOnlyNumber(row.get(6))));
						weekRiderInfoVO.setTimeInsurance(new BigDecimal(Util.getOnlyNumber(row.get(7))));
						weekRiderInfoVO.setNecessaryExpenses(new BigDecimal(Util.getOnlyNumber(row.get(8))));
						weekRiderInfoVO.setPay(new BigDecimal(Util.getOnlyNumber(row.get(9))));
						weekRiderInfoVO.setOwnerEmploymentInsurance(new BigDecimal(Util.getOnlyNumber(row.get(10))));
						weekRiderInfoVO.setRiderEmploymentInsurance(new BigDecimal(Util.getOnlyNumber(row.get(11))));
						weekRiderInfoVO.setOwnerIndustrialInsurance(new BigDecimal(Util.getOnlyNumber(row.get(12))));
						weekRiderInfoVO.setRiderIndustrialInsurance(new BigDecimal(Util.getOnlyNumber(row.get(13))));
						weekRiderInfoVO.setWithholdingTaxInsuranceSum(new BigDecimal(Util.getOnlyNumber(row.get(14))));
						weekRiderInfoVO.setOwnerEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(15))));
						weekRiderInfoVO.setRiderEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(16))));
						weekRiderInfoVO.setSumEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(17))));
						weekRiderInfoVO.setOwnerIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(18))));
						weekRiderInfoVO.setRiderIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(19))));
						weekRiderInfoVO.setSumIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(20))));
						weekRiderInfoVO.setOperatingCost(new BigDecimal(Util.getOnlyNumber(row.get(21))));
						weekRiderInfoVO.setAccountsCost(new BigDecimal(Util.getOnlyNumber(row.get(22))));
						weekRiderInfoVO.setIncomeTax(new BigDecimal(Util.getOnlyNumber(row.get(23))));
						weekRiderInfoVO.setResidenceTax(new BigDecimal(Util.getOnlyNumber(row.get(24))));
						weekRiderInfoVO.setWithholdingTax(new BigDecimal(Util.getOnlyNumber(row.get(25))));
						weekRiderInfoVO.setGivePay(new BigDecimal(Util.getOnlyNumber(row.get(26))));
						weekRiderInfoVO.setCreatId(loginVO.getId());
						insertData.add(weekRiderInfoVO);
					}
					if(row.size() == 26) {	//운영비가 빠졌음
						WeekRiderInfoVO weekRiderInfoVO = new WeekRiderInfoVO();
						weekRiderInfoVO.setWeekId(weekId);
						weekRiderInfoVO.setNo(row.get(0));
						weekRiderInfoVO.setMberId(row.get(1));
						weekRiderInfoVO.setMberNm(row.get(2));
						weekRiderInfoVO.setCnt(Integer.parseInt(Util.getOnlyNumber(row.get(3))));
						weekRiderInfoVO.setDeliveryCost(new BigDecimal(Util.getOnlyNumber(row.get(4))));
						weekRiderInfoVO.setAddCost(new BigDecimal(Util.getOnlyNumber(row.get(5))));
						weekRiderInfoVO.setSumCost(new BigDecimal(Util.getOnlyNumber(row.get(6))));
						weekRiderInfoVO.setTimeInsurance(new BigDecimal(Util.getOnlyNumber(row.get(7))));
						weekRiderInfoVO.setNecessaryExpenses(new BigDecimal(Util.getOnlyNumber(row.get(8))));
						weekRiderInfoVO.setPay(new BigDecimal(Util.getOnlyNumber(row.get(9))));
						weekRiderInfoVO.setOwnerEmploymentInsurance(new BigDecimal(Util.getOnlyNumber(row.get(10))));
						weekRiderInfoVO.setRiderEmploymentInsurance(new BigDecimal(Util.getOnlyNumber(row.get(11))));
						weekRiderInfoVO.setOwnerIndustrialInsurance(new BigDecimal(Util.getOnlyNumber(row.get(12))));
						weekRiderInfoVO.setRiderIndustrialInsurance(new BigDecimal(Util.getOnlyNumber(row.get(13))));
						weekRiderInfoVO.setWithholdingTaxInsuranceSum(new BigDecimal(Util.getOnlyNumber(row.get(14))));
						weekRiderInfoVO.setOwnerEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(15))));
						weekRiderInfoVO.setRiderEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(16))));
						weekRiderInfoVO.setSumEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(17))));
						weekRiderInfoVO.setOwnerIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(18))));
						weekRiderInfoVO.setRiderIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(19))));
						weekRiderInfoVO.setSumIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(row.get(20))));
						weekRiderInfoVO.setOperatingCost(new BigDecimal( 0 ));
						weekRiderInfoVO.setAccountsCost(new BigDecimal(Util.getOnlyNumber(row.get(21))));
						weekRiderInfoVO.setIncomeTax(new BigDecimal(Util.getOnlyNumber(row.get(22))));
						weekRiderInfoVO.setResidenceTax(new BigDecimal(Util.getOnlyNumber(row.get(23))));
						weekRiderInfoVO.setWithholdingTax(new BigDecimal(Util.getOnlyNumber(row.get(24))));
						weekRiderInfoVO.setGivePay(new BigDecimal(Util.getOnlyNumber(row.get(25))));
						weekRiderInfoVO.setCreatId(loginVO.getId());
						insertData.add(weekRiderInfoVO);
					}

				}
			}
		}


		//1번 sheet를 읽었으면 데이터를 DB에 isnert
		for(int i = 0 ; i < insertData.size() ; i++) {
			dtyDAO.insertWeekRiderInfo(insertData.get(i));
		}
	}


	/**
	 * 주정산 엑셀파일 저장
	 * @param excelDataBySheet
	 * @param atchFileId
	 * @param loginVO
	 * @throws Exception
	 */
	public String saveExcelDataWeek(Map<String, MultipartFile> files) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		List<FileVO> result = null;
		result = fileUtil.parseFileInf(files, "xls_", 0, "", "", user.getId(), "WEEK");
		//1. 화면에서 넘어온 엑셀 파일을 was와 db에 저장
		String atchFileId = fileMngService.insertFileInfs(result);

		Workbook workbook = WorkbookFactory.create(files.get("fileName").getInputStream());
		List<WeekInfoVO> weekGapji = insertExcelDataWeekByWorkbook(workbook, atchFileId, user);
		insertExcelDataWeekRiderByWorkbook(workbook, weekGapji);
		return atchFileId;
	}

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
	public List<WeekInfoVO> insertExcelDataWeekByWorkbook(Workbook excelDataBySheet, String atchFileId, LoginVO loginVO) throws Exception {

		List<WeekInfoVO> insertData = new ArrayList<WeekInfoVO>();


		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");

		//협력사 정보 찾았는지 여부
		boolean bSeet0CooperatorInfo = false;
		//주차별 정산내역을 찾았는지 여부
		boolean bSeet0bWeekInfo = false;
		//세금계산서 내역을 찾았는지 여부
		boolean bSeet0bTaxInfo = false;
		String cooperatorId = "";


		Sheet worksheet = excelDataBySheet.getSheetAt(0);


		//정산내역 행 index를 가리킨다.
		int acountIdx = 0;
		//세금계산서 행 index를 가리킨다.
		int taxIdx = 0;

		boolean bCooperatoHeader = false;
		boolean bWeekHeader = false;
		boolean bTaxHeader = false;
		for (int j = 0, rowIdx = 0; rowIdx < worksheet.getPhysicalNumberOfRows(); j++) {
			Row rowObj = worksheet.getRow(j);

			if(rowObj != null) {
				rowIdx++;
				int rowSize = this.getRowSize(rowObj);

				LOGGER.debug("------------------j : "+j+" endIndex : "+rowSize);

				// 1.협력사 정보
				// 1.1 협력사 정보는 윗줄에 있음을 감안하여 협력사 정보를 찾았으면 다음부터 찾지 않도록 설정하자
				if(!bSeet0CooperatorInfo) {
					if(rowSize > 2) {	//협력사 정보

						Iterator it = rowObj.iterator();
						while(it.hasNext()) {
							Cell val = (Cell)it.next();
							if(val != null && this.getValue(val) != null) {
								if(bCooperatoHeader) {		//헤더를 찾은 후 다음 글자는 협력사 아이디로 세팅한다
									cooperatorId = this.getValue(val);
									bSeet0CooperatorInfo = true;


									//총판 or 협력사
									// 협력사가 권한이 없는 cooperatorId를 등록하려 할 경우 오류 처리
									if("ROLE_USER".equals(loginVO.getAuthorCode())) {
										CooperatorVO chkVo = new CooperatorVO();
										chkVo.setMberId(loginVO.getId());
										chkVo.setCooperatorId(cooperatorId);
										if(!memDAO.selectAuthChkByCoop(chkVo)) {
											throw new IllegalArgumentException("권한이 없는 협력사데이터는 등록되지 않습니다.") ;
										}
									}

									break;
								}

								bCooperatoHeader = true;	//협력사아이디 헤더를 찾음을 인지
								continue;
							}
						}
					}
				}

				// 협력사 정보를 못찾으면 다음을 넘어갈 필요가 없음
				if(!bSeet0CooperatorInfo) {
					continue;
				}




				// 2.주차별 정산내역
				if(rowSize == 19) {			//주차별 정산내역 시트가 계속 바뀜????
					if(!bWeekHeader) {	//헤더 제외하기
						bWeekHeader = true;
						continue;
					}
					WeekInfoVO weekInfoVO = new WeekInfoVO();
					weekInfoVO.setWeekId(egovWeekIdGnrService.getNextStringId());
					weekInfoVO.setCooperatorId(cooperatorId);



					weekInfoVO.setAccountsStDt( rowObj.getCell(1).getCellTypeEnum() == CellType.NUMERIC  ? simpleDateFormat.format(rowObj.getCell(1).getDateCellValue()) : Util.getOnlyNumber(getValue(rowObj.getCell(1)))  );
					weekInfoVO.setAccountsEdDt( rowObj.getCell(1).getCellTypeEnum() == CellType.NUMERIC  ? simpleDateFormat.format(rowObj.getCell(2).getDateCellValue()) : Util.getOnlyNumber(getValue(rowObj.getCell(2))) );
					weekInfoVO.setDeliveryCost(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(3)))));
					weekInfoVO.setAddAccounts(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(4)))));
					weekInfoVO.setOperatingCost(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(5)))));
					weekInfoVO.setManagementCost(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(6)))));
					weekInfoVO.setOperatingFee(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(7)))));
					weekInfoVO.setEtcCost(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(8)))));
					weekInfoVO.setTimeInsurance(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(9)))));
					weekInfoVO.setOwnerEmploymentInsurance(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(10)))));
					weekInfoVO.setRiderEmploymentInsurance(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(11)))));
					weekInfoVO.setOwnerIndustrialInsurance(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(12)))));
					weekInfoVO.setRiderIndustrialInsurance(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(13)))));
					weekInfoVO.setWithholdingTaxInsuranceSum(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(14)))));
					weekInfoVO.setEmploymentInsuranceAccounts(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(15)))));
					weekInfoVO.setIndustrialInsuranceAccounts(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(16)))));
					weekInfoVO.setG(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(17)))));
					weekInfoVO.setAccountsScheduleCost(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(18)))));

					weekInfoVO.setAtchFileId(atchFileId);
					weekInfoVO.setCreatId(loginVO.getId());
					insertData.add(acountIdx, weekInfoVO);
					acountIdx++;
					bSeet0bWeekInfo = true;
					continue;
				}


				if(rowSize == 16) {			//주차별 정산내역 시트가 계속 바뀜????
					if(!bWeekHeader) {	//헤더 제외하기
						bWeekHeader = true;
						continue;
					}

					WeekInfoVO weekInfoVO = new WeekInfoVO();
					weekInfoVO.setWeekId(egovWeekIdGnrService.getNextStringId());
					weekInfoVO.setCooperatorId(cooperatorId);
					weekInfoVO.setAccountsStDt( simpleDateFormat.format(rowObj.getCell(1).getDateCellValue()) );
					weekInfoVO.setAccountsEdDt( simpleDateFormat.format(rowObj.getCell(2).getDateCellValue()) );
					weekInfoVO.setDeliveryCost(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(3)))));
					weekInfoVO.setAddAccounts(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(4)))));
					weekInfoVO.setOperatingCost(new BigDecimal( 0 ));
					weekInfoVO.setManagementCost(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(5)))));
					weekInfoVO.setOperatingFee(new BigDecimal( 0 ));
					weekInfoVO.setEtcCost(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(6)))));
					weekInfoVO.setTimeInsurance(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(7)))));
					weekInfoVO.setOwnerEmploymentInsurance(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(8)))));
					weekInfoVO.setRiderEmploymentInsurance(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(9)))));
					weekInfoVO.setOwnerIndustrialInsurance(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(10)))));
					weekInfoVO.setRiderIndustrialInsurance(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(11)))));
					weekInfoVO.setWithholdingTaxInsuranceSum(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(12)))));
					weekInfoVO.setEmploymentInsuranceAccounts(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(13)))));
					weekInfoVO.setIndustrialInsuranceAccounts(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(14)))));
					weekInfoVO.setG(new BigDecimal( 0 ));
					weekInfoVO.setAccountsScheduleCost(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(15)))));
					weekInfoVO.setAtchFileId(atchFileId);

					weekInfoVO.setWekAtchFileId(atchFileId);
					weekInfoVO.setCreatId(loginVO.getId());
					insertData.add(acountIdx, weekInfoVO);
					acountIdx++;
					bSeet0bWeekInfo = true;
					continue;
				}
//
//					// 주차별 정산내역을 못찾으면 세금계산서 내역을 찾을 필요가 없음
				if(!bSeet0bWeekInfo) {
					continue;
				}
//					// 3.세금계산서 내역
				if(rowSize == 4) {
					if(!bTaxHeader) {	//헤더 제외하기
						bTaxHeader = true;
						continue;
					}
					WeekInfoVO addTaxWeekInfoVO = insertData.get(taxIdx);
					addTaxWeekInfoVO.setTaxBillSupply(new BigDecimal( Util.getOnlyNumber(getValue(rowObj.getCell(1)))));
					addTaxWeekInfoVO.setTaxBillAdd(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(2)))));
					addTaxWeekInfoVO.setTaxBillSum(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(3)))));
					insertData.set(taxIdx, addTaxWeekInfoVO);
					taxIdx++;
				}
			}
		}


		//sheet를 모두 읽었는데 협력사 정보를 못찾으면 실패
		if(!bSeet0CooperatorInfo) {
			throw new IllegalArgumentException("협력사정보를 찾지 못했습니다.") ;
		}
		//sheet를 모두 읽었는데 주차별정산내역을 못찾으면 실패
		if(!bSeet0bWeekInfo) {
			throw new IllegalArgumentException("주차별정산내역을 찾지 못했습니다.") ;
		}


		//0번 sheet를 읽었으면 데이터를 DB에 isnert
		for(int i = 0 ; i < insertData.size() ; i++) {
			if(!dtyDAO.getAbleDateWeek(insertData.get(i))) {
				throw new IllegalArgumentException("협력사아이디, 정산시작일, 종료일이\n중복되는 파일이 이미 올라가 있습니다") ;
			}
			dtyDAO.insertWeekInfo(insertData.get(i));
		}
		return insertData;
	}

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
	public void insertExcelDataWeekRiderByWorkbook(Workbook excelDataBySheet, List<WeekInfoVO> weekGapji) throws Exception {

		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		List<WeekRiderInfoVO> insertData = new ArrayList<WeekRiderInfoVO>();
//		List<WeekPayVO> insertPayData = new ArrayList<WeekPayVO>();
		if(weekGapji== null || weekGapji.size() != 1 ) {
			throw new IllegalArgumentException("갑지 정산 데이터가 없거나 1개 협력사가 아닙니다.") ;
		}
		WeekInfoVO weekGapjiOne = weekGapji.get(0);


		Sheet worksheet = excelDataBySheet.getSheetAt(1);
//			List<List<String>> rows = sheet.getRows();

			//라이더 행 index를 가리킨다.
			int riderIdx = 0;

			for (int j = 0, rowIdx = 0; rowIdx < worksheet.getPhysicalNumberOfRows(); j++) {
//				List<String> row = rows.get(j);
				Row rowObj = worksheet.getRow(j);
				if(rowObj != null) {
					rowIdx++;
					int rowSize = this.getRowSize(rowObj);
					if(rowSize > 10) {
						LOGGER.debug("----------");
						if(riderIdx != 4) {		//헤더 제거용
							riderIdx++;
							continue;
						}

						if(rowSize == 27) {
							WeekRiderInfoVO weekRiderInfoVO = new WeekRiderInfoVO();
							weekRiderInfoVO.setWeekId(weekGapjiOne.getWeekId());
							weekRiderInfoVO.setNo(Integer.parseInt(getValue(rowObj.getCell(0)))+"");
							weekRiderInfoVO.setMberId(getValue(rowObj.getCell(1)));
							weekRiderInfoVO.setMberNm(getValue(rowObj.getCell(2)));
							weekRiderInfoVO.setCnt(Integer.parseInt(Util.getOnlyNumber(getValue(rowObj.getCell(3)))));
							weekRiderInfoVO.setDeliveryCost(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(4)))));
							weekRiderInfoVO.setAddCost(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(5)))));
							weekRiderInfoVO.setSumCost(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(6)))));
							weekRiderInfoVO.setTimeInsurance(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(7)))));
							weekRiderInfoVO.setNecessaryExpenses(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(8)))));
							weekRiderInfoVO.setPay(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(9)))));
							weekRiderInfoVO.setOwnerEmploymentInsurance(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(10)))));
							weekRiderInfoVO.setRiderEmploymentInsurance(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(11)))));
							weekRiderInfoVO.setOwnerIndustrialInsurance(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(12)))));
							weekRiderInfoVO.setRiderIndustrialInsurance(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(13)))));
							weekRiderInfoVO.setWithholdingTaxInsuranceSum(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(14)))));
							weekRiderInfoVO.setOwnerEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(15)))));
							weekRiderInfoVO.setRiderEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(16)))));
							weekRiderInfoVO.setSumEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(17)))));
							weekRiderInfoVO.setOwnerIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(18)))));
							weekRiderInfoVO.setRiderIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(19)))));
							weekRiderInfoVO.setSumIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(20)))));
							weekRiderInfoVO.setOperatingCost(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(21)))));
							weekRiderInfoVO.setAccountsCost(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(22)))));
							weekRiderInfoVO.setIncomeTax(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(23)))));
							weekRiderInfoVO.setResidenceTax(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(24)))));
							weekRiderInfoVO.setWithholdingTax(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(25)))));
							weekRiderInfoVO.setGivePay(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(26)))));
							weekRiderInfoVO.setCreatId(user.getId());
							insertData.add(weekRiderInfoVO);
						}
						if(rowSize == 26) {	//운영비가 빠졌음
							WeekRiderInfoVO weekRiderInfoVO = new WeekRiderInfoVO();
							weekRiderInfoVO.setWeekId(weekGapjiOne.getWeekId());
							weekRiderInfoVO.setNo((int)Double.parseDouble(getValue(rowObj.getCell(0)))+"");	//소수점을 무시하기 위해 더블로 변경
							weekRiderInfoVO.setMberId(getValue(rowObj.getCell(1)));
							weekRiderInfoVO.setMberNm(getValue(rowObj.getCell(2)));
							weekRiderInfoVO.setCnt(Integer.parseInt(Util.getOnlyNumber(getValue(rowObj.getCell(3)))));
							weekRiderInfoVO.setDeliveryCost(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(4)))));
							weekRiderInfoVO.setAddCost(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(5)))));
							weekRiderInfoVO.setSumCost(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(6)))));
							weekRiderInfoVO.setTimeInsurance(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(7)))));
							weekRiderInfoVO.setNecessaryExpenses(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(8)))));
							weekRiderInfoVO.setPay(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(9)))));
							weekRiderInfoVO.setOwnerEmploymentInsurance(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(10)))));
							weekRiderInfoVO.setRiderEmploymentInsurance(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(11)))));
							weekRiderInfoVO.setOwnerIndustrialInsurance(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(12)))));
							weekRiderInfoVO.setRiderIndustrialInsurance(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(13)))));
							weekRiderInfoVO.setWithholdingTaxInsuranceSum(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(14)))));
							weekRiderInfoVO.setOwnerEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(15)))));
							weekRiderInfoVO.setRiderEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(16)))));
							weekRiderInfoVO.setSumEmploymentInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(17)))));
							weekRiderInfoVO.setOwnerIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(18)))));
							weekRiderInfoVO.setRiderIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(19)))));
							weekRiderInfoVO.setSumIndustrialInsuranceAccounts(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(20)))));
							weekRiderInfoVO.setOperatingCost(new BigDecimal( 0 ));
							weekRiderInfoVO.setAccountsCost(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(21)))));
							weekRiderInfoVO.setIncomeTax(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(22)))));
							weekRiderInfoVO.setResidenceTax(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(23)))));
							weekRiderInfoVO.setWithholdingTax(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(24)))));
							weekRiderInfoVO.setGivePay(new BigDecimal(Util.getOnlyNumber(getValue(rowObj.getCell(25)))));
							weekRiderInfoVO.setCreatId(user.getId());
							insertData.add(weekRiderInfoVO);
						}

					}//end if
				}
			}//end for


		//1번 sheet를 읽었으면 데이터를 DB에 isnert
		for(int i = 0 ; i < insertData.size() ; i++) {
			WeekRiderInfoVO insertVO = insertData.get(i);
			dtyDAO.insertWeekRiderInfo(insertVO);

			insertMber(insertVO.getMberId(), insertVO.getMberNm(), weekGapjiOne.getCooperatorId(), user);

//			//주정산 입금 이력 데이터 세팅
//			WeekPayVO weekPayVO = new WeekPayVO();
//			weekPayVO.setWkpId(egovWkpIdGnrService.getNextStringId());
//			weekPayVO.setCooperatorId(weekGapjiOne.getCooperatorId());
//			weekPayVO.setMberId(insertVO.getMberId());
//			weekPayVO.setDwGubun("WEK");
//			weekPayVO.setIoGubun("1");		//입금
//			weekPayVO.setAblePrice(insertVO.getGivePay());
//			weekPayVO.setAccountsStDt(weekGapjiOne.getAccountsStDt());
//			weekPayVO.setAccountsEdDt(weekGapjiOne.getAccountsEdDt());
//			weekPayVO.setAtchFileId(weekGapjiOne.getAtchFileId());
//			weekPayVO.setWeekId(weekGapjiOne.getWeekId());
//			weekPayVO.setUseAt("Y");
//			weekPayVO.setCreatId(user.getId());
//			insertPayData.add(weekPayVO);
		}

		List<WeekPayVO> weekPayList = dtyDAO.selectWeekPay(weekGapjiOne);
		//주정산 입금 이력 데이터를 DB에 isnert
		for(int i = 0 ; i < weekPayList.size() ; i++) {
			WeekPayVO one = weekPayList.get(i);
			one.setWkpId(egovWkpIdGnrService.getNextStringId());
			one.setCreatId(user.getId());
			dtyDAO.insertWeekPay(one);
		}
		//일정산 입금이력을 정산 완료로 세팅 -- 협력사아이디, 기간으로 (TODO - 정합성체크 - 금액은 체크 않하나?)
		weekGapjiOne.setLastUpdusrId(user.getId());
		dtyDAO.updateDayPayWeekConfirm(weekGapjiOne);

		//미정산 선출금 출금이력조회하여 주정산 출금내역으로 insert
		List<WeekPayVO> dayPayListIoGubun2 = dtyDAO.selectDayPayIoGubn2List(weekGapjiOne);
		for(int i = 0 ; i < dayPayListIoGubun2.size() ; i++) {
			WeekPayVO one = dayPayListIoGubun2.get(i);
			one.setWkpId(egovWkpIdGnrService.getNextStringId());
			one.setCreatId(user.getId());
			dtyDAO.insertWeekPay(one);
		}
		//일정산 출금이력을 정산완료로 세팅
		weekGapjiOne.setLastUpdusrId(user.getId());
		dtyDAO.updateDayPayWeekConfirm2(weekGapjiOne);
	}

	/**
	 * 파일별 업로드 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DeliveryInfoVO> selectDeliveryInfoByAtchFileId(DeliveryInfoVO vo) throws Exception {
		return dtyDAO.selectDeliveryInfoByAtchFileId(vo);
	}

	/**
	 * 파일별 업로드 오류 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DeliveryErrorVO> selectDeliveryErrorByAtchFileId(DeliveryInfoVO vo) throws Exception {
		return dtyDAO.selectDeliveryErrorByAtchFileId(vo);
	}


	/**
	 * 파일별 업로드 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<WeekInfoVO> selectWeekInfoByAtchFileId(WeekInfoVO vo) throws Exception {
		return dtyDAO.selectWeekInfoByAtchFileId(vo);
	}

	/**
	 * 파일별 업로드 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<WeekRiderInfoVO> selectWeekRiderInfoByAtchFileId(WeekInfoVO vo) throws Exception {
		return dtyDAO.selectWeekRiderInfoByAtchFileId(vo);
	}
	/**
	 *  파일 업로드 현황 조회 / 주정산 파일
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<UploadStateVO> selectUploadStateInWeek(WeekInfoVO vo) throws Exception{
		return dtyDAO.selectUploadStateInWeek(vo);
	}
	/**
	 *  파일 업로드 현황 조회 / 일정산 파일
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<UploadStateVO> selectUploadStateInDay(WeekInfoVO vo) throws Exception{
		return dtyDAO.selectUploadStateInDay(vo);
	}

	/**
	 * 협력사 리스트 가져오기 (selectBox용도)
	 * @return
	 * @throws Exception
	 */
	public List<SearchKeyVO> selectCooperatorList(WeekInfoVO vo) throws Exception {
		return dtyDAO.selectCooperatorList(vo);
	}
	@SuppressWarnings("deprecation")
	private String getValue(Cell cell) {
		String value = null;
		switch (cell.getCellTypeEnum()) {
		case FORMULA:
//			value = cell.getCellFormula();
			if(cell.getCachedFormulaResultType() == Cell.CELL_TYPE_NUMERIC)
				value = cell.getNumericCellValue()+"";
			else value = cell.getRichStringCellValue().toString();
			break;
		case NUMERIC:
			//엑셀에는 소수점이 없을것을 확신함... 소수점이 나오면 getValue 함수를 다시 만들것..
			value = (int)Double.parseDouble(cell.getNumericCellValue()+"")+"";
			break;
		case STRING:
			value = cell.getStringCellValue()+"";
			break;
		case BLANK:
			value = null;
			break;
		case ERROR:
			value = null;
			break;
		}
		return value;
	}

	private int getRowSize(Row rowObj) {
		int rowSize = 0;
		//row의 실제 끝 사이즈를 구해야 함..
		for(int i = rowObj.getLastCellNum()-1 ; i >= 0 ; i--) {
			Cell cell = rowObj.getCell(i);
			if(cell != null) {
				String value;
				value = this.getValue(cell);
				if(value != null) {
					rowSize = i+1;
					break;
				};
			}
		}
		return rowSize;
	}

	/**
	 * 선출금 실행
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DoszTransferVO actDayPay(DayPayVO vo) throws Exception {
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
		MyInfoVO ablePrice = rotService.selectAblePrice(myInfoVO);
		if(!"Y".equals(ablePrice.getUseAt())) {
			throw new IllegalArgumentException("미사용 사용자로 출금 불가") ;
		}
		if(inputPrice+sendFee > ablePrice.getDayAblePrice() ) {
			throw new IllegalArgumentException("출금 가능 금액 초과") ;
		}

		//선지급 수수료 계산
		DayPayVO fee = new DayPayVO();
		fee.setMberId(user.getId());
		fee.setCooperatorId(vo.getCooperatorId());
		fee.setInputPrice(inputPrice);
		DayPayVO resultFee = rotDAO.selectDayFee(fee);

		int dayFee = resultFee.getDayFee();
		int insurance = 0;

		vo.setDypId(egovDypIdGnrService.getNextStringId());
		vo.setMberId(user.getId());
		vo.setDay(Util.getDay());
		vo.setIoGubun("2");			//출금
		vo.setDayFee(dayFee);		//선출금수수료
		vo.setInsurance(insurance);	//보험료
		vo.setSendFee(sendFee);		//이체수수료
		vo.setSendPrice(inputPrice);
		vo.setWeekYn("N");			//정산완료
		vo.setTranDay(tranDay);
		vo.setTelegramNo(telegramNo);
		vo.setUseAt("Y");
		vo.setCreatId(user.getId());
		dtyDAO.insertDayPay(vo);


		//수익 등록(선지급)
		ProfitVO fitVo = new ProfitVO();
		fitVo.setProfitId(egovFitIdGnrService.getNextStringId());
		fitVo.setCooperatorId(vo.getCooperatorId());//협력사
		fitVo.setMberId(user.getId());				//라이더ID
		fitVo.setGubun("D");						//선지급수수료
		fitVo.setCost(dayFee-resultFee.getFeeCooperatorCost()); //금액
		fitVo.setDypId(vo.getDypId());				//DYP_ID
		fitVo.setFeeId(resultFee.getFeeId());		//FEE_ID
		fitVo.setRiderFeeId(resultFee.getRiderFeeId());	//RIDER_FEE_ID
		fitVo.setCreatId(user.getId());
		dtyDAO.insertProfit(fitVo);

		//협력사 수익등록(선지급)
		ProfitVO citVo = new ProfitVO();
		citVo.setCoofitId(egovCitIdGnrService.getNextStringId());
		citVo.setProfitId(fitVo.getProfitId());
		citVo.setCooperatorId(vo.getCooperatorId());		//협력사
		citVo.setMberId(user.getId());						//라이더ID
		citVo.setGubun("D");								//선지급수수료
		citVo.setCost(resultFee.getFeeCooperatorCost());	//금액
		citVo.setDypId(vo.getDypId());						//DYP_ID
		citVo.setFeeId(resultFee.getFeeId());				//FEE_ID
		citVo.setRiderFeeId(resultFee.getRiderFeeId());		//RIDER_FEE_ID
		citVo.setCreatId(user.getId());
		dtyDAO.insertCooperatorProfit(citVo);


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
	 * 정산완료출금 실행
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DoszTransferVO actWekPay(WeekPayVO vo) throws Exception {

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
		MyInfoVO ablePrice = rotService.selectAblePrice(myInfoVO);
		if(!"Y".equals(ablePrice.getUseAt())) {
			throw new IllegalArgumentException("미사용 사용자로 출금 불가") ;
		}
		if(inputPrice+sendFee > ablePrice.getWeekAblePrice() ) {
			throw new IllegalArgumentException("출금 가능 금액 초과") ;
		}


		vo.setWkpId(egovWkpIdGnrService.getNextStringId());
		vo.setMberId(user.getId());
		vo.setDwGubun("WEK");
		vo.setIoGubun("2");
		vo.setFee(sendFee);
		vo.setSendPrice(new BigDecimal(inputPrice));
		vo.setTranDay(tranDay);
		vo.setTelegramNo(telegramNo);
		vo.setUseAt("Y");
		vo.setCreatId(user.getId());

		dtyDAO.insertWeekPay(vo);


		MyInfoVO bankInfo = rotService.selectMyInfo(myInfoVO);
		DoszTransferVO doszTransferVO = new DoszTransferVO();
		doszTransferVO.setTranDay(tranDay);
		doszTransferVO.setTelegram_no(telegramNo);
		doszTransferVO.setDrw_account_cntn(bankInfo.getAccountNm());		//출금계좌적요
		doszTransferVO.setRv_bank_code(bankInfo.getBnkCd());				//입금은행 코드
		doszTransferVO.setRv_account(bankInfo.getAccountNum());				//입금은행 계좌
		doszTransferVO.setRv_account_cntn("주식회사 다온플랜");					//입금은행 적요
		doszTransferVO.setAmount(vo.getSendPrice().toString());
		doszTransferVO.setRes_all_yn("y");
		doszTransferVO.setCreatId(user.getId());
		dtyDAO.insertTransfer(doszTransferVO);

		return doszTransferVO;
	}

	/**
	 * 라이더의 배달정보 조회(일별 입금 이력을 조회한다)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DayPayVO> selectRiderDayPayList(DayPayVO vo)throws Exception {
		return dtyDAO.selectRiderDayPayList(vo);
	}

	/**
	 * 나이스 토큰 생성, enc_data생성
	 * @return
	 * @throws Exception
	 */
	public NiceVO makeNiceEncData(HttpServletRequest request) throws Exception {

        // 토큰 생성 start
        String tURL = EgovProperties.getProperty("Globals.niceTokenUrl").trim();
        String uParam = EgovProperties.getProperty("Globals.uParam").trim();

        String client_id = EgovProperties.getProperty("Globals.clientId").trim();
        String secretKey = EgovProperties.getProperty("Globals.secretKey").trim();
        String productID = EgovProperties.getProperty("Globals.productID").trim();


        String Auth = Base64.getEncoder().encodeToString((client_id+":"+secretKey).getBytes());
        String responseData = testHttpRequest(tURL, uParam,Auth);
        LOGGER.debug("responseData "+responseData.toString());
        // {  "dataHeader": {    "CNTY_CD": "kr",    "GW_RSLT_CD": "1200",    "GW_RSLT_MSG": "오류 없음"  },  "dataBody": {    "rsp_cd": "P000",    "result_cd": "0000",    "site_code": "Q0cyMzI=",    "token_version_id": "2025062311392542-NCCDCG232-6HC5E-5813H0H32E",    "token_val": "CN5nvWbGJJBBfgsAKRbDPdaB+aOFHdVrG+Cu4+1ABrA=",    "period": 3600.0  }}
        //{  "dataHeader": {    "GW_RSLT_CD": "1702",    "GW_RSLT_MSG": "액세스가 허용되지 않습니다 - Client ID + Client IP"  },  "dataBody": ""}

        JSONParser jsonParse = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParse.parse(responseData);
        JSONObject dataHeader = (JSONObject) jsonParse.parse(jsonObj.get("dataHeader").toString());
        if(!"1200".equals((String)dataHeader.get("GW_RSLT_CD") )){
        	throw new IllegalArgumentException((String)dataHeader.get("GW_RSLT_MSG")) ;
        }
        JSONObject dataBody = (JSONObject) jsonParse.parse(jsonObj.get("dataBody").toString());

        String access_token= (String)dataBody.get("access_token");
        // 토큰 생성 end

        // enc_data 생성 start
        String returnURL = "https://"+request.getServerName()+EgovProperties.getProperty("Globals.niceReturnUrl").trim();


        SimpleDateFormat TestDate = new SimpleDateFormat("yyyyMMddhhmmss");
        String req_dtim = TestDate.format(new Date());
        String req_no="REQ"+req_dtim+Double.toString(Math.random()).substring(2,6);		// //요청고유번호(req_no)의 경우 업체 정책에 따라 거래 고유번호 설정 후 사용하면 됩니다.

        Date currentDate = new Date();
        long current_timestamp = currentDate.getTime() /1000;

        String Auth1 = Base64.getEncoder().encodeToString((access_token+":"+current_timestamp+":"+client_id).getBytes());
        tURL = EgovProperties.getProperty("Globals.niceEncUrl").trim();

        uParam="{\"dataHeader\":{\"CNTY_CD\":\"kr\"},"
                + "\"dataBody\":{\"req_dtim\":\""+req_dtim+"\","
                +"\"req_no\":\""+req_no+"\","
                +"\"enc_mode\":\"1\""
                + "}}";

        String responseData1 = testHttpRequest(tURL, uParam, Auth1, productID);
        LOGGER.debug("responseData1 "+responseData1.toString());

        String token_version_id = "";
        String sitecode = "";
        String token_val = "";
        JSONParser jsonParse1 = new JSONParser();
        JSONObject jsonObj1 = (JSONObject) jsonParse1.parse(responseData1);

        JSONObject dataBody1 = (JSONObject) jsonParse1.parse(jsonObj1.get("dataBody").toString());

        token_version_id = dataBody1.get("token_version_id").toString();
        sitecode = dataBody1.get("site_code").toString();
        token_val = dataBody1.get("token_val").toString();



        String result = req_dtim.trim()+req_no.trim()+token_val.trim();

        String resultVal = encryptSHA256(result);

        String key =resultVal.substring(0,16);
        String iv =resultVal.substring(resultVal.length()-16);
        String hmac_key =resultVal.substring(0,32);

        String plain ="{"
        +"\"requestno\":\""+req_no+"\","
        +"\"returnurl\":\""+returnURL+"\","
        +"\"sitecode\":\""+sitecode+"\""
        +"}";



        String enc_data = encryptAES(plain, key, iv);

        byte[] hmacSha256 = hmac256(hmac_key.getBytes(), enc_data.getBytes());
        String integrity = Base64.getEncoder().encodeToString(hmacSha256);

        //// enc_data 생성 end

        NiceVO returnVO = new NiceVO();
        returnVO.setToken_version_id(token_version_id);
        returnVO.setEnc_data(enc_data);
        returnVO.setIntegrity_value(integrity);
        returnVO.setReq_no(req_no);
        returnVO.setKey(key);
        returnVO.setIv(iv);
        returnVO.setHmac_key(hmac_key);
        return returnVO;
	}


	/**
	 * 나이스 최종 결과
	 * @return
	 * @throws Exception
	 */
	public NiceVO returnNiceData(NiceVO niceVO, HttpServletRequest request) throws Exception {

        LOGGER.debug("niceVO Enc_data : "+niceVO.getEnc_data());
        LOGGER.debug("niceVO Integrity : "+niceVO.getIntegrity_value());
        LOGGER.debug("niceVO Token_version_id : "+niceVO.getToken_version_id());
        String req_no = (String)request.getSession().getAttribute("req_no");
        String key = (String)request.getSession().getAttribute("key");
        String iv = (String)request.getSession().getAttribute("iv");
        String hmac_key = (String)request.getSession().getAttribute("hmac_key");
        String s_token_version_id = (String)request.getSession().getAttribute("token_version_id");
        String enc_data = request.getParameter("enc_data");
        String token_version_id = request.getParameter("token_version_id");
        String integrity_value = request.getParameter("integrity_value");


        String enctime ="";
        String requestno ="";
        String responseno ="";
        String authtype ="";
        String name ="";
        String birthdate = "";
        String gender ="";
        String nationalinfo="";
        String ci ="";
        String di ="";
        String mobileno ="";
        String mobileco ="";
        String sMessage ="";


        byte[] hmacSha256 = hmac256(hmac_key.getBytes(), enc_data.getBytes());
        String integrity = Base64.getEncoder().encodeToString(hmacSha256);

        if (!integrity.equals(integrity_value)){
            sMessage = "무결성 값이 다릅니다. 데이터가 변경된 것이 아닌지 확인 바랍니다.";
            niceVO.setResultMsg(sMessage);
            niceVO.setResultCode("fail");
            return niceVO;

        }else{

            String dec_data = getAesDecDataPKCS5(key.getBytes(), iv.getBytes(), enc_data);

            JSONParser jsonParse = new JSONParser();
            JSONObject plain_data = (JSONObject) jsonParse.parse(dec_data);

        	LOGGER.debug("plain_data : "+plain_data.toJSONString());

            if (!req_no.equals(plain_data.get("requestno").toString())){
                sMessage = "세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다.";
                niceVO.setResultMsg(sMessage);
                niceVO.setResultCode("fail");
                return niceVO;
            }else{
                sMessage = "복호화 성공";
                enctime =plain_data.get("enctime").toString();
                requestno =plain_data.get("requestno").toString();
                responseno =plain_data.get("responseno").toString();
                authtype =plain_data.get("authtype").toString();
                name = URLDecoder.decode(plain_data.get("utf8_name").toString(), "UTF-8");
                birthdate = plain_data.get("birthdate").toString();
                gender =plain_data.get("gender").toString();
                nationalinfo=plain_data.get("nationalinfo").toString();
                //ci =plain_data.get("ci").toString();
                di =plain_data.get("di").toString();
                mobileno =plain_data.get("mobileno").toString();
                mobileco =plain_data.get("mobileco").toString();
                niceVO.setResultMsg(sMessage);
                niceVO.setResultCode("success");
                Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
                if( isAuthenticated ) {
	                LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	                LOGGER.debug("nice★★★★★★★★name : "+name+"   ★★★★★★★★mobileno : "+mobileno);
	                LOGGER.debug("세션★★★★★★★★name : "+user.getName()+"   ★★★★★★★★mobileno : "+user.getMbtlnum());

	                MberManageVO vo = memDAO.selectMemberInfo(user.getId());
	                LOGGER.debug("재조회★★★★★★★★name : "+vo.getMberNm()+"   ★★★★★★★★mobileno : "+vo.getMbtlnum());

	                if(Util.isEmpty(vo.getMbtlnum())) {
	                	sMessage = "개인정보의 핸드폰번호를 확인할 수 없습니다\n\n핸드폰번호 등록 후 재시도 하시기바랍니다";
	                    niceVO.setResultMsg(sMessage);
	                    niceVO.setResultCode("fail");
	                }
	                if(!name.trim().equals(vo.getMberNm().trim()) || !mobileno.equals(Util.getOnlyNumber(vo.getMbtlnum()))) {
	                    sMessage = "사용자의 정보(이름, 핸드폰)가 다릅니다 \n\n요청을 취소합니다";
	                    niceVO.setResultMsg(sMessage);
	                    niceVO.setResultCode("fail");
	                }
                } else if(!Util.isEmpty(EgovStringUtil.isNullToString((String)request.getSession().getAttribute("mberId"))) ) {
                	MberManageVO vo = memDAO.selectMemberInfo(EgovStringUtil.isNullToString((String)request.getSession().getAttribute("mberId")));
	                LOGGER.debug("nice★★★★★★★★name : "+name+"   ★★★★★★★★mobileno : "+mobileno);
	                LOGGER.debug("재조회★★★★★★★★name : "+vo.getMberNm()+"   ★★★★★★★★mobileno : "+vo.getMbtlnum());
                	if(!name.trim().equals(vo.getMberNm().trim()) || !mobileno.equals(Util.getOnlyNumber(vo.getMbtlnum()))) {
	                    sMessage = "사용자의 정보(이름, 핸드폰)가 다릅니다 \n\n요청을 취소합니다";
	                    niceVO.setResultMsg(sMessage);
	                    niceVO.setResultCode("fail");
                	}
                } else {
                	LOGGER.debug("nice★★★★★★★★name : "+name+"   ★★★★★★★★mobileno : "+mobileno);
	                LOGGER.debug("기준정보 없음");
                    sMessage = "사용자의 정보(이름, 핸드폰)가 다릅니다 \n\n요청을 취소합니다.";
                    niceVO.setResultMsg(sMessage);
                    niceVO.setResultCode("fail");
                }
                return niceVO;
            }
        }
	}


    //http 통신을 위한 함수
    private String testHttpRequest(String targetURL, String parameters , String Auth) {
    HttpURLConnection connection = null;

        try {
            URL url = new URL(targetURL);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
            connection.setRequestProperty("Authorization","Basic "+Auth);
            connection.setDoOutput(true);
            DataOutputStream wr = new DataOutputStream (connection.getOutputStream());

            wr.writeBytes(parameters);
            wr.close();

            InputStream is = connection.getInputStream();

            BufferedReader rd = new BufferedReader(new InputStreamReader(is, "utf-8"));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = rd.readLine()) != null) {
                response.append(line);
                response.append('\r');
            }
            rd.close();
            return response.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }
    //http 통신을 위한 함수
    private String testHttpRequest(String targetURL, String parameters , String Auth, String productID) {
        HttpURLConnection connection = null;

        try {
            URL url = new URL(targetURL);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type","application/json");
            connection.setRequestProperty("Authorization","bearer "+Auth);
            connection.setRequestProperty("productID", productID);
            connection.setDoOutput(true);

            DataOutputStream wr = new DataOutputStream (connection.getOutputStream());

            wr.writeBytes(parameters);
            wr.close();
            InputStream is = connection.getInputStream();

            BufferedReader rd = new BufferedReader(new InputStreamReader(is, "utf-8"));

            StringBuilder response = new StringBuilder();
            String line;
            while ((line = rd.readLine()) != null) {
                response.append(line);
                response.append('\r');
            }
            rd.close();
            return response.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (connection != null) {
            connection.disconnect();
            }
        }
    }
    //DOZN http 통신을 위한 함수
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
            connection.setConnectTimeout(15000); // 연결 타임아웃 (15초)
            connection.setReadTimeout(15000);    // 읽기 타임아웃 (15초)
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
    //대칭키 생성을 위한 함수
    private String encryptSHA256(String result)throws NoSuchAlgorithmException{
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(result.getBytes());
        byte[] arrHashValue = md.digest();
        String resultVal = Base64.getEncoder().encodeToString(arrHashValue);

        return resultVal;
    }
    private String encryptAES(String reqData, String key, String iv)
            throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException,
            InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException{
        SecretKey secureKey = new SecretKeySpec(key.getBytes(), "AES");
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.ENCRYPT_MODE, secureKey, new IvParameterSpec(iv.getBytes()));
        byte[] encrypted = c.doFinal(reqData.trim().getBytes());
        String reqDataEnc =Base64.getEncoder().encodeToString(encrypted);

        return reqDataEnc;
    }
    //무결성값 생성을 위한 함수
    private byte[] hmac256(byte[] secretKey,byte[] message)
            throws NoSuchAlgorithmException, InvalidKeyException{
        byte[] hmac256 = null;
        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec sks = new SecretKeySpec(secretKey, "HmacSHA256");
        mac.init(sks);
        hmac256 = mac.doFinal(message);

        return hmac256;
      }
    //복호화를 위한 함수
    private String getAesDecDataPKCS5(byte[] key, byte[] iv, String base64Enc) throws Exception {
        SecretKey secureKey = new SecretKeySpec(key, "AES");
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.DECRYPT_MODE, secureKey, new IvParameterSpec(iv));
        byte[] cipherEnc = Base64.getDecoder().decode(base64Enc);

        String Dec = new String(c.doFinal(cipherEnc), "utf-8");

        return Dec;
    }

	/**
	 * 라이더 등록
	 * @param id
	 * @param nm
	 * @param cooperatorId
	 * @throws Exception
	 */
	public void insertMber(String id, String nm, String cooperatorId, LoginVO user) throws Exception {

    	//COMTNGNRLMBER 등록
        UserDefaultVO searchVO = new UserDefaultVO();
        searchVO.setSearchCondition("0");
        searchVO.setSearchKeyword(id);
        MberManageVO userOne = mberManageDAO.selectUserListRider(searchVO);
    	if( userOne != null ) {
//    		userOne.setMberNm(deliveryInfoVO.getRiderNm());
//    		mberManageDAO.updateMber(userOne);
    	} else {
    		MberManageVO voMem = new MberManageVO();
            voMem.setMberId(id);
            voMem.setMberNm(nm);
            voMem.setPassword("Daon2025!");
            voMem.setMberSttus("P");
            voMem.setMberConfirmAt("N");
    		String uniqId = mberManageService.insertMber(voMem);


        	//COMTNEMPLYRSCRTYESTBS 등록
            AuthorGroup authorGroup = new AuthorGroup();
            authorGroup.setUniqId(uniqId);
    		authorGroup.setAuthorCode("ROLE_USER");
    		authorGroup.setMberTyCode("USR01");
    		egovAuthorGroupService.insertAuthorGroup(authorGroup);

    	}



    	//RD_COOPERATOR_RIDER_CONNECT 등록
    	CooperatorVO coopConn = new CooperatorVO();
    	coopConn.setMberId(id);
    	coopConn.setCooperatorId(cooperatorId);
    	if(memDAO.selectCooperatorRiderConnectByMberId(coopConn).size() <= 0 ) {
    		String conId = egovConIdGnrService.getNextStringId();
    		coopConn.setConId(conId);
    		coopConn.setCreatId(user.getId());
    		coopConn.setFee(0);
    		if( userOne != null && !Util.isEmpty(userOne.getMbtlnum())) {
    			coopConn.setRegDt("YES");
    		}
    		memDAO.insertCooperatorRiderConnect(coopConn);
    	}
	}

	/**
	 * 이체 처리
	 * @param vo
	 * @throws Exception
	 */
	public DoszTransferVO transfer(DoszTransferVO vo) throws Exception {

		vo.setApi_key(EgovProperties.getProperty("Globals.apiKey"));
		vo.setOrg_code(EgovProperties.getProperty("Globals.orgCode"));
		ObjectMapper mapper = new ObjectMapper();
		String jsonStr = mapper.writeValueAsString(vo);

        String tURL = EgovProperties.getProperty("Globals.doznDevUrl")+"/crypto/rt/v1/transfer";

        LOGGER.debug("json : "+jsonStr);
        String responseData = doznHttpRequest(tURL, jsonStr, vo.getTranDay(), vo.getTelegram_no());
        LOGGER.debug("responseData1 : "+responseData);

        if(!Util.isEmpty(responseData)) {
	        JSONParser jsonParse = new JSONParser();
	        JSONObject jsonObj = (JSONObject) jsonParse.parse(responseData);

	        vo.setStatus(jsonObj.get("status").toString());
	        if("200".equals(vo.getStatus()) ) {
		        vo.setStatusCd(jsonObj.get("status_cd").toString());
		        vo.setSendDt(jsonObj.get("send_dt").toString());
		        vo.setSendTm(jsonObj.get("send_tm").toString());
		        vo.setNatvTrNo(jsonObj.get("natv_tr_no").toString());
	        } else {
		        vo.setErrorCode(jsonObj.get("error_code").toString());
		        vo.setErrorMessage(jsonObj.get("error_message").toString());
	        }
	        dtyDAO.updateTransfer(vo);
        }
        return vo;
	}

	/**
	 * 예금주조회
	 * @param vo
	 * @throws Exception
	 */
	public DoszSchAccoutVO schAcc(MyInfoVO vo) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        DoszSchAccoutVO doszSchAccoutVO = new DoszSchAccoutVO();

		String telegramNo = dtyDAO.selectTelegranNo();
		String tranDay = Util.getDay();

		doszSchAccoutVO.setApi_key(EgovProperties.getProperty("Globals.apiKey"));
		doszSchAccoutVO.setOrg_code(EgovProperties.getProperty("Globals.orgCode"));
		doszSchAccoutVO.setBank_code(vo.getBnkCd());					//은행 코드
		doszSchAccoutVO.setAccount(vo.getAccountNum());			//은행 계좌
		doszSchAccoutVO.setTranDay(tranDay);
		doszSchAccoutVO.setTelegram_no(telegramNo);
		doszSchAccoutVO.setAmount("0");
		doszSchAccoutVO.setRes_all_yn("y");
		doszSchAccoutVO.setCreatId(user.getId());
		dtyDAO.insertSchAccout(doszSchAccoutVO);

		ObjectMapper mapper = new ObjectMapper();
		String jsonStr = mapper.writeValueAsString(doszSchAccoutVO);

        String tURL = EgovProperties.getProperty("Globals.doznDevUrl")+"/crypto/rt/v1/inquireDepositor";

        LOGGER.debug("json : "+jsonStr);
        String responseData = doznHttpRequest(tURL, jsonStr, tranDay, telegramNo);
        LOGGER.debug("responseData1 : "+responseData);

        if(!Util.isEmpty(responseData)) {
	        JSONParser jsonParse = new JSONParser();
	        JSONObject jsonObj = (JSONObject) jsonParse.parse(responseData);
	        doszSchAccoutVO.setStatus(jsonObj.get("status").toString());

	        if("200".equals(doszSchAccoutVO.getStatus()) ) {
		        doszSchAccoutVO.setStatusCd(jsonObj.get("status_cd").toString());
		        doszSchAccoutVO.setSendDt(jsonObj.get("send_dt").toString());
		        doszSchAccoutVO.setSendTm(jsonObj.get("send_tm").toString());
		        doszSchAccoutVO.setNatvTrNo(jsonObj.get("natv_tr_no").toString());
		        doszSchAccoutVO.setDepositor(jsonObj.get("depositor").toString());
	        } else {
	        	doszSchAccoutVO.setErrorCode(jsonObj.get("error_code").toString());
	        	doszSchAccoutVO.setErrorMessage(jsonObj.get("error_message").toString());
	        }
	        dtyDAO.updateSchAccout(doszSchAccoutVO);
        }
		return doszSchAccoutVO;
	}

	/**
	 * 모계좌잔액조회
	 * @param vo
	 * @throws Exception
	 */
	public DoszSchAccoutCostVO schAccCost(MyInfoVO vo) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        DoszSchAccoutCostVO doszSchAccoutCostVO = new DoszSchAccoutCostVO();

		String telegramNo = dtyDAO.selectTelegranNo();
		String tranDay = Util.getDay();

		doszSchAccoutCostVO.setApi_key(EgovProperties.getProperty("Globals.apiKey"));
		doszSchAccoutCostVO.setOrg_code(EgovProperties.getProperty("Globals.orgCode"));
		doszSchAccoutCostVO.setTelegram_no(telegramNo);
		doszSchAccoutCostVO.setDrw_bank_code(EgovProperties.getProperty("Globals.bnkCd"));					//은행 코드
		doszSchAccoutCostVO.setRes_all_yn("y");
		doszSchAccoutCostVO.setCreatId(user.getId());

		ObjectMapper mapper = new ObjectMapper();
		String jsonStr = mapper.writeValueAsString(doszSchAccoutCostVO);

        String tURL = EgovProperties.getProperty("Globals.doznDevUrl")+"/crypto/rt/v1/balance/check ";

        LOGGER.debug("json : "+jsonStr);
        String responseData = doznHttpRequest(tURL, jsonStr, tranDay, telegramNo);
        LOGGER.debug("responseData1 : "+responseData);

        if(!Util.isEmpty(responseData)) {
	        JSONParser jsonParse = new JSONParser();
	        JSONObject jsonObj = (JSONObject) jsonParse.parse(responseData);
	        doszSchAccoutCostVO.setStatus(jsonObj.get("status").toString());

	        if("200".equals(doszSchAccoutCostVO.getStatus()) ) {
	        	doszSchAccoutCostVO.setStatusCd(jsonObj.get("status_cd").toString());
	        	doszSchAccoutCostVO.setSendDt(jsonObj.get("send_dt").toString());
	        	doszSchAccoutCostVO.setSendTm(jsonObj.get("send_tm").toString());
	        	doszSchAccoutCostVO.setNatvTrNo(jsonObj.get("natv_tr_no").toString());
	        	doszSchAccoutCostVO.setTrAfterBac(jsonObj.get("tr_after_bac").toString());
	        	doszSchAccoutCostVO.setTrAfterSign(jsonObj.get("tr_after_sign").toString());
	        } else {
	        	doszSchAccoutCostVO.setErrorCode(jsonObj.get("error_code").toString());
	        	doszSchAccoutCostVO.setErrorMessage(jsonObj.get("error_message").toString());
	        }
        }
		return doszSchAccoutCostVO;
	}
	/**
	 * 출금 내역 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<HistoryVO> selectHistory(HistoryVO vo)throws Exception {
		return dtyDAO.selectHistory(vo);
	}
	/**
	 * 출금 가능 내역 조회 (by mberId)
	 * @param mberId
	 * @return
	 * @throws Exception
	 */
	public List<DeliveryInfoVO> selectTakeDeliveryInfoListByMberId(DeliveryInfoVO vo) throws Exception{
		return dtyDAO.selectTakeDeliveryInfoListByMberId(vo);
	}

	/**
	 * 출금 실행된 일정산 입출금 출금건 use_at n로 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public void updateDayPayByTransfer(DoszTransferVO vo) throws Exception {
		dtyDAO.updateDayPayByTransfer(vo);
		dtyDAO.deleteProfit(vo);
		dtyDAO.deleteCooperatorProfit(vo);
	}

	/**
	 * 출금 실행된 주정산 입출금 출금건 use_at n로 세팅
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateWeekPayByTransfer(DoszTransferVO vo) throws Exception {
		return dtyDAO.updateWeekPayByTransfer(vo);
	}
}
