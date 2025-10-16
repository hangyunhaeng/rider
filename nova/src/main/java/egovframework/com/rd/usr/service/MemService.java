package egovframework.com.rd.usr.service;

import java.util.List;

import egovframework.com.cmm.LoginVO;
import egovframework.com.rd.usr.service.vo.CooperatorFeeVO;
import egovframework.com.rd.usr.service.vo.CooperatorVO;
import egovframework.com.rd.usr.service.vo.DayPayVO;
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
	 * 라이더 패스워드 초기화
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int initRiderPass(CooperatorVO vo) throws Exception ;
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
	 * 협력사,라이더별 대출 리스트 Cnt
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int selectEtcListCnt(EtcVO vo) throws Exception ;
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
	/**
	 * 협력사,라이더별 대출 삭제
	 * @param etcVO
	 * @return
	 * @throws Exception
	 */
	public EtcVO deleteEtcList(List<EtcVO> list) throws Exception ;
	/**
	 * 협력사,라이더별 대출 승인
	 * @param etcVO
	 * @return
	 * @throws Exception
	 */
	public int responseEtc(EtcVO vo) throws Exception ;

	/**
	 * 대출 입금 리스트 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DayPayVO> selectEtcInputList(DayPayVO vo) throws Exception ;
	/**
	 * 대출 입금 리스트 조회(운영사용)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DayPayVO> selectEtcInputListByOperator(EtcVO vo) throws Exception ;
	/**
	 * 관리자가 라이더 로그인을 위한 key 생성
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public String getRandomKey(CooperatorVO vo) throws Exception ;

	/**
	 * 영업사원 리스트 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectSalesUsrList(CooperatorVO vo) throws Exception ;
	/**
	 * 영업사원 ID 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public CooperatorVO saveSalesUsr(List<CooperatorVO> list, LoginVO user) throws Exception ;
	/**
	 * 영업사원의 협력사 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorListBySalesMan(CooperatorVO vo) throws Exception ;
	/**
	 * 영업사원 협력사 연결 저장
	 * @param list
	 * @return
	 * @throws Exception
	 */
	public CooperatorVO saveCooperatorSalesUsr(List<CooperatorVO> list) throws Exception ;

	/**
	 * 운영사 ID 리스트 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectAdminUsrList(CooperatorVO vo) throws Exception ;

	/**
	 * 운영사 ID 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public CooperatorVO saveAdminUsr(List<CooperatorVO> list, LoginVO user) throws Exception ;
}
