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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.SessionVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.MemService;
import egovframework.com.rd.usr.service.PayService;
import egovframework.com.rd.usr.service.vo.DoszDSResultVO;
import egovframework.com.rd.usr.service.vo.EtcVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
import egovframework.com.rd.usr.service.vo.ProfitVO;

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
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
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
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
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
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
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
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
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
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
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
	 * 협력사 기타(대여, 리스) 현황 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/pay0005.do")
    public String pay0004(@ModelAttribute("EtcVO") EtcVO etcVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
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
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}
}
