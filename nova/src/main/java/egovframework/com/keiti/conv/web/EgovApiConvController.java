package egovframework.com.keiti.conv.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.keiti.comm.service.EgovTaskInfoService;
import egovframework.com.keiti.comm.service.TaskInfoVO;
import egovframework.com.keiti.conv.service.EgovConvInfoService;
import egovframework.com.utl.fcc.service.EgovStringUtil;

/**
 * 협약관리
 *
 * @author 조경규
 * @since 2024.07.15
 * @version 1.0
 * @see
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2024.7.15   조경규      최초 생성
 *      </pre>
 */

@RestController
public class EgovApiConvController {

	@Resource(name = "EgovTaskInfoService")
	private EgovTaskInfoService taskInfoService;

	@Resource(name = "EgovConvInfoService")
	private EgovConvInfoService convInfoService;

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertyService;

	@SuppressWarnings("unused")
	@Autowired
	private DefaultBeanValidator beanValidator;

    @PostConstruct
    public void start() throws Exception {

    }

	/**
	 * 협약상세정보 조회
	 *
	 * @param adbkVO
	 * @param status
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "과세상세정보(세션)", order = 380, gid = 40)
	@RequestMapping("/api/conv/conv02401.do")
	public ResponseEntity<?> conv02401(@RequestBody TaskInfoVO taskInfoVo, HttpServletRequest request,ModelMap model) throws Exception {

		TaskInfoVO taskVo = taskInfoService.selectTaskInfoOne(taskInfoVo.getTaskNo());
		request.getSession().setAttribute("taskVo", taskVo);

		return ResponseEntity.ok(taskVo);
	}

	/**
	 * 협약상세정보 조회
	 *
	 * @param adbkVO
	 * @param status
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "과세상세정보", order = 380, gid = 40)
	@RequestMapping("/api/conv/conv02402.do")
	public ResponseEntity<?> conv02402(@ModelAttribute("searchVO") TaskInfoVO taskInfoVo, HttpServletRequest request) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
		TaskInfoVO taskNo = (TaskInfoVO) request.getSession().getAttribute("taskVo");
		TaskInfoVO taskVo = taskInfoService.selectTaskInfoOne(taskNo.getTaskNo());

		Map<String, Object> map = new HashMap<>();

        map.put("taskVo", taskVo);

        map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

		return ResponseEntity.ok(map);
	}
	/**
     * 비목별예산 목록을 조회한다.
     *
     * @param adbkVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */

    @IncludedInfo(name="비목별예산", order = 380, gid = 40)
    @RequestMapping("/api/conv/conv02501.do")
    public ResponseEntity<?> conv02501(@RequestParam("bdgTp") String bdgTp, HttpServletRequest request) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        if(bdgTp == null || "".equals(bdgTp)) {
        	bdgTp="01";
        }
        TaskInfoVO taskVo = (TaskInfoVO) request.getSession().getAttribute("taskVo");
        Map<String, Object> map = convInfoService.selectIoeBdgInfoList(taskVo.getTaskNo(),bdgTp);


        //String a=(String)map.get("resultList");

        map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

        return ResponseEntity.ok(map);

    }
    /**
     * 출연재원별 예산 목록을 조회한다.
     *
     * @param adbkVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */

    @IncludedInfo(name="재원별예산", order = 380, gid = 40)
    @RequestMapping("/api/conv/conv02502.do")
    public ResponseEntity<?> conv02502(@RequestParam("fndTp") String fndTp, HttpServletRequest request) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        TaskInfoVO taskVo = (TaskInfoVO) request.getSession().getAttribute("taskVo");
        Map<String, Object> map = convInfoService.selectFndBdgInfoList(taskVo.getTaskNo(),fndTp);



        map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

        return ResponseEntity.ok(map);

    }
    /**
     * 연구비 수령계좌 / 정산환수금 반납계좌 조회
     *
     * @param request
     * @return
     * @throws Exception
     */

    @IncludedInfo(name="계좌정보", order = 380, gid = 40)
    @RequestMapping("/api/conv/conv02601.do")
    public ResponseEntity<?> conv02601(HttpServletRequest request) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        TaskInfoVO taskVo = (TaskInfoVO) request.getSession().getAttribute("taskVo");
        Map<String, Object> map = convInfoService.selectActInfoList(taskVo.getTaskNo());


        //String a=(String)map.get("resultList");

        map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

        return ResponseEntity.ok(map);

    }
	/**
     * 참여연구원 목록을 조회한다.
     *
     * @param adbkVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */

    @IncludedInfo(name="참여연구원조회", order = 380, gid = 40)
    @RequestMapping("/api/conv/conv02701.do")
    public ResponseEntity<?> conv02701(@ModelAttribute("searchVO") TaskInfoVO taskInfoVo, HttpServletRequest request) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        TaskInfoVO taskVo = (TaskInfoVO) request.getSession().getAttribute("taskVo");
        Map<String, Object> map = convInfoService.selectPartInfoList(taskVo.getTaskNo());
//        int totCnt = Integer.parseInt((String)map.get("resultCnt"));


        map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

        return ResponseEntity.ok(map);

    }
}
