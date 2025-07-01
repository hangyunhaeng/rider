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
public class BdgSummaryInfo implements Serializable{
	private String ioeCd;       // 비목명
	private String lev;
	private String path;
	private String ioeNm;       // 비목명
	private String bdgCash;     // 현금 (A)
	private String bdgNon;  // 현물 (B)
	private String bdgTot;      // 계 (C=A+B)
	private String execCash;    // 현금 (D)
	private String execNon; // 현물 (E)
	private String execVat;     // 부가세 (F)
	private String execTot;     // 합계 (G=D+E)
	private String execSum;     // 총사용액(합계 + 부가세)
	private String balCash;     // 현금 (H=A+N+O-D)
	private String balNon;  // 현물 (I=B-E)
	private String balTot;      // 합계 (J=H+I)
	private String execRat;     // 집행비율 (K)
	private String execCnt;     // 집행건수
	private String chgCa;    // 전년도 이월액 (N)
	private String chgIa;    // 예산이자 발생액 (O)
	private String chgTot;      // 예산총계 (P=C+N+O)
	private String sumInptF;      // 부분합 여부
}
