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
public class ActInfo implements Serializable{

	private String taskNo;		// 과제번호
	private String actTp;		// 계좌종류
	private String bnkNm;     // 은행명
	private String actNo;        // 계좌번호
	private String actNm;     // 예금주명
}
