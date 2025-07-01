package egovframework.com.keiti.conv.service;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
/**
 * 재원별예산을 위한 모델 클래스
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
public class FndBdgInfo implements Serializable{

	private String taskNo;		// 과제번호
	private String fndTp;		// 재원코드
	private String fndTpNm;     // 재원이름
	private String cash;        // 현금
	private String nonCash;     // 현물
	private String tot;         // 합계


}
