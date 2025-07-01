package egovframework.com.keiti.conv.service;

import java.io.Serializable;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.com.utl.enc.SeedUtil;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
/**
 * 참여연구원 관리를 위한 모델 클래스
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
public class PartInfo implements Serializable{
	private static final Logger LOGGER = LoggerFactory.getLogger(PartInfo.class);
	private String taskNo;        // 과제번호
	private String nm;            // 이름 (예: 김상국)
	private String engNm;         // 영문이름 (예: KimSangGuk)
	private String gd;            // 성별 (예: 남)
	private String isMng;         // 책임자여부 (예: 책임자)
	private String dob;           // 생년월일 (예: 19530719)
	private String email;         // 이메일 (예: sg***@kier.re.kr, 마스킹 제외)
	private String phone;         // 휴대폰 (예: 010-4405-****, 마스킹 제외)
	private String partStartdt;   // 참여기간시작
	private String partEnddt;     // 참여기간종료
	private String partRat;       // 참여율
	private String org;           // 소속기관
	private String dept;          // 소속부서
	private String pos;           // 직위
    // 책임자명을 설정하는 메소드

    public void setNm(String nm) {
    	try {
    		this.nm = SeedUtil.decrypt(nm);
    	}catch (Exception e) {
    		LOGGER.error("ERROR: DECRYPT FAILED{}", e);
		}
    }
    // 책임자생년월일을 설정하는 메소드
    public void setDob(String dob) {
    	try {
    		this.dob = SeedUtil.decrypt(dob);
    	}catch (Exception e) {
    		LOGGER.error("ERROR: DECRYPT FAILED{}", e);
		}
    }
    // 책임자영문명을 설정하는 메소드
    public void setEngNm(String engNm) {
    	try {
    		this.engNm = SeedUtil.decrypt(engNm);
    	}catch (Exception e) {
    		LOGGER.error("ERROR: DECRYPT FAILED{}", e);
    	}
    }
    // 책임자이메일을 설정하는 메소드
    public void setEmail(String email) {
    	try {
    		this.email = SeedUtil.decrypt(email);
    	}catch (Exception e) {
    		LOGGER.error("ERROR: DECRYPT FAILED{}", e);
    	}
    }
    // 책임자휴대번호를 설정하는 메소드
    public void setPhone(String phone) {
    	try {
    		this.phone = SeedUtil.decrypt(phone);
    	}catch (Exception e) {
    		LOGGER.error("ERROR: DECRYPT FAILED{}", e);
    	}
    }
}
