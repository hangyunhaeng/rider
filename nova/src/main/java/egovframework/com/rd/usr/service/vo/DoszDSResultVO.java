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
public class DoszDSResultVO extends Sch implements Serializable {

	//이용기관 	API KEY
	private String api_key;
	//이용기관코드
	private String org_code;
	//원거래일자
	private String tr_dt;
	//전문API사용여부
	private String res_all_yn;


	//결과
	private String Status;
	private String dsDt;
	private String dsTm;
	private String paymentSuccCnt;
	private String paymentSuccAmount;
	private String paymentFailCnt;
	private String paymentFailAmount;
	private String depositorSuccCnt;
	private String depositorTimeCnt;
	private String depositorFailCnt;
	private String daonSuccCnt;
	private String daonSuccAmount;
	private String daonFailCnt;
	private String daonFailAmount;
	private String creatDt;


}
