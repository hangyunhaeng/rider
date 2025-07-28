package egovframework.com.rd.usr.service.vo;

import java.io.Serializable;
import java.util.List;

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
public class CooperatorFeeVO extends Sch implements Serializable {

	private String feeId;
	private String cooperatorId;
//	private String feeType;

	//운영사선지급수수료(%)
	private float feeAdminstrator;
	//협력사선지급수수료(%)
	private float feeCooperator;
	//고용보험(%)
	private float feeEmploymentInsurance;
	//산재보험(%)
	private float feeIndustrialInsurance;
	//원천세(%)
	private float feeWithholdingTax;
	//시간제보험(원)
	private int feeTimeInsurance;
	//콜수수료(원)
	private int feeCall;
	//콜수수료(원)
	private float feeCooperatorCall;
	//프로그램료(원)
	private int feeProgram;

//	private String startDt;
//	private String endDt;
	private String useAt;
	private String creatDt;
	private String creatId;
	private String lastUpdtPnttm;
	private String lastUpdusrId ;






	private List<CooperatorFeeVO> cooperatorFeeVO;
}
