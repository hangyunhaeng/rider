package egovframework.com.rd.usr.service.impl;


import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.DtyService;
import egovframework.com.rd.usr.service.InqService;
import egovframework.com.rd.usr.service.vo.DoznTokenVO;
import egovframework.com.rd.usr.service.vo.InquiryVO;
import egovframework.com.rd.usr.service.vo.KkoVO;

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
	@Resource(name = "PayDAO")
	private PayDAO payDAO;

    @Resource(name = "DtyService")
    private DtyService dtyService;
    /** ID Generation */
	@Resource(name="egovInqIdGnrService")
	private EgovIdGnrService egovInqIdGnrService;
	@Resource(name="egovInqIdGnrService")
	private EgovIdGnrService egovKkoIdGnrService;


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

		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(Util.isEmpty(vo.getInqId())) {
        	String inqId = egovInqIdGnrService.getNextStringId();
        	vo.setInqId(inqId);
        	inqDAO.insertInquiry(vo);

        	//라이더가 1:1문의 등록시 답변달 대상자에게 알림톡 발송
        	if(Util.isGnr()) {
        		List<KkoVO> ingReq = inqDAO.selectReqUserList(vo);
        		for(int i = 0; i < ingReq.size() ; i++) {
        			KkoVO kkoOne = ingReq.get(i);
        			kkoOne.setTemplateCode(EgovProperties.getProperty("Globals.inqReqAlert"));
        		}
		        //알림톡 발송
        		if(ingReq.size() > 0) {
			        //2. 알림톡 토큰 가져오기
		        	DoznTokenVO responseData = dtyService.getMsgTocken();

		        	//3. 메세지 발송
			        if(!Util.isEmpty(responseData.getSendAccessToken()) && !Util.isEmpty(responseData.getSendRefreshToken())) {

			        	JSONObject jsonMain = Util.makeKko(ingReq);

				        LOGGER.debug("json : "+jsonMain.toString());
		    	        //3. 성공시 메세지 발송
		    		    dtyService.doznHttpRequestMsg(jsonMain, responseData.getKkoId(), responseData.getSendAccessToken(), responseData.getSendRefreshToken());


			        } else {	//토큰을 못받아서 발송 못했을 경우에도 사용자 정보를 이력에 쌓아줘야 나중에 찾음
				        for(int i = 0; i < ingReq.size() ; i++) {
				        	KkoVO kkoVo = ingReq.get(i);
				            //거래이력 누적
				        	kkoVo.setKkoId(egovKkoIdGnrService.getNextStringId());
				        	kkoVo.setUpKkoId(responseData.getKkoId());
				        	kkoVo.setGubun("2");	//메세지
				        	kkoVo.setUrl("/api/v1/send");
				        	kkoVo.setCreatId(user.getId());
				        	kkoVo.setBigo("알림 미발송");
				        	kkoVo.setSendDt(Util.getDay());
				            payDAO.insertKko(kkoVo);
				        }
			        }
        		}
        	}
        } else {
        	inqDAO.updateInquiry(vo);
        }
		if(vo.getUpInqId() != null) {

			//알림톡 발송 대상 조회 (1:1문의 답변 등록 알림)
			InquiryVO upVo = inqDAO.selectInquiryByUpInqId(vo);
			if(!Util.isEmpty(Util.getOnlyNumber(upVo.getMbtlnum())) ) {
				List<KkoVO> kkoList = new ArrayList<KkoVO>();
				KkoVO kkoOne = new KkoVO();
				kkoOne.setMberId(upVo.getCreatId());
				kkoOne.setMbtlnum(Util.getOnlyNumber(upVo.getMbtlnum()));
				kkoOne.setParam0(upVo.getCreatNm());
				kkoOne.setTemplateCode(EgovProperties.getProperty("Globals.inqAlert"));
				kkoList.add(kkoOne);

		        //알림톡 발송
		        //2. 알림톡 토큰 가져오기
	        	DoznTokenVO responseData = dtyService.getMsgTocken();

	        	//3. 메세지 발송
		        if(!Util.isEmpty(responseData.getSendAccessToken()) && !Util.isEmpty(responseData.getSendRefreshToken())) {

		        	JSONObject jsonMain = Util.makeKko(kkoList);

			        LOGGER.debug("json : "+jsonMain.toString());
	    	        //3. 성공시 메세지 발송
	    		    dtyService.doznHttpRequestMsg(jsonMain, responseData.getKkoId(), responseData.getSendAccessToken(), responseData.getSendRefreshToken());


		        } else {	//토큰을 못받아서 발송 못했을 경우에도 사용자 정보를 이력에 쌓아줘야 나중에 찾음
			        for(int i = 0; i < kkoList.size() ; i++) {
			        	KkoVO kkoVo = kkoList.get(i);
			            //거래이력 누적
			        	kkoVo.setKkoId(egovKkoIdGnrService.getNextStringId());
			        	kkoVo.setUpKkoId(responseData.getKkoId());
			        	kkoVo.setGubun("2");	//메세지
			        	kkoVo.setUrl("/api/v1/send");
			        	kkoVo.setCreatId(user.getId());
			        	kkoVo.setBigo("알림 미발송");
			        	kkoVo.setSendDt(Util.getDay());
			            payDAO.insertKko(kkoVo);
			        }
		        }
			}//end if(!Util.isEmpty(upVo.getMbtlnum()) )
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
