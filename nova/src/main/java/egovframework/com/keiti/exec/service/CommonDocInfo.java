package egovframework.com.keiti.exec.service;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
/**
 * 집행관리를 위한 모델 클래스
 * @author 조경규
 * @since 2024.07.19
 * @version 1.0
 * @see
 *
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2024.7.19  조경규          최초 생성
 *
 */
@SuppressWarnings("serial")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommonDocInfo implements Serializable{
	private String taskNo;			// 타스크번호
	private String rtmItm;          // 체크항목
	private String rtmKey;          // 거래키
	private String seqN;          	// 순번
	private String filePath;        // 파일경로
	private String fileNm;        	// 파일이름
	private String fileOrgNm;       // 원본파일이름
	private String fullPath;        // 전체파일경로
}