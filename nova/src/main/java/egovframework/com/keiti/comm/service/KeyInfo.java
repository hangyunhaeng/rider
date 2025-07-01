package egovframework.com.keiti.comm.service;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
/**
 * TASK 관리를 위한 모델 클래스
 * @author 조경규
 * @since 2024.07.25
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2024.07.25  조경규          최초 생성
 *
 * </pre>
 */
@SuppressWarnings("serial")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class KeyInfo implements Serializable{
	private String key;      // key
	private String value;    // value
	private String path;     // path
}
