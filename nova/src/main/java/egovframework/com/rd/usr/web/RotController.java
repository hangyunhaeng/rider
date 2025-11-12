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
import egovframework.com.rd.usr.service.NotService;
import egovframework.com.rd.usr.service.StsService;
import egovframework.com.rd.usr.service.vo.InquiryVO;
import egovframework.com.rd.usr.service.vo.NoticeVO;
import egovframework.com.rd.usr.service.vo.StsVO;

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
public class RotController {


    @Resource(name = "NotService")
    private NotService notService;
    @Resource(name = "InqService")
    private InqService inqService;
    @Resource(name = "StsService")
    private StsService stsService;

	private static final Logger LOGGER = LoggerFactory.getLogger(RotController.class);


	/**
	 * 공지사항 리트스 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/rot0001.do")
    public String rot0001(HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        return "egovframework/usr/rot/rot0001";
	}

	/**
	 * 공지사항 리스트
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/rot0001_0001.do")
	public ResponseEntity<?> rot0001_0001(@ModelAttribute("NoticeVO") NoticeVO noticeVO, HttpServletRequest request) throws Exception{

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
        noticeVO.setSchUserSe(user.getUserSe());
        noticeVO.setSchAuthorCode(user.getAuthorCode());
        noticeVO.setSchId(user.getId());
        noticeVO.setSearchGubun("MAIN");

        InquiryVO inquiryVO = new InquiryVO();
        inquiryVO.setSchUserSe(user.getUserSe());
        inquiryVO.setSchAuthorCode(user.getAuthorCode());
        inquiryVO.setSchId(user.getId());
        inquiryVO.setSearchGubun("MAIN");

        map.put("list", notService.selectNoticeViewList(noticeVO));
        map.put("inqList", inqService.selectInquiryList(inquiryVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 다른 통계 리스트
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/rot0001_0002.do")
	public ResponseEntity<?> rot0001_0002(@ModelAttribute("StsVO") StsVO stsVO, HttpServletRequest request) throws Exception{

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
        stsVO.setSchUserSe(user.getUserSe());
        stsVO.setSchAuthorCode(user.getAuthorCode());
        stsVO.setSchIhidNum(user.getIhidNum());
        stsVO.setSchId(user.getId());

        map.put("profitList", stsService.selectCooperatorProfitStsList(stsVO));
        map.put("DeliveryCntList", stsService.selectCooperatorDeliveryCntStsList(stsVO));
        map.put("payList", stsService.selectSts0004(stsVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}


}
