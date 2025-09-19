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
public class StsVO extends Sch implements Serializable {

	private String cooperatorId;
	private String mberId;
	private String mberNm;

	private String cooperatorNm;
	private String day;
	private int deliveryCnt;
	private BigDecimal deliveryPrice;
	private BigDecimal costCOper;
	private BigDecimal costCCoop;
	private BigDecimal costPOper;
	private BigDecimal costPSale;

}
