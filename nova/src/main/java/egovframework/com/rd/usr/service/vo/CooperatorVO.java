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
public class CooperatorVO extends Sch implements Serializable {

	private String cooperatorId;
	private String cooperatorNm;
	private String registrationSn;
	private String companyNm;
	private String registrationNm;
	private String ceoNm;
	private String useAt;
	private String creatDt;
	private String creatId;
	private String lastUpdtPnttm;
	private String lastUpdusrId;
	private String gubun;
	private String crud;

	//RD_COOPERATOR_USR
	private String mberId;
	private String userNm;
	private String mbtlnum;//핸드폰번호
	private String ihidnum;//사업자번호
	private String emplyrSttusCode;	//사용여부
	private String password;

	//RD_COOPERATOR_RIDER_CONNECT
	private float fee;
	private String mberNm;
	private String lv;
	private String conId;
//	private String upConId;
	private String regDt;
	private String endDt;
	private String rdcnt;


	//RD_COOPERATOR_FEE
	private String feeId;
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
	//운영사 콜수수료(%)
	private float feeCooperatorCall;
	//프로그램료
	private int feeProgram;

	//세금신고 협력사
	private boolean feeCooperatorAt;

	//RD_RIDER_FEE
	private String riderFeeId;


	private List<CooperatorVO> cooperatorVO;
}
