package egovframework.com.rd.usr.service;

import java.util.List;

import egovframework.com.rd.usr.service.vo.BalanceVO;

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
}
