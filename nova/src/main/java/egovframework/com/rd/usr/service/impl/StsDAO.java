package egovframework.com.rd.usr.service.impl;


import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.rd.usr.service.vo.BalanceVO;
import egovframework.com.rd.usr.service.vo.StsVO;
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
	/**
	 * 협력사 일별 배달현황 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<StsVO> selectSts0002(StsVO vo) throws Exception {
		return selectList("stsDAO.selectSts0002", vo);
	}
	/**
	 * 라이더 일별 배달현황 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<StsVO> selectSts0003(StsVO vo) throws Exception {
		return selectList("stsDAO.selectSts0003", vo);
	}
	/**
	 * 주정산별 협력사별 수익현황
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<StsVO> selectCooperatorProfitStsList(StsVO vo) throws Exception {
		return selectList("stsDAO.selectCooperatorProfitStsList", vo);
	}
}


