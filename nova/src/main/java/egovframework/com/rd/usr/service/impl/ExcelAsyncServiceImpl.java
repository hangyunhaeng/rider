package egovframework.com.rd.usr.service.impl;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.usr.service.DtyService;
import egovframework.com.rd.usr.service.ExcelAsyncService;
import egovframework.com.rd.usr.service.ExcelSheetHandler;
import egovframework.com.rd.usr.service.ExcelUtil;

@Service("ExcelAsyncService")
public class ExcelAsyncServiceImpl implements ExcelAsyncService{



    @Resource(name = "DtyService")
    private DtyService dtyService;
	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil fileUtil;

	@Resource(name="EgovFileMngService")
	private EgovFileMngService fileMngService;

	private static final Logger LOGGER = LoggerFactory.getLogger(ExcelAsyncServiceImpl.class);

    private ExcelUtil excelUtil = new ExcelUtil();

    /**
    * 일정산 엑셀 업로드 (비동기)
    */
    @Async("excelAsyncExecutor")
    public void excelUpload(Map<String, MultipartFile> files, LoginVO loginVO) throws Exception {

    	InputStream fileInputStream = files.get("fileName").getInputStream();
    	List<FileVO> result = fileUtil.parseFileInf(files, "xls_", 0, "", "", loginVO.getId(), "DAY");
		String atchFileId = fileMngService.insertFileInfs(result);

        // 엑셀 파일 읽어오기
        List<ExcelSheetHandler> excelDataBySheet= excelUtil.readExcel(fileInputStream);

        // 엑셀 DB 저장
        dtyService.insertExcelData(excelDataBySheet, atchFileId, loginVO);
    }


    /**
    * 주정산 엑셀 업로드 (비동기)
    */
    @Async("excelAsyncExecutor")
    public void excelUploadByWeek(InputStream fileInputStream, String atchFileId, LoginVO loginVO) throws Exception {

        // 엑셀 파일 읽어오기
        List<ExcelSheetHandler> excelDataBySheet = null;
        try {
        	excelDataBySheet = excelUtil.readExcel(fileInputStream);
        }catch(Exception e) {
        	e.printStackTrace();
        	LOGGER.error(e.toString());

        	// 엑셀을 읽지 못하면 암호화 되어있을수 있음
        	// 업로드 파일을 삭제 처리 하고 종료한다.
			FileVO fileVO = new FileVO();
			fileVO.setAtchFileId(atchFileId);
			fileMngService.deleteAllFileInf(fileVO);
        	throw new IllegalArgumentException("엑셀을 로드 하지 못했습니다.") ;
        }

        // 엑셀 DB 저장(sheet0)
        String weekId = dtyService.insertExcelDataWeek(excelDataBySheet, atchFileId, loginVO);

        // 엑셀 DB 저장(sheet1)
        dtyService.insertExcelDataWeekRider(excelDataBySheet, atchFileId, loginVO, weekId);
    }

    /**
    * 주정산 엑셀 업로드 (동기)
    */
    public void excelUploadByWeekSync(InputStream fileInputStream, String atchFileId, LoginVO loginVO) throws Exception {

        // 엑셀 파일 읽어오기
        List<ExcelSheetHandler> excelDataBySheet = null;
        try {
        	excelDataBySheet = excelUtil.readExcel(fileInputStream);
        }catch(Exception e) {
        	e.printStackTrace();
        	LOGGER.error(e.toString());

        	// 엑셀을 읽지 못하면 암호화 되어있을수 있음
        	// 업로드 파일을 삭제 처리 하고 종료한다.
			FileVO fileVO = new FileVO();
			fileVO.setAtchFileId(atchFileId);
			fileMngService.deleteAllFileInf(fileVO);
        	throw new IllegalArgumentException("엑셀을 로드 하지 못했습니다.") ;
        }

        // 엑셀 DB 저장(sheet0)
        String weekId = dtyService.insertExcelDataWeek(excelDataBySheet, atchFileId, loginVO);

        // 엑셀 DB 저장(sheet1)
        dtyService.insertExcelDataWeekRider(excelDataBySheet, atchFileId, loginVO, weekId);
    }


}