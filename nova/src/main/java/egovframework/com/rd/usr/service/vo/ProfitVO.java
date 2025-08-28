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
public class ProfitVO extends Sch implements Serializable {

	//PROFIT_ID
	private String profitId;
	//COO_FIT_ID
	private String coofitId;
	//SALFIT_ID
	private String salfitId;

	//영업사원 id
	private String emplyrId;

	//협력사아이디
	private String cooperatorId;
	//User ID
	private String mberId;
	//수익종류( C:콜수수료, E:기타수수료, D:선지급 출금 수수료)
	private String gubun;
	//수익금액
	private int cost;
	//배달금액
	private int deliveryCost;
	//배달건수
	private int deliveryCnt;
	//배달일
	private String deliveryDay;
	//DYP_ID
	private String dypId;
	//DYP_ID
	private String wkpId;
	//수수료ID
	private String feeId;
	//수수료ID
	private String riderFeeId;
	private String copId;
	// 정산완료
	private String weekYn;
	//등록일
	private String creatDt;
	//생성자 ID
	private String creatId;
	private String mberNm;
	private String cooperatorNm;
	private String gubunNm;
	private String esntlId;


}
