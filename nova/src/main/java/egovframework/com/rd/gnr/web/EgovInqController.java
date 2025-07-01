package egovframework.com.rd.gnr.web;


import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.slf4j.Logger;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.InqService;
import egovframework.com.rd.usr.service.vo.InquiryVO;

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
public class EgovInqController {


    @Resource(name = "InqService")
    private InqService inqService;

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovInqController.class);


	/**
	 * 1:1문의 리스트 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/gnr/inq0001.do")
    public String inq0001(@ModelAttribute("InquiryVO") InquiryVO inquiryVO, HttpServletRequest request,ModelMap model) throws Exception {

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
        model.addAttribute("inquiryVO", inquiryVO);
        return "egovframework/gnr/inq/inq0001";
	}

	/**
	 * 1:1문의 리스트
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gnr/inq0001_0001.do")
	public ResponseEntity<?> inq0001_0001(@ModelAttribute("InquiryVO") InquiryVO inquiryVO, HttpServletRequest request) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isGnr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //라이더 권한
        inquiryVO.setSchUserSe(user.getUserSe());
        inquiryVO.setSchAuthorCode(user.getAuthorCode());
        inquiryVO.setSchId(user.getId());

        inquiryVO.setCreatId(user.getId());
        inquiryVO.setLastUpdusrId(user.getId());

        map.put("cnt", inqService.selectInquiryListCnt(inquiryVO));
        map.put("list", inqService.selectGnrInquiryList(inquiryVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}


	/**
	 * 1:1문의 등록 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/gnr/inq0002.do")
    public String inq0002(@ModelAttribute("InquiryVO") InquiryVO inquiryVO, HttpServletRequest request,ModelMap model) throws Exception {

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
        model.addAttribute("inquiryVO", inquiryVO);
		model.addAttribute("one", inqService.selectInquiryByInqId(inquiryVO));
        return "egovframework/gnr/inq/inq0002";
	}


	/**
	 * 1:1문의 저장
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gnr/inq0002_0001.do")
	public ResponseEntity<?> inq0002_0001(@ModelAttribute("InquiryVO") InquiryVO inquiryVO, HttpServletRequest request) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isGnr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //라이더 권한
        inquiryVO.setSchUserSe(user.getUserSe());
        inquiryVO.setSchAuthorCode(user.getAuthorCode());
        inquiryVO.setSchId(user.getId());

        inquiryVO.setCreatId(user.getId());
        inquiryVO.setLastUpdusrId(user.getId());

        inqService.saveInquiry(inquiryVO);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 1:1문의 삭제
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gnr/inq0002_0002.do")
	public ResponseEntity<?> inq0002_0002(@ModelAttribute("InquiryVO") InquiryVO inquiryVO, HttpServletRequest request) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isGnr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //라이더 권한
        inquiryVO.setSchUserSe(user.getUserSe());
        inquiryVO.setSchAuthorCode(user.getAuthorCode());
        inquiryVO.setSchId(user.getId());

        inquiryVO.setCreatId(user.getId());
        inquiryVO.setLastUpdusrId(user.getId());

        inquiryVO.setUseAt("N");
        inqService.deleteInquiryByInqId(inquiryVO);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}
}
