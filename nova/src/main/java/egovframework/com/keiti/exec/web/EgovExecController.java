package egovframework.com.keiti.exec.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.keiti.comm.service.TaskInfoVO;
import egovframework.com.keiti.exec.service.EgovExecInfoService;
import egovframework.com.keiti.exec.service.ExecInfoVO;

/**
 * 집행관리
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

@Controller
public class EgovExecController {

	@Resource(name = "EgovExecInfoService")
	private EgovExecInfoService execInfoService;

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertyService;

	@SuppressWarnings("unused")
	@Autowired
	private DefaultBeanValidator beanValidator;

	/**
	 * 집행내역 조회
	 *
	 * @param adbkVO
	 * @param status
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "집행내역 조회", order = 380, gid = 40)
	@RequestMapping("/exec/exec01010.do")
	public String exec01010(@ModelAttribute("searchVO") ExecInfoVO eiVO, HttpServletRequest request,
			ModelMap model) throws Exception {
		//LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (!isAuthenticated) {
			return "redirect:/uat/uia/egovLoginUsr.do";
		}
		return "egovframework/keiti/exec/exec01010";
	}
	/**
	 * 세부비목별 내역서
	 *
	 * @param adbkVO
	 * @param status
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "세부비목별 내역서", order = 380, gid = 40)
	@RequestMapping("/exec/exec02010.do")
	public String exec02010(@ModelAttribute("searchVO") ExecInfoVO siVO, HttpServletRequest request,
			ModelMap model) throws Exception {
		//LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (!isAuthenticated) {
			return "redirect:/uat/uia/egovLoginUsr.do";
		}
		return "egovframework/keiti/exec/exec02010";
	}
	/**
	 * 집행내역 조회
	 *
	 * @param adbkVO
	 * @param status
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "예실대비표", order = 380, gid = 40)
	@RequestMapping("/exec/exec03010.do")
	public String exec03010(@ModelAttribute("searchVO") ExecInfoVO siVO, HttpServletRequest request,
			ModelMap model) throws Exception {
		//LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (!isAuthenticated) {
			return "redirect:/uat/uia/egovLoginUsr.do";
		}
		return "egovframework/keiti/exec/exec03010";
	}
	/**
     * 세금계산서 화면 호출한다.
     *
     * @param adbkVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */
    @IncludedInfo(name="세금계산서", order = 380, gid = 40)
    @RequestMapping("/exec/exec04020.do")
    public String exec04020(@ModelAttribute("searchVO") ExecInfoVO eiVO, HttpServletRequest request, ModelMap model) throws Exception {
    	//LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (!isAuthenticated) {
			return "redirect:/uat/uia/egovLoginUsr.do";
		}
		TaskInfoVO taskInfoVO = (TaskInfoVO) request.getSession().getAttribute("taskVo");
		eiVO.setTaskNo(taskInfoVO.getTaskNo());
		Map<String, Object> taxInvInfo = execInfoService.selectTaxInvInfoList(eiVO);
		Map<String, Object> taxInvInfoItm = execInfoService.selectTaxInvItmInfoList(eiVO);

	    // taxInvInfo를 JSON으로 변환하여 뷰에 전달
	    ObjectMapper objectMapper = new ObjectMapper();
	    String taxInvInfoJson = objectMapper.writeValueAsString(taxInvInfo);
	    String taxInvInfoItmJson = objectMapper.writeValueAsString(taxInvInfoItm);
	    model.addAttribute("taxInvInfoJson", taxInvInfoJson);
	    model.addAttribute("taxInvInfoItmJson", taxInvInfoItmJson);

        return "egovframework/keiti/exec/exec04020";
    }
    /**
     * 정산증빙 화면 호출한다.
     *
     * @param adbkVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */
    @IncludedInfo(name="정산증빙", order = 380, gid = 40)
    @RequestMapping("/exec/exec04030.do")
    public String exec04030(@ModelAttribute("searchVO") ExecInfoVO eiVO, ModelMap model) throws Exception {
    	//LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
    	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    	if (!isAuthenticated) {
    		return "redirect:/uat/uia/egovLoginUsr.do";
    	}
    	model.addAttribute("execNo", eiVO.getExecNo());
    	return "egovframework/keiti/exec/exec04030";
    }
    /**
     * 공통서류 화면 호출한다.
     *
     * @param adbkVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */
    @IncludedInfo(name="공통서류", order = 380, gid = 40)
    @RequestMapping("/exec/exec04040.do")
    public String exec04040(@ModelAttribute("searchVO") TaskInfoVO tiVO, ModelMap model) throws Exception {
    	//LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
    	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    	if (!isAuthenticated) {
    		return "redirect:/uat/uia/egovLoginUsr.do";
    	}
    	return "egovframework/keiti/exec/exec04040";
    }

}
