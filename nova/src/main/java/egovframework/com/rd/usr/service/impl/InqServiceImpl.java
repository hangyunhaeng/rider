package egovframework.com.rd.usr.service.impl;


import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.LoginVO;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.InqService;
import egovframework.com.rd.usr.service.vo.InquiryVO;

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
@Service("InqService")
public class InqServiceImpl extends EgovAbstractServiceImpl implements InqService {


	@Resource(name = "InqDAO")
	private InqDAO inqDAO;
    /** ID Generation */
	@Resource(name="egovInqIdGnrService")
	private EgovIdGnrService egovInqIdGnrService;

	private static final Logger LOGGER = LoggerFactory.getLogger(InqServiceImpl.class);

	/**
	 * 공지사항 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int insertInquiry(InquiryVO vo) throws Exception {
		return inqDAO.insertInquiry(vo);
	}

	/**
	 * 공지사항 수정
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int updateInquiry(InquiryVO vo) throws Exception {
		return inqDAO.updateInquiry(vo);
	}

	/**
	 * 공지사항 조회 by NotId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public InquiryVO selectInquiryByInqId(InquiryVO vo) throws Exception {
		return inqDAO.selectInquiryByInqId(vo);
	}
	/**
	 * 1:1문의 저장
	 * @param vo
	 * @throws Exception
	 */
	public void saveInquiry(InquiryVO vo) throws Exception {

		if(Util.isEmpty(vo.getInqId())) {
        	String inqId = egovInqIdGnrService.getNextStringId();
        	vo.setInqId(inqId);
        	inqDAO.insertInquiry(vo);
        } else {
        	inqDAO.updateInquiry(vo);
        }

	}
	/**
	 * 1:1문의 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<InquiryVO> selectInquiryList(InquiryVO vo) throws Exception {
		return inqDAO.selectInquiryList(vo);
	}
	/**
	 * 1:1문의 리스트 Cnt
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int selectInquiryListCnt(InquiryVO vo) throws Exception {
		return inqDAO.selectInquiryListCnt(vo);
	}
	/**
	 * 1:1문의 상세
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<InquiryVO> selectInquiryListByInqId(InquiryVO vo) throws Exception {
		return inqDAO.selectInquiryListByInqId(vo);
	}
	/**
	 * 1:1문의 라이더용 리스트
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<InquiryVO> selectGnrInquiryList(InquiryVO vo) throws Exception {
		return inqDAO.selectGnrInquiryList(vo);
	}
	/**
	 * 1:1문의 삭제
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int deleteInquiryByInqId(InquiryVO vo) throws Exception {
		return inqDAO.deleteInquiryByInqId(vo);
	}
}
