package egovframework.com.rd.usr.service;

import java.util.List;

import egovframework.com.rd.usr.service.vo.BalanceVO;
import egovframework.com.rd.usr.service.vo.StsVO;

public interface StsService {

	/**
	 * 잔액 검증 리스트 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<BalanceVO> selectBalanceConfirmList(BalanceVO vo) throws Exception ;
	/**
	 * 잔액 검증 리스트 조회 cnt
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int selectBalanceConfirmListCnt(BalanceVO vo) throws Exception ;

	/**
	 * 협력사 일별 배달현황 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<StsVO> selectSts0002(StsVO vo) throws Exception ;
	/**
	 * 라이더 일별 배달현황 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<StsVO> selectSts0003(StsVO vo) throws Exception ;
	/**
	 * 주정산별 협력사별 수익현황
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<StsVO> selectCooperatorProfitStsList(StsVO vo) throws Exception ;
}
