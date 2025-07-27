package egovframework.com.rd.usr.service;


import egovframework.com.rd.usr.service.vo.BalanceVO;


public interface BalanceService {


	public int transactionBalance(BalanceVO vo) throws Exception ;
	public BalanceVO selectBalanceByMberId(BalanceVO vo) throws Exception ;

	public BalanceVO selectBalanceByIdx(BalanceVO vo) throws Exception ;

}
