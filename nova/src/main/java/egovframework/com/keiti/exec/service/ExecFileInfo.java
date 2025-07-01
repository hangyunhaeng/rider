package egovframework.com.keiti.exec.service;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
/**
 * 집행정산증빙을 위한 모델 클래스
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
public class ExecFileInfo implements Serializable{
    private String taskNo;          // 과제번호
    private String execNo;          // 집행번호
    private String seqN;            // 순번
    private String filePath;        // 파일경로
    private String fileNm;          // 파일명
    private String fileOrgNm;       // 파일기관명
}