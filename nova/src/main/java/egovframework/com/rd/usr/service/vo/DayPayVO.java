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
public class DayPayVO extends Sch implements Serializable {

	//일정산 입출금ID
	private String dypId;

	private String cooperatorId;
	//회원ID
	private String mberId;
	//날짜
	private String day;
	//입출금구분
	private String ioGubun;
	//배달처리비
	private int deliveryPrice;
	//선지급수수료
	private int dayFee;
	//보험료
	private int insurance;
	//이체수수료
	private int sendFee;
	//출금가능금액
	private int ablePrice;
	//출금액
	private int sendPrice;
	//정산완료구분
	private String weekYn;
	//일정산첨부파일ID
	private String dayAtchFileId;
	//주정산첨부파일ID
	private String wekAtchFileId;
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
	private String mberNm;
	//시간제보험 최대 금액(7,000)
	private int timeInsuranceMaxFee;
	//콜수수료(원)
	private int feeCallCost;
	//배달건수
	private int DeliveryCnt;
	//수수료ID
	private String feeId;
	//수수료ID
	private String riderFeeId;
	//협력사 콜수수료
	private int feeCooperatorCallCost;

	//협력사 선지급 수수료
	private int feeCooperatorCost;

	//라인수
	private int rnum;
	//입력된 출금요청액
	private int inputPrice;

	private float feeAdminstrator;
	private String dwGubun;
}
