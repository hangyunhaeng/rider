package egovframework.com.rd.usr.service.impl;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.RotService;
import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.uss.umt.service.EgovUserManageService;
import egovframework.com.uss.umt.service.UserManageVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.com.utl.sim.service.EgovFileScrty;

/**
 * @Class Name : DtyServiceImpl.java
 * @Description :
 * @Modification
 *
 *    수정일       수정자         수정내용
 *    -------        -------     -------------------
 *
 *
 * @author
 * @since
 * @version
 * @see
 *
 */
@Service("RotService")
public class RotServiceImpl extends EgovAbstractServiceImpl implements RotService {


	@Resource(name = "RotDAO")
	private RotDAO rotDAO;
	@Resource(name = "loginService")
	EgovLoginService loginService;
	@Resource(name = "userManageService")
	EgovUserManageService userManageService;
    /** ID Generation */
	@Resource(name="egovBnkIdGnrService")
	private EgovIdGnrService egovBnkIdGnrService;

	/**
	 * 내정보조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO selectMyInfo(MyInfoVO vo) throws Exception {
		return rotDAO.selectMyInfo(vo);
	}
	/**
	 * 내정보수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateMyInfoByMberId(MyInfoVO vo) throws Exception {

		if("GNR".equals(vo.getSchUserSe())) {
			if(!Util.isEmpty(vo.getPassword())) {
				LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

				LoginVO loginVO = new LoginVO();
				loginVO.setPassword(vo.getBefPassword());
				loginVO.setId(user.getId());
				loginVO.setUserSe(user.getUserSe());
				LoginVO reLoginVO = loginService.actionLogin(loginVO);
				if(Util.isEmpty(reLoginVO.getId())) {
					throw new IllegalArgumentException("기존 비밀번호가 틀려 저장에 실패하였습니다") ;
				}
				//패스워드 암호화
				String pass = EgovFileScrty.encryptPassword(vo.getPassword(), EgovStringUtil.isNullToString(user.getId()));//KISA 보안약점 조치 (2018-10-29, 윤창원)
				vo.setPassword(pass);
			}
		} else {
			vo.setPassword(null);;
		}

		return rotDAO.updateMyInfoByMberId(vo);
	}
	/**
	 * 코드조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectBankCodeList()throws Exception {
		MyInfoVO vo = new MyInfoVO();
		vo.setSchCdGroup("BANK_CD");
		List<MyInfoVO> result = rotDAO.selectCodeList(vo);


    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("resultList", result);

    	return map;
	}
	/**
	 * 사용자의 계좌정보 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public void saveBankByEsntlId(MyInfoVO vo) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		vo.setCreatId(user.getId());
		vo.setLastUpdusrId(user.getId());
		if("ROLE_SALES".equals(vo.getSchAuthorCode()) ) {
			vo.setEsntlId(user.getUniqId());
		} else {
			vo.setEsntlId(user.getIhidNum());
		}

		List<MyInfoVO> bnkList = rotDAO.selectBankByEsntlId(vo);
		if(bnkList.size() > 1) {	// 기존 계좌가 2개면????? 무조건 지우고 새로 넣는다
			rotDAO.deleteBnkByEsntlId(vo);
			vo.setBnkId(egovBnkIdGnrService.getNextStringId());
			rotDAO.insertBnk(vo);
		} else if(bnkList.size() == 1){	//기존 계좌가 다를시에만 등록한다.
			MyInfoVO one = bnkList.get(0);
			if(!vo.getBnkCd().equals(one.getBnkCd()) || !vo.getAccountNum().equals(one.getAccountNum())) {
				rotDAO.deleteBnkByEsntlId(vo);
				vo.setBnkId(egovBnkIdGnrService.getNextStringId());
				rotDAO.insertBnk(vo);
			}

		} else {
			rotDAO.deleteBnkByEsntlId(vo);
			vo.setBnkId(egovBnkIdGnrService.getNextStringId());
			rotDAO.insertBnk(vo);
		}
	}


	/**
	 * 비밀번호변경
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public void updatePasswordByEsntlId(MyInfoVO vo) throws Exception {

			LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

			LoginVO loginVO = new LoginVO();
			loginVO.setPassword(vo.getBefPassword());
			loginVO.setId(user.getId());
			loginVO.setUserSe(user.getUserSe());
			LoginVO reLoginVO = loginService.actionLogin(loginVO);
			if(Util.isEmpty(reLoginVO.getId())) {
				throw new IllegalArgumentException("기존 비밀번호가 틀려 저장에 실패하였습니다") ;
			}
			//패스워드 암호화
			String pass = EgovFileScrty.encryptPassword(vo.getPassword(), EgovStringUtil.isNullToString(user.getId()));//KISA 보안약점 조치 (2018-10-29, 윤창원)

			UserManageVO passVO = new UserManageVO();
			passVO.setPassword(pass);
			passVO.setUniqId(user.getUniqId());
			userManageService.updatePassword(passVO);
	}
	/**
	 * 사용자별 출금 가능금액 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO selectAblePrice(MyInfoVO vo)throws Exception {
		return rotDAO.selectAblePrice(vo);
	}
	/**
	 * 사용자의 협력사 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectMyCooperatorList(MyInfoVO vo)throws Exception {

		List<MyInfoVO> result = rotDAO.selectMyCooperatorList(vo);
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("resultList", result);
    	return map;
	}

	/**
	 * 사용자의 협력사 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<MyInfoVO> selectMyCooperatorList1(MyInfoVO vo)throws Exception {
    	return  rotDAO.selectMyCooperatorList(vo);
	}

	/**
	 * 각종 수수료 조회(아이디 기준)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DayPayVO selectFeeByMberId(MyInfoVO vo) throws Exception {
    	return  rotDAO.selectFeeByMberId(vo);
	}
}
