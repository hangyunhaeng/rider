package egovframework.com.rd.usr.service;


import java.util.List;
import java.util.Map;

import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.MyInfoVO;


public interface RotService {

	/**
	 * 내정보조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO selectMyInfo(MyInfoVO vo) throws Exception ;

	/**
	 * 내정보수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateMyInfoByMberId(MyInfoVO vo) throws Exception ;
	/**
	 * 코드조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectBankCodeList()throws Exception ;
	/**
	 * 사용자의 계좌정보 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public void saveBankByEsntlId(MyInfoVO vo) throws Exception ;

	/**
	 * 비밀번호변경
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public void updatePasswordByEsntlId(MyInfoVO vo) throws Exception ;
	/**
	 * 사용자별 출금 가능금액 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public MyInfoVO selectAblePrice(MyInfoVO vo)throws Exception ;
	/**
	 * 사용자의 협력사 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectMyCooperatorList(MyInfoVO vo)throws Exception ;
	/**
	 * 사용자의 협력사 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<MyInfoVO> selectMyCooperatorList1(MyInfoVO vo)throws Exception ;
	/**
	 * 각종 수수료 조회(아이디 기준)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DayPayVO selectFeeByMberId(MyInfoVO vo) throws Exception ;
}
