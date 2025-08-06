package egovframework.com.rd.usr.service.impl;


import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.rd.usr.service.vo.BalanceVO;
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
@Repository("StsDAO")
public class StsDAO extends EgovComAbstractDAO {


	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgoRDLoginController.class);

	/**
	 * 잔액 검증 리스트 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<BalanceVO> selectBalanceConfirmList(BalanceVO vo) throws Exception {
		return selectList("stsDAO.selectBalanceConfirmList", vo);
	}

	/**
	 * 잔액 검증 리스트 조회 cnt
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int selectBalanceConfirmListCnt(BalanceVO vo) throws Exception {
		BalanceVO reVo = selectOne("stsDAO.selectBalanceConfirmListCnt", vo);
		return reVo.getTotalCnt();
	}
}


