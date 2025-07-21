package egovframework.com.rd.gnr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.com.cmm.SessionVO;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.DtyService;
import egovframework.com.rd.usr.service.MemService;
import egovframework.com.rd.usr.service.vo.DeliveryInfoVO;
import egovframework.com.rd.usr.service.vo.NiceVO;
import egovframework.com.rd.usr.service.vo.WeekPayVO;
import egovframework.com.rd.usr.web.DtyController;
import egovframework.com.sec.rgm.service.AuthorGroup;
import egovframework.com.sec.rgm.service.EgovAuthorGroupService;
import egovframework.com.uss.umt.service.EgovMberManageService;
import egovframework.com.uss.umt.service.EgovUserManageService;
import egovframework.com.uss.umt.service.MberManageVO;
import egovframework.com.uss.umt.service.UserManageVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.com.utl.sim.service.EgovFileScrty;


/**
 * 라이더 Controller
 *
 * @author 한균행
 * @since 2025.04.18
 * @version 1.0
 * @see
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *  2025.04.18
 *      </pre>
 */
@Controller
public class EgovRdrController {

	/** EgovLoginService */
	@Resource(name = "MemService")
	private MemService memService;

    @Resource(name = "DtyService")
    private DtyService dtyService;

	@Resource(name = "userManageService")
	EgovUserManageService userManageService;

    /** mberManageService */
    @Resource(name = "mberManageService")
    private EgovMberManageService mberManageService;

    @Resource(name = "egovAuthorGroupService")
    private EgovAuthorGroupService egovAuthorGroupService;

	private static final Logger LOGGER = LoggerFactory.getLogger(DtyController.class);

	/**
	 * 라이더 아이디 찾는 페이지
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 */
	@RequestMapping("/com/com0006.do")
	public String com0006(HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{
		String memberSe = null;

		// 1. 사용자 확인
		if(!Util.isGnr(request.getSession()))
			return "egovframework/com/cmm/error/accessDenied";

		return "egovframework/gnr/com/com0006";
	}

	/**
	 * 라이더 아이디 찾는 페이지
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 */
	@RequestMapping("/com/com0006_0001.do")
	public ResponseEntity<?> com0006_0001(@RequestParam("mberId") String mberId, HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

		// 1. 사용자 확인
		if(!Util.isGnr(request.getSession()))
			return ResponseEntity.status(401).body("Unauthorized");

		// 2. 아이디가 일정산 테이블에 있는지 조회
		DeliveryInfoVO vo = new DeliveryInfoVO();
		vo.setMberId(mberId);
		List<DeliveryInfoVO> deliveryInofList = memService.selectDeliveryInfoByMberId(vo);

		if(deliveryInofList.size() <= 0) {
			map.put("resultCode", "failVoid");
			map.put("resultMessage", "정산 정보에 해당 아이디가 존재하지 않습니다. <br/><br/>현재 배달의 민족에서 데이터가 이관되어 있지 않을 수 있으니 잠시 후 시도하시거나 운영사에게 문의 바랍니다.");
			return ResponseEntity.ok(map);
		}


		// 3. 기등록된 사용자면 알림 후 로그인 페이지로 이동 (패스워드를 찾을 수 있도록 이동?)
		if(memService.selectMemberInfo(mberId) != null) {
			map.put("resultCode", "failReg");
			map.put("resultMessage", "이미 등록된 등록된 사용자입니다.<br/><br/>패스워드를 확인하여 로그인 하시기 바랍니다.");
			return ResponseEntity.ok(map);
		}

		// 4. 다음페이지의 비밀번호 등록시 사용할 아이디를 저장한다.
		request.getSession().setAttribute("mberId", mberId);
		request.getSession().setAttribute("mberNm", deliveryInofList.get(0).getRiderNm());
		map.put("resultCode", "success");
		return ResponseEntity.ok(map);
	}

	/**
	 * 비밀번호 등록페이지
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/com/com0007.do")
	public String com0007(HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{

		// 1. 사용자 확인
		if(!Util.isGnr(request.getSession()))
			return "egovframework/com/cmm/error/accessDenied";

		return "egovframework/gnr/com/com0007";
	}

	/**
	 * 비밀번호 등록
	 * @param password
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/com/com0007_0001.do")
	public ResponseEntity<?> com0007_0001(@ModelAttribute("mberManageVO") MberManageVO mberManageVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        String mberId = (String)request.getSession().getAttribute("mberId");
        String mberNm = (String)request.getSession().getAttribute("mberNm");
		// 1. 사용자 확인
		if(!Util.isGnr(request.getSession()))
			return ResponseEntity.status(401).body("Unauthorized");

		// 2. 기등록된 사용자면 알림 후 로그인 페이지로 이동 (패스워드를 찾을 수 있도록 이동?)
		if(memService.selectMemberInfo(mberId) != null) {
			map.put("resultCode", "failReg");
			map.put("resultMessage", "이미 등록된 등록된 사용자입니다.<br/><br/>패스워드를 확인하여 로그인 하시기 바랍니다.");
		}

		// 3. 회원가입

        // 가입상태 초기화
        mberManageVO.setMberSttus("P");
        // 그룹정보 초기화
        mberManageVO.setGroupId(null);
        mberManageVO.setMberId(mberId);
        mberManageVO.setMberNm(mberNm);
        mberManageVO.setMberConfirmAt("Y");
        // 일반회원가입신청 등록시 일반회원등록기능을 사용하여 등록한다.
        mberManageService.insertMber(mberManageVO);

        AuthorGroup authorGroup = new AuthorGroup();
        authorGroup.setUniqId(mberManageVO.getUniqId());
		authorGroup.setAuthorCode("ROLE_USER");
		authorGroup.setMberTyCode("USR01");
		egovAuthorGroupService.insertAuthorGroup(authorGroup);

		map.put("resultCode", "success");
		return ResponseEntity.ok(map);
	}

	/**
	 * 비밀번호 찾기페이지
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/com/com0008.do")
	public String com0008(HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{

		// 1. 사용자 확인
		if(!Util.isGnr(request.getSession()))
			return "egovframework/com/cmm/error/accessDenied";

		return "egovframework/gnr/com/com0008";
	}

	/**
	 * 기등록된 사용자 정보 확인
	 * @param mberId
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/com/com0008_0001.do")
	public ResponseEntity<?> com0008_0001(@RequestParam("mberId") String mberId, HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

		// 1. 사용자 확인
		if(!Util.isGnr(request.getSession()))
			return ResponseEntity.status(401).body("Unauthorized");


		// 2. 기등록된 사용자면 알림 후 로그인 페이지로 이동 (패스워드를 찾을 수 있도록 이동?)
		MberManageVO member = memService.selectMemberInfo(mberId);
		if(member == null || Util.isEmpty(member.getMberId())) {
			map.put("resultCode", "failReg");
			map.put("resultMessage", "등록되지 않은 사용자입니다.<br/><br/>등록된 라이더만 사용하실 수 있습니다<br/>협력사에 문의하시기 바랍니다");
			return ResponseEntity.ok(map);
		}
		if(member == null || Util.isEmpty(member.getMbtlnum())) {
			map.put("resultCode", "failReg");
			map.put("resultMessage", "핸드폰번호가 등록되어 있지 않습니다<br/>협력사에 문의하시기 바랍니다");
			return ResponseEntity.ok(map);
		}

		// 3. 다음페이지의 비밀번호 변경시 사용할 아이디를 저장한다.
		request.getSession().setAttribute("mberId", mberId);
		request.getSession().setAttribute("uniqId", member.getUniqId());
		request.getSession().setAttribute("mberNm", member.getMberNm());
		map.put("resultCode", "success");
		return ResponseEntity.ok(map);
	}

	/**
	 * 비밀번호 변경 페이지
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/com/com0009.do")
	public String com0009(HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{

		// 1. 사용자 확인
		if(!Util.isGnr(request.getSession()))
			return "egovframework/com/cmm/error/accessDenied";

		return "egovframework/gnr/com/com0009";
	}

	/**
	 * 비밀번호 변경
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/com/com0009_0001.do")
	public ResponseEntity<?> com0009_0001(@ModelAttribute("mberManageVO") MberManageVO mberManageVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model) throws Exception{

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

		// 1. 라이더
		if(Util.isGnr(request.getSession())) {

			//최초등록 사용자의 패스워드 변경시 pass인증 않태움 .. 일단은
			MberManageVO vo = memService.selectMemberInfo(EgovStringUtil.isNullToString((String)request.getSession().getAttribute("mberId")));

	    	if(Util.isReal() && "Y".equals( vo.getMberConfirmAt())) {
	        	if(Util.isEmpty((String)request.getSession().getAttribute("niceSuccess"))) {
	    			throw new IllegalArgumentException("PASS 미인증으로 변경 불가") ;
	        	}
	        	if(!"success".equals((String)request.getSession().getAttribute("niceSuccess"))) {
	    			throw new IllegalArgumentException("PASS 미인증으로 변경 불가") ;
	        	}
	    	}

	        request.getSession().removeAttribute("req_no");
	        request.getSession().removeAttribute("key");
	        request.getSession().removeAttribute("iv");
	        request.getSession().removeAttribute("hmac_key");
	        request.getSession().removeAttribute("token_version_id");
	        request.getSession().removeAttribute("niceSuccess");

			// 2. 비밀번호 변경
		    mberManageVO.setUniqId((String)request.getSession().getAttribute("uniqId"));
	        mberManageVO.setPassword(EgovFileScrty.encryptPassword(mberManageVO.getPassword(), EgovStringUtil.isNullToString((String)request.getSession().getAttribute("mberId"))));
	        mberManageVO.setMberConfirmAt("Y");
	        mberManageService.updatePasswordSelf(mberManageVO);
		}

		// 1. 관리자
		if(Util.isUsr(request.getSession())) {
//			MberManageVO vo = memService.selectUserInfo(EgovStringUtil.isNullToString((String)request.getSession().getAttribute("mberId")));

			// 2. 비밀번호 변경
			UserManageVO userManageVO = new UserManageVO();
			userManageVO.setUniqId((String)request.getSession().getAttribute("uniqId"));
			userManageVO.setPassword(EgovFileScrty.encryptPassword(mberManageVO.getPassword(), EgovStringUtil.isNullToString((String)request.getSession().getAttribute("mberId"))));
			userManageService.updatePassword(userManageVO);

		}


        request.getSession().removeAttribute("mberId");
        request.getSession().removeAttribute("uniqId");
        request.getSession().removeAttribute("mberNm");

		map.put("resultCode", "success");
		return ResponseEntity.ok(map);
	}


	/**
	 * 나이스 토큰 가져오기
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/com/com0010_0000.do")
    public ResponseEntity<?> com0010_0000(@ModelAttribute("WeekPayVO") WeekPayVO weekPayVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
//        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
//        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//
//        if(!isAuthenticated) {
//        	return ResponseEntity.status(401).body("Unauthorized");
//        }
//
//        if(!Util.isGnr()) {
//        	return ResponseEntity.status(401).body("Unauthorized");
//        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //라이더 권한
//        weekPayVO.setSchAuthorCode(user.getAuthorCode());
//        weekPayVO.setSchId(user.getId());

        try {
	        NiceVO niceVO = dtyService.makeNiceEncData(request);
	        // 인증 완료 후 success페이지에서 사용을 위한 key값은 DB,세션등 업체 정책에 맞춰 관리 후 사용하면 됩니다.
	        // 예시에서 사용하는 방법은 세션이며, 세션을 사용할 경우 반드시 인증 완료 후 세션이 유실되지 않고 유지되도록 확인 바랍니다.
	        // key, iv, hmac_key 값들은 token_version_id에 따라 동일하게 생성되는 고유값입니다.
	        // success페이지에서 token_version_id가 일치하는지 확인 바랍니다.
	        request.getSession().setAttribute("req_no", niceVO.getReq_no());
	        request.getSession().setAttribute("key" , niceVO.getKey());
	        request.getSession().setAttribute("iv" , niceVO.getIv());
	        request.getSession().setAttribute("hmac_key" , niceVO.getHmac_key());
	        request.getSession().setAttribute("token_version_id", niceVO.getToken_version_id());

	        map.put("token_version_id", niceVO.getToken_version_id());
	        map.put("enc_data", niceVO.getEnc_data());
	        map.put("integrity", niceVO.getIntegrity_value());
	    	map.put("resultCode", "success");
	    } catch (Exception e) {
			map.put("resultCode", "fail");
			map.put("resultMsg", e.getMessage());
			return ResponseEntity.ok(map);
		}
        return ResponseEntity.ok(map);

	}


	/**
	 * 나이스 핸드폰 본인인증
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/com/com0010_0001.do")
    public String com0010_0001(@ModelAttribute("NiceVO") NiceVO niceVO, HttpServletRequest request,ModelMap model) throws Exception {

//    	//로그인 체크
//        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
//        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
//
//        if(!isAuthenticated) {
//        	return "egovframework/com/cmm/error/accessDenied";
//        }
//
//		// 1. 사용자 확인
//		if(!Util.isGnr()) {
//			return "egovframework/com/cmm/error/accessDenied";
//        }

        //라이더 권한
//        niceVO.setSchAuthorCode(user.getAuthorCode());
//        niceVO.setSchId(user.getId());

        NiceVO reNiceVO = dtyService.returnNiceData(niceVO, request);
        if("success".equals(reNiceVO.getResultCode()) ) {
            request.getSession().setAttribute("niceSuccess", reNiceVO.getResultCode());
        }
        model.addAttribute("resultMsg", reNiceVO.getResultMsg());
        model.addAttribute("resultCode", reNiceVO.getResultCode());
        return "egovframework/gnr/rot/niceResult";
	}
}
