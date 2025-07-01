package egovframework.com.keiti.conv.service;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * 주소록관리를 위한 VO 모델 클래스
 * @author 조경규
 * @since 2024.07.29
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2024.07.29  조경규          최초 생성
 * </pre>
 */
@SuppressWarnings("serial")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class PartInfoVO extends PartInfo implements Serializable {

    private String searchBgnDe = ""; // 검색시작일
    private String searchCnd = ""; // 검색조건
    private String searchEndDe = ""; // 검색종료일
    private String searchWrd = ""; // 검색단어
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
    private List<PartInfo> partInfo = new ArrayList<>(); // 과제정보

    // partInfo 필드에 대해 불변 리스트를 반환하는 setter 메서드
    public void setPartInfo(List<PartInfo> partInfo) {
        this.partInfo = Collections.unmodifiableList(partInfo); // partInfo 필드에 대해 불변 리스트를 반환하는 setter 메서드
    }
}