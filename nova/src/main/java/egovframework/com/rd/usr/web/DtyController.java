package egovframework.com.rd.usr.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.slf4j.Logger;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.SessionVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.Util;
import egovframework.com.rd.usr.service.DtyService;
import egovframework.com.rd.usr.service.ExcelAsyncService;
import egovframework.com.rd.usr.service.RotService;
import egovframework.com.rd.usr.service.vo.DeliveryErrorVO;
import egovframework.com.rd.usr.service.vo.DeliveryInfoVO;
import egovframework.com.rd.usr.service.vo.WeekInfoVO;
import egovframework.com.rd.usr.service.vo.WeekRiderInfoVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;

/**
 * 엑셀 업로드 테스트
 *
 * @author 한균행
 * @since 2025.04.18
 * @version 1.0
 * @see
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *  2025.04.18
 *      </pre>
 */

@Controller
public class DtyController {

    @Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;


	@Resource(name="EgovFileMngService")
	private EgovFileMngService fileMngService;

	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil fileUtil;


    @Resource(name = "DtyService")
    private DtyService dtyService;

    @Resource(name = "ExcelAsyncService")
    private ExcelAsyncService excelAsyncService;
    @Resource(name = "RotService")
    private RotService rotService;
    @Resource(name="ehcache")
    Ehcache gCache ;

    @SuppressWarnings("unused")
	@Autowired
    private DefaultBeanValidator beanValidator;

	private static final Logger LOGGER = LoggerFactory.getLogger(DtyController.class);


	/**
	 * 협력사 정보 가져오기
	 * @param weekInfoVO
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0000_0001.do")
	public ResponseEntity<?> dty0000_0001(HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();


        //총판 or 협력사
        WeekInfoVO vo = new WeekInfoVO();
        vo.setSchAuthorCode(user.getAuthorCode());
        vo.setSchIhidNum(user.getIhidNum());
        vo.setSearchId(user.getId());

        map.put("list", dtyService.selectCooperatorList(vo));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

    @IncludedInfo(name="엑셀업로드", order = 380, gid = 40)
    @RequestMapping("/usr/dty0001.do")
    public String dty0001(@ModelAttribute("DeliveryInfoVO") DeliveryInfoVO deliveryInfoVO, HttpServletRequest request,ModelMap model) throws Exception {
    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        model.addAttribute("deliveryInfoVO", deliveryInfoVO);
        return "egovframework/usr/dty/dty0001";
    }


	@RequestMapping("/file/fileUpload.do")
    public ResponseEntity<?> uploadSingleFile(final MultipartHttpServletRequest multiRequest, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{


    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //사용자 정보

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();
    	List<Map<String, Object>> excelList = new ArrayList<Map<String, Object>>();

    	//1. 화면에서 넘어온 엑셀 파일을 was와 db에 저장
    	List<FileVO> result = null;
    	final Map<String, MultipartFile> files = multiRequest.getFileMap();

    	if(!files.isEmpty()) {
    		result = fileUtil.parseFileInf(files, "xls_", 0, "", "", user.getId());
    		fileMngService.insertFileInfs(result);


        	//2. 엑셀 파일 load
    		//2.1 파일은 1개씩만 올릴꺼니까 맵이지만 fileName으로 고정한다.
    		//비번없는 파일 업로드시
    		Workbook workbook = WorkbookFactory.create(files.get("fileName").getInputStream());
            // 엑셀파일에서 첫번째 시트 불러오기
            Sheet worksheet = workbook.getSheetAt(0);

        	List<String> mapKeyList = new ArrayList<String>();
            // getPhysicalNumberOfRow 는 행의 갯수를 불러오는 매소드
            for (int i = 0; i < worksheet.getPhysicalNumberOfRows(); i++) {

                // i번째 행 정보 가져오기
                Row row = worksheet.getRow(i);
                if (row != null) {

                    //excel Row value
                    Map<String, Object> excelRowMap =  new HashMap<String, Object>();

                	int cellCnt = row.getPhysicalNumberOfCells();
                	// i번째 행의 j번째 셀 정보 가져오기
                	for (int j = 0; j <= cellCnt; j++) {
                		Cell cell = row.getCell(j);
                		String value = "";

                		if(cell == null) {
                			continue;
                		}

            			switch (cell.getCellTypeEnum()) {
            			case FORMULA:
                			value = cell.getCellFormula();
                			break;
            			case NUMERIC:
            				value = cell.getNumericCellValue()+"";
            				break;
            			case STRING:
            				value = cell.getStringCellValue()+"";
            				break;
            			case BLANK:
            				value = cell.getBooleanCellValue()+"";
            				break;
            			case ERROR:
            				value = cell.getErrorCellValue()+"";
            				break;
            			}

//                		LOGGER.debug("엑셀 value : "+value+" || 열 : "+i+"  || 행 : "+j);


            			//0번째 행은 엑셀맵키로 쓸꺼다.
            			if(i == 0) {
            				mapKeyList.add(value);
            				continue;
            			}

            			//엑셀의 Row 실제 데이터
            			excelRowMap.put(mapKeyList.get(j), value);

                	}
                	if(i == 0) continue;	//0번째라인은 헤더라서 데이터에 담지 않는다.
                	excelList.add(excelRowMap);
                }
            }
    		/*
    		//복호화를 해보자!!
    		String password ="ryuwin5541";

			//엑셀업로드 다른 버전 ( 미테스트 - 해보자)
			DecryptExcelFile def = new DecryptExcelFile(mf, colM);
			data = def.readFile(pw);	// password


    		//엑셀 버전 구분없이 엑셀로드
    		Workbook workbook = WorkbookFactory.create(files.get("fileName").getInputStream(), password);
    		 */

    		//엑셀 버전별 엑셀 로드
			/*
			String filenm = files.get("fileName").getOriginalFilename();
			if(filenm.indexOf("xlsx") != -1) { // 확장자 2007 이후 버전
				POIFSFileSystem fs= new POIFSFileSystem(files.get("fileName").getInputStream());
				EncryptionInfo info = new EncryptionInfo(fs);
				Decryptor decryptor = Decryptor.getInstance(info);

				if (!decryptor.verifyPassword(password)) {	// 패스워드 일치하지 않음
					throw new Exception(filenm+" 파일의 패스워드가 일치하지 않습니다.");
				}

				LOGGER.debug("----");
				InputStream dataStream = decryptor.getDataStream(fs);
				Workbook workbook1 = new XSSFWorkbook(dataStream);
				LOGGER.debug("----");

			} else { // xls 확장자 2003 이전 버전
				try {
					password ="3098701474";
					POIFSFileSystem fs = new POIFSFileSystem(files.get("fileName").getInputStream());
					Biff8EncryptionKey.setCurrentUserPassword(password);
					Workbook workbook2 = new HSSFWorkbook(fs);
				} catch(EncryptedDocumentException e) {
					throw new Exception(filenm+" 파일의 패스워드가 일치하지 않습니다.");
				}
			}*/

    	}
    	map.put("excelData", excelList);
    	map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));
        return ResponseEntity.ok(map);
    }

	@RequestMapping("/usr/dty0001_0001.do")
    public ResponseEntity<?> dty0001_0001(final MultipartHttpServletRequest multiRequest, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }


        int sCnt = 0;
        int fCnt = 0;

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();
    	List<Map<String, Object>> excelList = new ArrayList<Map<String, Object>>();

    	//1. 화면에서 넘어온 엑셀 파일을 was와 db에 저장
    	List<FileVO> result = null;
    	final Map<String, MultipartFile> files = multiRequest.getFileMap();

    	if(!files.isEmpty()) {
    		result = fileUtil.parseFileInf(files, "xls_", 0, "", "", user.getId());
    		String atchFileId = fileMngService.insertFileInfs(result);


        	//2. 엑셀 파일 load
    		//2.1 파일은 1개씩만 올릴꺼니까 맵이지만 fileName으로 고정한다.
    		//비번없는 파일 업로드시
    		Workbook workbook = WorkbookFactory.create(files.get("fileName").getInputStream());
            // 엑셀파일에서 첫번째 시트 불러오기
            Sheet worksheet = workbook.getSheetAt(0);

        	List<String> mapKeyList = new ArrayList<String>();
            // getPhysicalNumberOfRow 는 행의 갯수를 불러오는 매소드
            for (int i = 0; i < worksheet.getPhysicalNumberOfRows(); i++) {

                // i번째 행 정보 가져오기
                Row row = worksheet.getRow(i);
                if (row != null) {

                    //excel Row value
                    Map<String, Object> excelRowMap =  new HashMap<String, Object>();

                	int cellCnt = row.getPhysicalNumberOfCells();
                	// i번째 행의 j번째 셀 정보 가져오기
                	for (int j = 0; j <= cellCnt; j++) {
                		Cell cell = row.getCell(j);
                		String value = "";

                		if(cell == null) {
                			continue;
                		}

            			switch (cell.getCellTypeEnum()) {
            			case FORMULA:
                			value = cell.getCellFormula();
                			break;
            			case NUMERIC:
            				value = cell.getNumericCellValue()+"";
            				break;
            			case STRING:
            				value = cell.getStringCellValue()+"";
            				break;
            			case BLANK:
            				value = cell.getBooleanCellValue()+"";
            				break;
            			case ERROR:
            				value = cell.getErrorCellValue()+"";
            				break;
            			}


            			//0번째 행은 엑셀맵키로 쓸꺼다.
            			if(i == 0) {
            				mapKeyList.add(value);
            				continue;
            			}

            			//엑셀의 Row 실제 데이터
            			excelRowMap.put(mapKeyList.get(j), value);

                	}
                	if(i == 0) continue;	//0번째라인은 헤더라서 데이터에 담지 않는다.

                	DeliveryInfoVO deliveryInfoVO = new DeliveryInfoVO();
                	deliveryInfoVO.setCooperatorId((String)excelRowMap.get("협력사아이디"));
                	deliveryInfoVO.setRunDe((String)excelRowMap.get("운행일"));
                	deliveryInfoVO.setDeliverySn((String)excelRowMap.get("배달번호"));
                	deliveryInfoVO.setAtchFileId(atchFileId);
                	deliveryInfoVO.setCreatId(user.getId());
                	if(dtyService.insertDeliveryInfo(deliveryInfoVO)) {
                		sCnt++;
                		continue;
                	}
                	fCnt++;
                	excelList.add(excelRowMap);
                }
            }

    	}
    	map.put("excelData", excelList);
    	map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));
    	map.put("sCnt", sCnt);
    	map.put("fCnt", fCnt);
        return ResponseEntity.ok(map);
    }

	/**
	 * 일별정산자료 업로드
	 * @param multiRequest
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0001_0002.do")
    public ResponseEntity<?> dty0001_0002(final MultipartHttpServletRequest multiRequest, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }


    	//1. 화면에서 넘어온 엑셀 파일을 was와 db에 저장
    	final Map<String, MultipartFile> files = multiRequest.getFileMap();

    	if(!files.isEmpty()) {

        	//2. 엑셀 파일 load
    		//2.1 파일은 1개씩만 올릴꺼니까 맵이지만 fileName으로 고정한다.
    		//비번없는 파일 업로드시
    		excelAsyncService.excelUpload(files, user);

    	}

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }
	/**
	 * 특정일에 업로드된 파일명 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0001_0003.do")
	 public ResponseEntity<?> dty0001_0003(@ModelAttribute("FileVO") FileVO fileVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        fileVO.setSchAuthorCode(user.getAuthorCode());
        fileVO.setSchIhidNum(user.getIhidNum());
        List<FileVO> fileList = fileMngService.selectFileListByInserDate(fileVO);

        map.put("fileList", fileList);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }

	/**
	 * 파일별 업로드 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0001_0004.do")
	public ResponseEntity<?> dty0001_0004(@ModelAttribute("DeliveryInfoVO") DeliveryInfoVO deliveryInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        deliveryInfoVO.setSchAuthorCode(user.getAuthorCode());
        deliveryInfoVO.setSchIhidNum(user.getIhidNum());
        deliveryInfoVO.setSearchGubun("FILE");

        List<DeliveryInfoVO> list = dtyService.selectDeliveryInfoByAtchFileId(deliveryInfoVO);
        List<DeliveryErrorVO> listE = null;
        if(!"false".equals(deliveryInfoVO.getSearchError()))listE = dtyService.selectDeliveryErrorByAtchFileId(deliveryInfoVO);

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("listE", listE);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

    @RequestMapping("/usr/dty0002.do")
    public String dty0002(@ModelAttribute("DeliveryInfoVO") DeliveryInfoVO deliveryInfoVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        model.addAttribute("deliveryInfoVO", deliveryInfoVO);
        return "egovframework/usr/dty/dty0002";
    }


	/**
	 * 일별정산자료 업로드 (async)
	 * @param multiRequest
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0002_0002.do")
    public ResponseEntity<?> dty0002_0002(final MultipartHttpServletRequest multiRequest, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }


    	//1. 화면에서 넘어온 엑셀 파일을 was와 db에 저장
    	List<FileVO> result = null;
    	final Map<String, MultipartFile> files = multiRequest.getFileMap();

    	if(!files.isEmpty()) {
    		result = fileUtil.parseFileInf(files, "xls_", 0, "", "", user.getId(), "WEEK");
    		String atchFileId = fileMngService.insertFileInfs(result);

        	//2. 엑셀 파일 load
    		//2.1 파일은 1개씩만 올릴꺼니까 맵이지만 fileName으로 고정한다.
    		//비번없는 파일 업로드시
    		excelAsyncService.excelUploadByWeek(files.get("fileName").getInputStream(), atchFileId, user);
    	}

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }
	/**
	 * 일별정산자료 업로드 (sync)
	 *
	 * 주별자료 업로드는 async로 하지 말까???- 에러처리가 안될꺼 같음- 업로드 후 에러, 성공 여부를 보여주자
	 * @param multiRequest
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0002_0003.do")
    public ResponseEntity<?> dty0002_0003(final MultipartHttpServletRequest multiRequest, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{


    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

    	//1. 화면에서 넘어온 엑셀 파일을 was와 db에 저장
    	List<FileVO> result = null;
    	final Map<String, MultipartFile> files = multiRequest.getFileMap();

    	if(!files.isEmpty()) {
    		result = fileUtil.parseFileInf(files, "xls_", 0, "", "", user.getId(), "WEEK");
    		String atchFileId = fileMngService.insertFileInfs(result);

    		try {
	        	//2. 엑셀 파일 load
	    		//2.1 파일은 1개씩만 올릴꺼니까 맵이지만 fileName으로 고정한다.
	    		//비번없는 파일 업로드시
	    		excelAsyncService.excelUploadByWeekSync(files.get("fileName").getInputStream(), atchFileId, user);

    		} catch (Exception e) {
    			e.printStackTrace();
    			LOGGER.error(e.toString());
    			// 4. 업로드 오류시 파일을 삭제한다
    			FileVO fileVO = new FileVO();
    			fileVO.setAtchFileId(atchFileId);
    			fileMngService.deleteAllFileInf(fileVO);
    			return ResponseEntity.ok(map);
    		}

    		// 3. 업로드된 데이터 조회
	        WeekInfoVO weekInfoVO = new WeekInfoVO();
	        weekInfoVO.setSearchAtchFileId(atchFileId);
	        List<WeekInfoVO> list = dtyService.selectWeekInfoByAtchFileId(weekInfoVO);
	        List<WeekRiderInfoVO> listRider = dtyService.selectWeekRiderInfoByAtchFileId(weekInfoVO);

	        map.put("list", list);
	        map.put("listRider", listRider);
    	}
    	map.put("resultCode", "success");

        return ResponseEntity.ok(map);
    }


	/**
	 * 주별정산자료 업로드 (sync)
	 *
	 * 주별자료 업로드는 async로 하지 말까???- 에러처리가 안될꺼 같음- 업로드 후 에러, 성공 여부를 보여주자
	 * 대용량 업로드가 아닌 wookSheet 방식 업로드
	 * @param multiRequest
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0002_0005.do")
    public ResponseEntity<?> dty0002_0005(final MultipartHttpServletRequest multiRequest, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{


    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();


    	final Map<String, MultipartFile> files = multiRequest.getFileMap();

    	String atchFileId;
    	if(!files.isEmpty()) {

    		try {
    			atchFileId = dtyService.saveExcelDataWeek(files);

    		} catch (Exception e) {
    			e.printStackTrace();
    			LOGGER.error(e.toString());
    			map.put("resultCode", "fail");
    			map.put("resultMsg", e.getMessage());
    			return ResponseEntity.ok(map);
    		}

    		// 3. 업로드된 데이터 조회
	        WeekInfoVO weekInfoVO = new WeekInfoVO();
	        weekInfoVO.setSearchAtchFileId(atchFileId);
	        List<WeekInfoVO> list = dtyService.selectWeekInfoByAtchFileId(weekInfoVO);
	        List<WeekRiderInfoVO> listRider = dtyService.selectWeekRiderInfoByAtchFileId(weekInfoVO);

	        map.put("list", list);
	        map.put("listRider", listRider);
    	}
    	map.put("resultCode", "success");

        return ResponseEntity.ok(map);
    }

	/**
	 * 파일별 업로드 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0002_0004.do")
	public ResponseEntity<?> dty0002_0004(@ModelAttribute("WeekInfoVO") WeekInfoVO weekInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }


        //총판 or 협력사
        weekInfoVO.setSchAuthorCode(user.getAuthorCode());
        weekInfoVO.setSchIhidNum(user.getIhidNum());

        List<WeekInfoVO> list = dtyService.selectWeekInfoByAtchFileId(weekInfoVO);
        List<WeekRiderInfoVO> listRider = dtyService.selectWeekRiderInfoByAtchFileId(weekInfoVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("listRider", listRider);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 자료 업로드 이력
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/dty0003.do")
    public String dty0003(HttpServletRequest request,ModelMap model) throws Exception {
    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        return "egovframework/usr/dty/dty0003";
    }
	@RequestMapping("/usr/dty0003_0001.do")
	public ResponseEntity<?> dty0003_0001(@ModelAttribute("WeekInfoVO") WeekInfoVO weekInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{
		//return value
		Map<String, Object> map =  new HashMap<String, Object>();

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
            map.put("resultCode", "logout");
            return ResponseEntity.ok(map);
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }


        //총판 or 협력사
        weekInfoVO.setSchAuthorCode(user.getAuthorCode());
        weekInfoVO.setSchIhidNum(user.getIhidNum());

        map.put("resultWeek", dtyService.selectUploadStateInWeek(weekInfoVO));
        map.put("resultDay", dtyService.selectUploadStateInDay(weekInfoVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 주정산 파일 삭제
	 * 확정 않한 파일만 삭제 할수 있음
	 * @param weekInfoVO
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0003_0002.do")
	public ResponseEntity<?> dty0003_0002(@ModelAttribute("WeekInfoVO") WeekInfoVO weekInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{
		//return value
		Map<String, Object> map =  new HashMap<String, Object>();

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
            map.put("resultCode", "logout");
            return ResponseEntity.ok(map);
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }


        //총판 or 협력사
        weekInfoVO.setSchAuthorCode(user.getAuthorCode());
        weekInfoVO.setSchIhidNum(user.getIhidNum());


		try {
	        dtyService.deleteWeekAtchFile(weekInfoVO);
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.error(e.toString());
			map.put("resultCode", "fail");
			map.put("resultMsg", e.getMessage());
			return ResponseEntity.ok(map);
		}


        map.put("resultWeek", dtyService.selectUploadStateInWeek(weekInfoVO));
        map.put("resultDay", dtyService.selectUploadStateInDay(weekInfoVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 일정산 파일 삭제
	 * 확정 않한 파일만 삭제 할수 있음
	 * @param weekInfoVO
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0003_0003.do")
	public ResponseEntity<?> dty0003_0003(@ModelAttribute("DeliveryInfoVO") WeekInfoVO weekInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{
		//return value
		Map<String, Object> map =  new HashMap<String, Object>();

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
            map.put("resultCode", "logout");
            return ResponseEntity.ok(map);
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }


        //총판 or 협력사
        weekInfoVO.setSchAuthorCode(user.getAuthorCode());
        weekInfoVO.setSchIhidNum(user.getIhidNum());


		try {
	        dtyService.deleteDayAtchFile(weekInfoVO);
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.error(e.toString());
			map.put("resultCode", "fail");
			map.put("resultMsg", e.getMessage());
			return ResponseEntity.ok(map);
		}
        map.put("resultWeek", dtyService.selectUploadStateInWeek(weekInfoVO));
        map.put("resultDay", dtyService.selectUploadStateInDay(weekInfoVO));
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 배달 정보 조회
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/dty0004.do")
    public String dty0004(HttpServletRequest request,ModelMap model) throws Exception {
    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        //검색조건 2주제한 해제 id
        Ehcache cache = gCache.getCacheManager().getCache("commCd");
        if(cache.get("exclus") == null) cache.put(new Element("exclus", rotService.selectExclusList()));
		model.addAttribute("exclus", new ObjectMapper().writeValueAsString(cache.get("exclus").getObjectValue()));

        return "egovframework/usr/dty/dty0004";
    }

	/**
	 * 파일별 업로드 리스트 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0004_0001.do")
	public ResponseEntity<?> dty0004_0001(@ModelAttribute("DeliveryInfoVO") DeliveryInfoVO deliveryInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        deliveryInfoVO.setSchAuthorCode(user.getAuthorCode());
        deliveryInfoVO.setSchIhidNum(user.getIhidNum());

        List<DeliveryInfoVO> list = dtyService.selectDeliveryInfoByParam(deliveryInfoVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}

	/**
	 * 확정 페이지
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping("/usr/dty0005.do")
    public String dty0005(HttpServletRequest request,ModelMap model) throws Exception {
    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        return "egovframework/usr/dty/dty0005";
    }


	/**
	 * 일정산 내역 조회
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0005_0001.do")
	public ResponseEntity<?> dty0005_0001(@ModelAttribute("DeliveryInfoVO") DeliveryInfoVO deliveryInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        deliveryInfoVO.setSchAuthorCode(user.getAuthorCode());
        deliveryInfoVO.setSchIhidNum(user.getIhidNum());

        List<DeliveryInfoVO> list = dtyService.selectDeliveryInfoByParam(deliveryInfoVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}


	/**
	 * 주정산 내역 조회
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0005_0002.do")
	public ResponseEntity<?> dty0005_0002(@ModelAttribute("WeekInfoVO") WeekInfoVO weekInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        weekInfoVO.setSchAuthorCode(user.getAuthorCode());
        weekInfoVO.setSchIhidNum(user.getIhidNum());

        List<WeekInfoVO> list = dtyService.selectWeekInfoByParam(weekInfoVO);
        List<WeekRiderInfoVO> listRider = dtyService.selectWeekRiderInfoByParam(weekInfoVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("listRider", listRider);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}


	/**
	 * 일정산 내역 확정
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0005_0003.do")
	public ResponseEntity<?> dty0005_0003(@ModelAttribute("DeliveryInfoVO") DeliveryInfoVO deliveryInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        deliveryInfoVO.setSchAuthorCode(user.getAuthorCode());
        deliveryInfoVO.setSchIhidNum(user.getIhidNum());

	    try {
	        dtyService.fixDay(deliveryInfoVO);

	        List<DeliveryInfoVO> list = dtyService.selectDeliveryInfoByParam(deliveryInfoVO);

	        map.put("list", list);
	        map.put("resultCode", "success");
	    }catch(Exception e) {
			e.printStackTrace();
			LOGGER.error(e.toString());
			map.put("resultCode", "fail");
			map.put("resultMsg", e.getMessage());
	    }
        return ResponseEntity.ok(map);
	}



	/**
	 * 주정산 내역 확정
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0005_0004.do")
	public ResponseEntity<?> dty0005_0004(@ModelAttribute("WeekInfoVO") WeekInfoVO weekInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        weekInfoVO.setSchAuthorCode(user.getAuthorCode());
        weekInfoVO.setSchIhidNum(user.getIhidNum());

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        try {
	        dtyService.fixWeek(weekInfoVO);

	        List<WeekInfoVO> list = dtyService.selectWeekInfoByParam(weekInfoVO);
	        List<WeekRiderInfoVO> listRider = dtyService.selectWeekRiderInfoByParam(weekInfoVO);

	        map.put("list", list);
	        map.put("listRider", listRider);
	        map.put("resultCode", "success");
        } catch(Exception e) {
			LOGGER.error(e.toString());
	        map.put("resultCode", "fail");
			map.put("resultMsg", e.getMessage());
        }
        return ResponseEntity.ok(map);
	}

	/**
	 * 미확정 주정산 파일명 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0005_0005.do")
	 public ResponseEntity<?> dty0005_0005(@ModelAttribute("FileVO") FileVO fileVO, HttpServletRequest request) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        fileVO.setSchAuthorCode(user.getAuthorCode());
        fileVO.setSchIhidNum(user.getIhidNum());
        List<FileVO> fileList = fileMngService.selectWeekFileLIstByNullFixDay(fileVO);

        map.put("fileList", fileList);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }

    @RequestMapping("/usr/dty0006.do")
    public String dty0006(@ModelAttribute("DeliveryInfoVO") DeliveryInfoVO deliveryInfoVO, HttpServletRequest request,ModelMap model) throws Exception {

    	//로그인 체크
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        if(!Util.isUsr()) {
        	return "egovframework/com/cmm/error/accessDenied";
        }

        return "egovframework/usr/dty/dty0006";
    }

	/**
	 * 특정 정산일의 확정된 주정산 파일명 가져오기
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0006_0001.do")
	 public ResponseEntity<?> dty0006_0001(@ModelAttribute("FileVO") FileVO fileVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        //총판 or 협력사
        fileVO.setSchAuthorCode(user.getAuthorCode());
        fileVO.setSchIhidNum(user.getIhidNum());
        List<FileVO> fileList = fileMngService.selectWeekFileListByFixDay(fileVO);

        map.put("fileList", fileList);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
    }

	/**
	 * 주정산 내역 조회
	 * @param request
	 * @param sessionVO
	 * @param model
	 * @param status
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/usr/dty0006_0002.do")
	public ResponseEntity<?> dty0006_0002(@ModelAttribute("WeekInfoVO") WeekInfoVO weekInfoVO, HttpServletRequest request, SessionVO sessionVO, ModelMap model, SessionStatus status) throws Exception{

    	//로그인 체크
        LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

        if(!isAuthenticated) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        if(!Util.isUsr()) {
        	return ResponseEntity.status(401).body("Unauthorized");
        }

        //총판 or 협력사
        weekInfoVO.setSchAuthorCode(user.getAuthorCode());
        weekInfoVO.setSchIhidNum(user.getIhidNum());

        List<WeekInfoVO> list = dtyService.selectWeekInfoOutByParam(weekInfoVO);
        List<WeekRiderInfoVO> listRider = dtyService.selectWeekRiderInfoOutByParam(weekInfoVO);
        //return value
        Map<String, Object> map =  new HashMap<String, Object>();

        map.put("list", list);
        map.put("listRider", listRider);
        map.put("resultCode", "success");
        return ResponseEntity.ok(map);
	}


}
