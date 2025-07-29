package egovframework.com.rd.usr.service.impl;


import java.util.Random;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.rd.usr.service.BalanceService;
import egovframework.com.rd.usr.service.vo.BalanceVO;

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
@Service("BalanceService")
public class BalanceServiceImpl extends EgovAbstractServiceImpl implements BalanceService {

	@Resource(name = "BalanceDAO")
	private BalanceDAO balanceDAO;


	private static final Logger LOGGER = LoggerFactory.getLogger(BalanceServiceImpl.class);

	public int transactionBalance(BalanceVO vo) throws Exception {
		balanceDAO.selectBalanceForUpdate(vo);
		return balanceDAO.updateBalance(vo);
	}

	public BalanceVO selectBalanceByMberId(BalanceVO vo) throws Exception {
		return balanceDAO.selectBalanceByMberId(vo);
	}

	public BalanceVO selectBalanceByIdx(BalanceVO vo) throws Exception {
		return balanceDAO.selectBalanceByIdx(vo);
	}

}
