package egovframework.com.rd.usr.service.impl;


import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;
import egovframework.com.rd.usr.service.vo.NoticeVO;
import egovframework.com.uat.uia.web.EgoRDLoginController;


/**
 * @Class Name : DelivertyInfoDao.java
 * @Description :
 * @Modification Information
 *
 *    수정일       수정자         수정내용
 *    -------        -------     -------------------
 *
 * @author
 * @since
 * @version
 * @see
 *
 */
@Repository("RotDAO")
public class RotDAO extends EgovComAbstractDAO {


	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgoRDLoginController.class);

	/**
	 * 내정보조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO selectMyInfo(MyInfoVO vo) throws Exception {
		if("GNR".equals(vo.getSchUserSe()))
			return selectOne("rotDAO.selectMyInfo", vo);
		else if("USR".equals(vo.getSchUserSe()))
			return selectOne("rotDAO.selectMyInfo2", vo);
		return null;
	}

	/**
	 * 내정보조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO selectMyInfo2(MyInfoVO vo) throws Exception {
		return selectOne("rotDAO.selectMyInfo2", vo);
	}
	/**
	 * 내정보수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateMyInfoByMberId(MyInfoVO vo) throws Exception {
		return update("rotDAO.updateMyInfoByMberId", vo);
	}
	/**
	 * 코드조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<MyInfoVO> selectCodeList(MyInfoVO vo)throws Exception {
		return selectList("rotDAO.selectCodeList", vo);
	}
	/**
	 * 사용자의 기존 사용하던 계좌정보 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<MyInfoVO> selectBankByEsntlId(MyInfoVO vo)throws Exception {
		return selectList("rotDAO.selectBankByEsntlId", vo);
	}
	/**
	 * 사용자의 기존 사용하던 계좌정보 삭제(useAt=N)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int deleteBnkByEsntlId(MyInfoVO vo)throws Exception {
		return update("rotDAO.deleteBnkByEsntlId", vo);
	}
	/**
	 * 사용자 계좌정보 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertBnk(MyInfoVO vo)throws Exception {
		return insert("rotDAO.insertBnk", vo);
	}

	/**
	 * 사용자별 출금 가능금액 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO selectAblePrice(MyInfoVO vo)throws Exception {
		return selectOne("rotDAO.selectAblePrice", vo);
	}
	/**
	 * 사용자의 협력사 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<MyInfoVO> selectMyCooperatorList(MyInfoVO vo) throws Exception {
		return selectList("rotDAO.selectMyCooperatorList", vo);
	}
	/**
	 * 라이더 출금시 선지급수수료 계산
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DayPayVO selectDayFee(DayPayVO vo) throws Exception {
		return selectOne("rotDAO.selectDayFee", vo);
	}
}


