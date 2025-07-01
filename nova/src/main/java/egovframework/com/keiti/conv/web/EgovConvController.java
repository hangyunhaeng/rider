package egovframework.com.keiti.conv.web;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.keiti.comm.service.EgovTaskInfoService;
import egovframework.com.keiti.comm.service.TaskInfoVO;

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

@Controller
public class EgovConvController {

	@Resource(name = "EgovTaskInfoService")
	private EgovTaskInfoService taskInfoService;

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertyService;

	@SuppressWarnings("unused")
	@Autowired
	private DefaultBeanValidator beanValidator;

    @PostConstruct
    public void start() throws Exception {

    }

	/**
	 * 협약상세정보 화면 호출
	 *
	 * @param adbkVO
	 * @param status
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "과세상세정보", order = 380, gid = 40)
	@RequestMapping("/conv/conv02410.do")
	public String conv02410(@ModelAttribute("searchVO") TaskInfoVO taskInfoVO, HttpServletRequest request,
			ModelMap model) throws Exception {

		TaskInfoVO existingTaskVo = (TaskInfoVO) request.getSession().getAttribute("taskVo");
		// taskVo가 null일 경우에만 세션에 저장
	    if (existingTaskVo == null) {
	        TaskInfoVO taskVo = taskInfoService.selectTaskInfoOne(taskInfoVO.getTaskNo());
	        request.getSession().setAttribute("taskVo", taskVo);
	    } else {
	        // 이미 세션에 존재하는 경우, 기존 taskVo를 반환
	    }

		return "egovframework/keiti/conv/conv02410";
	}
	/**
	 * 비목별예산 화면 호출
	 *
	 * @param adbkVO
	 * @param status
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "비목별예산", order = 380, gid = 40)
	@RequestMapping("/conv/conv02510.do")
	public String conv02510(@ModelAttribute("searchVO") TaskInfoVO taskInfoVO, HttpServletRequest request,
			ModelMap model) throws Exception {

		return "egovframework/keiti/conv/conv02510";
	}
	/**
	 * 계좌정보 화면 호출
	 *
	 * @param adbkVO
	 * @param status
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "계좌정보", order = 380, gid = 40)
	@RequestMapping("/conv/conv02610.do")
	public String conv02610(@ModelAttribute("searchVO") TaskInfoVO taskInfoVO, HttpServletRequest request,
			ModelMap model) throws Exception {

		return "egovframework/keiti/conv/conv02610";
	}
	/**
	 * 참여연구원 화면 호출
	 *
	 * @param adbkVO
	 * @param status
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "참여연구원", order = 380, gid = 40)
	@RequestMapping("/conv/conv02710.do")
	public String conv02710(@ModelAttribute("searchVO") TaskInfoVO taskInfoVO, HttpServletRequest request,
			ModelMap model) throws Exception {

		return "egovframework/keiti/conv/conv02710";
	}
}
