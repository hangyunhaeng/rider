package egovframework.com.rd.usr.service;

import java.util.List;

import egovframework.com.cmm.LoginVO;
import egovframework.com.rd.usr.service.vo.InquiryVO;
import egovframework.com.rd.usr.service.vo.NoticeVO;


public interface InqService {

	/**
	 * 1:1문의 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertInquiry(InquiryVO vo) throws Exception ;

	/**
	 * 1:1문의 수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateInquiry(InquiryVO vo) throws Exception ;

	/**
	 * 1:1문의 조회 by InqId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public InquiryVO selectInquiryByInqId(InquiryVO vo) throws Exception ;
	/**
	 * 1:1문의 저장
	 * @param vo
	 * @throws Exception
	 */
	public void saveInquiry(InquiryVO vo) throws Exception ;

	/**
	 * 1:1문의 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<InquiryVO> selectInquiryList(InquiryVO vo) throws Exception ;
	/**
	 * 1:1문의 리스트 Cnt
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int selectInquiryListCnt(InquiryVO vo) throws Exception ;
	/**
	 * 1:1문의 상세
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<InquiryVO> selectInquiryListByInqId(InquiryVO vo) throws Exception ;
	/**
	 * 1:1문의 라이더용 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<InquiryVO> selectGnrInquiryList(InquiryVO vo) throws Exception ;
	/**
	 * 1:1문의 삭제
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int deleteInquiryByInqId(InquiryVO vo) throws Exception ;
}
