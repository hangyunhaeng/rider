package egovframework.com.rd.usr.service.impl;


import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.com.rd.usr.service.NotService;
import egovframework.com.rd.usr.service.vo.NoticeVO;

/**
 * @Class Name : DtyServiceImpl.java
 * @Description :
 * @Modification
 *
 *    수정일       수정자         수정내용
 *    -------        -------     -------------------
 *
 *
 * @author
 * @since
 * @version
 * @see
 *
 */
@Service("NotService")
public class NotServiceImpl extends EgovAbstractServiceImpl implements NotService {


	@Resource(name = "NotDAO")
	private NotDAO notDAO;

	private static final Logger LOGGER = LoggerFactory.getLogger(NotServiceImpl.class);

	/**
	 * 공지사항 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertNotice(NoticeVO vo) throws Exception {
		return notDAO.insertNotice(vo);
	}

	/**
	 * 공지사항 수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateNotice(NoticeVO vo) throws Exception {
		return notDAO.updateNotice(vo);
	}

	/**
	 * 공지사항 조회 by NotId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public NoticeVO selectNoticeByNotId(NoticeVO vo) throws Exception {
		return notDAO.selectNoticeByNotId(vo);
	}
	/**
	 * 공지사항 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<NoticeVO> selectNoticeList(NoticeVO vo) throws Exception {
		return notDAO.selectNoticeList(vo);
	}
	/**
	 * 공지사항 리스트 cnt
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int selectNoticeListCnt(NoticeVO vo) throws Exception {
		return notDAO.selectNoticeListCnt(vo);
	}
	/**
	 * 공지사항 삭제
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int deleteNoticeByNotId(NoticeVO vo) throws Exception {
		return notDAO.deleteNoticeByNotId(vo);
	}
	/**
	 * 공지사항 표기 list
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<NoticeVO> selectNoticeViewList(NoticeVO vo) throws Exception {
		return notDAO.selectNoticeViewList(vo);
	}
}
