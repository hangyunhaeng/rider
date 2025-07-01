package egovframework.com.rd.usr.service;

import java.util.List;

import egovframework.com.rd.usr.service.vo.NoticeVO;


public interface NotService {

	/**
	 * 공지사항 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertNotice(NoticeVO vo) throws Exception ;

	/**
	 * 공지사항 수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateNotice(NoticeVO vo) throws Exception ;

	/**
	 * 공지사항 조회 by NotId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public NoticeVO selectNoticeByNotId(NoticeVO vo) throws Exception ;
	/**
	 * 공지사항 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<NoticeVO> selectNoticeList(NoticeVO vo) throws Exception ;	/**
	 * 공지사항 리스트 cnt
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int selectNoticeListCnt(NoticeVO vo) throws Exception ;
	/**
	 * 공지사항 삭제
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int deleteNoticeByNotId(NoticeVO vo) throws Exception ;
	/**
	 * 공지사항 표기 list
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<NoticeVO> selectNoticeViewList(NoticeVO vo) throws Exception ;
}
