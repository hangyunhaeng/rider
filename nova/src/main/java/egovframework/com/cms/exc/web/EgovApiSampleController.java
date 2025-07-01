package egovframework.com.cms.exc.web;

import java.util.Map;

import javax.annotation.Resource;

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
import egovframework.com.keiti.comm.service.EgovTaskInfoService;
import egovframework.com.keiti.comm.service.TaskInfoVO;
import egovframework.com.keiti.exec.service.EgovExecInfoService;
import egovframework.com.keiti.exec.service.ExecInfoVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;

/**
 * 주소록정보를 관리하기 위한 컨트롤러 클래스
 * @author 공통컴포넌트팀 윤성록
 * @since 2009.09.25
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.9.25   윤성록      최초 생성
 *   2011.8.26	 정진오		 IncludedInfo annotation 추가
 *   2016.12.13  최두영      클래스명 변경
 *   2022.11.11  김혜준      시큐어코딩 처리
 * </pre>
 */

@RestController
public class EgovApiSampleController {

    @Resource(name = "EgovTaskInfoService")
    private EgovTaskInfoService taskInfoService;

    @Resource(name = "EgovExecInfoService")
    private EgovExecInfoService execInfoService;

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;

    @SuppressWarnings("unused")
	@Autowired
    private DefaultBeanValidator beanValidator;


    /**
     * 과제정보 목록을 조회한다.
     *
     * @param adbkVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */

    @IncludedInfo(name="과제관리2", order = 380, gid = 40)
    @RequestMapping("/api/cms/exc/selectstifList4.do")
    public ResponseEntity<?> selectTaskInfoList4(@ModelAttribute("searchVO") TaskInfoVO adbkVO) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        adbkVO.setPageUnit(propertyService.getInt("pageUnit"));
        adbkVO.setPageSize(propertyService.getInt("pageSize"));

        PaginationInfo paginationInfo = new PaginationInfo();

        paginationInfo.setCurrentPageNo(adbkVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(adbkVO.getPageUnit());
        paginationInfo.setPageSize(adbkVO.getPageSize());

        adbkVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        adbkVO.setLastIndex(paginationInfo.getLastRecordIndex());
        adbkVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        Map<String, Object> map = taskInfoService.selectTaskInfoList(adbkVO);
        int totCnt = Integer.parseInt((String)map.get("resultCnt"));


        paginationInfo.setTotalRecordCount(totCnt);

        //String a=(String)map.get("resultList");

        map.put("paginationInfo", paginationInfo);
        map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

        return ResponseEntity.ok(map);

    }
    /**
     * 과제정보 목록을 조회한다.
     *
     * @param adbkVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */

    @IncludedInfo(name="과제관리2", order = 380, gid = 40)
    @RequestMapping("/api/cms/exc/selectstifList5.do")
    public ResponseEntity<?> selectTaskInfoList5(@ModelAttribute("searchVO") TaskInfoVO adbkVO) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        adbkVO.setPageUnit(propertyService.getInt("pageUnit"));
        adbkVO.setPageSize(propertyService.getInt("pageSize"));

        PaginationInfo paginationInfo = new PaginationInfo();

        paginationInfo.setCurrentPageNo(adbkVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(adbkVO.getPageUnit());
        paginationInfo.setPageSize(adbkVO.getPageSize());

        adbkVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        adbkVO.setLastIndex(paginationInfo.getLastRecordIndex());
        adbkVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        Map<String, Object> map = taskInfoService.selectTaskInfoList(adbkVO);
        int totCnt = Integer.parseInt((String)map.get("resultCnt"));


        paginationInfo.setTotalRecordCount(totCnt);

        //String a=(String)map.get("resultList");

        map.put("paginationInfo", paginationInfo);
        map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

        return ResponseEntity.ok(map);

    }
	/**
	 * 집행내역 조회
	 *
	 * @param eiVO
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "과세상세 정보", order = 380, gid = 40)
	@RequestMapping("/api/cms/exc/exec01001.do")
	public ResponseEntity<?> exec01001(@ModelAttribute("searchVO") ExecInfoVO eiVO) throws Exception {

		@SuppressWarnings("unused")
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(!isAuthenticated) {
			return ResponseEntity.status(401).body("Unauthorized");
		}

		eiVO.setPageUnit(propertyService.getInt("pageUnit"));
		eiVO.setPageSize(propertyService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();

		paginationInfo.setCurrentPageNo(eiVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(eiVO.getPageUnit());
		paginationInfo.setPageSize(eiVO.getPageSize());

		eiVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		eiVO.setLastIndex(paginationInfo.getLastRecordIndex());
		eiVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());


		return ResponseEntity.ok("");
	}
}
