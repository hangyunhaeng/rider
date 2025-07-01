package egovframework.com.cms.exc.web;

import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.keiti.comm.service.EgovTaskInfoService;
import egovframework.com.keiti.comm.service.TaskInfoVO;
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

@Controller
public class EgovSampleController {

    @Resource(name = "EgovTaskInfoService")
    private EgovTaskInfoService taskInfoService;

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
    @IncludedInfo(name="과제관리", order = 380, gid = 40)
    @RequestMapping("/cms/exc/selectstifList.do")
    public String selectTaskInfoList(@ModelAttribute("searchVO") TaskInfoVO adbkVO, ModelMap model) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
            return "redirect:/uat/uia/egovLoginUsr.do";
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

        model.addAttribute("resultList", map.get("resultList"));
        model.addAttribute("resultCnt", map.get("resultCnt"));
        model.addAttribute("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));
        model.addAttribute("paginationInfo", paginationInfo);

        return "egovframework/com/cms/exc/EgovTaskInfoList";
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
    @IncludedInfo(name="과제관리", order = 380, gid = 40)
    @RequestMapping("/cms/exc/selectstifList2.do")
    public String selectTaskInfoList2(@ModelAttribute("searchVO") TaskInfoVO adbkVO, ModelMap model) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
            return "redirect:/uat/uia/egovLoginUsr.do";
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

//        String a=(String)map.get("resultList");

        model.addAttribute("resultList", map.get("resultList"));
        model.addAttribute("resultCnt", map.get("resultCnt"));
        model.addAttribute("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));
        model.addAttribute("paginationInfo", paginationInfo);

        return "egovframework/com/cms/exc/EgovTaskInfoList2";
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
    @IncludedInfo(name="과제관리", order = 380, gid = 40)
    @RequestMapping("/cms/exc/selectstifList3.do")
    public String selectTaskInfoList3(@ModelAttribute("searchVO") TaskInfoVO adbkVO, ModelMap model) throws Exception {

        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
            return "redirect:/uat/uia/egovLoginUsr.do";
        }
        model.addAttribute("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

        return "egovframework/com/cms/exc/EgovTaskInfoList3";
    }
}
