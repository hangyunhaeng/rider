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
import egovframework.com.rd.usr.service.NotService;
import egovframework.com.rd.usr.service.vo.NoticeVO;

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
public class EgovNotController {


    @Resource(name = "NotService")
    private NotService notService;

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNotController.class);


	/**
	 * 공지사항 리트스 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/gnr/not0001.do")
    public String not0001(HttpServletRequest request,ModelMap model) throws Exception {

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
        return "egovframework/gnr/not/not0001";
	}

	/**
	 * 공지사항 리스트
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gnr/not0001_0001.do")
	public ResponseEntity<?> not0001_0001(@ModelAttribute("NoticeVO") NoticeVO noticeVO, HttpServletRequest request) throws Exception{

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
        noticeVO.setSchUserSe(user.getUserSe());
        noticeVO.setSchAuthorCode(user.getAuthorCode());

        noticeVO.setSearchId(user.getId());

        map.put("list", notService.selectNoticeViewList(noticeVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}


}
