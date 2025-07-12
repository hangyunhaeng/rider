package egovframework.com.rd.usr.service;

import java.util.List;

import egovframework.com.cmm.LoginVO;
import egovframework.com.rd.usr.service.vo.CooperatorFeeVO;
import egovframework.com.rd.usr.service.vo.CooperatorVO;
import egovframework.com.rd.usr.service.vo.DeliveryInfoVO;
import egovframework.com.rd.usr.service.vo.EtcVO;
import egovframework.com.uss.umt.service.MberManageVO;

public interface MemService {
	/**
	 * 협력사 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorList(CooperatorVO vo) throws Exception ;
	/**
	 * 협력사 조회(상세)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorDetailList(CooperatorVO vo) throws Exception ;
	/**
	 * 협력사 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorListRDCnt(CooperatorVO vo) throws Exception ;
	/**
	 * 협력사 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int mergeCooperator(CooperatorVO vo) throws Exception ;
	/**
	 * 협력사 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public void saveCooperator(List<CooperatorVO> list, LoginVO user) throws Exception;
	/**
	 * 협력사 ID 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public CooperatorVO saveCooperatorUsr(List<CooperatorVO> list, LoginVO user) throws Exception;
	/**
	 * 협력사 아이디 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int mergeCooperatorUsr(CooperatorVO vo) throws Exception;
	/**
	 * 협력사 아이디 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorUsrListByCooperator(CooperatorVO vo) throws Exception;
	/**
	 * 협력사별 라이더 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorRiderListByCooperator(CooperatorVO vo) throws Exception;
	/**
	 * 협력사별 라이더 저장
	 * @param list
	 * @throws Exception
	 */
	public CooperatorVO saveCooperatoRider(List<CooperatorVO> list, LoginVO user) throws Exception ;
	/**
	 * 협력사 접속 아이디 조회 by 사업자번호
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorUsrList(CooperatorVO vo) throws Exception ;
	/**
	 * 권한 있는 협력사 조회 by mberId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorListByMberId(CooperatorVO vo)throws Exception ;
	/**
	 * 라이더 개인정보 조회
	 * @param mberId
	 * @return
	 * @throws Exception
	 */
	public MberManageVO selectMemberInfo(String mberId) throws Exception ;

	/**
	 * 관리자측 개인정보 조회
	 * @param mberId
	 * @return
	 * @throws Exception
	 */
	public MberManageVO selectUserInfo(String mberId) throws Exception ;
	/**
	 * 협력사별 수수료 리스트 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorFeeVO> selectFeeListByCooperatorId (CooperatorFeeVO vo) throws Exception ;
	/**
	 * 수수료 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public CooperatorFeeVO saveCooperatorFee(List<CooperatorFeeVO> list, LoginVO user) throws Exception ;

	public List<DeliveryInfoVO> selectDeliveryInfoByMberId(DeliveryInfoVO deliveryInfoVO) throws Exception;

	/**
	 * 협력사,라이더별 대출 리스트 조회
	 * @param etcVO
	 * @return
	 * @throws Exception
	 */
	public List<EtcVO> selectEtcList(EtcVO etcVO) throws Exception ;

	/**
	 * 협력사,라이더별 대출 리스트 저장
	 * @param etcVO
	 * @return
	 * @throws Exception
	 */
	public EtcVO saveEtcList(List<EtcVO> list) throws Exception ;

	/**
	 * 협력사,라이더별 대출 승인요청
	 * @param etcVO
	 * @return
	 * @throws Exception
	 */
	public EtcVO requestEtcList(List<EtcVO> list) throws Exception ;
}
