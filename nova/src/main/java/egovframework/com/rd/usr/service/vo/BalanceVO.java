package egovframework.com.rd.usr.service.vo;

import java.io.Serializable;
import java.util.List;

import com.ibm.icu.math.BigDecimal;

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
public class BalanceVO extends Sch implements Serializable {

	private String mberId;
	private int balance;
	private int cost;
	private String lastUpdtPnttm;
	private String lastUpdusrId ;

	private String rn;

}
