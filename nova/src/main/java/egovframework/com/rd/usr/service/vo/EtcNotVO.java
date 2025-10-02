package egovframework.com.rd.usr.service.vo;

import java.io.Serializable;
import java.math.BigDecimal;
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
public class EtcNotVO extends Sch implements Serializable {
	//NO_ETC_ID
	private String etcNotId;
	//ETC_ID
	private String etcId;
	//협력사아이디
	private String cooperatorId;
	//User ID
	private String mberId;
	//일자
	private String day;
	//선지급잔액
	private BigDecimal balance0;
	//확정잔액
	private BigDecimal balance1;
	//메세지
	private String msg;
	//사용여부
	private String useAt;
	//최종수정자ID
	private String creatId;
	//최종수정시점
	private String creatDt;
}
