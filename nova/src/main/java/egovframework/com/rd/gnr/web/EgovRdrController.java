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
import egovframework.com.rd.usr.service.MemService;
import egovframework.com.rd.usr.service.vo.DeliveryInfoVO;
import egovframework.com.rd.usr.web.DtyController;
import egovframework.com.sec.rgm.service.AuthorGroup;
import egovframework.com.sec.rgm.service.EgovAuthorGroupService;
import egovframework.com.uss.umt.service.EgovMberManageService;
import egovframework.com.uss.umt.service.MberManageVO;
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
		if(member == null || "".equals(member.getMberId().trim())) {
			map.put("resultCode", "failReg");
			map.put("resultMessage", "등록되지 않은 사용자입니다.<br/><br/>메인페이지에서 라이더 등록을 하시기 바랍니다.");
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

		// 1. 사용자 확인
		if(!Util.isGnr(request.getSession()))
			return ResponseEntity.status(401).body("Unauthorized");

		// 2. 비밀번호 변경
	    mberManageVO.setUniqId((String)request.getSession().getAttribute("uniqId"));
        mberManageVO.setPassword(EgovFileScrty.encryptPassword(mberManageVO.getPassword(), EgovStringUtil.isNullToString((String)request.getSession().getAttribute("mberId"))));
        mberManageVO.setMberConfirmAt("Y");
        mberManageService.updatePasswordSelf(mberManageVO);

		map.put("resultCode", "success");
		return ResponseEntity.ok(map);
	}

}
