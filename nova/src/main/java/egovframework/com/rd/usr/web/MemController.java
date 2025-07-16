package egovframework.com.rd.usr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;


import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.slf4j.Logger;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.DtyService;
import egovframework.com.rd.usr.service.MemService;
import egovframework.com.rd.usr.service.RotService;
import egovframework.com.rd.usr.service.vo.CooperatorFeeVO;
import egovframework.com.rd.usr.service.vo.CooperatorVO;
import egovframework.com.rd.usr.service.vo.DoszSchAccoutVO;
import egovframework.com.rd.usr.service.vo.EtcVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;
import egovframework.com.sec.rgm.service.EgovAuthorGroupService;
import egovframework.com.uss.umt.service.EgovUserManageService;
import egovframework.com.uss.umt.service.MberManageVO;
import egovframework.com.uss.umt.service.UserManageVO;

/**
 * 엑셀 업로드 테스트
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
public class MemController {

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;

    @Resource(name = "MemService")
    private MemService memService;
    @Resource(name = "RotService")
    private RotService rotService;
    @Resource(name = "DtyService")
    private DtyService dtyService;

	@Resource(name = "userManageService")
	private EgovUserManageService userManageService;
    @Resource(name = "egovAuthorGroupService")
    private EgovAuthorGroupService egovAuthorGroupService;

	private static final Logger LOGGER = LoggerFactory.getLogger(MemController.class);


	/**
	 * 협력사 관리
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/mem0001.do")
    public String mem0001(HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        return "egovframework/usr/mem/mem0001";
	}


    /**
     * 협력사 상세 조회
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0001_0000.do")
    public ResponseEntity<?> mem0001_0000(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        cooperatorVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorVO.setSchIhidNum(user.getIhidNum());

        List<CooperatorVO> list = memService.selectCooperatorDetailList(cooperatorVO);

        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }

    /**
     * 협력사 조회
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0001_0001.do")
    public ResponseEntity<?> mem0001_0001(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        cooperatorVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorVO.setSchIhidNum(user.getIhidNum());

        List<CooperatorVO> list = memService.selectCooperatorList(cooperatorVO);

        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }

    /**
     * 협력사 저장
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0001_0002.do")
    public ResponseEntity<?> mem0001_0002(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model, @RequestBody List<CooperatorVO> list) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();


    	memService.saveCooperator(list, user);

        //총판 or 협력사
        cooperatorVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorVO.setSchIhidNum(user.getIhidNum());
        map.put("list", memService.selectCooperatorDetailList(cooperatorVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }


    /**
     * 협력사 아이디 저장
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0001_0003.do")
    public ResponseEntity<?> mem0001_0003(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model, @RequestBody List<CooperatorVO> list) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        CooperatorVO searchVo = memService.saveCooperatorUsr(list, user);
        map.put("list", memService.selectCooperatorUsrListByCooperator(searchVo));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }

    /**
     * 협력사 아이디 리스트
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0001_0004.do")
    public ResponseEntity<?> mem0001_0004(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", memService.selectCooperatorUsrListByCooperator(cooperatorVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }

    /**
     * 아이디 중복 체크
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0001_0005.do")
    public ResponseEntity<?> mem0001_0005(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        UserManageVO vo = new UserManageVO();
        vo.setSearchCondition("0");
        vo.setSearchKeyword(cooperatorVO.getMberId());
        UserManageVO userVo = userManageService.selectUserListRider(vo);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();
        if(userVo == null)
        	map.put("resultCode", "success");
        else
        	map.put("resultCode", "fail");
        return ResponseEntity.ok(map);
    }
    /**
     * 협력사별 수수료 리스트 조회
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0001_0006.do")
    public ResponseEntity<?> mem0001_0006(@ModelAttribute("cooperatorFeeVO")CooperatorFeeVO cooperatorFeeVO, HttpServletRequest request) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        cooperatorFeeVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorFeeVO.setSchIhidNum(user.getIhidNum());
        map.put("list", memService.selectFeeListByCooperatorId(cooperatorFeeVO));
    	map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }

    /**
     * 협력사 수수료 저장
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0001_0007.do")
    public ResponseEntity<?> mem0001_0007(@ModelAttribute("cooperatorFeeVO")CooperatorFeeVO cooperatorFeeVO, HttpServletRequest request,ModelMap model, @RequestBody List<CooperatorFeeVO> list) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();
        try {
	        CooperatorFeeVO vo = memService.saveCooperatorFee(list, user);
	        map.put("list", memService.selectFeeListByCooperatorId(vo));
	        map.put("resultCode", "success");
	        return ResponseEntity.ok(map);
        } catch(IllegalArgumentException e) {
        	map.put("resultCode", "fail");
        	map.put("resultMsg", e.getMessage());
        	return ResponseEntity.ok(map);
        }
    }


    /**
     * 협력사 조회(라이더)
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0001_0008.do")
    public ResponseEntity<?> mem0001_0008(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        cooperatorVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorVO.setSchIhidNum(user.getIhidNum());

        List<CooperatorVO> list = memService.selectCooperatorListRDCnt(cooperatorVO);

        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }
    /**
     * 라이더 아이디로 개인정보 불러오기
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0002_0003.do")
    public ResponseEntity<?> mem0002_0003(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        MberManageVO userVo = memService.selectMemberInfo(cooperatorVO.getMberId());
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();
        if(userVo != null) {
        	map.put("userVo", userVo);
        	map.put("resultCode", "success");
        }
        else
        	map.put("resultCode", "fail");
        return ResponseEntity.ok(map);
    }


    /**
     * 협력사,라이더별 대출 리스트 조회
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0002_0004.do")
    public ResponseEntity<?> mem0002_0004(@ModelAttribute("etcVO")EtcVO etcVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        List<EtcVO> list = memService.selectEtcList(etcVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();
        map.put("resultCode", "success");
        map.put("list", list);
        return ResponseEntity.ok(map);
    }

    /**
     * 협력사,라이더별 대출 리스트 저장
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0002_0005.do")
    public ResponseEntity<?> mem0002_0005(HttpServletRequest request,ModelMap model, @RequestBody List<EtcVO> list) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        try {
        	EtcVO vo = memService.saveEtcList(list);

	        map.put("list", memService.selectEtcList(vo));
	        map.put("resultCode", "success");
	    } catch(IllegalArgumentException e) {
	    	map.put("resultCode", "fail");
	    	map.put("resultMsg", e.getMessage());
	    	return ResponseEntity.ok(map);
	    }
        return ResponseEntity.ok(map);
    }
    /**
     * 협력사,라이더별 대출 승인요청
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0002_0006.do")
    public ResponseEntity<?> mem0002_0006(HttpServletRequest request,ModelMap model, @RequestBody List<EtcVO> list) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        try {
        	EtcVO vo = memService.requestEtcList(list);

	        map.put("list", memService.selectEtcList(vo));
	        map.put("resultCode", "success");
	    } catch(IllegalArgumentException e) {
	    	map.put("resultCode", "fail");
	    	map.put("resultMsg", e.getMessage());
	    	return ResponseEntity.ok(map);
	    }
        return ResponseEntity.ok(map);
    }

    /**
     * 협력사,라이더별 대출 삭제
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0002_0007.do")
    public ResponseEntity<?> mem0002_0007(HttpServletRequest request,ModelMap model, @RequestBody List<EtcVO> list) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        try {
        	EtcVO vo = memService.deleteEtcList(list);

	        map.put("list", memService.selectEtcList(vo));
	        map.put("resultCode", "success");
	    } catch(IllegalArgumentException e) {
	    	map.put("resultCode", "fail");
	    	map.put("resultMsg", e.getMessage());
	    	return ResponseEntity.ok(map);
	    }
        return ResponseEntity.ok(map);
    }

	/**
	 * 라이더 관리
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/mem0002.do")
    public String mem0002(HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        return "egovframework/usr/mem/mem0002";
	}
    /**
     * 협력사별 라이더 조회
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0002_0001.do")
    public ResponseEntity<?> mem0002_0001(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();


        //총판 or 협력사
        cooperatorVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorVO.setSchIhidNum(user.getIhidNum());

        map.put("list", memService.selectCooperatorRiderListByCooperator(cooperatorVO));
    	map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }

    /**
     * 라이더 저장
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0002_0002.do")
    public ResponseEntity<?> mem0002_0002(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model, @RequestBody List<CooperatorVO> list) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        cooperatorVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorVO.setSchIhidNum(user.getIhidNum());

        try {
	        CooperatorVO searchVo = memService.saveCooperatoRider(list, user);
	        map.put("list", memService.selectCooperatorRiderListByCooperator(searchVo));

	        CooperatorVO vo = new CooperatorVO();
	        vo.setSearchGubun("R");
	        map.put("orglist", memService.selectCooperatorListRDCnt(vo));
	        map.put("resultCode", "success");
        } catch(IllegalArgumentException e) {
        	map.put("resultCode", "fail");
        	map.put("resultMsg", e.getMessage());
        	return ResponseEntity.ok(map);
        }
        return ResponseEntity.ok(map);
    }
	/**
	 * 협력사계정관리
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/mem0003.do")
    public String mem0003(HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        return "egovframework/usr/mem/mem0003";
	}


    /**
     * 협력사 접속 아이디 조회
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0003_0001.do")
    public ResponseEntity<?> mem0003_0001(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        cooperatorVO.setSchAuthorCode(user.getAuthorCode());
        cooperatorVO.setSchIhidNum(user.getIhidNum());

        map.put("list", memService.selectCooperatorUsrList(cooperatorVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }
    /**
     * 협력사 아이디 저장
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0003_0002.do")
    public ResponseEntity<?> mem0003_0002(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model, @RequestBody List<CooperatorVO> list) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        CooperatorVO searchVo = memService.saveCooperatorUsr(list, user);

        //총판 or 협력사
        searchVo.setSchAuthorCode(user.getAuthorCode());
        searchVo.setSchIhidNum(user.getIhidNum());

        map.put("list", memService.selectCooperatorUsrList(searchVo));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }

    /**
     * 권한 있는 협력사 조회
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/usr/mem0003_0003.do")
    public ResponseEntity<?> mem0003_0003(@ModelAttribute("cooperatorVO")CooperatorVO cooperatorVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", memService.selectCooperatorListByMberId(cooperatorVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }
	/**
	 * my Page
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/mem0004.do")
    public String mem0004(@ModelAttribute("MyInfoVO") MyInfoVO myInfoVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }


        //총판 or 협력사
        myInfoVO.setSchAuthorCode(user.getAuthorCode());
        myInfoVO.setSchIhidNum(user.getIhidNum());

		myInfoVO.setMberId(user.getId());
		myInfoVO.setSchUserSe(user.getUserSe());

	    // taxInvInfo를 JSON으로 변환하여 뷰에 전달
	    ObjectMapper objectMapper = new ObjectMapper();
	    Map<String, Object> bankList = rotService.selectBankCodeList();
	    String bankListJson = objectMapper.writeValueAsString(bankList);
		model.addAttribute("bankList", bankListJson);
		model.addAttribute("myInfoVO", rotService.selectMyInfo(myInfoVO));
        return "egovframework/usr/mem/mem0004";
	}
	/**
	 * my Page - 기본정보저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/mem0004_0001.do")
    public ResponseEntity<?> mem0004_0001(@ModelAttribute("MyInfoVO") MyInfoVO myInfoVO, HttpServletRequest request,ModelMap model) throws Exception {
    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();


        //총판 or 협력사
        myInfoVO.setSchAuthorCode(user.getAuthorCode());
        myInfoVO.setSchIhidNum(user.getIhidNum());

		myInfoVO.setMberId(user.getId());
		myInfoVO.setSchUserSe(user.getUserSe());
        myInfoVO.setSchId(user.getId());

        try {
        	rotService.updateMyInfoByMberId(myInfoVO);
        } catch (Exception e) {
			map.put("resultCode", "fail");
			map.put("resultMsg", e.getMessage());
			return ResponseEntity.ok(map);
		}
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * my Page - 계좌정보저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/mem0004_0002.do")
    public ResponseEntity<?> mem0004_0002(@ModelAttribute("MyInfoVO") MyInfoVO myInfoVO, HttpServletRequest request,ModelMap model) throws Exception {
    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        myInfoVO.setSchAuthorCode(user.getAuthorCode());
        myInfoVO.setSchIhidNum(user.getIhidNum());
        myInfoVO.setMberId(user.getId());

        DoszSchAccoutVO doszSchAccoutVO = dtyService.schAcc(myInfoVO);


        if("200".equals(doszSchAccoutVO.getStatus())) {
        	myInfoVO.setAccountNm(doszSchAccoutVO.getDepositor());
        	myInfoVO.setEsntlId(user.getIhidNum());
        	rotService.saveBankByEsntlId(myInfoVO);
        	map.put("resultCode", "success");
        } else if("999".equals(doszSchAccoutVO.getStatus())) {
        	map.put("resultMsg", "계좌가 조회되지 않습니다.\n\n저장을 취소합니다");
        	map.put("resultCode", "fail");
        } else {
        	map.put("resultMsg", doszSchAccoutVO.getErrorMessage() +"\n\n저장을 취소합니다");
        	map.put("resultCode", "fail");
        }
        return ResponseEntity.ok(map);
	}
	/**
	 * my Page - 기본정보저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/mem0004_0003.do")
    public ResponseEntity<?> mem0004_0003(@ModelAttribute("MyInfoVO") MyInfoVO myInfoVO, HttpServletRequest request,ModelMap model) throws Exception {
    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();


        //총판 or 협력사
        myInfoVO.setSchAuthorCode(user.getAuthorCode());
        myInfoVO.setSchIhidNum(user.getIhidNum());

		myInfoVO.setMberId(user.getId());
		myInfoVO.setSchUserSe(user.getUserSe());
        myInfoVO.setSchId(user.getId());

        try {
        	rotService.updatePasswordByEsntlId(myInfoVO);
        } catch (Exception e) {
			map.put("resultCode", "fail");
			map.put("resultMsg", e.getMessage());
			return ResponseEntity.ok(map);
		}
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}
}
