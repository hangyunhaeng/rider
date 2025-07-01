package egovframework.com.keiti.comm.web;

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
import egovframework.com.keiti.comm.service.TaskInfoVO;

/**
 * 협약관리목록
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
public class EgovCommController {

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;

    @SuppressWarnings("unused")
	@Autowired
    private DefaultBeanValidator beanValidator;

     /**
     * 과제목록을 조회한다.
     *
     * @param adbkVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */
    @IncludedInfo(name="과제목록", order = 380, gid = 40)
    @RequestMapping("/comm/comm00800.do")
    public String comm00800(HttpServletRequest request,ModelMap model) throws Exception {
    	request.getSession().setAttribute("taskVo", null);
        return "egovframework/keiti/comm/comm00800";
    }
    /**
     * 협약과제변경 화면 호출한다.
     *
     * @param adbkVO
     * @param status
     * @param model
     * @return
     * @throws Exception
     */
    @IncludedInfo(name="과제목록", order = 380, gid = 40)
    @RequestMapping("/comm/comm00820.do")
    public String selectSbjt(@ModelAttribute("searchVO") TaskInfoVO adbkVO, ModelMap model) throws Exception {
        return "egovframework/keiti/comm/comm00820";
    }
}
