package egovframework.com.rd.usr.service.vo;

import java.io.Serializable;

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
public class DoszResultVO implements Serializable {

	//이용기관 	API KEY
	private String api_key;
	//이용기관코드
	private String org_code;
	//원거래고유번호
	private String org_telegram_no;
	//원거래일자
	private String tr_dt;
	//전문API사용여부
	private String res_all_yn;


	//이채 결과

	private String tranDay;
	private String telegramNo;
	private String statusCd;
	private String status;
	private String natvTrNo;
	private String amount;

	private String sendDt;
	private String sendTm;
	private String errorCode;
	private String errorMessage;
	private String lastUpdusrId;
}
