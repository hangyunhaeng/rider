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
public class ExecSummaryInfo implements Serializable{
	private String gb;         // 구분
	private String execMtd;   // 종류
	private String cnt;        // 건수
	private String amt;        // 금액
	private String vat;        // 부가세
	private String execAmt;    // 등록된집행액
	private String execRat;    // 집행비율
}
