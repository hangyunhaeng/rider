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
public class DoszSchAccoutCostVO implements Serializable {

	//이용기관 	API KEY
	private String api_key;
	//이용기관코드
	private String org_code;
	//거래고유번호 :거래일별 Unique 해야 하며1~950000번까지 사용. 이용기관에서 거래번호를 채번.
	private String telegram_no;
	//출금 은행코드
	private String drw_bank_code;
	//출금 계좌번호
	private String drw_account;
	//전문API사용여부
	private String res_all_yn;


	private String creatId;
	private String tranDay;


	//결과
	private String statusCd;
	private String status;
	private String sendDt;
	private String sendTm;
	private String natvTrNo;
	private String trAfterBac;
	private String trAfterSign;
	private String errorCode;
	private String errorMessage;
}
