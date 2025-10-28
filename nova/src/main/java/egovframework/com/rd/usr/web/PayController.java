package egovframework.com.rd.usr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.support.SessionStatus;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.SessionVO;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.DtyService;
import egovframework.com.rd.usr.service.MemService;
import egovframework.com.rd.usr.service.PayService;
import egovframework.com.rd.usr.service.RotService;
import egovframework.com.rd.usr.service.vo.CooperatorPayVO;
import egovframework.com.rd.usr.service.vo.CooperatorVO;
import egovframework.com.rd.usr.service.vo.DoszDSResultVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.EtcVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
import egovframework.com.rd.usr.service.vo.KkoVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;
import egovframework.com.rd.usr.service.vo.ProfitVO;
//import net.sf.ehcache.Ehcache;
//import net.sf.ehcache.Element;

/**
 * 게시판
 *
 * @since 2025.05.19
 * @version 1.0
 * @see
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *  2025.05.19
 *      </pre>
 */

@Controller
public class PayController {



	@Resource(name="PayService")
	private PayService payService;
	@Resource(name="MemService")
	private MemService memService;
    @Resource(name = "RotService")
    private RotService rotService;
    @Resource(name = "DtyService")
    private DtyService dtyService;
//    @Resource(name="ehcache")
//    Ehcache gCache ;




	private static final Logger LOGGER = LoggerFactory.getLogger(DtyController.class);

	/**
	 * 입출금내역 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/pay0001.do")
    public String pay0001(@ModelAttribute("HistoryVO") HistoryVO historyVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        return "egovframework/usr/pay/pay0001";
	}



	/**
	 * 입출금내역 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0001_0001.do")
	public ResponseEntity<?> pay0001_0001(@ModelAttribute("HistoryVO") HistoryVO historyVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        historyVO.setSchAuthorCode(user.getAuthorCode());
        historyVO.setSchIhidNum(user.getIhidNum());

        List<HistoryVO> list = payService.selectPayList(historyVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 대사 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/pay0002.do")
    public String pay0002(HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        return "egovframework/usr/pay/pay0002";
	}

	/**
	 * 입출금내역 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0002_0001.do")
	public ResponseEntity<?> pay0002_0001(@ModelAttribute("DoszDSResultVO") DoszDSResultVO doszDSResultVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
//        doszDSResultVO.setSchAuthorCode(user.getAuthorCode());
//        doszDSResultVO.setSchIhidNum(user.getIhidNum());

        List<DoszDSResultVO> list = payService.selectDoznDs(doszDSResultVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 운영사 수익조회 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/pay0003.do")
    public String pay0003(@ModelAttribute("ProfitVO") ProfitVO profitVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

//        Ehcache cache = gCache.getCacheManager().getCache("commCd");
//        if(cache.get("exclus") == null) cache.put(new Element("exclus", rotService.selectExclusList()));
//		model.addAttribute("exclus", new ObjectMapper().writeValueAsString(cache.get("exclus").getObjectValue()));

        return "egovframework/usr/pay/pay0003";
	}


	/**
	 * 운영사 수익조회 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0003_0001.do")
	public ResponseEntity<?> pay0003_0001(@ModelAttribute("ProfitVO") ProfitVO profitVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        profitVO.setSchAuthorCode(user.getAuthorCode());
        profitVO.setSchIhidNum(user.getIhidNum());

        List<ProfitVO> list = payService.selectProfitList(profitVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 협력사 수익조회 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/pay0004.do")
    public String pay0004(@ModelAttribute("ProfitVO") ProfitVO profitVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        model.addAttribute("notMberId", EgovProperties.getProperty("Globals.cooperatorId"));
        return "egovframework/usr/pay/pay0004";
	}


	/**
	 * 협력사 수익조회 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0004_0001.do")
	public ResponseEntity<?> pay0004_0001(@ModelAttribute("ProfitVO") ProfitVO profitVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        profitVO.setSchAuthorCode(user.getAuthorCode());
        profitVO.setSchIhidNum(user.getIhidNum());

        List<ProfitVO> list = payService.selectCooperatorProfitList(profitVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 협력사 수익 계산근거 조회
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0004_0002.do")
	public ResponseEntity<?> pay0004_0002(@ModelAttribute("ProfitVO") ProfitVO profitVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        profitVO.setSchAuthorCode(user.getAuthorCode());
        profitVO.setSchIhidNum(user.getIhidNum());


        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", payService.selectCoopProfitFeeCoop(profitVO));
        map.put("riderList", payService.selectCoopProfitFeeRider(profitVO));
        map.put("base", payService.selectCoopProfitBase(profitVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 운영사 수익 계산근거 조회
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0004_0003.do")
	public ResponseEntity<?> pay0004_0003(@ModelAttribute("ProfitVO") ProfitVO profitVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        profitVO.setSchAuthorCode(user.getAuthorCode());
        profitVO.setSchIhidNum(user.getIhidNum());


        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", payService.selectProfitFeeCoop(profitVO));
        map.put("riderList", payService.selectProfitFeeRider(profitVO));
        map.put("base", payService.selectProfitBase(profitVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 영업사원 수익 계산근거 조회
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0004_0004.do")
	public ResponseEntity<?> pay0004_0004(@ModelAttribute("ProfitVO") ProfitVO profitVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        profitVO.setSchAuthorCode(user.getAuthorCode());
        profitVO.setSchIhidNum(user.getIhidNum());


        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", payService.selectSalesProfitFeeCoop(profitVO));
        map.put("riderList", payService.selectSalesProfitFeeRider(profitVO));
        map.put("base", payService.selectSalesProfitBase(profitVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}
	/**
	 * 협력사 기타(대여, 리스) 현황 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/pay0005.do")
    public String pay0005(@ModelAttribute("EtcVO") EtcVO etcVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        model.addAttribute("etcVO", etcVO);
        return "egovframework/usr/pay/pay0005";
	}


	/**
	 * 협력사 기타(대여, 리스) 현황 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0005_0001.do")
	public ResponseEntity<?> pay0005_0001(@ModelAttribute("EtcVO") EtcVO etcVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        etcVO.setSchUserSe(user.getUserSe());
        etcVO.setSchAuthorCode(user.getAuthorCode());
        etcVO.setSchIhidNum(user.getIhidNum());

        List<EtcVO> list = memService.selectEtcList(etcVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("cnt", memService.selectEtcListCnt(etcVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 협력사 기타(대여, 리스) 현황 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0005_0002.do")
	public ResponseEntity<?> pay0005_0002(@ModelAttribute("EtcVO") EtcVO etcVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        etcVO.setSchUserSe(user.getUserSe());
        etcVO.setSchAuthorCode(user.getAuthorCode());
        etcVO.setSchIhidNum(user.getIhidNum());

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", memService.selectEtcInputListByOperator(etcVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 협력사 출금내역 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/pay0006.do")
    public String pay0006(@ModelAttribute("MyInfoVO") MyInfoVO myInfoVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }



        //총판 or 협력사
        myInfoVO.setSchAuthorCode(user.getAuthorCode());
        myInfoVO.setSchIhidNum(user.getIhidNum());

		myInfoVO.setMberId(user.getId());
		myInfoVO.setSchUserSe(user.getUserSe());



	    // taxInvInfo를 JSON으로 변환하여 뷰에 전달
	    ObjectMapper objectMapper = new ObjectMapper();
	    Map<String, Object> ablePriceList = payService.cooperatorAblePrice(myInfoVO);
	    String ablePriceListJson = objectMapper.writeValueAsString(ablePriceList);

		model.addAttribute("sendFee", EgovProperties.getProperty("Globals.sendFee"));
		model.addAttribute("ablePriceList", ablePriceListJson);

		model.addAttribute("myInfoVO", rotService.selectMyInfo(myInfoVO));
        return "egovframework/usr/pay/pay0006";
	}


	/**
	 * 협력사 출금내역 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0006_0001.do")
	public ResponseEntity<?> pay0006_0001(@ModelAttribute("CooperatorPayVO") CooperatorPayVO cooperatorPayVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        cooperatorPayVO.setSchUserSe(user.getUserSe());
        cooperatorPayVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorPayVO.setSchIhidNum(user.getIhidNum());

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        List<CooperatorPayVO> list = payService.selectCooperatorPayList(cooperatorPayVO);
        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}


	/**
	 * 협력사 출금
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0006_0002.do")
	public ResponseEntity<?> pay0006_0002(@ModelAttribute("CooperatorPayVO") CooperatorPayVO cooperatorPayVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        cooperatorPayVO.setSchUserSe(user.getUserSe());
        cooperatorPayVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorPayVO.setSchIhidNum(user.getIhidNum());

        DoszTransferVO tran = null;
        try {

            tran = payService.cooperatorPay(cooperatorPayVO);

            // 이체 실행
            DoszTransferVO tranResult = dtyService.transfer(tran);

            if(Util.isEmpty(tranResult.getStatus())){	//응답없음
//            	dtyService.updateDayPayByTransfer(tranResult);
            }
            else {
            	if("400".equals(tranResult.getStatus()) && "VTIM".equals(tranResult.getErrorCode())) {	//은행timeout
            		// 배치에서 재처리
            	} else if("400".equals(tranResult.getStatus()) && "0011".equals(tranResult.getErrorCode())) {	//처리중
            		// 배치에서 재처리
            	} else if("999".equals(tranResult.getStatus())) {	//커넥센실패
            		// 배치에서 재처리
            	} else if("200".equals(tranResult.getStatus()) ){	//성공

            	} else {
            		payService.updateCooperatorPayByTransfer(tranResult);	//실패 확정시 거래내역 삭제
            	}
            }


    		//출금 가능금액 재조회
    		MyInfoVO myInfoVO = new MyInfoVO();
    		myInfoVO.setMberId(user.getId());
    		myInfoVO.setSearchCooperatorId(cooperatorPayVO.getCooperatorId());
    		myInfoVO.setSchUserSe(user.getUserSe());
    		myInfoVO.setSchIhidNum(user.getIhidNum());
    		myInfoVO.setSchAuthorCode(user.getAuthorCode());

    		map.put("ablePrice", payService.cooperatorAblePriceByCoopId(myInfoVO));
        	map.put("resultCode", "success");
        }catch(IllegalArgumentException e) {
        	if(tran != null) {
        		tran.setStatus("999");
        		dtyService.errorTransfer(tran);
        	}
			map.put("resultMsg", e.getMessage());
        	map.put("resultCode", "fail");
        }catch(Exception e) {
        	if(tran != null) {
        		tran.setStatus("999");
        		dtyService.errorTransfer(tran);
        	}
			map.put("resultMsg", e.toString());
        	map.put("resultCode", "fail");
        }
        return ResponseEntity.ok(map);
	}


	/**
	 * 알림톡 발송 조회
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/pay0007.do")
    public String pay0007(@ModelAttribute("KkoVO") KkoVO kkoVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        model.addAttribute("kkoVO", kkoVO);
        return "egovframework/usr/pay/pay0007";
	}


	/**
	 * 알림톡 발송 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0007_0001.do")
	public ResponseEntity<?> pay0007_0001(@ModelAttribute("KkoVO") KkoVO kkoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        kkoVO.setSchUserSe(user.getUserSe());
        kkoVO.setSchAuthorCode(user.getAuthorCode());
        kkoVO.setSchIhidNum(user.getIhidNum());

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

//        map.put("cnt", payService.selectKkoListCnt(kkoVO));
        map.put("list", payService.selectKkoList(kkoVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}


	/**
	 * 영업사원 출금내역 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/pay0008.do")
    public String pay0008(@ModelAttribute("MyInfoVO") MyInfoVO myInfoVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }



        //총판 or 협력사
        myInfoVO.setSchAuthorCode(user.getAuthorCode());
        myInfoVO.setSchIhidNum(user.getIhidNum());

		myInfoVO.setMberId(user.getId());
		myInfoVO.setEmplyrId(user.getId());
		myInfoVO.setSchUserSe(user.getUserSe());



	    // taxInvInfo를 JSON으로 변환하여 뷰에 전달
	    ObjectMapper objectMapper = new ObjectMapper();
	    Map<String, Object> ablePrice = payService.salesAblePrice(myInfoVO);
	    String ablePriceJson = objectMapper.writeValueAsString(ablePrice);

		model.addAttribute("sendFee", EgovProperties.getProperty("Globals.sendFee"));
		model.addAttribute("ablePrice", ablePriceJson);

		model.addAttribute("myInfoVO", rotService.selectMyInfo(myInfoVO));
        return "egovframework/usr/pay/pay0008";
	}


	/**
	 * 영업사원 출금내역 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0008_0001.do")
	public ResponseEntity<?> pay0008_0001(@ModelAttribute("CooperatorPayVO") CooperatorPayVO cooperatorPayVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        cooperatorPayVO.setSchUserSe(user.getUserSe());
        cooperatorPayVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorPayVO.setSchIhidNum(user.getIhidNum());
        cooperatorPayVO.setEmplyrId(user.getId());

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        List<CooperatorPayVO> list = payService.selectSalesPayList(cooperatorPayVO);
        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 협력사 출금
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0008_0002.do")
	public ResponseEntity<?> pay0008_0002(@ModelAttribute("CooperatorPayVO") CooperatorPayVO cooperatorPayVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        cooperatorPayVO.setSchUserSe(user.getUserSe());
        cooperatorPayVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorPayVO.setSchIhidNum(user.getIhidNum());

        DoszTransferVO tran = null;
        try {

            tran = payService.salesPay(cooperatorPayVO);

            // 이체 실행
            DoszTransferVO tranResult = dtyService.transfer(tran);

            if(Util.isEmpty(tranResult.getStatus())){	//응답없음
//            	dtyService.updateDayPayByTransfer(tranResult);
            }
            else {
            	if("400".equals(tranResult.getStatus()) && "VTIM".equals(tranResult.getErrorCode())) {	//은행timeout
            		// 배치에서 재처리
            	} else if("400".equals(tranResult.getStatus()) && "0011".equals(tranResult.getErrorCode())) {	//처리중
            		// 배치에서 재처리
            	} else if("999".equals(tranResult.getStatus())) {	//커넥센실패
            		// 배치에서 재처리
            	} else if("200".equals(tranResult.getStatus()) ){	//성공

            	} else {
            		payService.updateSalesPayByTransfer(tranResult);	//실패 확정시 거래내역 삭제
            	}
            }


    		//출금 가능금액 재조회
    		MyInfoVO myInfoVO = new MyInfoVO();
    		myInfoVO.setMberId(user.getId());
    		myInfoVO.setEmplyrId(user.getId());

    		map.put("ablePrice", payService.salesAblePriceOne(myInfoVO));
        	map.put("resultCode", "success");
        }catch(IllegalArgumentException e) {
        	if(tran != null) {
        		tran.setStatus("999");
        		dtyService.errorTransfer(tran);
        	}
			map.put("resultMsg", e.getMessage());
        	map.put("resultCode", "fail");
        }catch(Exception e) {
        	if(tran != null) {
        		tran.setStatus("999");
        		dtyService.errorTransfer(tran);
        	}
			map.put("resultMsg", e.toString());
        	map.put("resultCode", "fail");
        }
        return ResponseEntity.ok(map);
	}


	/**
	 * 영업사원 수익조회 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/pay0009.do")
    public String pay0009(@ModelAttribute("ProfitVO") ProfitVO profitVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        CooperatorVO cooperatorVO = new CooperatorVO();
        cooperatorVO.setSchAuthorCode("ROLE_SALES");
	    String salesListJson = new ObjectMapper().writeValueAsString(memService.selectEmplyrList(cooperatorVO));// taxInvInfo를 JSON으로 변환하여 뷰에 전달
		model.addAttribute("salesList", salesListJson);
        return "egovframework/usr/pay/pay0009";
	}


	/**
	 * 영업사원 수익조회 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/pay0009_0001.do")
	public ResponseEntity<?> pay0009_0001(@ModelAttribute("ProfitVO") ProfitVO profitVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        profitVO.setSchAuthorCode(user.getAuthorCode());
        profitVO.setSchIhidNum(user.getIhidNum());
        profitVO.setSearchId(user.getId());

        List<ProfitVO> list = payService.selectSalesProfitList(profitVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}
}
