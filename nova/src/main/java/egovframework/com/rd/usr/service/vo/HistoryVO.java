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
public class HistoryVO extends Sch implements Serializable {

	//일정산 입출금ID
	private String cooperatorId;
	private String dwGubun;
	private String gubun;
	private String id;
	private String sendPrice;
	private String fee;
	private String tranDay;
	private String rvBankNm;
	private String rvAccount;
	private String trAfterBac;
	private String status;
	private String statusNm;
	private String sendDt;
	private String sendTm;
	private String creatDt;
	private String mberNm;
	private String cooperatorNm;
	private String wkpId;
	private String telegramNo;
	private String ioGubun;
	private String ioGubunNm;
	private String dayAtchFileId;
	private String wekAtchFileId;
	private String weekYn;
	private String weekNm;
	private String accountsStDt;
	private String accountsEdDt;
	private String statusCd;
	private String mberId;
	private String fileDate;
	private String errorCode;
	private String errorMessage;
	private String drwAccountCntn;
	private int amount;
	private int dayFee;
	private int sendFee;
	private String nm;
	private String gubunNm;

}

