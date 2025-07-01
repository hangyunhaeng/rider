package egovframework.com.keiti.conv.service;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
/**
 * 비목별예산을 위한 모델 클래스
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
 *
 * </pre>
 */
@SuppressWarnings("serial")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class IoeBdgInfo implements Serializable{

	private String bizCd;        	// 과제번호
	private String bimok;          // 비목
	private String semok;          // 세목
	private String use;         	// 사용내역
	private String csAmt;            // 현금
	private String thAmt;         // 현물
	private String totAmt;             // 합계
	private String rat;             // 비율
	private String level;             // 뎁스


}
