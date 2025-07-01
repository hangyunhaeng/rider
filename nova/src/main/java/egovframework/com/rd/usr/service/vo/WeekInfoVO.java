package egovframework.com.rd.usr.service.vo;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 주차별 정산 VO 클래스
 * @author
 * @since
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------      --------    ---------------------------
 *
 * </pre>
 */

@SuppressWarnings("serial")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@EqualsAndHashCode(callSuper = true)
public class WeekInfoVO extends Sch implements Serializable {

	/** 주정산내역 ID */
	private String weekId;
	/** 협력사아이디 */
	private String cooperatorId;
	/** 정산시작일 */
	private String accountsStDt;
	/** 정산종료일 */
	private String accountsEdDt;
	/** 배달료(A-1) */
	private BigDecimal deliveryCost;
	/** 추가정산(A-2) */
	private BigDecimal addAccounts;
	/** 운영비(C-2) */
	private BigDecimal operatingCost;
	/** 관리비(B-1) */
	private BigDecimal managementCost;
	/** 운영수수료(B-2) */
	private BigDecimal operatingFee;
	/** 관리비등 부가세(B-3) */
	private BigDecimal etcCost;
	/** 시간제보험료 */
	private BigDecimal timeInsurance;
	/** 사업주부담 고용보험료(1) */
	private BigDecimal ownerEmploymentInsurance;
	/** 라이더부담 고용보험료(2) */
	private BigDecimal riderEmploymentInsurance;
	/** 사업주부담 산재보험료(3) */
	private BigDecimal ownerIndustrialInsurance;
	/** 라이더부담 산재보험료(4) */
	private BigDecimal riderIndustrialInsurance;
	/** 원천징수보험료 합계(1+2+3+4)(D) */
	private BigDecimal withholdingTaxInsuranceSum;
	/** 고용보험 소급정산(E) */
	private BigDecimal employmentInsuranceAccounts;
	/** 산재보험 소급정산(F) */
	private BigDecimal industrialInsuranceAccounts;
	/** G(G) */
	private BigDecimal g;
	/** 정산예정금액:(A+B-C)-시간제보험료-(D+E+F+G) */
	private BigDecimal accountsScheduleCost;
	/** 세금계산서_공급가액 */
	private BigDecimal taxBillSupply;
	/** 세금계산서_부가세액 */
	private BigDecimal taxBillAdd;
	/** 세금계산서_공급대가 */
	private BigDecimal taxBillSum;
	/** 비고 */
	private String note;
	/** 첨부파일ID */
	private String atchFileId;
	private String wekAtchFileId;
	/** 등록일 */
	private String creatDt;
	/** 생성자 ID */
	private String creatId;
	private String lastUpdusrId;
}
