package egovframework.com.rd.usr.service.impl;



import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.rd.usr.service.vo.InquiryVO;
import egovframework.com.rd.usr.service.vo.KkoVO;
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
@Repository("InqDAO")
public class InqDAO extends EgovComAbstractDAO {


	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(EgoRDLoginController.class);

	/**
	 * 1:1문의 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertInquiry(InquiryVO vo) throws Exception {
		return insert("inqDAO.insertInquiry", vo);
	}

	/**
	 * 1:1문의 수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateInquiry(InquiryVO vo) throws Exception {
		return update("inqDAO.updateInquiry", vo);
	}

	/**
	 * 1:1문의 조회 by InqId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public InquiryVO selectInquiryByInqId(InquiryVO vo) throws Exception {
		return selectOne("inqDAO.selectInquiryByInqId", vo);
	}
	/**
	 * 1:1문의 답변의 원본 조회 by upInqId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public InquiryVO selectInquiryByUpInqId(InquiryVO vo) throws Exception {
		return selectOne("inqDAO.selectInquiryByUpInqId", vo);
	}

	/**
	 * 1:1문의 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<InquiryVO> selectInquiryList(InquiryVO vo) throws Exception {
		return selectList("inqDAO.selectInquiryList", vo);
	}
	/**
	 * 1:1문의 리스트 Cnt
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int selectInquiryListCnt(InquiryVO vo) throws Exception {
		InquiryVO reVo = selectOne("inqDAO.selectInquiryListCnt", vo);
		return reVo.getTotalCnt();
	}
	/**
	 * 1:1문의 상세
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<InquiryVO> selectInquiryListByInqId(InquiryVO vo) throws Exception {
		return selectList("inqDAO.selectInquiryListByInqId", vo);
	}
	/**
	 * 1:1문의 라이더용 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<InquiryVO> selectGnrInquiryList(InquiryVO vo) throws Exception {
		return selectList("inqDAO.selectGnrInquiryList", vo);
	}
	/**
	 * 1:1문의 삭제
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int deleteInquiryByInqId(InquiryVO vo) throws Exception {
		return update("inqDAO.deleteInquiryByInqId", vo);
	}

	/**
	 * 1:1 문의 답변 등룍 요청 알림
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<KkoVO> selectReqUserList(InquiryVO vo) throws Exception {
		return selectList("inqDAO.selectReqUserList", vo);
	}
}


