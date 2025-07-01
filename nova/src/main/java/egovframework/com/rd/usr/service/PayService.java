package egovframework.com.rd.usr.service;

import java.util.List;

import egovframework.com.rd.usr.service.vo.DoszDSResultVO;
import egovframework.com.rd.usr.service.vo.HistoryVO;

public interface PayService {

	/**
	 * 입출금내역 리스트 가져오기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<HistoryVO> selectPayList(HistoryVO vo) throws Exception ;

	/**
	 * 대사 이력 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DoszDSResultVO> selectDoznDs(DoszDSResultVO vo) throws Exception;
}
