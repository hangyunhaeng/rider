package egovframework.com.rd.usr.service.impl;


import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.rd.usr.service.vo.NoticeVO;
import egovframework.com.uat.uia.web.EgoRDLoginController;


/**
 * @Class Name : DelivertyInfoDao.java
 * @Description :
 * @Modification Information
 *
 *    수정일       수정자         수정내용
 *    -------        -------     -------------------
 *
 * @author
 * @since
 * @version
 * @see
 *
 */
@Repository("NotDAO")
public class NotDAO extends EgovComAbstractDAO {


	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgoRDLoginController.class);

	/**
	 * 공지사항 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertNotice(NoticeVO vo) throws Exception {
		return insert("notDAO.insertNotice", vo);
	}

	/**
	 * 공지사항 수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateNotice(NoticeVO vo) throws Exception {
		return update("notDAO.updateNotice", vo);
	}

	/**
	 * 공지사항 조회 by NotId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public NoticeVO selectNoticeByNotId(NoticeVO vo) throws Exception {
		return selectOne("notDAO.selectNoticeByNotId", vo);
	}
	/**
	 * 공지사항 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<NoticeVO> selectNoticeList(NoticeVO vo) throws Exception {
		vo.setSchTotal(null);
		return selectList("notDAO.selectNoticeList", vo);
	}
	/**
	 * 공지사항 리스트 totalCnt
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int selectNoticeListCnt(NoticeVO vo) throws Exception {
		NoticeVO reVo = selectOne("notDAO.selectNoticeListCnt", vo);
		return reVo.getTotalCnt();
	}
	/**
	 * 공지사항 삭제
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int deleteNoticeByNotId(NoticeVO vo) throws Exception {
		return update("notDAO.deleteNoticeByNotId", vo);
	}
	/**
	 * 공지사항 표기 list
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<NoticeVO> selectNoticeViewList(NoticeVO vo) throws Exception {
		return selectList("notDAO.selectNoticeViewList", vo);
	}
}


