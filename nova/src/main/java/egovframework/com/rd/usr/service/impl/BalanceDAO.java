package egovframework.com.rd.usr.service.impl;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.rd.usr.service.vo.BalanceVO;
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
@Repository("BalanceDAO")
public class BalanceDAO extends EgovComAbstractDAO {


	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgoRDLoginController.class);

	public void selectBalanceForUpdate(BalanceVO vo) throws Exception {
		selectList("balanceDAO.selectBalanceForUpdate", vo);
	}
	public int updateBalance(BalanceVO vo) throws Exception {
		return update("balanceDAO.updateBalance", vo);
	}

	public BalanceVO selectBalanceByMberId(BalanceVO vo) throws Exception {
		return selectOne("balanceDAO.selectBalanceByMberId", vo);
	}
	public BalanceVO selectBalanceByIdx(BalanceVO vo) throws Exception {
		return selectOne("balanceDAO.selectBalanceByIdx", vo);
	}

}

