package egovframework.com.uat.uia.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.ComDefaultCodeVO;
import egovframework.com.cmm.EgovComponentChecker;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.config.EgovLoginConfig;
import egovframework.com.cmm.service.CmmnDetailCode;
import egovframework.com.cmm.service.EgovCmmUseService;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.com.utl.sim.service.EgovClntInfo;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

/*
import com.gpki.gpkiapi.cert.X509Certificate;
import com.gpki.servlet.GPKIHttpServletRequest;
import com.gpki.servlet.GPKIHttpServletResponse;
*/

/**
 * 일반 로그인, 인증서 로그인을 처리하는 컨트롤러 클래스
 * @author 공통서비스 개발팀 박지욱
 * @since 2009.03.06
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *  수정일		수정자		수정내용
 *  ----------	--------	---------------------------
 *  2009.03.06	박지욱		최초 생성
 *  2011.08.26	정진오		IncludedInfo annotation 추가
 *  2011.09.07	서준식		스프링 시큐리티 로그인 및 SSO 인증 로직을 필터로 분리
 *  2011.09.25	서준식		사용자 관리 컴포넌트 미포함에 대한 점검 로직 추가
 *  2011.09.27	서준식		인증서 로그인시 스프링 시큐리티 사용에 대한 체크 로직 추가
 *  2011.10.27	서준식		아이디 찾기 기능에서 사용자 리름 공백 제거 기능 추가
 *  2017.07.21	장동한		로그인인증제한 작업
 *  2018.10.26	신용호		로그인 화면에 message 파라미터 전달 수정
 *  2019.10.01	정진오		로그인 인증세션 추가
 *  2020.06.25	신용호		로그인 메시지 처리 수정
 *  2021.01.15	신용호		로그아웃시 권한 초기화 추가 : session 모드 actionLogout()
 *  2021.05.30	정진오		디지털원패스 처리하기 위해 로그인 화면에 인증방식 전달
 *  2022.11.11	김혜준		시큐어코딩 처리
 *  2023.06.09	김신해		NSR 보안조치 (GPKI 인증서 등록 OOB 방지)
 *
 *  </pre>
 */
@Controller
public class EgoRDLoginController {

	/** EgovLoginService */
	@Resource(name = "loginService")
	private EgovLoginService loginService;

	/** EgovCmmUseService */
	@Resource(name = "EgovCmmUseService")
	private EgovCmmUseService cmmUseService;

	/** EgovMessageSource */
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;

	@Resource(name = "egovLoginConfig")
	EgovLoginConfig egovLoginConfig;

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgoRDLoginController.class);

	/**
	 * 로그인 화면으로 들어간다
	 * @param vo - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */
	@IncludedInfo(name = "로그인", listUrl = "/com/com0003.do", order = 10, gid = 10)
	@RequestMapping(value = "/com/com0003.do")
	public String loginUsrView(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		if (EgovComponentChecker.hasComponent("mberManageService")) {
			model.addAttribute("useMemberManage", "true");
		}

		//권한체크시 에러 페이지 이동
		String auth_error =  request.getParameter("auth_error") == null ? "" : (String)request.getParameter("auth_error");
		if(auth_error != null && auth_error.equals("1")){
			return "egovframework/com/cmm/error/accessDenied";
		}

		String rootUrl = Util.getRootUrl(request.getSession());
		if(rootUrl == null)
			return "egovframework/com/cmm/error/accessDenied";



		/*
		GPKIHttpServletResponse gpkiresponse = null;
		GPKIHttpServletRequest gpkirequest = null;

		try{

			gpkiresponse=new GPKIHttpServletResponse(response);
		    gpkirequest= new GPKIHttpServletRequest(request);
		    gpkiresponse.setRequest(gpkirequest);
		    model.addAttribute("challenge", gpkiresponse.getChallenge());
		    return "egovframework/com/uat/uia/EgovLoginUsr";

		}catch(Exception e){
		    return "egovframework/com/cmm/egovError";
		}
		*/

		// 2021.05.30, 정진오, 디지털원패스 처리하기 위해 로그인 화면에 인증방식 전달
		String authType = EgovProperties.getProperty("Globals.Auth").trim();
		model.addAttribute("authType", authType);

		String message = (String)request.getParameter("loginMessage");
		if (message!=null) model.addAttribute("loginMessage", message);

		return "egovframework/"+rootUrl+"/com/com0003";
	}


	/**
	 * 일반(세션) 로그인을 처리한다
	 * @param vo - 아이디, 비밀번호가 담긴 LoginVO
	 * @param request - 세션처리를 위한 HttpServletRequest
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
	@RequestMapping(value = "/com/com0004.do")
	public String actionLogin(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, ModelMap model) throws Exception {

		String memberSe = null;

		// 1. 사용자 확인
		if(Util.isGnr()) memberSe = "GNR";
		else if(Util.isUsr()) memberSe = "USR";
		else {
			return "egovframework/com/cmm/error/accessDenied";
		}

		// 1. 로그인 처리
		loginVO.setUserSe(memberSe);
		LoginVO resultVO = loginService.actionLogin(loginVO);
		String userIp = EgovClntInfo.getClntIP(request);
		resultVO.setIp(userIp);

		// 2. 일반 로그인 처리
		// 2022.11.11 시큐어코딩 처리
		if (resultVO.getId() != null && !resultVO.getId().equals("")) {

			// 3-1. 로그인 정보를 세션에 저장
			request.getSession().setAttribute("loginVO", resultVO);
			// 2019.10.01 로그인 인증세션 추가
			request.getSession().setAttribute("accessUser", resultVO.getUserSe().concat(resultVO.getId()));

			return "redirect:/com/com0005.do";

		} else {
			model.addAttribute("loginMessage", egovMessageSource.getMessage("fail.common.login",request.getLocale()));
			return "redirect:/uat/uia/egovLoginUsr.do";
		}
	}


	/**
	 * 로그인 후 메인화면으로 들어간다
	 * @param
	 * @return 로그인 페이지
	 * @exception Exception
	 */
	@RequestMapping(value = "/com/com0005.do")
	public String actionMain(HttpServletRequest request,ModelMap model) throws Exception {

		// 1. Spring Security 사용자권한 처리
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (!isAuthenticated) {
			model.addAttribute("loginMessage", egovMessageSource.getMessage("fail.common.login"));
			return "redirect:/com/com0003.do";
		}
		LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		if (user.getIp().equals(""))
			user.setIp(EgovClntInfo.getClntIP(request));

		// 221116	김혜준	2022 시큐어코딩 조치
		LOGGER.debug("User Id : {}", EgovStringUtil.isNullToString(user.getId()));

		/*
		// 2. 메뉴조회
		MenuManageVO menuManageVO = new MenuManageVO();
		menuManageVO.setTmp_Id(user.getId());
		menuManageVO.setTmp_UserSe(user.getUserSe());
		menuManageVO.setTmp_Name(user.getName());
		menuManageVO.setTmp_Email(user.getEmail());
		menuManageVO.setTmp_OrgnztId(user.getOrgnztId());
		menuManageVO.setTmp_UniqId(user.getUniqId());
		List list_headmenu = menuManageService.selectMainMenuHead(menuManageVO);
		model.addAttribute("list_headmenu", list_headmenu);
		*/

		// 3. 메인 페이지 이동
		String main_page = Globals.MAIN_PAGE;

		LOGGER.debug("Globals.MAIN_PAGE > " + Globals.MAIN_PAGE);
		LOGGER.debug("main_page > {}", main_page);

		if (main_page.startsWith("/")) {
			return "forward:" + main_page;
		} else {
			return main_page;
		}

		/*
		if (main_page != null && !main_page.equals("")) {

			// 3-1. 설정된 메인화면이 있는 경우
			return main_page;

		} else {

			// 3-2. 설정된 메인화면이 없는 경우
			if (user.getUserSe().equals("USR")) {
				return "egovframework/com/EgovMainView";
			} else {
				return "egovframework/com/EgovMainViewG";
			}
		}
		*/
	}

}