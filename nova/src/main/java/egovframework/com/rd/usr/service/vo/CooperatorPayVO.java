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
@EqualsAndHashCode(callSuper = true)
public class CooperatorPayVO extends Sch implements Serializable {

	//출금ID
	private String copId;

	private String cooperatorId;
	//이체수수료
	private int sendFee;
	//출금액
	private int sendPrice;
	//잔액
	private int balance;
	//송금일자
	private String tranDay;
	//거래고유번호
	private String telegramNo;
	//사용여부
	private String useAt;
	//생성시점
	private String creatDt;
	//생성자 ID
	private String creatId;
	//최종수정시점
	private String lastUpdtPnttm;
	//최종수정자ID
	private String lastUpdusrId;

	//입력된 출금요청액
	private int inputPrice;


	private String cooperatorNm;

	private String statusNm;
	private String rvAccount;
	private String rvBankNm;
	private String status;
	private String statusCd;
	private String errorCode;
	private String sendDt;
	private String sendTm;
	private String errorMessage;
}
