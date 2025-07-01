package egovframework.com.rd.usr.service;

import java.io.InputStream;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.LoginVO;


public interface ExcelAsyncService {


    /**
    * 일정산 엑셀 업로드 (비동기)
    */
	public void excelUpload(Map<String, MultipartFile> files, LoginVO loginVO) throws Exception ;
    /**
    * 주정산 엑셀 업로드 (비동기)
    */
    public void excelUploadByWeek(InputStream fileInputStream, String atchFileId, LoginVO loginVO) throws Exception ;

    /**
    * 주정산 엑셀 업로드 (동기)
    */
    public void excelUploadByWeekSync(InputStream fileInputStream, String atchFileId, LoginVO loginVO) throws Exception ;

}