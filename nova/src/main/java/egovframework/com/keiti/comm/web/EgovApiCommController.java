package egovframework.com.keiti.comm.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.keiti.comm.service.EgovCommService;
import egovframework.com.keiti.comm.service.EgovTaskInfoService;
import egovframework.com.keiti.comm.service.TaskInfoVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;

/**
 * 협약관리
 *
 * @author 조경규
 * @since 2024.07.15
 * @version 1.0
 * @see
 *
 *      수정일 수정자 수정내용 ------- -------- --------------------------- 2024.7.15 조경규
 *      최초 생성
 *      </pre>
 */

@RestController
public class EgovApiCommController {

	//private static final Logger logger = LoggerFactory.getLogger(EgovApiCommController.class);

    @Resource(name = "EgovTaskInfoService")
    private EgovTaskInfoService taskInfoService;

    @Resource(name = "EgovCommService")
    private EgovCommService CommService;

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertyService;

	@SuppressWarnings("unused")
	@Autowired
	private DefaultBeanValidator beanValidator;

	/**
     * 과제정보 목록을 조회한다.
     *
     * @param taskInfoVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */

    @IncludedInfo(name="과제목록", order = 380, gid = 40)
    @RequestMapping("/api/comm/comm00801.do")
    public ResponseEntity<?> comm00801(@ModelAttribute("searchVO") TaskInfoVO taskInfoVO) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

//        taskInfoVO.setPageUnit(propertyService.getInt("pageUnit"));
//        taskInfoVO.setPageSize(propertyService.getInt("pageSize"));

        PaginationInfo paginationInfo = new PaginationInfo();

        paginationInfo.setCurrentPageNo(taskInfoVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(taskInfoVO.getPageUnit());
        paginationInfo.setPageSize(taskInfoVO.getPageSize());

        taskInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        taskInfoVO.setLastIndex(paginationInfo.getLastRecordIndex());
        taskInfoVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        if ("01".equals(taskInfoVO.getSrcOpt())) {
            taskInfoVO.setSrcOptValue(taskInfoVO.getSrcOptValue().replace("-", ""));
        }

        Map<String, Object> map = taskInfoService.selectTaskInfoList(taskInfoVO);
        int totCnt = Integer.parseInt((String)map.get("resultCnt"));


        paginationInfo.setTotalRecordCount(totCnt);

        //String a=(String)map.get("resultList");

        map.put("paginationInfo", paginationInfo);
        map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

        return ResponseEntity.ok(map);

    }
	/**
     * 과제정보(1개)을 조회한다.
     *
     * @param taskInfoVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */
/*
    @IncludedInfo(name="과제정보", order = 380, gid = 40)
    @RequestMapping("/api/comm/comm00802.do")
    public ResponseEntity<?> comm00802(@ModelAttribute("searchVO") TaskInfoVO taskInfoVO) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }


        TaskInfoVO taskOne = taskInfoService.selectTaskInfoOne(taskInfoVO.getTaskNo());

        Map<String, Object> map = new HashMap<>();

        map.put("taskInfoVO", taskOne);
        map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

        return ResponseEntity.ok(map);

    }
    */
	/**
	 * 세목 조회
	 *
	 * @param eiVO
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "세목 조회", order = 380, gid = 40)
	@RequestMapping("/api/comm/comm09901.do")
	public ResponseEntity<?> comm09901(@ModelAttribute TaskInfoVO siVO, HttpServletRequest request) throws Exception {

			LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if (!isAuthenticated) {
				return ResponseEntity.status(401).body("Unauthorized");
			}

			TaskInfoVO taskInfoVO = (TaskInfoVO) request.getSession().getAttribute("taskVo");
			siVO.setTaskNo(taskInfoVO.getTaskNo());

			Map<String, Object> map = CommService.selectIoeInfoList(siVO);
			map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

			return ResponseEntity.ok(map);
	}
	/**
	 * 사업조회
	 *
	 * @param eiVO
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "사업 조회", order = 380, gid = 40)
	@RequestMapping("/api/comm/comm09902.do")
	public ResponseEntity<?> comm09902(@ModelAttribute TaskInfoVO siVO) throws Exception {

			LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if (!isAuthenticated) {
				return ResponseEntity.status(401).body("Unauthorized");
			}

			//Map<String, Object> map = CommService.selectIoeInfoList(siVO);
			Map<String, Object> map = CommService.selectBizInfoList(siVO);

			map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

			return ResponseEntity.ok(map);
	}
}
