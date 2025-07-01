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
public class ExecInfo implements Serializable{
	private String no;         // No
	private String rgDt;       // 등록일
	private String taskNo;     // TASK번호
	private String trnsDt;     // 지급일
	private String trnsAmt;    // 지급금액
	private String rmk;        // 사용내역
	private String sts;        // 진행상태
	private String stsNm;      // 진행상태
	private String execMtd;    // 집행방법
	private String execMtdNm;  // 집행방법
	private String ioeCd;      // 세목
	private String ioeCdNm;    // 세목
	private String execAmt;    // 사용금액
	private String vat;        // 부가세
	private String issueId;     // 세금계산서
	private String stlKey;     // 정산증빙
	private String execNo;     // 결의확인번호
	private String execDt;     // 집행일
	private String mct;        // 지급처
	private String totAmt;     // 결의확인번호
	private String bigo;       // 비고
	private String usg;       // 지급처
	private String payAmt;       // 지급금액
	private String matchId;       // 집행고유번호
}
