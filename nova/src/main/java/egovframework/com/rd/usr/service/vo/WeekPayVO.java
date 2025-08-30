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
public class WeekPayVO extends Sch implements Serializable {

	//주정산 입출금ID
	private String wkpId;

	private String cooperatorId;
	//회원ID
	private String mberId;
	//ESNTL_ID
	private String esntlId;
	//업무구분
	private String dwGubun;
	//입출금구분: 1: 입금, 2: 출금
	private String ioGubun;
	//출금가능금액
	private BigDecimal ablePrice;
	//출금가능금액
	private BigDecimal tmpAblePrice;
	//수수료
	private int fee;
	//출금액
	private BigDecimal sendPrice;
	//잔액
	private int balance;
	//정산시작일
	private String accountsStDt;
	//정산종료일
	private String accountsEdDt;
	//일정산 입출금ID
	private String dypId;
	//주정산첨부파일ID
	private String atchFileId;
	//주정산내역 ID
	private String weekId;
	//송금일자
	private String tranDay;
	//거래고유번호
	private String telegramNo;
	//etcId
	private String etcId;
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
	// 총배달배
	private BigDecimal sumCost;
	private int cnt;
	// 선지급수수료
	private BigDecimal dayFeeCost;
	// 이체수수료
	private BigDecimal sendFeeCost;
	// 선지급금
	private BigDecimal sendPriceCost;
	// 기타수수료
	private BigDecimal etcPriceCost;
	// 콜수수료
	private BigDecimal callFeeCost;
	// 프로그램료
	private BigDecimal programFeeCost;
	//확정금액
	private BigDecimal givePay;
}
