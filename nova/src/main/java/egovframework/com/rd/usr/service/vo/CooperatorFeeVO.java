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
public class CooperatorFeeVO extends Sch implements Serializable {

	private String feeId;
	private String cooperatorId;
	private String feeType;
	private float fee;
	private String startDt;
	private String endDt;
	private String useAt;
	private String creatDt;
	private String creatId;
	private String lastUpdtPnttm;
	private String lastUpdusrId ;


	private List<CooperatorFeeVO> cooperatorFeeVO;
}
