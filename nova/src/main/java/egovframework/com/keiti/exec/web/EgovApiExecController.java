package egovframework.com.keiti.exec.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.keiti.comm.service.TaskInfoVO;
import egovframework.com.keiti.exec.service.CommonDocInfoVO;
import egovframework.com.keiti.exec.service.EgovExecInfoService;
import egovframework.com.keiti.exec.service.ExecFileInfoVO;
import egovframework.com.keiti.exec.service.ExecInfoVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
/**
 * 협약관리
 *
 * @author 조경규
 * @since 2024.07.15
 * @version 1.0
 * @see
 *
 *      수정일 수정자 수정내용 ------- -------- --------------------------- 2024.7.15 조경규
 *      최초 생성
 *      </pre>
 */

@RestController
public class EgovApiExecController {

	private static final Logger logger = LoggerFactory.getLogger(EgovApiExecController.class);

	@Resource(name = "EgovExecInfoService")
	private EgovExecInfoService execInfoService;

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertyService;

	@SuppressWarnings("unused")
	@Autowired
	private DefaultBeanValidator beanValidator;

	/**
	 * 집행내역 조회
	 *
	 * @param eiVO
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "집행내역 조회", order = 380, gid = 40)
	@RequestMapping("/api/exec/exec01001.do")
	public ResponseEntity<?> exec01001(@ModelAttribute ExecInfoVO eiVO, HttpServletRequest request) throws Exception {

			LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			if (!isAuthenticated) {
				return ResponseEntity.status(401).body("Unauthorized");
			}
			TaskInfoVO taskInfoVO = (TaskInfoVO) request.getSession().getAttribute("taskVo");
			eiVO.setSrcTaskNo(taskInfoVO.getTaskNo());

			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(eiVO.getPageIndex());  //1
			paginationInfo.setRecordCountPerPage(eiVO.getPageUnit());   //10
			paginationInfo.setPageSize(eiVO.getPageSize());  // 10

			eiVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
			eiVO.setLastIndex(paginationInfo.getLastRecordIndex());
			eiVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
			Map<String, Object> map = execInfoService.selectExecInfoList(eiVO);
			int totCnt = Integer.parseInt((String) map.get("resultCnt"));

			paginationInfo.setTotalRecordCount(totCnt);

			map.put("paginationInfo", paginationInfo);
			map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

			return ResponseEntity.ok(map);
	}
	/**
	 * 예실대비표 조회
	 *
	 * @param eiVO
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "예실대비표 조회", order = 380, gid = 40)
	@RequestMapping("/api/exec/exec03001.do")
	public ResponseEntity<?> exec03001(@ModelAttribute ExecInfoVO eiVO, HttpServletRequest request) throws Exception {

		LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (!isAuthenticated) {
			return ResponseEntity.status(401).body("Unauthorized");
		}
		TaskInfoVO taskInfoVO = (TaskInfoVO) request.getSession().getAttribute("taskVo");
		eiVO.setSrcTaskNo(taskInfoVO.getTaskNo());
		Map<String, Object> map = execInfoService.selectBdgSummaryInfoList(eiVO);

		map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

		return ResponseEntity.ok(map);
	}
	/**
	 * 집행 방법별 집행내역 조회
	 *
	 * @param eiVO
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "집행 방법별 집행내역 조회", order = 380, gid = 40)
	@RequestMapping("/api/exec/exec03002.do")
	public ResponseEntity<?> exec03002(HttpServletRequest request) throws Exception {

		LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (!isAuthenticated) {
			return ResponseEntity.status(401).body("Unauthorized");
		}
		TaskInfoVO taskInfoVO = (TaskInfoVO) request.getSession().getAttribute("taskVo");
		Map<String, Object> map = execInfoService.selectExecSummaryInfoList(taskInfoVO.getTaskNo());

		map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

		return ResponseEntity.ok(map);
	}
	/**
	 * 공통서류 조회
	 *
	 * @param eiVO
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "공통서류 조회", order = 380, gid = 40)
	@RequestMapping("/api/exec/exec04001.do")
	public ResponseEntity<?> exec04001(@ModelAttribute CommonDocInfoVO cdVO,HttpServletRequest request) throws Exception {
		LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (!isAuthenticated) {
			return ResponseEntity.status(401).body("Unauthorized");
		}
		TaskInfoVO taskInfoVO = (TaskInfoVO) request.getSession().getAttribute("taskVo");
		cdVO.setTaskNo(taskInfoVO.getTaskNo());
		Map<String, Object> map = execInfoService.selectCommonDocInfoList(cdVO);

		map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

		return ResponseEntity.ok(map);
	}
	/**
	 * 공통서류 파일 다운로드
	 *
	 * @param filePath
	 * @param fileName
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "공통서류파일 다운로드", order = 380, gid = 40)
	@RequestMapping("/api/exec/exec04002.do")
	public void exec04002(@ModelAttribute CommonDocInfoVO cdVO, HttpServletRequest request,
			HttpServletResponse response) throws IOException {

		String filePath = null;
		String fileName = null;

		try {
			TaskInfoVO taskInfoVO = (TaskInfoVO) request.getSession().getAttribute("taskVo");
			cdVO.setTaskNo(taskInfoVO.getTaskNo());
			Map<String, Object> map = execInfoService.selectCommonDocInfoList(cdVO);
			@SuppressWarnings("unchecked")
			List<CommonDocInfoVO> result = (List<CommonDocInfoVO>) map.get("resultList");
			if (result != null && !result.isEmpty()) {
				CommonDocInfoVO firstItem = result.get(0); // 첫 번째 인스턴스를 가져옵니다.
				filePath = firstItem.getFilePath()+"/"+firstItem.getFileNm(); // filePath 값을 가져옵니다.
				fileName = firstItem.getFileOrgNm(); // fileName 값을 가져옵니다.

			}
			File file = new File(filePath);

			if (!file.exists()) {
				throw new IOException("파일을 찾을 수 없습니다.");
			}

			String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");
			response.setContentLength((int) file.length());

			try (FileInputStream inStream = new FileInputStream(file);
					OutputStream outStream = response.getOutputStream()) {

				byte[] buffer = new byte[4096];
				int bytesRead;

				while ((bytesRead = inStream.read(buffer)) != -1) {
					outStream.write(buffer, 0, bytesRead);
				}

				outStream.flush();
			}
		} catch (Exception e) {
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
		}
	}
	/**
	 * 공통서류 파일 전체 다운로드
	 *
	 * @param filePath
	 * @param fileName
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "공통서류파일 전체 다운로드", order = 380, gid = 40)
	@RequestMapping("/api/exec/exec04003.do")
	public void exec04003(@ModelAttribute CommonDocInfoVO cdVO, HttpServletRequest request,
	        HttpServletResponse response) throws IOException {

	    try {
	        TaskInfoVO taskInfoVO = (TaskInfoVO) request.getSession().getAttribute("taskVo");
	        cdVO.setTaskNo(taskInfoVO.getTaskNo());
	        Map<String, Object> map = execInfoService.selectCommonDocInfoList(cdVO);
	        @SuppressWarnings("unchecked")
	        List<CommonDocInfoVO> result = (List<CommonDocInfoVO>) map.get("resultList");

	        if (result == null || result.isEmpty()) {
	            throw new IOException("다운로드할 파일이 없습니다.");
	        }

	        String zipFileName = "documents.zip";
	        response.setContentType("application/zip");
	        response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(zipFileName, "UTF-8").replace("+", "%20") + "\"");

	     // Set to track added zip entry names
	        Set<String> addedEntries = new HashSet<>();

	        try (ZipOutputStream zos = new ZipOutputStream(response.getOutputStream())) {
	        	for (CommonDocInfoVO fileInfo : result) {
	                File file = new File(fileInfo.getFilePath() + "/" + fileInfo.getFileNm());

	                if (!file.exists()) {
	                    logger.error("파일을 찾을 수 없습니다: " + file.getAbsolutePath());
	                    continue;
	                }

	                // Generate unique zip entry name
	                String zipEntryName = fileInfo.getFileOrgNm();
	                int counter = 1;
	                while (addedEntries.contains(zipEntryName)) {
	                	int lastDotIndex = zipEntryName.lastIndexOf('.');
	                	String baseName = (lastDotIndex == -1) ? zipEntryName : zipEntryName.substring(0, lastDotIndex);
	                	String extension = (lastDotIndex == -1) ? "" : zipEntryName.substring(lastDotIndex);
	                	zipEntryName = baseName + "(" + counter++ + ")" + extension;
	                }
	                addedEntries.add(zipEntryName);

	                try (FileInputStream fis = new FileInputStream(file)) {
	                    ZipEntry zipEntry = new ZipEntry(zipEntryName);
	                    zos.putNextEntry(zipEntry);

	                    byte[] buffer = new byte[4096];
	                    int bytesRead;
	                    while ((bytesRead = fis.read(buffer)) != -1) {
	                        zos.write(buffer, 0, bytesRead);
	                    }

	                    zos.closeEntry();
	                }
	            }
	            zos.finish();
	        }
	    } catch (Exception e) {
	        response.setContentType("application/json");
	        response.setCharacterEncoding("UTF-8");
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
	    }
	}
	/**
	 * 정산증빙 조회
	 *
	 * @param eiVO
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "정산증빙 조회", order = 380, gid = 40)
	@RequestMapping("/api/exec/exec04031.do")
	public ResponseEntity<?> exec04031(@ModelAttribute ExecInfoVO eiVO,HttpServletRequest request) throws Exception {
		LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (!isAuthenticated) {
			return ResponseEntity.status(401).body("Unauthorized");
		}
		TaskInfoVO taskInfoVO = (TaskInfoVO) request.getSession().getAttribute("taskVo");
		eiVO.setTaskNo(taskInfoVO.getTaskNo());
		Map<String, Object> map = execInfoService.selectExecFileInfoList(eiVO);

		map.put("userId", user == null ? "" : EgovStringUtil.isNullToString(user.getId()));

		return ResponseEntity.ok(map);
	}

	/**
	 * 정산증빙 파일 다운로드
	 *
	 * @param filePath
	 * @param fileName
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "정산증빙파일 다운로드", order = 380, gid = 40)
	@RequestMapping("/api/exec/exec04032.do")
	public void exec04032(@ModelAttribute ExecInfoVO eiVO, HttpServletRequest request,
			HttpServletResponse response) throws IOException {

		String filePath = null;
		String fileName = null;

		try {
			TaskInfoVO taskInfoVO = (TaskInfoVO) request.getSession().getAttribute("taskVo");
			eiVO.setTaskNo(taskInfoVO.getTaskNo());
			Map<String, Object> map = execInfoService.selectExecFileInfoList(eiVO);
			@SuppressWarnings("unchecked")
			List<ExecFileInfoVO> result = (List<ExecFileInfoVO>) map.get("resultList");
			if (result != null && !result.isEmpty()) {
				ExecFileInfoVO firstItem = result.get(0); // 첫 번째 인스턴스를 가져옵니다.
				filePath = firstItem.getFilePath()+"/"+firstItem.getFileNm(); // filePath 값을 가져옵니다.
				fileName = firstItem.getFileOrgNm(); // fileName 값을 가져옵니다.

			}
			File file = new File(filePath);

			if (!file.exists()) {
				throw new IOException("파일을 찾을 수 없습니다.");
			}

			String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");
			response.setContentLength((int) file.length());

			try (FileInputStream inStream = new FileInputStream(file);
					OutputStream outStream = response.getOutputStream()) {

				byte[] buffer = new byte[4096];
				int bytesRead;

				while ((bytesRead = inStream.read(buffer)) != -1) {
					outStream.write(buffer, 0, bytesRead);
				}

				outStream.flush();
			}
		} catch (Exception e) {
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
		}
	}
	/**
	 * 정산증빙 파일 전체 다운로드
	 *
	 * @param filePath
	 * @param fileName
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name = "정산증빙파일 전체 다운로드", order = 380, gid = 40)
	@RequestMapping("/api/exec/exec04033.do")
	public void exec04033(@ModelAttribute ExecInfoVO eiVO, HttpServletRequest request,
	        HttpServletResponse response) throws IOException {

	    try {
	        TaskInfoVO taskInfoVO = (TaskInfoVO) request.getSession().getAttribute("taskVo");
	        eiVO.setTaskNo(taskInfoVO.getTaskNo());
	        Map<String, Object> map = execInfoService.selectExecFileInfoList(eiVO);
	        @SuppressWarnings("unchecked")
	        List<ExecFileInfoVO> result = (List<ExecFileInfoVO>) map.get("resultList");

	        if (result == null || result.isEmpty()) {
	            throw new IOException("다운로드할 파일이 없습니다.");
	        }

	        String zipFileName = "files.zip";
	        response.setContentType("application/zip");
	        response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(zipFileName, "UTF-8").replace("+", "%20") + "\"");

		     // Set to track added zip entry names
	        Set<String> addedEntries = new HashSet<>();

	        try (ZipOutputStream zos = new ZipOutputStream(response.getOutputStream())) {
	            for (ExecFileInfoVO fileInfo : result) {
	                File file = new File(fileInfo.getFilePath() + "/" + fileInfo.getFileNm());

	                if (!file.exists()) {
	                	logger.error("파일을 찾을 수 없습니다: " + file.getAbsolutePath());
	                	continue;
	                    //throw new IOException("파일을 찾을 수 없습니다: " + file.getAbsolutePath());
	                }
	                // Generate unique zip entry name
	                String zipEntryName = fileInfo.getFileOrgNm();
	                int counter = 1;
	                while (addedEntries.contains(zipEntryName)) {
	                	int lastDotIndex = zipEntryName.lastIndexOf('.');
	                	String baseName = (lastDotIndex == -1) ? zipEntryName : zipEntryName.substring(0, lastDotIndex);
	                	String extension = (lastDotIndex == -1) ? "" : zipEntryName.substring(lastDotIndex);
	                	zipEntryName = baseName + "(" + counter++ + ")" + extension;
	                }

	                addedEntries.add(zipEntryName);

	                try (FileInputStream fis = new FileInputStream(file)) {
	                    ZipEntry zipEntry = new ZipEntry(zipEntryName);
	                    zos.putNextEntry(zipEntry);

	                    byte[] buffer = new byte[4096];
	                    int bytesRead;
	                    while ((bytesRead = fis.read(buffer)) != -1) {
	                        zos.write(buffer, 0, bytesRead);
	                    }

	                    zos.closeEntry();
	                }
	            }
	            zos.finish();
	        }
	    } catch (Exception e) {
	        response.setContentType("application/json");
	        response.setCharacterEncoding("UTF-8");
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
	    }
	}

}
