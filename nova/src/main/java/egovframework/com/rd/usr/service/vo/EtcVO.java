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
public class EtcVO extends Sch implements Serializable {

	//ETC_ID
	private String etcId;
	//협력사아이디
	private String cooperatorId;
	//User ID
	private String mberId;
	//수수료 종류(대여:D, 리스,:R 기타:E)
	private String gubun;
	//상환기간(일)
	private int paybackDay;
	//일별상환금액
	private int paybackCost;
	//총대출금액
	private int paybackCostAll;
	//승인요청일
	private String authRequestDt;
	//승인완료일
	private String authResponsDt;
	//라이더승인여부
	private String responsAt;
	//입금완료여부
	private String finishAt;
	//사용여부
	private String useAt;
	//등록일
	private String creatDt;
	//생성자 ID
	private String creatId;
	//최종수정시점
	private String lastUpdtPnttm;
	//최종수정자ID
	private String lastUpdusrId;
	//대출 출금 가능여부(하루한번만 출금하도록 제한)
	private String ableYn;
	//대출 상환 총 금액
	private String finishCost;

	private String mberNm;
	private String cooperatorNm;
	private String day;
	//갚은 대여금
	private String sumEtcCost;

	//그리드 내 유니크 키
	private String uniq;


	private List<EtcVO> etcVO;
}
