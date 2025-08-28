package egovframework.com.rd.usr.service.vo;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@SuppressWarnings("serial")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@EqualsAndHashCode(callSuper = true)
public class MyInfoVO extends Sch implements Serializable {

	private String mberId;
	private String emplyrId;
	private String mberNm;
	private String mberEmailAdres;
	private String mbtlnum;
	private String password;
	private String befPassword;

	private String bnkCd;
	private String accountNum;
	private String accountNm;
	private String bnkNm;
	private String bnkId;
	private String esntlId;
	private String creatId;
	private String lastUpdusrId;
	private String cooperatorNm;
	private String companyNm;
	private String registrationSn;
	private String ceoNm;

	private float feeAdminstrator;
	private float feeSalesman;
	private String feeId;


	private String cooperatorId;

	//선지급가능금액
	private int dayAblePrice;
	//정산확정지급 가능금액
	private int weekAblePrice;
	//선지급가능금액(잔액테이블입력용)
	private BigDecimal balanceDayAblePrice;
	//정산확정지급 가능금액(잔액테이블입력용)
	private BigDecimal balanceWeekAblePrice;
	private BigDecimal dayMinus;
	//협력사 지급가능금액
	private int coopAblePrice;
	//영업사원 지급가능금액
	private int salesAblePrice;
	private String useAt;
	private String gubun;
	private String authorCode;
	private String authorCodeNm;
}
