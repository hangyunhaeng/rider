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
public class DoszTransferVO implements Serializable {

	//이용기관 	API KEY
	private String api_key;
	//이용기관코드
	private String org_code;
	//모은행코드
//	private String drw_bank_code;
	//거래고유번호 :거래일별 Unique 해야 하며1~950000번까지 사용. 이용기관에서 거래번호를 채번.
	private String telegram_no;
	//모계좌번호
//	private String drw_account;
	//모계좌적요
	private String drw_account_cntn;
	//입금은행코드
	private String rv_bank_code;
	//입금계좌번호
	private String rv_account;
	//입금계좌적요
	private String rv_account_cntn;
	//거래금액
	private String amount;
	//복기부호
//	private String sign_no;
	//전송일자
//	private String tr_dt;
	//전송시간
//	private String tr_tm;
	//전문API사용여부
	private String res_all_yn;


	private String creatId;
	private String tranDay;


	//이채 결과
	private String statusCd;
	private String status;
	private String sendDt;
	private String sendTm;
	private String natvTrNo;

	private String errorCode;
	private String errorMessage;
	private String lastUpdusrId;
}
