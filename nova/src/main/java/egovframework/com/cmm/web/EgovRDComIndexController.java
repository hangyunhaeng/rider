package egovframework.com.cmm.web;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.MemService;
import egovframework.com.uss.umt.service.MberManageVO;

/**
 * 화면에 표시할 정보를 처리하는 Controller 클래스
 * <Notice>
 * 		개발시 메뉴 구조가 잡히기 전에 배포파일들에 포함된 공통 컴포넌트들의 목록성 화면에
 * 		URL을 제공하여 개발자가 편하게 활용하도록 하기 위해 작성된 것으로,
 * 		실제 운영되는 시스템에서는 적용해서는 안 됨
 *      실 운영 시에는 삭제해서 배포해도 좋음
 * <Disclaimer>
 * 		운영시에 본 컨트롤을 사용하여 메뉴를 구성하는 경우 성능 문제를 일으키거나
 * 		사용자별 메뉴 구성에 오류를 발생할 수 있음
 * @author 공통컴포넌트 정진오
 * @since 2025.04.07
 * @version 1.0.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *  수정일		  수정자		수정내용
 *  ----------   --------   ---------------------------
 *  2025.04.07   한균행		최초 생성
 * </pre>
 */

@Controller
public class EgovRDComIndexController {

	@Autowired
	private ApplicationContext applicationContext;


	@Resource(name = "MemService")
	private MemService memService;

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovRDComIndexController.class);


	/**
	 * index
	 * @param model
	 * @return
	 */
	@RequestMapping("/com/com0001.do")
	public String com0001(HttpServletRequest request, HttpServletResponse response, ModelMap model) {


		String rootUrl = Util.getRootUrl(request.getSession());
		if(rootUrl == null)
			return "egovframework/com/cmm/error/accessDenied";

		model.addAttribute("isReal", Util.isReal());
		return "egovframework/"+rootUrl+"/com/com0001";
	}



	@RequestMapping("/com/com0002.do")
	public String com0002(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {


		String rootUrl = Util.getRootUrl(request.getSession());
		if(rootUrl == null)
			return "egovframework/com/cmm/error/accessDenied";


		// 1. 로그인한 유저가 패스워드 재등록 할수 있도록 유도 하는 페이지로 이동

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(loginVO != null) {
			MberManageVO memberVo;
			if(!Util.isUsr(request.getSession())) {	//라이더 페이지
				memberVo = memService.selectMemberInfo(loginVO.getId());
			} else {								//관리자 페이지
				memberVo = memService.selectUserInfo(loginVO.getId());
			}
			if(!"Y".equals(memberVo.getMberConfirmAt())) {

				// 1.1 다음페이지의 비밀번호 변경시 사용할 아이디를 저장한다.
				request.getSession().setAttribute("mberId", memberVo.getMberId());
				request.getSession().setAttribute("uniqId", memberVo.getUniqId());
				request.getSession().setAttribute("mberNm", memberVo.getMberNm());


				return "egovframework/"+rootUrl+"/com/com0009";
			}
		}


		return "egovframework/"+rootUrl+"/com/com0002";
	}

}
