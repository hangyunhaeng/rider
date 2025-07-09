package egovframework.com.rd.usr.web;

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
public class InqController {

    @Resource(name = "InqService")
    private InqService inqService;

	private static final Logger LOGGER = LoggerFactory.getLogger(InqController.class);


	/**
	 * 1:1문의 리트스 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/inq0001.do")
    public String inq0001(HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        return "egovframework/usr/inq/inq0001";
	}

	/**
	 * 1:1문의 리스트
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/inq0001_0001.do")
	public ResponseEntity<?> inq0001_0001(@ModelAttribute("InquiryVO") InquiryVO inquiryVO, HttpServletRequest request) throws Exception{

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
        inquiryVO.setSchUserSe(user.getUserSe());
        inquiryVO.setSchAuthorCode(user.getAuthorCode());
        inquiryVO.setSchId(user.getId());
        inquiryVO.setSchIhidNum(user.getIhidNum());

        map.put("cnt", inqService.selectInquiryListCnt(inquiryVO));
        map.put("list", inqService.selectInquiryList(inquiryVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 1:1문의 view 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/inq0001_0002.do")
    public ResponseEntity<?> inq0001_0002(@ModelAttribute("InquiryVO") InquiryVO inquiryVO, HttpServletRequest request,ModelMap model) throws Exception {

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
        inquiryVO.setSchAuthorCode(user.getAuthorCode());
        inquiryVO.setSchId(user.getId());

        map.put("list", inqService.selectInquiryListByInqId(inquiryVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 1:1문의 답변저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/inq0001_0003.do")
    public ResponseEntity<?> inq0001_0003(@ModelAttribute("InquiryVO") InquiryVO inquiryVO, HttpServletRequest request,ModelMap model) throws Exception {

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


        inquiryVO.setCreatId(user.getId());
        inquiryVO.setLastUpdusrId(user.getId());

        //총판 or 협력사
        inquiryVO.setSchAuthorCode(user.getAuthorCode());
        inquiryVO.setSchId(user.getId());

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
	@RequestMapping("/usr/inq0001_0004.do")
	public ResponseEntity<?> inq0001_0004(@ModelAttribute("InquiryVO") InquiryVO inquiryVO, HttpServletRequest request) throws Exception{

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
