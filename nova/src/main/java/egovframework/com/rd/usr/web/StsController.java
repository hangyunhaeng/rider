package egovframework.com.rd.usr.web;


import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.RotService;
import egovframework.com.rd.usr.service.StsService;
import egovframework.com.rd.usr.service.vo.BalanceVO;
import egovframework.com.rd.usr.service.vo.StsVO;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;

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
public class StsController {


    @Resource(name = "StsService")
    private StsService stsService;
    @Resource(name = "RotService")
    private RotService rotService;
    @Resource(name="ehcache")
    Ehcache gCache ;


	/**
	 * 잔액 검증 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/sts0001.do")
    public String sts0001(@ModelAttribute("BalanceVO") BalanceVO balanceVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        model.addAttribute("balanceVO", balanceVO);
        if(Util.isReal())
        	model.addAttribute("riderUrl", "https://"+EgovProperties.getProperty("Globals.gnrDomain"));
        else
        	model.addAttribute("riderUrl", "http://"+EgovProperties.getProperty("Globals.gnrDevDomain"));

        //검색조건 2주제한 해제 id
        Ehcache cache = gCache.getCacheManager().getCache("commCd");
        if(cache.get("exclus") == null) cache.put(new Element("exclus", rotService.selectExclusList()));
		model.addAttribute("exclus", new ObjectMapper().writeValueAsString(cache.get("exclus").getObjectValue()));

        return "egovframework/usr/sts/sts0001";
	}

	/**
	 * 잔액 검증 리스트
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/sts0001_0001.do")
	public ResponseEntity<?> sts0001_0001(@ModelAttribute("BalanceVO") BalanceVO balanceVO, HttpServletRequest request) throws Exception{

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
        balanceVO.setSchUserSe(user.getUserSe());
        balanceVO.setSchAuthorCode(user.getAuthorCode());
        balanceVO.setSchId(user.getId());

        map.put("cnt", stsService.selectBalanceConfirmListCnt(balanceVO));
        map.put("list", stsService.selectBalanceConfirmList(balanceVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 협력사 일별 배달현황 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/sts0002.do")
    public String sts0002(@ModelAttribute("StsVO") StsVO stsVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        model.addAttribute("stsVO", stsVO);

        //검색조건 2주제한 해제 id
        Ehcache cache = gCache.getCacheManager().getCache("commCd");
        if(cache.get("exclus") == null) cache.put(new Element("exclus", rotService.selectExclusList()));
		model.addAttribute("exclus", new ObjectMapper().writeValueAsString(cache.get("exclus").getObjectValue()));

        return "egovframework/usr/sts/sts0002";
	}


	/**
	 * 협력사 일별 배달현황 리스트
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/sts0002_0001.do")
	public ResponseEntity<?> sts0002_0001(@ModelAttribute("StsVO") StsVO stsVO, HttpServletRequest request) throws Exception{

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
        stsVO.setSchUserSe(user.getUserSe());
        stsVO.setSchAuthorCode(user.getAuthorCode());
        stsVO.setSchIhidNum(user.getIhidNum());
        stsVO.setSchId(user.getId());

        map.put("list", stsService.selectSts0002(stsVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 라이더 일별 배달현황 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/sts0003.do")
    public String sts0003(@ModelAttribute("StsVO") StsVO stsVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }
        model.addAttribute("stsVO", stsVO);


        //검색조건 2주제한 해제 id
        Ehcache cache = gCache.getCacheManager().getCache("commCd");
        if(cache.get("exclus") == null) cache.put(new Element("exclus", rotService.selectExclusList()));
		model.addAttribute("exclus", new ObjectMapper().writeValueAsString(cache.get("exclus").getObjectValue()));

        return "egovframework/usr/sts/sts0003";
	}

	/**
	 * 라이더 일별 배달현황 리스트
	 * @param noticeVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/sts0003_0001.do")
	public ResponseEntity<?> sts0003_0001(@ModelAttribute("StsVO") StsVO stsVO, HttpServletRequest request) throws Exception{

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
        stsVO.setSchUserSe(user.getUserSe());
        stsVO.setSchAuthorCode(user.getAuthorCode());
        stsVO.setSchIhidNum(user.getIhidNum());
        stsVO.setSchId(user.getId());

        map.put("list", stsService.selectSts0003(stsVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}
}
