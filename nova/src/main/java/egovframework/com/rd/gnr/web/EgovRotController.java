package egovframework.com.rd.gnr.web;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.slf4j.Logger;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.DtyService;
import egovframework.com.rd.usr.service.NotService;
import egovframework.com.rd.usr.service.RotService;
import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.DoszSchAccoutVO;
import egovframework.com.rd.usr.service.vo.DoszTransferVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;
import egovframework.com.rd.usr.service.vo.NiceVO;
import egovframework.com.rd.usr.service.vo.NoticeVO;
import egovframework.com.rd.usr.service.vo.WeekPayVO;

/**
 * 게시판
 *
 * @since 2025.05.19
 * @version 1.0
 * @see
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *  2025.05.19
 *      </pre>
 */

@Controller
public class EgovRotController {


    @Resource(name = "NotService")
    private NotService notService;
    @Resource(name = "RotService")
    private RotService rotService;
    @Resource(name = "DtyService")
    private DtyService dtyService;

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovRotController.class);


	/**
	 * 메인페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/gnr/rot0001.do")
    public String rot0001(HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

		// 1. 사용자 확인
		if(!Util.isGnr()) {
			return "egovframework/com/cmm/error/accessDenied";
        }

		MyInfoVO myInfoVO = new MyInfoVO();
		myInfoVO.setMberId(user.getId());

	    // taxInvInfo를 JSON으로 변환하여 뷰에 전달
	    ObjectMapper objectMapper = new ObjectMapper();
	    Map<String, Object> cooperatorList = rotService.selectMyCooperatorList(myInfoVO);
	    String cooperatorListJson = objectMapper.writeValueAsString(cooperatorList);
	    List<MyInfoVO> myInfoVoList = rotService.selectMyCooperatorList1(myInfoVO);

	    String selectCooperId = null;
	    if(myInfoVoList.size() >0) {
	    	selectCooperId = myInfoVoList.get(0).getSeleceKey();
	    }


	    //라이더 출금 기준 협력사ID
	    request.getSession().setAttribute("cooperatorId", selectCooperId);


		myInfoVO.setSearchCooperatorId(selectCooperId);

		model.addAttribute("ablePrice", rotService.selectAblePrice(myInfoVO));
		model.addAttribute("cooperatorList", cooperatorListJson);
		model.addAttribute("cooperatorId", selectCooperId);


		//공지사항

        //라이더 권한
		NoticeVO noticeVO = new NoticeVO();
        noticeVO.setSchUserSe(user.getUserSe());
        noticeVO.setSchAuthorCode(user.getAuthorCode());

        noticeVO.setSearchId(user.getId());
        noticeVO.setSearchGubun("gongji");
    	Map<String, Object> gonjiList = new HashMap<String, Object>();
    	gonjiList.put("resultList", notService.selectNoticeViewList(noticeVO));
    	String gonjiListJson = objectMapper.writeValueAsString(gonjiList);
        model.addAttribute("gongjiList", gonjiListJson);
        return "egovframework/gnr/rot/rot0001";
	}

	/**
	 * 공지사항 리스트
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gnr/rot0001_0001.do")
	public ResponseEntity<?> rot0001_0001(@ModelAttribute("NoticeVO") NoticeVO noticeVO, HttpServletRequest request) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isGnr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //라이더 권한
        noticeVO.setSchAuthorCode(user.getAuthorCode());
        noticeVO.setSchId(user.getId());

        map.put("list", notService.selectNoticeViewList(noticeVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 공지사항 리스트
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/gnr/rot0001_0002.do")
	public ResponseEntity<?> rot0001_0002(@ModelAttribute("MyInfoVO") MyInfoVO myInfoVO, HttpServletRequest request) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isGnr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

	    //라이더 출금 기준 협력사ID
	    request.getSession().setAttribute("cooperatorId", myInfoVO.getSearchCooperatorId());

		myInfoVO.setMberId(user.getId());

        map.put("ablePrice", rotService.selectAblePrice(myInfoVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}


	/**
	 * 마이페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/gnr/rot0002.do")
    public String rot0002(@ModelAttribute("MyInfoVO") MyInfoVO myInfoVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

		// 1. 사용자 확인
		if(!Util.isGnr()) {
			return "egovframework/com/cmm/error/accessDenied";
        }
		myInfoVO.setMberId(user.getId());
		myInfoVO.setSchUserSe(user.getUserSe());
		myInfoVO.setSearchCooperatorId((String)request.getSession().getAttribute("cooperatorId"));


	    // taxInvInfo를 JSON으로 변환하여 뷰에 전달
	    ObjectMapper objectMapper = new ObjectMapper();
	    Map<String, Object> bankList = rotService.selectBankCodeList();
	    String bankListJson = objectMapper.writeValueAsString(bankList);
		model.addAttribute("bankList", bankListJson);
		model.addAttribute("myInfoVO", rotService.selectMyInfo(myInfoVO));
		model.addAttribute("doNice", Util.isReal());
        return "egovframework/gnr/rot/rot0002";
	}
	/**
	 * 마이페이지 - 기본정보저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/gnr/rot0002_0001.do")
    public ResponseEntity<?> rot0002_0001(@ModelAttribute("MyInfoVO") MyInfoVO myInfoVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isGnr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //라이더 권한
        myInfoVO.setSchAuthorCode(user.getAuthorCode());
        myInfoVO.setSchId(user.getId());

        myInfoVO.setSchUserSe(user.getUserSe());
        myInfoVO.setMberId(user.getId());
        try {


        	if(Util.isReal()) {
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
	 * 마이페이지 - 계좌정보저장
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/gnr/rot0002_0002.do")
    public ResponseEntity<?> rot0002_0002(@ModelAttribute("MyInfoVO") MyInfoVO myInfoVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isGnr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //라이더 권한
        myInfoVO.setSchAuthorCode(user.getAuthorCode());
        myInfoVO.setSchId(user.getId());

        myInfoVO.setMberId(user.getId());


        try{
	    	if(Util.isReal()) {
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



	        DoszSchAccoutVO doszSchAccoutVO = dtyService.schAcc(myInfoVO);

	        if("200".equals((doszSchAccoutVO.getStatus()))) {
		        if(user.getName().equals(doszSchAccoutVO.getDepositor())) {
		        	myInfoVO.setAccountNm(doszSchAccoutVO.getDepositor());
		        	myInfoVO.setEsntlId(user.getUniqId());
		        	rotService.saveBankByEsntlId(myInfoVO);
		        	map.put("resultCode", "success");
		        }else {
		        	map.put("resultMsg", "예금주와 가입자 성명이 일치하지 않습니다\n저장을 취소합니다 \n\n예금주명 : "+doszSchAccoutVO.getDepositor());
		        	map.put("resultCode", "fail");
		        }
	        } else if("999".equals(doszSchAccoutVO.getStatus())) {
	        	map.put("resultMsg", "계좌가 조회되지 않습니다.\n\n저장을 취소합니다");
	        	map.put("resultCode", "fail");
	        } else {
	        	map.put("resultMsg", doszSchAccoutVO.getErrorMessage() +"\n\n저장을 취소합니다");
	        	map.put("resultCode", "fail");
	        }
	    } catch (Exception e) {
			map.put("resultCode", "fail");
			map.put("resultMsg", e.getMessage());
			return ResponseEntity.ok(map);
		}

        return ResponseEntity.ok(map);
	}


	/**
	 * 출금페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/gnr/rot0003.do")
    public String rot0003(@ModelAttribute("MyInfoVO") MyInfoVO myInfoVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

		// 1. 사용자 확인
		if(!Util.isGnr()) {
			return "egovframework/com/cmm/error/accessDenied";
        }
		myInfoVO.setMberId(user.getId());
		myInfoVO.setSchUserSe(user.getUserSe());
		myInfoVO.setSearchCooperatorId((String)request.getSession().getAttribute("cooperatorId"));


		model.addAttribute("ablePrice", rotService.selectAblePrice(myInfoVO));
		model.addAttribute("myInfoVO", rotService.selectMyInfo(myInfoVO));
		model.addAttribute("myInfoVOData", myInfoVO);
		model.addAttribute("sendFee", EgovProperties.getProperty("Globals.sendFee"));
		model.addAttribute("doNice", Util.isReal());
        return "egovframework/gnr/rot/rot0003";
	}
	/**
	 * 선출금 실행
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/gnr/rot0003_0001.do")
    public ResponseEntity<?> rot0003_0001(@ModelAttribute("DayPayVO") DayPayVO dayPayVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isGnr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //라이더 권한
        dayPayVO.setSchAuthorCode(user.getAuthorCode());
        dayPayVO.setSchId(user.getId());

        dayPayVO.setMberId(user.getId());
        dayPayVO.setCooperatorId((String)request.getSession().getAttribute("cooperatorId"));
        try {

        	if(Util.isReal()) {
	        	if(Util.isEmpty((String)request.getSession().getAttribute("niceSuccess"))) {
	    			throw new IllegalArgumentException("PASS 미인증으로 출금 불가") ;
	        	}
	        	if(!"success".equals((String)request.getSession().getAttribute("niceSuccess"))) {
	    			throw new IllegalArgumentException("PASS 미인증으로 출금 불가") ;
	        	}
        	}
            request.getSession().removeAttribute("req_no");
            request.getSession().removeAttribute("key");
            request.getSession().removeAttribute("iv");
            request.getSession().removeAttribute("hmac_key");
            request.getSession().removeAttribute("token_version_id");
            request.getSession().removeAttribute("niceSuccess");


            DoszTransferVO tran = dtyService.actDayPay(dayPayVO);

            // 이체 실행
            DoszTransferVO tranResult = dtyService.transfer(tran);

            if(Util.isEmpty(tranResult.getStatus())){	//응답없음
//            	dtyService.updateDayPayByTransfer(tranResult);
            }
            else {
            	if("400".equals(tranResult.getStatus()) && "VTIM".equals(tranResult.getErrorCode())) {	//은행timeout
            		// 배치에서 재처리
            	} else if("400".equals(tranResult.getStatus()) && "0011".equals(tranResult.getErrorCode())) {	//처리중
            		// 배치에서 재처리
            	}else if("200".equals(tranResult.getStatus()) ){	//성공

            	} else {
                	dtyService.updateDayPayByTransfer(tranResult);	//실패 확정시 거래내역 삭제
            	}
            }

        	map.put("resultCode", "success");
        }catch(IllegalArgumentException e) {
			map.put("resultMsg", e.getMessage());
        	map.put("resultCode", "fail");
        }catch(Exception e) {
			map.put("resultMsg", e.toString());
        	map.put("resultCode", "fail");
        }


        return ResponseEntity.ok(map);
	}
	/**
	 * 정산완료 출금 실행
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/gnr/rot0003_0002.do")
    public ResponseEntity<?> rot0003_0002(@ModelAttribute("WeekPayVO") WeekPayVO weekPayVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isGnr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //라이더 권한
        weekPayVO.setSchAuthorCode(user.getAuthorCode());
        weekPayVO.setSchId(user.getId());

        weekPayVO.setMberId(user.getId());
        weekPayVO.setCooperatorId((String)request.getSession().getAttribute("cooperatorId"));
        try {

        	if(Util.isReal() ) {
	        	if(Util.isEmpty((String)request.getSession().getAttribute("niceSuccess"))) {
	    			throw new IllegalArgumentException("PASS 미인증으로 출금 불가") ;
	        	}
	        	if(!"success".equals((String)request.getSession().getAttribute("niceSuccess"))) {
	    			throw new IllegalArgumentException("PASS 미인증으로 출금 불가") ;
	        	}
        	}
            request.getSession().removeAttribute("req_no");
            request.getSession().removeAttribute("key");
            request.getSession().removeAttribute("iv");
            request.getSession().removeAttribute("hmac_key");
            request.getSession().removeAttribute("token_version_id");
            request.getSession().removeAttribute("niceSuccess");


            DoszTransferVO tran = dtyService.actWekPay(weekPayVO);

            // 이체 실행
            DoszTransferVO tranResult = dtyService.transfer(tran);

            if(Util.isEmpty(tranResult.getStatus())){	//응답없음
//            	dtyService.updateWeekPayByTransfer(tranResult);
            }
            else {
            	if("400".equals(tranResult.getStatus()) && "VTIM".equals(tranResult.getErrorCode())) {	//은행timeout
            		// 배치에서 재처리
            	} else if("400".equals(tranResult.getStatus()) && "0011".equals(tranResult.getErrorCode())) {	//처리중
            		// 배치에서 재처리
            	}else if("200".equals(tranResult.getStatus()) ){	//성공

            	} else {
                	dtyService.updateWeekPayByTransfer(tranResult);	//실패 확정시 거래내역 삭제
            	}
            }

        	map.put("resultCode", "success");
        }catch(IllegalArgumentException e) {
			map.put("resultMsg", e.getMessage());
        	map.put("resultCode", "fail");
        }catch(Exception e) {
			map.put("resultMsg", e.toString());
        	map.put("resultCode", "fail");
        }


        return ResponseEntity.ok(map);
	}

	/**
	 * 나이스 토큰 가져오기
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/gnr/rot0003_0003.do")
    public ResponseEntity<?> rot0003_0003(@ModelAttribute("WeekPayVO") WeekPayVO weekPayVO, HttpServletRequest request,ModelMap model) throws Exception {

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
    @RequestMapping("/gnr/rot0003_0004.do")
    public String rot0003_0004(@ModelAttribute("NiceVO") NiceVO niceVO, HttpServletRequest request,ModelMap model) throws Exception {

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
