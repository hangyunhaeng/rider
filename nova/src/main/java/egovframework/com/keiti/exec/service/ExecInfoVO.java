package egovframework.com.keiti.exec.service;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * 집행관리를 위한 VO 모델 클래스
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
@EqualsAndHashCode(callSuper=false)
public class ExecInfoVO extends ExecInfo implements Serializable  {
	private String seqN; // seqN
	private String srcOpt = ""; // 검색_집행검색종류
	private String srcOptValue = ""; // 검색_집행검색값
	private String srcSRgDt;   // 등록일자시작
	private String srcERgDt;   // 등록일자종료
	private String srcSTrnsDt; // 지급일자시작
	private String srcETrnsDt; // 지급일자종료
	private String srcIoeCd;   // 세목
	private String srcExecMtd; // 집행방법
	private String srcSts;     // 진행상태
	private String srcUnionF;	//미등록꼐좌이체건, 카드건 포함여부
	private String srcTaskNo;     // 진행상태
	private String searchBgnDe = ""; // 검색시작일
	private String searchCnd = ""; // 검색조건
	private String searchEndDe = ""; // 검색종료일
	private String searchWrd = ""; // 검색단어
	private String srcOrderBy = ""; // 검색단어
	private long sortOrdr = 0L; // 정렬순서(DESC,ASC)
	private String searchUseYn = ""; // 검색사용여부
	private int pageIndex = 1; // 현재페이지
	private int pageUnit = 10; // 페이지개수
	private int pageSize = 10; // 페이지사이즈
	private int firstIndex = 1; // 첫페이지 인덱스
	private int lastIndex = 1; // 마지막페이지 인덱스
	private int recordCountPerPage = 10; // 페이지당 레코드 개수
	private int rowNo = 0; // 레코드 번호
	private String frstRegisterNm = ""; // 최초 등록자명
	private String lastUpdusrNm = ""; // 최종 수정자명
	private List<ExecInfo> execInfo = new ArrayList<ExecInfo>(); // 과제정보

}
