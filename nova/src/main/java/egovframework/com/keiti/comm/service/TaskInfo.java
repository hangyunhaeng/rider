package egovframework.com.keiti.comm.service;

import java.io.Serializable;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.com.utl.enc.SeedUtil;
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
public class TaskInfo implements Serializable{
	private static final Logger LOGGER = LoggerFactory.getLogger(TaskInfo.class);

	private String no;         // No
	private String taskNo;     // 과제번호
	private String taskNm;     // 과제명
	private String taskYr;     // 협약년도
	private String taskTp;     // 과제구분
	private String taskSt;     // 과제상태
	private String mnrNm;      // 책임자명
	private String mnrBirthdt; // 책임자생년월일
	private String mnrEngnm;   // 책임자영문명
	private String mnrEmail;   // 책임자이메일
	private String mnrPos;     // 책임자직위
	private String mnrDept;    // 책임자부서
	private String mnrPhone;   // 책임자전화
	private String mnrFax;     // 책임자팩스
	private String mnrGd;      // 책임자성별
	private String instNm;     // 기관명
	private String instBizno;  // 기관사업자번호
	private String curyrStartdt; // 당해년도시작일자
	private String curyrEnddt;   // 당해년도종료일자
	private String totalStartdt; // 총시작일자
	private String totalEnddt;   // 총종료일자
	private String bizNm;        // 사업명
	private String subFd;        // 중분야
	private String stlAgc;       // 정산기관
	private String stlPhone;     // 정산기관연락처
	private String stlEmail;     // 정산기관이메일
	private String execTp;       // 집행유형
	private String bizCd;        // 사업코드
	private String totBdg;        // 총연구비
	private String actNo;        // 사업비수령계좌

    // 책임자명을 설정하는 메소드
    public void setMnrNm(String mnrNm) {
    	try {
    		this.mnrNm = SeedUtil.decrypt(mnrNm);
    	}catch (Exception e) {
    		LOGGER.error("ERROR: DECRYPT FAILED{}", e);
		}
    }
    // 책임자생년월일을 설정하는 메소드
    public void setMnrBirthdt(String mnrBirthdt) {
    	try {
    		this.mnrBirthdt = SeedUtil.decrypt(mnrBirthdt);
    	}catch (Exception e) {
    		 LOGGER.error("ERROR: DECRYPT FAILED{}", e);
		}
    }
    // 책임자영문명을 설정하는 메소드
    public void setMnrEngnm(String mnrEngnm) {
    	try {
    		this.mnrEngnm = SeedUtil.decrypt(mnrEngnm);
    	}catch (Exception e) {
    		LOGGER.error("ERROR: DECRYPT FAILED{}", e);
    	}
    }
    // 책임자이메일을 설정하는 메소드
    public void setMnrEmail(String mnrEmail) {
    	try {
    		this.mnrEmail = SeedUtil.decrypt(mnrEmail);
    	}catch (Exception e) {
    		LOGGER.error("ERROR: DECRYPT FAILED{}", e);
    	}
    }
    // 책임자휴대번호를 설정하는 메소드
    public void setMnrPhone(String mnrPhone) {
    	try {
    		this.mnrPhone = SeedUtil.decrypt(mnrPhone);
    	}catch (Exception e) {
    		LOGGER.error("ERROR: DECRYPT FAILED{}", e);
    	}
    }
}
