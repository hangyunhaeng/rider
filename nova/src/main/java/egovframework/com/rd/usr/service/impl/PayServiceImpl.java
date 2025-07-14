package egovframework.com.rd.usr.service.impl;


import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.com.rd.usr.service.PayService;
import egovframework.com.rd.usr.service.vo.DoszDSResultVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;
import egovframework.com.rd.usr.service.vo.ProfitVO;

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
@Service("PayService")
public class PayServiceImpl extends EgovAbstractServiceImpl implements PayService {


	@Resource(name = "PayDAO")
	private PayDAO payDAO;

	private static final Logger LOGGER = LoggerFactory.getLogger(PayServiceImpl.class);


	/**
	 * 입출금내역 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<HistoryVO> selectPayList(HistoryVO vo) throws Exception {
		return payDAO.selectPayList(vo);
	}

	/**
	 * 대사 이력 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DoszDSResultVO> selectDoznDs(DoszDSResultVO vo) throws Exception {
		return payDAO.selectDoznDs(vo);
	}


	/**
	 * 운영사 수익 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<ProfitVO> selectProfitList(ProfitVO vo) throws Exception {
		return payDAO.selectProfitList(vo);
	}

	/**
	 * 협력사 수익 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<ProfitVO> selectCooperatorProfitList(ProfitVO vo) throws Exception {
		return payDAO.selectCooperatorProfitList(vo);
	}
}
