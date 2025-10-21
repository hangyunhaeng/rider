package egovframework.com.rd.usr.service.impl;


import java.util.List;

import javax.annotation.Resource;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.rd.usr.service.StsService;
import egovframework.com.rd.usr.service.vo.BalanceVO;
import egovframework.com.rd.usr.service.vo.StsVO;

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
@Service("StsService")
public class StsServiceImpl extends EgovAbstractServiceImpl implements StsService {

	@Resource(name = "StsDAO")
	private StsDAO stsDAO;
	/**
	 * 잔액 검증 리스트 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<BalanceVO> selectBalanceConfirmList(BalanceVO vo) throws Exception {
		vo.setCooperatorMberId(EgovProperties.getProperty("Globals.cooperatorId"));
		return stsDAO.selectBalanceConfirmList(vo);
	}

	/**
	 * 잔액 검증 리스트 조회 cnt
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int selectBalanceConfirmListCnt(BalanceVO vo) throws Exception {
		vo.setCooperatorMberId(EgovProperties.getProperty("Globals.cooperatorId"));
		return stsDAO.selectBalanceConfirmListCnt(vo);
	}
	/**
	 * 협력사 일별 배달현황 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<StsVO> selectSts0002(StsVO vo) throws Exception {
		return stsDAO.selectSts0002(vo);
	}
	/**
	 * 라이더 일별 배달현황 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<StsVO> selectSts0003(StsVO vo) throws Exception {
		return stsDAO.selectSts0003(vo);
	}
	/**
	 * 주정산별 협력사별 수익현황
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<StsVO> selectCooperatorProfitStsList(StsVO vo) throws Exception {
		return stsDAO.selectCooperatorProfitStsList(vo);
	}
	/**
	 * 주정산별 협력사별 배달건수현황
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<StsVO> selectCooperatorDeliveryCntStsList(StsVO vo) throws Exception {
		return stsDAO.selectCooperatorDeliveryCntStsList(vo);
	}
}
