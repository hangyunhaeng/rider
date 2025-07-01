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
public class WeekRiderInfoVO extends Sch implements Serializable {

	/** 주정산내역 ID */
	private String weekId;
	/** no */
	private String no;
	/** User ID */
	private String mberId;
	/** 라이더명 */
	private String mberNm;
	/** 처리건수 */
	private int cnt;
	/** 배달료A */
	private BigDecimal deliveryCost;
	/** 추가지지급B */
	private BigDecimal addCost;
	/** 총배달료C(A+B */
	private BigDecimal sumCost;
	/** 시간제보험료 */
	private BigDecimal timeInsurance;
	/** 필요경비 */
	private BigDecimal necessaryExpenses;
	/** 보수액 */
	private BigDecimal pay;
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
	/** 사업주부담 고용보험 소급정산(5) */
	private BigDecimal ownerEmploymentInsuranceAccounts;
	/** 라이더부담 고용보험 소급정산(6) */
	private BigDecimal riderEmploymentInsuranceAccounts;
	/** 합계 고용보험 소급정산(E) */
	private BigDecimal sumEmploymentInsuranceAccounts;
	/** 사업주부담 산재보험 소급정산(7) */
	private BigDecimal ownerIndustrialInsuranceAccounts;
	/** 라이더부담 산재보험 소급정산(8) */
	private BigDecimal riderIndustrialInsuranceAccounts;
	/** 합계 산재보험 소급정산(F) */
	private BigDecimal sumIndustrialInsuranceAccounts;
	/** 운영비(9) */
	private BigDecimal operatingCost;
	/** 라이더별정산금액(G):C-(2+4+6+8+9) */
	private BigDecimal accountsCost;
	/** 소득세(H):C*3%) */
	private BigDecimal incomeTax;
	/** 주민세(I):H*10%) */
	private BigDecimal residenceTax;
	/** 원천징수세액(J):(H+I) */
	private BigDecimal withholdingTax;
	/** 라이더별지급금액(K):(G-J) */
	private BigDecimal givePay;
	/** 등록일 */
	private String creatDt;
	/** 생성자 ID */
	private String creatId;
}
