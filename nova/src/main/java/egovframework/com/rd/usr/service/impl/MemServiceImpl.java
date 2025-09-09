package egovframework.com.rd.usr.service.impl;


import java.math.BigDecimal;
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
import egovframework.com.rd.usr.service.MemService;
import egovframework.com.rd.usr.service.vo.CooperatorFeeVO;
import egovframework.com.rd.usr.service.vo.CooperatorVO;
import egovframework.com.rd.usr.service.vo.DayPayVO;
import egovframework.com.rd.usr.service.vo.DeliveryInfoVO;
import egovframework.com.rd.usr.service.vo.DoznTokenVO;
import egovframework.com.rd.usr.service.vo.EtcVO;
import egovframework.com.rd.usr.service.vo.KkoVO;
import egovframework.com.rd.usr.service.vo.Sch;
import egovframework.com.sec.rgm.service.AuthorGroup;
import egovframework.com.sec.rgm.service.EgovAuthorGroupService;
import egovframework.com.uss.umt.service.EgovMberManageService;
import egovframework.com.uss.umt.service.EgovUserManageService;
import egovframework.com.uss.umt.service.MberManageVO;
import egovframework.com.uss.umt.service.UserDefaultVO;
import egovframework.com.uss.umt.service.UserManageVO;
import egovframework.com.uss.umt.service.impl.MberManageDAO;
import egovframework.com.uss.umt.service.impl.UserManageDAO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.com.utl.sim.service.EgovFileScrty;

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
@Service("MemService")
public class MemServiceImpl extends EgovAbstractServiceImpl implements MemService {

	@Resource(name = "MemDAO")
	private MemDAO memDAO;
	@Resource(name = "PayDAO")
	private PayDAO payDAO;

	@Resource(name="userManageDAO")
	private UserManageDAO userManageDAO;
	@Resource(name="mberManageDAO")
	private MberManageDAO mberManageDAO;

	@Resource(name = "userManageService")
	private EgovUserManageService userManageService;

    @Resource(name = "mberManageService")
    private EgovMberManageService mberManageService;

    @Resource(name = "DtyService")
    private DtyService dtyService;

    @Resource(name = "egovAuthorGroupService")
    private EgovAuthorGroupService egovAuthorGroupService;
    /** ID Generation */
	@Resource(name="egovConIdGnrService")
	private EgovIdGnrService egovConIdGnrService;
    /** ID Generation */
	@Resource(name="egovFeeIdGnrService")
	private EgovIdGnrService egovFeeIdGnrService;
    /** ID Generation */
	@Resource(name="egovRFeeIdGnrService")
	private EgovIdGnrService egovRFeeIdGnrService;
    /** ID Generation */
	@Resource(name="egovEtcIdGnrService")
	private EgovIdGnrService egovEtcIdGnrService;
    /** ID Generation */
	@Resource(name="egovKkoIdGnrService")
	private EgovIdGnrService egovKkoIdGnrService;
    /** ID Generation */
	@Resource(name="egovCslIdGnrService")
	private EgovIdGnrService egovCslIdGnrService;


	private static final Logger LOGGER = LoggerFactory.getLogger(MemServiceImpl.class);

	/**
	 * 협력사 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorList(CooperatorVO vo) throws Exception {
		return memDAO.selectCooperatorList(vo);
	}

	/**
	 * 협력사 조회(상세)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorDetailList(CooperatorVO vo) throws Exception {
		return memDAO.selectCooperatorDetailList(vo);
	}
	/**
	 * 협력사 조회(라이더)
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorListRDCnt(CooperatorVO vo) throws Exception {
		return memDAO.selectCooperatorListRDCnt(vo);
	}
	/**
	 * 협력사 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int mergeCooperator(CooperatorVO vo) throws Exception {
		return memDAO.mergeCooperator(vo);
	}
	/**
	 * 협력사 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public void saveCooperator(List<CooperatorVO> list, LoginVO user) throws Exception {
		for( int i = 0 ; i< list.size() ; i++) {
			CooperatorVO vo = list.get(i);
			vo.setCreatId(user.getId());
			vo.setLastUpdusrId(user.getId());
			if("N".equals(vo.getUseAt()) && "T".equals(vo.getGubun()))	//허수데이터
				continue;
			if(vo.getCooperatorId() == null || "".equals(vo.getCooperatorId()))
				continue;

			// 1. 협력사 저장
			CooperatorVO oneVo = memDAO.selectCooperatorByCooperatorId(vo);
			if(oneVo != null) {
				vo.setSchAuthorCode(user.getAuthorCode());
				vo.setSchIhidNum(user.getIhidNum());
				memDAO.updateCooperator(vo);
			} else {
				if("ROLE_ADMIN".equals(user.getAuthorCode())) {	//총판만이 협력사 등록이 가능
					memDAO.insertCooperator(vo);
				}
			}

			// 2. 협력사 수수료 저장
			// 2.1 수수료는 변경시 기존 수수료를 use_yn을 N로 변경 후 새로 insert한다
			// 2.2 기존수수료 조회 후 변경 된 사항이 있을 시에만 insert한다
			List<CooperatorVO> sameFee = memDAO.selectFeeSame(vo);
			if(sameFee.size() == 1) {	//기존 수수료와 현재 등록된 수수료가 같으면 pass
				//pass
			} else if(sameFee.size() > 1){
				//데이터가 이상함. 기존 라인들 지우고 새로 등록
				for(int j = 0 ; j < sameFee.size() ;j++) {
					CooperatorVO delVo = sameFee.get(j);
					memDAO.updateFeeUseNo(delVo);
				}
	    		String feeId = egovFeeIdGnrService.getNextStringId();
	    		vo.setFeeId(feeId);
				memDAO.insertFee(vo);
			} else {
				//수수료가 달라질 시 기존 정책 use_yn을 n로 변경 후 신규 등록
				memDAO.updateFeeUseNo(vo);

	    		String feeId = egovFeeIdGnrService.getNextStringId();
	    		vo.setFeeId(feeId);
				memDAO.insertFee(vo);
			}

		}
	}
	/**
	 * 협력사 ID 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public CooperatorVO saveCooperatorUsr(List<CooperatorVO> list, LoginVO user) throws Exception {
		CooperatorVO returnVo = new CooperatorVO();
        for(int i = 0 ; i< list.size() ;i++) {

        	//RD_COOPERATOR_USR 등록
        	CooperatorVO vo = list.get(i);
        	vo.setMberId(vo.getMberId());
        	vo.setCreatId(user.getId());
        	vo.setLastUpdusrId(user.getId());

//        	CooperatorVO oneVO = memDAO.selectCooperatorUsrByMberId(vo);
//        	if(oneVO != null) {
//        		memDAO.updateCooperatorUsr(vo);
//        	} else {
//        		memDAO.insertCooperatorUsr(vo);
//        	}

        	//comtnemplyrinfo 등록
            UserDefaultVO searchVO = new UserDefaultVO();
            searchVO.setSearchCondition("0");
            searchVO.setSearchKeyword(vo.getMberId());
            UserManageVO userOne = userManageDAO.selectUserListRider(searchVO);
        	if( userOne != null ) {
        		userOne.setEmplyrNm(vo.getUserNm());
        		userOne.setMoblphonNo(vo.getMbtlnum());
        		// 협력사는 자신의 관련 사업자 사용자만 등록한다.
        		if("ROLE_USER".equals(user.getAuthorCode())) {
        			userOne.setIhidnum(user.getIhidNum());
        		} else {
        			userOne.setIhidnum(vo.getIhidnum());
        		}
        		userManageService.updateUser(userOne);


        		//기존 사용자의 패스워드 변경
        		if(!Util.isEmpty(vo.getPassword())) {
        			userOne.setPassword(vo.getPassword());
        			userManageService.updatePasswordInit(userOne);

    		        //알림톡 발송
        			if(!Util.isEmpty(Util.getOnlyNumber(vo.getMbtlnum())) ) {

        				List<KkoVO> kkoList = new ArrayList<KkoVO>();
        				KkoVO kkoOne = new KkoVO();
        				kkoOne.setMberId(vo.getMberId());
        				kkoOne.setMbtlnum(Util.getOnlyNumber(vo.getMbtlnum()));
        				kkoOne.setParam0(vo.getUserNm());
        				kkoOne.setParam1(vo.getPassword());
        				kkoOne.setTemplateCode(EgovProperties.getProperty("Globals.passUserInitAlert"));
        				kkoList.add(kkoOne);

        		        //2. 알림톡 토큰 가져오기
        	        	DoznTokenVO responseData = dtyService.getMsgTocken();

        	        	//3. 메세지 발송
        		        if(!Util.isEmpty(responseData.getSendAccessToken()) && !Util.isEmpty(responseData.getSendRefreshToken())) {

        		        	JSONObject jsonMain = Util.makeKko(kkoList);

        			        LOGGER.debug("json : "+jsonMain.toString());
        	    	        //3. 성공시 메세지 발송
        	    		    dtyService.doznHttpRequestMsg(jsonMain, responseData.getKkoId(), responseData.getSendAccessToken(), responseData.getSendRefreshToken());


        		        } else {	//토큰을 못받아서 발송 못했을 경우에도 사용자 정보를 이력에 쌓아줘야 나중에 찾음
        			        for(int j = 0; j < kkoList.size() ; j++) {
        			        	KkoVO kkoVo = kkoList.get(j);
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
        		String pass = Util.isEmpty(vo.getPassword())? "Daon2025!" : vo.getPassword();
                UserManageVO voMem = new UserManageVO();
                voMem.setEmplyrId(vo.getMberId());
                voMem.setEmplyrNm(vo.getUserNm());
                voMem.setPassword(pass);
                voMem.setMoblphonNo(vo.getMbtlnum());
                // 협력사는 자신의 관련 사업자 사용자만 등록한다.
                if("ROLE_USER".equals(user.getAuthorCode())) {
                	voMem.setIhidnum(user.getIhidNum());
                } else {
                	voMem.setIhidnum(vo.getIhidnum());
        		}
                voMem.setEmplyrSttusCode("P");
        		String uniqId = userManageService.insertUser(voMem);


            	//COMTNEMPLYRSCRTYESTBS 등록
                AuthorGroup authorGroup = new AuthorGroup();
                authorGroup.setUniqId(uniqId);
        		authorGroup.setAuthorCode("ROLE_USER");
        		authorGroup.setMberTyCode("USR01");
        		egovAuthorGroupService.insertAuthorGroup(authorGroup);


		        //알림톡 발송
    			if(!Util.isEmpty(Util.getOnlyNumber(vo.getMbtlnum())) ) {

    				List<KkoVO> kkoList = new ArrayList<KkoVO>();
    				KkoVO kkoOne = new KkoVO();
    				kkoOne.setMberId(vo.getMberId());
    				kkoOne.setMbtlnum(Util.getOnlyNumber(vo.getMbtlnum()));
    				kkoOne.setParam0(vo.getUserNm());
    				kkoOne.setParam1(pass);
    				kkoOne.setTemplateCode(EgovProperties.getProperty("Globals.enterUserAlert"));
    				kkoList.add(kkoOne);

    		        //2. 알림톡 토큰 가져오기
    	        	DoznTokenVO responseData = dtyService.getMsgTocken();

    	        	//3. 메세지 발송
    		        if(!Util.isEmpty(responseData.getSendAccessToken()) && !Util.isEmpty(responseData.getSendRefreshToken())) {

    		        	JSONObject jsonMain = Util.makeKko(kkoList);

    			        LOGGER.debug("json : "+jsonMain.toString());
    	    	        //3. 성공시 메세지 발송
    	    		    dtyService.doznHttpRequestMsg(jsonMain, responseData.getKkoId(), responseData.getSendAccessToken(), responseData.getSendRefreshToken());


    		        } else {	//토큰을 못받아서 발송 못했을 경우에도 사용자 정보를 이력에 쌓아줘야 나중에 찾음
    			        for(int j = 0; j < kkoList.size() ; j++) {
    			        	KkoVO kkoVo = kkoList.get(j);
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
        	returnVo = vo;
        }
        return returnVo;
	}

	/**
	 * 협력사 아이디 등록
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int mergeCooperatorUsr(CooperatorVO vo) throws Exception {
		return memDAO.mergeCooperatorUsr(vo);
	}
	/**
	 * 협력사 아이디 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorUsrListByCooperator(CooperatorVO vo) throws Exception{
		return memDAO.selectCooperatorUsrListByCooperator(vo);
	}

	/**
	 * 협력사별 라이더 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorRiderListByCooperator(CooperatorVO vo) throws Exception{
		return memDAO.selectCooperatorRiderListByCooperator(vo);

	}

	/**
	 * 협력사별 라이더 저장
	 * @param list
	 * @throws Exception
	 */
	public CooperatorVO saveCooperatoRider(List<CooperatorVO> list, LoginVO user) throws Exception {
		CooperatorVO returnVo = new CooperatorVO();
		List<KkoVO> kkoList = new ArrayList<KkoVO>();

        for(int i = 0 ; i< list.size() ;i++) {

        	CooperatorVO vo = list.get(i);
        	vo.setMberId(vo.getMberId());
        	vo.setCreatId(user.getId());
        	vo.setLastUpdusrId(user.getId());

        	//COMTNGNRLMBER 등록
            UserDefaultVO searchVO = new UserDefaultVO();
            searchVO.setSearchCondition("0");
            searchVO.setSearchKeyword(vo.getMberId());
            MberManageVO userOne = mberManageDAO.selectUserListRider(searchVO);
        	if( userOne != null ) {
        		//핸드폰번호 최초등록 시
        		if(Util.isEmpty(userOne.getMbtlnum()) && !Util.isEmpty(vo.getMbtlnum())) {
        			//0. 카카오 발송 정보 저장
        			String pass = vo.getMbtlnum().substring(vo.getMbtlnum().length()-4, vo.getMbtlnum().length());
        			KkoVO kkoOne = new KkoVO();
        			kkoOne.setMberId(vo.getMberId());
        			kkoOne.setMbtlnum(Util.getOnlyNumber(vo.getMbtlnum()));
        			kkoOne.setParam0(vo.getMberNm());
        			kkoOne.setParam1("Daon"+pass+"!");
        			kkoOne.setTemplateCode(EgovProperties.getProperty("Globals.passAlert"));
        			kkoList.add(kkoOne);


        			//1. 임시패스워드와 MBER_CONFIRM_AT를 N로 설정
        			MberManageVO mberManageVO = new MberManageVO();

        		    mberManageVO.setUniqId(userOne.getUniqId());
        	        mberManageVO.setPassword(EgovFileScrty.encryptPassword("Daon"+pass+"!", EgovStringUtil.isNullToString(userOne.getMberId())));
        	        mberManageVO.setMberConfirmAt("N");
        	        mberManageService.updatePasswordSelf(mberManageVO);

        	        /*//2. 알림톡 토큰 가져오기
        	        String responseData = dtyService.getMsgTocken();
        	        LOGGER.debug("responseData1 : "+responseData);


        	        if(!Util.isEmpty(responseData)) {
        		        JSONParser jsonParse = new JSONParser();
        		        JSONObject jsonObj = (JSONObject) jsonParse.parse(responseData);
        		        if("200".equals(jsonObj.get("code")) ) {
	        		        JSONObject data = (JSONObject) jsonObj.get("data");
	        		        DoznTokenVO doznTokenVO = new DoznTokenVO();
	        		        doznTokenVO.setSendAccessToken(data.get("sendAccessToken").toString());
	        		        doznTokenVO.setSendRefreshToken(data.get("sendRefreshToken").toString());

	            	        //3. 성공시 메세지 발송
	        		        String sendData = dtyService.doznHttpRequestMsg("임시", data.get("sendAccessToken").toString(), data.get("sendRefreshToken").toString());

	            	        if(!Util.isEmpty(sendData)) {
	            		        JSONParser jsonParse1 = new JSONParser();
	            		        JSONObject jsonObj1 = (JSONObject) jsonParse1.parse(sendData);
	            		        if("200".equals(jsonObj1.get("code")) ) {

	            		        	JSONObject dataMsg = (JSONObject) jsonObj1.get("data");
	            		        	String reportData = dtyService.doznHttpRequestReport("임시", data.get("sendAccessToken").toString(), data.get("sendRefreshToken").toString(), dataMsg.get("referenceKey").toString());

	            		        	String a = "1";
	            		        }
	            	        }

        		        }

        	        }*/

        		}

        		userOne.setMberNm(vo.getMberNm());
        		userOne.setMoblphonNo(vo.getMbtlnum());
        		mberManageDAO.updateMber(userOne);
        	} else {
        		MberManageVO voMem = new MberManageVO();
                voMem.setMberId(vo.getMberId());
                voMem.setMberNm(vo.getMberNm());
                voMem.setPassword("Daon2025!");
                voMem.setMoblphonNo(vo.getMbtlnum());
                voMem.setMberSttus("P");
                voMem.setMberConfirmAt("N");
        		String uniqId = mberManageService.insertMber(voMem);


            	//COMTNEMPLYRSCRTYESTBS 등록
                AuthorGroup authorGroup = new AuthorGroup();
                authorGroup.setUniqId(uniqId);
        		authorGroup.setAuthorCode("ROLE_USER");
        		authorGroup.setMberTyCode("USR01");
        		egovAuthorGroupService.insertAuthorGroup(authorGroup);

        	}


			//총판 or 협력사
			// 협력사가 권한이 없는 cooperatorId를 등록하려 할 경우 오류 처리
			if("ROLE_USER".equals(user.getAuthorCode())) {
	        	CooperatorVO authChkByCoop =  new CooperatorVO();
	        	authChkByCoop.setMberId(user.getId());
	        	authChkByCoop.setCooperatorId(vo.getCooperatorId());
	        	if(!memDAO.selectAuthChkByCoop(authChkByCoop)) {
	        		throw new IllegalArgumentException("권한이 없는 협력사데이터는 등록되지 않습니다.") ;
	        	}
			}

        	//RD_COOPERATOR_RIDER_CONNECT 등록
        	if(Util.isEmpty(vo.getConId())) {
	        	if(memDAO.selectCooperatorRiderConnectNamugi(vo).size() > 0) {
	        		throw new IllegalArgumentException("이미 등록되어있는 사용자입니다.\n저장을 취소합니다\n\n"+vo.getMberId()+"/"+vo.getMberNm()) ;
	        	}
        	}

        	CooperatorVO oneVO = memDAO.selectCooperatorRiderConnect(vo);
        	if(oneVO == null) {
        		String conId = egovConIdGnrService.getNextStringId();
        		vo.setConId(conId);
        		if(!Util.isEmpty(vo.getMbtlnum())){
        			vo.setRegDt("YES");
        		}
        		memDAO.insertCooperatorRiderConnect(vo);
        	}
        	if(oneVO != null /*&& vo.getFee() != oneVO.getFee()*/ ) {
//        		String conId = egovConIdGnrService.getNextStringId();
//        		vo.setUpConId(vo.getConId());
//        		vo.setConId(conId);
//        		memDAO.insertCooperatorRiderConnect(vo);
        		// TODO 삭제 기능 넣기
//        		if("N".equals(vo.getUseAt()) ) {
//
//        		}
        		if(!Util.isEmpty(vo.getMbtlnum())){
        			vo.setRegDt("YES");
        		}
        		memDAO.updateCooperatorRiderConnect(vo);
        	}



			// 2. 라이더 수수료 저장
        	// 2.0 협력사 수수료와 같으면 use_yn을 n로 변경
			// 2.1 수수료는 변경시 기존 수수료를 use_yn을 N로 변경 후 새로 insert한다
			// 2.2 기존수수료 조회 후 변경 된 사항이 있을 시에만 insert한다
        	CooperatorVO sameFe = memDAO.selectRiderCoopFeeSame(vo);
        	if(sameFe != null && !Util.isEmpty(sameFe.getFeeId())) {
        		//협력사 수수료와 같으면 라이더 정보 저장하지 않는다.(기존 정보는 삭제한다)
				memDAO.updateRiderFeeUseNo(vo);
        	} else {

				List<CooperatorVO> sameFee = memDAO.selectRiderFeeSame(vo);
				if(sameFee.size() == 1) {	//기존 수수료와 현재 등록된 수수료가 같으면 pass
					//pass
				} else if(sameFee.size() > 1){
					//데이터가 이상함. 기존 라인들 지우고 새로 등록
					for(int j = 0 ; j < sameFee.size() ;j++) {
						CooperatorVO delVo = sameFee.get(j);
						memDAO.updateRiderFeeUseNo(delVo);
					}
		    		String rFeeId = egovRFeeIdGnrService.getNextStringId();
		    		vo.setRiderFeeId(rFeeId);
					memDAO.insertRiderFee(vo);
				} else {
					//수수료가 달라질 시 기존 정책 use_yn을 n로 변경 후 신규 등록
					memDAO.updateRiderFeeUseNo(vo);

		    		String rFeeId = egovRFeeIdGnrService.getNextStringId();
		    		vo.setRiderFeeId(rFeeId);
					memDAO.insertRiderFee(vo);
				}
        	}


        	returnVo = vo;
        }

        //알림톡 발송
        if(kkoList.size() > 0) {
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
        }


		return returnVo;
	}
	/**
	 * 협력사 접속 아이디 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorUsrList(CooperatorVO vo) throws Exception {
		return memDAO.selectCooperatorUsrList(vo);
	}
	/**
	 * 권한 있는 협력사 조회 by mberId
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorListByMberId(CooperatorVO vo)throws Exception{
		return memDAO.selectCooperatorListByMberId(vo);
	}
	/**
	 * 라이더 개인정보 조회
	 * @param mberId
	 * @return
	 * @throws Exception
	 */
	public MberManageVO selectMemberInfo(String mberId) throws Exception {
		return memDAO.selectMemberInfo(mberId);
	}

	/**
	 * 관리자측 개인정보 조회
	 * @param mberId
	 * @return
	 * @throws Exception
	 */
	public MberManageVO selectUserInfo(String mberId) throws Exception {
		return memDAO.selectUserInfo(mberId);
	}
	/**
	 * 협력사별 수수료 리스트 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorFeeVO> selectFeeListByCooperatorId (CooperatorFeeVO vo) throws Exception{
		return memDAO.selectFeeListByCooperatorId(vo);
	}

	/**
	 * 수수료 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public CooperatorFeeVO saveCooperatorFee(List<CooperatorFeeVO> list, LoginVO user) throws Exception {
		CooperatorFeeVO returnVo = new CooperatorFeeVO();
//        for(int i = 0 ; i< list.size() ;i++) {
//        	CooperatorFeeVO vo = list.get(i);
//        	vo.setCreatId(user.getId());
//        	vo.setLastUpdusrId(user.getId());
//			vo.setSchAuthorCode(user.getAuthorCode());
//			vo.setSchIhidNum(user.getIhidNum());
//
//			//총판 or 협력사
//			// 협력사가 권한이 없는 cooperatorId를 등록하려 할 경우 오류 처리
//			if("ROLE_USER".equals(user.getAuthorCode())) {
//	        	CooperatorVO authChkByCoop =  new CooperatorVO();
//	        	authChkByCoop.setMberId(user.getId());
//	        	authChkByCoop.setCooperatorId(vo.getCooperatorId());
//	        	if(!memDAO.selectAuthChkByCoop(authChkByCoop)) {
//	        		throw new IllegalArgumentException("권한이 없는 협력사데이터는 등록되지 않습니다.") ;
//	        	}
//			}
//
//			CooperatorFeeVO userOne = memDAO.selectFeeListByFeeId(vo);
//			if(userOne != null) {
//				memDAO.updaetFee(vo);
//			} else {
//        		String feeId = egovFeeIdGnrService.getNextStringId();
//        		vo.setFeeId(feeId);
//				memDAO.insertFee(vo);
//			}
//
//			returnVo = vo;
//
//        }
        return returnVo;
	}

	public List<DeliveryInfoVO> selectDeliveryInfoByMberId(DeliveryInfoVO deliveryInfoVO) throws Exception{
		return memDAO.selectDeliveryInfoByMberId(deliveryInfoVO);
	}

	/**
	 * 협력사,라이더별 대출 리스트 조회
	 * @param etcVO
	 * @return
	 * @throws Exception
	 */
	public List<EtcVO> selectEtcList(EtcVO etcVO) throws Exception{
		return memDAO.selectEtcList(etcVO);
	}
	/**
	 * 협력사,라이더별 대출 리스트 Cnt
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public int selectEtcListCnt(EtcVO vo) throws Exception {
		return memDAO.selectEtcListCnt(vo);
	}

	/**
	 * 협력사,라이더별 대출 리스트 저장
	 * @param etcVO
	 * @return
	 * @throws Exception
	 */
	public EtcVO saveEtcList(List<EtcVO> list) throws Exception{
		EtcVO returnVo = new EtcVO();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		for( int i =0 ; i < list.size() ; i++ ) {
			EtcVO one = list.get(i);
			one.setLastUpdusrId(user.getId());


			//총판 or 협력사
			// 협력사가 권한이 없는 cooperatorId를 등록하려 할 경우 오류 처리
			if("ROLE_USER".equals(user.getAuthorCode())) {
	        	CooperatorVO authChkByCoop =  new CooperatorVO();
	        	authChkByCoop.setMberId(user.getId());
	        	authChkByCoop.setCooperatorId(one.getCooperatorId());
	        	if(!memDAO.selectAuthChkByCoop(authChkByCoop)) {
	        		throw new IllegalArgumentException("권한이 없는 협력사데이터는 등록되지 않습니다.") ;
	        	}
			}

			//기존데이터 정정
			if(!Util.isEmpty(one.getEtcId())) {
				memDAO.updateEtc(one);
			} else {
			//신규 등록
				one.setEtcId(egovEtcIdGnrService.getNextStringId());
				one.setCreatId(user.getId());
				memDAO.insertEtc(one);
			}

			returnVo = one;
		}

		return returnVo;
	}

	/**
	 * 협력사,라이더별 대출 승인요청
	 * @param etcVO
	 * @return
	 * @throws Exception
	 */
	public EtcVO requestEtcList(List<EtcVO> list) throws Exception {
		EtcVO returnVo = new EtcVO();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		List<KkoVO> kkoList = new ArrayList<KkoVO>();

		for( int i =0 ; i < list.size() ; i++ ) {
			EtcVO one = list.get(i);
			one.setLastUpdusrId(user.getId());




			//총판 or 협력사
			// 협력사가 권한이 없는 cooperatorId를 등록하려 할 경우 오류 처리
			if("ROLE_USER".equals(user.getAuthorCode())) {
	        	CooperatorVO authChkByCoop =  new CooperatorVO();
	        	authChkByCoop.setMberId(user.getId());
	        	authChkByCoop.setCooperatorId(one.getCooperatorId());
	        	if(!memDAO.selectAuthChkByCoop(authChkByCoop)) {
	        		throw new IllegalArgumentException("권한이 없는 협력사데이터는 등록되지 않습니다.") ;
	        	}
			}




			//기존데이터 정정
			if(!Util.isEmpty(one.getEtcId())) {
				memDAO.requestEtc(one);
			} else {
			//신규 등록
				one.setEtcId(egovEtcIdGnrService.getNextStringId());
				one.setCreatId(user.getId());
				memDAO.insertEtc(one);
			}

			//승인요청시
			if("TRUE".equals(one.getChk().toUpperCase())) {

				EtcVO etcVo = memDAO.selectEtcOneByEtcId(one);
				if(!Util.isEmpty(etcVo.getMbtlnum())) {
	    			//0. 카카오 발송 정보 저장
	    			KkoVO kkoOne = new KkoVO();
	    			kkoOne.setMberId(etcVo.getMberId());
	    			kkoOne.setMbtlnum(Util.getOnlyNumber(etcVo.getMbtlnum()));
	    			kkoOne.setParam0(etcVo.getGubunNm());
	    			kkoOne.setParam1(etcVo.getMberNm());
	    			kkoOne.setParam2(Util.currencyFormatter( new BigDecimal(etcVo.getPaybackCostAll())));
	    			kkoOne.setTemplateCode(EgovProperties.getProperty("Globals.etcAlert"));
	    			kkoList.add(kkoOne);
				}
			}

			returnVo = one;
		}



        //알림톡 발송
        if(kkoList.size() > 0) {
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
		        	kkoVo.setBigo("대여 승인요청 알림 미발송");
		        	kkoVo.setSendDt(Util.getDay());
		            payDAO.insertKko(kkoVo);
		        }
	        }
        }

		return returnVo;

	}


	/**
	 * 협력사,라이더별 대출 삭제
	 * @param etcVO
	 * @return
	 * @throws Exception
	 */
	public EtcVO deleteEtcList(List<EtcVO> list) throws Exception {
		EtcVO returnVo = new EtcVO();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		for( int i =0 ; i < list.size() ; i++ ) {
			EtcVO one = list.get(i);
			one.setLastUpdusrId(user.getId());




			//총판 or 협력사
			// 협력사가 권한이 없는 cooperatorId를 등록하려 할 경우 오류 처리
			if("ROLE_USER".equals(user.getAuthorCode())) {
	        	CooperatorVO authChkByCoop =  new CooperatorVO();
	        	authChkByCoop.setMberId(user.getId());
	        	authChkByCoop.setCooperatorId(one.getCooperatorId());
	        	if(!memDAO.selectAuthChkByCoop(authChkByCoop)) {
	        		throw new IllegalArgumentException("권한이 없는 협력사데이터는 등록되지 않습니다.") ;
	        	}
			}

			//기존데이터 삭제
			if(!Util.isEmpty(one.getEtcId())) {
				memDAO.deletetEtc(one);
			}

			returnVo = one;
		}

		return returnVo;

	}
	/**
	 * 협력사,라이더별 대출 승인
	 * @param etcVO
	 * @return
	 * @throws Exception
	 */
	public int responseEtc(EtcVO vo) throws Exception {
		return memDAO.responseEtc(vo);
	}


	/**
	 * 대출 입금 리스트 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<DayPayVO> selectEtcInputList(DayPayVO vo) throws Exception {
		return memDAO.selectEtcInputList(vo);
	}

	/**
	 * 관리자가 라이더 로그인을 위한 key 생성
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public String getRandomKey(CooperatorVO vo) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(!"ROLE_ADMIN".equals(user.getAuthorCode())) {
			throw new IllegalArgumentException("운영사만 접속 할 수 있습니다.") ;
		}

		String key = Util.getRandomKey();
		Sch inVo = new Sch();
		inVo.setSearchId(user.getId());
		inVo.setSearchMberId(vo.getMberId());
		inVo.setSearchDate(Util.getDay());
		inVo.setSeleceKey(key);
		memDAO.insertAdminKey(inVo);
		return key;
	}
	/**
	 * 영업사원 리스트 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectSalesUsrList(CooperatorVO vo) throws Exception {
		return memDAO.selectSalesUsrList(vo);
	}

	/**
	 * 영업사원 ID 저장
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public CooperatorVO saveSalesUsr(List<CooperatorVO> list, LoginVO user) throws Exception {
		CooperatorVO returnVo = new CooperatorVO();

		if(!"ROLE_ADMIN".equals(user.getAuthorCode())) {
			throw new IllegalArgumentException("운영사만 등록 할 수 있습니다.") ;
		}

        for(int i = 0 ; i< list.size() ;i++) {

        	CooperatorVO vo = list.get(i);
        	vo.setMberId(vo.getMberId());
        	vo.setCreatId(user.getId());
        	vo.setLastUpdusrId(user.getId());


        	//comtnemplyrinfo 등록
            UserDefaultVO searchVO = new UserDefaultVO();
            searchVO.setSearchCondition("0");
            searchVO.setSearchKeyword(vo.getMberId());
            UserManageVO userOne = userManageDAO.selectUserListRider(searchVO);
        	if( userOne != null ) {
        		userOne.setEmplyrNm(vo.getUserNm());
        		userOne.setMoblphonNo(vo.getMbtlnum());
        		userManageService.updateUser(userOne);


        		//기존 사용자의 패스워드 변경
        		if(!Util.isEmpty(vo.getPassword())) {
        			userOne.setPassword(vo.getPassword());
        			userManageService.updatePasswordInit(userOne);


    		        //알림톡 발송
        			if(!Util.isEmpty(Util.getOnlyNumber(vo.getMbtlnum())) ) {

        				List<KkoVO> kkoList = new ArrayList<KkoVO>();
        				KkoVO kkoOne = new KkoVO();
        				kkoOne.setMberId(vo.getMberId());
        				kkoOne.setMbtlnum(Util.getOnlyNumber(vo.getMbtlnum()));
        				kkoOne.setParam0(vo.getUserNm());
        				kkoOne.setParam1(vo.getPassword());
        				kkoOne.setTemplateCode(EgovProperties.getProperty("Globals.passUserInitAlert"));
        				kkoList.add(kkoOne);

        		        //2. 알림톡 토큰 가져오기
        	        	DoznTokenVO responseData = dtyService.getMsgTocken();

        	        	//3. 메세지 발송
        		        if(!Util.isEmpty(responseData.getSendAccessToken()) && !Util.isEmpty(responseData.getSendRefreshToken())) {

        		        	JSONObject jsonMain = Util.makeKko(kkoList);

        			        LOGGER.debug("json : "+jsonMain.toString());
        	    	        //3. 성공시 메세지 발송
        	    		    dtyService.doznHttpRequestMsg(jsonMain, responseData.getKkoId(), responseData.getSendAccessToken(), responseData.getSendRefreshToken());


        		        } else {	//토큰을 못받아서 발송 못했을 경우에도 사용자 정보를 이력에 쌓아줘야 나중에 찾음
        			        for(int j = 0; j < kkoList.size() ; j++) {
        			        	KkoVO kkoVo = kkoList.get(j);
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
        		String pass = Util.isEmpty(vo.getPassword())? "Daon2025!" : vo.getPassword();
                UserManageVO voMem = new UserManageVO();
                voMem.setEmplyrId(vo.getMberId());
                voMem.setEmplyrNm(vo.getUserNm());
                voMem.setPassword(pass);
                voMem.setMoblphonNo(vo.getMbtlnum());
                voMem.setEmplyrSttusCode("P");
        		String uniqId = userManageService.insertUser(voMem);


            	//COMTNEMPLYRSCRTYESTBS 등록
                AuthorGroup authorGroup = new AuthorGroup();
                authorGroup.setUniqId(uniqId);
        		authorGroup.setAuthorCode("ROLE_SALES");
        		authorGroup.setMberTyCode("USR02");
        		egovAuthorGroupService.insertAuthorGroup(authorGroup);


		        //알림톡 발송
    			if(!Util.isEmpty(Util.getOnlyNumber(vo.getMbtlnum())) ) {

    				List<KkoVO> kkoList = new ArrayList<KkoVO>();
    				KkoVO kkoOne = new KkoVO();
    				kkoOne.setMberId(vo.getMberId());
    				kkoOne.setMbtlnum(Util.getOnlyNumber(vo.getMbtlnum()));
    				kkoOne.setParam0(vo.getUserNm());
    				kkoOne.setParam1(pass);
    				kkoOne.setTemplateCode(EgovProperties.getProperty("Globals.enterSaleAlert"));
    				kkoList.add(kkoOne);

    		        //2. 알림톡 토큰 가져오기
    	        	DoznTokenVO responseData = dtyService.getMsgTocken();

    	        	//3. 메세지 발송
    		        if(!Util.isEmpty(responseData.getSendAccessToken()) && !Util.isEmpty(responseData.getSendRefreshToken())) {

    		        	JSONObject jsonMain = Util.makeKko(kkoList);

    			        LOGGER.debug("json : "+jsonMain.toString());
    	    	        //3. 성공시 메세지 발송
    	    		    dtyService.doznHttpRequestMsg(jsonMain, responseData.getKkoId(), responseData.getSendAccessToken(), responseData.getSendRefreshToken());


    		        } else {	//토큰을 못받아서 발송 못했을 경우에도 사용자 정보를 이력에 쌓아줘야 나중에 찾음
    			        for(int j = 0; j < kkoList.size() ; j++) {
    			        	KkoVO kkoVo = kkoList.get(j);
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
        	returnVo = vo;
        }
        return returnVo;
	}
	/**
	 * 영업사원의 협력사 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List<CooperatorVO> selectCooperatorListBySalesMan(CooperatorVO vo) throws Exception {
		return memDAO.selectCooperatorListBySalesMan(vo);
	}
	/**
	 * 영업사원 협력사 연결 저장
	 * @param list
	 * @return
	 * @throws Exception
	 */
	public CooperatorVO saveCooperatorSalesUsr(List<CooperatorVO> list) throws Exception {
		CooperatorVO returnVo = new CooperatorVO();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		if(!"ROLE_ADMIN".equals(user.getAuthorCode())) {
			throw new IllegalArgumentException("운영사만 등록 할 수 있습니다.") ;
		}

        for(int i = 0 ; i< list.size() ;i++) {

        	CooperatorVO vo = list.get(i);
        	vo.setCreatId(user.getId());
        	vo.setLastUpdusrId(user.getId());

        	if(vo.isChkAt()) {
            	//연결
        		CooperatorVO selvo = memDAO.selectCooperatorSalesByCooperator(vo);
    			if(selvo != null && !selvo.getEmplyrId().equals(vo.getSchId())){
    				throw new IllegalArgumentException("이미 등록된 영업사원이 있는 협력사 입니다["+selvo.getCooperatorNm()+" | "+ selvo.getUserNm()+"]") ;
    			} else if(selvo != null && selvo.getEmplyrId().equals(vo.getSchId())){
    				//이미 해당 영업사원으로 지정된경우 pass
    			} else if(selvo == null){
    				// 연결 등록
    				vo.setCslId(egovCslIdGnrService.getNextStringId());
    				vo.setEmplyrId(vo.getSchId());
    				vo.setUseAt("Y");
    				memDAO.insertCooperatorSales(vo);
    			} else {
    				throw new IllegalArgumentException("예상치 못한 오류가 발생했습니다. 개발자에게 연락 요망") ;
    			}

        	} else {
        		//연결해제
        		memDAO.updateCooperatorSalesNoByEmplyrIdCoop(vo);
        	}

        	returnVo = vo;
        }

		return returnVo;
	}
}