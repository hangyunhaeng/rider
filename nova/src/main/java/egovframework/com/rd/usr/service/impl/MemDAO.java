package egovframework.com.rd.usr.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.rd.usr.service.vo.CooperatorFeeVO;
import egovframework.com.rd.usr.service.vo.CooperatorVO;
import egovframework.com.rd.usr.service.vo.DeliveryInfoVO;
import egovframework.com.uat.uia.web.EgoRDLoginController;
import egovframework.com.uss.umt.service.MberManageVO;


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
@Repository("MemDAO")
public class MemDAO extends EgovComAbstractDAO {


	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgoRDLoginController.class);

	/**
	 * 협력사 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorList(CooperatorVO vo) throws Exception {
		return selectList("memDAO.selectCooperatorList", vo);
	}
	/**
	 * 협력사 조회(상세)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorDetailList(CooperatorVO vo) throws Exception {
		return selectList("memDAO.selectCooperatorDetailList", vo);
	}

	/**
	 * 협력사 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorListRDCnt(CooperatorVO vo) throws Exception {
		return selectList("memDAO.selectCooperatorListRDCnt", vo);
	}

	/**
	 * 협력사 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int mergeCooperator(CooperatorVO vo)throws Exception {
		return insert("memDAO.mergeCooperator", vo);
	}
	/**
	 * 협력사 아이디 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int mergeCooperatorUsr(CooperatorVO vo) throws Exception {
		return insert("memDAO.mergeCooperatorUsr", vo);
	}
	/**
	 * 협력사 아이디 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorUsrListByCooperator(CooperatorVO vo) throws Exception {
		return selectList("memDAO.selectCooperatorUsrListByCooperator", vo);
	}

	/**
	 * 협력사 조회 ByCooperatorId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public CooperatorVO selectCooperatorByCooperatorId(CooperatorVO vo) throws Exception {
		return selectOne("memDAO.selectCooperatorByCooperatorId", vo);
	}

	/**
	 * 협력사 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertCooperator(CooperatorVO vo) throws Exception {
		return insert("memDAO.insertCooperator", vo);
	}

	/**
	 * 협력사 수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateCooperator(CooperatorVO vo) throws Exception {
		return update("memDAO.updateCooperator", vo);
	}

	/**
	 * 협력사 ID 조회 ByMberId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public CooperatorVO selectCooperatorUsrByMberId(CooperatorVO vo) throws Exception {
		return selectOne("memDAO.selectCooperatorUsrByMberId", vo);
	}

	/**
	 * 협력사 ID 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertCooperatorUsr(CooperatorVO vo) throws Exception {
		return insert("memDAO.insertCooperatorUsr", vo);
	}

	/**
	 * 협력사 ID 수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateCooperatorUsr(CooperatorVO vo) throws Exception {
		return update("memDAO.updateCooperatorUsr", vo);
	}

	/**
	 * 협력사별 라이더 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorRiderListByCooperator(CooperatorVO vo) throws Exception {
		return selectList("memDAO.selectCooperatorRiderListByCooperator", vo);
	}

	public CooperatorVO selectCooperatorRiderConnect(CooperatorVO vo) throws Exception {
		return selectOne("memDAO.selectCooperatorRiderConnect", vo);
	}
	public int insertCooperatorRiderConnect(CooperatorVO vo) throws Exception {
		return insert("memDAO.insertCooperatorRiderConnect", vo);
	}

	/**
	 *
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateCooperatorRiderConnect(CooperatorVO vo) throws Exception {
		return update("memDAO.updateCooperatorRiderConnect", vo);
	}

	/**
	 * 협력사 접속 아이디 조회 by 사업자번호
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorUsrList(CooperatorVO vo) throws Exception {
		return selectList("memDAO.selectCooperatorUsrList", vo);
	}
	/**
	 * 권한 있는 협력사 조회 by mberId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorListByMberId(CooperatorVO vo)throws Exception {
		return selectList("memDAO.selectCooperatorListByMberId", vo);
	}
	/**
	 * 아이디와 협력사ID로 권한여부 체크
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public boolean selectAuthChkByCoop(CooperatorVO vo)throws Exception {
		CooperatorVO one = selectOne("memDAO.selectAuthChkByCoop", vo);
		if(one != null) {
			return true;
		}
		return false;
	}
	/**
	 * 라이더 개인정보 조회
	 * @param mberId
	 * @return
	 * @throws Exception
	 */
	public MberManageVO selectMemberInfo(String mberId) throws Exception {
		return selectOne("memDAO.selectMemberInfo", mberId);
	}
	/**
	 * 관리자측 개인정보 조회
	 * @param mberId
	 * @return
	 * @throws Exception
	 */
	public MberManageVO selectUserInfo(String mberId) throws Exception {
		return selectOne("memDAO.selectUserInfo", mberId);
	}

	/**
	 * 협력사별 수수료 리스트 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorFeeVO> selectFeeListByCooperatorId (CooperatorFeeVO vo) throws Exception {
		return selectList("memDAO.selectFeeListByCooperatorId", vo);
	}
	public CooperatorFeeVO selectFeeListByFeeId(CooperatorFeeVO vo) throws Exception {
		return selectOne("memDAO.selectFeeListByFeeId", vo);
	}
	/**
	 * 수수료 종료일 수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updaetFee(CooperatorFeeVO vo) throws Exception {
		return update("memDAO.updaetFee", vo);
	}
	/**
	 * 수수료 삭제
	 */
	public int updateFeeUseNo(CooperatorVO vo) throws Exception {
		return update("memDAO.updateFeeUseNo", vo);
	}
	/**
	 * 수수료 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertFee(CooperatorVO vo) throws Exception {
		return insert("memDAO.insertFee", vo);
	}

	/**
	 * 같은 수수료가 있는지 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectFeeSame(CooperatorVO vo) throws Exception {
		return selectList("memDAO.selectFeeSame", vo);
	}
	public List<CooperatorVO> selectCooperatorRiderConnectByMberId(CooperatorVO vo) throws Exception {
		return selectList("memDAO.selectCooperatorRiderConnectByMberId", vo);
	}
	/**
	 * 라이더 등록전 라이더가 있는지 체크
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorRiderConnectNamugi(CooperatorVO vo) throws Exception {
		return selectList("memDAO.selectCooperatorRiderConnectNamugi", vo);
	}
	/**
	 * 회원 아이디로 일정산 정보 조회
	 * @param deliveryInfoVO
	 * @return
	 * @throws Exception
	 */
	public List<DeliveryInfoVO> selectDeliveryInfoByMberId(DeliveryInfoVO deliveryInfoVO) throws Exception {
		return selectList("memDAO.selectDeliveryInfoListByMberId", deliveryInfoVO);
	}
}


