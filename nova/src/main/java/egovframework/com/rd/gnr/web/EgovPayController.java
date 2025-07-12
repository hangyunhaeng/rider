package egovframework.com.rd.gnr.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.SessionVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.DtyService;
import egovframework.com.rd.usr.service.MemService;
import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.DeliveryInfoVO;
import egovframework.com.rd.usr.service.vo.EtcVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
import egovframework.com.sec.rgm.service.EgovAuthorGroupService;


/**
 * 라이더 Controller
 *
 * @author 한균행
 * @since 2025.04.18
 * @version 1.0
 * @see
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *  2025.04.25
 *      </pre>
 */
@Controller
public class EgovPayController {

	/** EgovPayController */
    @Resource(name = "egovAuthorGroupService")
    private EgovAuthorGroupService egovAuthorGroupService;

    @Resource(name = "DtyService")
    private DtyService dtyService;
    @Resource(name = "MemService")
    private MemService memService;

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovPayController.class);

	/**
	 * 출금 대상 페이지
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 */
	@RequestMapping("/gnr/pay0001.do")
	public String pay0001(HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

		// 1. 사용자 확인
		if(!Util.isGnr()) {
			return "egovframework/com/cmm/error/accessDenied";
        }
		return "egovframework/gnr/pay/pay0001";
	}

	/**
	 * 출금 대상 조회
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 */
	@RequestMapping("/gnr/pay0001_001.do")
	public ResponseEntity<?> pay0001_001(@ModelAttribute("DeliveryInfoVO") DeliveryInfoVO deliveryInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //출금 가능 내역 조회 (by mberId)
        deliveryInfoVO.setSearchId(user.getId());
        map.put("takeData", dtyService.selectTakeDeliveryInfoListByMberId(deliveryInfoVO));

        //출금 가능 총 금액 조회
        deliveryInfoVO.setSum(true);
        map.put("takeSumDeliveryPrice", dtyService.selectTakeDeliveryInfoListByMberId(deliveryInfoVO));


        map.put("resultCode", "success");
    	return ResponseEntity.ok(map);
	}

	/**
	 * 배달 정보 조회
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 */
	@RequestMapping("/gnr/pay0002.do")
	public String pay0002(SessionVO sessionVO, ModelMap model) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

		// 1. 사용자 확인
		if(!Util.isGnr()) {
			return "egovframework/com/cmm/error/accessDenied";
        }
		return "egovframework/gnr/pay/pay0002";
	}


	/**
	 * 출금 대상 조회
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 */
	@RequestMapping("/gnr/pay0002_001.do")
	public ResponseEntity<?> pay0002_001(@ModelAttribute("DayPayVO") DayPayVO dayPayVO, SessionVO sessionVO, ModelMap model) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        dayPayVO.setMberId(user.getId());

        map.put("list", dtyService.selectRiderDayPayList(dayPayVO));
        map.put("resultCode", "success");
    	return ResponseEntity.ok(map);
	}


	/**
	 * 출금 대상 페이지
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 */
	@RequestMapping("/gnr/pay0003.do")
	public String pay0003(HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

		// 1. 사용자 확인
		if(!Util.isGnr()) {
			return "egovframework/com/cmm/error/accessDenied";
        }
		return "egovframework/gnr/pay/pay0003";
	}


	/**
	 * 출금 내역 조회
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 */
	@RequestMapping("/gnr/pay0003_001.do")
	public ResponseEntity<?> pay0003_001(@ModelAttribute("HistoryVO") HistoryVO historyVO, HttpServletRequest request) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();


        //라이더 권한
        historyVO.setSchAuthorCode(user.getAuthorCode());
        historyVO.setSchId(user.getId());
        historyVO.setSearchCooperatorId((String)request.getSession().getAttribute("cooperatorId"));

        map.put("list", dtyService.selectHistory(historyVO));
        map.put("resultCode", "success");
    	return ResponseEntity.ok(map);
	}

	/**
	 * 대출 요청 리스트 페이지
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 */
	@RequestMapping("/gnr/pay0004.do")
	public String pay0004(@ModelAttribute("etcVO")EtcVO etcVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

		// 1. 사용자 확인
		if(!Util.isGnr()) {
			return "egovframework/com/cmm/error/accessDenied";
        }
        model.addAttribute("etcVO", etcVO);
		return "egovframework/gnr/pay/pay0004";
	}


	/**
	 * 대출 요청 리스트 조회
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 */
	@RequestMapping("/gnr/pay0004_001.do")
	public ResponseEntity<?> pay0004_001(@ModelAttribute("EtcVO") EtcVO etcVO, HttpServletRequest request) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();


        //라이더 권한
        etcVO.setSchAuthorCode(user.getAuthorCode());
        etcVO.setSchId(user.getId());

        etcVO.setMberId(user.getId());
        etcVO.setSearchGubun("RIDER");
        etcVO.setCooperatorId((String)request.getSession().getAttribute("cooperatorId"));

        map.put("list", memService.selectEtcList(etcVO));
        map.put("resultCode", "success");
    	return ResponseEntity.ok(map);
	}
}
