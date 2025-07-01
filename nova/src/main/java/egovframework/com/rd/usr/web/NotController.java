package egovframework.com.rd.usr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.slf4j.Logger;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.SessionVO;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;
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
public class NotController {

	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil fileUtil;
    @Resource(name = "NotService")
    private NotService notService;
    /** ID Generation */
	@Resource(name="egovNotIdGnrService")
	private EgovIdGnrService egovNotIdGnrService;

	private static final Logger LOGGER = LoggerFactory.getLogger(NotController.class);


	/**
	 * 공지사항 리트스 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/not0001.do")
    public String not0001(@ModelAttribute("NoticeVO") NoticeVO noticeVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        model.addAttribute("noticeVO", noticeVO);
        return "egovframework/usr/not/not0001";
	}

	/**
	 * 공지사항 리스트
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/not0001_0001.do")
	public ResponseEntity<?> not0001_0001(@ModelAttribute("NoticeVO") NoticeVO noticeVO, HttpServletRequest request) throws Exception{

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
        noticeVO.setSchAuthorCode(user.getAuthorCode());
        noticeVO.setSchId(user.getId());

        map.put("cnt", notService.selectNoticeListCnt(noticeVO));
        map.put("list", notService.selectNoticeList(noticeVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}




	/**
	 * 공지사항 수정 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/not0002.do")
    public String not0002(@ModelAttribute("NoticeVO") NoticeVO noticeVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        model.addAttribute("noticeVO", noticeVO);
        return "egovframework/usr/not/not0002";
	}

    /**
     * 섬머에디터 이미지업로드
     * @param multiRequest
     * @param request
     * @param sessionVO
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping("/usr/not0002_0001.do")
    public ResponseEntity<?> not0002_0001(final MultipartHttpServletRequest multiRequest, HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{


    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }


    	List<FileVO> result = null;
    	final Map<String, MultipartFile> files = multiRequest.getFileMap();
    	String imgName = new String();
    	if(!files.isEmpty()) {
    		String sPath = "Globals.imgStorePath";
    		if(Util.isDev()) {
    			sPath = "Globals.imgDevStorePath";
    		}
    		result = fileUtil.parseFileInf(files, "img_", 0, "", sPath, user.getId());
    		if(result.size() >0) {
    			imgName = result.get(0).getStreFileNm();
    		}
    	}

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();
        map.put("name", imgName);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}
	/**
	 * 공지사항 저장
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/not0002_0002.do")
	public ResponseEntity<?> not0002_0002(@ModelAttribute("NoticeVO") NoticeVO noticeVO, HttpServletRequest request) throws Exception{

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



        noticeVO.setCreatId(user.getId());
        noticeVO.setLastUpdusrId(user.getId());

        //총판 or 협력사
        noticeVO.setSchAuthorCode(user.getAuthorCode());
        noticeVO.setSchId(user.getId());

        if(Util.isEmpty(noticeVO.getNotId())) {
        	String notId = egovNotIdGnrService.getNextStringId();
        	noticeVO.setNotId(notId);
        	notService.insertNotice(noticeVO);
        } else {

        	if(!"Y".equals(notService.selectNoticeByNotId(noticeVO).getModifyAuth())) {
            	map.put("resultCode", "fail");
            	map.put("resultMsg", "권한이 없어 수정할 수 없습니다.");
                return ResponseEntity.ok(map);
        	}
        	notService.updateNotice(noticeVO);
        }

        map.put("one", noticeVO);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}
	/**
	 * 공지사항 view
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/not0002_0003.do")
	public ResponseEntity<?> not0002_0003(@ModelAttribute("NoticeVO") NoticeVO noticeVO, HttpServletRequest request) throws Exception{

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
        noticeVO.setSchAuthorCode(user.getAuthorCode());
        noticeVO.setSchId(user.getId());

        map.put("one", notService.selectNoticeByNotId(noticeVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}
	/**
	 * 공지사항 삭제
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/not0002_0004.do")
	public ResponseEntity<?> not0002_0004(@ModelAttribute("NoticeVO") NoticeVO noticeVO, HttpServletRequest request) throws Exception{

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

        noticeVO.setUseAt("N");
        noticeVO.setLastUpdusrId(user.getId());

        //총판 or 협력사
        noticeVO.setSchAuthorCode(user.getAuthorCode());
        noticeVO.setSchId(user.getId());

    	if(!"Y".equals(notService.selectNoticeByNotId(noticeVO).getModifyAuth())) {
        	map.put("resultCode", "fail");
        	map.put("resultMsg", "권한이 없어 삭제할 수 없습니다.");
            return ResponseEntity.ok(map);
    	}

        notService.deleteNoticeByNotId(noticeVO);

        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}


	/**
	 * 공지사항 view
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/not0003.do")
    public String not0003(@ModelAttribute("NoticeVO") NoticeVO noticeVO, HttpServletRequest request,ModelMap model) throws Exception {

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
        noticeVO.setSchAuthorCode(user.getAuthorCode());
        noticeVO.setSchId(user.getId());

        model.addAttribute("noticeVO", noticeVO);
        model.addAttribute("one", notService.selectNoticeByNotId(noticeVO));
        return "egovframework/usr/not/not0003";
	}

}
